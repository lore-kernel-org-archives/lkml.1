Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZKLXex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZKLXex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbZKLXeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:34:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZKLXel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:34:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 15/16] blkio: Drop the reference to queue once the task changes cgroup
Date: Thu, 12 Nov 2009 18:32:35 -0500
Message-Id: <1258068756-10766-16-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
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
index 3f7a350..34f029c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2648,6 +2648,41 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
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
@@ -2880,6 +2915,10 @@ out:
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

