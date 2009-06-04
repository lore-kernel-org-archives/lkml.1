Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbZFDQ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbZFDQ3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758995AbZFDQ3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:29:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760117AbZFDQ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:29:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Thu, 4 Jun 2009 17:29:08 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200905282104.55818.arnd@arndb.de> <20090604143803.GD24491@flint.arm.linux.org.uk> <20090604144909.GE24491@flint.arm.linux.org.uk>
In-Reply-To: <20090604144909.GE24491@flint.arm.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906041729.10513.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+uamWcQQma8Q7IdQbWeZ5vF979st8gey30yE3
 HQbkg+izAep2G9VH8WQebNEEvnmZmqO5yYvKdv/BfR8gf6jJZt
 qFuf80HTaAlgbENEswgX/xIiSCeWGWe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Russell King wrote:
> The following assumption has been made by the kernel:
> 
> 	maximum_physical_address = dma_mask
> 
> Yes, that's _physical_ address, not bus specific DMA address:

Right, this is an oversimplification that I did not expect the kernel
to make, and it seems to stem from the days before we had the dma
mapping API.
 
> void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
> {
>         unsigned long b_pfn = dma_mask >> PAGE_SHIFT;
> ...
>         q->bounce_pfn = b_pfn;
> }
> 
> static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>                                              struct bio *bio)
> {
> ...
>                         high = page_to_pfn(bv->bv_page) > q->bounce_pfn;
> }
> 
> It's not "is this page DMA-able according to the DMA mask" it's effectively
> "is this page's physical address greater than the maximum physical address
> that can be DMA'd from".
> 
> As I've already pointed out, there are ARM platforms where this is just
> a total nonsense.

Agreed. I still think that a per-device limit combined with the set of
per-bus remapping rules should handle all cases right, but the block
bounce buffer handling seems to prevent that. Looking at
scsi_cacluclate_bounce_limit:

u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
{
	struct device *host_dev;
	u64 bounce_limit = 0xffffffff;

	if (shost->unchecked_isa_dma)
		return BLK_BOUNCE_ISA;
	/*
	 * Platforms with virtual-DMA translation
	 * hardware have no practical limit.
	 */
	if (!PCI_DMA_BUS_IS_PHYS)
		return BLK_BOUNCE_ANY;

	host_dev = scsi_get_device(shost);
	if (host_dev && host_dev->dma_mask)
		bounce_limit = *host_dev->dma_mask;

	return bounce_limit;
}

This is more or less hardcoding all the common cases
(ISA, PCI with IOMMU, and phys address limit per device),
but not the one you are interested in.

The bounce buffer handling is more or less an older and simpler
way of doing the swiotlb, maybe you can simply unset the
(horribly misnamed) PCI_DMA_BUS_IS_PHYS in order to effectively
disable bounce buffers at the block layer and instead do them
in the dma mapping layer in the form of swiotlb.

Are there similar problems outside of the block layer?
It seems that in networking, device drivers themselves are
always in charge of the allocation, so unlike block drivers,
they can do the right thing on all platforms that have this
problem.

> As I say, what is the DMA mask?  Is it really a limit?

I still don't think this is the right question to ask. The way that
the code is structured, it's very clear that it treats a mask and
a limit the same way. Simply assuming that it's a mask that can contain
zeroes gets you into trouble.

> Is it really supposed to be a mask?

Would it solve any problem if it were a mask? All uses essentially
come down to the point where you allocate memory and decide between
GFP_DMA, GFP_DMA32, GFP_NORMAL or GFP_HIGHMEM. If none of them
fit into the mask, you still lose. Also, a bitmask is not enough
to encode a range, as I mentioned before.

	Arnd <><
