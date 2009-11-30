Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZK3DDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZK3DDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZK3DBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbZK3DAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 15/21] blkio: Drop the reference to queue once the task changes cgroup
Date: Sun, 29 Nov 2009 21:59:22 -0500
Message-Id: <1259549968-10369-16-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o If a task changes cgroup, drop reference to the cfqq associated with io
  context and set cfqq pointer stored in ioc to NULL so that upon next request
  arrival we will allocate a  new queue in new group.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ed18746..d076d01 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2610,6 +2610,41 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqq->pid = pid;
 }
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+static void changed_cgroup(struct io_context *ioc, struct cfq_io_context *cic)
+{
+	struct cfq_queue *sync_cfqq = cic_to_cfqq(cic, 1);
+	struct cfq_data *cfqd = cic->key;
+	unsigned long flags;
+	struct request_queue *q;
+
+	if (unlikely(!cfqd))
+		return;
+
+	q = cfqd->queue;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+
+	if (sync_cfqq) {
+		/*
+		 * Drop reference to sync queue. A new sync queue will be
+		 * assigned in new group upon arrival of a fresh request.
+		 */
+		cfq_log_cfqq(cfqd, sync_cfqq, "changed cgroup");
+		cic_set_cfqq(cic, NULL, 1);
+		cfq_put_queue(sync_cfqq);
+	}
+
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static void cfq_ioc_set_cgroup(struct io_context *ioc)
+{
+	call_for_each_cic(ioc, changed_cgroup);
+	ioc->cgroup_changed = 0;
+}
+#endif  /* CONFIG_CFQ_GROUP_IOSCHED */
+
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
@@ -2842,6 +2877,10 @@ out:
 	if (unlikely(ioc->ioprio_changed))
 		cfq_ioc_set_ioprio(ioc);
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	if (unlikely(ioc->cgroup_changed))
+		cfq_ioc_set_cgroup(ioc);
+#endif
 	return cic;
 err_free:
 	cfq_cic_free(cic);
-- 
1.6.2.5

