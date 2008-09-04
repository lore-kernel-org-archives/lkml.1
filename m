Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbYIDEN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbYIDEN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYIDEM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:12:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:53979 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYIDEM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:12:57 -0400
Date: Thu, 4 Sep 2008 13:11:46 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, iommu@lists.linux-foundation.org, mingo@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/3] swiotlb: use GFP_DMA32 instead of GFP_DMA in
 swiotlb_alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080903200527.GD16706@8bytes.org>
References: <1220465065-10533-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1220465065-10533-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080903200527.GD16706@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080904130130M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 22:05:27 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Thu, Sep 04, 2008 at 03:04:25AM +0900, FUJITA Tomonori wrote:
> > x86 sets up gfp flag propely so swiotlb_alloc_coherent doesn't need to
> > use GFP_DMA unconditionally. It leads to allocation failures in some
> > systems.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  lib/swiotlb.c |    7 +------
> >  1 files changed, 1 insertions(+), 6 deletions(-)
> > 
> > diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > index 977edbd..b88d7c2 100644
> > --- a/lib/swiotlb.c
> > +++ b/lib/swiotlb.c
> > @@ -467,12 +467,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> >  	void *ret;
> >  	int order = get_order(size);
> >  
> > -	/*
> > -	 * XXX fix me: the DMA API should pass us an explicit DMA mask
> > -	 * instead, or use ZONE_DMA32 (ia64 overloads ZONE_DMA to be a ~32
> > -	 * bit range instead of a 16MB one).
> > -	 */
> > -	flags |= GFP_DMA;
> > +	flags |= GFP_DMA32;
> 
> No. This is exactly the place where the swiotlb iommu implementation
> should handle the dma_mask of the specific device. Unconditionally use
> DMA32 here is not the best possible handling.

Not best but it works though ideally we can just remove the flags hack
completely.
