Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbXH0Gwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbXH0Gwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 02:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXH0Gw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 02:52:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56661 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXH0Gw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 02:52:27 -0400
Subject: Re: [PATCH] SLUB use cmpxchg_local
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca>
	 <20070820201822.597720007@polymtl.ca>
	 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
	 <20070820204126.GA22507@Krystal>
	 <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
	 <20070820212922.GA27011@Krystal>
	 <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
	 <20070820215413.GA28452@Krystal>
	 <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
	 <20070821173849.GA8360@Krystal>
	 <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 08:52:19 +0200
Message-Id: <1188197539.6114.426.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 16:14 -0700, Christoph Lameter wrote:
> On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:
> 
> > - Changed smp_rmb() for barrier(). We are not interested in read order
> >   across cpus, what we want is to be ordered wrt local interrupts only.
> >   barrier() is much cheaper than a rmb().
> 
> But this means a preempt disable is required. RT users do not want that.
> Without preemption the processor can be moved after c has been determined.
> That is why the smp_rmb() is there.

Likewise for disabling interrupts, we don't like that either. So
anything that requires cpu-pinning is preferably not done.

That said, we can suffer a preempt-off section if its O(1) and only a
few hundred cycles.

The trouble with all this percpu data in slub is that it also requires
pinning to the cpu in much of the slow path, either that or what we've
been doing so far with slab, a lock per cpu, and just grab one of those
locks and stick to the data belonging to that lock, regardless of
whether we get migrated.

slab-rt has these locks for all allocations and they are a massive
bottleneck for quite a few workloads, getting a fast path allocation
without using these would be most welcome.

So, if the fast path can be done with a preempt off, it might be doable
to suffer the slow path with a per cpu lock like that.


