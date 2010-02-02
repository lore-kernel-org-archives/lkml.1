Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0BBCDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 21:03:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:25862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab0BBCDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 21:03:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,386,1262592000"; 
   d="scan'208";a="592302034"
Subject: [patch] x86: ptrace and core-dump extensions for xstate
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Lu, Hongjiu" <hongjiu.lu@intel.com>,
       "Lachner, Peter" <peter.lachner@intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 01 Feb 2010 18:00:25 -0800
Message-Id: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel ptrace, core dump extensions to support AVX state etc. This interface
(PTRACE_GETXSTATEREGS, PTRACE_SETXSTATEREGS, NT_X86_XSTATE) is designed to
support all the future state that gets supported using xsave/xrstor
infrastructure.

Looking at the memory layout saved by "xsave", one can't say which state
is represented in the memory layout. This is because if a particular state is
in init state, in the xsave hdr it can be represented by bit '0'. And hence
we can't really say by the xsave header wether a state is in init state or
the state is not saved in the memory layout.

And hence the xsave memory layout available through the PTRACE_GETXSTATEREGS
and the core dump(NT_X86_XSTATE) uses SW usable bytes [464..511] to convey
what state is represented in the memory layout.

First 8 bytes of the sw_usable_bytes[464..467] will be set to OS enabled xstate
mask(which is same as the 64bit mask returned by the xgetbv's xCR0).

For more information on how to use this API by users like debuggers and core
dump, please refer to comments in arch/x86/include/asm/ptrace-abi.h

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Hongjiu Lu <hongjiu.lu@intel.com>
---

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index ebfb8a9..1cd5d43 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -32,9 +32,11 @@ extern void __math_state_restore(void);
 extern void init_thread_xstate(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
-extern user_regset_active_fn fpregs_active, xfpregs_active;
-extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
-extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
+extern user_regset_active_fn fpregs_active, xfpregs_active, xstateregs_active;
+extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
+				xstateregs_get;
+extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
+				 xstateregs_set;
 
 extern struct _fpx_sw_bytes fx_sw_reserved;
 #ifdef CONFIG_IA32_EMULATION
diff --git a/arch/x86/include/asm/ptrace-abi.h b/arch/x86/include/asm/ptrace-abi.h
index 8672303..6fe60cb 100644
--- a/arch/x86/include/asm/ptrace-abi.h
+++ b/arch/x86/include/asm/ptrace-abi.h
@@ -80,6 +80,44 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
+/*
+ * Structure layout used in PTRACE_GETXSTATEREGS/PTRACE_SETXSTATEREGS is same
+ * as the memory layout of xsave used by the processor (except for the bytes
+ * 464..511 which can be used by the software). Size of the structure that users
+ * need to use for these two interfaces can be obtained by doing:
+ * 	cpuid_count(0xd, 0, &eax, &ptrace_xstateregs_struct_size, &ecx, &edx);
+ * i.e., cpuid.(eax=0xd,ecx=0).ebx will be the size that user (debuggers etc)
+ * need to use.
+ *
+ * And format of this structure will be like:
+ * 	struct {
+ * 		fxsave_bytes[0..463]
+ * 		sw_usable_bytes[464..511]
+ * 		xsave_hdr_bytes[512..575]
+ * 		avx_bytes[576..831]
+ * 		future_state etc
+ * 	}
+ *
+ * Same memory layout will be used for the coredump NT_X86_XSTATE representing
+ * the xstate registers.
+ *
+ * For now, only first 8 bytes of the sw_usable_bytes[464..467] will be used and
+ * will be set to OS enabled xstate mask(which is same as the 64bit mask
+ * returned by the xgetbv's xCR0). Users (analyzing core dump remotely etc)
+ * can use this mask aswell as the mask saved in the xstate_hdr bytes and
+ * interpret what states the processor/OS supports and what states are in
+ * modified/initialized conditions for the particular process/thread.
+ *
+ * Also when the user modifies certain state FP/SSE/etc through this
+ * PTRACE_SETXSTATEREGS, they must ensure that the xsave_hdr.xstate_bv
+ * bytes[512..519] of the above memory layout are updated correspondingly.
+ * i.e., for example when FP state is modified to a non-init state,
+ * xsave_hdr.xstate_bv's bit 0 must be set to '1', when SSE is modified to
+ * non-init state, xsave_hdr.xstate_bv's bit 1 must to be set to '1' etc..
+ */
+#define PTRACE_GETXSTATEREGS      34
+#define PTRACE_SETXSTATEREGS      35
+
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 727acc1..9e26171 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
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
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f2f8540..dffdf91 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -224,6 +224,85 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	return ret;
 }
 
+int xstateregs_active(struct task_struct *target,
+		      const struct user_regset *regset)
+{
+	return (cpu_has_xsave && tsk_used_math(target)) ? xstate_size : 0;
+}
+
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
+	 * First copy the fxsave bytes 0..463
+	 */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &target->thread.xstate->xsave, 0,
+				  (sizeof(struct i387_fxsave_struct) -
+				   sizeof(xstate_fx_sw_bytes)));
+	/*
+	 * Copy the 48bytes defined by software
+	 */
+	ret |= user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   xstate_fx_sw_bytes,
+				   (sizeof(struct i387_fxsave_struct) -
+				    sizeof(xstate_fx_sw_bytes)),
+				   sizeof(struct i387_fxsave_struct));
+	/*
+	 * Copy the rest of xstate memory layout
+	 */
+	ret |= user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   &target->thread.xstate->xsave.xsave_hdr,
+				   sizeof(struct i387_fxsave_struct), -1);
+	return ret;
+}
+
+int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
+		  unsigned int pos, unsigned int count,
+		  const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	struct xsave_hdr_struct *xsave_hdr =
+				&current->thread.xstate->xsave.xsave_hdr;
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
+				 &target->thread.xstate->xsave, 0, -1);
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
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 73554a3..4bb5c1c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -48,6 +48,7 @@ enum x86_regset {
 	REGSET_FP,
 	REGSET_XFP,
 	REGSET_IOPERM64 = REGSET_XFP,
+	REGSET_XSTATE,
 	REGSET_TLS,
 	REGSET_IOPERM32,
 };
@@ -1208,6 +1209,20 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					     0, sizeof(struct user_i387_struct),
 					     datap);
 
+	case PTRACE_GETXSTATEREGS:	/* Get the child extended state. */
+		return copy_regset_to_user(child,
+					   task_user_regset_view(current),
+					   REGSET_XSTATE,
+					   0, xstate_size,
+					   datap);
+
+	case PTRACE_SETXSTATEREGS:	/* Set the child extended state. */
+		return copy_regset_from_user(child,
+					     task_user_regset_view(current),
+					     REGSET_XSTATE,
+					     0, xstate_size,
+					     datap);
+
 #ifdef CONFIG_X86_32
 	case PTRACE_GETFPXREGS:	/* Get the child extended FPU state. */
 		return copy_regset_to_user(child, &user_x86_32_view,
@@ -1537,6 +1552,16 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 					     sizeof(struct user32_fxsr_struct),
 					     datap);
 
+	case PTRACE_GETXSTATEREGS:	/* Get the child extended state. */
+		return copy_regset_to_user(child, &user_x86_32_view,
+					   REGSET_XSTATE, 0, xstate_size,
+					   datap);
+
+	case PTRACE_SETXSTATEREGS:	/* Set the child extended state. */
+		return copy_regset_from_user(child, &user_x86_32_view,
+					     REGSET_XSTATE, 0, xstate_size,
+					     datap);
+
 	case PTRACE_GET_THREAD_AREA:
 	case PTRACE_SET_THREAD_AREA:
 #ifdef CONFIG_X86_PTRACE_BTS
@@ -1560,7 +1585,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 #ifdef CONFIG_X86_64
 
-static const struct user_regset x86_64_regsets[] = {
+static struct user_regset x86_64_regsets[] __read_mostly = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct) / sizeof(long),
@@ -1573,6 +1598,12 @@ static const struct user_regset x86_64_regsets[] = {
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
@@ -1598,7 +1629,7 @@ static const struct user_regset_view user_x86_64_view = {
 #endif	/* CONFIG_X86_64 */
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
-static const struct user_regset x86_32_regsets[] = {
+static struct user_regset x86_32_regsets[] __read_mostly = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct32) / sizeof(u32),
@@ -1617,6 +1648,12 @@ static const struct user_regset x86_32_regsets[] = {
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
@@ -1639,6 +1676,18 @@ static const struct user_regset_view user_x86_32_view = {
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
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index c5ee17e..782c3a3 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -337,6 +337,7 @@ void __ref xsave_cntxt_init(void)
 	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
 	xstate_size = ebx;
 
+	update_regset_xstate_info(xstate_size, pcntxt_mask);
 	prepare_fx_sw_frame();
 
 	setup_xstate_init();
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 0cc4d55..a8c4af0 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -361,6 +361,7 @@ typedef struct elf64_shdr {
 #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
 #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
 #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
+#define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */
 #define NT_S390_HIGH_GPRS	0x300	/* s390 upper register halves */
 
 


