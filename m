Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbXEIUcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbXEIUcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbXEIUck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:32:40 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40412 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbXEIUcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:32:39 -0400
Date: Wed, 9 May 2007 16:27:22 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 5/6] UML - Monitor stack usage
Message-ID: <20070509202722.GA22464@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for reducing stack size, add a machanism to see how
much of a kernel stack is used.  This fills a new stack with 0x6b on
allocation and sees where the lowest non-0x6b byte is on process
exit.  It keeps track of the lowest value and logs values as they get
lower.

The lowest values I've seen so far are ~1250 bytes remaining on i386
(with order 0 stacks) and ~2650 on x86_64 (order 1).

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/Kconfig.debug        |    8 ++++++++
 arch/um/defconfig            |    1 +
 arch/um/kernel/process.c     |   35 +++++++++++++++++++++++++++++++++++
 include/asm-um/thread_info.h |   16 ++++++++++++++++
 4 files changed, 60 insertions(+)

Index: linux-2.6.21-mm/arch/um/Kconfig.debug
===================================================================
--- linux-2.6.21-mm.orig/arch/um/Kconfig.debug	2007-05-09 14:34:39.000000000 -0400
+++ linux-2.6.21-mm/arch/um/Kconfig.debug	2007-05-09 14:36:10.000000000 -0400
@@ -47,4 +47,12 @@ config GCOV
         If you're involved in UML kernel development and want to use gcov,
         say Y.  If you're unsure, say N.
 
+config STACK_USAGE
+	bool "Track kernel stack usage"
+	default N
+	help
+	Track the maximum kernel stack usage - this will look at each
+	kernel stack at process exit and log it if it's the deepest
+	stack seen so far.
+
 endmenu
Index: linux-2.6.21-mm/arch/um/kernel/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/process.c	2007-05-09 14:34:39.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/process.c	2007-05-09 14:36:10.000000000 -0400
@@ -427,3 +427,38 @@ unsigned long arch_align_stack(unsigned 
 	return sp & ~0xf;
 }
 #endif
+
+#ifdef CONFIG_STACK_USAGE
+
+static int lowest_to_date = THREAD_SIZE;
+
+void mark_stack(struct thread_info *stack)
+{
+	if(stack == NULL)
+		return;
+
+	memset(stack, 0x6b, THREAD_SIZE);
+}
+
+void check_stack_usage(struct thread_info *s)
+{
+	unsigned int *stack;
+	unsigned int *p, *end;
+	int left;
+
+	stack = (unsigned int *) (s + 1);
+	end = (unsigned int *) ((unsigned long) stack + THREAD_SIZE);
+	for(p = stack; p < end; p++){
+		if(*p != 0x6b6b6b6b){
+			left = (p - stack);
+			if(left < lowest_to_date){
+				printk("Greatest stack depth - %d bytes left\n",
+				       left * sizeof(*p));
+				lowest_to_date = left;
+			}
+			return;
+		}
+	}
+}
+
+#endif
Index: linux-2.6.21-mm/include/asm-um/thread_info.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-um/thread_info.h	2007-05-09 14:34:39.000000000 -0400
+++ linux-2.6.21-mm/include/asm-um/thread_info.h	2007-05-09 14:36:10.000000000 -0400
@@ -52,6 +52,20 @@ static inline struct thread_info *curren
 	return ti;
 }
 
+#ifdef CONFIG_STACK_USAGE
+
+extern void mark_stack(struct thread_info *stack);
+extern void check_stack_usage(struct thread_info *stack);
+
+#define alloc_thread_info(tsk) \
+	({ struct thread_info *stack = kmalloc(THREAD_SIZE, GFP_KERNEL); \
+	   mark_stack(stack); \
+	   stack; \
+	 })
+#define free_thread_info(ti) ({ check_stack_usage(ti) ; kfree(ti); })
+
+#else
+
 /* thread information allocation */
 #define alloc_thread_info(tsk) \
 	((struct thread_info *) kmalloc(THREAD_SIZE, GFP_KERNEL))
@@ -59,6 +73,8 @@ static inline struct thread_info *curren
 
 #endif
 
+#endif
+
 #define PREEMPT_ACTIVE		0x10000000
 
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
Index: linux-2.6.21-mm/arch/um/defconfig
===================================================================
--- linux-2.6.21-mm.orig/arch/um/defconfig	2007-05-09 14:42:04.000000000 -0400
+++ linux-2.6.21-mm/arch/um/defconfig	2007-05-09 14:42:59.000000000 -0400
@@ -527,3 +527,4 @@ CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_GPROF is not set
 # CONFIG_GCOV is not set
+# CONFIG_STACK_USAGE is not set
