Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYKSJzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYKSJzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYKSJz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:55:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:44394 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYKSJz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:55:29 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Exiting queue and task might race to free cic
Date: Wed, 19 Nov 2008 15:27:17 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, Fabio Checconi <fchecconi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811191527.18539.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens

Looking at the bug reported here
http://thread.gmane.org/gmane.linux.kernel/722539
it looks like an exiting queue can race with an exiting task.

When a queue exits the queue lock is taken and cfq_exit_queue() would free all 
the cic's associated with the queue.

But when a task exits, cfq_exit_io_context() gets cic one by one and then 
locks the associated queue to call __cfq_exit_single_io_context. It looks like 
between getting a cic from the ioc and locking the queue, the queue might have 
exited on another cpu. Isn't this possible?

If possible, either verifying whether cic->key is still not null or q->flags 
does not have QUEUE_FLAG_DEAD set would fix this.

Thanks
Nikanth Karthikesan

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6a062ee..b9b627a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1318,7 +1318,12 @@ static void cfq_exit_single_io_context(struct 
io_context *ioc,
 		unsigned long flags;
 
 		spin_lock_irqsave(q->queue_lock, flags);
-		__cfq_exit_single_io_context(cfqd, cic);
+		/*
+		 * cic might have been already exited when an exiting task
+		 * races with an exiting queue.
+		 */
+		if (likely(cic->key))
+			__cfq_exit_single_io_context(cfqd, cic);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }

Or this would also work

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6a062ee..7a068bd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1318,7 +1318,11 @@ static void cfq_exit_single_io_context(struct 
io_context *ioc,
 		unsigned long flags;
 
 		spin_lock_irqsave(q->queue_lock, flags);
-		__cfq_exit_single_io_context(cfqd, cic);
+		/*
+		 * Make sure the queue is not dead.
+		 */
+		if (likely(!test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+			__cfq_exit_single_io_context(cfqd, cic);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }


