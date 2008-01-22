Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbYAVJzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbYAVJzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbYAVJy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:54:29 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8780 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497AbYAVJy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:54:27 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: knikanth@novell.com, Nikanth Karthikesan <KNikanth@novell.com>
Subject: [PATCH 3/6] io_context sharing - cfq changes
Date: Tue, 22 Jan 2008 10:49:18 +0100
Message-Id: <1200995361-24001-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.rc2.84.gf85fd
In-Reply-To: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikanth Karthikesan <KNikanth@novell.com>

changes in the cfq for io_context sharing

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 533af75..dba52b6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -895,7 +895,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * task has exited, don't wait
 	 */
 	cic = cfqd->active_cic;
-	if (!cic || !cic->ioc->task)
+	if (!cic || !atomic_read(&cic->ioc->nr_tasks))
 		return;
 
 	/*
@@ -1178,6 +1178,8 @@ static void cfq_free_io_context(struct io_context *ioc)
 
 	ioc->ioc_data = NULL;
 
+	spin_lock(&ioc->lock);
+
 	while ((n = rb_first(&ioc->cic_root)) != NULL) {
 		__cic = rb_entry(n, struct cfq_io_context, rb_node);
 		rb_erase(&__cic->rb_node, &ioc->cic_root);
@@ -1189,6 +1191,8 @@ static void cfq_free_io_context(struct io_context *ioc)
 
 	if (ioc_gone && !elv_ioc_count_read(ioc_count))
 		complete(ioc_gone);
+
+	spin_unlock(&ioc->lock);
 }
 
 static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
@@ -1243,6 +1247,7 @@ static void cfq_exit_io_context(struct io_context *ioc)
 
 	ioc->ioc_data = NULL;
 
+	spin_lock(&ioc->lock);
 	/*
 	 * put the reference this task is holding to the various queues
 	 */
@@ -1253,6 +1258,8 @@ static void cfq_exit_io_context(struct io_context *ioc)
 		cfq_exit_single_io_context(__cic);
 		n = rb_next(n);
 	}
+
+	spin_unlock(&ioc->lock);
 }
 
 static struct cfq_io_context *
@@ -1349,6 +1356,8 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 	struct cfq_io_context *cic;
 	struct rb_node *n;
 
+	spin_lock(&ioc->lock);
+
 	ioc->ioprio_changed = 0;
 
 	n = rb_first(&ioc->cic_root);
@@ -1358,6 +1367,8 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 		changed_ioprio(cic);
 		n = rb_next(n);
 	}
+
+	spin_unlock(&ioc->lock);
 }
 
 static struct cfq_queue *
@@ -1502,6 +1513,7 @@ cfq_cic_rb_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	if (cic && cic->key == cfqd)
 		return cic;
 
+	spin_lock(&ioc->lock);
 restart:
 	n = ioc->cic_root.rb_node;
 	while (n) {
@@ -1519,10 +1531,12 @@ restart:
 			n = n->rb_right;
 		else {
 			ioc->ioc_data = cic;
+			spin_unlock(&ioc->lock);
 			return cic;
 		}
 	}
 
+	spin_unlock(&ioc->lock);
 	return NULL;
 }
 
@@ -1536,6 +1550,7 @@ cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
 	unsigned long flags;
 	void *k;
 
+	spin_lock(&ioc->lock);
 	cic->ioc = ioc;
 	cic->key = cfqd;
 
@@ -1566,6 +1581,7 @@ restart:
 	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
 	list_add(&cic->queue_list, &cfqd->cic_list);
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
+	spin_unlock(&ioc->lock);
 }
 
 /*
@@ -1659,7 +1675,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	enable_idle = cfq_cfqq_idle_window(cfqq);
 
-	if (!cic->ioc->task || !cfqd->cfq_slice_idle ||
+	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
 	    (cfqd->hw_tag && CIC_SEEKY(cic)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
-- 
1.5.4.rc2.84.gf85fd

