Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYIENrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYIENrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYIENrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:47:24 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:54524 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYIENrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:47:23 -0400
Message-ID: <48C13869.9040603@weinigel.se>
Date: Fri, 05 Sep 2008 15:47:21 +0200
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Proposed SDIO layer rework
References: <48C11BF3.2060609@weinigel.se> <20080905131855.GY26082@trinity.fluff.org>
In-Reply-To: <20080905131855.GY26082@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:
>> Most of the CPU is probably spent doing PIO transfers to the SDIO 
>> controller, if DMA starts working in the s3cmci driver, the CPU load 
>> difference will be even larger.
> 
> I'm not sure if I'll get the time to look at this before the new kernel
> is released... anyway DMA may not be much of a win for smaller transfers
> anyway, since the setup (the cache will need to be cleaned out or the
> transfer memory made unbuffered)  and complete time will add another
> IRQ's worth of response time. This means small transfers are probably
> better off using PIO.

Yes.  For the DMA-capable S3C SPI driver I wrote, I added some 
thresholds, so for smaller transfers than a certain number of bytes, I 
skip DMA and just do a polled/interrupt transfer instead.  For short 
transfers at high clock rates it's not even worth getting an interrupt 
per byte, it's better to just busy wait for each byte, since the 
interrupt overhead is larger than the time between each byte.

A SDIO CMD/response packet is 48 bits, so at 25 MHz that is only about 4 
us and I think the interrupt overhead is more than that.  So if we 
really want to squeeze every last clock cycle out of the SDIO driver it 
may be better to busy wait for the end of simple CMD52s instead of using 
the an interrupt to complete the transfer.

I'll clean up my s3cmci patches and send them to you, but I can't 
promise when I'll be done, so it'll probably have to wait for the next 
kernel release.

   /Christer
