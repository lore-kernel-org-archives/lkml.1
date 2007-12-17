Return-Path: <linux-kernel-owner+w=401wt.eu-S937693AbXLRBqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937693AbXLRBqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764043AbXLRBih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:38:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763989AbXLRBif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:38:35 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 19/21] [PATCH] unify asm nops
Date: Mon, 17 Dec 2007 20:52:42 -0200
Message-Id: <11979320603229-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979320551036-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <1197932006634-git-send-email-gcosta@redhat.com> <11979320114180-git-send-email-gcosta@redhat.com> <11979320163651-git-send-email-gcosta@redhat.com> <11979320211287-git-send-email-gcosta@redhat.com> <11979320252102-git-send-email-gcosta@redhat.com> <11979320302030-git-send-email-gcosta@redhat.com> <11979320354186-git-send-email-gcosta@redhat.com> <11979320401316-git-send-email-gcosta@redhat.com> <11979320451308-git-send-email-gcosta@redhat.com> <1197932050948-git-send-email-gcosta@redhat.com> <11979320551036-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's only one difference between the NOPs used in asm code for i386 and x86_64:
i386 has a lot more variants. The code is moved to processor.h, and adjusted
accordingly.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/processor.h    |   85 ++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor_32.h |   85 ----------------------------------------
 include/asm-x86/processor_64.h |   44 --------------------
 3 files changed, 85 insertions(+), 129 deletions(-)

Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -588,6 +588,91 @@ extern int bootloader_type;
 extern char ignore_fpu_irq;
 #define cache_line_size() (boot_cpu_data.x86_cache_alignment)
 
+/* generic versions from gas */
+#define GENERIC_NOP1	".byte 0x90\n"
+#define GENERIC_NOP2    	".byte 0x89,0xf6\n"
+#define GENERIC_NOP3        ".byte 0x8d,0x76,0x00\n"
+#define GENERIC_NOP4        ".byte 0x8d,0x74,0x26,0x00\n"
+#define GENERIC_NOP5        GENERIC_NOP1 GENERIC_NOP4
+#define GENERIC_NOP6	".byte 0x8d,0xb6,0x00,0x00,0x00,0x00\n"
+#define GENERIC_NOP7	".byte 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00\n"
+#define GENERIC_NOP8	GENERIC_NOP1 GENERIC_NOP7
+
+/* Opteron nops */
+#define K8_NOP1 GENERIC_NOP1
+#define K8_NOP2	".byte 0x66,0x90\n"
+#define K8_NOP3	".byte 0x66,0x66,0x90\n"
+#define K8_NOP4	".byte 0x66,0x66,0x66,0x90\n"
+#define K8_NOP5	K8_NOP3 K8_NOP2
+#define K8_NOP6	K8_NOP3 K8_NOP3
+#define K8_NOP7	K8_NOP4 K8_NOP3
+#define K8_NOP8	K8_NOP4 K8_NOP4
+
+/* K7 nops */
+/* uses eax dependencies (arbitary choice) */
+#define K7_NOP1  GENERIC_NOP1
+#define K7_NOP2	".byte 0x8b,0xc0\n"
+#define K7_NOP3	".byte 0x8d,0x04,0x20\n"
+#define K7_NOP4	".byte 0x8d,0x44,0x20,0x00\n"
+#define K7_NOP5	K7_NOP4 ASM_NOP1
+#define K7_NOP6	".byte 0x8d,0x80,0,0,0,0\n"
+#define K7_NOP7        ".byte 0x8D,0x04,0x05,0,0,0,0\n"
+#define K7_NOP8        K7_NOP7 ASM_NOP1
+
+/* P6 nops */
+/* uses eax dependencies (Intel-recommended choice) */
+#define P6_NOP1	GENERIC_NOP1
+#define P6_NOP2	".byte 0x66,0x90\n"
+#define P6_NOP3	".byte 0x0f,0x1f,0x00\n"
+#define P6_NOP4	".byte 0x0f,0x1f,0x40,0\n"
+#define P6_NOP5	".byte 0x0f,0x1f,0x44,0x00,0\n"
+#define P6_NOP6	".byte 0x66,0x0f,0x1f,0x44,0x00,0\n"
+#define P6_NOP7	".byte 0x0f,0x1f,0x80,0,0,0,0\n"
+#define P6_NOP8	".byte 0x0f,0x1f,0x84,0x00,0,0,0,0\n"
+
+#ifdef CONFIG_MK7
+#define ASM_NOP1 K7_NOP1
+#define ASM_NOP2 K7_NOP2
+#define ASM_NOP3 K7_NOP3
+#define ASM_NOP4 K7_NOP4
+#define ASM_NOP5 K7_NOP5
+#define ASM_NOP6 K7_NOP6
+#define ASM_NOP7 K7_NOP7
+#define ASM_NOP8 K7_NOP8
+#elif defined(CONFIG_M686) || defined(CONFIG_MPENTIUMII) || \
+      defined(CONFIG_MPENTIUMIII) || defined(CONFIG_MPENTIUMM) || \
+      defined(CONFIG_MCORE2) || defined(CONFIG_PENTIUM4) || \
+      defined(CONFIG_MPSC)
+#define ASM_NOP1 P6_NOP1
+#define ASM_NOP2 P6_NOP2
+#define ASM_NOP3 P6_NOP3
+#define ASM_NOP4 P6_NOP4
+#define ASM_NOP5 P6_NOP5
+#define ASM_NOP6 P6_NOP6
+#define ASM_NOP7 P6_NOP7
+#define ASM_NOP8 P6_NOP8
+#elif defined(CONFIG_MK8) || defined(CONFIG_X86_64)
+#define ASM_NOP1 K8_NOP1
+#define ASM_NOP2 K8_NOP2
+#define ASM_NOP3 K8_NOP3
+#define ASM_NOP4 K8_NOP4
+#define ASM_NOP5 K8_NOP5
+#define ASM_NOP6 K8_NOP6
+#define ASM_NOP7 K8_NOP7
+#define ASM_NOP8 K8_NOP8
+#else
+#define ASM_NOP1 GENERIC_NOP1
+#define ASM_NOP2 GENERIC_NOP2
+#define ASM_NOP3 GENERIC_NOP3
+#define ASM_NOP4 GENERIC_NOP4
+#define ASM_NOP5 GENERIC_NOP5
+#define ASM_NOP6 GENERIC_NOP6
+#define ASM_NOP7 GENERIC_NOP7
+#define ASM_NOP8 GENERIC_NOP8
+#endif
+
+#define ASM_NOP_MAX 8
+
 #define HAVE_ARCH_PICK_MMAP_LAYOUT 1
 #define ARCH_HAS_PREFETCHW
 #define ARCH_HAS_SPINLOCK_PREFETCH
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <asm/desc_defs.h>
 
-
 /*
  * the following now lives in the per cpu area:
  * extern	int cpu_llc_id[NR_CPUS];
@@ -144,88 +143,4 @@ extern unsigned long thread_saved_pc(str
 
 #define KSTK_ESP(task) (task_pt_regs(task)->sp)
 
-/* generic versions from gas */
-#define GENERIC_NOP1	".byte 0x90\n"
-#define GENERIC_NOP2    	".byte 0x89,0xf6\n"
-#define GENERIC_NOP3        ".byte 0x8d,0x76,0x00\n"
-#define GENERIC_NOP4        ".byte 0x8d,0x74,0x26,0x00\n"
-#define GENERIC_NOP5        GENERIC_NOP1 GENERIC_NOP4
-#define GENERIC_NOP6	".byte 0x8d,0xb6,0x00,0x00,0x00,0x00\n"
-#define GENERIC_NOP7	".byte 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00\n"
-#define GENERIC_NOP8	GENERIC_NOP1 GENERIC_NOP7
-
-/* Opteron nops */
-#define K8_NOP1 GENERIC_NOP1
-#define K8_NOP2	".byte 0x66,0x90\n" 
-#define K8_NOP3	".byte 0x66,0x66,0x90\n" 
-#define K8_NOP4	".byte 0x66,0x66,0x66,0x90\n" 
-#define K8_NOP5	K8_NOP3 K8_NOP2 
-#define K8_NOP6	K8_NOP3 K8_NOP3
-#define K8_NOP7	K8_NOP4 K8_NOP3
-#define K8_NOP8	K8_NOP4 K8_NOP4
-
-/* K7 nops */
-/* uses eax dependencies (arbitary choice) */
-#define K7_NOP1  GENERIC_NOP1
-#define K7_NOP2	".byte 0x8b,0xc0\n" 
-#define K7_NOP3	".byte 0x8d,0x04,0x20\n"
-#define K7_NOP4	".byte 0x8d,0x44,0x20,0x00\n"
-#define K7_NOP5	K7_NOP4 ASM_NOP1
-#define K7_NOP6	".byte 0x8d,0x80,0,0,0,0\n"
-#define K7_NOP7        ".byte 0x8D,0x04,0x05,0,0,0,0\n"
-#define K7_NOP8        K7_NOP7 ASM_NOP1
-
-/* P6 nops */
-/* uses eax dependencies (Intel-recommended choice) */
-#define P6_NOP1	GENERIC_NOP1
-#define P6_NOP2	".byte 0x66,0x90\n"
-#define P6_NOP3	".byte 0x0f,0x1f,0x00\n"
-#define P6_NOP4	".byte 0x0f,0x1f,0x40,0\n"
-#define P6_NOP5	".byte 0x0f,0x1f,0x44,0x00,0\n"
-#define P6_NOP6	".byte 0x66,0x0f,0x1f,0x44,0x00,0\n"
-#define P6_NOP7	".byte 0x0f,0x1f,0x80,0,0,0,0\n"
-#define P6_NOP8	".byte 0x0f,0x1f,0x84,0x00,0,0,0,0\n"
-
-#ifdef CONFIG_MK8
-#define ASM_NOP1 K8_NOP1
-#define ASM_NOP2 K8_NOP2
-#define ASM_NOP3 K8_NOP3
-#define ASM_NOP4 K8_NOP4
-#define ASM_NOP5 K8_NOP5
-#define ASM_NOP6 K8_NOP6
-#define ASM_NOP7 K8_NOP7
-#define ASM_NOP8 K8_NOP8
-#elif defined(CONFIG_MK7)
-#define ASM_NOP1 K7_NOP1
-#define ASM_NOP2 K7_NOP2
-#define ASM_NOP3 K7_NOP3
-#define ASM_NOP4 K7_NOP4
-#define ASM_NOP5 K7_NOP5
-#define ASM_NOP6 K7_NOP6
-#define ASM_NOP7 K7_NOP7
-#define ASM_NOP8 K7_NOP8
-#elif defined(CONFIG_M686) || defined(CONFIG_MPENTIUMII) || \
-      defined(CONFIG_MPENTIUMIII) || defined(CONFIG_MPENTIUMM) || \
-      defined(CONFIG_MCORE2) || defined(CONFIG_PENTIUM4)
-#define ASM_NOP1 P6_NOP1
-#define ASM_NOP2 P6_NOP2
-#define ASM_NOP3 P6_NOP3
-#define ASM_NOP4 P6_NOP4
-#define ASM_NOP5 P6_NOP5
-#define ASM_NOP6 P6_NOP6
-#define ASM_NOP7 P6_NOP7
-#define ASM_NOP8 P6_NOP8
-#else
-#define ASM_NOP1 GENERIC_NOP1
-#define ASM_NOP2 GENERIC_NOP2
-#define ASM_NOP3 GENERIC_NOP3
-#define ASM_NOP4 GENERIC_NOP4
-#define ASM_NOP5 GENERIC_NOP5
-#define ASM_NOP6 GENERIC_NOP6
-#define ASM_NOP7 GENERIC_NOP7
-#define ASM_NOP8 GENERIC_NOP8
-#endif
-
-#define ASM_NOP_MAX 8
-
 #endif /* __ASM_I386_PROCESSOR_H */
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -80,48 +80,4 @@ DECLARE_PER_CPU(struct orig_ist, orig_is
 #define task_pt_regs(tsk) ((struct pt_regs *)(tsk)->thread.sp0 - 1)
 #define KSTK_ESP(tsk) -1 /* sorry. doesn't work for syscall. */
 
-
-#if defined(CONFIG_MPSC) || defined(CONFIG_MCORE2)
-#define ASM_NOP1 P6_NOP1
-#define ASM_NOP2 P6_NOP2
-#define ASM_NOP3 P6_NOP3
-#define ASM_NOP4 P6_NOP4
-#define ASM_NOP5 P6_NOP5
-#define ASM_NOP6 P6_NOP6
-#define ASM_NOP7 P6_NOP7
-#define ASM_NOP8 P6_NOP8
-#else
-#define ASM_NOP1 K8_NOP1
-#define ASM_NOP2 K8_NOP2
-#define ASM_NOP3 K8_NOP3
-#define ASM_NOP4 K8_NOP4
-#define ASM_NOP5 K8_NOP5
-#define ASM_NOP6 K8_NOP6
-#define ASM_NOP7 K8_NOP7
-#define ASM_NOP8 K8_NOP8
-#endif
-
-/* Opteron nops */
-#define K8_NOP1 ".byte 0x90\n"
-#define K8_NOP2	".byte 0x66,0x90\n" 
-#define K8_NOP3	".byte 0x66,0x66,0x90\n" 
-#define K8_NOP4	".byte 0x66,0x66,0x66,0x90\n" 
-#define K8_NOP5	K8_NOP3 K8_NOP2 
-#define K8_NOP6	K8_NOP3 K8_NOP3
-#define K8_NOP7	K8_NOP4 K8_NOP3
-#define K8_NOP8	K8_NOP4 K8_NOP4
-
-/* P6 nops */
-/* uses eax dependencies (Intel-recommended choice) */
-#define P6_NOP1	".byte 0x90\n"
-#define P6_NOP2	".byte 0x66,0x90\n"
-#define P6_NOP3	".byte 0x0f,0x1f,0x00\n"
-#define P6_NOP4	".byte 0x0f,0x1f,0x40,0\n"
-#define P6_NOP5	".byte 0x0f,0x1f,0x44,0x00,0\n"
-#define P6_NOP6	".byte 0x66,0x0f,0x1f,0x44,0x00,0\n"
-#define P6_NOP7	".byte 0x0f,0x1f,0x80,0,0,0,0\n"
-#define P6_NOP8	".byte 0x0f,0x1f,0x84,0x00,0,0,0,0\n"
-
-#define ASM_NOP_MAX 8
-
 #endif /* __ASM_X86_64_PROCESSOR_H */
