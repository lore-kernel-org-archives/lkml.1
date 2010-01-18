Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029Ab0ARVYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0ARVYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755Ab0ARVYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:24:41 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:34496 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0ARVYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:24:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=RKynZZ9Ruk7W7SyC5Y/mCpguhw4jte7G6IzdwF/2JlA9+lmmqQ0x3HwjJJF0XDQ7Mb
         BlzdubWKKViWItbyIt1P6QyoP04NwIn181CRj1RWCLsqliSEUi7qhPOak2E5SR1sjtKg
         ypCJY07oxRdqDezKHkzQHe5SgIk6tTLHSkFAE=
Message-ID: <4B54D192.5050503@gmail.com>
Date: Mon, 18 Jan 2010 13:24:34 -0800
From: Dyadya Skrudzh <gorshkov@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Policy-routing of locally originated traffic?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Short version: Is it possible?

Long question: read on!

I'm trying to do some weird thing, here. There's dynamips running on my 
F11 box
(kernel 2.6.30.10-105.fc11.i586) emulating Cisco 7200 router with two 
FastEthernets.

Interfaces are connected as:

f0/0 is attached to tap10 on Linux
f0/1 is attached to tap20 on Linux

IP addresses are:

tap10: 10.10.0.1/16
f0/0: 10.10.0.2/16
f0/1: 10.20.0.2/16
tap20: 10.20.0.1/16

Policy routing configured as:

[root@lab ~]# ip rule
0:      from all lookup local
32764:  from 10.20.0.1 to 10.10.0.0/16 lookup tap20
32765:  from 10.10.0.1 to 10.20.0.0/16 lookup tap10
32766:  from all lookup main
32767:  from all lookup default

[root@lab ~]# ip route show table tap10
default via 10.10.0.2 dev tap10

[root@lab ~]# ip route show table tap20
default via 10.20.0.2 dev tap20

Interfaces, Linux:

[root@lab ~]# ip addr show dev tap10
7: tap10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast 
state UNKNOWN qlen 500
    link/ether 00:50:56:a7:5d:07 brd ff:ff:ff:ff:ff:ff
    inet 10.10.0.1/16 brd 10.10.255.255 scope global tap10
    inet6 fe80::250:56ff:fea7:5d07/64 scope link
       valid_lft forever preferred_lft forever

[root@lab ~]# ip addr show dev tap20
8: tap20: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast 
state UNKNOWN qlen 500
    link/ether 00:50:56:b7:5b:b2 brd ff:ff:ff:ff:ff:ff
    inet 10.20.0.1/16 brd 10.20.255.255 scope global tap20
    inet6 fe80::250:56ff:feb7:5bb2/64 scope link
       valid_lft forever preferred_lft forever

Interfaces, Cisco:

interface FastEthernet0/0
 ip address 10.10.0.2 255.255.0.0
 no ip proxy-arp
!
interface FastEthernet0/1
 ip address 10.20.0.2 255.255.0.0
 no ip proxy-arp

Here's the results I got:

[ next hop, OK ]

[root@lab ~]# ip route flush cache ; ping -c 3 -I 10.10.0.1 10.10.0.2 ; 
ip route show cache
PING 10.10.0.2 (10.10.0.2) from 10.10.0.1 : 56(84) bytes of data.
64 bytes from 10.10.0.2: icmp_seq=1 ttl=255 time=2.50 ms
64 bytes from 10.10.0.2: icmp_seq=2 ttl=255 time=1.89 ms
64 bytes from 10.10.0.2: icmp_seq=3 ttl=255 time=2.06 ms

--- 10.10.0.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 1.892/2.152/2.505/0.264 ms
10.10.0.2 from 10.10.0.1 dev tap10
    cache  mtu 1500 advmss 1460 hoplimit 64
local 10.10.0.1 from 10.10.0.2 dev lo  src 10.10.0.1
    cache <local,src-direct>  iif tap10

[ another interface on Cisco, OK ]

[root@lab ~]# ip route flush cache ; ping -c 3 -I 10.10.0.1 10.20.0.2 ; 
ip route show cache
PING 10.20.0.2 (10.20.0.2) from 10.10.0.1 : 56(84) bytes of data.
64 bytes from 10.20.0.2: icmp_seq=1 ttl=255 time=2.92 ms
64 bytes from 10.20.0.2: icmp_seq=2 ttl=255 time=2.05 ms
64 bytes from 10.20.0.2: icmp_seq=3 ttl=255 time=2.05 ms

--- 10.20.0.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 2.057/2.348/2.928/0.410 ms
10.20.0.2 from 10.10.0.1 via 10.10.0.2 dev tap10
    cache  mtu 1500 advmss 1460 hoplimit 64
local 10.10.0.1 from 10.20.0.2 dev lo  src 10.10.0.1
    cache <local>  iif tap10

[ tap10 -> tap20 interface through Cisco. Does not work; ping is OK but 
route is local ]

[root@lab ~]# ip route flush cache ; ping -c 3 -I 10.10.0.1 10.20.0.1 ; 
ip route show cache
PING 10.20.0.1 (10.20.0.1) from 10.10.0.1 : 56(84) bytes of data.
64 bytes from 10.20.0.1: icmp_seq=1 ttl=64 time=0.052 ms
64 bytes from 10.20.0.1: icmp_seq=2 ttl=64 time=0.022 ms
64 bytes from 10.20.0.1: icmp_seq=3 ttl=64 time=0.021 ms

--- 10.20.0.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.021/0.031/0.052/0.015 ms
local 10.20.0.1 from 10.10.0.1 dev lo
    cache <local>  mtu 16436 advmss 16396 hoplimit 64
local 10.10.0.1 from 10.20.0.1 dev lo
    cache <local>  ipid 0xe686 mtu 16436 advmss 16396 hoplimit 64

Is there any way I can make it work?

Thank you,
DS
