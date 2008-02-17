Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYBQTGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYBQTGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYBQTGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:06:41 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32060 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYBQTGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:06:40 -0500
Date: Sun, 17 Feb 2008 13:06:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI Bursting with PIO
In-reply-to: <fa.kFanAY/O5VMnSf6YXqEyxmsR62U@ifi.uio.no>
To: Dan Gora <dan.gora@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <47B885BC.70902@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.QF1nJvJhMpLvtquNDa6sbADHwhs@ifi.uio.no>
 <fa.LrKLA2l3F3abMpHk4aDjFfwzFVI@ifi.uio.no>
 <fa.kFanAY/O5VMnSf6YXqEyxmsR62U@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Gora wrote:
> On Feb 15, 2008 10:00 PM, Robert Hancock <rwh461@mail.usask.ca> wrote:
>> Well, in order for the CPU to batch up more writes you'd have to map the
>>   BAR as either write-combining or write-back. If it's not listed in
>> /proc/mtrr it will be the default setting of uncacheable.
> 
> Ok, this is pretty much what I thought, but I still don't really have
> any idea how to do this.  ioremap() doesn't take any flags and I'm not
> using ioremap_uncacheable(), plus the BAR is marked prefetchable...

Likely easiest to do it from userspace by writing into /proc/mtrr to 
change the memory type attributes. Have a look at Documentation/mtrr.txt.

> 
>> X has code to
>> set up the video memory on the video card as write-combining so it can
>> get better write performance, you could do something similar.
> 
> Alan mentioned this as well, but I haven't tried to hunt this code
> yet.  If you have any pointers as to where I might find this, I would
> appreciate it.
> 
>> Setting it as write-back might allow you to get the reads to do bursting
>> as well (since the CPU will do a cache-line fill instead of individual
>> accesses)
> 
> I don't see what the cache write policy has to do with the reads.  If
> the region is marked cacheable, then all reads should try and read a
> cache line, right?  The write-back or write-through policy only has to
> do with the writes.  If it's write through then writes go directly to
> RAM, if it's write-back then they hit the cache and are flushed when
> the  line is flushed (LRU replacement, explicit cache line flush,
> etc..), right?

That caching attribute affects reads as well. If it's marked uncacheable 
or write-combining then reads will never be cached, only if it's marked 
write-back.

> 
>> but this if the device is modifying this memory area, unless
>> you add code to invalidate those cache lines before reading the data
>> you'll get stale data back.
> 
> Yeah this could definitely be tricky, would pci_dma_sync suffice for this?

No, that's not meant to handle this case of stale data in the CPU's 
cache since that doesn't normally happen. Something like clflush or 
wbinvd would do it, those being x86 specific of course..

> 
>> You could run into some other less obvious
>> issues as well, as normally device memory regions are not mapped write-back.
>>
>> In general, especially if you need to read data back from the device,
>> implementing a DMA engine would be by far the better option. Most
>> chipsets seem not at all optimized for handling sequential reads from
>> PCI memory from the CPU. (Even in the DMA case, you have to be careful
>> with what type of memory read transaction you use when transferring from
>> host memory - some chipsets don't like to burst more than one cycle if
>> you use normal Memory Read instead of Memory Read Line or Memory Read
>> Multiple.)
> 
> True enough... Fortunately my device allows me to set these...
> 
> What I am trying to avoid is PCI read transactions in general.  PCI
> reads are slow pretty much no matter if they are originated from the
> device or from the host because of all the multitude of bridges they
> have to go through (I've seen 5 in some cases... sheesh).  So
> ultimately I like for everything going to the device to be written
> from the host, then everything going towards the host be DMA'd into
> RAM by the device, at least then we can take advantage of PCI write
> posting and you don't have to wait for the write to actually complete
> before we plod on.  But this depends on at least getting get write
> burst performance from the host so that the time to write the data
> from host is less than the time it would take for the device to read
> the data out of RAM.
> 
> thanks again for your help!
> dan

Setting write-combining should be fairly easy without too many wierd 
side effects. Trying to use write-back to get burst reads is potentially 
doable, but may be fraught with difficulty.

I think DMA in both directions is still likely better though, unless the 
data you are writing is very small. Most chipsets have pretty small 
posting buffers so the amount it will help you is small. If you fill 
them up you'll just stall the CPU. With doing a DMA read, at least only 
the device will stall.
