Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYADEgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYADEgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 23:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYADEgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 23:36:16 -0500
Received: from waste.org ([66.93.16.53]:40479 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbYADEgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 23:36:15 -0500
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080104024506.GA4665@one.firstfloor.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <20080104024506.GA4665@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 22:34:44 -0600
Message-Id: <1199421285.4608.95.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-04 at 03:45 +0100, Andi Kleen wrote:
> > I still have trouble to see that SLOB still has much to offer. An embedded 
> > allocator that in many cases has more allocation overhead than the default 
> > one? Ok you still have advantages if allocations are rounded up to the 
> > next power of two for a kmalloc and because of the combining of different 
> > types of allocations in a single slab if there are an overall small number 
> > of allocations. If one would create a custom slab for the worst problems 
> > there then this may also go away.
> 
> I suspect it would be a good idea anyways to reevaluate the power of two
> slabs. Perhaps a better distribution can be found based on some profiling?
> I did profile kmalloc using a systemtap script some time ago but don't
> remember the results exactly, but iirc it looked like it could be improved.

We can roughly group kmalloced objects into two classes:

a) intrinsically variable-sized (strings, etc.)
b) fixed-sized objects that nonetheless don't have their own caches

For (a), we can expect the size distribution to be approximately a
scale-invariant power distribution. So buckets of the form n**x make a
fair amount of sense. We might consider n less than 2 though.

For objects of type (b) that occur in significant numbers, well, we
might just want to add more caches. SLUB's merging of same-sized caches
will reduce the pain here.

> A long time ago i also had some code to let the network stack give hints
> about its MMUs to slab to create fitting slabs for packets. But that
> was never really pushed forward because it turned out it didn't help
> much for the most common 1.5K MTU -- always only two packets fit into
> a page.

Yes, that and task_struct kinda make you want to cry. Large-order
SLAB/SLUB/SLOB would go a long way to fix that, but has its own problems
of course.

One could imagine restructuring things so that the buddy allocator only
extended down to 64k or so and below that, gfp and friends called
through SLAB/SLUB/SLOB.

-- 
Mathematics is the supreme nostalgia of our time.

