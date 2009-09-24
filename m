Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZIXT1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZIXT1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZIXT1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:27:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbZIXT0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:26:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       vgoyal@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
       jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       riel@redhat.com
Subject: [PATCH 19/28] io-controller: Avoid expiring ioq for single ioq scheduler if only root group
Date: Thu, 24 Sep 2009 15:25:23 -0400
Message-Id: <1253820332-10246-20-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o For io scheduler noop, deadline and AS, we maintain only one ioq per group.
  If people are using only flat mode where only root group is present, there
  will be only one ioq. In that case we can avoid queue expiration every
  100ms (dependent on slice_sync). This patch introduces this optimization.

o If an ioq is not expired for a long time and suddenly somebody
  decides to create a group and launch a job there, in that case old ioq
  queue will be expired with a very high value of slice used and will get
  a very high disk time. Fix it by marking the queue as "charge_one_slice"
  and charge the queue only for a single time slice and not for whole
  of the duration when queue was running.

o Introduce the notion of "real_served" and "virtual_served". real time is the
  actual time queue used and is visible through cgroup interface. virtual_time
  is the one we actually want to charge the queue for.  If a queue has not
  been expired for long time, real_time value will probably be high but we
  charge the queue for only one slice length.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++
 block/elevator-fq.h |    3 ++
 2 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index b08a200..04419cf 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -902,6 +902,19 @@ static void elv_ioq_served(struct io_queue *ioq, unsigned long served)
 	queue_charge = group_charge = served;
 
 	/*
+	 * For single ioq schedulers we don't expire the queue if there are
+	 * no other competing groups. It might happen that once a queue has
+	 * not been expired for a long time, suddenly a new group is created
+	 * and IO comes in that new group. In that case, we don't want to
+	 * charge the old queue for whole of the period it was not expired.
+	 */
+
+	if (elv_ioq_charge_one_slice(ioq) && queue_charge > allocated_slice)
+		queue_charge = group_charge = allocated_slice;
+
+	elv_clear_ioq_charge_one_slice(ioq);
+
+	/*
 	 * We don't want to charge more than allocated slice otherwise this
 	 * queue can miss one dispatch round doubling max latencies. On the
 	 * other hand we don't want to charge less than allocated slice as
@@ -2143,6 +2156,37 @@ void elv_reset_request_ioq(struct request_queue *q, struct request *rq)
 	}
 }
 
+static inline int is_only_root_group(void)
+{
+	if (list_empty(&io_root_cgroup.css.cgroup->children))
+		return 1;
+
+	return 0;
+}
+
+/*
+ * One can do some optimizations for single ioq scheduler, when one does
+ * not have to expire the queue after every time slice is used. This avoids
+ * some unnecessary overhead, especially in AS where we wait for requests to
+ * finish from last queue before new queue is scheduled in.
+ */
+static inline int single_ioq_no_timed_expiry(struct request_queue *q)
+{
+	struct elv_fq_data *efqd = q->elevator->efqd;
+	struct io_queue *ioq = elv_active_ioq(q->elevator);
+
+	if (!elv_iosched_single_ioq(q->elevator))
+		return 0;
+
+	if (!is_only_root_group())
+		return 0;
+
+	if (efqd->busy_queues == 1 && ioq == efqd->root_group->ioq)
+		return 1;
+
+	return 0;
+}
+
 #else /* CONFIG_GROUP_IOSCHED */
 
 static inline unsigned int iog_weight(struct io_group *iog) { return 0; }
@@ -2188,6 +2232,17 @@ int elv_iog_should_idle(struct io_queue *ioq) { return 0; }
 EXPORT_SYMBOL(elv_iog_should_idle);
 static int elv_ioq_should_wait_busy(struct io_queue *ioq) { return 0; }
 
+static inline int is_only_root_group(void)
+{
+	return 1;
+}
+
+/* Never expire the single ioq in flat mode */
+static inline int single_ioq_no_timed_expiry(struct request_queue *q)
+{
+	return 1;
+};
+
 #endif /* CONFIG_GROUP_IOSCHED */
 
 /*
@@ -2794,6 +2849,16 @@ void *elv_select_ioq(struct request_queue *q, int force)
 		goto expire;
 	}
 
+	/*
+	 * If there is only root group present, don't expire the queue for
+	 * single queue ioschedulers (noop, deadline, AS).
+	 */
+
+	if (single_ioq_no_timed_expiry(q)) {
+		elv_mark_ioq_charge_one_slice(ioq);
+		goto keep_queue;
+	}
+
 	/* We are waiting for this group to become busy before it expires.*/
 	if (elv_iog_wait_busy(iog)) {
 		ioq = NULL;
@@ -3015,6 +3080,16 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
 			elv_clear_ioq_slice_new(ioq);
 		}
 
+		/*
+		 * If there is only root group present, don't expire the queue
+		 * for single queue ioschedulers (noop, deadline, AS). It is
+		 * unnecessary overhead.
+		 */
+		if (single_ioq_no_timed_expiry(q)) {
+			elv_mark_ioq_charge_one_slice(ioq);
+			elv_log_ioq(efqd, ioq, "single ioq no timed expiry");
+			goto done;
+		}
 
 		/*
 		 * If there are no requests waiting in this queue, and
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index e60ceed..4114543 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -242,6 +242,8 @@ enum elv_queue_state_flags {
 	ELV_QUEUE_FLAG_slice_new,	  /* no requests dispatched in slice */
 	ELV_QUEUE_FLAG_sync,              /* synchronous queue */
 	ELV_QUEUE_FLAG_must_expire,       /* expire queue even slice is left */
+	ELV_QUEUE_FLAG_charge_one_slice,  /* Charge the queue for only one
+					   * time slice length */
 };
 
 #define ELV_IO_QUEUE_FLAG_FNS(name)					\
@@ -265,6 +267,7 @@ ELV_IO_QUEUE_FLAG_FNS(idle_window)
 ELV_IO_QUEUE_FLAG_FNS(slice_new)
 ELV_IO_QUEUE_FLAG_FNS(sync)
 ELV_IO_QUEUE_FLAG_FNS(must_expire)
+ELV_IO_QUEUE_FLAG_FNS(charge_one_slice)
 
 #ifdef CONFIG_GROUP_IOSCHED
 
-- 
1.6.0.6

