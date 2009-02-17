Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZBQRYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZBQRYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZBQRYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:24:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53260 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZBQRYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:24:21 -0500
Date: Tue, 17 Feb 2009 18:21:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic-smp: remove kmalloc()
Message-ID: <20090217172113.GA26459@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <1234885258.4744.153.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234885258.4744.153.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Peter Zijlstra wrote:
>
> Ok, so this is on top of Nick's cleanup from earlier today, and folds
> everything.
>
> No more RCU games as the storage for per-cpu entries is permanent - cpu
> hotplug should be good because it does a synchronize_sched().
>
> What we do play games with is the global list, we can extract entries
> and place them to the front while its being observed. This means that
> the list iteration can see some entries twice (not a problem since we
> remove ourselves from the cpumask), but cannot miss entries.

I think this all is correct.

But I am wondering, don't we have another problem. Before this patch,
smp_call_function_many(wait => 0) always succeeds, no matter which
locks the caller holds.

After this patch we can deadlock, csd_lock() can spin forever if the
caller shares the lock with another func in flight.

IOW,
	void func(void *arg)
	{
		lock(LOCK);
		unlock(LOCK);
	}

CPU 0 does:

	smp_call_function(func, NULL, 0);
	lock(LOCK);
	smp_call_function(another_func, NULL, 0);
	unlock(LOCK);

If CPU 0 takes LOCK before CPU 1 calls func, the 2nd smp_call_function()
hangs in csd_lock().

I am not sure this is the real problem (even if I am right), perhaps
the answer is "don't do that".

But, otoh, afaics we can tweak generic_smp_call_function_interrupt()
a bit to avoid this problem. Something like

	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
		void (*func)(void *);
		void *info;
		int refs;

		spin_lock(&data->lock);
		if (!cpumask_test_cpu(cpu, data->cpumask)) {
			spin_unlock(&data->lock);
			continue;
		}
		cpumask_clear_cpu(cpu, data->cpumask);
		WARN_ON(data->refs == 0);
		refs = --data->refs;
		func = data->csd.func;
		info = data->csd.info;
		wait = (data->flags & CSD_FLAG_WAIT);
		spin_unlock(&data->lock);

		if (!refs) {
			spin_lock(&call_function.lock);
			list_del_rcu(&data->csd.list);
			spin_unlock(&call_function.lock);
			csd_unlock(&data->csd);
		}
		
		func(info);
		if (!refs && wait)
			csd_complete(&data->csd);
	}

I am afraid I missed something, and the code above looks wrong
because it does csd_unlock() first, then csd_complete().

But if wait == T, then nobody can reuse this per-cpu entry, the
caller of smp_call_function_many() must spin in csd_wait() on
the same CPU.

What do you think?

Oleg.

