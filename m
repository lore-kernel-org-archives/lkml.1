Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbZEEKSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbZEEKSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZEEKSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:18:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:35533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbZEEKSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:18:35 -0400
Date: Tue, 5 May 2009 12:18:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@android.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] oom: move oom_adj value from task_struct to mm_struct
Message-ID: <20090505101834.GB28917@wotan.suse.de>
References: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com> <alpine.DEB.2.00.0905041725590.11756@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905041725590.11756@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 05:27:04PM -0700, David Rientjes wrote:
> The per-task oom_adj value is a characteristic of its mm more than the
> task itself since it's not possible to oom kill any thread that shares
> the mm.  If a task were to be killed while attached to an mm that could
> not be freed because another thread were set to OOM_DISABLE, it would
> have needlessly been terminated since there is no potential for future
> memory freeing.

True.

 
> This patch moves oomkilladj (now more appropriately named oom_adj) from
> struct task_struct to struct mm_struct.  This requires task_lock() on a
> task to check its oom_adj value to protect against exec, but it's already
> necessary to take the lock when dereferencing the mm to find the total VM
> size for the badness heuristic.
> 
> Taking task_lock() in select_bad_process() to check for OOM_DISABLE and
> in oom_kill_task() to check for threads sharing the same memory will be
> removed in the next patch in this series where it will no longer be
> necessary.
> 
> Writing to /proc/pid/oom_adj for a kthread will now return -EINVAL since
> these threads are immune from oom killing already.  They simply report an
> oom_adj value of OOM_DISABLE.

Hmm, not particularly bad to do any of this, but I guess the way to
do it without changing userspace APIs would be to take the lowest
value of oomkilladj for any thread in the mm and use that.

I guess the previous behaviour was basically quite random anyway if
multiple threads each have different oomkilladj variables so it
probably doesn't matter.

I don't suppose you'd ever get a significantly advanced (aka crazy)
userspace app that would want to deliberately set *one* of its threads
as OOM_DISABLE and others allowed to be killed, would we?

> 
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: San Mehat <san@android.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  Documentation/filesystems/proc.txt        |   15 +++++++++----
>  drivers/staging/android/lowmemorykiller.c |    2 +-
>  fs/proc/base.c                            |   19 ++++++++++++++--
>  include/linux/mm_types.h                  |    2 +
>  include/linux/sched.h                     |    1 -
>  mm/oom_kill.c                             |   32 ++++++++++++++++++----------
>  6 files changed, 49 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -1003,11 +1003,13 @@ CHAPTER 3: PER-PROCESS PARAMETERS
>  3.1 /proc/<pid>/oom_adj - Adjust the oom-killer score
>  ------------------------------------------------------
>  
> -This file can be used to adjust the score used to select which processes
> -should be killed in an  out-of-memory  situation.  Giving it a high score will
> -increase the likelihood of this process being killed by the oom-killer.  Valid
> -values are in the range -16 to +15, plus the special value -17, which disables
> -oom-killing altogether for this process.
> +This file can be used to adjust the score used to select which processes should
> +be killed in an out-of-memory situation.  The oom_adj value is a characteristic
> +of the task's mm, so all threads that share an mm with pid will have the same
> +oom_adj value.  A high value will increase the liklihood of this process being
> +killed by the oom-killer.  Valid values are in the range -16 to +15 as
> +explained below and a special value of -17, which disables oom-killing
> +altogether for threads sharing pid's mm.
>  
>  The process to be killed in an out-of-memory situation is selected among all others
>  based on its badness score. This value equals the original memory size of the process
> @@ -1021,6 +1023,9 @@ the parent's score if they do not share the same memory. Thus forking servers
>  are the prime candidates to be killed. Having only one 'hungry' child will make
>  parent less preferable than the child.
>  
> +/proc/<pid>/oom_adj cannot be changed for kthreads since they are immune from
> +oom-killing already.
> +
>  /proc/<pid>/oom_score shows process' current badness score.
>  
>  The following heuristics are then applied:
> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -97,7 +97,7 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>  			task_unlock(p);
>  			continue;
>  		}
> -		oom_adj = p->oomkilladj;
> +		oom_adj = p->mm->oom_adj;
>  		if (oom_adj < min_adj) {
>  			task_unlock(p);
>  			continue;
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1003,7 +1003,12 @@ static ssize_t oom_adjust_read(struct file *file, char __user *buf,
>  
>  	if (!task)
>  		return -ESRCH;
> -	oom_adjust = task->oomkilladj;
> +	task_lock(task);
> +	if (task->mm)
> +		oom_adjust = task->mm->oom_adj;
> +	else
> +		oom_adjust = OOM_DISABLE;
> +	task_unlock(task);
>  	put_task_struct(task);
>  
>  	len = snprintf(buffer, sizeof(buffer), "%i\n", oom_adjust);
> @@ -1032,11 +1037,19 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
>  	task = get_proc_task(file->f_path.dentry->d_inode);
>  	if (!task)
>  		return -ESRCH;
> -	if (oom_adjust < task->oomkilladj && !capable(CAP_SYS_RESOURCE)) {
> +	task_lock(task);
> +	if (!task->mm) {
> +		task_unlock(task);
> +		put_task_struct(task);
> +		return -EINVAL;
> +	}
> +	if (oom_adjust < task->mm->oom_adj && !capable(CAP_SYS_RESOURCE)) {
> +		task_unlock(task);
>  		put_task_struct(task);
>  		return -EACCES;
>  	}
> -	task->oomkilladj = oom_adjust;
> +	task->mm->oom_adj = oom_adjust;
> +	task_unlock(task);
>  	put_task_struct(task);
>  	if (end - buffer == 0)
>  		return -EIO;
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -232,6 +232,8 @@ struct mm_struct {
>  
>  	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
>  
> +	s8 oom_adj;	/* OOM kill score adjustment (bit shift) */
> +
>  	cpumask_t cpu_vm_mask;
>  
>  	/* Architecture-specific MM context */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1149,7 +1149,6 @@ struct task_struct {
>  	 * a short time
>  	 */
>  	unsigned char fpu_counter;
> -	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
>  #ifdef CONFIG_BLK_DEV_IO_TRACE
>  	unsigned int btrace_seq;
>  #endif
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -58,6 +58,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  	unsigned long points, cpu_time, run_time;
>  	struct mm_struct *mm;
>  	struct task_struct *child;
> +	int oom_adj;
>  
>  	task_lock(p);
>  	mm = p->mm;
> @@ -65,6 +66,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  		task_unlock(p);
>  		return 0;
>  	}
> +	oom_adj = mm->oom_adj;
>  
>  	/*
>  	 * The memory size of the process is the basis for the badness.
> @@ -148,15 +150,15 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  		points /= 8;
>  
>  	/*
> -	 * Adjust the score by oomkilladj.
> +	 * Adjust the score by oom_adj.
>  	 */
> -	if (p->oomkilladj) {
> -		if (p->oomkilladj > 0) {
> +	if (oom_adj) {
> +		if (oom_adj > 0) {
>  			if (!points)
>  				points = 1;
> -			points <<= p->oomkilladj;
> +			points <<= oom_adj;
>  		} else
> -			points >>= -(p->oomkilladj);
> +			points >>= -(oom_adj);
>  	}
>  
>  #ifdef DEBUG
> @@ -251,8 +253,10 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
>  			*ppoints = ULONG_MAX;
>  		}
>  
> -		if (p->oomkilladj == OOM_DISABLE)
> +		task_lock(p);
> +		if (p->mm && p->mm->oom_adj == OOM_DISABLE)
>  			continue;
> +		task_unlock(p);
>  
>  		points = badness(p, uptime.tv_sec);
>  		if (points > *ppoints || !chosen) {
> @@ -304,8 +308,7 @@ static void dump_tasks(const struct mem_cgroup *mem)
>  		}
>  		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
>  		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
> -		       get_mm_rss(mm), (int)task_cpu(p), p->oomkilladj,
> -		       p->comm);
> +		       get_mm_rss(mm), (int)task_cpu(p), mm->oom_adj, p->comm);
>  		task_unlock(p);
>  	} while_each_thread(g, p);
>  }
> @@ -367,8 +370,12 @@ static int oom_kill_task(struct task_struct *p)
>  	 * Don't kill the process if any threads are set to OOM_DISABLE
>  	 */
>  	do_each_thread(g, q) {
> -		if (q->mm == mm && q->oomkilladj == OOM_DISABLE)
> +		task_lock(q);
> +		if (q->mm == mm && q->mm && q->mm->oom_adj == OOM_DISABLE) {
> +			task_unlock(q);
>  			return 1;
> +		}
> +		task_unlock(q);
>  	} while_each_thread(g, q);
>  
>  	__oom_kill_task(p, 1);
> @@ -393,10 +400,11 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	struct task_struct *c;
>  
>  	if (printk_ratelimit()) {
> -		printk(KERN_WARNING "%s invoked oom-killer: "
> -			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
> -			current->comm, gfp_mask, order, current->oomkilladj);
>  		task_lock(current);
> +		printk(KERN_WARNING "%s invoked oom-killer: "
> +			"gfp_mask=0x%x, order=%d, oom_adj=%d\n",
> +			current->comm, gfp_mask, order,
> +			current->mm ? current->mm->oom_adj : OOM_DISABLE);
>  		cpuset_print_task_mems_allowed(current);
>  		task_unlock(current);
>  		dump_stack();
