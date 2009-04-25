Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbZDYAOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbZDYAOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759241AbZDYAO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:14:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbZDYAO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:14:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 11/17] arm: user_regset: iWMMXt regs
Message-Id: <20090425001236.B4BD4FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:12:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the ptrace iWMMXt support into user_regset form.
There should be no change in the ptrace behavior on CONFIG_IWMMXT.

I am not set up to test any hardware with CONFIG_IWMMXT or to try
any software that uses iWMMXt so as to verify it.  I've tested that
it compiles.  This regset's code is extremely simple.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |   50 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 5fb5ac1..821ce64 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -628,29 +628,41 @@ static int user_fp_set(struct task_struct *target,
 /*
  * Get the child iWMMXt state.
  */
-static int ptrace_getwmmxregs(struct task_struct *tsk, void __user *ufp)
+static int iwmmxt_get(struct task_struct *target,
+		      const struct user_regset *regset,
+		      unsigned int pos, unsigned int count,
+		      void *kbuf, void __user *ubuf)
 {
-	struct thread_info *thread = task_thread_info(tsk);
+	struct thread_info *thread = task_thread_info(target);
 
 	if (!test_ti_thread_flag(thread, TIF_USING_IWMMXT))
 		return -ENODATA;
 	iwmmxt_task_disable(thread);  /* force it to ram */
-	return copy_to_user(ufp, &thread->fpstate.iwmmxt, IWMMXT_SIZE)
-		? -EFAULT : 0;
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   &thread->fpstate.iwmmxt, 0, IWMMXT_SIZE);
+}
+
+static int iwmmxt_active(struct task_struct *target,
+			 const struct user_regset *regset)
+{
+	return test_tsk_thread_flag(target, TIF_USING_IWMMXT) ? regset->n : 0;
 }
 
 /*
  * Set the child iWMMXt state.
  */
-static int ptrace_setwmmxregs(struct task_struct *tsk, void __user *ufp)
+static int iwmmxt_set(struct task_struct *target,
+		      const struct user_regset *regset,
+		      unsigned int pos, unsigned int count,
+		      const void *kbuf, const void __user *ubuf)
 {
-	struct thread_info *thread = task_thread_info(tsk);
+	struct thread_info *thread = task_thread_info(target);
 
 	if (!test_ti_thread_flag(thread, TIF_USING_IWMMXT))
 		return -EACCES;
 	iwmmxt_task_release(thread);  /* force a reload */
-	return copy_from_user(&thread->fpstate.iwmmxt, ufp, IWMMXT_SIZE)
-		? -EFAULT : 0;
+	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				  &thread->fpstate.iwmmxt, 0, IWMMXT_SIZE);
 }
 
 #endif
@@ -789,6 +801,9 @@ enum {
 #ifdef CONFIG_VFP
 	REGSET_VFP,
 #endif
+#ifdef CONFIG_IWMMXT
+	REGSET_IWMMXT,
+#endif
 };
 
 static const struct user_regset arm_regsets[] = {
@@ -811,6 +826,13 @@ static const struct user_regset arm_regsets[] = {
 		.get = vfp_get, .set = vfp_set
 	},
 #endif
+#ifdef CONFIG_IWMMXT
+	[REGSET_IWMMXT] = {
+		.n = sizeof(struct iwmmxt_struct) / sizeof(int),
+		.size = sizeof(int), .align = sizeof(int),
+		.active = iwmmxt_active, .get = iwmmxt_get, .set = iwmmxt_set
+	},
+#endif
 };
 
 static const struct user_regset_view user_arm_view = {
@@ -884,12 +906,16 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 #ifdef CONFIG_IWMMXT
 	case PTRACE_GETWMMXREGS:
-		ret = ptrace_getwmmxregs(child, (void __user *)data);
-		break;
+		return copy_regset_to_user(child, &user_arm_view,
+					   REGSET_IWMMXT,
+					   0, IWMMXT_SIZE,
+					   (void __user *) data);
 
 	case PTRACE_SETWMMXREGS:
-		ret = ptrace_setwmmxregs(child, (void __user *)data);
-		break;
+		return copy_regset_from_user(child, &user_arm_view,
+					     REGSET_IWMMXT,
+					     0, IWMMXT_SIZE,
+					     (const void __user *) data);
 #endif
 
 	case PTRACE_GET_THREAD_AREA:
