Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936074Ab0BZMPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:15:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:43558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935973Ab0BZMP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:15:27 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/43] workqueue: change cancel_work_sync() to clear work->data
Date: Fri, 26 Feb 2010 21:22:45 +0900
Message-Id: <1267187000-18791-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

In short: change cancel_work_sync(work) to mark this work as "never
queued" upon return.

When cancel_work_sync(work) succeeds, we know that this work can't be
queued or running, and since we own WORK_STRUCT_PENDING nobody can change
the bits in work->data under us. This means we can also clear the "cwq"
part along with _PENDING bit lockless before return, unless the work is
queued nobody can assume get_wq_data() is stable even under cwq->lock.

This change can speedup the subsequent cancel/flush requests, and as
Dmitry pointed out this simplifies the usage of work_struct's which
can be queued on different workqueues. Consider this pseudo code from
the input subsystem:

	struct workqueue_struct *WQ;
	struct work_struct *WORK;

	for (;;) {
		WQ = create_workqueue();
		...
		if (condition())
			queue_work(WQ, WORK);
		...
		cancel_work_sync(WORK);
		destroy_workqueue(WQ);
	}

If condition() returns T and then F, cancel_work_sync() will crash the
kernel because WORK->data still points to the already destroyed workqueue.
With this patch the code like above becomes correct.

Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dee4865..f7a914f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -229,6 +229,16 @@ static inline void set_wq_data(struct work_struct *work,
 	atomic_long_set(&work->data, new);
 }
 
+/*
+ * Clear WORK_STRUCT_PENDING and the workqueue on which it was queued.
+ */
+static inline void clear_wq_data(struct work_struct *work)
+{
+	unsigned long flags = *work_data_bits(work) &
+				(1UL << WORK_STRUCT_STATIC);
+	atomic_long_set(&work->data, flags);
+}
+
 static inline
 struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 {
@@ -671,7 +681,7 @@ static int __cancel_work_timer(struct work_struct *work,
 		wait_on_work(work);
 	} while (unlikely(ret < 0));
 
-	work_clear_pending(work);
+	clear_wq_data(work);
 	return ret;
 }
 
-- 
1.6.4.2

