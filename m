Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbYAGFl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbYAGFl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 00:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYAGFlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 00:41:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbYAGFlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 00:41:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: [PATCH update -mm 16/43] powerpc user_regset compat
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:58:08 -0800 <20071220115808.015F626F98D@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
	<20071220115808.015F626F98D@magilla.localdomain>
X-Shopping-List: (1) Coniferous protrusions
   (2) Insipid watchers
   (3) Scratch 'n' Snot Fraudulent lotion
   (4) Frenetic indecent rotation attention
Message-Id: <20080107054041.D7F0926F9A4@magilla.localdomain>
Date: Sun,  6 Jan 2008 21:40:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces my 2007-12-20 patch by the same title, and has to take
its place in the order of applying that whole series.  

Further testing revealed a bug that resulted in regset-based core dumps of
32-bit processes on 64-bit kernels having r0..r3 cleared to zero.  The fix
(interdiff from original patch) is a trivial pair of lines in two places.


Thanks,
Roland

---

This extends task_user_regset_view CONFIG_PPC64 with support for the 32-bit
view of register state, compatible with what a CONFIG_PPC32 kernel provides.
This will enable generic machine-independent code to access user-mode
threads' registers for debugging and dumping.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |  162 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 162 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index eb00274..60de9ee 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -501,8 +501,170 @@ static const struct user_regset_view user_ppc_native_view = {
 	.regsets = native_regsets, .n = ARRAY_SIZE(native_regsets)
 };
 
+#ifdef CONFIG_PPC64
+#include <linux/compat.h>
+
+static int gpr32_get(struct task_struct *target,
+		     const struct user_regset *regset,
+		     unsigned int pos, unsigned int count,
+		     void *kbuf, void __user *ubuf)
+{
+	const unsigned long *regs = &target->thread.regs->gpr[0];
+	compat_ulong_t *k = kbuf;
+	compat_ulong_t __user *u = ubuf;
+	compat_ulong_t reg;
+
+	if (target->thread.regs == NULL)
+		return -EIO;
+
+	CHECK_FULL_REGS(target->thread.regs);
+
+	pos /= sizeof(reg);
+	count /= sizeof(reg);
+
+	if (kbuf)
+		for (; count > 0 && pos < PT_MSR; --count)
+			*k++ = regs[pos++];
+	else
+		for (; count > 0 && pos < PT_MSR; --count)
+			if (__put_user((compat_ulong_t) regs[pos++], u++))
+				return -EFAULT;
+
+	if (count > 0 && pos == PT_MSR) {
+		reg = get_user_msr(target);
+		if (kbuf)
+			*k++ = reg;
+		else if (__put_user(reg, u++))
+			return -EFAULT;
+		++pos;
+		--count;
+	}
+
+	if (kbuf)
+		for (; count > 0 && pos < PT_REGS_COUNT; --count)
+			*k++ = regs[pos++];
+	else
+		for (; count > 0 && pos < PT_REGS_COUNT; --count)
+			if (__put_user((compat_ulong_t) regs[pos++], u++))
+				return -EFAULT;
+
+	kbuf = k;
+	ubuf = u;
+	pos *= sizeof(reg);
+	count *= sizeof(reg);
+	return user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					PT_REGS_COUNT * sizeof(reg), -1);
+}
+
+static int gpr32_set(struct task_struct *target,
+		     const struct user_regset *regset,
+		     unsigned int pos, unsigned int count,
+		     const void *kbuf, const void __user *ubuf)
+{
+	unsigned long *regs = &target->thread.regs->gpr[0];
+	const compat_ulong_t *k = kbuf;
+	const compat_ulong_t __user *u = ubuf;
+	compat_ulong_t reg;
+
+	if (target->thread.regs == NULL)
+		return -EIO;
+
+	CHECK_FULL_REGS(target->thread.regs);
+
+	pos /= sizeof(reg);
+	count /= sizeof(reg);
+
+	if (kbuf)
+		for (; count > 0 && pos < PT_MSR; --count)
+			regs[pos++] = *k++;
+	else
+		for (; count > 0 && pos < PT_MSR; --count) {
+			if (__get_user(reg, u++))
+				return -EFAULT;
+			regs[pos++] = reg;
+		}
+
+
+	if (count > 0 && pos == PT_MSR) {
+		if (kbuf)
+			reg = *k++;
+		else if (__get_user(reg, u++))
+			return -EFAULT;
+		set_user_msr(target, reg);
+		++pos;
+		--count;
+	}
+
+	if (kbuf)
+		for (; count > 0 && pos <= PT_MAX_PUT_REG; --count)
+			regs[pos++] = *k++;
+	else
+		for (; count > 0 && pos <= PT_MAX_PUT_REG; --count) {
+			if (__get_user(reg, u++))
+				return -EFAULT;
+			regs[pos++] = reg;
+		}
+
+	if (count > 0 && pos == PT_TRAP) {
+		if (kbuf)
+			reg = *k++;
+		else if (__get_user(reg, u++))
+			return -EFAULT;
+		set_user_trap(target, reg);
+		++pos;
+		--count;
+	}
+
+	kbuf = k;
+	ubuf = u;
+	pos *= sizeof(reg);
+	count *= sizeof(reg);
+	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					 (PT_TRAP + 1) * sizeof(reg), -1);
+}
+
+/*
+ * These are the regset flavors matching the CONFIG_PPC32 native set.
+ */
+static const struct user_regset compat_regsets[] = {
+	[REGSET_GPR] = {
+		.core_note_type = NT_PRSTATUS, .n = ELF_NGREG,
+		.size = sizeof(compat_long_t), .align = sizeof(compat_long_t),
+		.get = gpr32_get, .set = gpr32_set
+	},
+	[REGSET_FPR] = {
+		.core_note_type = NT_PRFPREG, .n = ELF_NFPREG,
+		.size = sizeof(double), .align = sizeof(double),
+		.get = fpr_get, .set = fpr_set
+	},
+#ifdef CONFIG_ALTIVEC
+	[REGSET_VMX] = {
+		.core_note_type = NT_PPC_VMX, .n = 34,
+		.size = sizeof(vector128), .align = sizeof(vector128),
+		.active = vr_active, .get = vr_get, .set = vr_set
+	},
+#endif
+#ifdef CONFIG_SPE
+	[REGSET_SPE] = {
+		.n = 35,
+		.size = sizeof(u32), .align = sizeof(u32),
+		.active = evr_active, .get = evr_get, .set = evr_set
+	},
+#endif
+};
+
+static const struct user_regset_view user_ppc_compat_view = {
+	.name = "ppc", .e_machine = EM_PPC, .ei_osabi = ELF_OSABI,
+	.regsets = compat_regsets, .n = ARRAY_SIZE(compat_regsets)
+};
+#endif	/* CONFIG_PPC64 */
+
 const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 {
+#ifdef CONFIG_PPC64
+	if (test_tsk_thread_flag(task, TIF_32BIT))
+		return &user_ppc_compat_view;
+#endif
 	return &user_ppc_native_view;
 }
 
