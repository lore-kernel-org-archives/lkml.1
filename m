Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYBLEQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYBLEQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 23:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbYBLEQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 23:16:30 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:23670 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYBLEQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 23:16:29 -0500
Date: Mon, 11 Feb 2008 22:15:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: DMA mapping API on 32-bit X86 with CONFIG_HIGHMEM64G
To: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <47B11D58.2070201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at the out-of-tree driver for a PCI high-security module 
(from a vendor who shall remain nameless) today, as we had a problem 
reported where the device didn't work properly if the computer had more 
than 4GB of RAM (this is x86 32-bit, with CONFIG_HIGHMEM64G enabled).

Essentially what it was doing was taking some memory that the userspace 
app was transferring to/from the device, doing get_user_pages on it, and 
then using the old-style page_to_phys, etc. functions to DMA on that 
memory instead of the modern DMA API.

However, I'm not sure this strategy would have worked on this platform 
even if it had been using the proper DMA API. This device has 32-bit DMA 
limits and is transferring userspace buffers which with HIGHMEM64G 
enabled could easily have physical addresses over 4GB. The strategy that 
Linux Device Drivers, 3rd Edition (chapter 15) suggests is doing 
get_user_pages, creating an SG list from the returned pages and then 
using dma_map_sg on that list. However, essentially all dma_map_sg in 
include/asm-x86/dma-mapping_32.h is:

	for_each_sg(sglist, sg, nents, i) {
		BUG_ON(!sg_page(sg));

		sg->dma_address = sg_phys(sg);
	}

which does nothing to ensure that the returned physical address is 
within the device's DMA mask. On 64-bit this triggers IOMMU mapping but 
on 32-bit it doesn't seem like this case is handled at all. I believe 
the block and networking layers have their own ways of ensuring that 
they don't feed such buffers to their drivers if they can't handle it, 
but a basic character device driver is kind of left out in the cold here 
and the DMA API doesn't appear to work as documented in this case. Given 
that x86-32 kernels don't implement any IOMMU support I'm not sure what 
it actually could do, other than implementing some kind of software 
bounce buffering of its own..

Are there any in-tree drivers that use this DMA mapping on 
get_user_pages strategy that could be affected by this?

I think the get_free_pages trick is actually pretty silly in this case, 
the size of the data being transferred is likely such that it would be 
just as fast or faster to copy to a kernel buffer and DMA to/from there..
