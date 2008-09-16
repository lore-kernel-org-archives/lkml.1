Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYIPRNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYIPRNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYIPRNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:13:47 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:42668 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbYIPRNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:13:46 -0400
Date: Wed, 17 Sep 2008 02:13:25 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about
 virtual mappings
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080916134335.GC25711@one.firstfloor.org>
References: <87hc8grjuf.fsf@basil.nowhere.org>
	<20080916222032O.fujita.tomonori@lab.ntt.co.jp>
	<20080916134335.GC25711@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080917021319O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 15:43:35 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > What the need_iommu() does is seeing if GART needs to do virtual
> > mappings or not.
> > 
> > (After need_iommu() checking) What this patchset does is to guarantee
> > that GART provides a virtual address that a device can access to.
> 
> Ah you care about masks < 32bit?

Yes,


> Those always are handled elsewhere in the block layer (using the bounce_pfn
> mechanism)

I don't think that the bounce guarantees that dma_alloc_coherent()
returns an address that a device can access to.


> or in various other ways in other subsystems. e.g. on networking
> the rule is that you just don't announce direct SG when you have 
> less than 32bit mask.

I'm not familiar with what the networking does, for example, seems
that b44 sets dev->dma_mask to DMA_30BIT_MASK and b44_start_xmit()
does:

mapping = ssb_dma_map_single(bp->sdev, skb->data, len, DMA_TO_DEVICE);
if (ssb_dma_mapping_error(bp->sdev, mapping) || mapping + len > DMA_30BIT_MASK) {
	struct sk_buff *bounce_skb;

	/* Chip can't handle DMA to/from >1GB, use bounce buffer */
	if (!ssb_dma_mapping_error(bp->sdev, mapping))
		ssb_dma_unmap_single(bp->sdev, mapping, len,
				     DMA_TO_DEVICE);

IOMMUs can try to return an address that the NIC can access to.
