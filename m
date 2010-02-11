Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0BKJem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 04:34:42 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:51728 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab0BKJej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:34:39 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: [PATCH] ptrace: unify FDPIC implementations
Date: Thu, 11 Feb 2010 04:36:00 -0500
Message-Id: <1265880960-26676-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin/FRV/SuperH guys all have the same exact FDPIC ptrace code in
their arch handlers (since they were probably copied & pasted).  Since
these ptrace interfaces are an arch independent aspect of the FDPIC code,
unify them in the common ptrace code so new FDPIC ports don't need to copy
and paste this fundamental stuff yet again.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/ptrace.c |   33 ++++++++-------------------------
 arch/frv/kernel/ptrace.c      |   20 --------------------
 arch/sh/kernel/ptrace_32.c    |   23 -----------------------
 kernel/ptrace.c               |   20 ++++++++++++++++++++
 4 files changed, 28 insertions(+), 68 deletions(-)

diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 65567dc..0ae2f1e 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -261,11 +261,15 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			} else if (addr == (sizeof(struct pt_regs) + 8)) {
 				/* PT_DATA_ADDR */
 				tmp = child->mm->start_data;
-#ifdef CONFIG_BINFMT_ELF_FDPIC
+#ifdef CONFIG_BINFMT_ELF_FDPIC	/* backwards compat */
 			} else if (addr == (sizeof(struct pt_regs) + 12)) {
-				goto case_PTRACE_GETFDPIC_EXEC;
+				request = PTRACE_GETFDPIC;
+				addr = PTRACE_GETFDPIC_EXEC;
+				goto case_default;
 			} else if (addr == (sizeof(struct pt_regs) + 16)) {
-				goto case_PTRACE_GETFDPIC_INTERP;
+				request = PTRACE_GETFDPIC;
+				addr = PTRACE_GETFDPIC_INTERP;
+				goto case_default;
 #endif
 			} else {
 				tmp = get_reg(child, addr);
@@ -274,28 +278,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			break;
 		}
 
-#ifdef CONFIG_BINFMT_ELF_FDPIC
-	case PTRACE_GETFDPIC: {
-		unsigned long tmp = 0;
-
-		switch (addr) {
-		case_PTRACE_GETFDPIC_EXEC:
-		case PTRACE_GETFDPIC_EXEC:
-			tmp = child->mm->context.exec_fdpic_loadmap;
-			break;
-		case_PTRACE_GETFDPIC_INTERP:
-		case PTRACE_GETFDPIC_INTERP:
-			tmp = child->mm->context.interp_fdpic_loadmap;
-			break;
-		default:
-			break;
-		}
-
-		ret = put_user(tmp, datap);
-		break;
-	}
-#endif
-
 		/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKEDATA:
 		pr_debug("ptrace: PTRACE_PEEKDATA\n");
@@ -409,6 +391,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = 0;
 		break;
 
+	case_default:
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index 60eeed3..fac0289 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -344,26 +344,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					     0, sizeof(child->thread.user->f),
 					     (const void __user *)data);
 
-	case PTRACE_GETFDPIC:
-		tmp = 0;
-		switch (addr) {
-		case PTRACE_GETFDPIC_EXEC:
-			tmp = child->mm->context.exec_fdpic_loadmap;
-			break;
-		case PTRACE_GETFDPIC_INTERP:
-			tmp = child->mm->context.interp_fdpic_loadmap;
-			break;
-		default:
-			break;
-		}
-
-		ret = 0;
-		if (put_user(tmp, (unsigned long *) data)) {
-			ret = -EFAULT;
-			break;
-		}
-		break;
-
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 9be35f3..ab8123b 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -405,29 +405,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					     0, sizeof(struct pt_dspregs),
 					     (const void __user *)data);
 #endif
-#ifdef CONFIG_BINFMT_ELF_FDPIC
-	case PTRACE_GETFDPIC: {
-		unsigned long tmp = 0;
-
-		switch (addr) {
-		case PTRACE_GETFDPIC_EXEC:
-			tmp = child->mm->context.exec_fdpic_loadmap;
-			break;
-		case PTRACE_GETFDPIC_INTERP:
-			tmp = child->mm->context.interp_fdpic_loadmap;
-			break;
-		default:
-			break;
-		}
-
-		ret = 0;
-		if (put_user(tmp, datap)) {
-			ret = -EFAULT;
-			break;
-		}
-		break;
-	}
-#endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 23bd09c..60fe465 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -554,6 +554,26 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = ptrace_detach(child, data);
 		break;
 
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	case PTRACE_GETFDPIC: {
+		unsigned long tmp = 0;
+
+		switch (addr) {
+		case PTRACE_GETFDPIC_EXEC:
+			tmp = child->mm->context.exec_fdpic_loadmap;
+			break;
+		case PTRACE_GETFDPIC_INTERP:
+			tmp = child->mm->context.interp_fdpic_loadmap;
+			break;
+		default:
+			break;
+		}
+
+		ret = put_user(tmp, (unsigned long __user *) data);
+		break;
+	}
+#endif
+
 #ifdef PTRACE_SINGLESTEP
 	case PTRACE_SINGLESTEP:
 #endif
-- 
1.6.6.1

