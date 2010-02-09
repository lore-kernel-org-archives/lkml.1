Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0BIU2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:28:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:61029 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab0BIU2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:28:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,438,1262592000"; 
   d="scan'208";a="242242017"
Message-Id: <20100209202502.216592031@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 09 Feb 2010 12:13:11 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch v2 2/4] x86, ptrace: regset extensions to support xstate
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
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
 arch/x86/include/asm/i387.h  |   12 ++++-
 arch/x86/include/asm/xsave.h |    2 
 arch/x86/kernel/i387.c       |   88 ++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/ptrace.c     |   29 +++++++++++++-
 arch/x86/kernel/xsave.c      |    1 
 include/linux/elf.h          |    1 
 6 files changed, 127 insertions(+), 6 deletions(-)

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
+extern u64 xstate_fx_sw_bytes[6];
 
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
+ * The xfpregs_active() routine is same as the fpregs_active() routine,
+ * as the "regset->n" for the xstate regset will be updated based on the feature
+ * capabilites supported by the xsave.
+ */
 int fpregs_active(struct task_struct *target, const struct user_regset *regset)
 {
 	return tsk_used_math(target) ? regset->n : 0;
@@ -204,8 +209,6 @@ int xfpregs_set(struct task_struct *targ
 	if (ret)
 		return ret;
 
-	set_stopped_child_used_math(target);
-
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.xstate->fxsave, 0, -1);
 
@@ -224,6 +227,87 @@ int xfpregs_set(struct task_struct *targ
 	return ret;
 }
 
+int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
+		unsigned int pos, unsigned int count,
+		void *kbuf, void __user *ubuf)
+{
+	int ret;
+	int size = regset->n * regset->size;
+	struct xsave_hdr_struct *xsave_hdr =
+				&target->thread.xstate->xsave.xsave_hdr;
+
+	if (!cpu_has_xsave)
+		return -ENODEV;
+
+	ret = init_fpu(target);
+	if (ret)
+		return ret;
+
+	/*
+	 * First copy the fxsave bytes 0..463
+	 */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &target->thread.xstate->xsave, 0,
+				  offsetof(struct i387_fxsave_struct,
+					   sw_reserved));
+	if (!ret)
+		/*
+		 * Copy the 48bytes defined by software
+		 */
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  xstate_fx_sw_bytes,
+					  offsetof(struct i387_fxsave_struct,
+						   sw_reserved),
+					  offsetof(struct xsave_struct,
+						   xsave_hdr));
+	if (!ret)
+		/*
+		 * Copy the rest of xstate memory layout
+		 */
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  xsave_hdr,
+					  offsetof(struct xsave_struct,
+						   xsave_hdr), size);
+	return ret;
+}
+
+int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
+		  unsigned int pos, unsigned int count,
+		  const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	int size = regset->n * regset->size;
+	struct xsave_hdr_struct *xsave_hdr =
+				&target->thread.xstate->xsave.xsave_hdr;
+
+
+	if (!cpu_has_xsave)
+		return -ENODEV;
+
+	ret = init_fpu(target);
+	if (ret)
+		return ret;
+
+	set_stopped_child_used_math(target);
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &target->thread.xstate->xsave, 0, size);
+
+	/*
+	 * mxcsr reserved bits must be masked to zero for security reasons.
+	 */
+	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+
+	xsave_hdr->xstate_bv &= pcntxt_mask;
+	/*
+	 * These bits must be zero.
+	 */
+	xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+
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
+		.size = sizeof(long), .align = sizeof(long),
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
+		.size = sizeof(u32), .align = sizeof(u32),
+		.active = xstateregs_active, .get = xstateregs_get,
+		.set = xstateregs_set
+	},
 	[REGSET_TLS] = {
 		.core_note_type = NT_386_TLS,
 		.n = GDT_ENTRY_TLS_ENTRIES, .bias = GDT_ENTRY_TLS_MIN,
@@ -1639,6 +1652,18 @@ static const struct user_regset_view use
 };
 #endif
 
+u64 xstate_fx_sw_bytes[6];
+void update_regset_xstate_info(unsigned int size, u64 xstate_mask)
+{
+#ifdef CONFIG_X86_64
+	x86_64_regsets[REGSET_XSTATE].n = size / sizeof(long);
+#endif
+#if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
+	x86_32_regsets[REGSET_XSTATE].n = size / sizeof(u32);
+#endif
+	xstate_fx_sw_bytes[0] = xstate_mask;
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
 
 


