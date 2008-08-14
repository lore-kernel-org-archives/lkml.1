Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbYHNJE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbYHNJE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbYHNJDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:03:40 -0400
Received: from lemon.ertos.nicta.com.au ([203.143.174.143]:40750 "EHLO
	lemon.gelato.unsw.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269AbYHNJDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:03:39 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] deadline-iosched: allow non-sequential batching
Date: Thu, 14 Aug 2008 18:17:13 +1000
Message-Id: <1218701835-17327-2-git-send-email-aaronc@gelato.unsw.edu.au>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218701835-17327-1-git-send-email-aaronc@gelato.unsw.edu.au>
References: <1218701835-17327-1-git-send-email-aaronc@gelato.unsw.edu.au>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 203.143.161.65
X-SA-Exim-Mail-From: aaronc@gelato.unsw.edu.au
X-SA-Exim-Scanned: No (on lemon.gelato.unsw.edu.au); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deadline currently only batches sector-contiguous requests, so except
for a few circumstances (e.g. requests in a single direction), it is
essentially first come first served.  This is bad for throughput, so
change it to CSCAN, which means requests in a batch do not need to be
sequential and are issued in increasing sector order.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 block/deadline-iosched.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 342448c..07b80e4 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -258,17 +258,9 @@ static int deadline_dispatch_requests(struct request_queue *q, int force)
 	else
 		rq = dd->next_rq[READ];
 
-	if (rq) {
-		/* we have a "next request" */
-		
-		if (dd->last_sector != rq->sector)
-			/* end the batch on a non sequential request */
-			dd->batching += dd->fifo_batch;
-		
-		if (dd->batching < dd->fifo_batch)
-			/* we are still entitled to batch */
-			goto dispatch_request;
-	}
+	if (rq && dd->batching < dd->fifo_batch)
+		/* we have a next request are still entitled to batch */
+		goto dispatch_request;
 
 	/*
 	 * at this point we are not running a batch. select the appropriate
-- 
1.5.4.5

