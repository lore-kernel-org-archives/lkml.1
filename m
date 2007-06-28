Return-Path: <linux-kernel-owner+w=401wt.eu-S1763202AbXF1Gha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763202AbXF1Gha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759125AbXF1GhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:37:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759128AbXF1GhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:37:20 -0400
Date: Wed, 27 Jun 2007 23:37:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 4/5] UML - Simplify helper stack handling
Message-Id: <20070627233701.8e53f3cb.akpm@linux-foundation.org>
In-Reply-To: <20070614202655.GA9647@c2.user-mode-linux.org>
References: <20070614202655.GA9647@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


So I'm running the generic version of this on i386 with 8k stacks (below),
with a quick LTP run.

Holy cow, either we use a _lot_ of stack or these numbers are off:

vmm:/home/akpm> dmesg -s 1000000|grep 'bytes left' 
khelper used greatest stack depth: 7176 bytes left
khelper used greatest stack depth: 7064 bytes left
khelper used greatest stack depth: 6840 bytes left
khelper used greatest stack depth: 6812 bytes left
hostname used greatest stack depth: 6636 bytes left
uname used greatest stack depth: 6592 bytes left
uname used greatest stack depth: 6284 bytes left
hotplug used greatest stack depth: 5568 bytes left
rpc.nfsd used greatest stack depth: 5136 bytes left
chown02 used greatest stack depth: 4956 bytes left
fchown01 used greatest stack depth: 4892 bytes left

That's the sum of process stack and interrupt stack, but I doubt if this
little box is using much interrupt stack space.

No wonder people are still getting stack overflows with 4k stacks...





From: Jeff Dike <jdike@addtoit.com>

Add generic exit-time stack-depth checking to CONFIG_DEBUG_STACK_USAGE.

This also adds UML support.

Tested on UML and i386.

[akpm@linux-foundation.org: cleanups, speedups, tweaks]
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.debug        |    9 +++++++++
 arch/um/defconfig            |    1 +
 include/asm-um/thread_info.h |    9 +++++++++
 kernel/exit.c                |   29 +++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+)

diff -puN arch/um/Kconfig.debug~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage arch/um/Kconfig.debug
--- a/arch/um/Kconfig.debug~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage
+++ a/arch/um/Kconfig.debug
@@ -47,4 +47,13 @@ config GCOV
         If you're involved in UML kernel development and want to use gcov,
         say Y.  If you're unsure, say N.
 
+config DEBUG_STACK_USAGE
+	bool "Stack utilization instrumentation"
+	default N
+	help
+	  Track the maximum kernel stack usage - this will look at each
+	  kernel stack at process exit and log it if it's the deepest
+	  stack seen so far.
+
+	  This option will slow down process creation and destruction somewhat.
 endmenu
diff -puN arch/um/defconfig~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage arch/um/defconfig
--- a/arch/um/defconfig~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage
+++ a/arch/um/defconfig
@@ -527,3 +527,4 @@ CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_GPROF is not set
 # CONFIG_GCOV is not set
+# CONFIG_DEBUG_STACK_USAGE is not set
diff -puN include/asm-um/thread_info.h~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage
+++ a/include/asm-um/thread_info.h
@@ -52,10 +52,19 @@ static inline struct thread_info *curren
 	return ti;
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+
+#define alloc_thread_info(tsk) \
+	((struct thread_info *) __get_free_pages(GFP_KERNEL | __GFP_ZERO, \
+						 CONFIG_KERNEL_STACK_ORDER))
+#else
+
 /* thread information allocation */
 #define alloc_thread_info(tsk) \
 	((struct thread_info *) __get_free_pages(GFP_KERNEL, \
 						 CONFIG_KERNEL_STACK_ORDER))
+#endif
+
 #define free_thread_info(ti) \
 	free_pages((unsigned long)(ti),CONFIG_KERNEL_STACK_ORDER)
 
diff -puN kernel/exit.c~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage kernel/exit.c
--- a/kernel/exit.c~add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage
+++ a/kernel/exit.c
@@ -868,6 +868,34 @@ static void exit_notify(struct task_stru
 		release_task(tsk);
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+static void check_stack_usage(void)
+{
+	static DEFINE_SPINLOCK(low_water_lock);
+	static int lowest_to_date = THREAD_SIZE;
+	unsigned long *n = end_of_stack(current);
+	unsigned long free;
+
+	while (*n == 0)
+		n++;
+	free = (unsigned long)n - (unsigned long)end_of_stack(current);
+
+	if (free >= lowest_to_date)
+		return;
+
+	spin_lock(&low_water_lock);
+	if (free < lowest_to_date) {
+		printk(KERN_WARNING "%s used greatest stack depth: %lu bytes "
+				"left\n",
+				current->comm, free);
+		lowest_to_date = free;
+	}
+	spin_unlock(&low_water_lock);
+}
+#else
+static inline void check_stack_usage(void) {}
+#endif
+
 fastcall NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
@@ -959,6 +987,7 @@ fastcall NORET_TYPE void do_exit(long co
 	exit_sem(tsk);
 	__exit_files(tsk);
 	__exit_fs(tsk);
+	check_stack_usage();
 	exit_thread();
 	cpuset_exit(tsk);
 	exit_keys(tsk);
_

