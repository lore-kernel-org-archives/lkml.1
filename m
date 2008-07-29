Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbYG2Rnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbYG2Rnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbYG2Rkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:40:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:41772 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758311AbYG2Rkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:40:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,273,1215414000"; 
   d="scan'208";a="602032826"
Message-Id: <20080729173157.527963000@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 10:29:19 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, roland@redhat.com, drepper@redhat.com,
       mikpe@it.uu.se, chrisw@sous-sol.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 2/9] x86, xsave: enable xsave/xrstor on cpus with xsave support
Content-Disposition: inline; filename=xsave_enable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables xsave/xrstor by turning on cr4.osxsave on cpu's which have
the xsave support. For now, features that OS supports/enabled are
FP and SSE.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip-0728/arch/x86/kernel/Makefile
===================================================================
--- tip-0728.orig/arch/x86/kernel/Makefile	2008-07-29 09:55:43.000000000 -0700
+++ tip-0728/arch/x86/kernel/Makefile	2008-07-29 09:55:46.000000000 -0700
@@ -39,7 +39,7 @@
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
-obj-y				+= i387.o
+obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
 obj-y				+= ds.o
 obj-$(CONFIG_X86_32)		+= tls.o
Index: tip-0728/arch/x86/kernel/cpu/common.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/cpu/common.c	2008-07-29 09:55:43.000000000 -0700
+++ tip-0728/arch/x86/kernel/cpu/common.c	2008-07-29 09:55:46.000000000 -0700
@@ -712,6 +712,14 @@
 	current_thread_info()->status = 0;
 	clear_used_math();
 	mxcsr_feature_mask_init();
+
+	/*
+	 * Boot processor to setup the FP and extended state context info.
+	 */
+	if (!smp_processor_id())
+		init_thread_xstate();
+
+	xsave_init();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
Index: tip-0728/arch/x86/kernel/i387.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/i387.c	2008-07-29 09:55:43.000000000 -0700
+++ tip-0728/arch/x86/kernel/i387.c	2008-07-29 09:55:46.000000000 -0700
@@ -61,6 +61,11 @@
 		return;
 	}
 
+	if (cpu_has_xsave) {
+		xsave_cntxt_init();
+		return;
+	}
+
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
 #ifdef CONFIG_X86_32
@@ -83,6 +88,13 @@
 
 	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
 
+	/*
+	 * Boot processor to setup the FP and extended state context info.
+	 */
+	if (!smp_processor_id())
+		init_thread_xstate();
+	xsave_init();
+
 	mxcsr_feature_mask_init();
 	/* clean state in init */
 	current_thread_info()->status = 0;
Index: tip-0728/arch/x86/kernel/traps_64.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/traps_64.c	2008-07-29 09:55:43.000000000 -0700
+++ tip-0728/arch/x86/kernel/traps_64.c	2008-07-29 09:55:46.000000000 -0700
@@ -1186,10 +1186,6 @@
 	set_system_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
 #endif
 	/*
-	 * initialize the per thread extended state:
-	 */
-	init_thread_xstate();
-	/*
 	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
Index: tip-0728/include/asm-x86/processor-flags.h
===================================================================
--- tip-0728.orig/include/asm-x86/processor-flags.h	2008-07-29 09:55:43.000000000 -0700
+++ tip-0728/include/asm-x86/processor-flags.h	2008-07-29 09:55:46.000000000 -0700
@@ -59,6 +59,7 @@
 #define X86_CR4_OSFXSR	0x00000200 /* enable fast FPU save and restore */
 #define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
 #define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
+#define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
 
 /*
  * x86-64 Task Priority Register, CR8
Index: tip-0728/arch/x86/kernel/xsave.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ tip-0728/arch/x86/kernel/xsave.c	2008-07-29 09:56:54.000000000 -0700
@@ -0,0 +1,87 @@
+/*
+ * xsave/xrstor support.
+ *
+ * Author: Suresh Siddha <suresh.b.siddha@intel.com>
+ */
+#include <linux/bootmem.h>
+#include <linux/compat.h>
+#include <asm/i387.h>
+
+/*
+ * Supported feature mask by the CPU and the kernel.
+ */
+unsigned int pcntxt_hmask, pcntxt_lmask;
+
+/*
+ * Represents init state for the supported extended state.
+ */
+struct xsave_struct *init_xstate_buf;
+
+/*
+ * Enable the extended processor state save/restore feature
+ */
+void __cpuinit xsave_init(void)
+{
+	if (!cpu_has_xsave)
+		return;
+
+	set_in_cr4(X86_CR4_OSXSAVE);
+
+	/*
+	 * Enable all the features that the HW is capable of
+	 * and the Linux kernel is aware of.
+	 *
+	 * xsetbv();
+	 */
+	asm volatile(".byte 0x0f,0x01,0xd1"::"c" (0),
+		     "a" (pcntxt_lmask), "d" (pcntxt_hmask));
+}
+
+/*
+ * setup the xstate image representing the init state
+ */
+void setup_xstate_init(void)
+{
+	init_xstate_buf = alloc_bootmem(xstate_size);
+	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
+}
+
+/*
+ * Enable and initialize the xsave feature.
+ */
+void __init xsave_cntxt_init(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+
+	pcntxt_lmask = eax;
+	pcntxt_hmask = edx;
+
+	if ((pcntxt_lmask & XSTATE_FPSSE) != XSTATE_FPSSE) {
+		printk(KERN_ERR "FP/SSE not shown under xsave features %x\n",
+		       pcntxt_lmask);
+		BUG();
+	}
+
+	/*
+	 * for now OS knows only about FP/SSE
+	 */
+	pcntxt_lmask = pcntxt_lmask & XCNTXT_LMASK;
+	pcntxt_hmask = pcntxt_hmask & XCNTXT_HMASK;
+
+	xsave_init();
+
+	/*
+	 * Recompute the context size for enabled features
+	 */
+	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+
+	xstate_size = ebx;
+
+	setup_xstate_init();
+
+	printk(KERN_INFO "xsave/xrstor: enabled xstate_bv 0x%Lx, "
+	       "cntxt size 0x%x\n",
+	       (pcntxt_lmask | ((u64) pcntxt_hmask << 32)), xstate_size);
+}
Index: tip-0728/include/asm-x86/xsave.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ tip-0728/include/asm-x86/xsave.h	2008-07-29 09:55:46.000000000 -0700
@@ -0,0 +1,26 @@
+#ifndef __ASM_X86_XSAVE_H
+#define __ASM_X86_XSAVE_H
+
+#include <asm/processor.h>
+#include <asm/i387.h>
+
+#define XSTATE_FP	0x1
+#define XSTATE_SSE	0x2
+
+#define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
+
+#define FXSAVE_SIZE	512
+
+/*
+ * These are the features that the OS can handle currently.
+ */
+#define XCNTXT_LMASK	(XSTATE_FP | XSTATE_SSE)
+#define XCNTXT_HMASK	0x0
+
+extern unsigned int xstate_size, pcntxt_hmask, pcntxt_lmask;
+extern struct xsave_struct *init_xstate_buf;
+
+extern void xsave_cntxt_init(void);
+extern void xsave_init(void);
+
+#endif
Index: tip-0728/arch/x86/kernel/traps_32.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/traps_32.c	2008-07-29 09:55:43.000000000 -0700
+++ tip-0728/arch/x86/kernel/traps_32.c	2008-07-29 09:55:46.000000000 -0700
@@ -1240,7 +1240,6 @@
 
 	set_bit(SYSCALL_VECTOR, used_vectors);
 
-	init_thread_xstate();
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
Index: tip-0728/include/asm-x86/i387.h
===================================================================
--- tip-0728.orig/include/asm-x86/i387.h	2008-07-29 09:55:43.000000000 -0700
+++ tip-0728/include/asm-x86/i387.h	2008-07-29 09:55:46.000000000 -0700
@@ -18,6 +18,7 @@
 #include <asm/sigcontext.h>
 #include <asm/user.h>
 #include <asm/uaccess.h>
+#include <asm/xsave.h>
 
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
Index: tip-0728/include/asm-x86/processor.h
===================================================================
--- tip-0728.orig/include/asm-x86/processor.h	2008-07-29 09:55:43.000000000 -0700
+++ tip-0728/include/asm-x86/processor.h	2008-07-29 09:55:46.000000000 -0700
@@ -351,6 +351,18 @@
 	u32			entry_eip;
 };
 
+struct xsave_hdr_struct {
+ 	u64 xstate_bv;
+ 	u64 reserved1[2];
+	u64 reserved2[5];
+} __attribute__((packed));
+
+struct xsave_struct {
+ 	struct i387_fxsave_struct i387;
+ 	struct xsave_hdr_struct xsave_hdr;
+ 	/* new processor state extensions will go here */
+} __attribute__ ((packed, aligned (64)));
+
 union thread_xstate {
 	struct i387_fsave_struct	fsave;
 	struct i387_fxsave_struct	fxsave;

-- 

