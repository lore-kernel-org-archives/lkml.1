Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143Ab0A0D5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0A0D5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 22:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477Ab0A0D5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 22:57:14 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:61312 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0A0D5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 22:57:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Mgg9BWFlXFS/8yLRu0bfFTlPBqiuRwmYGGEXyVQjSEfJKMwFW2GQk43z1T6SMdOHkY
         UnSlV5rjGPcGoCe/Umg/9DBNJ1Eh9NpIN5qnirPfXM5L+k9r8PhXoTW80gbzL0qhRPuG
         2KFRNhBbMPGCPaSYYjOkVjv26+uXc882tLcko=
Subject: Re: Problems Receiving UDP Broadcasts on Some Versions of Linux
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Curt Sampson <cjs@starling-software.com>
Cc: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
In-Reply-To: <20100127003744.GA16322@analytic.cynic.net>
References: <20100125072749.GG21419@analytic.cynic.net>
	 <4B5D51E6.5090601@gmail.com>  <20100127003744.GA16322@analytic.cynic.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 04:56:05 +0100
Message-ID: <1264564565.2810.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 janvier 2010 à 09:37 +0900, Curt Sampson a écrit :
> On 2010-01-25 09:10 +0100 (Mon), Eric Dumazet wrote:
> 
> > > The short summary is that on two very similar servers on the same
> > > network, an application that listens for broadcast UDP packets on a
> > > given port works fine on the Ubuntu 8.04/Linux 2.6.24-26-server box but
> > > does not receive the packets on the Ubuntu 9.04/Linux 2.6.28-17-server
> > > box.
> >
> > Could you post a sample of tcpdump trafic you receive on the 9.04
> > host, and your network config ? "ifconfig -a"
> 
> I've added both to the end of the StackOverflow entry:
> 
>   http://stackoverflow.com/questions/2130563/udp-broadcast-reception-problems-with-ubuntu-9-04-but-not-8-04
> 
> Again, please cc me on any responses; I'm on neither the linux-kernel
> nor netdev lists.
> 
> cjs

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1362 qdisc pfifo_fast state UP qlen 1000
    link/ether 00:30:48:d9:38:da brd ff:ff:ff:ff:ff:ff
3: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 00:1b:21:36:19:fd brd ff:ff:ff:ff:ff:ff
4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 100
    link/ether 00:30:48:d9:38:db brd ff:ff:ff:ff:ff:ff
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1362 qdisc pfifo_fast state UP qlen 1000
    link/ether 00:30:48:d9:38:da brd ff:ff:ff:ff:ff:ff
    inet 192.168.228.132/28 brd 192.168.228.143 scope global eth0
    inet6 fe80::230:48ff:fed9:38da/64 scope link 
       valid_lft forever preferred_lft forever
3: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 00:1b:21:36:19:fd brd ff:ff:ff:ff:ff:ff
4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 100
    link/ether 00:30:48:d9:38:db brd ff:ff:ff:ff:ff:ff
    inet 172.40.4.132/24 brd 172.40.4.255 scope global eth1
    inet6 fe80::230:48ff:fed9:38db/64 scope link 
       valid_lft forever preferred_lft forever

And you receive a frame on eth1 with src ip address = 192.166.1.120

I suspect your kernel drops this frame because of asymetric routing

Check "ip route get 192.166.1.120" and if answer is directed to another interface,
this may explain the problem.

Solution : tweak rp_filter settings.

Documentation/networking/ip-sysctl.txt

rp_filter - INTEGER
        0 - No source validation.
        1 - Strict mode as defined in RFC3704 Strict Reverse Path
            Each incoming packet is tested against the FIB and if the
interface
            is not the best reverse path the packet check will fail.
            By default failed packets are discarded.
        2 - Loose mode as defined in RFC3704 Loose Reverse Path
            Each incoming packet's source address is also tested against
the FIB
            and if the source address is not reachable via any interface
            the packet check will fail.

        Current recommended practice in RFC3704 is to enable strict mode
        to prevent IP spoofing from DDos attacks. If using asymmetric
routing
        or other complicated routing, then loose mode is recommended.

        The max value from conf/{all,interface}/rp_filter is used
        when doing source validation on the {interface}.

        Default value is 0. Note that some distributions enable it
        in startup scripts.


I suspect Ubuntu 9.04 enables rp_filter (set to one)

(note 2 value (loose mode) might be not available yet on 2.6.28 kernels)

Check/change /etc/sysctl.conf settings


