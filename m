Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZCOUud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZCOUud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbZCOUuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:50:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:30447 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZCOUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O3pfo1dj0ydV/qkJurbGxvHOpqwmxBd6ASmGerfqLa3wQ3rg6EtqRcV/dLbkZtGL2j
         W7b4N7UxeryJkBgKXmI+/P6b2oBVtZ5Tl7tcuNP0GES05+u2yraf4HCa8LwGhLa8VsDT
         G4QUN2TIZwBCpVmBY3LzWX/7QzeX1vX5a26ps=
Date: Sun, 15 Mar 2009 21:50:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC patch 21/21] LTTng Kernel Trace Thread Flag API
Message-ID: <20090315205017.GB5212@nowhere>
References: <20090315190340.229569867@polymtl.ca> <20090315191105.594651713@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315191105.594651713@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 03:04:01PM -0400, Mathieu Desnoyers wrote:
> Add an API to set/clear the kernel wide tracing thread flags. Implemented in
> kernel/sched.c. Updates thread flags *asynchronously* while holding the tasklist
> lock.
> 
> Upon fork, the flag must be re-copied while the tasklist lock is held.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  include/linux/sched.h |    3 ++
>  kernel/fork.c         |    9 ++++++++
>  kernel/sched.c        |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 67 insertions(+)
> 
> Index: linux-2.6-lttng/include/linux/sched.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/sched.h	2009-01-09 18:15:54.000000000 -0500
> +++ linux-2.6-lttng/include/linux/sched.h	2009-01-09 18:17:50.000000000 -0500
> @@ -2300,6 +2300,9 @@ static inline void mm_init_owner(struct 
>  
>  #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
>  
> +extern void clear_kernel_trace_flag_all_tasks(void);
> +extern void set_kernel_trace_flag_all_tasks(void);
> +
>  #endif /* __KERNEL__ */
>  
>  #endif
> Index: linux-2.6-lttng/kernel/fork.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/fork.c	2009-01-09 18:17:38.000000000 -0500
> +++ linux-2.6-lttng/kernel/fork.c	2009-01-09 18:17:50.000000000 -0500
> @@ -1218,6 +1218,15 @@ static struct task_struct *copy_process(
>  			!cpu_online(task_cpu(p))))
>  		set_task_cpu(p, smp_processor_id());
>  
> +	/*
> +	 * The state of the parent's TIF_KTRACE flag may have changed
> +	 * since it was copied in dup_task_struct() so we re-copy it here.
> +	 */
> +	if (test_thread_flag(TIF_KERNEL_TRACE))
> +		set_tsk_thread_flag(p, TIF_KERNEL_TRACE);
> +	else
> +		clear_tsk_thread_flag(p, TIF_KERNEL_TRACE);
> +


I thought about that too. But the thread info is already
copied on a fork right? Which includes the thread flags.

But perhaps I'm wrong and miss one detail about this copy...


>  	/* CLONE_PARENT re-uses the old parent */
>  	if (clone_flags & (CLONE_PARENT|CLONE_THREAD))
>  		p->real_parent = current->real_parent;
> Index: linux-2.6-lttng/kernel/sched.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/sched.c	2009-01-09 18:17:38.000000000 -0500
> +++ linux-2.6-lttng/kernel/sched.c	2009-01-09 18:17:50.000000000 -0500
> @@ -9395,3 +9395,58 @@ struct cgroup_subsys cpuacct_subsys = {
>  	.subsys_id = cpuacct_subsys_id,
>  };
>  #endif	/* CONFIG_CGROUP_CPUACCT */
> +
> +static DEFINE_MUTEX(kernel_trace_mutex);
> +static int kernel_trace_refcount;
> +
> +/**
> + * clear_kernel_trace_flag_all_tasks - clears all TIF_KERNEL_TRACE thread flags.
> + *
> + * This function iterates on all threads in the system to clear their
> + * TIF_KERNEL_TRACE flag. Setting the TIF_KERNEL_TRACE flag with the
> + * tasklist_lock held in copy_process() makes sure that once we finish clearing
> + * the thread flags, all threads have their flags cleared.
> + */
> +void clear_kernel_trace_flag_all_tasks(void)
> +{
> +	struct task_struct *p;
> +	struct task_struct *t;
> +
> +	mutex_lock(&kernel_trace_mutex);
> +	if (--kernel_trace_refcount)
> +		goto end;
> +	read_lock(&tasklist_lock);
> +	do_each_thread(p, t) {
> +		clear_tsk_thread_flag(t, TIF_KERNEL_TRACE);
> +	} while_each_thread(p, t);
> +	read_unlock(&tasklist_lock);
> +end:
> +	mutex_unlock(&kernel_trace_mutex);
> +}
> +EXPORT_SYMBOL_GPL(clear_kernel_trace_flag_all_tasks);
> +
> +/**
> + * set_kernel_trace_flag_all_tasks - sets all TIF_KERNEL_TRACE thread flags.
> + *
> + * This function iterates on all threads in the system to set their
> + * TIF_KERNEL_TRACE flag. Setting the TIF_KERNEL_TRACE flag with the
> + * tasklist_lock held in copy_process() makes sure that once we finish setting
> + * the thread flags, all threads have their flags set.
> + */
> +void set_kernel_trace_flag_all_tasks(void)
> +{
> +	struct task_struct *p;
> +	struct task_struct *t;
> +
> +	mutex_lock(&kernel_trace_mutex);
> +	if (kernel_trace_refcount++)
> +		goto end;
> +	read_lock(&tasklist_lock);
> +	do_each_thread(p, t) {
> +		set_tsk_thread_flag(t, TIF_KERNEL_TRACE);
> +	} while_each_thread(p, t);
> +	read_unlock(&tasklist_lock);
> +end:
> +	mutex_unlock(&kernel_trace_mutex);
> +}
> +EXPORT_SYMBOL_GPL(set_kernel_trace_flag_all_tasks);


Speaking about optimizations and latency. If you want to avoid
the overhead of a whole tasklist iteration making any writer spinning on
you, may be you can iterate it using rcu.

But it can be slightly racy in that you could miss a freshly inserted
task while playing with a nano delayed version of the list. So this is not
necessarily a good idea.


> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

