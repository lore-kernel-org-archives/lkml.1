Return-Path: <linux-kernel-owner+w=401wt.eu-S1762597AbXFSSnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762597AbXFSSnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762236AbXFSSnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:43:15 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53313 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762221AbXFSSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:43:14 -0400
Date: Tue, 19 Jun 2007 14:42:45 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] UML - Add stack usage monitoring
Message-ID: <20070619184245.GA10567@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a machanism to see how much of a kernel stack is used.  This
allocates zeroed stacks and sees where the lowest non-zero byte is on
process exit.  It keeps track of the lowest value and logs values as
they get lower.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/Kconfig.debug        |    9 +++++++++
 arch/um/defconfig            |    1 +
 arch/um/kernel/process.c     |   29 +++++++++++++++++++++++++++++
 include/asm-um/thread_info.h |   16 ++++++++++++++++
 4 files changed, 55 insertions(+)

Index: linux-2.6.21-mm/arch/um/Kconfig.debug
===================================================================
--- linux-2.6.21-mm.orig/arch/um/Kconfig.debug	2007-06-19 13:37:16.000000000 -0400
+++ linux-2.6.21-mm/arch/um/Kconfig.debug	2007-06-19 14:05:59.000000000 -0400
@@ -47,4 +47,13 @@ config GCOV
         If you're involved in UML kernel development and want to use gcov,
         say Y.  If you're unsure, say N.
 
+config DEBUG_STACK_USAGE
+	bool "Stack utilization instrumentation"
+	default N
+	help
+	Track the maximum kernel stack usage - this will look at each
+	kernel stack at process exit and log it if it's the deepest
+	stack seen so far.
+
+	This option will slow down process creation and destruction somewhat.
 endmenu
Index: linux-2.6.21-mm/arch/um/kernel/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/process.c	2007-06-19 13:37:16.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/process.c	2007-06-19 14:01:55.000000000 -0400
@@ -411,3 +411,32 @@ unsigned long arch_align_stack(unsigned 
 	return sp & ~0xf;
 }
 #endif
+
+#ifdef CONFIG_DEBUG_STACK_USAGE
+
+static DEFINE_SPINLOCK(low_water_lock);
+static int lowest_to_date = THREAD_SIZE;
+
+void check_stack_usage(struct thread_info *s)
+{
+	unsigned int *stack, *p, *end;
+	int left;
+
+	stack = (unsigned int *) (s + 1);
+	end = (unsigned int *) ((unsigned long) s + THREAD_SIZE);
+	for(p = stack; p < end; p++){
+		if(*p != 0)
+			break;
+	}
+
+	left = (p - stack) * sizeof(*p);
+
+	spin_lock(&low_water_lock);
+	if(left < lowest_to_date){
+		printk("Greatest stack depth - %d bytes left\n", left);
+		lowest_to_date = left;
+	}
+	spin_unlock(&low_water_lock);
+}
+
+#endif
Index: linux-2.6.21-mm/include/asm-um/thread_info.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-um/thread_info.h	2007-06-19 13:37:16.000000000 -0400
+++ linux-2.6.21-mm/include/asm-um/thread_info.h	2007-06-19 13:57:07.000000000 -0400
@@ -52,6 +52,20 @@ static inline struct thread_info *curren
 	return ti;
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+
+extern void check_stack_usage(struct thread_info *stack);
+
+#define alloc_thread_info(tsk) \
+	((struct thread_info *) __get_free_pages(GFP_KERNEL | __GFP_ZERO, \
+						 CONFIG_KERNEL_STACK_ORDER))
+
+#define free_thread_info(ti) ({ check_stack_usage(ti) ; \
+			        free_pages((unsigned long)(ti), \
+					   CONFIG_KERNEL_STACK_ORDER); })
+
+#else
+
 /* thread information allocation */
 #define alloc_thread_info(tsk) \
 	((struct thread_info *) __get_free_pages(GFP_KERNEL, \
@@ -61,6 +75,8 @@ static inline struct thread_info *curren
 
 #endif
 
+#endif
+
 #define PREEMPT_ACTIVE		0x10000000
 
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
Index: linux-2.6.21-mm/arch/um/defconfig
===================================================================
--- linux-2.6.21-mm.orig/arch/um/defconfig	2007-06-19 13:37:16.000000000 -0400
+++ linux-2.6.21-mm/arch/um/defconfig	2007-06-19 13:51:44.000000000 -0400
@@ -527,3 +527,4 @@ CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_GPROF is not set
 # CONFIG_GCOV is not set
+# CONFIG_DEBUG_STACK_USAGE is not set
