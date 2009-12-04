Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZLELBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZLELBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 06:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZLELBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 06:01:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53945 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbZLELBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 06:01:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=EIsstiqHXsJerMjcAGmjd8G2sCnLERM9u+kgmTyd44qL45E1MtEg9EF8yt8N8WeVOu
         otGmyPwXoo0uEJ5UViHnCjvIR3GtBE+FIJH8AcgsLfmDXUWLPEkq1dHOibHDDnE+Ip6Z
         YkGGPwcua8uQdMj7qtiFstPUjNLkZwoY6pU4Q=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
Date: Fri, 4 Dec 2009 13:35:05 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.29.6-desktop586-2mnb; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduction of ramp-up formula for async queue depths has
slowed down dirty page reclaim, by reducing async write performance.
This patch makes sure the formula kicks in only when sync request
was recently delayed.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b00ca4c..a594388 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -284,7 +284,7 @@ struct cfq_data {
 	 */
 	struct cfq_queue oom_cfqq;
 
-	unsigned long last_end_sync_rq;
+	unsigned long last_delayed_sync;
 
 	/* List of cfq groups being managed on this device*/
 	struct hlist_head cfqg_list;
@@ -2264,7 +2264,7 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, 
struct cfq_queue *cfqq)
 	 * based on the last sync IO we serviced
 	 */
 	if (!cfq_cfqq_sync(cfqq) && cfqd->cfq_latency) {
-		unsigned long last_sync = jiffies - cfqd->last_end_sync_rq;
+		unsigned long last_sync = jiffies - cfqd->last_delayed_sync;
 		unsigned int depth;
 
 		depth = last_sync / cfqd->cfq_slice[1];
@@ -3272,7 +3272,8 @@ static void cfq_completed_request(struct request_queue 
*q, struct request *rq)
 
 	if (sync) {
 		RQ_CIC(rq)->last_end_request = now;
-		cfqd->last_end_sync_rq = now;
+		if (time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
+			cfqd->last_delayed_sync = now;
 	}
 
 	/*
@@ -3706,7 +3707,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_latency = 1;
 	cfqd->cfq_group_isolation = 0;
 	cfqd->hw_tag = -1;
-	cfqd->last_end_sync_rq = jiffies;
+	cfqd->last_delayed_sync = jiffies - HZ;
 	return cfqd;
 }
 
-- 
1.6.2.5



