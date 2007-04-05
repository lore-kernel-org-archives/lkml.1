Return-Path: <linux-kernel-owner+w=401wt.eu-S1945994AbXDEGxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945994AbXDEGxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945985AbXDEGxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:53:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53195 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945994AbXDEGxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:53:04 -0400
Date: Thu, 5 Apr 2007 12:30:33 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Paul Jackson" <pj@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Balbir Singh" <balbir@in.ibm.com>
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Message-ID: <20070405070033.GB3435@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070325164746.GI11794@in.ibm.com> <20070325125025.b6e8f0d4.pj@sgi.com> <20070326115506.GL11794@in.ibm.com> <6599ad830704042255t5c126a0cj86d644cb8174e177@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704042255t5c126a0cj86d644cb8174e177@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 10:55:01PM -0700, Paul Menage wrote:
> >@@ -1257,8 +1260,8 @@ static int attach_task(struct cpuset *cs
> >
> >        put_task_struct(tsk);
> >        synchronize_rcu();
> >-       if (atomic_dec_and_test(&oldcs->count))
> >-               check_for_release(oldcs, ppathbuf);
> >+       if (oldcs_to_be_released)
> >+               check_for_release(oldcs_to_be_released, ppathbuf);
> >        return 0;
> > }
> 
> Is this part of the patch necessary? If we're adding a task_lock() in
> cpuset_exit(), then the problem that Vatsa described (both
> cpuset_attach_task() and cpuset_exit() decrementing the same cpuset
> count, and cpuset_attach_task() incrementing the count on a cpuset
> that the task doesn't eventually end up in) go away, since only one
> thread will retrieve the old value of the task's cpuset in order to
> decrement its count.

You *have* to drop/inc the refcount inside the task_lock, otherwise it is
racy.

	task_lock(T1);
	old_cs = T1->cputset (C1)
	atomic_inc(&C2->count);
	T1->cputset = C2;
	task_unlock();

	...

	synchronize_rcu();

	if (atomic_dec_and_test(&C1->count))
		check_for_release(..)

is incorrect. For ex: T1's refcount on C1 may have already been dropped
by now in cpuset_exit() and dropping the refcount again can lead to
negative refcounts. 
		.
> > void cpuset_exit(struct task_struct *tsk)
> > {
> >        struct cpuset *cs;
> >+       struct cpuset *oldcs_to_be_released = NULL;
> >
> >+       task_lock(tsk);
> >        cs = tsk->cpuset;
> >        tsk->cpuset = &top_cpuset;      /* the_top_cpuset_hack - see above 
> >        */
> >+       if (atomic_dec_and_test(&cs->count))
> >+               oldcs_to_be_released = cs;
> >+       task_unlock(tsk);
> >
> 
> I think this is still racy - at this point we're holding a reference
> on a cpuset that could have a zero count,

How's that possible? That you have a zero-refcount cpuset with non empty
tasks in it?

> and we don't hold
> manage_mutex or callback_mutex. So a concurrent rmdir could zap the
> directory and free the cpuset.

I don't think that is possible. Can you explain?

> Shouldn't we just put a task_lock()/task_unlock() around these lines
> and leave everything else as-is?
> 
> 	task_lock(tsk);
> 	cs = tsk->cpuset;
> 	tsk->cpuset = &top_cpuset;	/* the_top_cpuset_hack - see above */
> 	task_unlock(tsk)

If we don't drop refcount inside task_lock() it makes it racy with
attach_task(). 'cs' derived above may not be the right cpuset to drop
refcount on later in cpuset_exit.

-- 
Regards,
vatsa
