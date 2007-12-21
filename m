Return-Path: <linux-kernel-owner+w=401wt.eu-S1764006AbXLUABz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764006AbXLUABz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXLUABo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:01:44 -0500
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:45465 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbXLUABn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:01:43 -0500
To: rusty@rustcorp.com.au
Cc: davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH 2/5] dma_map_sg_ring() helper
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200712210958.56994.rusty@rustcorp.com.au>
References: <20071220160631S.fujita.tomonori@lab.ntt.co.jp>
	<20071219.234244.148945256.davem@davemloft.net>
	<200712210958.56994.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071221090027K.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 21 Dec 2007 09:00:27 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 09:58:56 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 20 December 2007 18:42:44 David Miller wrote:
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date: Thu, 20 Dec 2007 16:06:31 +0900
> >
> > > On Thu, 20 Dec 2007 16:49:30 +1100
> > >
> > > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > > +/**
> > > > + * dma_map_sg_ring - Map an entire sg ring
> > > > + * @dev: Device to free noncoherent memory for
> > > > + * @sg: The sg_ring
> > > > + * @direction: DMA_TO_DEVICE, DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
> > > > + *
> > > > + * This returns -ENOMEM if mapping fails.  It's not clear that telling
> > > > you + * it failed is useful though.
> > > > + */
> > > > +int dma_map_sg_ring(struct device *dev, struct sg_ring *sg,
> > > > +		     enum dma_data_direction direction)
> > > > +{
> > > > +	struct sg_ring *i;
> > > > +	unsigned int num;
> > > > +
> > > > +	for (i = sg; i; i = sg_ring_next(i, sg)) {
> > > > +		BUG_ON(i->num > i->max);
> > > > +		num = dma_map_sg(dev, i->sg, i->num, direction);
> > > > +		if (num == 0 && i->num != 0)
> > > > +			goto unmap;
> > > > +	}
> > > > +	return 0;
> > >
> > > I don't think that this works for IOMMUs that could merge sg entries.
> >
> > Right, it won't work at all.
> >
> > The caller has to be told how many DMA entries it really did use to
> > compose the mapping, and there has to be a way to properly iterate
> > over them.  The assumption that the IOMMU will map the SG entries
> > 1-to-1 is invalid.
> 
> Good catch.  Indeed, what's missing is one line:
> 
> 	i->num = num;
> 
> Of course, an arch-specific version of this could merge between sg_rings,
> too, but that's an optimization.

We need to pass the whole sg entries to the IOMMUs at a time.
