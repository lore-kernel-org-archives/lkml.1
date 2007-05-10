Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbXEKJIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbXEKJIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbXEKJHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:07:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094AbXEKJGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:06:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7/7] Freezer: Move frozen_process to kernel/power/process.c
Date: Fri, 11 May 2007 00:44:23 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl>
In-Reply-To: <200705110035.32229.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705110044.23934.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>

Other than refrigerator, no one else calls frozen_process(). So move it
from include/linux/freezer.h to kernel/power/process.c.

Also, since a task can be marked as frozen by itself, we don't need to pass
the (struct task_struct *p) parameter to frozen_process().

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |   13 -------------
 kernel/power/process.c  |   14 +++++++++++++-
 2 files changed, 13 insertions(+), 14 deletions(-)

Index: linux-2.6/include/linux/freezer.h
===================================================================
--- linux-2.6.orig/include/linux/freezer.h	2007-05-10 21:44:47.000000000 +0200
+++ linux-2.6/include/linux/freezer.h	2007-05-10 21:44:50.000000000 +0200
@@ -58,18 +58,6 @@ static inline int thaw_process(struct ta
 	return 0;
 }
 
-/*
- * freezing is complete, mark process as frozen
- */
-static inline void frozen_process(struct task_struct *p)
-{
-	if (!unlikely(p->flags & PF_NOFREEZE)) {
-		p->flags |= PF_FROZEN;
-		wmb();
-	}
-	clear_tsk_thread_flag(p, TIF_FREEZE);
-}
-
 extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
@@ -132,7 +120,6 @@ static inline int frozen(struct task_str
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void freeze(struct task_struct *p) { BUG(); }
 static inline int thaw_process(struct task_struct *p) { return 1; }
-static inline void frozen_process(struct task_struct *p) { BUG(); }
 
 static inline void refrigerator(void) {}
 static inline int freeze_processes(void) { BUG(); return 0; }
Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c	2007-05-10 21:44:40.000000000 +0200
+++ linux-2.6/kernel/power/process.c	2007-05-10 21:44:50.000000000 +0200
@@ -32,6 +32,18 @@ static inline int freezeable(struct task
 	return 1;
 }
 
+/*
+ * freezing is complete, mark current process as frozen
+ */
+static inline void frozen_process(void)
+{
+	if (!unlikely(current->flags & PF_NOFREEZE)) {
+		current->flags |= PF_FROZEN;
+		wmb();
+	}
+	clear_tsk_thread_flag(current, TIF_FREEZE);
+}
+
 /* Refrigerator is place where frozen processes are stored :-). */
 void refrigerator(void)
 {
@@ -41,7 +53,7 @@ void refrigerator(void)
 
 	task_lock(current);
 	if (freezing(current)) {
-		frozen_process(current);
+		frozen_process();
 		task_unlock(current);
 	} else {
 		task_unlock(current);

