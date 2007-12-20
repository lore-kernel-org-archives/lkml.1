Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbXLTMDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbXLTMDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761001AbXLTMAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760345AbXLTMAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:20 -0500
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
Subject: [PATCH -mm 11/43] powerpc user_regset altivec
Message-Id: <20071220115739.4978126F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:57:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements user_regset-style accessors for the powerpc Altivec data,
and rewrites the existing ptrace code in terms of those calls.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |  112 +++++++++++++++++++++++++++++-------------
 1 files changed, 78 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index f1ce646..7cdf35a 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/regset.h>
+#include <linux/elf.h>
 #include <linux/user.h>
 #include <linux/security.h>
 #include <linux/signal.h>
@@ -163,30 +164,87 @@ static int set_fpregs(void __user *data, struct task_struct *task,
  * (combined (32- and 64-bit) gdb.
  */
 
+static int vr_active(struct task_struct *target,
+		     const struct user_regset *regset)
+{
+	flush_altivec_to_thread(target);
+	return target->thread.used_vr ? regset->n : 0;
+}
+
+static int vr_get(struct task_struct *target, const struct user_regset *regset,
+		  unsigned int pos, unsigned int count,
+		  void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	flush_altivec_to_thread(target);
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, vscr) !=
+		     offsetof(struct thread_struct, vr[32]));
+
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &target->thread.vr, 0,
+				  33 * sizeof(vector128));
+	if (!ret) {
+		/*
+		 * Copy out only the low-order word of vrsave.
+		 */
+		union {
+			elf_vrreg_t reg;
+			u32 word;
+		} vrsave;
+		memset(&vrsave, 0, sizeof(vrsave));
+		vrsave.word = target->thread.vrsave;
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &vrsave,
+					  33 * sizeof(vector128), -1);
+	}
+
+	return ret;
+}
+
+static int vr_set(struct task_struct *target, const struct user_regset *regset,
+		  unsigned int pos, unsigned int count,
+		  const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+
+	flush_altivec_to_thread(target);
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, vscr) !=
+		     offsetof(struct thread_struct, vr[32]));
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &target->thread.vr, 0, 33 * sizeof(vector128));
+	if (!ret && count > 0) {
+		/*
+		 * We use only the first word of vrsave.
+		 */
+		union {
+			elf_vrreg_t reg;
+			u32 word;
+		} vrsave;
+		memset(&vrsave, 0, sizeof(vrsave));
+		vrsave.word = target->thread.vrsave;
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &vrsave,
+					 33 * sizeof(vector128), -1);
+		if (!ret)
+			target->thread.vrsave = vrsave.word;
+	}
+
+	return ret;
+}
+
 /*
  * Get contents of AltiVec register state in task TASK
  */
 static int get_vrregs(unsigned long __user *data, struct task_struct *task)
 {
-	unsigned long regsize;
-
-	/* copy AltiVec registers VR[0] .. VR[31] */
-	regsize = 32 * sizeof(vector128);
-	if (copy_to_user(data, task->thread.vr, regsize))
-		return -EFAULT;
-	data += (regsize / sizeof(unsigned long));
-
-	/* copy VSCR */
-	regsize = 1 * sizeof(vector128);
-	if (copy_to_user(data, &task->thread.vscr, regsize))
+	if (!access_ok(VERIFY_WRITE, data,
+		       33 * sizeof(vector128) + sizeof(u32)))
 		return -EFAULT;
-	data += (regsize / sizeof(unsigned long));
 
-	/* copy VRSAVE */
-	if (put_user(task->thread.vrsave, (u32 __user *)data))
-		return -EFAULT;
-
-	return 0;
+	return vr_get(task, NULL, 0, 33 * sizeof(vector128) + sizeof(u32),
+		      NULL, data);
 }
 
 /*
@@ -194,25 +252,11 @@ static int get_vrregs(unsigned long __user *data, struct task_struct *task)
  */
 static int set_vrregs(struct task_struct *task, unsigned long __user *data)
 {
-	unsigned long regsize;
-
-	/* copy AltiVec registers VR[0] .. VR[31] */
-	regsize = 32 * sizeof(vector128);
-	if (copy_from_user(task->thread.vr, data, regsize))
-		return -EFAULT;
-	data += (regsize / sizeof(unsigned long));
-
-	/* copy VSCR */
-	regsize = 1 * sizeof(vector128);
-	if (copy_from_user(&task->thread.vscr, data, regsize))
-		return -EFAULT;
-	data += (regsize / sizeof(unsigned long));
-
-	/* copy VRSAVE */
-	if (get_user(task->thread.vrsave, (u32 __user *)data))
+	if (!access_ok(VERIFY_READ, data, 33 * sizeof(vector128) + sizeof(u32)))
 		return -EFAULT;
 
-	return 0;
+	return vr_set(task, NULL, 0, 33 * sizeof(vector128) + sizeof(u32),
+		      NULL, data);
 }
 #endif /* CONFIG_ALTIVEC */
 
-- 
1.5.3.6

