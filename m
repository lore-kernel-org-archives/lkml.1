Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYKSW63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYKSW63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYKSW6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:58:18 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:34045 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbYKSW6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:58:17 -0500
Date: Wed, 19 Nov 2008 23:58:12 +0100 (CET)
From: Jesper Dangaard Brouer <hawk@diku.dk>
To: David Miller <davem@davemloft.net>
Cc: Jesper Dangaard Brouer <jdb@comx.dk>, netdev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NIU driver: Sun x8 Express Quad Gigabit Ethernet Adapter (perf
 + regression IRQs)
In-Reply-To: <20081113.141513.116537651.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0811192333130.30818@ask.diku.dk>
References: <20081112.035240.226243372.davem@davemloft.net>
 <20081112.041143.11487260.davem@davemloft.net> <1226572171.6834.87.camel@localhost.localdomain>
 <20081113.141513.116537651.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Nov 2008, David Miller wrote:

> From: Jesper Dangaard Brouer <jdb@comx.dk>
> Date: Thu, 13 Nov 2008 11:29:31 +0100
>
>> Although I'm not happy about the new perf numbers, as I now on a SMP
>> system only can route approx 290 kpps, remember I could route 319 kpps
>> using a single CPU nosmp kernel.
>
> That unfortunately (can be) the cost of SMP :-/

[Regression]

Well that was not the real cause of the performance loss.  Because on 
kernel 2.6.27 I get really good performance (900-1200kpps) compared to 
2.6.28 (git net-2.6).

The cause of this problem (tracked down together with Robert Olsson) is 
that on 2.6.28 I have a lot less IRQs available.  It seems max 34 IRQs.

Due the reduced number of IRQs the NIU driver cannot get enough IRQs to 
the interfaces, and starts to use "IO-APIC" based IRQs.

On kernel 2.6.28:

  My eth2 is using 10 IRQs all "PCI-MSI-edge".

  BUT my eth3 is using a single IRQ using "IO-APIC-fasteoi" and shared
  with the usb driver...

Think thats must be my performance problem on 2.6.28.


> With multi-flow tests, Robert Olsson is getting 4.2 mpps rates with
> NIU and pktgen.  That's what this card is designed for, good
> multi-flow workload performance, rather than striving for maximum
> single-flow performance.

[Packet performance]

Yes, I know, I do use pktgen and multi-flows (rand dest IP+port).

For the two drivers NIU and Suns NXGE, my packet per sec performance is 
now, on 2.6.27 (with backported NIU fixes).

   With NIU driver I can route 900 kpps.

   With NXGE driver (and enqueue=NULL hack) I can route 1200 kpps.

Actually I think I can go higher, because I'm limited by my packet rate 
generator. I use pktgen (with rand dst IP+port) and can only generate 1200 
kpps.

(I have actually ordered some new hardware, so I can get a faster pktgen 
machine and perhaps test it as a router too.  Also ordered the hardware 
because I want to test PCI-express v.2.0. I have a prototype 12-port 
gigabit NIC (from hotlava systems) that support PCIe v.2.0 and has 6x 
82575 chips (4RX/4TX queues))


Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
