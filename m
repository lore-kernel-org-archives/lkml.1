Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZECTA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZECTA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZECTAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:00:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59470 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZECTAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:00:47 -0400
Date: Sun, 3 May 2009 20:55:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] utrace-core-kill-exclude_xtrace-logic
Message-ID: <20090503185545.GA17080@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of utrace-core.patch)

exclude_utrace() has no callers. exclude_ptrace() is called under
tasklist_lock + task_lock() but needs utrace->lock.

Remove this logic for now. We will either add utrace-ptrace or rework
this mutual exclusion later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |   18 +-----------------
 kernel/utrace.c |    8 --------
 2 files changed, 1 insertion(+), 25 deletions(-)

--- PTRACE/kernel/ptrace.c~1_EXCLUDE	2009-05-03 19:28:47.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-03 19:30:15.000000000 +0200
@@ -16,7 +16,6 @@
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
 #include <linux/ptrace.h>
-#include <linux/utrace.h>
 #include <linux/security.h>
 #include <linux/signal.h>
 #include <linux/audit.h>
@@ -175,14 +174,6 @@ bool ptrace_may_access(struct task_struc
 	return !err;
 }
 
-/*
- * For experimental use of utrace, exclude ptrace on the same task.
- */
-static inline bool exclude_ptrace(struct task_struct *task)
-{
-	return unlikely(!!task_utrace_flags(task));
-}
-
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
@@ -221,11 +212,6 @@ repeat:
 		goto repeat;
 	}
 
-	if (exclude_ptrace(task)) {
-		retval = -EBUSY;
-		goto bad;
-	}
-
 	if (!task->mm)
 		goto bad;
 	/* the same process cannot be attached many times */
@@ -602,9 +588,7 @@ int ptrace_traceme(void)
 	 */
 repeat:
 	task_lock(current);
-	if (exclude_ptrace(current)) {
-		ret = -EBUSY;
-	} else if (!(current->ptrace & PT_PTRACED)) {
+	if (!(current->ptrace & PT_PTRACED)) {
 		/*
 		 * See ptrace_attach() comments about the locking here.
 		 */
--- PTRACE/kernel/utrace.c~1_EXCLUDE	2009-04-29 14:26:52.000000000 +0200
+++ PTRACE/kernel/utrace.c	2009-05-03 19:29:56.000000000 +0200
@@ -108,14 +108,6 @@ static struct utrace_engine *matching_en
 }
 
 /*
- * For experimental use, utrace attach is mutually exclusive with ptrace.
- */
-static inline bool exclude_utrace(struct task_struct *task)
-{
-	return unlikely(!!task->ptrace);
-}
-
-/*
  * Called without locks, when we might be the first utrace engine to attach.
  * If this is a newborn thread and we are not the creator, we have to wait
  * for it.  The creator gets the first chance to attach.  The PF_STARTING

