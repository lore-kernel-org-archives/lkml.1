Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968605Ab0B0QrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:47:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968586Ab0B0QrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:47:00 -0500
Date: Sat, 27 Feb 2010 17:44:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/ptrace changes for v2.6.34
Message-ID: <20100227164455.GA13837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-ptrace-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-ptrace-for-linus

Seen and acked by Roland.

out-of-topic modifications in x86-ptrace-for-linus:
---------------------------------------------------
arch/parisc/Kconfig                # 5e6dbc2: parisc: Disable CONFIG_HAVE_ARCH_
include/linux/elf.h                # 2225a12: ptrace: Add support for generic P
                                   # 5b3efd5: x86, ptrace: regset extensions to
include/linux/ptrace.h             # c6a0dd7: ptrace: Fix ptrace_regset() comme
                                   # 2225a12: ptrace: Add support for generic P
kernel/ptrace.c                    # c6a0dd7: ptrace: Fix ptrace_regset() comme
                                   # 2225a12: ptrace: Add support for generic P

 Thanks,

	Ingo

------------------>
Roland McGrath (1):
      parisc: Disable CONFIG_HAVE_ARCH_TRACEHOOK

Suresh Siddha (5):
      x86, ptrace: regset extensions to support xstate
      ptrace: Add support for generic PTRACE_GETREGSET/PTRACE_SETREGSET
      ptrace: Fix ptrace_regset() comments and diagnose errors specifically
      x86, ptrace: Simplify xstateregs_get()
      x86, ptrace: Remove set_stopped_child_used_math() in [x]fpregs_set


 arch/parisc/Kconfig          |    1 -
 arch/x86/include/asm/i387.h  |   12 +++++-
 arch/x86/include/asm/user.h  |   58 +++++++++++++++++++++++++++
 arch/x86/include/asm/xsave.h |    2 +
 arch/x86/kernel/i387.c       |   71 ++++++++++++++++++++++++++++++++--
 arch/x86/kernel/ptrace.c     |   34 +++++++++++++++-
 arch/x86/kernel/xsave.c      |    1 +
 include/linux/elf.h          |    7 +++-
 include/linux/ptrace.h       |   20 +++++++++
 kernel/ptrace.c              |   88 ++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 284 insertions(+), 10 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 524d935..f388dc6 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -18,7 +18,6 @@ config PARISC
 	select BUG
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
-	select HAVE_ARCH_TRACEHOOK
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index ebfb8a9..da29309 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
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
diff --git a/arch/x86/include/asm/user.h b/arch/x86/include/asm/user.h
index 999873b..24532c7 100644
--- a/arch/x86/include/asm/user.h
+++ b/arch/x86/include/asm/user.h
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
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 727acc1..ddc04cc 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
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
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f2f8540..c01a2b8 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
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
@@ -204,8 +209,6 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
-	set_stopped_child_used_math(target);
-
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.xstate->fxsave, 0, -1);
 
@@ -224,6 +227,68 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
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
+	 * Copy the 48bytes defined by the software first into the xstate
+	 * memory layout in the thread struct, so that we can copy the entire
+	 * xstateregs to the user using one user_regset_copyout().
+	 */
+	memcpy(&target->thread.xstate->fxsave.sw_reserved,
+	       xstate_fx_sw_bytes, sizeof(xstate_fx_sw_bytes));
+
+	/*
+	 * Copy the xstate memory layout.
+	 */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &target->thread.xstate->xsave, 0, -1);
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
@@ -404,8 +469,6 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
-	set_stopped_child_used_math(target);
-
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 017d937..16433a5 100644
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
@@ -1584,7 +1585,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 #ifdef CONFIG_X86_64
 
-static const struct user_regset x86_64_regsets[] = {
+static struct user_regset x86_64_regsets[] __read_mostly = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct) / sizeof(long),
@@ -1597,6 +1598,12 @@ static const struct user_regset x86_64_regsets[] = {
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
@@ -1622,7 +1629,7 @@ static const struct user_regset_view user_x86_64_view = {
 #endif	/* CONFIG_X86_64 */
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
-static const struct user_regset x86_32_regsets[] = {
+static struct user_regset x86_32_regsets[] __read_mostly = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
 		.n = sizeof(struct user_regs_struct32) / sizeof(u32),
@@ -1641,6 +1648,12 @@ static const struct user_regset x86_32_regsets[] = {
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
@@ -1663,6 +1676,23 @@ static const struct user_regset_view user_x86_32_view = {
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
index 0cc4d55..d8e6e61 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -349,7 +349,11 @@ typedef struct elf64_shdr {
 #define ELF_OSABI ELFOSABI_NONE
 #endif
 
-/* Notes used in ET_CORE */
+/*
+ * Notes used in ET_CORE. Architectures export some of the arch register sets
+ * using the corresponding note types via the PTRACE_GETREGSET and
+ * PTRACE_SETREGSET requests.
+ */
 #define NT_PRSTATUS	1
 #define NT_PRFPREG	2
 #define NT_PRPSINFO	3
@@ -361,6 +365,7 @@ typedef struct elf64_shdr {
 #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
 #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
 #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
+#define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */
 #define NT_S390_HIGH_GPRS	0x300	/* s390 upper register halves */
 
 
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 56f2d63..c5eab89 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -27,6 +27,26 @@
 #define PTRACE_GETSIGINFO	0x4202
 #define PTRACE_SETSIGINFO	0x4203
 
+/*
+ * Generic ptrace interface that exports the architecture specific regsets
+ * using the corresponding NT_* types (which are also used in the core dump).
+ * Please note that the NT_PRSTATUS note type in a core dump contains a full
+ * 'struct elf_prstatus'. But the user_regset for NT_PRSTATUS contains just the
+ * elf_gregset_t that is the pr_reg field of 'struct elf_prstatus'. For all the
+ * other user_regset flavors, the user_regset layout and the ELF core dump note
+ * payload are exactly the same layout.
+ *
+ * This interface usage is as follows:
+ *	struct iovec iov = { buf, len};
+ *
+ *	ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
+ *
+ * On the successful completion, iov.len will be updated by the kernel,
+ * specifying how much the kernel has written/read to/from the user's iov.buf.
+ */
+#define PTRACE_GETREGSET	0x4204
+#define PTRACE_SETREGSET	0x4205
+
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD	0x00000001
 #define PTRACE_O_TRACEFORK	0x00000002
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 23bd09c..42ad8ae 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/regset.h>
 
 
 /*
@@ -511,6 +512,47 @@ static int ptrace_resume(struct task_struct *child, long request, long data)
 	return 0;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+
+static const struct user_regset *
+find_regset(const struct user_regset_view *view, unsigned int type)
+{
+	const struct user_regset *regset;
+	int n;
+
+	for (n = 0; n < view->n; ++n) {
+		regset = view->regsets + n;
+		if (regset->core_note_type == type)
+			return regset;
+	}
+
+	return NULL;
+}
+
+static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
+			 struct iovec *kiov)
+{
+	const struct user_regset_view *view = task_user_regset_view(task);
+	const struct user_regset *regset = find_regset(view, type);
+	int regset_no;
+
+	if (!regset || (kiov->iov_len % regset->size) != 0)
+		return -EINVAL;
+
+	regset_no = regset - view->regsets;
+	kiov->iov_len = min(kiov->iov_len,
+			    (__kernel_size_t) (regset->n * regset->size));
+
+	if (req == PTRACE_GETREGSET)
+		return copy_regset_to_user(task, view, regset_no, 0,
+					   kiov->iov_len, kiov->iov_base);
+	else
+		return copy_regset_from_user(task, view, regset_no, 0,
+					     kiov->iov_len, kiov->iov_base);
+}
+
+#endif
+
 int ptrace_request(struct task_struct *child, long request,
 		   long addr, long data)
 {
@@ -573,6 +615,26 @@ int ptrace_request(struct task_struct *child, long request,
 			return 0;
 		return ptrace_resume(child, request, SIGKILL);
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	case PTRACE_GETREGSET:
+	case PTRACE_SETREGSET:
+	{
+		struct iovec kiov;
+		struct iovec __user *uiov = (struct iovec __user *) data;
+
+		if (!access_ok(VERIFY_WRITE, uiov, sizeof(*uiov)))
+			return -EFAULT;
+
+		if (__get_user(kiov.iov_base, &uiov->iov_base) ||
+		    __get_user(kiov.iov_len, &uiov->iov_len))
+			return -EFAULT;
+
+		ret = ptrace_regset(child, request, addr, &kiov);
+		if (!ret)
+			ret = __put_user(kiov.iov_len, &uiov->iov_len);
+		break;
+	}
+#endif
 	default:
 		break;
 	}
@@ -711,6 +773,32 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 		else
 			ret = ptrace_setsiginfo(child, &siginfo);
 		break;
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	case PTRACE_GETREGSET:
+	case PTRACE_SETREGSET:
+	{
+		struct iovec kiov;
+		struct compat_iovec __user *uiov =
+			(struct compat_iovec __user *) datap;
+		compat_uptr_t ptr;
+		compat_size_t len;
+
+		if (!access_ok(VERIFY_WRITE, uiov, sizeof(*uiov)))
+			return -EFAULT;
+
+		if (__get_user(ptr, &uiov->iov_base) ||
+		    __get_user(len, &uiov->iov_len))
+			return -EFAULT;
+
+		kiov.iov_base = compat_ptr(ptr);
+		kiov.iov_len = len;
+
+		ret = ptrace_regset(child, request, addr, &kiov);
+		if (!ret)
+			ret = __put_user(kiov.iov_len, &uiov->iov_len);
+		break;
+	}
+#endif
 
 	default:
 		ret = ptrace_request(child, request, addr, data);

