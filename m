Return-Path: <linux-kernel-owner+w=401wt.eu-S1762981AbXLTMMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762981AbXLTMMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761253AbXLTMBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41849 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761146AbXLTMAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 16/43] powerpc user_regset compat
Message-Id: <20071220115808.015F626F98D@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:58:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends task_user_regset_view CONFIG_PPC64 with support for the 32-bit
view of register state, compatible with what a CONFIG_PPC32 kernel provides.
This will enable generic machine-independent code to access user-mode
threads' registers for debugging and dumping.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |  158 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 158 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index b32ac5f..e961e10 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -501,8 +501,166 @@ static const struct user_regset_view user_ppc_native_view = {
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
 
-- 
1.5.3.6

