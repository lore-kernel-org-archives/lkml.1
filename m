Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbXJ2Ebe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbXJ2Ebe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbXJ2Eb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:31:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57991 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbXJ2EbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:31:24 -0400
Date: Mon, 29 Oct 2007 04:31:16 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86 merge fallout: uml
Message-ID: <20071029043116.GW8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't undef __i386__/__x86_64__ in uml anymore, make sure that (few) places
that required adjusting the ifdefs got those.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile-i386     |    3 +--
 arch/um/Makefile-x86_64   |    5 +----
 drivers/char/mem.c        |    4 ++--
 drivers/md/raid6algos.c   |    4 ++--
 drivers/md/raid6mmx.c     |    2 +-
 drivers/md/raid6sse1.c    |    2 +-
 drivers/md/raid6sse2.c    |    4 ++--
 drivers/md/raid6x86.h     |    2 +-
 include/asm-um/unistd.h   |    1 -
 include/linux/eventpoll.h |    7 +------
 kernel/signal.c           |    2 +-
 11 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
index 0178df3..08433f8 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
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
 
diff --git a/arch/um/Makefile-x86_64 b/arch/um/Makefile-x86_64
index fe5316f..8ed362f 100644
--- a/arch/um/Makefile-x86_64
+++ b/arch/um/Makefile-x86_64
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
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 0e937f6..20070b7 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -41,7 +41,7 @@
  */
 static inline int uncached_access(struct file *file, unsigned long addr)
 {
-#if defined(__i386__)
+#if defined(__i386__) && !defined(__arch_um__)
 	/*
 	 * On the PPro and successors, the MTRRs are used to set
 	 * memory types for physical addresses outside main memory,
@@ -57,7 +57,7 @@ static inline int uncached_access(struct file *file, unsigned long addr)
 		  test_bit(X86_FEATURE_CYRIX_ARR, boot_cpu_data.x86_capability) ||
 		  test_bit(X86_FEATURE_CENTAUR_MCR, boot_cpu_data.x86_capability) )
 	  && addr >= __pa(high_memory);
-#elif defined(__x86_64__)
+#elif defined(__x86_64__) && !defined(__arch_um__)
 	/* 
 	 * This is broken because it can generate memory type aliases,
 	 * which can cause cache corruptions
diff --git a/drivers/md/raid6algos.c b/drivers/md/raid6algos.c
index 9265761..77a6e4b 100644
--- a/drivers/md/raid6algos.c
+++ b/drivers/md/raid6algos.c
@@ -52,7 +52,7 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_intx16,
 	&raid6_intx32,
 #endif
-#if defined(__i386__)
+#if defined(__i386__) && !defined(__arch_um__)
 	&raid6_mmxx1,
 	&raid6_mmxx2,
 	&raid6_sse1x1,
@@ -60,7 +60,7 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_sse2x1,
 	&raid6_sse2x2,
 #endif
-#if defined(__x86_64__)
+#if defined(__x86_64__) && !defined(__arch_um__)
 	&raid6_sse2x1,
 	&raid6_sse2x2,
 	&raid6_sse2x4,
diff --git a/drivers/md/raid6mmx.c b/drivers/md/raid6mmx.c
index 6181a5a..d4e4a1b 100644
--- a/drivers/md/raid6mmx.c
+++ b/drivers/md/raid6mmx.c
@@ -16,7 +16,7 @@
  * MMX implementation of RAID-6 syndrome functions
  */
 
-#if defined(__i386__)
+#if defined(__i386__) && !defined(__arch_um__)
 
 #include "raid6.h"
 #include "raid6x86.h"
diff --git a/drivers/md/raid6sse1.c b/drivers/md/raid6sse1.c
index f0a1ba8..0666237 100644
--- a/drivers/md/raid6sse1.c
+++ b/drivers/md/raid6sse1.c
@@ -21,7 +21,7 @@
  * worthwhile as a separate implementation.
  */
 
-#if defined(__i386__)
+#if defined(__i386__) && !defined(__arch_um__)
 
 #include "raid6.h"
 #include "raid6x86.h"
diff --git a/drivers/md/raid6sse2.c b/drivers/md/raid6sse2.c
index 0f01976..b034ad8 100644
--- a/drivers/md/raid6sse2.c
+++ b/drivers/md/raid6sse2.c
@@ -17,7 +17,7 @@
  *
  */
 
-#if defined(__i386__) || defined(__x86_64__)
+#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
 
 #include "raid6.h"
 #include "raid6x86.h"
@@ -161,7 +161,7 @@ const struct raid6_calls raid6_sse2x2 = {
 
 #endif
 
-#ifdef __x86_64__
+#if defined(__x86_64__) && !defined(__arch_um__)
 
 /*
  * Unrolled-by-4 SSE2 implementation
diff --git a/drivers/md/raid6x86.h b/drivers/md/raid6x86.h
index 9111950..99fea7a 100644
--- a/drivers/md/raid6x86.h
+++ b/drivers/md/raid6x86.h
@@ -19,7 +19,7 @@
 #ifndef LINUX_RAID_RAID6X86_H
 #define LINUX_RAID_RAID6X86_H
 
-#if defined(__i386__) || defined(__x86_64__)
+#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
 
 #ifdef __KERNEL__ /* Real code */
 
diff --git a/include/asm-um/unistd.h b/include/asm-um/unistd.h
index 732c83f..38bd9d9 100644
--- a/include/asm-um/unistd.h
+++ b/include/asm-um/unistd.h
@@ -14,7 +14,6 @@ extern int um_execve(const char *file, char *const argv[], char *const env[]);
 
 #ifdef __KERNEL__
 /* We get __ARCH_WANT_OLD_STAT and __ARCH_WANT_STAT64 from the base arch */
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index d2a96cb..cf79853 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
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
diff --git a/kernel/signal.c b/kernel/signal.c
index 1200630..4537bdd 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -732,7 +732,7 @@ static void print_fatal_signal(struct pt_regs *regs, int signr)
 	printk("%s/%d: potentially unexpected fatal signal %d.\n",
 		current->comm, task_pid_nr(current), signr);
 
-#ifdef __i386__
+#if defined(__i386__) && !defined(__arch_um__)
 	printk("code at %08lx: ", regs->eip);
 	{
 		int i;
-- 
1.5.3.GIT


