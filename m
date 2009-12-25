Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZLYJKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZLYJKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 04:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZLYJKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 04:10:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:2362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbZLYJKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 04:10:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,453,1257148800"; 
   d="scan'208";a="582034676"
Date: Fri, 25 Dec 2009 17:10:30 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, czoccolo@gmail.com, yanmin.zhang@intel.com
Subject: [RFC]cfq-iosched: quantum check tweak
Message-ID: <20091225091030.GA28365@sli10-desk.sh.intel.com>
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
do some tweaks:
1. if the queue still has a lot of slice left, sounds we could ignore the limit
2. we could keep the check only when cfq_latency is on. For uses who don't care
about latency should be happy to have device fully piped on.

I have a test of random direct io of two threads, each has 32 requests one time
without patch: 78m/s
with tweak 1: 138m/s
with two tweaks and disable latency: 156m/s

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c
+++ linux-2.6/block/cfq-iosched.c
@@ -2242,6 +2242,18 @@ static int cfq_forced_dispatch(struct cf
 	return dispatched;
 }
 
+static inline bool cfq_slice_used_soon(struct cfq_data *cfqd,
+	struct cfq_queue *cfqq)
+{
+	/* the queue hasn't finished any request, can't estimate */
+	if (cfq_cfqq_slice_new(cfqq))
+		return 1;
+	if (time_after(jiffies + cfqd->cfq_slice_idle, cfqq->slice_end))
+		return 1;
+
+	return 0;
+}
+
 static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	unsigned int max_dispatch;
@@ -2275,7 +2287,8 @@ static bool cfq_may_dispatch(struct cfq_
 		/*
 		 * We have other queues, don't allow more IO from this one
 		 */
-		if (cfqd->busy_queues > 1)
+		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq)
+			&& cfqd->cfq_latency)
 			return false;
 
 		/*
