Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZAFS0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZAFS0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZAFS0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:26:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZAFS02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:26:28 -0500
Date: Tue, 6 Jan 2009 10:25:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
In-Reply-To: <alpine.LFD.2.00.0901060948220.3057@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901061013250.3057@localhost.localdomain>
References: <1230722935.4680.5.camel@think.oraclecorp.com>  <20081231104533.abfb1cf9.akpm@linux-foundation.org>  <1230765549.7538.8.camel@think.oraclecorp.com>  <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>  <1231093310.27690.5.camel@twins>
  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <alpine.LFD.2.00.0901060948220.3057@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Linus Torvalds wrote:
> 
> Sure - the owner may have rescheduled to another CPU, but if it did that, 
> then we really might as well sleep.

.. or at least re-try the loop.

It might be worth it to move the whole sleeping behavior into that helper 
function (mutex_spin_or_sleep()), and just make the logic be:

 - if we _enter_ the function with the owner not on a runqueue, then we 
   sleep

 - otherwise, we spin as long as the owner stays on the same runqueue.

and then we loop over the whole "get mutex spinlock and revalidate it all" 
after either sleeping or spinning for a while.

That seems much simpler in all respects. And it should simplify the whole 
patch too, because it literally means that in the main 
__mutex_lock_common(), the only real difference is

	-             __set_task_state(task, state);
	-             spin_unlock_mutex(&lock->wait_lock, flags);
	-             schedule();

becoming instead

	+		mutex_spin_or_schedule(owner, task, lock, state);

and then all the "spin-or-schedule" logic is in just that one simple 
routine (that has to look up the rq and drop the lock and re-take it).

The "mutex_spin_or_schedule()" code would literally look something like

	void mutex_spin_or_schedule(owner, task, lock, state)
	{
		struct rq *owner_rq = owner->rq;

		if (owner_rq->curr != owner) {
			__set_task_state(task, state);
			spin_unlock_mutex(&lock->wait_lock, flags);
			schedule();
		} else {
			spin_unlock_mutex(&lock->wait_lock, flags);
			do {
				cpu_relax();
			while (lock->owner == owner &&
				owner_rq->curr == owner);
		}
		spin_lock_mutex(&lock->wait_lock, flags);
	}

or something.

Btw, this also fixes a bug: your patch did

	+                     __set_task_state(task, state);
	+                     /* didnt get the lock, go to sleep: */
	+                     schedule();

for the schedule case without holding the mutex spinlock.

And that seems very buggy and racy indeed: since it doesn't hold the mutex 
lock, if the old owner releases the mutex at just the right point (yeah, 
yeah, it requires a scheduling event on another CPU in order to also miss 
the whole "task_is_current()" logic), the wakeup can get lost, because you 
set the state to sleeping perhaps _after_ the task just got woken up. So 
we stay sleeping even though the mutex is clear.

So I'm going to NAK the original patch, and just -require- the cleanup I'm 
suggesting as also fixing what looks like a bug.

Of course, once I see the actual patch, maybe I'm going to find something 
_else_ to kwetch about.

			Linus
