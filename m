Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZFXMEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZFXMEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZFXMEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:04:02 -0400
Received: from www84.your-server.de ([213.133.104.84]:56917 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZFXMEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:04:00 -0400
Subject: [patch 2/2] procfs: provide stack information for threads V0.9
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <m1my7ykrs7.fsf@fess.ebiederm.org>
References: <200906182243.n5IMhwuV003008@imap1.linux-foundation.org>
	 <1245824444.22613.3.camel@wall-e>
	 <20090623233247.7ed661b7.akpm@linux-foundation.org>
	 <1245825903.23818.4.camel@wall-e>
	 <20090624001302.18de9e21.akpm@linux-foundation.org>
	 <m1my7ykrs7.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 14:03:30 +0200
Message-Id: <1245845010.11658.25.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the newest version of the formaly named "detailed stack info"
patch which give you a better overview of the userland application stack
usage, especially for embedded linux.

Currently you are only able to dump the main process/thread stack usage
which is showed in /proc/pid/status by the "VmStk" Value. But you get no
information about the consumed stack memory of the the threads.

There is an enhancement in the /proc/<pid>/{task/*,}/*maps and which
marks the vm mapping where the thread stack pointer reside with "[thread
stack xxxxxxxx]". xxxxxxxx is the maximum size of stack. This is a
value information, because libpthread doesn't set the start of the stack
to the top of the mapped area, depending of the pthread usage.

A sample output of /proc/<pid>/task/<tid>/maps looks like:

08048000-08049000 r-xp 00000000 03:00 8312       /opt/z
08049000-0804a000 rw-p 00001000 03:00 8312       /opt/z
0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
a7d12000-a7d13000 ---p 00000000 00:00 0 
a7d13000-a7f13000 rw-p 00000000 00:00 0          [thread stack: 001ff4b4]
a7f13000-a7f14000 ---p 00000000 00:00 0 
a7f14000-a7f36000 rw-p 00000000 00:00 0 
a7f36000-a8069000 r-xp 00000000 03:00 4222       /lib/libc.so.6
a8069000-a806b000 r--p 00133000 03:00 4222       /lib/libc.so.6
a806b000-a806c000 rw-p 00135000 03:00 4222       /lib/libc.so.6
a806c000-a806f000 rw-p 00000000 00:00 0 
a806f000-a8083000 r-xp 00000000 03:00 14462      /lib/libpthread.so.0
a8083000-a8084000 r--p 00013000 03:00 14462      /lib/libpthread.so.0
a8084000-a8085000 rw-p 00014000 03:00 14462      /lib/libpthread.so.0
a8085000-a8088000 rw-p 00000000 00:00 0 
a8088000-a80a4000 r-xp 00000000 03:00 8317       /lib/ld-linux.so.2
a80a4000-a80a5000 r--p 0001b000 03:00 8317       /lib/ld-linux.so.2
a80a5000-a80a6000 rw-p 0001c000 03:00 8317       /lib/ld-linux.so.2
afaf5000-afb0a000 rw-p 00000000 00:00 0          [stack]
ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]

 
Also there is a new entry "stack usage" in /proc/<pid>/{task/*,}/status
which will you give the current stack usage in kb.

A sample output of /proc/self/status looks like:

Name:   cat
State:  R (running)
Tgid:   507
Pid:    507
.
.
.
CapBnd: fffffffffffffeff
voluntary_ctxt_switches:        0
nonvoluntary_ctxt_switches:     0
Stack usage:    12 kB

I also fixed stack base address in /proc/<pid>/{task/*,}/stat to the
base address of the associated thread stack and not the one of the main
process. This makes more sense.

Changes since last posting:

 - use walk_page_range() to determinate the stack usage high water mark
 - include swapped pages to the stack usage high water mark

The patch is against 2.6.30-rc7 and tested with on intel and ppc
architectures.
 
ChangeLog:
 20. Jan 2009 V0.1
  - First Version for Kernel 2.6.28.1
 31. Mar 2009 V0.2
  - Ported to Kernel 2.6.29
 03. Jun 2009 V0.3
  - Ported to Kernel 2.6.30
  - Redesigned what was suggested by Ingo Molnar 
  - the thread watch monitor is gone
  - the /proc/stackmon entry is also gone
  - slim down
 04. Jun 2009 V0.4
  - Redesigned everything that was suggested by Andrew Morton 
  - slim down 
 04. Jun 2009 V0.5
  - Code cleanup
 06. Jun 2009 V0.6
  - Fix missing mm->mmap_sem locking in function task_show_stack_usage()
  - Code cleanup
 10. Jun 2009 V0.7
  - update Documentation/filesystem/proc.txt
 10. Jun 2009 V0.8
 - change maps/smaps output, displays now the max. stack size

 Documentation/filesystems/proc.txt |    5 +-
 fs/exec.c                          |    2 
 fs/proc/array.c                    |   85 ++++++++++++++++++++++++++++++++++++-
 fs/proc/task_mmu.c                 |   19 ++++++++
 include/linux/sched.h              |    1 
 kernel/fork.c                      |    2 
 6 files changed, 112 insertions(+), 2 deletions(-)

Signed-off-by: Stefani Seibold <stefani@seibold.net>

diff -u -N -r linux-2.6.30.orig/Documentation/filesystems/proc.txt linux-2.6.30/Documentation/filesystems/proc.txt
--- linux-2.6.30.orig/Documentation/filesystems/proc.txt	2009-06-10 09:09:27.000000000 +0200
+++ linux-2.6.30/Documentation/filesystems/proc.txt	2009-06-10 09:07:46.000000000 +0200
@@ -176,6 +176,7 @@
   CapBnd: ffffffffffffffff
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
+  Stack usage:    12 kB
 
 This shows you nearly the same information you would get if you viewed it with
 the ps  command.  In  fact,  ps  uses  the  proc  file  system  to  obtain its
@@ -229,6 +230,7 @@
  Mems_allowed_list           Same as previous, but in "list format"
  voluntary_ctxt_switches     number of voluntary context switches
  nonvoluntary_ctxt_switches  number of non voluntary context switches
+ Stack usage:                stack usage high water mark (round up to page size)
 ..............................................................................
 
 Table 1-3: Contents of the statm files (as of 2.6.8-rc3)
@@ -307,7 +309,7 @@
 08049000-0804a000 rw-p 00001000 03:00 8312       /opt/test
 0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
 a7cb1000-a7cb2000 ---p 00000000 00:00 0
-a7cb2000-a7eb2000 rw-p 00000000 00:00 0
+a7cb2000-a7eb2000 rw-p 00000000 00:00 0          [thread stack: 001ff4b4]
 a7eb2000-a7eb3000 ---p 00000000 00:00 0
 a7eb3000-a7ed5000 rw-p 00000000 00:00 0
 a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
@@ -343,6 +345,7 @@
  [stack]                  = the stack of the main process
  [vdso]                   = the "virtual dynamic shared object",
                             the kernel system call handler
+ [thread stack, xxxxxxxx] = the stack of the thread, xxxxxxxx is the stack size
 
  or if empty, the mapping is anonymous.
 
diff -u -N -r linux-2.6.30.orig/fs/exec.c linux-2.6.30/fs/exec.c
--- linux-2.6.30.orig/fs/exec.c	2009-06-04 09:29:47.000000000 +0200
+++ linux-2.6.30/fs/exec.c	2009-06-04 09:32:35.000000000 +0200
@@ -1328,6 +1328,8 @@
 	if (retval < 0)
 		goto out;
 
+	current->stack_start = current->mm->start_stack;
+
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
diff -u -N -r linux-2.6.30.orig/fs/proc/array.c linux-2.6.30/fs/proc/array.c
--- linux-2.6.30.orig/fs/proc/array.c	2009-06-04 09:29:47.000000000 +0200
+++ linux-2.6.30/fs/proc/array.c	2009-06-24 13:53:27.000000000 +0200
@@ -83,6 +83,8 @@
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
 
+#include <linux/swapops.h>
+
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include "internal.h"
@@ -321,6 +323,86 @@
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
+					struct task_struct *task)
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
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
@@ -340,6 +422,7 @@
 	task_show_regs(m, task);
 #endif
 	task_context_switch_counts(m, task);
+	task_show_stack_usage(m, task);
 	return 0;
 }
 
@@ -481,7 +564,7 @@
 		rsslim,
 		mm ? mm->start_code : 0,
 		mm ? mm->end_code : 0,
-		(permitted && mm) ? mm->start_stack : 0,
+		(permitted) ? task->stack_start : 0,
 		esp,
 		eip,
 		/* The signal information here is obsolete.
diff -u -N -r linux-2.6.30.orig/fs/proc/task_mmu.c linux-2.6.30/fs/proc/task_mmu.c
--- linux-2.6.30.orig/fs/proc/task_mmu.c	2009-06-04 09:29:47.000000000 +0200
+++ linux-2.6.30/fs/proc/task_mmu.c	2009-06-10 09:02:40.000000000 +0200
@@ -242,6 +242,25 @@
 				} else if (vma->vm_start <= mm->start_stack &&
 					   vma->vm_end >= mm->start_stack) {
 					name = "[stack]";
+				} else {
+					unsigned long stack_start;
+					struct proc_maps_private *pmp;
+
+					pmp = m->private;
+					stack_start = pmp->task->stack_start;
+
+					if (vma->vm_start <= stack_start &&
+					    vma->vm_end >= stack_start) {
+						pad_len_spaces(m, len);
+						seq_printf(m,
+						 "[thread stack: %08lx]",
+#ifdef CONFIG_STACK_GROWSUP
+						 vma->vm_end - stack_start
+#else
+						 stack_start - vma->vm_start
+#endif
+						);
+					}
 				}
 			} else {
 				name = "[vdso]";
diff -u -N -r linux-2.6.30.orig/include/linux/sched.h linux-2.6.30/include/linux/sched.h
--- linux-2.6.30.orig/include/linux/sched.h	2009-06-04 09:29:47.000000000 +0200
+++ linux-2.6.30/include/linux/sched.h	2009-06-04 09:32:35.000000000 +0200
@@ -1429,6 +1429,7 @@
 	/* state flags for use by tracers */
 	unsigned long trace;
 #endif
+	unsigned long stack_start;
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff -u -N -r linux-2.6.30.orig/kernel/fork.c linux-2.6.30/kernel/fork.c
--- linux-2.6.30.orig/kernel/fork.c	2009-06-04 09:29:47.000000000 +0200
+++ linux-2.6.30/kernel/fork.c	2009-06-04 13:15:35.000000000 +0200
@@ -1092,6 +1092,8 @@
 	if (unlikely(current->ptrace))
 		ptrace_fork(p, clone_flags);
 
+	p->stack_start = stack_start;
+
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
 



