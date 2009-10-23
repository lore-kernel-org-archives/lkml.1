Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbZJWQjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbZJWQjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZJWQjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:39:54 -0400
Received: from sous-sol.org ([216.99.217.87]:39302 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752419AbZJWQjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:39:54 -0400
Date: Fri, 23 Oct 2009 09:39:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] allow fallback to swiotlb on hw iommu init
	failures
Message-ID: <20091023163923.GA12883@sequoia.sous-sol.org>
References: <20091023012158.177308035@sequoia.sous-sol.org> <20091023145054P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023145054P.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* FUJITA Tomonori (fujita.tomonori@lab.ntt.co.jp) wrote:
> On Thu, 22 Oct 2009 18:21:58 -0700
> Chris Wright <chrisw@sous-sol.org> wrote:
> 
> > This short series gives us the ability to allocate the swiotlb and then
> > conditionally free it if we discover it isn't needed.  This allows us to
> > put swiotlb to use when the hw iommu fails to initialize properly.
> > 
> > This needs some changes to the bootmem allocator to give the ability to
> > free reserved bootmem directly to the page allocator after bootmem is
> > torn down.
> 
> The concept sounds fine but the third patch doesn't look correct.
> 
> Seems that the third patch doesn't take into account enabling both hw
> iommu and swiotlb (Calgary does and I guess VT-d and AMD need that
> too).

VT-d isn't using swiotlb.  Nor is AMD, although I think it will pick up
no_iommu on passthrough (seems like it would benefit from swiotlb in
that case).

>  Also (iommu_detected && !dma_ops) trick doesn't work for
> Calgary, IIRC.

Yes, I think you are right.  I had stared at the calgary code and thought
it would DTRT due to calgary's use of no_iommu as fallback, but instead
it will never pick up swiotlb_dma_ops.  The calgary shouldn't even need
to be manually setting up nommu_dma_ops.

>  The third patch also makes the dma startup code more
> complicated.

I completely agree.  The whole dma/iommu startup is already complex
and fragile.  Issues like above made getting the right combination
like whack-a-mole.

> I have half-baked patches to clean up the dma startup code supporting
> the concept. I can work on the top of the first and second
> patches. They need to be CC'ed to the memory people and ACKs, don't
> they?

Great.
