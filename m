Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYGKLQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYGKLQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbYGKLQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:16:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:36555 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbYGKLQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:16:25 -0400
Date: Fri, 11 Jul 2008 20:15:52 +0900
To: mpatocka@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.64.0807110649510.16550@engineering.redhat.com>
References: <Pine.LNX.4.64.0807101702090.19775@engineering.redhat.com>
	<20080711152054C.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0807110649510.16550@engineering.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080711201558J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 06:52:09 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 11 Jul 2008, FUJITA Tomonori wrote:
> 
> > On Thu, 10 Jul 2008 17:56:08 -0400 (EDT)
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >> When I thought about it more, I realized that this accounting of virtual
> >> segments in I/O layer can't work correctly at all. If an architecture
> >> defines symbols BIOVEC_VIRT_MERGEABLE and BIOVEC_VIRT_OVERSIZE, it
> >> declares that it's IOMMU must merge any two regions satisfying these
> >> conditions. But in an IOMMU, it is impossible to guarantee, because:
> >
> > Yeah, IOMMUs can't guarantee that. The majority of architectures set
> > BIO_VMERGE_BOUNDARY to 0 so they don't hit this, I think.
> 
> Yes, the architectures without IOMMU don't hit this problem.

I meant that even if some architectures support IOMMUs, they set
BIO_VMERGE_BOUNDARY to 0.


> >> * the bus address is allocated basiclly randomly, so we can hit
> >> dev->dma_parms->segment_boundary_mask any time. This will prevent virtual
> >> merging from happenning. I/O layer doesn't know the bus address at the
> >> time it merges requests, so it can't predict when this happens.
> >>
> >> * the IOMMU isn't guaranteed to find a continuous space in it's bus
> >> address space. If it skips over already mapped regions, it can't perform
> >> virtual merging.
> >>
> >> * when creating the mapping, we can hit per-device limit
> >> "dev->dma_parms->max_segment_size" --- but the I/O layer checks only
> >> against global limit BIOVEC_VIRT_OVERSIZE. (this last issue is fixable,
> >> the previous two are not).
> >
> > I think that the block layer can handle this properly via
> > q->max_segment_size. We have the same value at two different
> > places. Yeah, it's not good...
> >
> >
> > BTW, inia100_template sets sg_tablesize to SG_ALL. If the controller
> > has at most 32 SG entries per request, we need to fix that.
> 
> Later, it sets that to shost->sg_tablesize = TOTAL_SG_ENTRY; I don't know 
> why in inia100_template there is SG_ALL.

Thanks, I overlooked it.

Seems that the driver sets shost->sg_tablesize to TOTAL_SG_ENTRY
unconditionally. Setting it in inia100_template is better.
