Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYLIINi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYLIINi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYLIIN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:13:27 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:60243 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYLIINZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:13:25 -0500
Message-ID: <493E2884.6010600@cosmosbay.com>
Date: Tue, 09 Dec 2008 09:12:52 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Mingming Cao <cmm@us.ibm.com>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
References: <4936D287.6090206@cosmosbay.com>	 <4936EB04.8000609@cosmosbay.com>	 <20081206202233.3b74febc.akpm@linux-foundation.org>	 <493BCF60.1080409@cosmosbay.com>	 <20081207092854.f6bcbfae.akpm@linux-foundation.org>	 <493C0F40.7040304@cosmosbay.com>	 <20081207205250.dbb7fe4b.akpm@linux-foundation.org>	 <20081208221241.GA2501@mit.edu>	 <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>	 <20081208230047.GC2501@mit.edu> <1228777500.12729.4.camel@twins>
In-Reply-To: <1228777500.12729.4.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 09 Dec 2008 09:12:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra a écrit :
> On Mon, 2008-12-08 at 18:00 -0500, Theodore Tso wrote:
>> On Mon, Dec 08, 2008 at 11:20:35PM +0100, Peter Zijlstra wrote:
>>> atomic_t is pretty good on all archs, but you get to keep the cacheline
>>> ping-pong.
>>>
>> Stupid question --- if you're worried about cacheline ping-pongs, why
>> aren't each cpu's delta counter cacheline aligned?  With a 64-byte
>> cache-line, and a 32-bit counters entry, with less than 16 CPU's we're
>> going to be getting cache ping-pong effects with percpu_counter's,
>> right?  Or am I missing something?
> 
> sorta - a new per-cpu allocator is in the works, but we do cacheline
> align the per-cpu allocations (or used to), also, the allocations are
> node affine.
> 

I did work on a 'light weight percpu counter', aka percpu_lcounter, for
all metrics that dont need 64 bits wide, but a plain 'long'
(network, nr_files, nr_dentry, nr_inodes, ...)

struct percpu_lcounter {
        atomic_long_t count;
#ifdef CONFIG_SMP
#ifdef CONFIG_HOTPLUG_CPU
        struct list_head list;  /* All percpu_counters are on a list */
#endif
        long *counters;
#endif
};

(No more spinlock)

Then I tried to have atomic_t  (or atomic_long_t) for 'counters', but got a
10% slow down of __percpu_lcounter_add(), even if never hitting the 'slow path'
atomic_long_add_return() is really expensiven, even on a non contended cache
line.

struct percpu_lcounter {
        atomic_long_t count;
#ifdef CONFIG_SMP
#ifdef CONFIG_HOTPLUG_CPU
        struct list_head list;  /* All percpu_counters are on a list */
#endif
        atomic_long_t *counters;
#endif
};

So I believe the percpu_clounter_sum() that tries to reset to 0 all cpu local
 counts would be really too expensive, if it slows down _add() so much.

long percpu_lcounter_sum(struct percpu_lcounter *fblc)
{
        long acc = 0;
        int cpu;

        for_each_online_cpu(cpu)
                acc += atomic_long_xchg(per_cpu_ptr(fblc->counters, cpu), 0);
        return atomic_long_add_return(acc, &fblc->count);
}

void __percpu_lcounter_add(struct percpu_lcounter *flbc, long amount, s32 batch)
{
        long count;
        atomic_long_t *pcount;

        pcount = per_cpu_ptr(flbc->counters, get_cpu());
        count = atomic_long_add_return(amount, pcount); /* way too expensive !!! */
        if (unlikely(count >= batch || count <= -batch)) {
                atomic_long_add(count, &flbc->count);
                atomic_long_sub(count, pcount);
        }
        put_cpu();
}

Just forget about it and let percpu_lcounter_sum() only read the values, and
let percpu_lcounter_add() not using atomic ops in fast path.

void __percpu_lcounter_add(struct percpu_lcounter *flbc, long amount, s32 batch)
{
        long count;
        long *pcount;

        pcount = per_cpu_ptr(flbc->counters, get_cpu());
        count = *pcount + amount;
        if (unlikely(count >= batch || count <= -batch)) {
                atomic_long_add(count, &flbc->count);
                count = 0;
        }
        *pcount = count;
        put_cpu();
}
EXPORT_SYMBOL(__percpu_lcounter_add);


Also, with upcoming NR_CPUS=4096, it may be time to design a hierarchical percpu_counter,
to avoid hitting one shared "fbc->count" all the time a local counter overflows.


