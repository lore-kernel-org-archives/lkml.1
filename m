Return-Path: <linux-kernel-owner+w=401wt.eu-S1761516AbXLTMBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516AbXLTMBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760820AbXLTMAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759311AbXLTMAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:12 -0500
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
Subject: [PATCH -mm 14/43] powerpc user_regset gpr
Message-Id: <20071220115755.29B5E26F98B@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:57:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements user_regset-style accessors for the powerpc general registers.
In the future these functions will be the only place that needs to understand
the user_regset layout (core dump format) and how it maps to the internal
representation of user thread state.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |   91 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 4edc118..e493fc0 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -119,6 +119,97 @@ int ptrace_put_reg(struct task_struct *task, int regno, unsigned long data)
 	return -EIO;
 }
 
+static int gpr_get(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	if (target->thread.regs == NULL)
+		return -EIO;
+
+	CHECK_FULL_REGS(target->thread.regs);
+
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  target->thread.regs,
+				  0, offsetof(struct pt_regs, msr));
+	if (!ret) {
+		unsigned long msr = get_user_msr(target);
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &msr,
+					  offsetof(struct pt_regs, msr),
+					  offsetof(struct pt_regs, msr) +
+					  sizeof(msr));
+	}
+
+	BUILD_BUG_ON(offsetof(struct pt_regs, orig_gpr3) !=
+		     offsetof(struct pt_regs, msr) + sizeof(long));
+
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  &target->thread.regs->orig_gpr3,
+					  offsetof(struct pt_regs, orig_gpr3),
+					  sizeof(struct pt_regs));
+	if (!ret)
+		ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					       sizeof(struct pt_regs), -1);
+
+	return ret;
+}
+
+static int gpr_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	unsigned long reg;
+	int ret;
+
+	if (target->thread.regs == NULL)
+		return -EIO;
+
+	CHECK_FULL_REGS(target->thread.regs);
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 target->thread.regs,
+				 0, PT_MSR * sizeof(reg));
+
+	if (!ret && count > 0) {
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &reg,
+					 PT_MSR * sizeof(reg),
+					 (PT_MSR + 1) * sizeof(reg));
+		if (!ret)
+			ret = set_user_msr(target, reg);
+	}
+
+	BUILD_BUG_ON(offsetof(struct pt_regs, orig_gpr3) !=
+		     offsetof(struct pt_regs, msr) + sizeof(long));
+
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					 &target->thread.regs->orig_gpr3,
+					 PT_ORIG_R3 * sizeof(reg),
+					 (PT_MAX_PUT_REG + 1) * sizeof(reg));
+
+	if (PT_MAX_PUT_REG + 1 < PT_TRAP && !ret)
+		ret = user_regset_copyin_ignore(
+			&pos, &count, &kbuf, &ubuf,
+			(PT_MAX_PUT_REG + 1) * sizeof(reg),
+			PT_TRAP * sizeof(reg));
+
+	if (!ret && count > 0) {
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &reg,
+					 PT_TRAP * sizeof(reg),
+					 (PT_TRAP + 1) * sizeof(reg));
+		if (!ret)
+			ret = set_user_trap(target, reg);
+	}
+
+	if (!ret)
+		ret = user_regset_copyin_ignore(
+			&pos, &count, &kbuf, &ubuf,
+			(PT_TRAP + 1) * sizeof(reg), -1);
+
+	return ret;
+}
 
 static int fpr_get(struct task_struct *target, const struct user_regset *regset,
 		   unsigned int pos, unsigned int count,
-- 
1.5.3.6

