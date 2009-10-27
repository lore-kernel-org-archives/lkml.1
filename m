Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbZJ0A5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbZJ0A5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZJ0A5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:57:53 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50616 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbZJ0A5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:57:52 -0400
Date: Tue, 27 Oct 2009 09:57:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/5] dma: create dma_generic_alloc/free_coherent()
Message-ID: <20091027005748.GB17085@linux-sh.org>
References: <20091026232401.9646.90540.stgit@nehalem.aw> <20091026232458.9646.36818.stgit@nehalem.aw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026232458.9646.36818.stgit@nehalem.aw>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 05:24:58PM -0600, Alex Williamson wrote:
> Move dma_generic_alloc_coherent() out of x86 code and create
> corresponding dma_generic_free_coherent() for symmetry.  These
> can then be used by IOMMU drivers attempting to implement
> passthrough mode.
> 
Except that dma_generic_alloc_coherent() is only "generic" for platforms
with consistent DMA. Everyone else will need a cacheflush and potentially
a remap. It's not even obvious from looking at the consistent DMA
platforms that they'll be able to use it out of the box due to expecting
something other than page_address(), which all suggests that this is
better off remaining an x86-only routine.

This is also making changes to the DMA-API without any documentation
updates and without consulting with any other architecture people. If you
wish to make a proposal for a DMA-API addition, then this should be made
to linux-arch rather than hidden in an iommu patchset.

Beyond that, we presently have:

	- dma_alloc_coherent()
	- dma_alloc_noncoherent()
	- dma_alloc_from_coherent()

defined in the API. Making an addition to this for your fallback case
seems workable, but it's something that will have to be handled
differently for each architecture. You might be able to get away with
something generic enough to stash in drivers/base/dma-coherent.c, but
from a first look, I wouldn't count on it.

It was bad enough when the x86-specific flush_write_buffers() snuck in to
the "generic" dma mapping code, but this particular case is much more
problematic.
