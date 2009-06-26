Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZFZJFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZFZJFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbZFZJFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:05:21 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42915 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758272AbZFZJFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:05:19 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/2] cfq-iosched: move cfqq initialization out of cfq_find_alloc_queue()
Date: Fri, 26 Jun 2009 11:05:19 +0200
Message-Id: <1246007120-24034-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com>
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to be needing that init code outside of that function
to get rid of the __GFP_NOFAIL in cfqq allocation.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 833ec18..c760ae7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1641,6 +1641,26 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 	ioc->ioprio_changed = 0;
 }
 
+static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+			  pid_t pid, int is_sync)
+{
+	RB_CLEAR_NODE(&cfqq->rb_node);
+	RB_CLEAR_NODE(&cfqq->p_node);
+	INIT_LIST_HEAD(&cfqq->fifo);
+
+	atomic_set(&cfqq->ref, 0);
+	cfqq->cfqd = cfqd;
+
+	cfq_mark_cfqq_prio_changed(cfqq);
+
+	if (is_sync) {
+		if (!cfq_class_idle(cfqq))
+			cfq_mark_cfqq_idle_window(cfqq);
+		cfq_mark_cfqq_sync(cfqq);
+	}
+	cfqq->pid = pid;
+}
+
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, int is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
@@ -1678,23 +1698,8 @@ retry:
 				goto out;
 		}
 
-		RB_CLEAR_NODE(&cfqq->rb_node);
-		RB_CLEAR_NODE(&cfqq->p_node);
-		INIT_LIST_HEAD(&cfqq->fifo);
-
-		atomic_set(&cfqq->ref, 0);
-		cfqq->cfqd = cfqd;
-
-		cfq_mark_cfqq_prio_changed(cfqq);
-
+		cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
 		cfq_init_prio_data(cfqq, ioc);
-
-		if (is_sync) {
-			if (!cfq_class_idle(cfqq))
-				cfq_mark_cfqq_idle_window(cfqq);
-			cfq_mark_cfqq_sync(cfqq);
-		}
-		cfqq->pid = current->pid;
 		cfq_log_cfqq(cfqd, cfqq, "alloced");
 	}
 
-- 
1.6.3.2.306.g4f4fa

