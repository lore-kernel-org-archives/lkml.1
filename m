Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbZDNPuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbZDNPuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZDNPuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:50:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:50806 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZDNPue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:50:34 -0400
Date: Tue, 14 Apr 2009 15:48:33 GMT
From: tip-bot for Johannes Weiner <hannes@cmpxchg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, hannes@cmpxchg.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, hannes@cmpxchg.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239720785-19661-1-git-send-email-hannes@cmpxchg.org>
References: <1239720785-19661-1-git-send-email-hannes@cmpxchg.org>
Subject: [tip:sched/core] wait: don't use __wake_up_common()
Message-ID: <tip-78ddb08feb7d4fbe3c0a9931804c51ee58be4023@git.kernel.org>
Git-Commit-ID: 78ddb08feb7d4fbe3c0a9931804c51ee58be4023
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 15:48:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78ddb08feb7d4fbe3c0a9931804c51ee58be4023
Gitweb:     http://git.kernel.org/tip/78ddb08feb7d4fbe3c0a9931804c51ee58be4023
Author:     Johannes Weiner <hannes@cmpxchg.org>
AuthorDate: Tue, 14 Apr 2009 16:53:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 17:17:16 +0200

wait: don't use __wake_up_common()

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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1239720785-19661-1-git-send-email-hannes@cmpxchg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 36d213b..92b4b56 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5345,7 +5345,7 @@ EXPORT_SYMBOL(default_wake_function);
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
