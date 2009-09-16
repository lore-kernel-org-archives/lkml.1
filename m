Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbZIPKY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbZIPKY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758760AbZIPKY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:24:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:58417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758782AbZIPKYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:24:54 -0400
Date: Wed, 16 Sep 2009 10:24:28 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix sync wakeups again
Message-ID: <tip-63859d4fe4c97b737e7adbfe60acb1c2b2e668cb@git.kernel.org>
Git-Commit-ID: 63859d4fe4c97b737e7adbfe60acb1c2b2e668cb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:24:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63859d4fe4c97b737e7adbfe60acb1c2b2e668cb
Gitweb:     http://git.kernel.org/tip/63859d4fe4c97b737e7adbfe60acb1c2b2e668cb
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 15 Sep 2009 19:14:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 19:47:22 +0200

sched: Fix sync wakeups again

The sync argument rename to introduce WF_* broke stuff by missing a
local alias for an argument in __wake_up_common, fix it by using
the more descriptive wake_flags name.

This restores WF_SYNC propagation, which fixes wake_affine()
behaviour, which fixes pipe-test.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0d4c4fe..af04ede 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5564,10 +5564,10 @@ asmlinkage void __sched preempt_schedule_irq(void)
 
 #endif /* CONFIG_PREEMPT */
 
-int default_wake_function(wait_queue_t *curr, unsigned mode, int flags,
+int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
 			  void *key)
 {
-	return try_to_wake_up(curr->private, mode, flags);
+	return try_to_wake_up(curr->private, mode, wake_flags);
 }
 EXPORT_SYMBOL(default_wake_function);
 
@@ -5581,14 +5581,14 @@ EXPORT_SYMBOL(default_wake_function);
  * zero in this (rare) case, and we handle it by continuing to scan the queue.
  */
 static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, int flags, void *key)
+			int nr_exclusive, int wake_flags, void *key)
 {
 	wait_queue_t *curr, *next;
 
 	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
 		unsigned flags = curr->flags;
 
-		if (curr->func(curr, mode, flags, key) &&
+		if (curr->func(curr, mode, wake_flags, key) &&
 				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
 			break;
 	}
