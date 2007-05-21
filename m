Return-Path: <linux-kernel-owner+w=401wt.eu-S936242AbXEUT6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936242AbXEUT6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935091AbXEUToA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:44:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46646 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934527AbXEUTn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:43:58 -0400
Date: Mon, 21 May 2007 12:43:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Paul Jackson <pj@sgi.com>,
       npiggin@suse.de
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <1179776038.5735.39.camel@lappy>
Message-ID: <Pine.LNX.4.64.0705211239300.27622@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> 
 <Pine.LNX.4.64.0705161957440.13458@schroedinger.engr.sgi.com> 
 <1179385718.27354.17.camel@twins>  <Pine.LNX.4.64.0705171027390.17245@schroedinger.engr.sgi.com>
  <20070517175327.GX11115@waste.org>  <Pine.LNX.4.64.0705171101360.18085@schroedinger.engr.sgi.com>
  <1179429499.2925.26.camel@lappy>  <Pine.LNX.4.64.0705171220120.3043@schroedinger.engr.sgi.com>
  <1179437209.2925.29.camel@lappy>  <Pine.LNX.4.64.0705171516260.4593@schroedinger.engr.sgi.com>
  <1179482054.2925.52.camel@lappy>  <Pine.LNX.4.64.0705181002400.9372@schroedinger.engr.sgi.com>
  <1179650384.7019.33.camel@twins>  <Pine.LNX.4.64.0705210932500.25871@schroedinger.engr.sgi.com>
 <1179776038.5735.39.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Peter Zijlstra wrote:

> > So the original issue is still not fixed. A slab alloc may succeed without
> > watermarks if that particular allocation is restricted to a different set 
> > of nodes. Then the reserve slab is dropped despite the memory scarcity on
> > another set of nodes?
> 
> I can't see how. This extra ALLOC_MIN|ALLOC_HIGH|ALLOC_HARDER alloc will
> first deplete all other zones. Once that starts failing no node should
> still have pages accessible by any allocation context other than
> PF_MEMALLOC.

This means we will disobey cpuset and memory policy constraints?

> > No the gfp zone flags are not uniform and placement of page allocator 
> > allocs through SLUB do not always have the same allocation constraints.
> 
> It has to; since it can serve the allocation from a pre-existing slab
> allocation. Hence any page allocation must be valid for all other users.

Why does it have to? This is not true.

> > SLUB will check the node of the page that was allocated when the page 
> > allocator returns and put the page into that nodes slab list. This varies
> > depending on the allocation context.
> 
> Yes, it keeps slabs on per node lists. I'm just not seeing how this puts
> hard constraints on the allocations.

The constraints come from the context of memory policies and cpusets. See
get_any_partial().
 
> As far as I can see there cannot be a hard constraint here, because
> allocations form interrupt context are at best node local. And node
> affine zone lists still have all zones, just ordered on locality.

Interrupt context is something different. If we do not have a process 
context then no cpuset and memory policy constraints can apply since we
have no way of determining that. If you restrict your use of the reserve 
cpuset to only interrupt allocs then we may indeed be fine.
 
> > Allocations can be particular to uses of a slab in particular situations. 
> > A kmalloc cache can be used to allocate from various sets of nodes in 
> > different circumstances. kmalloc will allow serving a limited number of 
> > objects from the wrong nodes for performance reasons but the next 
> > allocation from the page allocator (or from the partial lists) will occur 
> > using the current set of allowed nodes in order to ensure a rough 
> > obedience to the memory policies and cpusets. kmalloc_node behaves 
> > differently and will enforce using memory from a particular node.
> 
> >From what I can see, it takes pretty much any page it can get once you
> hit it with PF_MEMALLOC. If the page allocation doesn't use ALLOC_CPUSET
> the page can come from pretty much anywhere.

No it cannot. One the current cpuslab is exhaused (which can be anytime) 
it will enforce the contextual allocation constraints. See 
get_any_partial() in slub.c.
