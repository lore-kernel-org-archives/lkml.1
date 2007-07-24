Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbXGXTIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbXGXTIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbXGXTHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:07:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35862 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752994AbXGXTHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:07:53 -0400
Date: Tue, 24 Jul 2007 12:07:51 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@skynet.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERO to GFP_LEVEL_MASK
Message-ID: <20070724120751.401bcbcb@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707240030110.3295@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins>
	<20070723112143.GB19437@skynet.ie>
	<1185190711.8197.15.camel@twins>
	<Pine.LNX.4.64.0707231615310.427@schroedinger.engr.sgi.com>
	<1185256869.8197.27.camel@twins>
	<Pine.LNX.4.64.0707240007100.3128@schroedinger.engr.sgi.com>
	<1185261894.8197.33.camel@twins>
	<Pine.LNX.4.64.0707240030110.3295@schroedinger.engr.sgi.com>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_LEVEL_MASK is used to allow the pass through of page allocator
flags. Currently these are

#define GFP_LEVEL_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS| \
                        __GFP_COLD|__GFP_NOWARN|__GFP_REPEAT| \
                        __GFP_NOFAIL|__GFP_NORETRY|__GFP_COMP| \
                        __GFP_NOMEMALLOC|__GFP_HARDWALL|__GFP_THISNODE|
			__GFP_MOVABLE)

Some of these flags control page allocator reclaim and fallback
behavior. If they are specified for a slab alloc operation then they
are effective if a new slab has to be allocated. These are

1. Reclaim control

__GFP_WAIT
__GFP_IO
__GFP_FS
__GFP_NOWARN
__GFP_REPEAT
__GFP_NOFAIL
__GFP_NORETRY

2. Reserve control

__GFP_HIGH
__GFP_NOMEMALLOC

2. Fallback control

__GFP_HARDWALL	(cpuset contraints)
__GFP_THISNODE (handled by SLAB on its own, SLUB/SLOB pass through)

AFAIK these make sense.

Then there are some other flags. I am wondering why they are in
GFP_LEVEL_MASK?

__GFP_COLD	Does not make sense for slab allocators since we have
		to touch the page immediately.

__GFP_COMP	No effect. Added by the page allocator on their own
		if a higher order allocs are used for a slab.

__GFP_MOVABLE	The movability of a slab is determined by the
		options specified at kmem_cache_create time. If this is
		specified at kmalloc time then we will have some random
		slabs movable and others not. 

