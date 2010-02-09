Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab0BIWzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:55:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:34759 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab0BIWzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:55:15 -0500
Date: Tue, 9 Feb 2010 22:54:38 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20100209202502.129595258@sbs-t61.sc.intel.com>
References: <20100209202502.129595258@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/ptrace] Revert "x86: ptrace and core-dump extensions for xstate"
Message-ID: <tip-bea19fc4b32ec1974edaa999290e23b6375b0768@git.kernel.org>
Git-Commit-ID: bea19fc4b32ec1974edaa999290e23b6375b0768
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Feb 2010 22:54:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bea19fc4b32ec1974edaa999290e23b6375b0768
Gitweb:     http://git.kernel.org/tip/bea19fc4b32ec1974edaa999290e23b6375b0768
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 9 Feb 2010 12:13:10 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 9 Feb 2010 14:09:41 -0800

Revert "x86: ptrace and core-dump extensions for xstate"

Revert commit c741196df8a42602965f781e0f09462de81742e2. Updated patches based
on Roland's feedback follow.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100209202502.129595258@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/i387.h       |    8 +--
 arch/x86/include/asm/ptrace-abi.h |   38 ------------------
 arch/x86/include/asm/xsave.h      |    2 -
 arch/x86/kernel/i387.c            |   79 -------------------------------------
 arch/x86/kernel/ptrace.c          |   53 +------------------------
 arch/x86/kernel/xsave.c           |    1 -
 include/linux/elf.h               |    1 -
 7 files changed, 5 insertions(+), 177 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 1cd5d43..ebfb8a9 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
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
diff --git a/arch/x86/include/asm/ptrace-abi.h b/arch/x86/include/asm/ptrace-abi.h
index 447cfb6..8672303 100644
--- a/arch/x86/include/asm/ptrace-abi.h
+++ b/arch/x86/include/asm/ptrace-abi.h
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
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 9e26171..727acc1 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
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
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index dffdf91..f2f8540 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -224,85 +224,6 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
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
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index df9add9..017d937 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -48,7 +48,6 @@ enum x86_regset {
 	REGSET_FP,
 	REGSET_XFP,
 	REGSET_IOPERM64 = REGSET_XFP,
-	REGSET_XSTATE,
 	REGSET_TLS,
 	REGSET_IOPERM32,
 };
@@ -1233,20 +1232,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
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
@@ -1576,16 +1561,6 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
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
@@ -1609,7 +1584,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 #ifdef CONFIG_X86_64
 
-static struct user_regset x86_64_regsets[] __read_mostly = {
+static const struct user_regset x86_64_regsets[] = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct) / sizeof(long),
@@ -1622,12 +1597,6 @@ static struct user_regset x86_64_regsets[] __read_mostly = {
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
@@ -1653,7 +1622,7 @@ static const struct user_regset_view user_x86_64_view = {
 #endif	/* CONFIG_X86_64 */
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
-static struct user_regset x86_32_regsets[] __read_mostly = {
+static const struct user_regset x86_32_regsets[] = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct32) / sizeof(u32),
@@ -1672,12 +1641,6 @@ static struct user_regset x86_32_regsets[] __read_mostly = {
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
@@ -1700,18 +1663,6 @@ static const struct user_regset_view user_x86_32_view = {
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
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 782c3a3..c5ee17e 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -337,7 +337,6 @@ void __ref xsave_cntxt_init(void)
 	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
 	xstate_size = ebx;
 
-	update_regset_xstate_info(xstate_size, pcntxt_mask);
 	prepare_fx_sw_frame();
 
 	setup_xstate_init();
diff --git a/include/linux/elf.h b/include/linux/elf.h
index a8c4af0..0cc4d55 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -361,7 +361,6 @@ typedef struct elf64_shdr {
 #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
 #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
 #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
-#define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */
 #define NT_S390_HIGH_GPRS	0x300	/* s390 upper register halves */
 
 
