Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbXLTMDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbXLTMDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760962AbXLTMAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760224AbXLTMAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:17 -0500
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
Subject: [PATCH -mm 25/43] powerpc ptrace32 user_regset
Message-Id: <20071220115904.89A7F26F98D@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:59:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the 32-bit ptrace syscall support to use user_regset calls
to get at the register data for PTRACE_*REGS* calls.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace32.c |   96 ++++++++++-----------------------------
 1 files changed, 25 insertions(+), 71 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
index 0f6eea0..4c1de6a 100644
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -24,6 +24,7 @@
 #include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/ptrace.h>
+#include <linux/regset.h>
 #include <linux/user.h>
 #include <linux/security.h>
 #include <linux/signal.h>
@@ -46,43 +47,21 @@
 static long compat_ptrace_old(struct task_struct *child, long request,
 			      long addr, long data)
 {
-	int ret = -EPERM;
-
-	switch(request) {
-	case PPC_PTRACE_GETREGS: { /* Get GPRs 0 - 31. */
-		int i;
-		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
-		unsigned int __user *tmp = (unsigned int __user *)addr;
-
-		CHECK_FULL_REGS(child->thread.regs);
-		for (i = 0; i < 32; i++) {
-			ret = put_user(*reg, tmp);
-			if (ret)
-				break;
-			reg++;
-			tmp++;
-		}
-		break;
-	}
-
-	case PPC_PTRACE_SETREGS: { /* Set GPRs 0 - 31. */
-		int i;
-		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
-		unsigned int __user *tmp = (unsigned int __user *)addr;
-
-		CHECK_FULL_REGS(child->thread.regs);
-		for (i = 0; i < 32; i++) {
-			ret = get_user(*reg, tmp);
-			if (ret)
-				break;
-			reg++;
-			tmp++;
-		}
-		break;
+	switch (request) {
+	case PPC_PTRACE_GETREGS:	/* Get GPRs 0 - 31. */
+		return copy_regset_to_user(child,
+					   task_user_regset_view(current), 0,
+					   0, 32 * sizeof(compat_long_t),
+					   compat_ptr(data));
+
+	case PPC_PTRACE_SETREGS:	/* Set GPRs 0 - 31. */
+		return copy_regset_from_user(child,
+					     task_user_regset_view(current), 0,
+					     0, 32 * sizeof(compat_long_t),
+					     compat_ptr(data));
 	}
 
-	}
-	return ret;
+	return -EPERM;
 }
 
 long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
@@ -291,42 +270,17 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 		break;
 	}
 
-	case PTRACE_GETREGS: { /* Get all pt_regs from the child. */
-		int ui;
-	  	if (!access_ok(VERIFY_WRITE, (void __user *)data,
-			       PT_REGS_COUNT * sizeof(int))) {
-			ret = -EIO;
-			break;
-		}
-		CHECK_FULL_REGS(child->thread.regs);
-		ret = 0;
-		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
-			ret |= __put_user(ptrace_get_reg(child, ui),
-					  (unsigned int __user *) data);
-			data += sizeof(int);
-		}
-		break;
-	}
-
-	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
-		unsigned long tmp;
-		int ui;
-	  	if (!access_ok(VERIFY_READ, (void __user *)data,
-			       PT_REGS_COUNT * sizeof(int))) {
-			ret = -EIO;
-			break;
-		}
-		CHECK_FULL_REGS(child->thread.regs);
-		ret = 0;
-		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
-			ret = __get_user(tmp, (unsigned int __user *) data);
-			if (ret)
-				break;
-			ptrace_put_reg(child, ui, tmp);
-			data += sizeof(int);
-		}
-		break;
-	}
+	case PTRACE_GETREGS:	/* Get all pt_regs from the child. */
+		return copy_regset_to_user(
+			child, task_user_regset_view(current), 0,
+			0, PT_REGS_COUNT * sizeof(compat_long_t),
+			compat_ptr(data));
+
+	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
+		return copy_regset_from_user(
+			child, task_user_regset_view(current), 0,
+			0, PT_REGS_COUNT * sizeof(compat_long_t),
+			compat_ptr(data));
 
 	case PTRACE_GETFPREGS:
 	case PTRACE_SETFPREGS:
-- 
1.5.3.6

