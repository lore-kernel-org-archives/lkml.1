Return-Path: <linux-kernel-owner+w=401wt.eu-S1161217AbXDEFzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161217AbXDEFzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 01:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161218AbXDEFzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 01:55:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:23302 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161217AbXDEFzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 01:55:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=o+mSMYb1k3bA4N0KW2PA4aCO61QsQ1AGZkAlewa4xqiaxEcgXIgudiRBaNksRZrrB
	/UqjL6DSS2Zak5vcMXnVQ==
Message-ID: <6599ad830704042255t5c126a0cj86d644cb8174e177@mail.gmail.com>
Date: Wed, 4 Apr 2007 22:55:01 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Cc: "Paul Jackson" <pj@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Balbir Singh" <balbir@in.ibm.com>
In-Reply-To: <20070326115506.GL11794@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070325164746.GI11794@in.ibm.com>
	 <20070325125025.b6e8f0d4.pj@sgi.com>
	 <20070326115506.GL11794@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Sun, Mar 25, 2007 at 12:50:25PM -0700, Paul Jackson wrote:
> > Is there perhaps another race here?
>
> Yes, we have!
>
> Modified patch below. Compile/boot tested on a x86_64 box.
>
>
> Currently cpuset_exit() changes the exiting task's ->cpuset pointer w/o
> taking task_lock(). This can lead to ugly races between attach_task and
> cpuset_exit. Details of the races are described at
> http://lkml.org/lkml/2007/3/24/132.
>
> Patch below closes those races. It is against 2.6.21-rc4 and has
> undergone a simple compile/boot test on a x86_64 box.
>
> Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>
>
>
> ---
>
>
> diff -puN kernel/cpuset.c~cpuset_race_fix kernel/cpuset.c
> --- linux-2.6.21-rc4/kernel/cpuset.c~cpuset_race_fix    2007-03-25 21:08:27.000000000 +0530
> +++ linux-2.6.21-rc4-vatsa/kernel/cpuset.c      2007-03-26 16:48:24.000000000 +0530
> @@ -1182,6 +1182,7 @@ static int attach_task(struct cpuset *cs
>         pid_t pid;
>         struct task_struct *tsk;
>         struct cpuset *oldcs;
> +       struct cpuset *oldcs_to_be_released = NULL;
>         cpumask_t cpus;
>         nodemask_t from, to;
>         struct mm_struct *mm;
> @@ -1237,6 +1238,8 @@ static int attach_task(struct cpuset *cs
>         }
>         atomic_inc(&cs->count);
>         rcu_assign_pointer(tsk->cpuset, cs);
> +       if (atomic_dec_and_test(&oldcs->count))
> +               oldcs_to_be_released = oldcs;
>         task_unlock(tsk);
>
>         guarantee_online_cpus(cs, &cpus);
> @@ -1257,8 +1260,8 @@ static int attach_task(struct cpuset *cs
>
>         put_task_struct(tsk);
>         synchronize_rcu();
> -       if (atomic_dec_and_test(&oldcs->count))
> -               check_for_release(oldcs, ppathbuf);
> +       if (oldcs_to_be_released)
> +               check_for_release(oldcs_to_be_released, ppathbuf);
>         return 0;
>  }

Is this part of the patch necessary? If we're adding a task_lock() in
cpuset_exit(), then the problem that Vatsa described (both
cpuset_attach_task() and cpuset_exit() decrementing the same cpuset
count, and cpuset_attach_task() incrementing the count on a cpuset
that the task doesn't eventually end up in) go away, since only one
thread will retrieve the old value of the task's cpuset in order to
decrement its count.


>
> @@ -2200,10 +2203,6 @@ void cpuset_fork(struct task_struct *chi
>   * it is holding that mutex while calling check_for_release(),
>   * which calls kmalloc(), so can't be called holding callback_mutex().
>   *
> - * We don't need to task_lock() this reference to tsk->cpuset,
> - * because tsk is already marked PF_EXITING, so attach_task() won't
> - * mess with it, or task is a failed fork, never visible to attach_task.
> - *
>   * the_top_cpuset_hack:
>   *
>   *    Set the exiting tasks cpuset to the root cpuset (top_cpuset).
> @@ -2241,20 +2240,23 @@ void cpuset_fork(struct task_struct *chi
>  void cpuset_exit(struct task_struct *tsk)
>  {
>         struct cpuset *cs;
> +       struct cpuset *oldcs_to_be_released = NULL;
>
> +       task_lock(tsk);
>         cs = tsk->cpuset;
>         tsk->cpuset = &top_cpuset;      /* the_top_cpuset_hack - see above */
> +       if (atomic_dec_and_test(&cs->count))
> +               oldcs_to_be_released = cs;
> +       task_unlock(tsk);
>

I think this is still racy - at this point we're holding a reference
on a cpuset that could have a zero count, and we don't hold
manage_mutex or callback_mutex. So a concurrent rmdir could zap the
directory and free the cpuset.

Shouldn't we just put a task_lock()/task_unlock() around these lines
and leave everything else as-is?

	task_lock(tsk);
	cs = tsk->cpuset;
	tsk->cpuset = &top_cpuset;	/* the_top_cpuset_hack - see above */
	task_unlock(tsk)

Paul
