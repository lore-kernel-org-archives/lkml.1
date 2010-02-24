Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab0BXUWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:22:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758038Ab0BXUWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:22:11 -0500
Date: Wed, 24 Feb 2010 21:20:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] workqueues: change cancel_work_sync() to clear
	work->data
Message-ID: <20100224202031.GA26987@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 kernel/workqueue.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- wq/kernel/workqueue.c~1_CANCEL_CLEAR_WQ	2010-02-24 20:43:32.000000000 +0100
+++ wq/kernel/workqueue.c	2010-02-24 20:55:53.000000000 +0100
@@ -229,6 +229,16 @@ static inline void set_wq_data(struct wo
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
@@ -671,7 +681,7 @@ static int __cancel_work_timer(struct wo
 		wait_on_work(work);
 	} while (unlikely(ret < 0));
 
-	work_clear_pending(work);
+	clear_wq_data(work);
 	return ret;
 }
 

