Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbXJYPGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbXJYPGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbXJYPG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:06:29 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:46224 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771AbXJYPG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:06:27 -0400
Date: Thu, 25 Oct 2007 11:05:41 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86 patch] Fix UML signal.h build errors
Message-ID: <20071025150541.GB5968@c2.user-mode-linux.org>
References: <20071025130022.8720.77346.sendpatchset@balbir-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025130022.8720.77346.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 06:30:22PM +0530, Balbir Singh wrote:
> Fix build errors seen in UML. 

Al fixed these already.

FWIW, below is a rolled-up combo patch which make 2.6.24-rc1 UML build.

It includes Al's build fixes, Wang Cong's driver fix, and a declaration
mismatch in sched.c.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

Index: linux-2.6.17/arch/um/Makefile
===================================================================
--- linux-2.6.17.orig/arch/um/Makefile	2007-10-24 10:04:50.000000000 -0400
+++ linux-2.6.17/arch/um/Makefile	2007-10-24 10:19:58.000000000 -0400
@@ -70,9 +70,12 @@ include $(srctree)/$(ARCH_DIR)/Makefile-
 # in KBUILD_CFLAGS.  Otherwise, it would cause ld to complain about the two different
 # errnos.
 # These apply to kernelspace only.
+#
+# strip leading and trailing whitespace to make the USER_CFLAGS removal of these
+# defines more robust
 
-KERNEL_DEFINES = -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
-	-Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES)
+KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
+			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
 KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
 
Index: linux-2.6.17/arch/um/Makefile-i386
===================================================================
--- linux-2.6.17.orig/arch/um/Makefile-i386	2007-10-24 10:04:50.000000000 -0400
+++ linux-2.6.17/arch/um/Makefile-i386	2007-10-24 10:16:51.000000000 -0400
@@ -9,6 +9,7 @@ ELF_ARCH		:= $(SUBARCH)
 ELF_FORMAT 		:= elf32-$(SUBARCH)
 OBJCOPYFLAGS  		:= -O binary -R .note -R .comment -S
 HEADER_ARCH		:= x86
+CHECKFLAGS	+= -D__i386__
 
 ifeq ("$(origin SUBARCH)", "command line")
 ifneq ("$(shell uname -m | sed -e s/i.86/i386/)", "$(SUBARCH)")
@@ -26,8 +27,6 @@ AFLAGS			+= -DCONFIG_X86_32
 CONFIG_X86_32		:= y
 export CONFIG_X86_32
 
-ARCH_KERNEL_DEFINES += -U__$(SUBARCH)__ -U$(SUBARCH)
-
 # First of all, tune CFLAGS for the specific CPU. This actually sets cflags-y.
 include $(srctree)/arch/i386/Makefile.cpu
 
Index: linux-2.6.17/arch/um/Makefile-x86_64
===================================================================
--- linux-2.6.17.orig/arch/um/Makefile-x86_64	2007-10-24 10:04:50.000000000 -0400
+++ linux-2.6.17/arch/um/Makefile-x86_64	2007-10-24 10:16:51.000000000 -0400
@@ -6,12 +6,9 @@ START := 0x60000000
 
 _extra_flags_ = -fno-builtin -m64
 
-#We #undef __x86_64__ for kernelspace, not for userspace where
-#it's needed for headers to work!
-ARCH_KERNEL_DEFINES = -U__$(SUBARCH)__
 KBUILD_CFLAGS += $(_extra_flags_)
 
-CHECKFLAGS  += -m64
+CHECKFLAGS  += -m64 -D__x86_64__
 KBUILD_AFLAGS += -m64
 LDFLAGS += -m elf_x86_64
 KBUILD_CPPFLAGS += -m64
Index: linux-2.6.17/arch/um/kernel/sysrq.c
===================================================================
--- linux-2.6.17.orig/arch/um/kernel/sysrq.c	2007-07-09 08:53:09.000000000 -0400
+++ linux-2.6.17/arch/um/kernel/sysrq.c	2007-10-24 10:16:51.000000000 -0400
@@ -8,6 +8,7 @@
 #include "linux/module.h"
 #include "linux/kallsyms.h"
 #include "asm/page.h"
+#include "registers.h"
 #include "asm/processor.h"
 #include "sysrq.h"
 
Index: linux-2.6.17/drivers/char/mem.c
===================================================================
--- linux-2.6.17.orig/drivers/char/mem.c	2007-10-24 10:04:50.000000000 -0400
+++ linux-2.6.17/drivers/char/mem.c	2007-10-24 10:16:51.000000000 -0400
@@ -41,7 +41,7 @@
  */
 static inline int uncached_access(struct file *file, unsigned long addr)
 {
-#if defined(__i386__)
+#if defined(__i386__) && !defined(__arch_um__)
 	/*
 	 * On the PPro and successors, the MTRRs are used to set
 	 * memory types for physical addresses outside main memory,
@@ -57,7 +57,7 @@ static inline int uncached_access(struct
 		  test_bit(X86_FEATURE_CYRIX_ARR, boot_cpu_data.x86_capability) ||
 		  test_bit(X86_FEATURE_CENTAUR_MCR, boot_cpu_data.x86_capability) )
 	  && addr >= __pa(high_memory);
-#elif defined(__x86_64__)
+#elif defined(__x86_64__) && !defined(__arch_um__)
 	/* 
 	 * This is broken because it can generate memory type aliases,
 	 * which can cause cache corruptions
Index: linux-2.6.17/drivers/md/raid6algos.c
===================================================================
--- linux-2.6.17.orig/drivers/md/raid6algos.c	2006-10-20 13:41:41.000000000 -0400
+++ linux-2.6.17/drivers/md/raid6algos.c	2007-10-24 10:16:51.000000000 -0400
@@ -52,7 +52,7 @@ const struct raid6_calls * const raid6_a
 	&raid6_intx16,
 	&raid6_intx32,
 #endif
-#if defined(__i386__)
+#if defined(__i386__) && !defined(__arch_um__)
 	&raid6_mmxx1,
 	&raid6_mmxx2,
 	&raid6_sse1x1,
@@ -60,7 +60,7 @@ const struct raid6_calls * const raid6_a
 	&raid6_sse2x1,
 	&raid6_sse2x2,
 #endif
-#if defined(__x86_64__)
+#if defined(__x86_64__) && !defined(__arch_um__)
 	&raid6_sse2x1,
 	&raid6_sse2x2,
 	&raid6_sse2x4,
Index: linux-2.6.17/drivers/md/raid6mmx.c
===================================================================
--- linux-2.6.17.orig/drivers/md/raid6mmx.c	2007-04-26 17:03:01.000000000 -0400
+++ linux-2.6.17/drivers/md/raid6mmx.c	2007-10-24 10:16:51.000000000 -0400
@@ -16,7 +16,7 @@
  * MMX implementation of RAID-6 syndrome functions
  */
 
-#if defined(__i386__)
+#if defined(__i386__) && !defined(__arch_um__)
 
 #include "raid6.h"
 #include "raid6x86.h"
Index: linux-2.6.17/drivers/md/raid6sse1.c
===================================================================
--- linux-2.6.17.orig/drivers/md/raid6sse1.c	2007-04-26 17:03:01.000000000 -0400
+++ linux-2.6.17/drivers/md/raid6sse1.c	2007-10-24 10:16:51.000000000 -0400
@@ -21,7 +21,7 @@
  * worthwhile as a separate implementation.
  */
 
-#if defined(__i386__)
+#if defined(__i386__) && !defined(__arch_um__)
 
 #include "raid6.h"
 #include "raid6x86.h"
Index: linux-2.6.17/drivers/md/raid6sse2.c
===================================================================
--- linux-2.6.17.orig/drivers/md/raid6sse2.c	2007-04-26 17:03:01.000000000 -0400
+++ linux-2.6.17/drivers/md/raid6sse2.c	2007-10-24 10:16:51.000000000 -0400
@@ -17,7 +17,7 @@
  *
  */
 
-#if defined(__i386__) || defined(__x86_64__)
+#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
 
 #include "raid6.h"
 #include "raid6x86.h"
@@ -161,7 +161,7 @@ const struct raid6_calls raid6_sse2x2 = 
 
 #endif
 
-#ifdef __x86_64__
+#if defined(__x86_64__) && !defined(__arch_um__)
 
 /*
  * Unrolled-by-4 SSE2 implementation
Index: linux-2.6.17/drivers/md/raid6x86.h
===================================================================
--- linux-2.6.17.orig/drivers/md/raid6x86.h	2007-04-26 17:03:01.000000000 -0400
+++ linux-2.6.17/drivers/md/raid6x86.h	2007-10-24 10:16:51.000000000 -0400
@@ -19,7 +19,7 @@
 #ifndef LINUX_RAID_RAID6X86_H
 #define LINUX_RAID_RAID6X86_H
 
-#if defined(__i386__) || defined(__x86_64__)
+#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
 
 #ifdef __KERNEL__ /* Real code */
 
Index: linux-2.6.17/include/asm-um/unistd.h
===================================================================
--- linux-2.6.17.orig/include/asm-um/unistd.h	2006-12-02 09:56:59.000000000 -0500
+++ linux-2.6.17/include/asm-um/unistd.h	2007-10-24 10:16:51.000000000 -0400
@@ -14,7 +14,6 @@ extern int um_execve(const char *file, c
 
 #ifdef __KERNEL__
 /* We get __ARCH_WANT_OLD_STAT and __ARCH_WANT_STAT64 from the base arch */
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
Index: linux-2.6.17/include/linux/eventpoll.h
===================================================================
--- linux-2.6.17.orig/include/linux/eventpoll.h	2007-04-26 17:03:16.000000000 -0400
+++ linux-2.6.17/include/linux/eventpoll.h	2007-10-24 10:16:51.000000000 -0400
@@ -32,18 +32,13 @@
  * On x86-64 make the 64bit structure have the same alignment as the
  * 32bit structure. This makes 32bit emulation easier.
  *
- * UML/x86_64 needs the same packing as x86_64 - UML + UML_X86 +
- * 64_BIT adds up to UML/x86_64.
+ * UML/x86_64 needs the same packing as x86_64
  */
 #ifdef __x86_64__
 #define EPOLL_PACKED __attribute__((packed))
 #else
-#if defined(CONFIG_UML) && defined(CONFIG_UML_X86) && defined(CONFIG_64BIT)
-#define EPOLL_PACKED __attribute__((packed))
-#else
 #define EPOLL_PACKED
 #endif
-#endif
 
 struct epoll_event {
 	__u32 events;
Index: linux-2.6.17/kernel/signal.c
===================================================================
--- linux-2.6.17.orig/kernel/signal.c	2007-10-24 10:05:11.000000000 -0400
+++ linux-2.6.17/kernel/signal.c	2007-10-24 10:16:51.000000000 -0400
@@ -732,7 +732,7 @@ static void print_fatal_signal(struct pt
 	printk("%s/%d: potentially unexpected fatal signal %d.\n",
 		current->comm, task_pid_nr(current), signr);
 
-#ifdef __i386__
+#if defined(__i386__) && !defined(__arch_um__)
 	printk("code at %08lx: ", regs->eip);
 	{
 		int i;
Index: linux-2.6.17/kernel/sched.c
===================================================================
--- linux-2.6.17.orig/kernel/sched.c	2007-10-24 10:05:11.000000000 -0400
+++ linux-2.6.17/kernel/sched.c	2007-10-24 10:22:43.000000000 -0400
@@ -3897,7 +3897,7 @@ wait_for_completion_timeout(struct compl
 }
 EXPORT_SYMBOL(wait_for_completion_timeout);
 
-int __sched wait_for_completion_interruptible(struct completion *x)
+int fastcall __sched wait_for_completion_interruptible(struct completion *x)
 {
 	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
 	if (t == -ERESTARTSYS)
Index: linux-2.6.17/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.17.orig/arch/um/drivers/ubd_kern.c	2007-10-24 10:04:50.000000000 -0400
+++ linux-2.6.17/arch/um/drivers/ubd_kern.c	2007-10-24 10:24:33.000000000 -0400
@@ -35,6 +35,7 @@
 #include "linux/genhd.h"
 #include "linux/spinlock.h"
 #include "linux/platform_device.h"
+#include "linux/scatterlist.h"
 #include "asm/segment.h"
 #include "asm/uaccess.h"
 #include "asm/irq.h"
