Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZKNNdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZKNNdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 08:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZKNNdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 08:33:40 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:45456 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZKNNdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 08:33:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=QrCfMg4Sx2JVKq9Rko1WdDxU3UlCLDEhpeOeldyZ33MOxFwJc64PEBh0kcEn0VGPBN
         g0tr1aMZ7D3G+vorMdButHQAOxDkqgOEZXO4Bm2B1CT/rNZ/yAZi4QDs3qlS8RDoEssQ
         OcpRLBNAhfn1i3iGa1Fmz3fuvPgMSXEBCVCMw=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq-iosched: fix ncq detection code
Date: Sat, 14 Nov 2009 14:33:40 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
Cc: Vivek Goyal <vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911141433.40440.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFQ's detection of queueing devices assumes a non-queuing device and detects
if the queue depth reaches a certain threshold.  Under some workloads (e.g.
synchronous reads), CFQ effectively forces a unit queue depth, thus defeating
the detection logic.  This leads to poor performance on queuing hardware,
since the idle window remains enabled.

Given this premise, switching to hw_tag = 0 after we have proved at
least once that the device is NCQ capable is not a good choice.

The new detection code starts in an indeterminate state, in which CFQ behaves
as if hw_tag = 1, and then, if for a long observation period we never saw
large depth, we switch to hw_tag = 0, otherwise we stick to hw_tag = 1,
without reconsidering it again.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1bcbd8c..6925ab9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -191,8 +191,14 @@ struct cfq_data {
 	 */
 	int rq_queued;
 	int hw_tag;
-	int hw_tag_samples;
-	int rq_in_driver_peak;
+	/*
+	 * hw_tag can be
+	 * -1 => indeterminate, (cfq will behave as if NCQ is present, to allow better detection)
+	 *  1 => NCQ is present (hw_tag_est_depth is the estimated max depth)
+	 *  0 => no NCQ
+	 */
+	int hw_tag_est_depth;
+	unsigned int hw_tag_samples;
 
 	/*
 	 * idle window management
@@ -2527,8 +2533,11 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 
-	if (rq_in_driver(cfqd) > cfqd->rq_in_driver_peak)
-		cfqd->rq_in_driver_peak = rq_in_driver(cfqd);
+	if (rq_in_driver(cfqd) > cfqd->hw_tag_est_depth)
+		cfqd->hw_tag_est_depth = rq_in_driver(cfqd);
+
+	if (cfqd->hw_tag == 1)
+		return;
 
 	if (cfqd->rq_queued <= CFQ_HW_QUEUE_MIN &&
 	    rq_in_driver(cfqd) <= CFQ_HW_QUEUE_MIN)
@@ -2547,13 +2556,10 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
 	if (cfqd->hw_tag_samples++ < 50)
 		return;
 
-	if (cfqd->rq_in_driver_peak >= CFQ_HW_QUEUE_MIN)
+	if (cfqd->hw_tag_est_depth >= CFQ_HW_QUEUE_MIN)
 		cfqd->hw_tag = 1;
 	else
 		cfqd->hw_tag = 0;
-
-	cfqd->hw_tag_samples = 0;
-	cfqd->rq_in_driver_peak = 0;
 }
 
 static void cfq_completed_request(struct request_queue *q, struct request *rq)
@@ -2960,7 +2966,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->cfq_latency = 1;
-	cfqd->hw_tag = 1;
+	cfqd->hw_tag = -1;
 	cfqd->last_end_sync_rq = jiffies;
 	return cfqd;
 }
-- 
1.6.2.5


