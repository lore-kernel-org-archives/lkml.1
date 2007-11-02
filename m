Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXKBH0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXKBH0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 03:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbXKBH0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 03:26:10 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:46481 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbXKBH0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 03:26:08 -0400
Message-ID: <472AD0AE.50106@cosmosbay.com>
Date: Fri, 02 Nov 2007 08:24:30 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Felix von Leitner <felix-linuxkernel@fefe.de>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: TCP_DEFER_ACCEPT issues
References: <20071102013321.GA30893@codeblau.de>
In-Reply-To: <20071102013321.GA30893@codeblau.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 02 Nov 2007 08:24:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Felix von Leitner a écrit :
> I am trying to use TCP_DEFER_ACCEPT in my web server.
> 
> There are some operational problems.  First of all: timeout handling.  I
> would like to be able to set a timeout in seconds (or better:
> milliseconds) for how long the socket is allowed to sit there without
> data coming in.  For high load situations, I have been enforcing
> timeouts in the range of 15 seconds, otherwise someone can DoS the
> server by opening a lot of connections and tying up data structures.
> 
> It is still possible, of course, to tie up kernel memory this way, by
> not reacting to the FIN or RST packets and running into a timeout there,
> too, but that is partially tunable via sysctl.
> 
> According to tcp(7) the int argument to TCP_DEFER_ACCEPT is in seconds.
> In the kernel code, it's converted to TCP timeout units.  When I ran my
> server, and connected without sending any data, nothing happened.  No
> timeout.  Minutes later, the connection was still there.  Even worse:
> when I killed (!) the server process (thus closing the server socket),
> the client did not get a reset.  Only when I type something in the
> telnet, I get a reset.  This appears to be very broken.
> 
> My suggestion:
> 
>   1. make the argument to the setsockopt be in seconds, or milliseconds.
>   2. if the server socket is closed, reset all pending connections.
> 
> Comments?
> 

I agree TCP_DEFER_ACCEPT is not worth it at the current time, if you take into 
account the bad guys, or very slow networks.

1) Setting a timeout in a millisecond range (< 1000) is not very good because 
some clients may need much more time to send your server the data (very long 
distance). So a second granularity is OK.

2) After timeout is elapsed, the server tcp stack has no socket associated to 
your client attempt. So closing the server listening socket wont be able to 
send RST. I agree a RST *should* be sent by the server once the timeout is 
triggered.

A typical tcpdump of what is happening for a tcp_defer_accept timeout of 20 
seconds is :

[1]08:52:47.480291 IP client.60930 > server.http: S 2498995442:2498995442(0) 
win 5840 <mss 1460,sackOK,timestamp 2685904595 0,nop,wscale 2>
[2]08:52:47.480302 IP server.http > client.60930: S 1173302644:1173302644(0) 
ack 2498995443 win 5840 <mss 1460>
[3]08:52:47.481669 IP client.60930 > server.http: . ack 1 win 5840

[4]08:52:50.757543 IP server.http > client.60930: S 1173302644:1173302644(0) 
ack 2498995443 win 5840 <mss 1460>
[5]08:52:50.758953 IP client.60930 > server.http: . ack 1 win 5840

[6]08:52:56.760611 IP server.http > client.60930: S 1173302644:1173302644(0) 
ack 2498995443 win 5840 <mss 1460>
[7]08:52:56.761886 IP client.60930 > server.http: . ack 1 win 5840

[8]08:53:08.771254 IP server.http > client.60930: S 1173302644:1173302644(0) 
ack 2498995443 win 5840 <mss 1460>
[9]08:53:08.772514 IP client.60930 > server.http: . ack 1 win 5840

[10]08:53:32.782488 IP server.http > client.60930: S 1173302644:1173302644(0) 
ack 2498995443 win 5840 <mss 1460>
[11]08:53:32.783754 IP client.60930 > server.http: . ack 1 win 5840

<a very long time, then client finally sends 2 bytes>

[12]08:59:30.509097 IP client.60930 > server.http: P 1:3(2) ack 1 win 5840
[13]08:59:30.509125 IP server.http > client.60930: R 1173302645:1173302645(0) 
win 0


So TCP_DEFER_ACCEPT might send way more packets than needed. Packets 4,6,8,10 
(and their corresponding acks 5,7,9,11) seem un-necessary, since (1,2,3) has 
engaged a normal TCP session (three way handshake).

We only should wait for the data coming from the client to be able to pass the 
new socket to the listening application.


