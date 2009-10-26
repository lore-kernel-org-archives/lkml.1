Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZJZJQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZJZJQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 05:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZJZJQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 05:16:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:29872 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbZJZJQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 05:16:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,625,1249282800"; 
   d="scan'208";a="507479610"
Date: Mon, 26 Oct 2009 17:16:24 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com
Subject: [RFC]cfq-iosched: improve hw_tag detection
Message-ID: <20091026091624.GA1169@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If active queue hasn't enough requests and idle window opens, cfq will not
dispatch sufficient requests to hardware. In such situation, current code
will zero hw_tag. But this is because cfq doesn't dispatch enough requests
instead of hardware queue doesn't work. Don't zero hw_tag in such case.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 069a610..0467049 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2166,6 +2166,8 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
  */
 static void cfq_update_hw_tag(struct cfq_data *cfqd)
 {
+	struct cfq_queue *cfqq = cfqd->active_queue;
+
 	if (rq_in_driver(cfqd) > cfqd->rq_in_driver_peak)
 		cfqd->rq_in_driver_peak = rq_in_driver(cfqd);
 
@@ -2173,6 +2175,16 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
 	    rq_in_driver(cfqd) <= CFQ_HW_QUEUE_MIN)
 		return;
 
+	/*
+	 * If active queue hasn't enough requests and can idle, cfq might not
+	 * dispatch sufficient requests to hardware. Don't zero hw_tag in this
+	 * case
+	 */
+	if (cfqq && cfq_cfqq_idle_window(cfqq) &&
+	    cfqq->dispatched + cfqq->queued[0] + cfqq->queued[1] <
+	    CFQ_HW_QUEUE_MIN && rq_in_driver(cfqd) < CFQ_HW_QUEUE_MIN)
+		return;
+
 	if (cfqd->hw_tag_samples++ < 50)
 		return;
 
