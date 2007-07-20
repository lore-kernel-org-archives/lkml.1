Return-Path: <linux-kernel-owner+w=401wt.eu-S965050AbXGTPdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050AbXGTPdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934904AbXGTPcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:32:52 -0400
Received: from ns.suse.de ([195.135.220.2]:50692 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933492AbXGTPcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:32:50 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/11] x86: Unify alternative nop handling between i386 and x86-64
Message-Id: <20070720153249.95B3514E79@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Move nops into own header file.
Removes some duplicated code and some ifdefs.
The x86-64 kernel now knows about Intel (and K7) nops.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/asm-i386/processor-nops.h
===================================================================
--- /dev/null
+++ linux/include/asm-i386/processor-nops.h
@@ -0,0 +1,66 @@
+#ifndef _ASM_PROCESSOR_NOPS_H
+#define _ASM_PROCESSOR_NOPS_H 1
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
+#ifdef CONFIG_MK8
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
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -22,6 +22,7 @@
 #include <linux/cpumask.h>
 #include <linux/init.h>
 #include <asm/processor-flags.h>
+#include <asm/processor-nops.h>
 
 /* flag for disabling the tsc */
 extern int tsc_disable;
@@ -654,68 +655,6 @@ static inline unsigned int cpuid_edx(uns
 	return edx;
 }
 
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
 /* Prefetch instructions for Pentium III and AMD Athlon */
 /* It's not worth to care about 3dnow! prefetches for the K6
    because they are microcoded there and very slow.
Index: linux/include/asm-x86_64/processor.h
===================================================================
--- linux.orig/include/asm-x86_64/processor.h
+++ linux/include/asm-x86_64/processor.h
@@ -21,6 +21,7 @@
 #include <linux/personality.h>
 #include <linux/cpumask.h>
 #include <asm/processor-flags.h>
+#include <asm-i386/processor-nops.h>
 
 #define TF_MASK		0x00000100
 #define IF_MASK		0x00000200
@@ -339,28 +340,6 @@ struct extended_sigtable {
 	struct extended_signature sigs[0];
 };
 
-
-#define ASM_NOP1 K8_NOP1
-#define ASM_NOP2 K8_NOP2
-#define ASM_NOP3 K8_NOP3
-#define ASM_NOP4 K8_NOP4
-#define ASM_NOP5 K8_NOP5
-#define ASM_NOP6 K8_NOP6
-#define ASM_NOP7 K8_NOP7
-#define ASM_NOP8 K8_NOP8
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
-#define ASM_NOP_MAX 8
-
 /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
 static inline void rep_nop(void)
 {
Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -56,7 +56,6 @@ __setup("noreplace-paravirt", setup_nore
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
 
-#ifdef GENERIC_NOP1
 /* Use inline assembly to define this because the nops are defined
    as inline assembly strings in the include files and we cannot
    get them easily into strings. */
@@ -75,9 +74,7 @@ static unsigned char *intel_nops[ASM_NOP
 	intelnops + 1 + 2 + 3 + 4 + 5 + 6,
 	intelnops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
 };
-#endif
 
-#ifdef K8_NOP1
 asm("\t.data\nk8nops: "
 	K8_NOP1 K8_NOP2 K8_NOP3 K8_NOP4 K8_NOP5 K8_NOP6
 	K8_NOP7 K8_NOP8);
@@ -93,9 +90,7 @@ static unsigned char *k8_nops[ASM_NOP_MA
 	k8nops + 1 + 2 + 3 + 4 + 5 + 6,
 	k8nops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
 };
-#endif
 
-#ifdef K7_NOP1
 asm("\t.data\nk7nops: "
 	K7_NOP1 K7_NOP2 K7_NOP3 K7_NOP4 K7_NOP5 K7_NOP6
 	K7_NOP7 K7_NOP8);
@@ -111,17 +106,10 @@ static unsigned char *k7_nops[ASM_NOP_MA
 	k7nops + 1 + 2 + 3 + 4 + 5 + 6,
 	k7nops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
 };
-#endif
 
 #ifdef CONFIG_X86_64
-
 extern char __vsyscall_0;
-static inline unsigned char** find_nop_table(void)
-{
-	return k8_nops;
-}
-
-#else /* CONFIG_X86_64 */
+#endif
 
 static struct nop {
 	int cpuid;
@@ -146,8 +134,6 @@ static unsigned char** find_nop_table(vo
 	return noptable;
 }
 
-#endif /* CONFIG_X86_64 */
-
 static void nop_out(void *insns, unsigned int len)
 {
 	unsigned char **noptable = find_nop_table();
