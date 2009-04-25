Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbZDYAMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbZDYAMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZDYAMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:12:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZDYAL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:11:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 09/17] arm: user_regset: VFP regs
Message-Id: <20090425001149.0E31FFC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:11:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts PTRACE_GETVFPREGS/PTRACE_SETVFPREGS into user_regset form.

There are two small changes to the PTRACE_GETVFPREGS behavior.
The trailing word of struct user_vfp (alignment padding) was not
touched at all by PTRACE_GETVFPREGS before, so the user's struct
probably contained uninitialized garbage.  Now that word will be
filled with zero.  Likewise, on configurations with only 16 VFP
registers (<v3), PTRACE_GETVFPREGS would not touch those words in
the user's struct all, leaving uninitialized garbage.  Now those
words will also be filled with zero.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |  104 ++++++++++++++++++++++++++++++++++++----------
 1 files changed, 82 insertions(+), 22 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 9e7aa04..7f3c121 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -685,47 +685,95 @@ static int ptrace_setcrunchregs(struct task_struct *tsk, void __user *ufp)
 /*
  * Get the child VFP state.
  */
-static int ptrace_getvfpregs(struct task_struct *tsk, void __user *data)
+static int vfp_get(struct task_struct *target,
+		   const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
 {
-	struct thread_info *thread = task_thread_info(tsk);
+	struct thread_info *thread = task_thread_info(target);
 	union vfp_state *vfp = &thread->vfpstate;
-	struct user_vfp __user *ufp = data;
+	u32 *fpscr = &vfp->hard.fpscr;
+	int ret;
 
 	vfp_sync_state(thread);
 
 	/* copy the floating point registers */
-	if (copy_to_user(&ufp->fpregs, &vfp->hard.fpregs,
-			 sizeof(vfp->hard.fpregs)))
-		return -EFAULT;
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &vfp->hard.fpregs,
+				  0, sizeof(vfp->hard.fpregs));
+	if (!ret && sizeof(vfp->hard.fpregs) < offsetof(struct user_vfp, fpscr))
+		/*
+		 * When we don't support all the VFP registers in the
+		 * regset format, fill the rest with zero.
+		 */
+		ret = user_regset_copyout_zero(
+			&pos, &count, &kbuf, &ubuf,
+			sizeof(vfp->hard.fpregs),
+			offsetof(struct user_vfp, fpscr));
 
 	/* copy the status and control register */
-	if (put_user(vfp->hard.fpscr, &ufp->fpscr))
-		return -EFAULT;
+	if (!ret)
+		ret = user_regset_copyout(
+			&pos, &count, &kbuf, &ubuf, fpscr,
+			offsetof(struct user_vfp, fpscr),
+			offsetof(struct user_vfp, fpscr) + sizeof(*fpscr));
 
-	return 0;
+	/*
+	 * Fill the alignment padding at the end of struct user_vfp.
+	 */
+	if (!ret)
+		ret = user_regset_copyout_zero(
+			&pos, &count, &kbuf, &ubuf,
+			offsetof(struct user_vfp, fpscr),
+			offsetof(struct user_vfp, fpscr) + sizeof(*fpscr));
+
+	return ret;
 }
 
 /*
  * Set the child VFP state.
  */
-static int ptrace_setvfpregs(struct task_struct *tsk, void __user *data)
+static int vfp_set(struct task_struct *target,
+		   const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
 {
-	struct thread_info *thread = task_thread_info(tsk);
+	struct thread_info *thread = task_thread_info(target);
 	union vfp_state *vfp = &thread->vfpstate;
-	struct user_vfp __user *ufp = data;
+	u32 *fpscr = &vfp->hard.fpscr;
+	int ret;
 
 	vfp_sync_state(thread);
 
 	/* copy the floating point registers */
-	if (copy_from_user(&vfp->hard.fpregs, &ufp->fpregs,
-			   sizeof(vfp->hard.fpregs)))
-		return -EFAULT;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &vfp->hard.fpregs,
+				 0, sizeof(vfp->hard.fpregs));
+	if (!ret && sizeof(vfp->hard.fpregs) < offsetof(struct user_vfp, fpscr))
+		/*
+		 * When we don't support all the VFP registers in the
+		 * regset format, ignore the rest.
+		 */
+		ret = user_regset_copyin_ignore(
+			&pos, &count, &kbuf, &ubuf,
+			sizeof(vfp->hard.fpregs),
+			offsetof(struct user_vfp, fpscr));
 
 	/* copy the status and control register */
-	if (get_user(vfp->hard.fpscr, &ufp->fpscr))
-		return -EFAULT;
+	if (!ret)
+		ret = user_regset_copyin(
+			&pos, &count, &kbuf, &ubuf, fpscr,
+			offsetof(struct user_vfp, fpscr),
+			offsetof(struct user_vfp, fpscr) + sizeof(*fpscr));
 
-	return 0;
+	/*
+	 * Ignore the alignment padding at the end of struct user_vfp.
+	 */
+	if (!ret)
+		ret = user_regset_copyin_ignore(
+			&pos, &count, &kbuf, &ubuf,
+			offsetof(struct user_vfp, fpscr) + sizeof(*fpscr),
+			sizeof(struct user_vfp));
+
+	return ret;
 }
 #endif
 
@@ -738,6 +786,9 @@ static int ptrace_setvfpregs(struct task_struct *tsk, void __user *data)
 enum {
 	REGSET_GPR,
 	REGSET_FP,
+#ifdef CONFIG_VFP
+	REGSET_VFP,
+#endif
 };
 
 static const struct user_regset arm_regsets[] = {
@@ -752,6 +803,13 @@ static const struct user_regset arm_regsets[] = {
 		.size = sizeof(long), .align = sizeof(long),
 		.active = user_fp_active, .get = user_fp_get, .set = user_fp_set
 	},
+#ifdef CONFIG_VFP
+	[REGSET_VFP] = {
+		.n = sizeof(struct user_vfp) / sizeof(long),
+		.size = sizeof(long), .align = sizeof(long),
+		.get = vfp_get, .set = vfp_set
+	},
+#endif
 };
 
 static const struct user_regset_view user_arm_view = {
@@ -855,12 +913,14 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 #ifdef CONFIG_VFP
 	case PTRACE_GETVFPREGS:
-		ret = ptrace_getvfpregs(child, (void __user *)data);
-		break;
+		return copy_regset_to_user(child, &user_arm_view, REGSET_VFP,
+					   0, sizeof(struct pt_regs),
+					   (void __user *) data);
 
 	case PTRACE_SETVFPREGS:
-		ret = ptrace_setvfpregs(child, (void __user *)data);
-		break;
+		return copy_regset_from_user(child, &user_arm_view, REGSET_VFP,
+					     0, sizeof(struct pt_regs),
+					     (const void __user *) data);
 #endif
 
 	default:
