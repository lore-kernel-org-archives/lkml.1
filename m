Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZKJAUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZKJAUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbZKJAUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:20:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:36130 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZKJAUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:20:02 -0500
Subject: Re: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent
 on	passthrough
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Chris Wright <chrisw@sous-sol.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>
In-Reply-To: <1257809524.24450.64.camel@8530w.home>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
	 <1257807747.25961.852.camel@macbook.infradead.org>
	 <1257809524.24450.64.camel@8530w.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 00:19:59 +0000
Message-ID: <1257812399.25961.892.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 16:32 -0700, Alex Williamson wrote:
> iommu=off means a feature regression from 2.6.31 and kills support for
> being able to use VT-d for virtualization for a large percentage of
> servers from a major vendor.  I don't think Chris' patches actually
> address this since we don't actually know what the DMA mask is for a
> device until the driver claims it.  How long do we wait before we drop
> the swiotlb? 

With a quirk for the broken device in question, we'll know nice and
early that it's there, and hence that we have to keep swiotlb around.
That fits on top of what Chris is doing relatively well.

>  I think his patch is really intended for the "oops, the
> DMAR is broken, the hardware is bad, I can't init the hardware IOMMU,
> whew we can fallback to swiotlb".

Well, in the case Chris is trying to handle it's not really that the
hardware is bad. It's more that the 'major vendor' of which you speak is
shipping completely crap firmware that hasn't been given _any_ form of
QA. They gave it VT-d support and obviously never once booted a VT-d
capable OS on it.

> > I'm slightly reluctant to put the half-arsed 'try to allocate in the
> > right region for broken devices but without full swiotlb support' option
> > into 2.6.32.
> 
> Since the device also makes use of RMRRs, once we have it in the
> si_domain, we're stuck.  I think that means we needs swiotlb anytime
> we're in passthrough mode.  That's what 2.6.31, can we get it back for
> 2.6.32?  Thanks,

That's what 2.6.31 did on _some_ hardware. It depends on whether you had
hardware or software passthrough. This particular broken device only
ever worked by accident in 2.6.31; it wasn't really by design.

But I suppose as a short-term measure, the patch you posted isn't so
bad. We'll fix it properly in 2.6.32 to use the non-passthrough mode for
devices with an inadequate coherent_dma_mask, and you can provide a
quirk which handles your "speshul" device differently.

We can also debate whether the non-passthrough mode for crap devices
(other than yours) should be to use the IOMMU, or to use swiotlb.

-- 
dwmw2

