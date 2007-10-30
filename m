Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbXJ3ENZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbXJ3ENZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXJ3ENQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:13:16 -0400
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:60931 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbXJ3ENP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:13:15 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2007 00:13:15 EDT
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 30 Oct 2007 15:06:44 +1100
X-Spam-Score: 0.001
X-CSE-Spam-Checker-Version: SpamAssassin 3.1.3 (2006-06-01) on 
	note.orchestra.cse.unsw.EDU.AU
X-CSE-Spam-Level: 
X-CSE-Spam-Status: No, score=-2.6 required=4.0 tests=BAYES_00,UNPARSEABLE_RELAY 
	autolearn=ham version=3.1.3
Message-ID: <4726ADD4.7030805@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: [PATCH 3/3] Deadline iosched: Fix batching fairness
References: <4726AD03.2080908@gelato.unsw.edu.au>
In-Reply-To: <4726AD03.2080908@gelato.unsw.edu.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After switching data directions, deadline always starts the next batch
from the lowest-sector request.  This gives excessive deadline expiries
and large latency and throughput disparity between high- and low-sector
requests; an order of magnitude in some tests.

This patch changes the batching behaviour so new batches start from the
request whose expiry is earliest.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 block/deadline-iosched.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index cb94c83..a054eef 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -306,27 +306,20 @@ dispatch_writes:
 dispatch_find_request:
 	/*
 	 * we are not running a batch, find best request for selected data_dir
-	 * and start a new batch
 	 */
-	if (deadline_check_fifo(dd, data_dir)) {
-		/* An expired request exists - satisfy it */
+	if (deadline_check_fifo(dd, data_dir) || !dd->next_rq[data_dir]) {
+		/*
+		 * A deadline has expired, the last request was in the other
+		 * direction, or we have run out of higher-sectored requests.
+		 * Start again from the request with the earliest expiry time.
+		 */
 		rq = rq_entry_fifo(dd->fifo_list[data_dir].next);
-	} else if (dd->next_rq[data_dir]) {
+	} else {
 		/*
 		 * The last req was the same dir and we have a next request in
 		 * sort order. No expired requests so continue on from here.
 		 */
 		rq = dd->next_rq[data_dir];
-	} else {
-		struct rb_node *node;
-		/*
-		 * The last req was the other direction or we have run out of
-		 * higher-sectored requests. Go back to the lowest sectored
-		 * request (1 way elevator) and start a new batch.
-		 */
-		node = rb_first(&dd->sort_list[data_dir]);
-		if (node)
-			rq = rb_entry_rq(node);
 	}
 
 	dd->batching = 0;
