Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab0BIU20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:28:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:56226 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab0BIU2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:28:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,438,1262592000"; 
   d="scan'208";a="539273813"
Message-Id: <20100209202502.129595258@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 09 Feb 2010 12:13:10 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch v2 1/4] revert "x86: ptrace and core-dump extensions for xstate"
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=revert_current_ptrace_coredump_support_for_xstate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert commit c741196df8a42602965f781e0f09462de81742e2. Updated patches based
on Roland's feedback follow.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/i387.h       |    8 +--
 arch/x86/include/asm/ptrace-abi.h |   38 ------------------
 arch/x86/include/asm/xsave.h      |    2 
 arch/x86/kernel/i387.c            |   79 --------------------------------------
 arch/x86/kernel/ptrace.c          |   53 -------------------------
 arch/x86/kernel/xsave.c           |    1 
 include/linux/elf.h               |    1 
 7 files changed, 5 insertions(+), 177 deletions(-)

Index: tip/arch/x86/include/asm/i387.h
===================================================================
--- tip.orig/arch/x86/include/asm/i387.h
+++ tip/arch/x86/include/asm/i387.h
@@ -32,11 +32,9 @@ extern void __math_state_restore(void);
 extern void init_thread_xstate(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
-extern user_regset_active_fn fpregs_active, xfpregs_active, xstateregs_active;
-extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get,
-				xstateregs_get;
-extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set,
-				 xstateregs_set;
+extern user_regset_active_fn fpregs_active, xfpregs_active;
+extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
+extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
 
 extern struct _fpx_sw_bytes fx_sw_reserved;
 #ifdef CONFIG_IA32_EMULATION
Index: tip/arch/x86/include/asm/ptrace-abi.h
===================================================================
--- tip.orig/arch/x86/include/asm/ptrace-abi.h
+++ tip/arch/x86/include/asm/ptrace-abi.h
@@ -80,44 +80,6 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
-/*
- * Structure layout used in PTRACE_GETXSTATEREGS/PTRACE_SETXSTATEREGS is same
- * as the memory layout of xsave used by the processor (except for the bytes
- * 464..511 which can be used by the software). Size of the structure that users
- * need to use for these two interfaces can be obtained by doing:
- *	cpuid_count(0xd, 0, &eax, &ptrace_xstateregs_struct_size, &ecx, &edx);
- * i.e., cpuid.(eax=0xd,ecx=0).ebx will be the size that user (debuggers etc)
- * need to use.
- *
- * And format of this structure will be like:
- *	struct {
- *		fxsave_bytes[0..463]
- *		sw_usable_bytes[464..511]
- *		xsave_hdr_bytes[512..575]
- *		avx_bytes[576..831]
- *		future_state etc
- *	}
- *
- * Same memory layout will be used for the coredump NT_X86_XSTATE representing
- * the xstate registers.
- *
- * For now, only first 8 bytes of the sw_usable_bytes[464..467] will be used and
- * will be set to OS enabled xstate mask(which is same as the 64bit mask
- * returned by the xgetbv's xCR0). Users (analyzing core dump remotely etc)
- * can use this mask aswell as the mask saved in the xstate_hdr bytes and
- * interpret what states the processor/OS supports and what states are in
- * modified/initialized conditions for the particular process/thread.
- *
- * Also when the user modifies certain state FP/SSE/etc through this
- * PTRACE_SETXSTATEREGS, they must ensure that the xsave_hdr.xstate_bv
- * bytes[512..519] of the above memory layout are updated correspondingly.
- * i.e., for example when FP state is modified to a non-init state,
- * xsave_hdr.xstate_bv's bit 0 must be set to '1', when SSE is modified to
- * non-init state, xsave_hdr.xstate_bv's bit 1 must to be set to '1' etc..
- */
-#define PTRACE_GETXSTATEREGS      34
-#define PTRACE_SETXSTATEREGS      35
-
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 
Index: tip/arch/x86/include/asm/xsave.h
===================================================================
--- tip.orig/arch/x86/include/asm/xsave.h
+++ tip/arch/x86/include/asm/xsave.h
@@ -27,11 +27,9 @@
 extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
 extern struct xsave_struct *init_xstate_buf;
-extern u64 xstate_fx_sw_bytes[6];
 
 extern void xsave_cntxt_init(void);
 extern void xsave_init(void);
-extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
 extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
 			    void __user *fpstate,
Index: tip/arch/x86/kernel/i387.c
===================================================================
--- tip.orig/arch/x86/kernel/i387.c
+++ tip/arch/x86/kernel/i387.c
@@ -224,85 +224,6 @@ int xfpregs_set(struct task_struct *targ
 	return ret;
 }
 
-int xstateregs_active(struct task_struct *target,
-		      const struct user_regset *regset)
-{
-	return (cpu_has_xsave && tsk_used_math(target)) ? xstate_size : 0;
-}
-
-int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
-		unsigned int pos, unsigned int count,
-		void *kbuf, void __user *ubuf)
-{
-	int ret;
-
-	if (!cpu_has_xsave)
-		return -ENODEV;
-
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
-
-	/*
-	 * First copy the fxsave bytes 0..463
-	 */
-	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				  &target->thread.xstate->xsave, 0,
-				  (sizeof(struct i387_fxsave_struct) -
-				   sizeof(xstate_fx_sw_bytes)));
-	/*
-	 * Copy the 48bytes defined by software
-	 */
-	ret |= user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				   xstate_fx_sw_bytes,
-				   (sizeof(struct i387_fxsave_struct) -
-				    sizeof(xstate_fx_sw_bytes)),
-				   sizeof(struct i387_fxsave_struct));
-	/*
-	 * Copy the rest of xstate memory layout
-	 */
-	ret |= user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				   &target->thread.xstate->xsave.xsave_hdr,
-				   sizeof(struct i387_fxsave_struct), -1);
-	return ret;
-}
-
-int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
-		  unsigned int pos, unsigned int count,
-		  const void *kbuf, const void __user *ubuf)
-{
-	int ret;
-	struct xsave_hdr_struct *xsave_hdr =
-				&current->thread.xstate->xsave.xsave_hdr;
-
-
-	if (!cpu_has_xsave)
-		return -ENODEV;
-
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
-
-	set_stopped_child_used_math(target);
-
-	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.xstate->xsave, 0, -1);
-
-	/*
-	 * mxcsr reserved bits must be masked to zero for security reasons.
-	 */
-	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
-
-	xsave_hdr->xstate_bv &= pcntxt_mask;
-	/*
-	 * These bits must be zero.
-	 */
-	xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
-
-
-	return ret;
-}
-
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
 
 /*
Index: tip/arch/x86/kernel/ptrace.c
===================================================================
--- tip.orig/arch/x86/kernel/ptrace.c
+++ tip/arch/x86/kernel/ptrace.c
@@ -48,7 +48,6 @@ enum x86_regset {
 	REGSET_FP,
 	REGSET_XFP,
 	REGSET_IOPERM64 = REGSET_XFP,
-	REGSET_XSTATE,
 	REGSET_TLS,
 	REGSET_IOPERM32,
 };
@@ -1209,20 +1208,6 @@ long arch_ptrace(struct task_struct *chi
 					     0, sizeof(struct user_i387_struct),
 					     datap);
 
-	case PTRACE_GETXSTATEREGS:	/* Get the child extended state. */
-		return copy_regset_to_user(child,
-					   task_user_regset_view(current),
-					   REGSET_XSTATE,
-					   0, xstate_size,
-					   datap);
-
-	case PTRACE_SETXSTATEREGS:	/* Set the child extended state. */
-		return copy_regset_from_user(child,
-					     task_user_regset_view(current),
-					     REGSET_XSTATE,
-					     0, xstate_size,
-					     datap);
-
 #ifdef CONFIG_X86_32
 	case PTRACE_GETFPXREGS:	/* Get the child extended FPU state. */
 		return copy_regset_to_user(child, &user_x86_32_view,
@@ -1552,16 +1537,6 @@ long compat_arch_ptrace(struct task_stru
 					     sizeof(struct user32_fxsr_struct),
 					     datap);
 
-	case PTRACE_GETXSTATEREGS:	/* Get the child extended state. */
-		return copy_regset_to_user(child, &user_x86_32_view,
-					   REGSET_XSTATE, 0, xstate_size,
-					   datap);
-
-	case PTRACE_SETXSTATEREGS:	/* Set the child extended state. */
-		return copy_regset_from_user(child, &user_x86_32_view,
-					     REGSET_XSTATE, 0, xstate_size,
-					     datap);
-
 	case PTRACE_GET_THREAD_AREA:
 	case PTRACE_SET_THREAD_AREA:
 #ifdef CONFIG_X86_PTRACE_BTS
@@ -1585,7 +1560,7 @@ long compat_arch_ptrace(struct task_stru
 
 #ifdef CONFIG_X86_64
 
-static struct user_regset x86_64_regsets[] __read_mostly = {
+static const struct user_regset x86_64_regsets[] = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct) / sizeof(long),
@@ -1598,12 +1573,6 @@ static struct user_regset x86_64_regsets
 		.size = sizeof(long), .align = sizeof(long),
 		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
 	},
-	[REGSET_XSTATE] = {
-		.core_note_type = NT_X86_XSTATE,
-		.size = sizeof(long), .align = sizeof(long),
-		.active = xstateregs_active, .get = xstateregs_get,
-		.set = xstateregs_set
-	},
 	[REGSET_IOPERM64] = {
 		.core_note_type = NT_386_IOPERM,
 		.n = IO_BITMAP_LONGS,
@@ -1629,7 +1598,7 @@ static const struct user_regset_view use
 #endif	/* CONFIG_X86_64 */
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
-static struct user_regset x86_32_regsets[] __read_mostly = {
+static const struct user_regset x86_32_regsets[] = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct32) / sizeof(u32),
@@ -1648,12 +1617,6 @@ static struct user_regset x86_32_regsets
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
 	},
-	[REGSET_XSTATE] = {
-		.core_note_type = NT_X86_XSTATE,
-		.size = sizeof(u32), .align = sizeof(u32),
-		.active = xstateregs_active, .get = xstateregs_get,
-		.set = xstateregs_set
-	},
 	[REGSET_TLS] = {
 		.core_note_type = NT_386_TLS,
 		.n = GDT_ENTRY_TLS_ENTRIES, .bias = GDT_ENTRY_TLS_MIN,
@@ -1676,18 +1639,6 @@ static const struct user_regset_view use
 };
 #endif
 
-u64 xstate_fx_sw_bytes[6];
-void update_regset_xstate_info(unsigned int size, u64 xstate_mask)
-{
-#ifdef CONFIG_X86_64
-	x86_64_regsets[REGSET_XSTATE].n = size / sizeof(long);
-#endif
-#if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
-	x86_32_regsets[REGSET_XSTATE].n = size / sizeof(u32);
-#endif
-	xstate_fx_sw_bytes[0] = xstate_mask;
-}
-
 const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 {
 #ifdef CONFIG_IA32_EMULATION
Index: tip/arch/x86/kernel/xsave.c
===================================================================
--- tip.orig/arch/x86/kernel/xsave.c
+++ tip/arch/x86/kernel/xsave.c
@@ -337,7 +337,6 @@ void __ref xsave_cntxt_init(void)
 	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
 	xstate_size = ebx;
 
-	update_regset_xstate_info(xstate_size, pcntxt_mask);
 	prepare_fx_sw_frame();
 
 	setup_xstate_init();
Index: tip/include/linux/elf.h
===================================================================
--- tip.orig/include/linux/elf.h
+++ tip/include/linux/elf.h
@@ -361,7 +361,6 @@ typedef struct elf64_shdr {
 #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
 #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
 #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
-#define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */
 #define NT_S390_HIGH_GPRS	0x300	/* s390 upper register halves */
 
 


