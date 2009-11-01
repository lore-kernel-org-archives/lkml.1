Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZKAOkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZKAOkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 09:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZKAOkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 09:40:04 -0500
Received: from www84.your-server.de ([213.133.104.84]:36242 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZKAOkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 09:40:03 -0500
Subject: Re: [PATCH] proc: remove /proc/*/status "Stack usage:"
From: Stefani Seibold <stefani@seibold.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091101131518.GA18284@x200>
References: <20091101131518.GA18284@x200>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 01 Nov 2009 15:39:57 +0100
Message-ID: <1257086397.31587.5.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 01.11.2009, 16:15 +0300 schrieb Alexey Dobriyan:
> We have /proc/*/pagemap to determine how much stack was consumed.
> Leave "threadstack" though.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 

Stop! /proc/*/pagemap is not a real substitute for the stackm usage
patch. If you have problems with this patch i will have a look on it.

>  fs/proc/array.c |   90 --------------------------------------------------------
>  1 file changed, 90 deletions(-)
> 
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -82,7 +82,6 @@
>  #include <linux/pid_namespace.h>
>  #include <linux/ptrace.h>
>  #include <linux/tracehook.h>
> -#include <linux/swapops.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/processor.h>
> @@ -322,94 +321,6 @@ static inline void task_context_switch_counts(struct seq_file *m,
>  			p->nivcsw);
>  }
>  
> -#ifdef CONFIG_MMU
> -
> -struct stack_stats {
> -	struct vm_area_struct *vma;
> -	unsigned long	startpage;
> -	unsigned long	usage;
> -};
> -
> -static int stack_usage_pte_range(pmd_t *pmd, unsigned long addr,
> -				unsigned long end, struct mm_walk *walk)
> -{
> -	struct stack_stats *ss = walk->private;
> -	struct vm_area_struct *vma = ss->vma;
> -	pte_t *pte, ptent;
> -	spinlock_t *ptl;
> -	int ret = 0;
> -
> -	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> -	for (; addr != end; pte++, addr += PAGE_SIZE) {
> -		ptent = *pte;
> -
> -#ifdef CONFIG_STACK_GROWSUP
> -		if (pte_present(ptent) || is_swap_pte(ptent))
> -			ss->usage = addr - ss->startpage + PAGE_SIZE;
> -#else
> -		if (pte_present(ptent) || is_swap_pte(ptent)) {
> -			ss->usage = ss->startpage - addr + PAGE_SIZE;
> -			pte++;
> -			ret = 1;
> -			break;
> -		}
> -#endif
> -	}
> -	pte_unmap_unlock(pte - 1, ptl);
> -	cond_resched();
> -	return ret;
> -}
> -
> -static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
> -				struct task_struct *task)
> -{
> -	struct stack_stats ss;
> -	struct mm_walk stack_walk = {
> -		.pmd_entry = stack_usage_pte_range,
> -		.mm = vma->vm_mm,
> -		.private = &ss,
> -	};
> -
> -	if (!vma->vm_mm || is_vm_hugetlb_page(vma))
> -		return 0;
> -
> -	ss.vma = vma;
> -	ss.startpage = task->stack_start & PAGE_MASK;
> -	ss.usage = 0;
> -
> -#ifdef CONFIG_STACK_GROWSUP
> -	walk_page_range(KSTK_ESP(task) & PAGE_MASK, vma->vm_end,
> -		&stack_walk);
> -#else
> -	walk_page_range(vma->vm_start, (KSTK_ESP(task) & PAGE_MASK) + PAGE_SIZE,
> -		&stack_walk);
> -#endif
> -	return ss.usage;
> -}
> -
> -static inline void task_show_stack_usage(struct seq_file *m,
> -						struct task_struct *task)
> -{
> -	struct vm_area_struct	*vma;
> -	struct mm_struct	*mm = get_task_mm(task);
> -
> -	if (mm) {
> -		down_read(&mm->mmap_sem);
> -		vma = find_vma(mm, task->stack_start);
> -		if (vma)
> -			seq_printf(m, "Stack usage:\t%lu kB\n",
> -				get_stack_usage_in_bytes(vma, task) >> 10);
> -
> -		up_read(&mm->mmap_sem);
> -		mmput(mm);
> -	}
> -}
> -#else
> -static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
> -{
> -}
> -#endif		/* CONFIG_MMU */
> -
>  int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
>  			struct pid *pid, struct task_struct *task)
>  {
> @@ -429,7 +340,6 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
>  	task_show_regs(m, task);
>  #endif
>  	task_context_switch_counts(m, task);
> -	task_show_stack_usage(m, task);
>  	return 0;
>  }
>  


