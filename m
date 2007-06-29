Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbXF2VPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbXF2VPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbXF2VPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:15:10 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3235 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbXF2VPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:15:09 -0400
Date: Fri, 29 Jun 2007 22:14:34 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       clameter@sgi.com, hugh@veritas.com, James.Bottomley@steeleye.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather lists
Message-ID: <20070629211434.GA21187@flint.arm.linux.org.uk>
References: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com> <20070628.220606.112621271.davem@davemloft.net> <20070628222424.4cbae90c.akpm@linux-foundation.org> <20070628.223734.21928089.davem@davemloft.net> <20070628224519.1a3319c3.akpm@linux-foundation.org> <20070629131657.5ecc3baa@the-village.bc.nu> <20070629134529.3e12a131.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629134529.3e12a131.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 01:45:29PM -0700, Andrew Morton wrote:
> On Fri, 29 Jun 2007 13:16:57 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > If those operations involve modifying that slab page's pageframe then what
> > > stops concurrent dma'ers from stomping on each other's changes?  As in:
> > > why aren't we already buggy?
> > 
> > Or DMA operations falling out with CPU operations in the same memory
> > area. Not all platforms have hardware consistency and some will blat the
> > entire page out of cache.
> 
> Is that just a performance problem, or can data be lost here?  It depends
> on the meaning of "blat": writeback?  invalidate?  More details, please.
> 
> 
> I'm dyin here and nobody will talk to me.  If the kernel is already doing
> these things, why aren't we already buggy?  Is it because we don't actually
> modify the pageframes of these dma-to-from-kmalloced pages?  But we were
> thinking of doing so in the future?

I think people are getting too het up about this.

DMA to or from memory should be done via the DMA mapping API.  If we're
DMAing to/from a limited range within a page, either we should be using
dma_map_single(), or dma_map_page() with an appropriate offset and size.

Other cache flushing functions should not be called for DMA operations;
any cache handling required by non-coherent architectures should be done
by the DMA API only.

However, with non-coherent aliasing architectures (such as those with
aliasing VIPT or VIVT caches) there is an additional requirement on PIO
to page cache.  If the page we're writing data has some cache lines
allocated to it, we potentially hit those cache lines and the data
doesn't hit the underlying page.  Later on, when we come to map the
page into userspace, the data may still be sitting in the cache lines
corresponding with the kernel's mapping.  Therefore, there is a
requirement to ensure that the cache state WRT the kernel's mapping is
the same irrespective of the method by which data ends up in the page.

That means that for these caches, the data PIO'd into the page must be
written back to the underlying page before the page is handed to
userspace.

The two are completely separate; it seems to me from the above discussion
that people are confusing the two scenarios, and mixing DMA with the PIO
cache handling.  Please don't, you'll only get more and more confused.

(Note: with the dma_map_* API, architectures have to be sensible when
they're passed offests and sizes which aren't cacheline aligned.
Technically, it's buggy to ask for non-L1 line aligned offsets and
sizes, but they do happen.  We handle this on ARM by writing back
the overlapped lines and invalidating the rest before the DMA operation
commences, and hope that the overlapped lines aren't touched for the
duration of the DMA.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
