Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbZKCXsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbZKCXsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZKCXoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZKCXoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 03/20] blkio: Introduce the notion of weights
Date: Tue,  3 Nov 2009 18:43:40 -0500
Message-Id: <1257291837-6246-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Introduce the notion of weights. Priorities are mapped to weights internally.
  These weights will be useful once IO groups are introduced and group's share
  will be decided by the group weight.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   58 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 58ac8b7..ca815ce 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -29,6 +29,10 @@ static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
 
 #define IO_IOPRIO_CLASSES	3
+#define CFQ_WEIGHT_MIN		100
+#define CFQ_WEIGHT_MAX		1000
+#define CFQ_WEIGHT_DEFAULT	500
+#define CFQ_SERVICE_SHIFT       12
 
 /*
  * offset from end of service tree
@@ -40,7 +44,7 @@ static int cfq_slice_idle = HZ / 125;
  */
 #define CFQ_MIN_TT		(2)
 
-#define CFQ_SLICE_SCALE		(5)
+#define CFQ_SLICE_SCALE		(500)
 #define CFQ_HW_QUEUE_MIN	(5)
 
 #define RQ_CIC(rq)		\
@@ -123,6 +127,7 @@ struct cfq_queue {
 	unsigned short ioprio, org_ioprio;
 	unsigned short ioprio_class, org_ioprio_class;
 	bool ioprio_class_changed;
+	unsigned int weight;
 
 	pid_t pid;
 };
@@ -266,11 +271,22 @@ cfqq_key(struct cfq_service_tree *st, struct cfq_queue *cfqq)
 }
 
 static inline u64
+cfq_delta(u64 service, unsigned int numerator_wt, unsigned int denominator_wt)
+{
+	if (numerator_wt != denominator_wt) {
+		service = service * numerator_wt;
+		do_div(service, denominator_wt);
+	}
+
+	return service;
+}
+
+static inline u64
 cfq_delta_fair(unsigned long delta, struct cfq_queue *cfqq)
 {
-	const int base_slice = cfqq->cfqd->cfq_slice[cfq_cfqq_sync(cfqq)];
+	u64 d = delta << CFQ_SERVICE_SHIFT;
 
-	return delta + (base_slice/CFQ_SLICE_SCALE * (cfqq->ioprio - 4));
+	return cfq_delta(d, CFQ_WEIGHT_DEFAULT, cfqq->weight);
 }
 
 static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
@@ -308,6 +324,23 @@ static void update_min_vdisktime(struct cfq_service_tree *st)
 	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
 }
 
+static inline unsigned int cfq_ioprio_to_weight(int ioprio)
+{
+	WARN_ON(ioprio < 0 || ioprio >= IOPRIO_BE_NR);
+	/* Map prio 7 - 0 to weights 200 to 900 */
+	return CFQ_WEIGHT_DEFAULT + (CFQ_WEIGHT_DEFAULT/5 * (4 - ioprio));
+}
+
+static inline int
+cfq_weight_slice(struct cfq_data *cfqd, int sync, unsigned int weight)
+{
+	const int base_slice = cfqd->cfq_slice[sync];
+
+	WARN_ON(weight > CFQ_WEIGHT_MAX);
+
+	return cfq_delta(base_slice, weight, CFQ_WEIGHT_DEFAULT);
+}
+
 static inline int rq_in_driver(struct cfq_data *cfqd)
 {
 	return cfqd->rq_in_driver[0] + cfqd->rq_in_driver[1];
@@ -353,25 +386,10 @@ static int cfq_queue_empty(struct request_queue *q)
 	return !cfqd->rq_queued;
 }
 
-/*
- * Scale schedule slice based on io priority. Use the sync time slice only
- * if a queue is marked sync and has sync io queued. A sync queue with async
- * io only, should not get full sync slice length.
- */
-static inline int cfq_prio_slice(struct cfq_data *cfqd, bool sync,
-				 unsigned short prio)
-{
-	const int base_slice = cfqd->cfq_slice[sync];
-
-	WARN_ON(prio >= IOPRIO_BE_NR);
-
-	return base_slice + (base_slice/CFQ_SLICE_SCALE * (4 - prio));
-}
-
 static inline int
 cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
+	return cfq_weight_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->weight);
 }
 
 static inline void
@@ -1819,6 +1837,8 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 		break;
 	}
 
+	cfqq->weight = cfq_ioprio_to_weight(cfqq->ioprio);
+
 	if (cfqq->org_ioprio_class != cfqq->ioprio_class)
 		cfqq->ioprio_class_changed = 1;
 	/*
-- 
1.6.2.5

