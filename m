Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbZKZQKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbZKZQKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbZKZQKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:10:48 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60110 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbZKZQKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:10:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=LPPjyjL0uYT6TBOwRiQNa3w41Ar1EM5JFYK9bmmFEaaPhzS/svzHbbxC4hE5aC0WcW
         3f3XVrjaV2iQONmrltV0JTEzNeVooq+vXd8/dZ7DNJ1COr8LTn1EYtH+68qeBnTsQ5mG
         O2KLHi/kVp2wJ2hV8vImVOg6amNKmbna7sJ2o=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>, mel@csn.ul.ie, efault@gmx.de
Subject: [RFC,PATCH] cfq-iosched: improve async queue ramp up formula
Date: Thu, 26 Nov 2009 17:10:39 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911261710.40719.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduction of ramp-up formula for async queue depths has
slowed down dirty page reclaim, by reducing async write performance.
This patch improves the formula by considering the remaining slice.

The new formula will allow more dispatches at the beginning of the
slice, reducing them at the end.
This will ensure that we achieve good throughput, without the risk of
overrunning the allotted timeslice.

The threshold is automatically increased when sync I/O is not
intermingled with async, in accordance with the previous incarnation of
the formula.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a5de31f..799782d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1633,12 +1633,24 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * based on the last sync IO we serviced
 	 */
 	if (!cfq_cfqq_sync(cfqq) && cfqd->cfq_latency) {
-		unsigned long last_sync = jiffies - cfqd->last_end_sync_rq;
-		unsigned int depth;
-
-		depth = last_sync / cfqd->cfq_slice[1];
-		if (!depth && !cfqq->dispatched)
-			depth = 1;
+		unsigned long now = jiffies;
+		unsigned long last_sync = now - cfqd->last_end_sync_rq;
+		unsigned int depth = 1;
+		if (cfqq->slice_end > now) {
+			unsigned int num,den;
+			/*
+			 * (cfqq->slice_end - now) / cfqd->cfq_slice_idle
+			 * approximates the number of requests that can be
+			 * dispatched before our slice ends
+			 * last_sync/cfq_slice[1] gives a boost when no
+			 * concurrent sync activity is expected
+			 */
+			num = last_sync          * (cfqq->slice_end - now);
+			den = cfqd->cfq_slice[1] * cfqd->cfq_slice_idle;
+			if (!den)
+				den++;
+			depth += num / den;
+		}
 		if (depth < max_dispatch)
 			max_dispatch = depth;
 	}
-- 
1.6.2.5


