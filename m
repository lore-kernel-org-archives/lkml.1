Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbYLIIei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbYLIIei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYLIIe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:34:26 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:30825 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYLIIeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:34:23 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Mingming Cao <cmm@us.ibm.com>,
       linux-ext4@vger.kernel.org
In-Reply-To: <493E2884.6010600@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
	 <20081206202233.3b74febc.akpm@linux-foundation.org>
	 <493BCF60.1080409@cosmosbay.com>
	 <20081207092854.f6bcbfae.akpm@linux-foundation.org>
	 <493C0F40.7040304@cosmosbay.com>
	 <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
	 <20081208221241.GA2501@mit.edu>
	 <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>
	 <20081208230047.GC2501@mit.edu> <1228777500.12729.4.camel@twins>
	 <493E2884.6010600@cosmosbay.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Dec 2008 09:34:13 +0100
Message-Id: <1228811653.6809.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-09 at 09:12 +0100, Eric Dumazet wrote:
> Peter Zijlstra a écrit :
> > On Mon, 2008-12-08 at 18:00 -0500, Theodore Tso wrote:
> >> On Mon, Dec 08, 2008 at 11:20:35PM +0100, Peter Zijlstra wrote:
> >>> atomic_t is pretty good on all archs, but you get to keep the cacheline
> >>> ping-pong.
> >>>
> >> Stupid question --- if you're worried about cacheline ping-pongs, why
> >> aren't each cpu's delta counter cacheline aligned?  With a 64-byte
> >> cache-line, and a 32-bit counters entry, with less than 16 CPU's we're
> >> going to be getting cache ping-pong effects with percpu_counter's,
> >> right?  Or am I missing something?
> > 
> > sorta - a new per-cpu allocator is in the works, but we do cacheline
> > align the per-cpu allocations (or used to), also, the allocations are
> > node affine.
> > 
> 
> I did work on a 'light weight percpu counter', aka percpu_lcounter, for
> all metrics that dont need 64 bits wide, but a plain 'long'
> (network, nr_files, nr_dentry, nr_inodes, ...)
> 
> struct percpu_lcounter {
>         atomic_long_t count;
> #ifdef CONFIG_SMP
> #ifdef CONFIG_HOTPLUG_CPU
>         struct list_head list;  /* All percpu_counters are on a list */
> #endif
>         long *counters;
> #endif
> };
> 
> (No more spinlock)
> 
> Then I tried to have atomic_t  (or atomic_long_t) for 'counters', but got a
> 10% slow down of __percpu_lcounter_add(), even if never hitting the 'slow path'
> atomic_long_add_return() is really expensiven, even on a non contended cache
> line.
> 
> struct percpu_lcounter {
>         atomic_long_t count;
> #ifdef CONFIG_SMP
> #ifdef CONFIG_HOTPLUG_CPU
>         struct list_head list;  /* All percpu_counters are on a list */
> #endif
>         atomic_long_t *counters;
> #endif
> };
> 
> So I believe the percpu_clounter_sum() that tries to reset to 0 all cpu local
>  counts would be really too expensive, if it slows down _add() so much.
> 
> long percpu_lcounter_sum(struct percpu_lcounter *fblc)
> {
>         long acc = 0;
>         int cpu;
> 
>         for_each_online_cpu(cpu)
>                 acc += atomic_long_xchg(per_cpu_ptr(fblc->counters, cpu), 0);
>         return atomic_long_add_return(acc, &fblc->count);
> }
> 
> void __percpu_lcounter_add(struct percpu_lcounter *flbc, long amount, s32 batch)
> {
>         long count;
>         atomic_long_t *pcount;
> 
>         pcount = per_cpu_ptr(flbc->counters, get_cpu());
>         count = atomic_long_add_return(amount, pcount); /* way too expensive !!! */

Yeah, its an extra LOCK ins where there wasn't one before.

>         if (unlikely(count >= batch || count <= -batch)) {
>                 atomic_long_add(count, &flbc->count);
>                 atomic_long_sub(count, pcount);

Also, this are two LOCKs where, with the spinlock, you'd likely only
have 1.

So yes, having the per-cpu variable an atomic seems like a way too
expensive idea. That xchg based _sum is cool though.

>         }
>         put_cpu();
> }
> 
> Just forget about it and let percpu_lcounter_sum() only read the values, and
> let percpu_lcounter_add() not using atomic ops in fast path.
> 
> void __percpu_lcounter_add(struct percpu_lcounter *flbc, long amount, s32 batch)
> {
>         long count;
>         long *pcount;
> 
>         pcount = per_cpu_ptr(flbc->counters, get_cpu());
>         count = *pcount + amount;
>         if (unlikely(count >= batch || count <= -batch)) {
>                 atomic_long_add(count, &flbc->count);
>                 count = 0;
>         }
>         *pcount = count;
>         put_cpu();
> }
> EXPORT_SYMBOL(__percpu_lcounter_add);
> 
> 
> Also, with upcoming NR_CPUS=4096, it may be time to design a hierarchical percpu_counter,
> to avoid hitting one shared "fbc->count" all the time a local counter overflows.

So we'd normally write to the shared cacheline every cpus/batch.
Cascading this you'd get ln(cpus)/(batch^ln(cpus)) or something like
that, right? Won't just increasing batch give the same result - or are
we going to play funny games with the topology information?

