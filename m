Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZAZWSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZAZWSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbZAZWSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:18:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36493 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbZAZWR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:17:59 -0500
Date: Mon, 26 Jan 2009 23:15:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090126221502.GA4542@redhat.com>
References: <200901261711.43943.rusty@rustcorp.com.au> <20090125230130.bcdab2e5.akpm@linux-foundation.org> <20090126171618.GA32091@elte.hu> <20090126103529.cb124a58.akpm@linux-foundation.org> <20090126202022.GA8867@elte.hu> <20090126130046.37b8f34e.akpm@linux-foundation.org> <20090126212727.GA13670@elte.hu> <20090126133551.fab5e27a.akpm@linux-foundation.org> <20090126214516.GA22142@elte.hu> <20090126140116.35f9c173.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126140116.35f9c173.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Andrew Morton wrote:
>
> On Mon, 26 Jan 2009 22:45:16 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
> > that would change the concept of execution but indeed it would be 
> > interesting to try. It's outside the scope of late -rcs i guess, but 
> > worthwile nevertheless.
> >
>
> Well it turns out that I was having a less-than-usually-senile moment:
>
> : commit b89deed32ccc96098bd6bc953c64bba6b847774f
> : Author:     Oleg Nesterov <oleg@tv-sign.ru>
> : AuthorDate: Wed May 9 02:33:52 2007 -0700
> : Commit:     Linus Torvalds <torvalds@woody.linux-foundation.org>
> : CommitDate: Wed May 9 12:30:50 2007 -0700
> : 
> :     implement flush_work()
> :     
> :     A basic problem with flush_scheduled_work() is that it blocks behind _all_
> :     presently-queued works, rather than just the work whcih the caller wants to
> :     flush.  If the caller holds some lock, and if one of the queued work happens
> :     to want that lock as well then accidental deadlocks can occur.
> :     
> :     One example of this is the phy layer: it wants to flush work while holding
> :     rtnl_lock().  But if a linkwatch event happens to be queued, the phy code will
> :     deadlock because the linkwatch callback function takes rtnl_lock.
> :     
> :     So we implement a new function which will flush a *single* work - just the one
> :     which the caller wants to free up.  Thus we avoid the accidental deadlocks
> :     which can arise from unrelated subsystems' callbacks taking shared locks.
> :     
> :     flush_work() non-blockingly dequeues the work_struct which we want to kill,
> :     then it waits for its handler to complete on all CPUs.
> :     
> :     Add ->current_work to the "struct cpu_workqueue_struct", it points to
> :     currently running "struct work_struct". When flush_work(work) detects
> :     ->current_work == work, it inserts a barrier at the _head_ of ->worklist
> :     (and thus right _after_ that work) and waits for completition. This means
> :     that the next work fired on that CPU will be this barrier, or another
> :     barrier queued by concurrent flush_work(), so the caller of flush_work()
> :     will be woken before any "regular" work has a chance to run.
> :     
> :     When wait_on_work() unlocks workqueue_mutex (or whatever we choose to protect
> :     against CPU hotplug), CPU may go away. But in that case take_over_work() will
> :     move a barrier we queued to another CPU, it will be fired sometime, and
> :     wait_on_work() will be woken.
> :     
> :     Actually, we are doing cleanup_workqueue_thread()->kthread_stop() before
> :     take_over_work(), so cwq->thread should complete its ->worklist (and thus
> :     the barrier), because currently we don't check kthread_should_stop() in
> :     run_workqueue(). But even if we did, everything should be ok.
> 
> 
> Why isn't that working in this case??

Cough. Because that "flush_work()" was renamed to cancel_work_sync(). Because
it really cancells the work_struct if it can.

Now we have flush_work() which does not cancel, but waits for completion of
the single work_struct. Of course, it can hang if the caller holds the lock
which can be taken by another work in that workqueue.

Oleg.

