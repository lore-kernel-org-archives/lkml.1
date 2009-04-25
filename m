Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbZDYAKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbZDYAKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbZDYAK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:10:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbZDYAK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:10:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 06/17] arm: user_regset: general regs
Message-Id: <20090425001019.20460FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:10:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts PTRACE_GETREGS/PTRACE_SETREGS into user_regset form.
There should be no change in the ptrace behavior.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |   72 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index effada1..fbb18e4 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -15,6 +15,8 @@
 #include <linux/smp.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
+#include <linux/regset.h>
+#include <linux/elf.h>
 #include <linux/user.h>
 #include <linux/security.h>
 #include <linux/init.h>
@@ -547,30 +549,38 @@ static int ptrace_write_user(struct task_struct *tsk, unsigned long off,
 /*
  * Get all user integer registers.
  */
-static int ptrace_getregs(struct task_struct *tsk, void __user *uregs)
+static int gpr_get(struct task_struct *target,
+		   const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
 {
-	struct pt_regs *regs = task_pt_regs(tsk);
-
-	return copy_to_user(uregs, regs, sizeof(struct pt_regs)) ? -EFAULT : 0;
+	struct pt_regs *regs = task_pt_regs(target);
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   regs, 0, sizeof(*regs));
 }
 
 /*
  * Set all user integer registers.
  */
-static int ptrace_setregs(struct task_struct *tsk, void __user *uregs)
+static int gpr_set(struct task_struct *target,
+		   const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
 {
+	struct pt_regs *regs = task_pt_regs(target);
 	struct pt_regs newregs;
 	int ret;
 
-	ret = -EFAULT;
-	if (copy_from_user(&newregs, uregs, sizeof(struct pt_regs)) == 0) {
-		struct pt_regs *regs = task_pt_regs(tsk);
+	if (pos != 0 || count != sizeof(newregs))
+		newregs = *regs;
 
-		ret = -EINVAL;
-		if (valid_user_regs(&newregs)) {
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &newregs, 0, sizeof(newregs));
+	if (!ret) {
+		if (valid_user_regs(&newregs))
 			*regs = newregs;
-			ret = 0;
-		}
+		else
+			ret = -EINVAL;
 	}
 
 	return ret;
@@ -702,6 +712,34 @@ static int ptrace_setvfpregs(struct task_struct *tsk, void __user *data)
 }
 #endif
 
+/*
+ * Indices in arm_regsets[] array.  These are used only in arch_ptrace(),
+ * below.  The ordering that matters is that the NT_PRSTATUS regset is
+ * first.  Other than that, ever use outside this file should just look at
+ * the contents of the table entries.
+ */
+enum {
+	REGSET_GPR,
+};
+
+static const struct user_regset arm_regsets[] = {
+	[REGSET_GPR] = {
+		.core_note_type = NT_PRSTATUS, .n = ELF_NGREG,
+		.size = sizeof(long), .align = sizeof(long),
+		.get = gpr_get, .set = gpr_set
+	},
+};
+
+static const struct user_regset_view user_arm_view = {
+	.name = "arm", .e_machine = ELF_ARCH, .ei_osabi = ELF_OSABI,
+	.regsets = arm_regsets, .n = ARRAY_SIZE(arm_regsets)
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &user_arm_view;
+}
+
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	int ret;
@@ -742,12 +780,14 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		goto common;
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (void __user *)data);
-		break;
+		return copy_regset_to_user(child, &user_arm_view, REGSET_GPR,
+					   0, sizeof(struct pt_regs),
+					   (void __user *) data);
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (void __user *)data);
-		break;
+		return copy_regset_from_user(child, &user_arm_view, REGSET_GPR,
+					     0, sizeof(struct pt_regs),
+					     (const void __user *) data);
 
 	case PTRACE_GETFPREGS:
 		ret = ptrace_getfpregs(child, (void __user *)data);
