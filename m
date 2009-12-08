Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbZLHIjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbZLHIjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZLHIjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:39:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56002 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbZLHIjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:39:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Amerigo Wang <amwang@redhat.com>
Subject: Re: [RFC Patch] getrusage: fill ru_ixrss, ru_idrss and ru_isrss fields
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Jiri Pirko <jpirko@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091208083358.4232.28469.sendpatchset@localhost.localdomain>
References: <20091208083358.4232.28469.sendpatchset@localhost.localdomain>
Message-Id: <20091208173730.B5C3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Dec 2009 17:39:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Currently we always get 0 for ru_ixrss etc. fields with getrusage()
> or wait4(). However, GNU time (i.e. /usr/bin/time) uses these fields
> to report some statistics, thus we get no useful info if we don't have
> a chance to read /proc/<pid>/status.
> 
> Jiri worked on this many days ago, but didn't get the patch merged.
> After reading all the discussion in that thread [1], I rework on
> this, without introducing new fields for task_struct, without using
> CONFIG_TASK_XACCT.
> 
> In my patch, I first make vm_stat_account() independent of CONFIG_PROC_FS,
> so that we can continue to use it to do statistics without procfs.
> Then add the corresponding fields in signal_struct, and fill them
> in the right place with the values from mm_struct.
> 
> A quick test is here:
> 
> % strace -v -ewait4 /usr/bin/time -f '%X %p %t' cat /proc/self/status
> wait4(4294967295, Name:	cat
> ...
> VmPeak:	   58916 kB
> VmSize:	   58916 kB
> VmLck:	       0 kB
> VmHWM:	     476 kB
> VmRSS:	     476 kB
> VmData:	     172 kB
> VmStk:	      84 kB
> VmExe:	      20 kB
> VmLib:	    1444 kB
> VmPTE:	      40 kB
> ...
> [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, {ru_utime={0, 0}, ru_stime={0, 999}, ru_maxrss=512, ru_ixrss=1464, ru_idrss=172, ru_isrss=84, ru_minflt=160, ru_majflt=0, ru_nswap=0, ru_inblock=0, ru_oublock=0, ru_msgsnd=0, ru_msgrcv=0, ru_nsignals=0, ru_nvcsw=1, ru_nivcsw=1}) = 4962
> --- SIGCHLD (Child exited) @ 0 (0) ---
> 0 0 0
> 
> 
> Please review. Any comments are welcome.
> 
> 1. http://lkml.org/lkml/2009/1/15/290
> 
> Cc: Jiri Pirko <jpirko@redhat.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 24c3956..c2607ab 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1245,14 +1245,7 @@ typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
>  extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
>  			       unsigned long size, pte_fn_t fn, void *data);
>  
> -#ifdef CONFIG_PROC_FS
>  void vm_stat_account(struct mm_struct *, unsigned long, struct file *, long);
> -#else
> -static inline void vm_stat_account(struct mm_struct *mm,
> -			unsigned long flags, struct file *file, long pages)
> -{
> -}
> -#endif /* CONFIG_PROC_FS */
>  
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  extern int debug_pagealloc_enabled;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 89115ec..175ef61 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -631,6 +631,7 @@ struct signal_struct {
>  	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
>  	unsigned long inblock, oublock, cinblock, coublock;
>  	unsigned long maxrss, cmaxrss;
> +	unsigned long ixrss, isrss, idrss, cixrss, cisrss, cidrss;
>  	struct task_io_accounting ioac;
>  
>  	/*
> @@ -1546,6 +1547,30 @@ struct task_struct {
>  	unsigned long stack_start;
>  };
>  
> +static inline unsigned long get_task_ixrss(struct task_struct *p)
> +{
> +	if (p->mm)
> +		return p->mm->exec_vm * (PAGE_SIZE / 1024);
> +	return 0;
> +}
> +static inline unsigned long get_task_isrss(struct task_struct *p)
> +{
> +	if (p->mm)
> +		return p->mm->stack_vm * (PAGE_SIZE / 1024);
> +	return 0;
> +}
> +static inline unsigned long get_task_idrss(struct task_struct *p)
> +{
> +	struct mm_struct *mm = p->mm;
> +	unsigned long size;
> +
> +	if (mm) {
> +		size = mm->total_vm - mm->shared_vm - mm->stack_vm;
> +		return size * (PAGE_SIZE / 1024);
> +	}
> +	return 0;
> +}

Sorry NAK. Hugh already explained the reason. quote here

	But on looking closer, there's a stronger reason to oppose this patch.
	You're trying to add support for the struct rusage fields
		long	ru_maxrss;		/* maximum resident set size */
		long	ru_ixrss;		/* integral shared memory size */
		long	ru_idrss;		/* integral unshared data size */
		long	ru_isrss;		/* integral unshared stack size */
	And your previous patch added support for the first of those fields,
	correctly based on hiwater of anon_rss+file_rss already accounted.
	The next three fields, the subject of this patch, are named ru_XXrss:
	though the 80-column comment omits to say "resident set" before "size",
	I believe they'd be expected to account (subdivided) resident set sizes?


your calculation is not rss nor not integral.





