Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbXEUQpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbXEUQpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbXEUQpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:45:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35172 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755827AbXEUQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:45:38 -0400
Date: Mon, 21 May 2007 09:45:36 -0700 (PDT)
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
In-Reply-To: <1179650384.7019.33.camel@twins>
Message-ID: <Pine.LNX.4.64.0705210932500.25871@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> 
 <Pine.LNX.4.64.0705161957440.13458@schroedinger.engr.sgi.com> 
 <1179385718.27354.17.camel@twins>  <Pine.LNX.4.64.0705171027390.17245@schroedinger.engr.sgi.com>
  <20070517175327.GX11115@waste.org>  <Pine.LNX.4.64.0705171101360.18085@schroedinger.engr.sgi.com>
  <1179429499.2925.26.camel@lappy>  <Pine.LNX.4.64.0705171220120.3043@schroedinger.engr.sgi.com>
  <1179437209.2925.29.camel@lappy>  <Pine.LNX.4.64.0705171516260.4593@schroedinger.engr.sgi.com>
  <1179482054.2925.52.camel@lappy>  <Pine.LNX.4.64.0705181002400.9372@schroedinger.engr.sgi.com>
 <1179650384.7019.33.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Peter Zijlstra wrote:

> I care about kernel allocations only. In particular about those that
> have PF_MEMALLOC semantics.

Hmmmm.. I wish I was more familiar with PF_MEMALLOC. ccing Nick.

>  - set page->reserve nonzero for each page allocated with
>    ALLOC_NO_WATERMARKS; which by the previous point implies that all
>    available zones are below ALLOC_MIN|ALLOC_HIGH|ALLOC_HARDER

Ok that adds a new field to the page struct. I suggested a page flag in 
slub before.
 
>  - when a page->reserve slab is allocated store it in s->reserve_slab
>    and do not update the ->cpu_slab[] (this forces subsequent allocs to
>    retry the allocation).

Right that should work.
 
> All ALLOC_NO_WATERMARKS enabled slab allocations are served from
> ->reserve_slab, up until the point where a !page->reserve slab alloc
> succeeds, at which point the ->reserve_slab is pushed into the partial
> lists and ->reserve_slab set to NULL.

So the original issue is still not fixed. A slab alloc may succeed without
watermarks if that particular allocation is restricted to a different set 
of nodes. Then the reserve slab is dropped despite the memory scarcity on
another set of nodes?

> Since only the allocation of a new slab uses the gfp zone flags, and
> other allocations placement hints they have to be uniform over all slab
> allocs for a given kmem_cache. Thus the s->reserve_slab/page->reserve
> status is kmem_cache wide.

No the gfp zone flags are not uniform and placement of page allocator 
allocs through SLUB do not always have the same allocation constraints.
SLUB will check the node of the page that was allocated when the page 
allocator returns and put the page into that nodes slab list. This varies
depending on the allocation context.

Allocations can be particular to uses of a slab in particular situations. 
A kmalloc cache can be used to allocate from various sets of nodes in 
different circumstances. kmalloc will allow serving a limited number of 
objects from the wrong nodes for performance reasons but the next 
allocation from the page allocator (or from the partial lists) will occur 
using the current set of allowed nodes in order to ensure a rough 
obedience to the memory policies and cpusets. kmalloc_node behaves 
differently and will enforce using memory from a particular node.

SLAB is very strict in that area and will not allow serving objects from 
the wrong node even with only kmalloc. Changing policy will immediately 
change the per node queue that SLAB takes its objects from.
