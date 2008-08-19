Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYHSXWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYHSXWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYHSXWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:22:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58611 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYHSXWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:22:37 -0400
Message-Id: <20080819232233.732140572@us.ibm.com>
References: <20080819232232.432973784@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Aug 2008 16:22:34 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH 2/6] Container Freezer: uninline thaw_process()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the cgroup freezer system also calls thaw_process() inlining these
functions uses more space. Uninlining returns some space:

Before:
	text	data	bss	dec	hex	filename
	4260872	275532	290816	4827220 49a854	vmlinux
After:
	text	data	bss	dec	hex	filename
	4260852	275532	290816	4827200	49a840	vmlinux

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |	29 +++--------------------------
 kernel/freezer.c        |	31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 26 deletions(-)

Index: linux-2.6.27-rc1-mm1/include/linux/freezer.h
===================================================================
--- linux-2.6.27-rc1-mm1.orig/include/linux/freezer.h
+++ linux-2.6.27-rc1-mm1/include/linux/freezer.h
@@ -46,34 +46,11 @@ static inline bool should_send_signal(st
 
 /*
  * Wake up a frozen process
- *
- * task_lock() is needed to prevent the race with refrigerator() which may
- * occur if the freezing of tasks fails.  Namely, without the lock, if the
- * freezing of tasks failed, thaw_tasks() might have run before a task in
- * refrigerator() could call frozen_process(), in which case the task would be
- * frozen and no one would thaw it.
  */
-static inline int __thaw_process(struct task_struct *p)
-{
-	if (frozen(p)) {
-		p->flags &= ~PF_FROZEN;
-		return 1;
-	}
-	clear_freeze_flag(p);
-	return 0;
-}
+extern int __thaw_process(struct task_struct *p);
 
-static inline int thaw_process(struct task_struct *p)
-{
-	task_lock(p);
-	if (__thaw_process(p) == 1) {
-		task_unlock(p);
-		wake_up_process(p);
-		return 1;
-	}
-	task_unlock(p);
-	return 0;
-}
+/* Takes and releases task alloc lock using task_lock() */
+extern int thaw_process(struct task_struct *p);
 
 extern void refrigerator(void);
 extern int freeze_processes(void);
Index: linux-2.6.27-rc1-mm1/kernel/freezer.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/kernel/freezer.c
+++ linux-2.6.27-rc1-mm1/kernel/freezer.c
@@ -120,3 +120,34 @@ void cancel_freezing(struct task_struct 
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 }
+
+/*
+ * Wake up a frozen process
+ *
+ * task_lock() is needed to prevent the race with refrigerator() which may
+ * occur if the freezing of tasks fails.  Namely, without the lock, if the
+ * freezing of tasks failed, thaw_tasks() might have run before a task in
+ * refrigerator() could call frozen_process(), in which case the task would be
+ * frozen and no one would thaw it.
+ */
+int __thaw_process(struct task_struct *p)
+{
+	if (frozen(p)) {
+		p->flags &= ~PF_FROZEN;
+		return 1;
+	}
+	clear_freeze_flag(p);
+	return 0;
+}
+
+int thaw_process(struct task_struct *p)
+{
+	task_lock(p);
+	if (__thaw_process(p) == 1) {
+		task_unlock(p);
+		wake_up_process(p);
+		return 1;
+	}
+	task_unlock(p);
+	return 0;
+}

-- 
