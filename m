Return-Path: <linux-kernel-owner+w=401wt.eu-S1761681AbXGXHfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761681AbXGXHfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbXGXHf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:35:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46116 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754243AbXGXHf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:35:28 -0400
Date: Tue, 24 Jul 2007 00:35:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERO to GFP_LEVEL_MASK
In-Reply-To: <1185261894.8197.33.camel@twins>
Message-ID: <Pine.LNX.4.64.0707240030110.3295@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins>  <20070723112143.GB19437@skynet.ie>
 <1185190711.8197.15.camel@twins>  <Pine.LNX.4.64.0707231615310.427@schroedinger.engr.sgi.com>
  <1185256869.8197.27.camel@twins>  <Pine.LNX.4.64.0707240007100.3128@schroedinger.engr.sgi.com>
 <1185261894.8197.33.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Peter Zijlstra wrote:

> > There is another exception for __GFP_DMA.
> 
> non of the zone specifiers are

__GFP_DMA is handled in a similar way to __GFP_ZERO though. Its explicitly 
listed in BUG_ON() because it can be specified in the gfpflags to kmalloc 
but also set by having created a slab with SLAB_DMA. It is also cleared 
by the & GFP_LEVEL_MASK.
 
> > > Anybody else got a preference?
> > 
> > >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
> > >  
> > > -/* if you forget to add the bitmask here kernel will crash, period */
> > > +/*
> > > + * If you forget to add the bitmask here kernel will crash, period!
> > > + *
> > > + * GFP_LEVEL_MASK is used to filter out the flags that are to be passed to the
> > > + * page allocator.
> > > + *
> > 
> > GFP_LEVEL_MASK is also used in mm/vmalloc.c. We need a definition that 
> > goes beyond slab allocators.
> 
> Right, bugger.

Lets get rid of the cryptic sentence there and explain it in a better way. 
GFP_LEVEL_MASK contains the flags that are passed to the page allocator
by derived allocators (such as slab allocators and vmalloc, maybe the 
uncached allocator may use it in the future?).

__get_vm_area_node also relies on GFP_LEVEL_MASK to clear the __GFP_ZERO 
flag. Otherwise the kmalloc_node there would needlessly return zeroed 
memory (or have failed in the past).
