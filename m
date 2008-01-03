Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbYACAvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYACAvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYACAuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbYACAuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:00 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [4/20] x86: Move nop declarations into separate include file
Message-Id: <20080103004959.54D6314D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:49:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Moving things out of processor.h is always a good thing.

Also needed to avoid include loop in later patch.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/nops.h      |   90 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor.h |   86 ------------------------------------------
 2 files changed, 91 insertions(+), 85 deletions(-)

Index: linux/include/asm-x86/nops.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86/nops.h
@@ -0,0 +1,90 @@
+#ifndef _ASM_NOPS_H
+#define _ASM_NOPS_H 1
+
+/* Define nops for use with alternative() */
+
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
+/* Opteron 64bit nops */
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
+#if defined(CONFIG_MK8)
+#define ASM_NOP1 K8_NOP1
+#define ASM_NOP2 K8_NOP2
+#define ASM_NOP3 K8_NOP3
+#define ASM_NOP4 K8_NOP4
+#define ASM_NOP5 K8_NOP5
+#define ASM_NOP6 K8_NOP6
+#define ASM_NOP7 K8_NOP7
+#define ASM_NOP8 K8_NOP8
+#elif defined(CONFIG_MK7)
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
+      defined(CONFIG_MCORE2) || defined(CONFIG_PENTIUM4)
+#define ASM_NOP1 P6_NOP1
+#define ASM_NOP2 P6_NOP2
+#define ASM_NOP3 P6_NOP3
+#define ASM_NOP4 P6_NOP4
+#define ASM_NOP5 P6_NOP5
+#define ASM_NOP6 P6_NOP6
+#define ASM_NOP7 P6_NOP7
+#define ASM_NOP8 P6_NOP8
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
+#endif
Index: linux/include/asm-x86/processor.h
===================================================================
--- linux.orig/include/asm-x86/processor.h
+++ linux/include/asm-x86/processor.h
@@ -20,6 +20,7 @@ struct mm_struct;
 #include <asm/percpu.h>
 #include <asm/msr.h>
 #include <asm/desc_defs.h>
+#include <asm/nops.h>
 #include <linux/personality.h>
 #include <linux/cpumask.h>
 #include <linux/cache.h>
@@ -674,91 +675,6 @@ extern int bootloader_type;
 extern char ignore_fpu_irq;
 #define cache_line_size() (boot_cpu_data.x86_cache_alignment)
 
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
-#ifdef CONFIG_MK7
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
-      defined(CONFIG_MCORE2) || defined(CONFIG_PENTIUM4) || \
-      defined(CONFIG_MPSC)
-#define ASM_NOP1 P6_NOP1
-#define ASM_NOP2 P6_NOP2
-#define ASM_NOP3 P6_NOP3
-#define ASM_NOP4 P6_NOP4
-#define ASM_NOP5 P6_NOP5
-#define ASM_NOP6 P6_NOP6
-#define ASM_NOP7 P6_NOP7
-#define ASM_NOP8 P6_NOP8
-#elif defined(CONFIG_MK8) || defined(CONFIG_X86_64)
-#define ASM_NOP1 K8_NOP1
-#define ASM_NOP2 K8_NOP2
-#define ASM_NOP3 K8_NOP3
-#define ASM_NOP4 K8_NOP4
-#define ASM_NOP5 K8_NOP5
-#define ASM_NOP6 K8_NOP6
-#define ASM_NOP7 K8_NOP7
-#define ASM_NOP8 K8_NOP8
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
 #define HAVE_ARCH_PICK_MMAP_LAYOUT 1
 #define ARCH_HAS_PREFETCHW
 #define ARCH_HAS_SPINLOCK_PREFETCH
