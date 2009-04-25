Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbZDYAMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbZDYAMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbZDYAMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:12:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759558AbZDYAMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:12:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 07/17] arm: user_regset: FPU regs
Message-Id: <20090425001049.542CAFC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:10:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts PTRACE_GETFPREGS/PTRACE_SETFPREGS into user_regset form.
There should be no change in the ptrace behavior.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |   48 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index fbb18e4..9e7aa04 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -589,21 +589,38 @@ static int gpr_set(struct task_struct *target,
 /*
  * Get the child FPU state.
  */
-static int ptrace_getfpregs(struct task_struct *tsk, void __user *ufp)
+static int user_fp_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user *ubuf)
 {
-	return copy_to_user(ufp, &task_thread_info(tsk)->fpstate,
-			    sizeof(struct user_fp)) ? -EFAULT : 0;
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   &task_thread_info(target)->fpstate,
+				   0, sizeof(struct user_fp));
+}
+
+/*
+ * Decide if the FPU state is interesting enough to look at or dump.
+ */
+static int user_fp_active(struct task_struct *target,
+			  const struct user_regset *regset)
+{
+	struct thread_info *thread = task_thread_info(target);
+	return (thread->used_cp[1] || thread->used_cp[2]) ? regset->n : 0;
 }
 
 /*
  * Set the child FPU state.
  */
-static int ptrace_setfpregs(struct task_struct *tsk, void __user *ufp)
+static int user_fp_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user *ubuf)
 {
-	struct thread_info *thread = task_thread_info(tsk);
+	struct thread_info *thread = task_thread_info(target);
 	thread->used_cp[1] = thread->used_cp[2] = 1;
-	return copy_from_user(&thread->fpstate, ufp,
-			      sizeof(struct user_fp)) ? -EFAULT : 0;
+	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				  &thread->fpstate, 0, sizeof(struct user_fp));
 }
 
 #ifdef CONFIG_IWMMXT
@@ -720,6 +737,7 @@ static int ptrace_setvfpregs(struct task_struct *tsk, void __user *data)
  */
 enum {
 	REGSET_GPR,
+	REGSET_FP,
 };
 
 static const struct user_regset arm_regsets[] = {
@@ -728,6 +746,12 @@ static const struct user_regset arm_regsets[] = {
 		.size = sizeof(long), .align = sizeof(long),
 		.get = gpr_get, .set = gpr_set
 	},
+	[REGSET_FP] = {
+		.core_note_type = NT_PRFPREG,
+		.n = sizeof(struct user_fp) / sizeof(long),
+		.size = sizeof(long), .align = sizeof(long),
+		.active = user_fp_active, .get = user_fp_get, .set = user_fp_set
+	},
 };
 
 static const struct user_regset_view user_arm_view = {
@@ -790,12 +814,14 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					     (const void __user *) data);
 
 	case PTRACE_GETFPREGS:
-		ret = ptrace_getfpregs(child, (void __user *)data);
-		break;
+		return copy_regset_to_user(child, &user_arm_view, REGSET_FP,
+					   0, sizeof(struct user_fp),
+					   (void __user *) data);
 
 	case PTRACE_SETFPREGS:
-		ret = ptrace_setfpregs(child, (void __user *)data);
-		break;
+		return copy_regset_from_user(child, &user_arm_view, REGSET_FP,
+					     0, sizeof(struct user_fp),
+					     (const void __user *) data);
 
 #ifdef CONFIG_IWMMXT
 	case PTRACE_GETWMMXREGS:
