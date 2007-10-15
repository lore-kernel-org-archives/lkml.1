Return-Path: <linux-kernel-owner+w=401wt.eu-S1765280AbXJOW27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765280AbXJOW27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760549AbXJOW0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:26:17 -0400
Received: from waste.org ([66.93.16.53]:1298 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756242AbXJOW0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:26:09 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.290135367@selenic.com>
Message-Id: <3.290135367@selenic.com>
Subject: [PATCH 2/11] maps3: introduce task_size_of for all arches
Date: Mon, 15 Oct 2007 17:25:59 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For the /proc/<pid>/pagemap code[1], we need to able to query how
much virtual address space a particular task has.  The trick is
that we do it through /proc and can't use TASK_SIZE since it
references "current" on some arches.  The process opening the
/proc file might be a 32-bit process opening a 64-bit process's
pagemap file.

x86_64 already has a TASK_SIZE_OF() macro:

#define TASK_SIZE_OF(child)     ((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)

I'd like to have that for other architectures.  So, add it
for all the architectures that actually use "current" in 
their TASK_SIZE.  For the others, just add a quick #define
in sched.h to use plain old TASK_SIZE.

1. http://www.linuxworld.com/news/2007/042407-kernel.html

- MIPS portion from Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Matt Mackall <mpm@selenic.com>
---

 lxc-dave/include/asm-ia64/processor.h    |    3 ++-
 lxc-dave/include/asm-mips/processor.h    |    4 ++++
 lxc-dave/include/asm-parisc/processor.h  |    3 ++-
 lxc-dave/include/asm-powerpc/processor.h |    4 +++-
 lxc-dave/include/asm-s390/processor.h    |    2 ++
 lxc-dave/include/linux/sched.h           |    4 ++++
 6 files changed, 17 insertions(+), 3 deletions(-)

Index: l/include/asm-ia64/processor.h
===================================================================
--- l.orig/include/asm-ia64/processor.h	2007-10-09 17:37:58.000000000 -0500
+++ l/include/asm-ia64/processor.h	2007-10-10 11:46:30.000000000 -0500
@@ -31,7 +31,8 @@
  * each (assuming 8KB page size), for a total of 8TB of user virtual
  * address space.
  */
-#define TASK_SIZE		(current->thread.task_size)
+#define TASK_SIZE_OF(tsk)	((tsk)->thread.task_size)
+#define TASK_SIZE       	TASK_SIZE_OF(current)
 
 /*
  * This decides where the kernel will search for a free chunk of vm
Index: l/include/asm-mips/processor.h
===================================================================
--- l.orig/include/asm-mips/processor.h	2007-10-09 17:37:58.000000000 -0500
+++ l/include/asm-mips/processor.h	2007-10-10 11:46:30.000000000 -0500
@@ -45,6 +45,8 @@ extern unsigned int vced_count, vcei_cou
  * space during mmap's.
  */
 #define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
+#define TASK_SIZE_OF(tsk)						\
+	(test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 #endif
 
 #ifdef CONFIG_64BIT
@@ -65,6 +67,8 @@ extern unsigned int vced_count, vcei_cou
 #define TASK_UNMAPPED_BASE						\
 	(test_thread_flag(TIF_32BIT_ADDR) ?				\
 		PAGE_ALIGN(TASK_SIZE32 / 3) : PAGE_ALIGN(TASK_SIZE / 3))
+#define TASK_SIZE_OF(tsk)						\
+	(test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 #endif
 
 #define NUM_FPU_REGS	32
Index: l/include/asm-parisc/processor.h
===================================================================
--- l.orig/include/asm-parisc/processor.h	2007-10-09 17:36:49.000000000 -0500
+++ l/include/asm-parisc/processor.h	2007-10-10 11:46:30.000000000 -0500
@@ -32,7 +32,8 @@
 #endif
 #define current_text_addr() ({ void *pc; current_ia(pc); pc; })
 
-#define TASK_SIZE               (current->thread.task_size)
+#define TASK_SIZE_OF(tsk)       ((tsk)->thread.task_size)
+#define TASK_SIZE	         (current->thread.task_size)
 #define TASK_UNMAPPED_BASE      (current->thread.map_base)
 
 #define DEFAULT_TASK_SIZE32	(0xFFF00000UL)
Index: l/include/asm-powerpc/processor.h
===================================================================
--- l.orig/include/asm-powerpc/processor.h	2007-10-09 17:37:58.000000000 -0500
+++ l/include/asm-powerpc/processor.h	2007-10-10 11:46:30.000000000 -0500
@@ -99,7 +99,9 @@ extern struct task_struct *last_task_use
  */
 #define TASK_SIZE_USER32 (0x0000000100000000UL - (1*PAGE_SIZE))
 
-#define TASK_SIZE (test_thread_flag(TIF_32BIT) ? \
+#define TASK_SIZE	  (test_thread_flag(TIF_32BIT) ? \
+		TASK_SIZE_USER32 : TASK_SIZE_USER64)
+#define TASK_SIZE_OF(tsk) (test_tsk_thread_flag(tsk, TIF_32BIT) ? \
 		TASK_SIZE_USER32 : TASK_SIZE_USER64)
 
 /* This decides where the kernel will search for a free chunk of vm
Index: l/include/asm-s390/processor.h
===================================================================
--- l.orig/include/asm-s390/processor.h	2007-10-09 17:37:58.000000000 -0500
+++ l/include/asm-s390/processor.h	2007-10-10 11:46:30.000000000 -0500
@@ -75,6 +75,8 @@ extern struct task_struct *last_task_use
 
 # define TASK_SIZE		(test_thread_flag(TIF_31BIT) ? \
 					(0x80000000UL) : (0x40000000000UL))
+# define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_31BIT) ? \
+					(0x80000000UL) : (0x40000000000UL))
 # define TASK_UNMAPPED_BASE	(TASK_SIZE / 2)
 # define DEFAULT_TASK_SIZE	(0x40000000000UL)
 
Index: l/include/linux/sched.h
===================================================================
--- l.orig/include/linux/sched.h	2007-10-09 17:37:59.000000000 -0500
+++ l/include/linux/sched.h	2007-10-10 11:46:30.000000000 -0500
@@ -1880,6 +1880,10 @@ static inline void inc_syscw(struct task
 }
 #endif
 
+#ifndef TASK_SIZE_OF
+#define TASK_SIZE_OF(tsk)	TASK_SIZE
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
