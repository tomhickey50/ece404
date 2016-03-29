#!/bin/sh

#Create a new user-defined chain and delete any previously user-defined chains
iptables -t filter -N hw9.rules

#Block specific ip addresses
iptables -A hw9.rules -s 10.0.0.4 -j DROP
iptables -A hw9.rules -s 10.0.0.8 -j DROP

#Block computer from being pinged by all other hosts
iptables -A hw9.rules -p icmp --icmp-type 8 -j DROP

#Accept tcp packets on port 855
iptables -A hw9.rules -p tcp --dport 8855 -j ACCEPT

#Port forward open port to port 22
iptables -t nat -A PREROUTING -p tcp --dport 8855 -j REDIRECT --to-port 22

#Only allow ssh connection from ecn.purdue.edu
iptables -A hw9.rules -p tcp -s ecn.purdue.edu --dport 22 -j ACCEPT

#Only allow one HTTPD connection
iptables -A hw9.rules -p tcp -s 10.0.0.5 -j ACCEPT

#Permit port 113
iptables -A hw9.rules -p tcp -m tcp --syn --dport 113 -j ACCEPT

iptables -I INPUT -j hw9.rules
iptalbes -I FORWARD -j hw9.rules
