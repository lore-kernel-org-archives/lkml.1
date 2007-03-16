Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXCPBSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXCPBSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 21:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbXCPBSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 21:18:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXCPBSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 21:18:04 -0400
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Return EPERM not ECHILD on security_task_wait failure
X-Shopping-List: (1) Heretical Prenatal rendezvous
   (2) Elevated auctions
   (3) Cavernous compulsions
   (4) Curvaceous Wax & Wear clothes
   (5) Left-handed heterogeneous faceers
Message-Id: <20070316011756.988BD1801C5@magilla.sf.frob.com>
Date: Thu, 15 Mar 2007 18:17:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

wait* syscalls return -ECHILD even when an individual PID of a live
child was requested explicitly, when security_task_wait denies the
operation.  This means that something like a broken SELinux policy
can produce an unexpected failure that looks just like a bug with
wait or ptrace or something.

This patch makes do_wait return -EPERM instead of -ECHILD if some
children were ruled out solely because security_task_wait failed.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/exit.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index f132349..a41052f 100644  
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1067,7 +1067,7 @@ static int eligible_child(pid_t pid, int
 		return 2;
 
 	if (security_task_wait(p))
-		return 0;
+		return -1;
 
 	return 1;
 }
@@ -1449,6 +1449,7 @@ static long do_wait(pid_t pid, int optio
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int flag, retval;
+	int allowed, denied;
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
@@ -1457,6 +1458,7 @@ repeat:
 	 * match our criteria, even if we are not able to reap it yet.
 	 */
 	flag = 0;
+	allowed = denied = 0;
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
@@ -1472,6 +1474,12 @@ repeat:
 			if (!ret)
 				continue;
 
+			if (unlikely(ret < 0)) {
+				denied = 1;
+				continue;
+			}
+			allowed = 1;
+
 			switch (p->state) {
 			case TASK_TRACED:
 				/*
@@ -1570,6 +1578,8 @@ check_continued:
 		goto repeat;
 	}
 	retval = -ECHILD;
+	if (unlikely(denied) && !allowed)
+		retval = -EPERM;
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
