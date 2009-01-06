Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbZAFMLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbZAFMLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZAFMLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:11:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbZAFMLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:11:21 -0500
Date: Tue, 6 Jan 2009 13:10:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Message-ID: <20090106121052.GA27232@elte.hu>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231242031.11687.97.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> +++ linux-2.6/kernel/mutex.c
> @@ -46,6 +46,7 @@ __mutex_init(struct mutex *lock, const c
>  	atomic_set(&lock->count, 1);
>  	spin_lock_init(&lock->wait_lock);
>  	INIT_LIST_HEAD(&lock->wait_list);
> +	lock->owner = NULL;
>  
>  	debug_mutex_init(lock, name, key);
>  }
> @@ -120,6 +121,28 @@ void __sched mutex_unlock(struct mutex *
>  
>  EXPORT_SYMBOL(mutex_unlock);
>  
> +#ifdef CONFIG_SMP
> +static int adaptive_wait(struct mutex_waiter *waiter,
> +			 struct task_struct *owner, long state)
> +{
> +	for (;;) {
> +		if (signal_pending_state(state, waiter->task))
> +			return 0;
> +		if (waiter->lock->owner != owner)
> +			return 0;
> +		if (!task_is_current(owner))
> +			return 1;
> +		cpu_relax();
> +	}
> +}
> +#else

Linus, what do you think about this particular approach of spin-mutexes? 
It's not the typical spin-mutex i think.

The thing i like most about Peter's patch (compared to most other adaptive 
spinning approaches i've seen, which all sucked as they included various 
ugly heuristics complicating the whole thing) is that it solves the "how 
long should we spin" question elegantly: we spin until the owner runs on a 
CPU.

So on shortly held locks we degenerate to spinlock behavior, and only 
long-held blocking locks [with little CPU time spent while holding the 
lock - say we wait for IO] we degenerate to classic mutex behavior.

There's no time or spin-rate based heuristics in this at all (i.e. these 
mutexes are not 'adaptive' at all!), and it degenerates to our primary and 
well-known locking behavior in the important boundary situations.

A couple of other properties i like about it:

 - A spinlock user can be changed to a mutex with no runtime impact. (no 
   increase in scheduling) This might enable us to convert/standardize 
   some of the uglier locking constructs within ext2/3/4?

 - This mutex modification would probably be a win for workloads where
   mutexes are held briefly - we'd never schedule.

 - If the owner is preempted, we fall back to proper blocking behavior. 
   This might reduce the cost of preemptive kernels in general.

The flip side:

 - The slight increase in the hotpath - we now maintain the 'owner' field.
   That's cached in a register on most platforms anyway so it's not a too
   big deal - if the general win justifies it.

   ( This reminds me: why not flip over all the task_struct uses in 
     mutex.c to thread_info? thread_info is faster to access [on x86] 
     than current. )

 - The extra mutex->owner pointer data overhead.

 - It could possibly increase spinning overhead (and waste CPU time) on
   workloads where locks are held and contended for. OTOH, such cases are
   probably a prime target for improvements anyway. It would probably be 
   near-zero-impact for workloads where mutexes are held for a very long 
   time and where most of the time is spent blocking.

It's hard to tell how it would impact inbetween workloads - i guess it 
needs to be measured on a couple of workloads.

	Ingo
