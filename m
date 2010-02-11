Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0BKUBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:01:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:4318 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822Ab0BKUA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:00:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,454,1262592000"; 
   d="scan'208";a="595215597"
Message-Id: <20100211195614.802495327@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 11 Feb 2010 11:50:59 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       peter.lachner@intel.com, suresh.b.siddha@intel.com
Subject: [patch v3 1/2] x86, ptrace: regset extensions to support xstate
References: <20100211195058.071883111@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=add_regset_for_xstate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the xstate regset support which helps extend the kernel ptrace and the
core-dump interfaces to support AVX state etc.

This regset interface is designed to support all the future state that gets
supported using xsave/xrstor infrastructure.

Looking at the memory layout saved by "xsave", one can't say which state
is represented in the memory layout. This is because if a particular state is
in init state, in the xsave hdr it can be represented by bit '0'. And hence
we can't really say by the xsave header wether a state is in init state or
the state is not saved in the memory layout.

And hence the xsave memory layout available through this regset
interface uses SW usable bytes [464..511] to convey what state is represented
in the memory layout.

First 8 bytes of the sw_usable_bytes[464..467] will be set to OS enabled xstate
mask(which is same as the 64bit mask returned by the xgetbv's xCR0).

The note NT_X86_XSTATE represents the extended state information in the
core file, using the above mentioned memory layout.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Hongjiu Lu <hjl.tools@gmail.com>
---
 arch/x86/include/asm/i387.h  |   12 +++++-
 arch/x86/include/asm/user.h  |   58 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/xsave.h |    2 +
 arch/x86/kernel/i387.c       |   83 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/ptrace.c     |   34 ++++++++++++++++-
 arch/x86/kernel/xsave.c      |    1 
 include/linux/elf.h          |    1 
 7 files changed, 187 insertions(+), 4 deletions(-)

Index: tip/arch/x86/include/asm/i387.h
===================================================================
--- tip.orig/arch/x86/include/asm/i387.h
+++ tip/arch/x86/include/asm/i387.h
@@ -33,8 +33,16 @@ extern void init_thread_xstate(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
 extern user_regset_active_fn fpregs_active, xfpregs_active;
-extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
-extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
+extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
+				xstateregs_get;
+extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
+				 xstateregs_set;
+
+/*
+ * xstateregs_active == fpregs_active. Please refer to the comment
+ * at the definition of fpregs_active.
+ */
+#define xstateregs_active	fpregs_active
 
 extern struct _fpx_sw_bytes fx_sw_reserved;
 #ifdef CONFIG_IA32_EMULATION
Index: tip/arch/x86/include/asm/xsave.h
===================================================================
--- tip.orig/arch/x86/include/asm/xsave.h
+++ tip/arch/x86/include/asm/xsave.h
@@ -27,9 +27,11 @@
 extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
 extern struct xsave_struct *init_xstate_buf;
+extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 
 extern void xsave_cntxt_init(void);
 extern void xsave_init(void);
+extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
 extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
 			    void __user *fpstate,
Index: tip/arch/x86/kernel/i387.c
===================================================================
--- tip.orig/arch/x86/kernel/i387.c
+++ tip/arch/x86/kernel/i387.c
@@ -164,6 +164,11 @@ int init_fpu(struct task_struct *tsk)
 	return 0;
 }
 
+/*
+ * The xstateregs_active() routine is the same as the fpregs_active() routine,
+ * as the "regset->n" for the xstate regset will be updated based on the feature
+ * capabilites supported by the xsave.
+ */
 int fpregs_active(struct task_struct *target, const struct user_regset *regset)
 {
 	return tsk_used_math(target) ? regset->n : 0;
@@ -224,6 +229,84 @@ int xfpregs_set(struct task_struct *targ
 	return ret;
 }
 
+int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
+		unsigned int pos, unsigned int count,
+		void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	if (!cpu_has_xsave)
+		return -ENODEV;
+
+	ret = init_fpu(target);
+	if (ret)
+		return ret;
+
+	/*
+	 * First copy the fxsave bytes 0..463.
+	 */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &target->thread.xstate->xsave, 0,
+				  offsetof(struct user_xstateregs,
+					   i387.xstate_fx_sw));
+	if (ret)
+		return ret;
+
+	/*
+	 * Copy the 48bytes defined by software.
+	 */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  xstate_fx_sw_bytes,
+				  offsetof(struct user_xstateregs,
+					   i387.xstate_fx_sw),
+				  offsetof(struct user_xstateregs,
+					   xsave_hdr));
+	if (ret)
+		return ret;
+
+	/*
+	 * Copy the rest of xstate memory layout.
+	 */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &target->thread.xstate->xsave.xsave_hdr,
+				  offsetof(struct user_xstateregs,
+					   xsave_hdr), -1);
+	return ret;
+}
+
+int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
+		  unsigned int pos, unsigned int count,
+		  const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	struct xsave_hdr_struct *xsave_hdr;
+
+	if (!cpu_has_xsave)
+		return -ENODEV;
+
+	ret = init_fpu(target);
+	if (ret)
+		return ret;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &target->thread.xstate->xsave, 0, -1);
+
+	/*
+	 * mxcsr reserved bits must be masked to zero for security reasons.
+	 */
+	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+
+	xsave_hdr = &target->thread.xstate->xsave.xsave_hdr;
+
+	xsave_hdr->xstate_bv &= pcntxt_mask;
+	/*
+	 * These bits must be zero.
+	 */
+	xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+
+	return ret;
+}
+
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
 
 /*
Index: tip/arch/x86/kernel/ptrace.c
===================================================================
--- tip.orig/arch/x86/kernel/ptrace.c
+++ tip/arch/x86/kernel/ptrace.c
@@ -48,6 +48,7 @@ enum x86_regset {
 	REGSET_FP,
 	REGSET_XFP,
 	REGSET_IOPERM64 = REGSET_XFP,
+	REGSET_XSTATE,
 	REGSET_TLS,
 	REGSET_IOPERM32,
 };
@@ -1560,7 +1561,7 @@ long compat_arch_ptrace(struct task_stru
 
 #ifdef CONFIG_X86_64
 
-static const struct user_regset x86_64_regsets[] = {
+static struct user_regset x86_64_regsets[] __read_mostly = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct) / sizeof(long),
@@ -1573,6 +1574,12 @@ static const struct user_regset x86_64_r
 		.size = sizeof(long), .align = sizeof(long),
 		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
 	},
+	[REGSET_XSTATE] = {
+		.core_note_type = NT_X86_XSTATE,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.active = xstateregs_active, .get = xstateregs_get,
+		.set = xstateregs_set
+	},
 	[REGSET_IOPERM64] = {
 		.core_note_type = NT_386_IOPERM,
 		.n = IO_BITMAP_LONGS,
@@ -1598,7 +1605,7 @@ static const struct user_regset_view use
 #endif	/* CONFIG_X86_64 */
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
-static const struct user_regset x86_32_regsets[] = {
+static struct user_regset x86_32_regsets[] __read_mostly = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct32) / sizeof(u32),
@@ -1617,6 +1624,12 @@ static const struct user_regset x86_32_r
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
 	},
+	[REGSET_XSTATE] = {
+		.core_note_type = NT_X86_XSTATE,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.active = xstateregs_active, .get = xstateregs_get,
+		.set = xstateregs_set
+	},
 	[REGSET_TLS] = {
 		.core_note_type = NT_386_TLS,
 		.n = GDT_ENTRY_TLS_ENTRIES, .bias = GDT_ENTRY_TLS_MIN,
@@ -1639,6 +1652,23 @@ static const struct user_regset_view use
 };
 #endif
 
+/*
+ * This represents bytes 464..511 in the memory layout exported through
+ * the REGSET_XSTATE interface.
+ */
+u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
+
+void update_regset_xstate_info(unsigned int size, u64 xstate_mask)
+{
+#ifdef CONFIG_X86_64
+	x86_64_regsets[REGSET_XSTATE].n = size / sizeof(u64);
+#endif
+#if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
+	x86_32_regsets[REGSET_XSTATE].n = size / sizeof(u64);
+#endif
+	xstate_fx_sw_bytes[USER_XSTATE_XCR0_WORD] = xstate_mask;
+}
+
 const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 {
 #ifdef CONFIG_IA32_EMULATION
Index: tip/arch/x86/kernel/xsave.c
===================================================================
--- tip.orig/arch/x86/kernel/xsave.c
+++ tip/arch/x86/kernel/xsave.c
@@ -337,6 +337,7 @@ void __ref xsave_cntxt_init(void)
 	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
 	xstate_size = ebx;
 
+	update_regset_xstate_info(xstate_size, pcntxt_mask);
 	prepare_fx_sw_frame();
 
 	setup_xstate_init();
Index: tip/include/linux/elf.h
===================================================================
--- tip.orig/include/linux/elf.h
+++ tip/include/linux/elf.h
@@ -361,6 +361,7 @@ typedef struct elf64_shdr {
 #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
 #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
 #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
+#define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */
 #define NT_S390_HIGH_GPRS	0x300	/* s390 upper register halves */
 
 
Index: tip/arch/x86/include/asm/user.h
===================================================================
--- tip.orig/arch/x86/include/asm/user.h
+++ tip/arch/x86/include/asm/user.h
@@ -1,5 +1,63 @@
+#ifndef _ASM_X86_USER_H
+#define _ASM_X86_USER_H
+
 #ifdef CONFIG_X86_32
 # include "user_32.h"
 #else
 # include "user_64.h"
 #endif
+
+#include <asm/types.h>
+
+struct user_ymmh_regs {
+	/* 16 * 16 bytes for each YMMH-reg */
+	__u32 ymmh_space[64];
+};
+
+struct user_xsave_hdr {
+	__u64 xstate_bv;
+	__u64 reserved1[2];
+	__u64 reserved2[5];
+};
+
+/*
+ * The structure layout of user_xstateregs, used for exporting the
+ * extended register state through ptrace and core-dump (NT_X86_XSTATE note)
+ * interfaces will be same as the memory layout of xsave used by the processor
+ * (except for the bytes 464..511, which can be used by the software) and hence
+ * the size of this structure varies depending on the features supported by the
+ * processor and OS. The size of the structure that users need to use can be
+ * obtained by doing:
+ *     cpuid_count(0xd, 0, &eax, &ptrace_xstateregs_struct_size, &ecx, &edx);
+ * i.e., cpuid.(eax=0xd,ecx=0).ebx will be the size that user (debuggers, etc.)
+ * need to use.
+ *
+ * For now, only the first 8 bytes of the software usable bytes[464..471] will
+ * be used and will be set to OS enabled xstate mask (which is same as the
+ * 64bit mask returned by the xgetbv's xCR0).  Users (analyzing core dump
+ * remotely, etc.) can use this mask as well as the mask saved in the
+ * xstate_hdr bytes and interpret what states the processor/OS supports
+ * and what states are in modified/initialized conditions for the
+ * particular process/thread.
+ *
+ * Also when the user modifies certain state FP/SSE/etc through the
+ * ptrace interface, they must ensure that the xsave_hdr.xstate_bv
+ * bytes[512..519] of the memory layout are updated correspondingly.
+ * i.e., for example when FP state is modified to a non-init state,
+ * xsave_hdr.xstate_bv's bit 0 must be set to '1', when SSE is modified to
+ * non-init state, xsave_hdr.xstate_bv's bit 1 must to be set to '1', etc.
+ */
+#define USER_XSTATE_FX_SW_WORDS 6
+#define USER_XSTATE_XCR0_WORD	0
+
+struct user_xstateregs {
+	struct {
+		__u64 fpx_space[58];
+		__u64 xstate_fx_sw[USER_XSTATE_FX_SW_WORDS];
+	} i387;
+	struct user_xsave_hdr xsave_hdr;
+	struct user_ymmh_regs ymmh;
+	/* further processor state extensions go here */
+};
+
+#endif /* _ASM_X86_USER_H */


