Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYGXUE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYGXUE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbYGXUED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:04:03 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:4923 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753526AbYGXUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:04:01 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=ZBoxELfd66lUOLupKHEA:9 a=G1kx7nUvTcNFvVpvuPgA:7 a=TkoGrY2U7QABDhVntCZ_Y_zNSHwA:4 a=V0udAT3DthYA:10 a=z7OazWlR7xUA:10
Message-ID: <4888E011.4000406@shaw.ca>
Date: Thu, 24 Jul 2008 14:03:29 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex <arghness@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: DMA with PCIe and very large DMA transfers
References: <fa.vod1UTmCwWWvRyGIk08cgMVx/H4@ifi.uio.no>
In-Reply-To: <fa.vod1UTmCwWWvRyGIk08cgMVx/H4@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex wrote:
> Are there any examples (or just documentation) on providing DMA for
> PCIe devices? I have read the DMA-mapping.txt document but wasn't sure
> if this was all relevant to PCIe. For example, pci_set_dma_mask talks
> about driving pins on the PCI bus, but PCIe doesn't work in quite the
> same way. Perhaps these calls have no effect in this case (similar to
> the PCI latency timers) but I just wondered.

Not sure where you saw that reference, but there's no difference with 
respect to DMA mapping with PCI vs. PCI Express.

> 
> I'm also interested in knowing if any drivers perform very large DMA
> transfers. I'm putting together a driver for a specialist high-speed
> data acquisition device that typically might need a DMA buffer of
> 100-500MB (ouch!) in the low 32 bit address space (or possibly 36 bit
> address space, but I'm not sure if this is possible to allocate
> without allocating as much as possible and then discarding?) but only
> supports a very limited number of scatter/gather entries (between 1
> and 4). The particular use-case for this is a ring buffer with
> registers in IO memory that are used to keep track of read/write
> pointers in the buffer. The device writes to the DMA memory when there
> is space in the ring buffer i.e. the DMA transfer is only from device
> to host.
> 
> I would like to perform the DMA straight from device to user-space
> (probably via mmap), which I think requires a consistent/coherent
> rather than streaming DMA so that I may read from the ring buffer
> while the DMA may still be active (although not active in that section
> of the buffer).
> 
> I assume that to allocate that much memory in physical contiguous
> addresses will require a driver to be loaded as soon as possible at
> startup. I was thinking about trying to grab a lot of high-order pages
> and try and make them one contiguous block - is that feasible?

For a block of memory that big, you may need to reserve some memory at 
boot time for use by the device. I don't really have any details on how 
to do that, though.

> Browsing the archives, I found references to early allocation for
> large buffers, but no direct links to existing examples or recommended
> techniques on how to stitch pages together in to a single buffer. Is
> there a platform independent way to ensure cache coherency with
> allocated pages like this (i.e. not allocated with
> pci_alloc_consistent / dma_alloc_coherent)?
> 
> I suppose that anything which takes a large chunk of physical memory
> at startup isn't very recommended, but this is for a specialist device
> and the host machine will probably be dedicated to using it.
> 
> As an aside, my module, driver and device are under the pci bus in
> sysfs - should be PCIe device be showing under the pci_express bus?
> This appears to be the PCIe Port Bus Driver and only has the aer
> driver listed under it. I can't find any other drivers in the kernel
> source that use it (I'm currently running 2.6.21).

Most parts of the kernel don't care whether devices are PCI or PCI-E, so 
this is presumably why.
