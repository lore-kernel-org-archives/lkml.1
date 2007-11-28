Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbXK1BVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbXK1BVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 20:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbXK1BVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 20:21:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:48958 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXK1BVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 20:21:33 -0500
Date: Wed, 28 Nov 2007 02:21:29 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: /proc dcache deadlock in do_exit
Message-ID: <20071128012129.GD6840@v2.random>
References: <20071127132022.GW6840@v2.random> <20071127143852.601509ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127143852.601509ac.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 02:38:52PM -0800, Andrew Morton wrote:
> I don't see why the schedule() will not return?  Because the task has
> PF_EXITING set?  Doesn't TASK_DEAD do that?

Ouch, I assumed you couldn't sleep safely anymore in release_task
given it's the function that will free the task structure itself and
there was no preempt related action anywhere close to it!
delayed_put_task_struct can be called if a quiescent point is reached
and any scheduling would exactly allow it to run (it requires quite a
bit of a race, with local irq triggering a reschedule and the timer
irq invoking the tasklet to run to free the task struct before do_exit
finishes and all other cpus in quiescent state too).

So a corollary question is how can it be safe to call
preempt_disable() after call_rcu(delayed_put_task_struct)?

Back in sles9 preempt_disable was implemented as
_raw_write_unlock(&tasklist_lock) and it happened _before_
release_task, and scheduling there wouldn't return because PF_DEAD was
already set. If mainline can come back, it will crash for a different
reason because the task struct is long gone by the time
release_task+schedule() runs. Either ways, still a kernel crashing bug
there is. Or is there some magic that prevents call_rcu + schedule to
invoke the rcu callback?

So you may need to apply this one too (this one is needed to fix the
second bug, my previous patch is needed after applying this one):

Signed-off-by: Andrea Arcangeli <andrea@suse.de>

diff --git a/kernel/exit.c b/kernel/exit.c
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -841,6 +841,13 @@ static void exit_notify(struct task_stru
 
 	write_unlock_irq(&tasklist_lock);
 
+	/*
+	 * Task struct can go away at the first schedule if this was a
+	 * self reaping task. Scheduling is forbidden until we set
+	 * the state to TASK_DEAD.
+	 */
+	preempt_disable();
+
 	/* If the process is dead, release it - nobody will wait for it */
 	if (state == EXIT_DEAD)
 		release_task(tsk);
@@ -1042,7 +1049,6 @@ fastcall NORET_TYPE void do_exit(long co
 	if (tsk->splice_pipe)
 		__free_pipe_info(tsk->splice_pipe);
 
-	preempt_disable();
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
 

> What are the implications of not running shrink_dcache_parent() on
> the exit path sometimes?  We'll leave procfs stuff behind?  Will
> they be reaped by memory pressure later on?

Yes.
