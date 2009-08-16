Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbZHPTeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbZHPTeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932350AbZHPTce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:32:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35840 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346AbZHPTcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:32:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       vgoyal@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
       jmarchan@redhat.com
Subject: [PATCH 12/24] io-controller: Wait for requests to complete from last queue before new queue is scheduled
Date: Sun, 16 Aug 2009 15:30:34 -0400
Message-Id: <1250451046-9966-13-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Currently one can dispatch requests from multiple queues to the disk. This
  is true for hardware which supports queuing. So if a disk support queue
  depth of 31 it is possible that 20 requests are dispatched from queue 1
  and then next queue is scheduled in which dispatches more requests.

o This multiple queue dispatch introduces issues for accurate accounting of
  disk time consumed by a particular queue. For example, if one async queue
  is scheduled in, it can dispatch 31 requests to the disk and then it will
  be expired and a new sync queue might get scheduled in. These 31 requests
  might take a long time to finish but this time is never accounted to the
  async queue which dispatched these requests.

o This patch introduces the functionality where we wait for all the requests
  to finish from previous queue before next queue is scheduled in. That way
  a queue is more accurately accounted for disk time it has consumed. Note
  this still does not take care of errors introduced by disk write caching.

o Because above behavior can result in reduced throughput, this behavior will
  be enabled only if user sets "fairness" tunable to 1.

o This patch helps in achieving more isolation between reads and buffered
  writes in different cgroups. buffered writes typically utilize full queue
  depth and then expire the queue. On the contarary, sequential reads
  typicaly driver queue depth of 1. So despite the fact that writes are
  using more disk time it is never accounted to write queue because we don't
  wait for requests to finish after dispatching these. This patch helps
  do more accurate accounting of disk time, especially for buffered writes
  hence providing better fairness hence better isolation between two cgroups
  running read and write workloads.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    1 +
 block/elevator-fq.c |   19 +++++++++++++++++++
 block/elevator-fq.h |   10 +++++++++-
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 11ae473..52c4710 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2123,6 +2123,7 @@ static struct elv_fs_entry cfq_attrs[] = {
 	ELV_ATTR(slice_async),
 #ifdef CONFIG_GROUP_IOSCHED
 	ELV_ATTR(group_idle),
+	ELV_ATTR(fairness),
 #endif
 	__ATTR_NULL
 };
diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 09377d0..b1b7dc8 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -677,6 +677,8 @@ SHOW_FUNCTION(elv_slice_sync_show, efqd->elv_slice[1], 1);
 EXPORT_SYMBOL(elv_slice_sync_show);
 SHOW_FUNCTION(elv_slice_async_show, efqd->elv_slice[0], 1);
 EXPORT_SYMBOL(elv_slice_async_show);
+SHOW_FUNCTION(elv_fairness_show, efqd->fairness, 0);
+EXPORT_SYMBOL(elv_fairness_show);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -701,6 +703,8 @@ STORE_FUNCTION(elv_slice_sync_store, &efqd->elv_slice[1], 1, UINT_MAX, 1);
 EXPORT_SYMBOL(elv_slice_sync_store);
 STORE_FUNCTION(elv_slice_async_store, &efqd->elv_slice[0], 1, UINT_MAX, 1);
 EXPORT_SYMBOL(elv_slice_async_store);
+STORE_FUNCTION(elv_fairness_store, &efqd->fairness, 0, 1, 0);
+EXPORT_SYMBOL(elv_fairness_store);
 #undef STORE_FUNCTION
 
 void elv_schedule_dispatch(struct request_queue *q)
@@ -2260,6 +2264,17 @@ void *elv_select_ioq(struct request_queue *q, int force)
 	}
 
 expire:
+	if (efqd->fairness && !force && ioq && ioq->dispatched) {
+		/*
+		 * If there are request dispatched from this queue, don't
+		 * dispatch requests from new queue till all the requests from
+		 * this queue have completed.
+		 */
+		elv_log_ioq(efqd, ioq, "select: wait for requests to finish"
+				" disp=%lu", ioq->dispatched);
+		ioq = NULL;
+		goto keep_queue;
+	}
 	elv_slice_expired(q);
 new_queue:
 	ioq = elv_set_active_ioq(q, new_ioq);
@@ -2375,6 +2390,10 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
 				goto done;
 			}
 
+			/* Wait for requests to finish from this queue */
+			if (efqd->fairness && ioq->dispatched)
+				goto done;
+
 			/* Expire the queue */
 			elv_slice_expired(q);
 			goto done;
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index 5f2cb8b..9b9ebf4 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -179,6 +179,12 @@ struct elv_fq_data {
 
 	/* Fallback dummy ioq for extreme OOM conditions */
 	struct io_queue oom_ioq;
+
+	/*
+	 * If set to 1, waits for all request completions from current
+	 * queue before new queue is scheduled in
+	 */
+	unsigned int fairness;
 };
 
 /* Logging facilities. */
@@ -436,7 +442,9 @@ extern ssize_t elv_slice_sync_store(struct elevator_queue *q, const char *name,
 extern ssize_t elv_slice_async_show(struct elevator_queue *q, char *name);
 extern ssize_t elv_slice_async_store(struct elevator_queue *q, const char *name,
 						size_t count);
-
+extern ssize_t elv_fairness_show(struct elevator_queue *q, char *name);
+extern ssize_t elv_fairness_store(struct elevator_queue *q, const char *name,
+					size_t count);
 /* Functions used by elevator.c */
 extern struct elv_fq_data *elv_alloc_fq_data(struct request_queue *q,
 					struct elevator_queue *e);
-- 
1.6.0.6

