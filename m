Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbZJXG5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbZJXG5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 02:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZJXG5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 02:57:30 -0400
Received: from sous-sol.org ([216.99.217.87]:39754 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752516AbZJXG5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 02:57:30 -0400
Date: Fri, 23 Oct 2009 23:57:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] allow fallback to swiotlb on hw iommu init
	failures
Message-ID: <20091024065712.GC14926@sequoia.sous-sol.org>
References: <20091023012158.177308035@sequoia.sous-sol.org> <20091023145054P.fujita.tomonori@lab.ntt.co.jp> <20091023163923.GA12883@sequoia.sous-sol.org> <20091024120633Z.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091024120633Z.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* FUJITA Tomonori (fujita.tomonori@lab.ntt.co.jp) wrote:
> On Fri, 23 Oct 2009 09:39:23 -0700
> Chris Wright <chrisw@sous-sol.org> wrote:
> 
> > > The concept sounds fine but the third patch doesn't look correct.
> > > 
> > > Seems that the third patch doesn't take into account enabling both hw
> > > iommu and swiotlb (Calgary does and I guess VT-d and AMD need that
> > > too).
> > 
> > VT-d isn't using swiotlb.  Nor is AMD, although I think it will pick up
> > no_iommu on passthrough (seems like it would benefit from swiotlb in
> > that case).
> 
> I think that they need swiotlb for the same reason why Calgray needs
> it. IIRC, someone in VT-d camp said so.

Right, it was used as fallback for a bit when pass through mode was
first enabled to handle case where device has dma mask smaller than
physical memory.  That was removed, it was just recently w/ Alex's
comments that the idea of putting it back came up.

> > >  Also (iommu_detected && !dma_ops) trick doesn't work for
> > > Calgary, IIRC.
> > 
> > Yes, I think you are right.  I had stared at the calgary code and thought
> > it would DTRT due to calgary's use of no_iommu as fallback, but instead
> > it will never pick up swiotlb_dma_ops.
> 
> Note that Calgary comment 'falling back to no_iommu' is misleading. It
> actually falls back to swiotlb or nommu properly.
> 
> Calgary doesn't set to dma_ops to calgary_dma_ops so it doesn't need
> to pick up swiotlb_dma_ops.

It does need swiotlb_dma_ops even when calgary init succeeds for the devices
that aren't behind Calgary to deal w/ the case of those devices having
dma mask smaller than physical memory (i.e those that don't get device
specific dma_ops set to calgary_dma_ops).  So, the problem with this
patch is that it would fall back to nommu_dma_ops in cases where it was
expecting to fall back to swiotlb.

> > The calgary shouldn't even need to be manually setting up
> > nommu_dma_ops.
> 
> Yeah, but it needs because of how the dma startup code works.

Be much better to have the core handle all of this. Basically register
ops and then put the top one on the stack to actual use.  So the
fallback would be automatic, just pick the top of the stack and go.
Were you thinking of something along those lines?

thanks,
-chris
