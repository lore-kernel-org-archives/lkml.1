Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbYLSTky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbYLSTky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYLSTkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:40:46 -0500
Received: from www.tglx.de ([62.245.132.106]:41421 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYLSTkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:40:45 -0500
Date: Fri, 19 Dec 2008 20:40:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
Subject: Re: [patch 4/7] rtmutex: unify state manipulation
In-Reply-To: <alpine.DEB.1.10.0812191309540.26432@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0812192031270.3376@localhost.localdomain>
References: <20081219155504.735865178@linutronix.de> <20081219155556.103531550@linutronix.de> <alpine.DEB.1.10.0812191309540.26432@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Steven Rostedt wrote:
> > +	} while (cmpxchg(&current->state, state, block_state) != state);
> 
> Doesn't this break archs that do not have cmpxchg?

We can use xchg. The waiter is protected against the RUNNING_MUTEX
state change via the mutex->lock. It's just some overcautioness when I
started to fix this.

> There might be another way. We could just use your TASK_RUNNING_MUTEX or 
> trick for both mutexes and spinlocks.

The mechanisms should be the same for everything now.
 
> > -	if (mtx)
> > -		set_current_state(TASK_RUNNING);
> > -	else {
> > -		state = xchg(&current->state, saved_state);
> > -		if (unlikely(state == TASK_RUNNING))
> > -			current->state = TASK_RUNNING;
> > -	}
> > +	rt_restore_current_state(saved_state);
> 
> This is a bug. A mutex always leaves in the TASK_RUNNING state.
 
Duh, yes. So this should be:

     rt_restore_current_state(!mtx ? saved_state : TASK_RUNNING);

> What about having the locking spinlocks and mutexes be almost identical. 
> Like the rwlocks are (rwlocks and rwsems share the same code). We can use 
> the RT_MUTEX_RUNNING trick for both. The only difference is that a mutex 
> will always leave in the TASK_RUNNING state.

Good point.

Thanks,

	tglx
