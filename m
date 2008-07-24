Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbYGXUCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbYGXUCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYGXUCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:02:22 -0400
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:38592 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751884AbYGXUCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:02:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=FpBJJAZx++M1fCUKxVf7Pl5qvJWZtTyj87NmVQke2NDEz9/QMUZ7E8+2OMKqQkHxlP4902rCBry6boaL2stAn2NWk/tFRljIdYbCTna8XyCQHW6xSwrvDZ5WXvSXDvSq;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex <arghness@gmail.com>
Subject: Re: DMA with PCIe and very large DMA transfers
Date: Thu, 24 Jul 2008 13:02:19 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <e17d70da0807240806h329bba4aw60e6fad82bcffabd@mail.gmail.com>
In-Reply-To: <e17d70da0807240806h329bba4aw60e6fad82bcffabd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241302.19656.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2008 8:06 am Alex wrote:
> Are there any examples (or just documentation) on providing DMA for
> PCIe devices? I have read the DMA-mapping.txt document but wasn't sure
> if this was all relevant to PCIe. For example, pci_set_dma_mask talks
> about driving pins on the PCI bus, but PCIe doesn't work in quite the
> same way. Perhaps these calls have no effect in this case (similar to
> the PCI latency timers) but I just wondered.

Yes, the API applies to PCIe as well.  It's really more of an address 
translation layer than anything else, giving you bus addresses to use with 
your device.  The API described in DMA-API.txt is even more generic, but 
either one should work for your purposes.

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

It sounds like you'll probably have fairly special purpose configurations.  In 
that case, it may be reasonable to reserve your large DMA buffers at boot 
time, assuming you need large, contiguous chunks of physical memory.  
Depending on your usage model, it may even be reasonable to limit the 
kernel's view of memory by modifying the e820 map or similar, and writing 
some custom code to manage your DMA buffers.

> I would like to perform the DMA straight from device to user-space
> (probably via mmap), which I think requires a consistent/coherent
> rather than streaming DMA so that I may read from the ring buffer
> while the DMA may still be active (although not active in that section
> of the buffer).

Well this would likely rule out the second approach I mentioned above, unless 
you wanted to do more major surgery on the kernel.  For high bw userspace 
communication you might check out relayfs 
(Documentation/filesystems/relay.txt), if it's suitable for your needs it 
could make things easier on you.

> I assume that to allocate that much memory in physical contiguous
> addresses will require a driver to be loaded as soon as possible at
> startup. I was thinking about trying to grab a lot of high-order pages
> and try and make them one contiguous block - is that feasible?
> Browsing the archives, I found references to early allocation for
> large buffers, but no direct links to existing examples or recommended
> techniques on how to stitch pages together in to a single buffer. Is
> there a platform independent way to ensure cache coherency with
> allocated pages like this (i.e. not allocated with
> pci_alloc_consistent / dma_alloc_coherent)?

Not that I can think of offhand, though on many platforms DMA mapped with 
map_single or map_sg will be coherent by default, which may be good enough 
for you.

> As an aside, my module, driver and device are under the pci bus in
> sysfs - should be PCIe device be showing under the pci_express bus?
> This appears to be the PCIe Port Bus Driver and only has the aer
> driver listed under it. I can't find any other drivers in the kernel
> source that use it (I'm currently running 2.6.21).

Yeah, for the most part stuff will appear under PCI in sysfs; only PCIe 
specific features like AER will show up under the PCI express bus driver.

Note that if you want to upstream this driver we'll probably want to add some 
platform independent code to support your needs (huge, coherent DMA buffers) 
in a reasonably generic way...

Jesse
