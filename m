Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbYB2Uz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbYB2Uz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbYB2Uzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:55:43 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:33379 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243AbYB2Uzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:55:42 -0500
Message-ID: <47C870FD.4000808@razik.name>
Date: Fri, 29 Feb 2008 21:54:21 +0100
From: Lukas Razik <linux@razik.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417 FreeBSD/i386
X-Accept-Language: de-de, en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Ethernet over Kernel Sockets
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18+1i70l++BMvgPDuMo4EwryrfK0Bvksb6VIChc
	zIWVw3Y4IbJ4MgJxVLra9fAXD7FDu8T/EPN0/zCwr9pWm8PD3G
	Vr3qmEeco=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all!

As you know, some network cards doesn't have a 'eth' interface under linux.
Because of that I'm developing a net_device based driver which doesn't 
transmit and receive directly through a real network card but through 
UDP kernel sockets.
That means:
If my net_device->hard_start_xmit function gets an packet to transmit 
(in interrupt context), there will be a work struct queued into a 
workqueue and the packet will be processed by the workqueue later on (in 
process context).
On the receiver side I have a kernel thread which blocks on 
sock_recvmsg() and if there comes a UDP message, then it will be 
processed and a sk_buff will be passed to the kernel.
The current state is that all works stable but I've bad transmission 
rates and bad ping times.

For example I've to systems and each has one Gigabit-Ethernet card:
System 1: ifconfig eth0 192.168.0.1
System 2: ifconfig eth0 192.168.0.2

If I load my driver then I get an additional eth interface (for example):
System 1: ifconfig eth1 192.168.1.1
System 2: ifconfig eth1 192.168.1.2

So the eth1 interfaces are based on sockets which use the eth0 (Gigabit) 
interfaces for the communication.
Now, if I measure the transmission between 192.168.0.1 and 192.168.0.2 
then I get transmission rates that are normal for Gigabit-Ethernet 
(~25µsec (PingPong) and ~900Mbit/s).
If I measure the transmission through the eth1 interfaces between 
192.168.1.1 and 192.168.1.2 then I only get ~1msec (PingPong) and only 
about ~400Mbit/s.

The interesting thing is, that I always get PingPongs of 1ms (= one 
jiffie). Although if I measure with 100MBit- or other non-Ethernet cards.
Maybe it's because I run the socket_recvmsg() function in a kernel 
thread which blocks on the function and must wait to be executed by the 
scheduler.

Now I don't know how I could solve this problem:
How can I force the kernel to process a received message immediately 
when it comes in through an UDP kernel socket?

I hope that someone of you can help me....
The source code you can find here:
http://net.razik.de/ethos.tar.gz

Regards and Many Thanks for any help!
Lukas
