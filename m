Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZDNOxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZDNOxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbZDNOx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:53:26 -0400
Received: from cmpxchg.org ([85.214.51.133]:41517 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbZDNOxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:53:25 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] wait: don't use __wake_up_common()
Date: Tue, 14 Apr 2009 16:53:05 +0200
Message-Id: <1239720785-19661-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.2.1.135.gde769
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'777c6c5 wait: prevent exclusive waiter starvation' made
__wake_up_common() global to be used from abort_exclusive_wait().

It was needed to do a wake-up with the waitqueue lock held while
passing down a key to the wake-up function.

Since '4ede816 epoll keyed wakeups: add __wake_up_locked_key() and
__wake_up_sync_key()' there is an appropriate wrapper for this case:
__wake_up_locked_key().

Use it here and make __wake_up_common() private to the scheduler
again.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/wait.h |    2 --
 kernel/sched.c       |    2 +-
 kernel/wait.c        |    2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 5d631c1..67d4e89 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -132,8 +132,6 @@ static inline void __remove_wait_queue(wait_queue_head_t *head,
 	list_del(&old->task_list);
 }
 
-void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, int sync, void *key);
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
diff --git a/kernel/sched.c b/kernel/sched.c
index 5724508..46c8f25 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5221,7 +5221,7 @@ EXPORT_SYMBOL(default_wake_function);
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
  * zero in this (rare) case, and we handle it by continuing to scan the queue.
  */
-void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, int sync, void *key)
 {
 	wait_queue_t *curr, *next;
diff --git a/kernel/wait.c b/kernel/wait.c
index 42a2dbc..ea7c3b4 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -154,7 +154,7 @@ void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
 	if (!list_empty(&wait->task_list))
 		list_del_init(&wait->task_list);
 	else if (waitqueue_active(q))
-		__wake_up_common(q, mode, 1, 0, key);
+		__wake_up_locked_key(q, mode, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(abort_exclusive_wait);
-- 
1.6.2.1.135.gde769

