Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYBQExX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYBQExX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 23:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbYBQExP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 23:53:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:49919 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYBQExO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 23:53:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aoAHBsN3k/iPJyl/rAq6hTuT+o+O1T2F0bIdjhumvvUKnvPi2/gETcadeMzcmtDK2fzjfDbj6Ew08mCEfGBUDgI938hm+SnsEyNm1sdEgAr536mmMQJ9TME2JAG5+Vn2tEs5IQe/SL9MFgAHD+VcSmh42kkBpbHd9G/Tyavtpsw=
Message-ID: <4779de450802162053j66920f74p61cc4a0240d2cc53@mail.gmail.com>
Date: Sat, 16 Feb 2008 20:53:14 -0800
From: "Dan Gora" <dan.gora@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: PCI Bursting with PIO
In-Reply-To: <47B67C06.6060706@mail.usask.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.Mbzb1/2dWnp5V/5ElzijlkAstZU@ifi.uio.no>
	 <47B67C06.6060706@mail.usask.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15, 2008 10:00 PM, Robert Hancock <rwh461@mail.usask.ca> wrote:
>
> Well, in order for the CPU to batch up more writes you'd have to map the
>   BAR as either write-combining or write-back. If it's not listed in
> /proc/mtrr it will be the default setting of uncacheable.

Ok, this is pretty much what I thought, but I still don't really have
any idea how to do this.  ioremap() doesn't take any flags and I'm not
using ioremap_uncacheable(), plus the BAR is marked prefetchable...

> X has code to
> set up the video memory on the video card as write-combining so it can
> get better write performance, you could do something similar.

Alan mentioned this as well, but I haven't tried to hunt this code
yet.  If you have any pointers as to where I might find this, I would
appreciate it.

> Setting it as write-back might allow you to get the reads to do bursting
> as well (since the CPU will do a cache-line fill instead of individual
> accesses)

I don't see what the cache write policy has to do with the reads.  If
the region is marked cacheable, then all reads should try and read a
cache line, right?  The write-back or write-through policy only has to
do with the writes.  If it's write through then writes go directly to
RAM, if it's write-back then they hit the cache and are flushed when
the  line is flushed (LRU replacement, explicit cache line flush,
etc..), right?

> but this if the device is modifying this memory area, unless
> you add code to invalidate those cache lines before reading the data
> you'll get stale data back.

Yeah this could definitely be tricky, would pci_dma_sync suffice for this?

> You could run into some other less obvious
> issues as well, as normally device memory regions are not mapped write-back.
>
> In general, especially if you need to read data back from the device,
> implementing a DMA engine would be by far the better option. Most
> chipsets seem not at all optimized for handling sequential reads from
> PCI memory from the CPU. (Even in the DMA case, you have to be careful
> with what type of memory read transaction you use when transferring from
> host memory - some chipsets don't like to burst more than one cycle if
> you use normal Memory Read instead of Memory Read Line or Memory Read
> Multiple.)

True enough... Fortunately my device allows me to set these...

What I am trying to avoid is PCI read transactions in general.  PCI
reads are slow pretty much no matter if they are originated from the
device or from the host because of all the multitude of bridges they
have to go through (I've seen 5 in some cases... sheesh).  So
ultimately I like for everything going to the device to be written
from the host, then everything going towards the host be DMA'd into
RAM by the device, at least then we can take advantage of PCI write
posting and you don't have to wait for the write to actually complete
before we plod on.  But this depends on at least getting get write
burst performance from the host so that the time to write the data
from host is less than the time it would take for the device to read
the data out of RAM.

thanks again for your help!
dan
