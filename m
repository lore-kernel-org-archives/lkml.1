Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbXGXX7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbXGXX7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXGXX6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:58:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49929 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757070AbXGXX6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:58:53 -0400
Date: Tue, 24 Jul 2007 16:58:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERO to GFP_LEVEL_MASK
In-Reply-To: <20070724161247.ee1a2546.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707241639440.9018@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins> <20070723112143.GB19437@skynet.ie>
 <1185190711.8197.15.camel@twins> <Pine.LNX.4.64.0707231615310.427@schroedinger.engr.sgi.com>
 <1185256869.8197.27.camel@twins> <Pine.LNX.4.64.0707240007100.3128@schroedinger.engr.sgi.com>
 <1185261894.8197.33.camel@twins> <Pine.LNX.4.64.0707240030110.3295@schroedinger.engr.sgi.com>
 <20070724120751.401bcbcb@schroedinger.engr.sgi.com>
 <20070724122542.d4ac734a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707241234460.13653@schroedinger.engr.sgi.com>
 <20070724151046.d8fbb7da.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707241541310.7288@schroedinger.engr.sgi.com>
 <20070724161247.ee1a2546.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Andrew Morton wrote:

> __GFP_COMP I'm not so sure about. 
> drivers/char/drm/drm_pci.c:drm_pci_alloc() (and other places like infiniband)
> pass it into dma_alloc_coherent() which some architectures implement via slab.  umm,
> arch/arm/mm/consistent.c is one such.

Should  drm_pci_alloc really aright in setting __GFP_COMP? 
dma_alloc_coherent does not set __GFP_COMP for other higher order allocs 
and expects to be able to operate on the page structs indepedently. That 
is not the case for a compound page.

Creates a really interesting case for SLAB. Slab did not use __GFP_COMP in 
order to be able to allow the use page->private (No longer an issue since 
the 2.6.22 cleanups and avoiding the use of page->private for the compound 
head).

Now the __GFP_COMP flag is passed through for any higher order page alloc 
(such as a kmalloc allocation > PAGE_SIZE). Then we may have allocated one 
slab that is a compound page amoung others higher order pages allocated 
without __GFP_COMP. May have caused rare and strange failures in 2.6.21 
and earlier because of the concurrent page->private use in compound head 
pages and arch pages.

SLUB will always use __GFP_COMP so the pages are consistent regardless if 
__GFP_COMP is passed in or not.

The strange scenarios come about by expecting a page allocation when 
sometimes we just substitute a slab alloc.

We could filter __GFP_COMP out to avoid the BUG()? Or deal with it on a 
case by case basis?

