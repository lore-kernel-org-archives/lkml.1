Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYBPGBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYBPGBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 01:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757661AbYBPGAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 01:00:49 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52269 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbYBPGAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 01:00:47 -0500
Date: Sat, 16 Feb 2008 00:00:38 -0600
From: Robert Hancock <rwh461@mail.usask.ca>
Subject: Re: PCI Bursting with PIO
In-reply-to: <fa.Mbzb1/2dWnp5V/5ElzijlkAstZU@ifi.uio.no>
To: Dan Gora <dan.gora@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <47B67C06.6060706@mail.usask.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Mbzb1/2dWnp5V/5ElzijlkAstZU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Gora wrote:
> Hi,
> 
> I am trying to optimize a driver for a slave only PCI device and am
> having a lot of trouble getting any kind of PCI burst transactions in
> either the read or the write direction.  Using bcopy/memcpy or even a
> hand-crafted while (len) { *pdst++ = *psrc++} (with pdst and psrc
> unsigned long*) I can only get writes to burst and even in that case
> only for 2 data phases (8 bytes) and only on 64 bit machines.  The
> best that I have managed is to use a hand crafted asm function which
> copies the data through mmx registers on i386 machines, but that still
> only bursts a maximum of 16 bytes in the write direction and not at
> all in the read direction.  The source and destination pointers are
> both aligned to 8 byte boundaries, so I don't think that it's an
> alignment issue.

The chipset is being limited by what the CPU is giving it. If the CPU 
sends only a small amount of data in one access then the chipset usually 
does not try to burst more than that.

> 
> Is there any way to get PIO to burst over the PCI bus in the read and
> write direction?  My device has 4 BAR registers, but the area where I
> am transferring data is marked 'prefetchable' (although the others are
> not).  I read here: http://lkml.org/lkml/2004/9/23/393 that this was a
> prerequisite, but it is apparently not sufficient.  He also mentioned
> that the area had to be marked as write-back, but it's not clear how
> you can tell (no /proc/mtrr doesn't tell you) or that it has anything
> to do with bursting reads.
> 
> Any ideas would be really appreciated,

Well, in order for the CPU to batch up more writes you'd have to map the 
  BAR as either write-combining or write-back. If it's not listed in 
/proc/mtrr it will be the default setting of uncacheable. X has code to 
set up the video memory on the video card as write-combining so it can 
get better write performance, you could do something similar.

Setting it as write-back might allow you to get the reads to do bursting 
  as well (since the CPU will do a cache-line fill instead of individual 
accesses) but this if the device is modifying this memory area, unless 
you add code to invalidate those cache lines before reading the data 
you'll get stale data back. You could run into some other less obvious 
issues as well, as normally device memory regions are not mapped write-back.

In general, especially if you need to read data back from the device, 
implementing a DMA engine would be by far the better option. Most 
chipsets seem not at all optimized for handling sequential reads from 
PCI memory from the CPU. (Even in the DMA case, you have to be careful 
with what type of memory read transaction you use when transferring from 
host memory - some chipsets don't like to burst more than one cycle if 
you use normal Memory Read instead of Memory Read Line or Memory Read 
Multiple.)
