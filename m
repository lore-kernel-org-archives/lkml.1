Return-Path: <linux-kernel-owner+w=401wt.eu-S1160998AbXDEHCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160998AbXDEHCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 03:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXDEHCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 03:02:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24478 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160998AbXDEHCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 03:02:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=wUf5tOBMMFBiPtO4qkg96RQ+EF9eUc3q8EDlZQ19CepEKE86eCzVS4J3Qfz+FgSPU
	1Wt2zoMmYDABnpisKBzFw==
Message-ID: <6599ad830704050001n50d9fa2bw4167c1fa16aa618f@mail.gmail.com>
Date: Thu, 5 Apr 2007 00:01:53 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Cc: "Paul Jackson" <pj@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Balbir Singh" <balbir@in.ibm.com>
In-Reply-To: <20070405070033.GB3435@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070325164746.GI11794@in.ibm.com>
	 <20070325125025.b6e8f0d4.pj@sgi.com>
	 <20070326115506.GL11794@in.ibm.com>
	 <6599ad830704042255t5c126a0cj86d644cb8174e177@mail.gmail.com>
	 <20070405070033.GB3435@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Wed, Apr 04, 2007 at 10:55:01PM -0700, Paul Menage wrote:
> > >@@ -1257,8 +1260,8 @@ static int attach_task(struct cpuset *cs
> > >
> > >        put_task_struct(tsk);
> > >        synchronize_rcu();
> > >-       if (atomic_dec_and_test(&oldcs->count))
> > >-               check_for_release(oldcs, ppathbuf);
> > >+       if (oldcs_to_be_released)
> > >+               check_for_release(oldcs_to_be_released, ppathbuf);
> > >        return 0;
> > > }
> >
> > Is this part of the patch necessary? If we're adding a task_lock() in
> > cpuset_exit(), then the problem that Vatsa described (both
> > cpuset_attach_task() and cpuset_exit() decrementing the same cpuset
> > count, and cpuset_attach_task() incrementing the count on a cpuset
> > that the task doesn't eventually end up in) go away, since only one
> > thread will retrieve the old value of the task's cpuset in order to
> > decrement its count.
>
> You *have* to drop/inc the refcount inside the task_lock, otherwise it is
> racy.
>
>         task_lock(T1);
>         old_cs = T1->cputset (C1)
>         atomic_inc(&C2->count);
>         T1->cputset = C2;
>         task_unlock();
>
>         ...
>
>         synchronize_rcu();
>
>         if (atomic_dec_and_test(&C1->count))
>                 check_for_release(..)
>
> is incorrect. For ex: T1's refcount on C1 may have already been dropped
> by now in cpuset_exit() and dropping the refcount again can lead to
> negative refcounts.

I don't see how that could happen. Assuming we add the
task_lock()/task_unlock() in cpuset_exit(), then only one of the two
threads (either cpuset_exit() or attach_task() ) can copy C1 from
T1->cpuset and replace it with something new, and hence only one of
them can drop the refcount.

>                 .
> > > void cpuset_exit(struct task_struct *tsk)
> > > {
> > >        struct cpuset *cs;
> > >+       struct cpuset *oldcs_to_be_released = NULL;
> > >
> > >+       task_lock(tsk);
> > >        cs = tsk->cpuset;
> > >        tsk->cpuset = &top_cpuset;      /* the_top_cpuset_hack - see above
> > >        */
> > >+       if (atomic_dec_and_test(&cs->count))
> > >+               oldcs_to_be_released = cs;
> > >+       task_unlock(tsk);
> > >
> >
> > I think this is still racy - at this point we're holding a reference
> > on a cpuset that could have a zero count,
>
> How's that possible? That you have a zero-refcount cpuset with non empty
> tasks in it?

If this is the last task in cs, then cs->count will be 1. We remove
this task from cs, and decrement its count to 0. Then another cpu does
cpuset_rmdir(), takes manage_mutex, sees that the count is 0, cleans
up the cpuset, drops the dentry, and the cpuset gets freed. Then we
get to run again, and we dereference an invalid cpuset.

>
> > Shouldn't we just put a task_lock()/task_unlock() around these lines
> > and leave everything else as-is?
> >
> >       task_lock(tsk);
> >       cs = tsk->cpuset;
> >       tsk->cpuset = &top_cpuset;      /* the_top_cpuset_hack - see above */
> >       task_unlock(tsk)
>
> If we don't drop refcount inside task_lock() it makes it racy with
> attach_task(). 'cs' derived above may not be the right cpuset to drop
> refcount on later in cpuset_exit.

How so? If we're holding task_lock(tsk) then we're atomic with respect
to the code in attach_task that reads the old cpuset and puts in a new
one. Only the thread that actually reads the value and replaces it
will get to drop the old value.

Paul
