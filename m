Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbZDYANy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbZDYANy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZDYANo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:13:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbZDYANn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:13:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 13/17] arm: user_regset: Crunch regs
Message-Id: <20090425001334.71F13FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:13:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the ptrace Crunch support into user_regset form.
There should be no change in the ptrace behavior on CONFIG_CRUNCH.

I am not set up to test any hardware with CONFIG_CRUNCH or to try
any software that uses Crunch so as to verify it.  I've tested that
it compiles.  This regset's code is as simple as any can be.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |   44 ++++++++++++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index d59e074..78b457c 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -671,25 +671,33 @@ static int iwmmxt_set(struct task_struct *target,
 /*
  * Get the child Crunch state.
  */
-static int ptrace_getcrunchregs(struct task_struct *tsk, void __user *ufp)
+static int crunch_get(struct task_struct *target,
+		      const struct user_regset *regset,
+		      unsigned int pos, unsigned int count,
+		      void *kbuf, void __user *ubuf)
 {
-	struct thread_info *thread = task_thread_info(tsk);
+	struct thread_info *thread = task_thread_info(target);
 
 	crunch_task_disable(thread);  /* force it to ram */
-	return copy_to_user(ufp, &thread->crunchstate, CRUNCH_SIZE)
-		? -EFAULT : 0;
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   &thread->crunchstate, 0, CRUNCH_SIZE);
 }
 
 /*
  * Set the child Crunch state.
  */
-static int ptrace_setcrunchregs(struct task_struct *tsk, void __user *ufp)
+static int crunch_set(struct task_struct *target,
+		      const struct user_regset *regset,
+		      unsigned int pos, unsigned int count,
+		      const void *kbuf, const void __user *ubuf)
 {
-	struct thread_info *thread = task_thread_info(tsk);
+	struct thread_info *thread = task_thread_info(target);
 
 	crunch_task_release(thread);  /* force a reload */
-	return copy_from_user(&thread->crunchstate, ufp, CRUNCH_SIZE)
-		? -EFAULT : 0;
+
+	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				  &thread->crunchstate, 0, CRUNCH_SIZE);
 }
 #endif
 
@@ -804,6 +812,9 @@ enum {
 #ifdef CONFIG_IWMMXT
 	REGSET_IWMMXT,
 #endif
+#ifdef CONFIG_CRUNCH
+	REGSET_CRUNCH,
+#endif
 };
 
 static const struct user_regset arm_regsets[] = {
@@ -834,6 +845,13 @@ static const struct user_regset arm_regsets[] = {
 		.active = iwmmxt_active, .get = iwmmxt_get, .set = iwmmxt_set
 	},
 #endif
+#ifdef CONFIG_CRUNCH
+	[REGSET_CRUNCH] = {
+		.n = sizeof(struct crunch_state) / sizeof(int),
+		.size = sizeof(int), .align = sizeof(int),
+		.get = crunch_get, .set = crunch_set
+	},
+#endif
 };
 
 static const struct user_regset_view user_arm_view = {
@@ -931,12 +949,14 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 #ifdef CONFIG_CRUNCH
 	case PTRACE_GETCRUNCHREGS:
-		ret = ptrace_getcrunchregs(child, (void __user *)data);
-		break;
+		return copy_regset_from_user(child, &user_arm_view,
+					     REGSET_CRUNCH, 0, CRUNCH_SIZE,
+					     (const void __user *) data);
 
 	case PTRACE_SETCRUNCHREGS:
-		ret = ptrace_setcrunchregs(child, (void __user *)data);
-		break;
+		return copy_regset_from_user(child, &user_arm_view,
+					     REGSET_CRUNCH, 0, CRUNCH_SIZE,
+					     (const void __user *) data);
 #endif
 
 #ifdef CONFIG_VFP
