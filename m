Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZIQPYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZIQPYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZIQPYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:24:04 -0400
Received: from www.tglx.de ([62.245.132.106]:53621 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbZIQPYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:24:01 -0400
Date: Thu, 17 Sep 2009 17:23:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: futex: wakeup race and futex_q woken state definition
In-Reply-To: <4AB25076.8020406@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0909171719260.2889@localhost.localdomain>
References: <4AB17A08.50008@us.ibm.com> <alpine.LFD.2.00.0909170939080.2889@localhost.localdomain> <4AB25076.8020406@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009, Darren Hart wrote:
> > 	/*
> > 	 * !plist_node_empty() is safe here without any lock.
> > 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
> > 	 */
> > 	if (likely(!plist_node_empty(&q->list))) {
> > 
> > If we move set_current_state() before the queue_me() this check is
> > still an optimization to avoid the schedule call in case we have been
> > woken up already. But the comment is still wrong as the wakeup code
> > has changed:
> > 
> > The old version did:
> > 
> >      plist_del(&q->list);
> >      wake_up_all(&q->waiters);
> >      q->lock_ptr = NULL;
> > 
> > Today we do:
> > 
> >      p = q->task;
> >      get_task_struct(p);
> >      plist_del(&q->list);
> >      q->lock_ptr = NULL;
> >      wake_up_state(p);
> >      put_task_struct(p);
> > 
> > We changed this because it makes no sense to use a waitqueue for a
> > single task.
> 
> Right.
> 
> 
> However, my bigger concern still remains.  If the above is only an
> optimization, we appear to have a race with wakeup where we can see a
> non-empty list here and decide to schedule and have the wakeup code remove us
> from the list, hiding it from all future futex related wakeups (signal and
> timeout would still work).

No.

Sleeper does:

	set_current_state(TASK_INTERRUPTIBLE);
	
	if (!plist_empty())
	   schedule();

So when the list removal happened before set_current_state() we don't
schedule. If the wakeup happens _after_ set_current_state() then the
wake_up_state() call will bring us back to running.

> We have also been seeing a race with the requeue_pi code with a JVM benchmark
> where the apparent owner of the pi mutex remains blocked on the condvar - this
> can be explained by the race I'm suspecting.  Also, futex_requeue_pi() is
> using futex_wait_queue_me() which expects the waker to remove the futex_q from
> the list, which isn't how things work for PI mutexes.  In an experiment, I
> moved the spin_unlock() out of queueme() and right before the call to
> schedule() to narrow the race window, and the hang we were experiencing
> appears to have gone away.

The correct thing to do is to move set_current_state() before queue_me().

Thanks,

	tglx
