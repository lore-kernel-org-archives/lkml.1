Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZK0I5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZK0I5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 03:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZK0I5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 03:57:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:58274 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751470AbZK0I5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 03:57:41 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18BMaV9vMgBMUAJ4cNZpnqB1f7A2HvGkfyA0ftp3s
	ei8GnaSs53FJus
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259311550.6110.241.camel@marge.simson.net>
References: <1258891664.14325.30.camel@marge.simson.net>
	 <1259252785.31676.216.camel@laptop>
	 <1259311550.6110.241.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 27 Nov 2009 09:57:44 +0100
Message-Id: <1259312264.7747.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-27 at 09:45 +0100, Mike Galbraith wrote:
> Off list

Guess not, mouse went click on the way to save menu.  Oh well, was going
to spare thousands of mailboxes another confused /me message, but too
late now.

> On Thu, 2009-11-26 at 17:26 +0100, Peter Zijlstra wrote:
> > On Sun, 2009-11-22 at 13:07 +0100, Mike Galbraith wrote:
> > > @@ -2589,16 +2588,10 @@ void sched_fork(struct task_struct *p, i
> > >          */
> > >         p->prio = current->normal_prio;
> > >  
> > > -       if (!rt_prio(p->prio))
> > > +       if (!task_has_rt_policy(p))
> > >                 p->sched_class = &fair_sched_class;
> > >  
> > > -#ifdef CONFIG_SMP
> > > -       cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
> > > -#endif
> > > -       local_irq_save(flags);
> > > -       update_rq_clock(cpu_rq(cpu));
> > > -       set_task_cpu(p, cpu);
> > > -       local_irq_restore(flags);
> > > +       __set_task_cpu(p, cpu); 
> > 
> > OK, so I figured out why it was in sched_fork() and not in
> > wake_up_new_task().
> > 
> > It is because in sched_fork() the new task isn't in the tasklist yet and
> > can therefore not race with any other migration logic.
> 
> All the raciness I'm fretting over probably just doesn't matter much.
> Things aren't exploding.  Maybe min_vruntime is the only thing I should
> be worrying about.  That concern is in-flight deltas of SCHED_IDLE
> magnitude, ie cross cpu "fuzziness" on a very large scale.
> 
> However :-/  (aw sh*t, here i go again.  aaaaOOOOOgah! dive! dive!;)
> 
> WRT affinity, sched_class, nice level fretting, that can all change from
> userland at any instant that you do not hold the task's runqueue lock
> and the tasklist lock is not held by somebody to keep them from getting
> a task reference to start the ball rolling.  As soon as you drop the
> runqueue lock, userland can acquire, and change whatever it likes under
> you, so afaikt, we can call the wrong sched_class method etc etc.
> 
> 3f029d3 agrees fully wrt sched_class at least:
>     In addition, we fix a race condition where we try to access
>     current->sched_class without holding the rq->lock.  This is
>     technically racy, as the sched-class could change out from
>     under us.  Instead, we reference the per-rq post_schedule
>     variable with the runqueue unlocked, but with preemption
>     disabled to see if we need to reacquire the rq->lock.
> 
> The only thing that really changes with the unlocked _rummaging_ is that
> we now can't count on nr_running/load on the task's current runqueue,
> sched_class etc while you're rummaging, ALL state is fuzzy, instead of
> only most.
> 
> However, I don't think we can even count on the task remaining untouched
> while in TASK_WAKING state, and that might be a bigger deal.
> 
> afaikt, userland can migrate the task you're in the process of waking
> while you're off rummaging around looking for a place to put it, like
> so:  Wakee is on the tasklist, can be accessed by userland.  We wouldn't
> be in ttwu either were it not.  We're waking, we set task state to
> TASK_WAKING, release the lock, userland acquires, nobody but ttwu has
> ever heard of a TASK_WAKING, so it happily changes task's affinity,
> migrates the sleeping task to the one and only (pins) correct runqueue,
> sets task cpu etc, releases the lock, and goes home.  We finish
> rummaging, do NOT check for an intervening affinity change, instead, we
> do an unlocked scribble over what userland just wrote, resetting cpu and
> vruntime to a now illegal cpu, and activate.  I'm not seeing any
> inhibitor for this scenario.
> 
> When I moved fork balancing runqueue selection to the much more logical
> wakeup and enqueue time, vs copy and fiddle time, I didn't fix anything,
> I merely duplicated the races that are now in ttwu.
> 
> No matter were we do the selection, we can race with userland if the
> darn thing isn't locked all the while.  With .31 ttwu locking, there is
> no race, because nobody can get to the task struct.  If target cpu
> changes via rq selection, we set cpu, _then_ unlock, at which point
> userland or whomever may override _our_ decision, but we never write
> after re-acquiring, so intervening changes, if any, stay intact.
> 
> With an exec, userland policy/affinity change will deactivate/activate
> or do a migration call.  We don't have the thing locked while we're
> rummaging, so what keeps sched_class from changing after we evaluated,
> so we call the wrong method, and then do our own migration call?
> 
> /me is still pretty befuddled, and haven't even crawled over PI.
> 
> I flat don't see how we can do this race free, unless we put every task
> in some untouchable state while we're rummaging, and teach everything
> having to do with migration about that state.
> 
> 	-Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

