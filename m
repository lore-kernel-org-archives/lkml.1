Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbXLTME5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbXLTME5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761085AbXLTMAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760767AbXLTMAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:22 -0500
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
Subject: [PATCH -mm 10/43] powerpc user_regset fpregs
Message-Id: <20071220115734.37FA126F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:57:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements user_regset-style accessors for the powerpc FPU data,
and rewrites the existing ptrace code in terms of those calls.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |   37 +++++++++++++++++++++++++++++++------
 1 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 8b056d2..f1ce646 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/smp.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
+#include <linux/regset.h>
 #include <linux/user.h>
 #include <linux/security.h>
 #include <linux/signal.h>
@@ -103,24 +104,48 @@ int ptrace_put_reg(struct task_struct *task, int regno, unsigned long data)
 }
 
 
+static int fpr_get(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	flush_fp_to_thread(target);
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, fpscr) !=
+		     offsetof(struct thread_struct, fpr[32]));
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   &target->thread.fpr, 0, -1);
+}
+
+static int fpr_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	flush_fp_to_thread(target);
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, fpscr) !=
+		     offsetof(struct thread_struct, fpr[32]));
+
+	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				  &target->thread.fpr, 0, -1);
+}
+
 static int get_fpregs(void __user *data, struct task_struct *task,
 		      int has_fpscr)
 {
 	unsigned int count = has_fpscr ? 33 : 32;
-
-	if (copy_to_user(data, task->thread.fpr, count * sizeof(double)))
+	if (!access_ok(VERIFY_WRITE, data, count * sizeof(double)))
 		return -EFAULT;
-	return 0;
+	return fpr_get(task, NULL, 0, count * sizeof(double), NULL, data);
 }
 
 static int set_fpregs(void __user *data, struct task_struct *task,
 		      int has_fpscr)
 {
 	unsigned int count = has_fpscr ? 33 : 32;
-
-	if (copy_from_user(task->thread.fpr, data, count * sizeof(double)))
+	if (!access_ok(VERIFY_READ, data, count * sizeof(double)))
 		return -EFAULT;
-	return 0;
+	return fpr_set(task, NULL, 0, count * sizeof(double), NULL, data);
 }
 
 
-- 
1.5.3.6

