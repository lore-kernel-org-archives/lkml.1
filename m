Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbZATKnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbZATKnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZATKmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:42:18 -0500
Received: from www84.your-server.de ([213.133.104.84]:44148 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760722AbZATKmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:42:16 -0500
Subject: Detailed Stack Information Patch [1/3]
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 20 Jan 2009 11:16:40 +0100
Message-Id: <1232446600.784.16.camel@matrix>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff -u -N -r linux-2.6.28.1.orig/fs/exec.c linux-2.6.28.1/fs/exec.c
--- linux-2.6.28.1.orig/fs/exec.c	2009-01-18 19:45:37.000000000 +0100
+++ linux-2.6.28.1/fs/exec.c	2009-01-20 09:10:35.000000000 +0100
@@ -1342,6 +1342,9 @@
 	current->flags &= ~PF_KTHREAD;
 	retval = search_binary_handler(bprm,regs);
 	if (retval >= 0) {
+#ifdef CONFIG_PROC_STACK
+		current->stack_start = current->mm->start_stack;
+#endif
 		/* execve success */
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
diff -u -N -r linux-2.6.28.1.orig/fs/proc/array.c linux-2.6.28.1/fs/proc/array.c
--- linux-2.6.28.1.orig/fs/proc/array.c	2009-01-18 19:45:37.000000000 +0100
+++ linux-2.6.28.1/fs/proc/array.c	2009-01-20 09:10:35.000000000 +0100
@@ -308,6 +308,25 @@
 			p->nivcsw);
 }
 
+#ifdef CONFIG_PROC_STACK
+static inline void task_show_stack_usage(struct seq_file *m,
+						struct task_struct *p)
+{
+	unsigned long		cur_stack;
+	unsigned long		base_page;
+
+	base_page = KSTK_ESP(p) >> PAGE_SHIFT;
+
+#ifdef CONFIG_STACK_GROWSUP
+	cur_stack = base_page-(p->stack_start >> PAGE_SHIFT);
+#else
+	cur_stack = (p->stack_start >> PAGE_SHIFT)-base_page;
+#endif
+	seq_printf(m,	"stack usage:\t%lu kB\n",
+		(cur_stack + 1) << (PAGE_SHIFT-10));
+}
+#endif
+
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
@@ -327,6 +346,9 @@
 	task_show_regs(m, task);
 #endif
 	task_context_switch_counts(m, task);
+#ifdef CONFIG_PROC_STACK
+	task_show_stack_usage(m, task);
+#endif
 	return 0;
 }
 
diff -u -N -r linux-2.6.28.1.orig/fs/proc/task_mmu.c linux-2.6.28.1/fs/proc/task_mmu.c
--- linux-2.6.28.1.orig/fs/proc/task_mmu.c	2009-01-18 19:45:37.000000000 +0100
+++ linux-2.6.28.1/fs/proc/task_mmu.c	2009-01-20 09:10:35.000000000 +0100
@@ -240,6 +240,11 @@
 				} else if (vma->vm_start <= mm->start_stack &&
 					   vma->vm_end >= mm->start_stack) {
 					name = "[stack]";
+#ifdef CONFIG_PROC_STACK
+				} else if (vma->vm_start <= mm->start_stack &&
+					   vma->vm_end >= mm->start_stack) {
+					name = "[thread stack]";
+#endif
 				}
 			} else {
 				name = "[vdso]";
diff -u -N -r linux-2.6.28.1.orig/include/linux/sched.h linux-2.6.28.1/include/linux/sched.h
--- linux-2.6.28.1.orig/include/linux/sched.h	2009-01-18 19:45:37.000000000 +0100
+++ linux-2.6.28.1/include/linux/sched.h	2009-01-20 09:10:35.000000000 +0100
@@ -1356,6 +1356,9 @@
 	unsigned long default_timer_slack_ns;
 
 	struct list_head	*scm_work_list;
+#ifdef CONFIG_PROC_STACK
+	unsigned long stack_start;
+#endif
 };
 
 /*
diff -u -N -r linux-2.6.28.1.orig/init/Kconfig linux-2.6.28.1/init/Kconfig
--- linux-2.6.28.1.orig/init/Kconfig	2009-01-18 19:45:37.000000000 +0100
+++ linux-2.6.28.1/init/Kconfig	2009-01-20 09:10:36.000000000 +0100
@@ -814,6 +814,18 @@
 
 source "arch/Kconfig"
 
+config PROC_STACK
+ 	default y
+	depends on PROC_FS && MMU
+	bool "Enable /proc/<pid> stack monitoring" if EMBEDDED
+ 	help
+	  This enables monitoring of process and thread stack utilization.
+
+	  The /proc/pid/maps, /proc/pid/smaps, /proc/pid/status and the
+	  /proc/pid/task/pid pedants will be extended by the stack information.
+	  Disabling these interfaces will reduce the size of the kernel by
+	  approximately 1kb.
+
 endmenu		# General setup
 
 config HAVE_GENERIC_DMA_COHERENT
diff -u -N -r linux-2.6.28.1.orig/kernel/fork.c linux-2.6.28.1/kernel/fork.c
--- linux-2.6.28.1.orig/kernel/fork.c	2009-01-18 19:45:37.000000000 +0100
+++ linux-2.6.28.1/kernel/fork.c	2009-01-20 09:10:36.000000000 +0100
@@ -1093,6 +1093,11 @@
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
 
+#ifdef CONFIG_PROC_STACK
+	p->stack_start = (stack_start == KSTK_ESP(current)) ?
+		current->stack_start : stack_start;
+#endif
+
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
 


