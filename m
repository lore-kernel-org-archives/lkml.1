Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbZLRUrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbZLRUrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZLRUry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:47:54 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57540 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbZLRUrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:47:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w/6XEwLyLIF1clEG3nP8Y2m1fDSRbT/m9x6hgr1tSfAMCniF4KmFkgLhOKOeK5cK2p
         3del88Bw9x0WIq5EyPsygO0G6vO7a9zVH+WtBhhKCanglDNGf1ScL4U7NrCOhe6WgI8W
         NfwEs+sn++2fNYggij54Mrrf+qebUDMWRTDic=
Date: Fri, 18 Dec 2009 21:47:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch 1/1] Introduce register_user_hbp_by_pid() and
	unregister_user_hbp_by_pid()
Message-ID: <20091218204744.GC5004@nowhere>
References: <20091217172010.GB5457@in.ibm.com> <20091217172253.GC5457@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217172253.GC5457@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 10:52:53PM +0530, K.Prasad wrote:
> Provide an interface to (un)register user-space breakpoints using a
> process' pid.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  include/linux/hw_breakpoint.h |    8 +++
>  kernel/hw_breakpoint.c        |   92 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 100 insertions(+)
> 
> Index: linux-2.6-tip.reg_by_pid/include/linux/hw_breakpoint.h
> ===================================================================
> --- linux-2.6-tip.reg_by_pid.orig/include/linux/hw_breakpoint.h
> +++ linux-2.6-tip.reg_by_pid/include/linux/hw_breakpoint.h
> @@ -54,6 +54,10 @@ register_user_hw_breakpoint(struct perf_
>  			    perf_overflow_handler_t triggered,
>  			    struct task_struct *tsk);
>  
> +extern int register_user_hbp_by_pid(struct perf_event_attr *attr,
> +			 perf_overflow_handler_t triggered,
> +			 pid_t pid);
> +extern void unregister_user_hbp_by_pid(pid_t pid);
>  /* FIXME: only change from the attr, and don't unregister */
>  extern int
>  modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr);
> @@ -91,6 +95,10 @@ static inline struct perf_event *
>  register_user_hw_breakpoint(struct perf_event_attr *attr,
>  			    perf_overflow_handler_t triggered,
>  			    struct task_struct *tsk)	{ return NULL; }
> +int register_user_hbp_by_pid(struct perf_event_attr *attr,
> +			 perf_overflow_handler_t triggered,
> +			 pid_t pid)	{ return 0; }
> +void unregister_user_hbp_by_pid(pid_t pid) {}
>  static inline int
>  modify_user_hw_breakpoint(struct perf_event *bp,
>  			  struct perf_event_attr *attr)	{ return -ENOSYS; }
> Index: linux-2.6-tip.reg_by_pid/kernel/hw_breakpoint.c
> ===================================================================
> --- linux-2.6-tip.reg_by_pid.orig/kernel/hw_breakpoint.c
> +++ linux-2.6-tip.reg_by_pid/kernel/hw_breakpoint.c
> @@ -298,6 +298,98 @@ int register_perf_hw_breakpoint(struct p
>  	return ret;
>  }
>  
> +/*
> + * Unregister breakpoints thread-by-thread, for all threads ranging from
> + * @start to @end.
> + */
> +static inline void __unregister_user_hbp_for_threads(struct task_struct *start,
> +						struct task_struct *end)



I'm not sure this wants to be inlined. The function is not not
that tiny. May be let the compiler choose?


> +{
> +	struct perf_event *bp, *temp_bp;
> +
> +	do {
> +		mutex_lock(&start->perf_event_mutex);
> +		list_for_each_entry_safe(bp, temp_bp, &start->perf_event_list,
> +					 owner_entry) {
> +			if (bp->attr.type != PERF_TYPE_BREAKPOINT)
> +				continue;
> +			unregister_hw_breakpoint(bp);
> +			break;



Do you really want to unregister all of them? What about those
that may have been registered using perf syscall?

> +/**
> + * register_user_hbp_by_pid - register a hardware breakpoint for user space using pid
> + * @attr: breakpoint attributes
> + * @triggered: callback to trigger when we hit the breakpoint
> + * @pid: pid of the thread group for which breakpoints must be registered
> + */
> +int register_user_hbp_by_pid(struct perf_event_attr *attr,
> +			 perf_overflow_handler_t triggered,
> +			 pid_t pid)
> +{
> +	int ret;
> +	struct task_struct *t1, *t2;



This needs rcu_read_lock()



> +	t1 = t2 = find_task_by_vpid(pid);
> +	if (t1 == NULL)
> +		return -ESRCH;
> +
> +	/*
> +	 * Ensure that the breakpoint propogates to every new thread created in
> +	 * this thread_group.
> +	 */
> +	attr->inherit = 1;
> +	/*
> +	 * Register a breakpoint individually for every thread of the
> +	 * thread_group using register_user_hw_breakpoint() interface.
> +	 * Warning: Involves redundant validation checks using
> +	 * arch_validate_hwbkpt_settings().
> +	 */
> +	do {
> +		ret = IS_ERR(register_user_hw_breakpoint(attr, triggered, t1));
> +		if (ret)
> +			goto fail;
> +		t1 = next_thread(t1);
> +	} while (t1 != t2);


And this needs rcu_read_unlock()



> +	return 0;
> +fail:
> +	/*
> +	 * Check if the very first register_user_hw_breakpoint() request
> +	 * failed. If then, do nothing but return the error value.
> +	 */
> +	if (t1 == t2)
> +		return ret;
> +	/*
> +	 * Since there exists a thread where the breakpoint request was not
> +	 * successful, we are unable to provide a process-wide breakpoint. Hence
> +	 * cleanup the breakpoints from the previously registered threads.
> +	 */
> +	__unregister_user_hbp_for_threads(t2, t1);


There too.

Once you play with tasks (if it's not current), and iterate
through these, you need to protect either by read-lock
tasklist_lock or using rcu.

Rcu is the much prefered way here.


> +/**
> + * unregister_hbp_by_pid - unregister a user-space hardware breakpoint previously registered using a pid
> + * @pid: pid of the process for which breakpoint must be unregistered
> + */
> +void unregister_user_hbp_by_pid(pid_t pid)
> +{
> +	struct task_struct *t1, *t2;
> +
> +	t1 = t2 = find_task_by_vpid(pid);
> +	if (t1 == NULL)
> +		return;
> +
> +	__unregister_user_hbp_for_threads(t1, t2);



And this function needs rcu too.

I don't see any in-kernel user for this new feature.
That would be required to integrate it.

Thanks.

