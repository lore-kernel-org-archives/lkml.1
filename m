Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbZLaONM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbZLaONM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 09:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZLaONM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 09:13:12 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42183 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZLaONL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 09:13:11 -0500
Date: Thu, 31 Dec 2009 23:12:22 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] proc: revert to show stack information in /proc/{pid}/status
Cc: kosaki.motohiro@jp.fujitsu.com, Stefani Seibold <stefani@seibold.net>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d899bf7b (procfs: provide stack information for threads) introduced
to show stack information in /proc/{pid}/status. But it cause large performance
regression. Unfortunately /proc/{pid}/status is used ps command too and ps is
one of most important component. Because both to take mmap_sem and page table walk
are heavily operation.

if many process run, the ps performance is,

[before d899bf7b]

% perf stat ps >/dev/null

 Performance counter stats for 'ps':

     4090.435806  task-clock-msecs         #      0.032 CPUs
             229  context-switches         #      0.000 M/sec
               0  CPU-migrations           #      0.000 M/sec
             234  page-faults              #      0.000 M/sec
      8587565207  cycles                   #   2099.425 M/sec
      9866662403  instructions             #      1.149 IPC
      3789415411  cache-references         #    926.409 M/sec
        30419509  cache-misses             #      7.437 M/sec

   128.859521955  seconds time elapsed

[after d899bf7b]

% perf stat  ps  > /dev/null

 Performance counter stats for 'ps':

     4305.081146  task-clock-msecs         #      0.028 CPUs
             480  context-switches         #      0.000 M/sec
               2  CPU-migrations           #      0.000 M/sec
             237  page-faults              #      0.000 M/sec
      9021211334  cycles                   #   2095.480 M/sec
     10605887536  instructions             #      1.176 IPC
      3612650999  cache-references         #    839.160 M/sec
        23917502  cache-misses             #      5.556 M/sec

   152.277819582  seconds time elapsed

Thus, this patch revert it. Fortunately /proc/{pid}/task/{tid}/smaps
provide almost same information. we can use it.

Cc: Stefani Seibold <stefani@seibold.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 Documentation/filesystems/proc.txt |    2 -
 fs/proc/array.c                    |   89 ------------------------------------
 2 files changed, 0 insertions(+), 91 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 220cc63..0d07513 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -177,7 +177,6 @@ read the file /proc/PID/status:
   CapBnd: ffffffffffffffff
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
-  Stack usage:    12 kB
 
 This shows you nearly the same information you would get if you viewed it with
 the ps  command.  In  fact,  ps  uses  the  proc  file  system  to  obtain its
@@ -231,7 +230,6 @@ Table 1-2: Contents of the statm files (as of 2.6.30-rc7)
  Mems_allowed_list           Same as previous, but in "list format"
  voluntary_ctxt_switches     number of voluntary context switches
  nonvoluntary_ctxt_switches  number of non voluntary context switches
- Stack usage:                stack usage high water mark (round up to page size)
 ..............................................................................
 
 Table 1-3: Contents of the statm files (as of 2.6.8-rc3)
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 2e5c2a3..b8df659 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -322,94 +322,6 @@ static inline void task_context_switch_counts(struct seq_file *m,
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
-{
-	struct stack_stats *ss = walk->private;
-	struct vm_area_struct *vma = ss->vma;
-	pte_t *pte, ptent;
-	spinlock_t *ptl;
-	int ret = 0;
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
-		ptent = *pte;
-
-#ifdef CONFIG_STACK_GROWSUP
-		if (pte_present(ptent) || is_swap_pte(ptent))
-			ss->usage = addr - ss->startpage + PAGE_SIZE;
-#else
-		if (pte_present(ptent) || is_swap_pte(ptent)) {
-			ss->usage = ss->startpage - addr + PAGE_SIZE;
-			pte++;
-			ret = 1;
-			break;
-		}
-#endif
-	}
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
-}
-#endif		/* CONFIG_MMU */
-
 static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
 {
 	seq_printf(m, "Cpus_allowed:\t");
@@ -440,7 +352,6 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	task_show_regs(m, task);
 #endif
 	task_context_switch_counts(m, task);
-	task_show_stack_usage(m, task);
 	return 0;
 }
 
-- 
1.6.6



