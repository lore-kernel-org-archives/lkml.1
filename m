Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYGXPGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYGXPGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYGXPGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:06:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:2527 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYGXPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FXIh3JuontU0cAR/ndYQ7JStYT8rpevqQKxX6QRs4xrDbTs7BD4Uu9Czl1DzOV8S/X
         etYpGUYPuLep1bnvkAt7Gbtk9IVXDN14y11KbXF/ad+i0LM1odOam+nXAjc+Z6+ZCYsN
         FbjLAdYy14iczw37HGf/1+So3P38O9C5Fq6uo=
Message-ID: <e17d70da0807240806h329bba4aw60e6fad82bcffabd@mail.gmail.com>
Date: Thu, 24 Jul 2008 16:06:31 +0100
From: Alex <arghness@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: DMA with PCIe and very large DMA transfers
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are there any examples (or just documentation) on providing DMA for
PCIe devices? I have read the DMA-mapping.txt document but wasn't sure
if this was all relevant to PCIe. For example, pci_set_dma_mask talks
about driving pins on the PCI bus, but PCIe doesn't work in quite the
same way. Perhaps these calls have no effect in this case (similar to
the PCI latency timers) but I just wondered.

I'm also interested in knowing if any drivers perform very large DMA
transfers. I'm putting together a driver for a specialist high-speed
data acquisition device that typically might need a DMA buffer of
100-500MB (ouch!) in the low 32 bit address space (or possibly 36 bit
address space, but I'm not sure if this is possible to allocate
without allocating as much as possible and then discarding?) but only
supports a very limited number of scatter/gather entries (between 1
and 4). The particular use-case for this is a ring buffer with
registers in IO memory that are used to keep track of read/write
pointers in the buffer. The device writes to the DMA memory when there
is space in the ring buffer i.e. the DMA transfer is only from device
to host.

I would like to perform the DMA straight from device to user-space
(probably via mmap), which I think requires a consistent/coherent
rather than streaming DMA so that I may read from the ring buffer
while the DMA may still be active (although not active in that section
of the buffer).

I assume that to allocate that much memory in physical contiguous
addresses will require a driver to be loaded as soon as possible at
startup. I was thinking about trying to grab a lot of high-order pages
and try and make them one contiguous block - is that feasible?
Browsing the archives, I found references to early allocation for
large buffers, but no direct links to existing examples or recommended
techniques on how to stitch pages together in to a single buffer. Is
there a platform independent way to ensure cache coherency with
allocated pages like this (i.e. not allocated with
pci_alloc_consistent / dma_alloc_coherent)?

I suppose that anything which takes a large chunk of physical memory
at startup isn't very recommended, but this is for a specialist device
and the host machine will probably be dedicated to using it.

As an aside, my module, driver and device are under the pci bus in
sysfs - should be PCIe device be showing under the pci_express bus?
This appears to be the PCIe Port Bus Driver and only has the aer
driver listed under it. I can't find any other drivers in the kernel
source that use it (I'm currently running 2.6.21).

Thanks,
Alex
