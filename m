Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZG3R7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZG3R7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZG3R7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:59:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51022 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZG3R7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:59:06 -0400
Date: Thu, 30 Jul 2009 19:55:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] task_struct cleanup: move binfmt field to mm_struct
Message-ID: <20090730175547.GD3617@redhat.com>
References: <20090723161806.GA5690@redhat.com> <4A68FD3B.7040606@ct.jp.nec.com> <4A693569.1090009@ct.jp.nec.com> <20090724161449.GA3509@redhat.com> <4A6CF466.9040608@ct.jp.nec.com> <20090727165901.GA8854@redhat.com> <4A6E98DC.5020200@ct.jp.nec.com> <20090728143734.GA6664@redhat.com> <4A70EC76.6060109@ct.jp.nec.com> <4A70ECAD.203@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A70ECAD.203@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Hiroshi Shimamoto wrote:
>
> Because the binfmt is not different between threads in the same process,
> it can be moved from task_struct to mm_struct. And binfmt moudle is handled
> per mm_struct instead of task_struct.

Looks like a nice patch to me.

Oleg.

> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  fs/exec.c                |   10 ++++++----
>  include/linux/mm_types.h |    2 ++
>  include/linux/sched.h    |    1 -
>  kernel/exit.c            |    2 --
>  kernel/fork.c            |   13 +++++++------
>  5 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 6751a25..1d9b7a1 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1380,10 +1380,12 @@ out_ret:
>   */
>  void set_binfmt(struct linux_binfmt *new)
>  {
> -	if (current->binfmt)
> -		module_put(current->binfmt->module);
> +	struct mm_struct *mm = current->mm;
> +
> +	if (mm->binfmt)
> +		module_put(mm->binfmt->module);
>  
> -	current->binfmt = new;
> +	mm->binfmt = new;
>  	if (new)
>  		__module_get(new->module);
>  }
> @@ -1729,7 +1731,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  
>  	audit_core_dumps(signr);
>  
> -	binfmt = current->binfmt;
> +	binfmt = mm->binfmt;
>  	if (!binfmt || !binfmt->core_dump)
>  		goto fail;
>  
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 7acc843..6719040 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -240,6 +240,8 @@ struct mm_struct {
>  
>  	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
>  
> +	struct linux_binfmt *binfmt;
> +
>  	s8 oom_adj;	/* OOM kill score adjustment (bit shift) */
>  
>  	cpumask_t cpu_vm_mask;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 3ab08e4..940b070 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1220,7 +1220,6 @@ struct task_struct {
>  	struct mm_struct *mm, *active_mm;
>  
>  /* task state */
> -	struct linux_binfmt *binfmt;
>  	int exit_state;
>  	int exit_code, exit_signal;
>  	int pdeath_signal;  /*  The signal sent when the parent dies  */
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 869dc22..77b01be 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -970,8 +970,6 @@ NORET_TYPE void do_exit(long code)
>  		disassociate_ctty(1);
>  
>  	module_put(task_thread_info(tsk)->exec_domain->module);
> -	if (tsk->binfmt)
> -		module_put(tsk->binfmt->module);
>  
>  	proc_exit_connector(tsk);
>  
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 9b42695..653da52 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -494,6 +494,8 @@ void mmput(struct mm_struct *mm)
>  			spin_unlock(&mmlist_lock);
>  		}
>  		put_swap_token(mm);
> +		if (mm->binfmt)
> +			module_put(mm->binfmt->module);
>  		mmdrop(mm);
>  	}
>  }
> @@ -619,9 +621,14 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
>  	mm->hiwater_rss = get_mm_rss(mm);
>  	mm->hiwater_vm = mm->total_vm;
>  
> +	if (mm->binfmt && !try_module_get(mm->binfmt->module))
> +		goto free_pt;
> +
>  	return mm;
>  
>  free_pt:
> +	/* don't put binfmt in mmput, we haven't got module yet */
> +	mm->binfmt = NULL;
>  	mmput(mm);
>  
>  fail_nomem:
> @@ -1013,9 +1020,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	if (!try_module_get(task_thread_info(p)->exec_domain->module))
>  		goto bad_fork_cleanup_count;
>  
> -	if (p->binfmt && !try_module_get(p->binfmt->module))
> -		goto bad_fork_cleanup_put_domain;
> -
>  	p->did_exec = 0;
>  	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
>  	copy_flags(clone_flags, p);
> @@ -1300,9 +1304,6 @@ bad_fork_cleanup_cgroup:
>  #endif
>  	cgroup_exit(p, cgroup_callbacks_done);
>  	delayacct_tsk_free(p);
> -	if (p->binfmt)
> -		module_put(p->binfmt->module);
> -bad_fork_cleanup_put_domain:
>  	module_put(task_thread_info(p)->exec_domain->module);
>  bad_fork_cleanup_count:
>  	atomic_dec(&p->cred->user->processes);
> -- 
> 1.6.3.3
> 

