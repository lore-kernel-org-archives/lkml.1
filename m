Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZIXEHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZIXEHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 00:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZIXEHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 00:07:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55052 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbZIXEHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 00:07:39 -0400
Date: Thu, 24 Sep 2009 14:07:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stefani Seibold <stefani@seibold.net>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20090924140738.3b8ab138.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
fs/proc/array.c between commit d899bf7b55f503ba7d3d07ed27c3a37e270fa7db
("procfs: provide stack information for threads") from Linus' tree and
commit d01d4827858cdc2e1c437c87ab65ec0a00fd40f8 ("sched: Always show
Cpus_allowed field in /proc/<pid>/status") from the tip tree.

Just overlapping additions.  I fixed it up (see below) and can cay the
fix for a while. This appears to be fixed the same way in tip:master.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/proc/array.c
index 0c6bc60,762aea9..0000000
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@@ -322,87 -321,16 +322,97 @@@ static inline void task_context_switch_
  			p->nivcsw);
  }
  
 +struct stack_stats {
 +	struct vm_area_struct *vma;
 +	unsigned long	startpage;
 +	unsigned long	usage;
 +};
 +
 +static int stack_usage_pte_range(pmd_t *pmd, unsigned long addr,
 +				unsigned long end, struct mm_walk *walk)
 +{
 +	struct stack_stats *ss = walk->private;
 +	struct vm_area_struct *vma = ss->vma;
 +	pte_t *pte, ptent;
 +	spinlock_t *ptl;
 +	int ret = 0;
 +
 +	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 +	for (; addr != end; pte++, addr += PAGE_SIZE) {
 +		ptent = *pte;
 +
 +#ifdef CONFIG_STACK_GROWSUP
 +		if (pte_present(ptent) || is_swap_pte(ptent))
 +			ss->usage = addr - ss->startpage + PAGE_SIZE;
 +#else
 +		if (pte_present(ptent) || is_swap_pte(ptent)) {
 +			ss->usage = ss->startpage - addr + PAGE_SIZE;
 +			pte++;
 +			ret = 1;
 +			break;
 +		}
 +#endif
 +	}
 +	pte_unmap_unlock(pte - 1, ptl);
 +	cond_resched();
 +	return ret;
 +}
 +
 +static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
 +				struct task_struct *task)
 +{
 +	struct stack_stats ss;
 +	struct mm_walk stack_walk = {
 +		.pmd_entry = stack_usage_pte_range,
 +		.mm = vma->vm_mm,
 +		.private = &ss,
 +	};
 +
 +	if (!vma->vm_mm || is_vm_hugetlb_page(vma))
 +		return 0;
 +
 +	ss.vma = vma;
 +	ss.startpage = task->stack_start & PAGE_MASK;
 +	ss.usage = 0;
 +
 +#ifdef CONFIG_STACK_GROWSUP
 +	walk_page_range(KSTK_ESP(task) & PAGE_MASK, vma->vm_end,
 +		&stack_walk);
 +#else
 +	walk_page_range(vma->vm_start, (KSTK_ESP(task) & PAGE_MASK) + PAGE_SIZE,
 +		&stack_walk);
 +#endif
 +	return ss.usage;
 +}
 +
 +static inline void task_show_stack_usage(struct seq_file *m,
 +						struct task_struct *task)
 +{
 +	struct vm_area_struct	*vma;
 +	struct mm_struct	*mm = get_task_mm(task);
 +
 +	if (mm) {
 +		down_read(&mm->mmap_sem);
 +		vma = find_vma(mm, task->stack_start);
 +		if (vma)
 +			seq_printf(m, "Stack usage:\t%lu kB\n",
 +				get_stack_usage_in_bytes(vma, task) >> 10);
 +
 +		up_read(&mm->mmap_sem);
 +		mmput(mm);
 +	}
 +}
 +
+ static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
+ {
+ 	seq_printf(m, "Cpus_allowed:\t");
+ 	seq_cpumask(m, &task->cpus_allowed);
+ 	seq_printf(m, "\n");
+ 	seq_printf(m, "Cpus_allowed_list:\t");
+ 	seq_cpumask_list(m, &task->cpus_allowed);
+ 	seq_printf(m, "\n");
+ }
+ 
  int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
  			struct pid *pid, struct task_struct *task)
  {
