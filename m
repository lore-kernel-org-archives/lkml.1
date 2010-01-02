Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695Ab0ABOFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0ABOFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 09:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517Ab0ABOFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 09:05:33 -0500
Received: from www84.your-server.de ([213.133.104.84]:40839 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab0ABOFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 09:05:32 -0500
Subject: [PATCH] partial revert to show stack information in 
 /proc/<pid>/status
From: Stefani Seibold <stefani@seibold.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <2f11576a1001012153qec2ea0eo7a2762386ed22273@mail.gmail.com>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
	 <1262274494.14143.7.camel@wall-e>
	 <20100101155630.1A1E.A69D9226@jp.fujitsu.com>
	 <1262358616.11460.18.camel@wall-e> <20100101220529.GL4620@const>
	 <1262384490.16706.4.camel@wall-e>
	 <2f11576a1001012153qec2ea0eo7a2762386ed22273@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 02 Jan 2010 15:05:09 +0100
Message-ID: <1262441109.9108.20.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As announce here is the patch to partial revert the show stack
information patch due a not accepted performance regression. It will be
now show only the current stack usage, not the high water mark.

The path is only partial reverted because i need the other parts to do
it in an other way.

There are now two possibilities solutions:

- create a new /proc/<pid>/stackinfo entry, which provides the reverted
information and maybe others like the sigaltstack.
- create a user space tool which use /proc/<pid>/pagemap

In both cases the information of task->stack_start and the KSTK_ESP is
needed.

It will be also needed for an enhancement of the oom handler, where i
free unused stack pages (the pages before the stack pointer) under high
memory pressure. This is currently under work.

Andrew please apply this patch to 2.6.34-rc* tree.

Greetings,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 Documentation/filesystems/proc.txt |    2 
 fs/proc/array.c                    |   87 ++-----------------------------------
 2 files changed, 8 insertions(+), 81 deletions(-)

diff -u -N -r -p linux-2.6.33-rc2.orig/fs/proc/array.c linux-2.6.33-rc2.new/fs/proc/array.c
--- linux-2.6.33-rc2.orig/fs/proc/array.c	2009-12-27 23:37:04.817427024 +0100
+++ linux-2.6.33-rc2.new/fs/proc/array.c	2010-01-02 14:36:53.794188418 +0100
@@ -327,93 +327,20 @@ static inline void task_context_switch_c
 			p->nivcsw);
 }
 
-#ifdef CONFIG_MMU
-
-struct stack_stats {
-	struct vm_area_struct *vma;
-	unsigned long	startpage;
-	unsigned long	usage;
-};
-
-static int stack_usage_pte_range(pmd_t *pmd, unsigned long addr,
-				unsigned long end, struct mm_walk *walk)
+static inline void task_show_stack_usage(struct seq_file *m,
+						struct task_struct *task)
 {
-	struct stack_stats *ss = walk->private;
-	struct vm_area_struct *vma = ss->vma;
-	pte_t *pte, ptent;
-	spinlock_t *ptl;
-	int ret = 0;
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
-		ptent = *pte;
+	unsigned long		usage;
 
+	if (task->mm) {
 #ifdef CONFIG_STACK_GROWSUP
-		if (pte_present(ptent) || is_swap_pte(ptent))
-			ss->usage = addr - ss->startpage + PAGE_SIZE;
+		usage = KSTK_ESP(task) - task->stack_start;
 #else
-		if (pte_present(ptent) || is_swap_pte(ptent)) {
-			ss->usage = ss->startpage - addr + PAGE_SIZE;
-			pte++;
-			ret = 1;
-			break;
-		}
+		usage = task->stack_start - KSTK_ESP(task);
 #endif
+		seq_printf(m, "Stack usage:\t%lu kB\n", (usage + 1023) >> 10);
 	}
-	pte_unmap_unlock(pte - 1, ptl);
-	cond_resched();
-	return ret;
-}
-
-static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
-				struct task_struct *task)
-{
-	struct stack_stats ss;
-	struct mm_walk stack_walk = {
-		.pmd_entry = stack_usage_pte_range,
-		.mm = vma->vm_mm,
-		.private = &ss,
-	};
-
-	if (!vma->vm_mm || is_vm_hugetlb_page(vma))
-		return 0;
-
-	ss.vma = vma;
-	ss.startpage = task->stack_start & PAGE_MASK;
-	ss.usage = 0;
-
-#ifdef CONFIG_STACK_GROWSUP
-	walk_page_range(KSTK_ESP(task) & PAGE_MASK, vma->vm_end,
-		&stack_walk);
-#else
-	walk_page_range(vma->vm_start, (KSTK_ESP(task) & PAGE_MASK) + PAGE_SIZE,
-		&stack_walk);
-#endif
-	return ss.usage;
-}
-
-static inline void task_show_stack_usage(struct seq_file *m,
-						struct task_struct *task)
-{
-	struct vm_area_struct	*vma;
-	struct mm_struct	*mm = get_task_mm(task);
-
-	if (mm) {
-		down_read(&mm->mmap_sem);
-		vma = find_vma(mm, task->stack_start);
-		if (vma)
-			seq_printf(m, "Stack usage:\t%lu kB\n",
-				get_stack_usage_in_bytes(vma, task) >> 10);
-
-		up_read(&mm->mmap_sem);
-		mmput(mm);
-	}
-}
-#else
-static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
-{
 }
-#endif		/* CONFIG_MMU */
 
 static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
 {
diff -u -N -r -p linux-2.6.33-rc2.orig/Documentation/filesystems/proc.txt linux-2.6.33-rc2.new/Documentation/filesystems/proc.txt
--- linux-2.6.33-rc2.orig/Documentation/filesystems/proc.txt	2009-12-27 23:37:01.098310709 +0100
+++ linux-2.6.33-rc2.new/Documentation/filesystems/proc.txt	2010-01-02 14:30:39.059150340 +0100
@@ -231,7 +231,7 @@ Table 1-2: Contents of the statm files (
  Mems_allowed_list           Same as previous, but in "list format"
  voluntary_ctxt_switches     number of voluntary context switches
  nonvoluntary_ctxt_switches  number of non voluntary context switches
- Stack usage:                stack usage high water mark (round up to page size)
+ Stack usage:                stack usage in kB
 ..............................................................................
 
 Table 1-3: Contents of the statm files (as of 2.6.8-rc3)


