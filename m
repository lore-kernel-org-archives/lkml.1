Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZGTRI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZGTRI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZGTRI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:08:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:3150 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZGTRIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:08:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=d0mi/v56yQ1e2fmKiOO86SQkh1G505/6I14ObGYKnBGZ3fY9N6kvieXkG46jzaBAvQ
         3mt5n+YQsyJwEBTHJXH1lW562djpUKmirgeRSp6tHw9RcZe2ZJTDoz88cxrpJyajU8er
         rT/e91mCDYLwNpJ7L4g58QZOxr9XxUB+ibLok=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linuxtronix.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH 3/5] hw-breakpoints: Make user breakpoints API truly generic
Date: Mon, 20 Jul 2009 13:08:05 -0400
Message-Id: <1248109687-7808-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the API changes on the kernel breakpoints API,
the user breakpoints registration now follows the same pattern.

The target, access length and type and now given as parameters
in the registration helpers to avoid per arch code in generic code.

However, to keep registering or modifying easily a user breakpoint
from arch code with a prefilled arch breakpoint structure, we provide
two new helpers:

- register_user_hw_breakpoint_filled(tsk, bp)
- modify_user_hw_breakpoint_filled(tsk, bp)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/ptrace.c            |   21 ++++++-----
 include/asm-generic/hw_breakpoint.h |   12 +++++-
 kernel/hw_breakpoint.c              |   65 +++++++++++++++++++++++++++++-----
 3 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index cabdabc..ef0eb10 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -525,17 +525,18 @@ restore:
 		if (!bp) {
 			rc = -ENOMEM;
 			bp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
-			if (bp) {
-				bp->info.address = thread->debugreg[i];
-				bp->triggered = ptrace_triggered;
-				bp->info.len = len;
-				bp->info.type = type;
-				rc = register_user_hw_breakpoint(tsk, bp);
-				if (rc)
-					kfree(bp);
-			}
+			if (!bp)
+				break;
+
+			bp->info.address = thread->debugreg[i];
+			bp->triggered = ptrace_triggered;
+			bp->info.len = len;
+			bp->info.type = type;
+			rc = register_user_hw_breakpoint_filled(tsk, bp);
+			if (rc)
+				kfree(bp);
 		} else
-			rc = modify_user_hw_breakpoint(tsk, bp);
+			rc = modify_user_hw_breakpoint_filled(tsk, bp);
 		if (rc)
 			break;
 	}
diff --git a/include/asm-generic/hw_breakpoint.h b/include/asm-generic/hw_breakpoint.h
index 300fe4c..598e3c4 100644
--- a/include/asm-generic/hw_breakpoint.h
+++ b/include/asm-generic/hw_breakpoint.h
@@ -83,10 +83,18 @@ struct hw_breakpoint {
  * 1-, 2-, and 4-byte lengths may be unavailable.
  */
 
+extern int register_user_hw_breakpoint_filled(struct task_struct *tsk,
+					      struct hw_breakpoint *bp);
 extern int register_user_hw_breakpoint(struct task_struct *tsk,
-					struct hw_breakpoint *bp);
+				       struct hw_breakpoint *bp,
+				       unsigned long addr, int len,
+				       enum breakpoint_type type);
+extern int modify_user_hw_breakpoint_filled(struct task_struct *tsk,
+					    struct hw_breakpoint *bp);
 extern int modify_user_hw_breakpoint(struct task_struct *tsk,
-					struct hw_breakpoint *bp);
+				     struct hw_breakpoint *bp,
+				     unsigned long addr,
+				     int len, enum breakpoint_type type);
 extern void unregister_user_hw_breakpoint(struct task_struct *tsk,
 						struct hw_breakpoint *bp);
 /*
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 0301245..f9e62e7 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -211,16 +211,14 @@ static void __unregister_user_hw_breakpoint(int pos, struct task_struct *tsk)
 }
 
 /**
- * register_user_hw_breakpoint - register a hardware breakpoint for user space
+ * register_user_hw_breakpoint_filled - register a filled hardware breakpoint
+ * for user space.
  * @tsk: pointer to 'task_struct' of the process to which the address belongs
  * @bp: the breakpoint structure to register
- *
- * @bp.info->name or @bp.info->address, @bp.info->len, @bp.info->type and
  * @bp->triggered must be set properly before invocation
- *
  */
-int register_user_hw_breakpoint(struct task_struct *tsk,
-					struct hw_breakpoint *bp)
+int register_user_hw_breakpoint_filled(struct task_struct *tsk,
+				       struct hw_breakpoint *bp)
 {
 	struct thread_struct *thread = &(tsk->thread);
 	int i, rc = -ENOSPC;
@@ -246,15 +244,40 @@ int register_user_hw_breakpoint(struct task_struct *tsk,
 	spin_unlock_bh(&hw_breakpoint_lock);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(register_user_hw_breakpoint_filled);
+
+/**
+ * register_user_hw_breakpoint - register a filled hardware breakpoint
+ * for user space.
+ * @tsk: pointer to 'task_struct' of the process to which the address belongs
+ * @bp: the breakpoint structure to register
+ * @addr: target of the breakpoint
+ * @len: length of the memory target access
+ * @type: type of the breakpoint (read-write/read/write/execute)
+ * @bp->triggered must be set properly before invocation
+ */
+int register_user_hw_breakpoint(struct task_struct *tsk,
+				struct hw_breakpoint *bp,
+				unsigned long addr,
+				int len, enum breakpoint_type type)
+{
+	int ret;
+
+	ret = arch_fill_hw_breakpoint(bp, addr, len, type);
+	if (ret)
+		return ret;
+
+	return register_user_hw_breakpoint_filled(tsk, bp);
+}
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
 /**
- * modify_user_hw_breakpoint - modify a user-space hardware breakpoint
+ * modify_user_hw_breakpoint_filled - modify a filled user-space hardware breakpoint
  * @tsk: pointer to 'task_struct' of the process to which the address belongs
- * @bp: the breakpoint structure to unregister
- *
+ * @bp: the breakpoint structure to update
  */
-int modify_user_hw_breakpoint(struct task_struct *tsk, struct hw_breakpoint *bp)
+int modify_user_hw_breakpoint_filled(struct task_struct *tsk,
+				     struct hw_breakpoint *bp)
 {
 	struct thread_struct *thread = &(tsk->thread);
 	int i, ret = -ENOENT;
@@ -269,6 +292,28 @@ int modify_user_hw_breakpoint(struct task_struct *tsk, struct hw_breakpoint *bp)
 	spin_unlock_bh(&hw_breakpoint_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(modify_user_hw_breakpoint_filled);
+
+/**
+ * modify_user_hw_breakpoint - modify a user-space hardware breakpoint
+ * @tsk: pointer to 'task_struct' of the process to which the address belongs
+ * @bp: the breakpoint structure to update
+ * @addr: target of the breakpoint
+ * @len: length of the memory target access
+ * @type: type of the breakpoint (read-write/read/write/execute)
+ */
+int modify_user_hw_breakpoint(struct task_struct *tsk, struct hw_breakpoint *bp,
+			      unsigned long addr, int len,
+			      enum breakpoint_type type)
+{
+	int ret;
+
+	ret = arch_fill_hw_breakpoint(bp, addr, len, type);
+	if (ret)
+		return ret;
+
+	return register_user_hw_breakpoint_filled(tsk, bp);
+}
 EXPORT_SYMBOL_GPL(modify_user_hw_breakpoint);
 
 /**
-- 
1.6.2.3

