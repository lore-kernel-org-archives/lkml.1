Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbXEJW1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbXEJW1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbXEJW1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:27:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40902 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758310AbXEJW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:27:20 -0400
Date: Thu, 10 May 2007 15:27:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.skynet.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Nicolas.Mailhot@LaPoste.net,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
Subject: Re: [Bug 8464] New: autoreconf: page allocation failure. order:2,
 mode:0x84020
In-Reply-To: <20070510221607.GA15084@skynet.ie>
Message-ID: <Pine.LNX.4.64.0705101522250.13504@schroedinger.engr.sgi.com>
References: <200705102128.l4ALSI2A017437@fire-2.osdl.org>
 <20070510144319.48d2841a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705101447120.12874@schroedinger.engr.sgi.com>
 <20070510220657.GA14694@skynet.ie> <Pine.LNX.4.64.0705101510500.13404@schroedinger.engr.sgi.com>
 <20070510221607.GA15084@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Mel Gorman wrote:

> On (10/05/07 15:11), Christoph Lameter didst pronounce:
> > On Thu, 10 May 2007, Mel Gorman wrote:
> > 
> > > I see the gfpmask was 0x84020. That doesn't look like __GFP_WAIT was set,
> > > right? Does that mean that SLUB is trying to allocate pages atomically? If so,
> > > it would explain why this situation could still occur even though high-order
> > > allocations that could sleep would succeed.
> > 
> > SLUB is following the gfp mask of the caller like all well behaved slab 
> > allocators do. If the caller does not set __GFP_WAIT then the page 
> > allocator also cannot wait.
> 
> Then SLUB should not use the higher orders for slab allocations that cannot
> sleep during allocations. What could be done in the longer term is decide
> how to tell kswapd to keep pages free at an order other than 0 when it is
> known there are a large number of high-order long-lived allocations like this.

I cannot predict how allocations on a slab will be performed. In order 
to avoid the higher order allocations in we would have to add a flag 
that tells SLUB at slab creation creation time that this cache will be 
used for atomic allocs and thus we can avoid configuring slabs in such a 
way that they use higher order allocs.

The other solution is not to use higher order allocations by dropping the 
antifrag patches in mm that allow SLUB to use higher order allocations. 
But then there would be no higher order allocations at all that would use 
the benefits of antifrag measures.
