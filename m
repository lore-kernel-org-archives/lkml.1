Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbXGIXKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbXGIXKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 19:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761280AbXGIXJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 19:09:54 -0400
Received: from waste.org ([66.93.16.53]:37961 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760343AbXGIXJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 19:09:52 -0400
Date: Mon, 9 Jul 2007 18:09:19 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-ID: <20070709230918.GX11115@waste.org>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <20070709095116.c2ea700f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709095116.c2ea700f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 09:51:16AM -0700, Andrew Morton wrote:
> On Mon, 9 Jul 2007 09:06:46 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> 
> > But yes the power of 
> > two caches are a necessary design feature of SLAB/SLUB that allows O(1) 
> > operations of kmalloc slabs which in turns causes memory wastage because 
> > of rounding of the alloc to the next power of two.
> 
> I've frequently wondered why we don't just create more caches for kmalloc:
> make it denser than each-power-of-2-plus-a-few-others-in-between.
> 
> I assume the tradeoff here is better packing versus having a ridiculous
> number of caches.  Is there any other cost?

It magnifies the fragmentation problem.

SLAB (and SLUB) makes the optimistic assumption that objects of the
same type/size have similar lifetimes. But for some objects, it's not
uncommon to do many temporary allocations but have some objects with
indefinite lifespans. dcache is a very frequently encountered example,
but there's no reason we couldn't see it with sockets and many other
object types. 

Every new arena introduces further opportunity for this sort of
fragmentation. If we had, say, separate pools for 48 byte and 64 byte
objects, an unfortunate usage pattern for 48-byte kmallocs could DoS
requests for 64 byte objects that would work just fine if they both
came out of the same pool. If we have 10 pools with long-lived
objects, we're much worse off than if we had 1 or 2.

-- 
Mathematics is the supreme nostalgia of our time.
