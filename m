Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZBTQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZBTQoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZBTQop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:44:45 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51606 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZBTQoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:44:44 -0500
Date: Fri, 20 Feb 2009 08:44:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090220164441.GG6960@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu> <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com> <20090220154619.GC6960@linux.vnet.ibm.com> <20090220160409.GB11294@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220160409.GB11294@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 05:04:09PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Fri, Feb 20, 2009 at 03:51:28PM +0100, Vegard Nossum wrote:
> > > 2009/2/20 Ingo Molnar <mingo@elte.hu>:
> > > >
> > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > >
> > > >> ah, indeed:
> > > >>
> > > >>         list_del_rcu(&va->list);
> > > >>
> > > >> i suspect it could be hit big time in a workload that opens
> > > >> more than 512 files, as expand_files() uses a
> > > >> vmalloc()+vfree() pair in that case.
> > > >
> > > > hm, perhaps it's not a problem after all. The freeing is done
> > > > via rcu, and list_del_rcu() leaves the forward pointer intact.
> > > 
> > > Well, it's not the particular line that you posted, in any case.
> > > That's &va->list, but the traversed list is &va->purge_list.
> > > 
> > > I thought it would be the line:
> > > 
> > >         call_rcu(&va->rcu_head, rcu_free_va);
> > > 
> > > (which does kfree() in the callback) that was the problem.
> > > 
> > > > So how did it happen that the entry got kfree()d before the loop
> > > > was done? We are in a spinlocked section so the CPU should not
> > > > have entered rcu processing.
> > > 
> > > I added some printks to __free_vmap_area() and rcu_free_va(), and it
> > > shows that the kfree() is being called immediately (inside the list
> > > traversal). So the call_rcu() is happening immediately (or almost
> > > immediately).
> > > 
> > > If I've understood correctly, the RCU processing can happen inside a
> > > spinlock, as long as interrupts are enabled. (Won't the timer IRQ
> > > trigger softirq processing, which triggers RCU callback processing,
> > > for example?)
> > > 
> > > And interrupts are enabled when this happens: EFLAGS: 00000292
> > > 
> > > Please correct me if I am wrong!
> > 
> > If you are using preemptable RCU, and if the read side 
> > accesses are not protected by rcu_read_lock(), this can 
> > happen.  At least for values of "immediately" in the 
> > millisecond range.
> > 
> > If you were using classic or hierarchical RCU, the fact that 
> > the call_rcu() is within a spinlock (as opposed to mutex) 
> > critical section should prevent the grace period from ending.
> > 
> > So, what flavor of RCU were you using?
> 
> well, even in preemptible RCU the grace period should be 
> extended as long as we are non-preempt (which we are here), 
> correct?

Given Classic RCU, you are quite correct.  With preemptable RCU, if
there are no readers, and if irqs are enabled, the grace period could
end within the spinlock's critical section.  Of course, the spinlock
would need to be held for an improbably long time -- many milliseconds.

The only thing that is -guaranteed- to block RCU read-side critical
sections is some task being in an RCU read-side critical section.

The way a preemptable RCU grace period could end, even with some CPU
having preemption disabled, is as follows:

o	Because there are no RCU readers anywhere in the system,
	both sides of the per-CPU rcu_flipctr[] array sum to zero.

o	Because irqs are enabled, scheduling-clock interrupts
	still happen.  The state machine sequences as follows:

	o	rcu_try_flip_idle() on the CPU that did the call_rcu()
		sees that rcu_pending() returns 1, and therefore
		increments the rcu_ctrlblk.completed counter, starting a
		new grace period.  It also sets each CPU's rcu_flip_flag
		to rcu_flipped, which requests acknowledgement of the
		counter increment.

	o	Each CPU's scheduling-clock interrupt will note that
		the rcu_ctrlblk.completed counter has advanced, and
		will therefore invoke __rcu_advance_callbacks, which
		will set that CPU's rcu_flip_flag to rcu_flip_seen.

	o	The scheduling-clock interrupt (on any CPU) following
		the last __rcu_advance_callbacks() will now invoke
		rcu_try_flip_waitack(), which will find that all CPUs'
		rcu_mb_flag values are rcu_mb_done.  It will return
		non-zero indicating that the state machine should advance.

	o	The next scheduling-clock interrupt will therefore invoke
		rcu_try_flip_waitzero(), which, because there are no
		RCU readers, will find that the sum of the rcu_flipctr[]
		entries will be zero.  This function will therefore
		return non-zero indicating that the state machine should
		advance.  Before returning, it will set each CPU's
		rcu_mb_flag to rcu_mb_needed to indicate that each CPU
		must execute a memory 

	o	Each CPU's rcu_check_mb(), also invoked during the
		scheduling-clock interrupt, executes a memory barrier
		and sets the per-CPU rcu_mb_flag to rcu_mb_done.

	o	The scheduling-clock interrupt (on any CPU) following the
		last rcu_check_mb() will now invoke rcu_try_flip_waitmb(),
		which iwll find that all CPUs' rcu_mb_flag variables are
		equal to rcu_mb_done, and will therefore return non-zero.

	This process will repeat, and then the callback will be invoked,
	freeing the element.

Unlike Classic RCU, disabled preemption does not block RCU grace periods.
Disabled irqs currently happen to block preemptable RCU grace periods,
but that is simply a side-effect of the implementation.  It is not
guaranteed, and any code that disables irqs to block RCU grace periods
should be viewed with great suspicion, if not viewed as buggy.

> Preemptible RCU does make an rcu_read_lock() critical section 
> preemptible, so if this were protected by rcu_read_lock() it 
> would be a bug. But it does not make spin_lock() section 
> preemptible, and this is a spin_lock(&vmap_area_lock) section:
> 
>                 spin_lock(&vmap_area_lock);
> -               list_for_each_entry(va, &valist, purge_list)
> +               list_for_each_entry_safe(va, n_va, &valist, purge_list)
>                        	__free_vmap_area(va);
>                 spin_unlock(&vmap_area_lock);

Again, the only thing -guaranteed- to block preemptable RCU grace
periods is some task residing in an RCU read-side critical section.

						Thanx, Paul
