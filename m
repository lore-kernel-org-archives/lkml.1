Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbYH2XRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbYH2XRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbYH2XQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:16:15 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:54419 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYH2XQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:16:13 -0400
Date: Fri, 29 Aug 2008 16:16:12 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jiayingz@google.com, dkegel@google.com
Subject: [PATCH 3/6] UML and sched: Annotate stacks
In-Reply-To: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
Message-ID: <alpine.DEB.1.00.0808291615300.15543@abydos.NerdBox.Net>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Track and tell valgrind about kernel mode stacks.  Valgrind gets confused
without these annotations because it expects processes to only use their
initial stack and stacks created for threads by way of clone.

Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
---

Index: linux-2.6.27-rc5/arch/um/kernel/process.c
===================================================================
--- linux-2.6.27-rc5.orig/arch/um/kernel/process.c	2008-08-29 14:17:31.000000000 -0700
+++ linux-2.6.27-rc5/arch/um/kernel/process.c	2008-08-29 14:41:34.000000000 -0700
@@ -16,6 +16,7 @@
  #include <linux/sched.h>
  #include <linux/tick.h>
  #include <linux/threads.h>
+#include <linux/valgrind.h>
  #include <asm/current.h>
  #include <asm/pgtable.h>
  #include <asm/uaccess.h>
@@ -62,10 +63,40 @@
  	if (atomic)
  		flags = GFP_ATOMIC;
  	page = __get_free_pages(flags, order);
+	/* There are long lived stacks and we won't free them */
+	if (page)
+		VALGRIND_STACK_REGISTER(page + (PAGE_SIZE << order) - 1, page);

  	return page;
  }

+struct thread_info *alloc_thread_info(struct task_struct *tsk)
+{
+	struct thread_info *ti;
+#ifdef CONFIG_DEBUG_STACK_USAGE
+	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
+#else
+	gfp_t mask = GFP_KERNEL;
+#endif
+	ti = (struct thread_info *) __get_free_pages(mask,
+						CONFIG_KERNEL_STACK_ORDER);
+#ifdef CONFIG_VALGRIND_SUPPORT
+	if (ti) {
+		VALGRIND_MALLOCLIKE_BLOCK(ti, sizeof(*ti), 0, 0);
+		ti->valgrind_sid = VALGRIND_STACK_REGISTER((unsigned long)ti
+						+ UM_THREAD_SIZE - 1, ti + 1);
+	}
+#endif
+	return ti;
+}
+
+void free_thread_info(struct thread_info *ti)
+{
+	VALGRIND_STACK_DEREGISTER(ti->valgrind_sid);
+	VALGRIND_FREELIKE_BLOCK(ti, 0);
+	free_pages((unsigned long)ti, CONFIG_KERNEL_STACK_ORDER);
+}
+
  int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
  {
  	int pid;
Index: linux-2.6.27-rc5/arch/um/kernel/skas/process.c
===================================================================
--- linux-2.6.27-rc5.orig/arch/um/kernel/skas/process.c	2008-07-13 14:51:29.000000000 -0700
+++ linux-2.6.27-rc5/arch/um/kernel/skas/process.c	2008-08-29 14:32:45.000000000 -0700
@@ -5,6 +5,7 @@

  #include "linux/init.h"
  #include "linux/sched.h"
+#include "linux/valgrind.h"
  #include "as-layout.h"
  #include "kern.h"
  #include "os.h"
@@ -65,6 +66,8 @@
  	}

  	init_new_thread_signals();
+	VALGRIND_STACK_REGISTER((unsigned long)(&init_stack + 1) - 1,
+				&init_thread_info + 1);

  	init_task.thread.request.u.thread.proc = start_kernel_proc;
  	init_task.thread.request.u.thread.arg = NULL;
Index: linux-2.6.27-rc5/include/asm-um/thread_info.h
===================================================================
--- linux-2.6.27-rc5.orig/include/asm-um/thread_info.h	2008-08-29 14:17:37.000000000 -0700
+++ linux-2.6.27-rc5/include/asm-um/thread_info.h	2008-08-29 14:46:02.000000000 -0700
@@ -24,6 +24,9 @@
  						   0-0xFFFFFFFF for kernel */
  	struct restart_block    restart_block;
  	struct thread_info	*real_thread;    /* Points to non-IRQ stack */
+#ifdef CONFIG_VALGRIND_SUPPORT
+	unsigned int valgrind_sid;
+#endif
  };

  #define INIT_THREAD_INFO(tsk)			\
@@ -55,6 +58,11 @@

  #define THREAD_SIZE_ORDER CONFIG_KERNEL_STACK_ORDER

+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
+extern struct thread_info *alloc_thread_info(struct task_struct *tsk);
+extern void free_thread_info(struct thread_info *ti);
+
  #endif

  #define PREEMPT_ACTIVE		0x10000000
Index: linux-2.6.27-rc5/include/linux/sched.h
===================================================================
--- linux-2.6.27-rc5.orig/include/linux/sched.h	2008-08-29 14:17:38.000000000 -0700
+++ linux-2.6.27-rc5/include/linux/sched.h	2008-08-29 14:32:45.000000000 -0700
@@ -1947,8 +1947,14 @@

  static inline void setup_thread_stack(struct task_struct *p, struct task_struct *org)
  {
+#ifdef CONIG_VALGRIND_SUPPORT
+	unsigned int valgrind_sid = task_thread_info(p)->valgrind_sid;
+#endif
  	*task_thread_info(p) = *task_thread_info(org);
  	task_thread_info(p)->task = p;
+#ifdef CONIG_VALGRIND_SUPPORT
+	task_thread_info(p)->valgrind_sid = valgrind_sid;
+#endif
  }

  static inline unsigned long *end_of_stack(struct task_struct *p)
