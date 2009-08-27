Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbZH0JJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbZH0JJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZH0JJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:09:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45804 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbZH0JJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:09:01 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: tj@kernel.org, alan@lxorguk.ukuu.org.uk, jeff@garzik.org,
       dhowells@redhat.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/3] slow-work: add delayed_slow_work support
Date: Thu, 27 Aug 2009 11:08:40 +0200
Message-Id: <1251364122-9592-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com>
References: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for starting slow work with a delay, similar
to the functionality we have for workqueues.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/slow-work.h |   15 +++++++++++
 kernel/slow-work.c        |   59 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index b65c888..12827a8 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -51,6 +51,11 @@ struct slow_work {
 	struct list_head	link;	/* link in queue */
 };
 
+struct delayed_slow_work {
+	struct timer_list timer;
+	struct slow_work work;
+};
+
 /**
  * slow_work_init - Initialise a slow work item
  * @work: The work item to initialise
@@ -66,6 +71,13 @@ static inline void slow_work_init(struct slow_work *work,
 	INIT_LIST_HEAD(&work->link);
 }
 
+static inline void delayed_slow_work_init(struct delayed_slow_work *dwork,
+					  const struct slow_work_ops *ops)
+{
+	init_timer(&dwork->timer);
+	slow_work_init(&dwork->work, ops);
+}
+
 /**
  * vslow_work_init - Initialise a very slow work item
  * @work: The work item to initialise
@@ -87,6 +99,9 @@ extern int slow_work_enqueue(struct slow_work *work);
 extern int slow_work_register_user(void);
 extern void slow_work_unregister_user(void);
 
+extern int delayed_slow_work_enqueue(struct delayed_slow_work *dwork,
+					unsigned long delay);
+
 #ifdef CONFIG_SYSCTL
 extern ctl_table slow_work_sysctls[];
 #endif
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 09d7519..1eeda59 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -318,6 +318,65 @@ cant_get_ref:
 }
 EXPORT_SYMBOL(slow_work_enqueue);
 
+static void delayed_slow_work_timer(unsigned long data)
+{
+	struct slow_work *work = (struct slow_work *) data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&slow_work_queue_lock, flags);
+	if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
+		list_add_tail(&work->link, &vslow_work_queue);
+	else
+		list_add_tail(&work->link, &slow_work_queue);
+	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
+
+	wake_up(&slow_work_thread_wq);
+}
+
+/**
+ * delayed_slow_work_enqueue - Schedule a delayed slow work item for processing
+ * @dwork: The delayed work item to queue
+ * @delay: When to start executing the work
+ *
+ * See slow_work_enqueue(), this functions adds a delay before the work
+ * is actually started. The act of queuing the work is not delayed.
+ */
+int delayed_slow_work_enqueue(struct delayed_slow_work *dwork,
+			      unsigned long delay)
+{
+	struct slow_work *work = &dwork->work;
+	unsigned long flags;
+
+	BUG_ON(slow_work_user_count <= 0);
+	BUG_ON(!work);
+	BUG_ON(!work->ops);
+	BUG_ON(!work->ops->get_ref);
+
+	if (!test_and_set_bit_lock(SLOW_WORK_PENDING, &work->flags)) {
+		spin_lock_irqsave(&slow_work_queue_lock, flags);
+
+		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
+			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
+		} else {
+			if (work->ops->get_ref(work) < 0)
+				goto cant_get_ref;
+		}
+
+		spin_unlock_irqrestore(&slow_work_queue_lock, flags);
+		dwork->timer.expires = jiffies + delay;
+		dwork->timer.data = (unsigned long) work;
+		dwork->timer.function = delayed_slow_work_timer;
+		add_timer(&dwork->timer);
+	}
+
+	return 0;
+
+cant_get_ref:
+	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
+	return -EAGAIN;
+}
+EXPORT_SYMBOL(delayed_slow_work_enqueue);
+
 /*
  * Schedule a cull of the thread pool at some time in the near future
  */
-- 
1.6.4.1.207.g68ea

