Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0CABuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 20:50:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:2044 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab0CABuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 20:50:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,557,1262592000"; 
   d="scan'208";a="496464621"
Date: Mon, 1 Mar 2010 09:50:47 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, czoccolo@gmail.com, vgoyal@redhat.com,
       jmoyer@redhat.com, guijianfeng@cn.fujitsu.com
Subject: [PATCH] cfq-iosched: quantum check tweak --resend
Message-ID: <20100301015047.GA16630@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a queue can only dispatch up to 4 requests if there are other queues.
This isn't optimal, device can handle more requests, for example, AHCI can
handle 31 requests. I can understand the limit is for fairness, but we could
do a tweak: if the queue still has a lot of slice left, sounds we could
ignore the limit. Test shows this boost my workload (two thread randread of
a SSD) from 78m/s to 100m/s.
Thanks for suggestions from Corrado and Vivek for the patch.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f27e535..0db07d7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -19,7 +19,7 @@
  * tunables
  */
 /* max queue in one round of service */
-static const int cfq_quantum = 4;
+static const int cfq_quantum = 8;
 static const int cfq_fifo_expire[2] = { HZ / 4, HZ / 8 };
 /* maximum backwards seek, in KiB */
 static const int cfq_back_max = 16 * 1024;
@@ -2197,6 +2197,19 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	return dispatched;
 }
 
+static inline bool cfq_slice_used_soon(struct cfq_data *cfqd,
+	struct cfq_queue *cfqq)
+{
+	/* the queue hasn't finished any request, can't estimate */
+	if (cfq_cfqq_slice_new(cfqq))
+		return 1;
+	if (time_after(jiffies + cfqd->cfq_slice_idle * cfqq->dispatched,
+		cfqq->slice_end))
+		return 1;
+
+	return 0;
+}
+
 static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	unsigned int max_dispatch;
@@ -2213,7 +2226,7 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	if (cfqd->rq_in_flight[BLK_RW_SYNC] && !cfq_cfqq_sync(cfqq))
 		return false;
 
-	max_dispatch = cfqd->cfq_quantum;
+	max_dispatch = max_t(unsigned int, cfqd->cfq_quantum / 2, 1);
 	if (cfq_class_idle(cfqq))
 		max_dispatch = 1;
 
@@ -2230,13 +2243,22 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		/*
 		 * We have other queues, don't allow more IO from this one
 		 */
-		if (cfqd->busy_queues > 1)
+		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
 			return false;
 
 		/*
 		 * Sole queue user, no limit
 		 */
-		max_dispatch = -1;
+		if (cfqd->busy_queues == 1)
+			max_dispatch = -1;
+		else
+			/*
+			 * Normally we start throttling cfqq when cfq_quantum/2
+			 * requests have been dispatched. But we can drive
+			 * deeper queue depths at the beginning of slice
+			 * subjected to upper limit of cfq_quantum.
+			 * */
+			max_dispatch = cfqd->cfq_quantum;
 	}
 
 	/*
-- 
1.6.3.3

