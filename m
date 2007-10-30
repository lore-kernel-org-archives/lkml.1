Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbXJ3ENi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbXJ3ENi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXJ3ENU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:13:20 -0400
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:60933 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbXJ3ENT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:13:19 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 30 Oct 2007 15:05:46 +1100
X-Spam-Score: 0.001
X-CSE-Spam-Checker-Version: SpamAssassin 3.1.3 (2006-06-01) on 
	note.orchestra.cse.unsw.EDU.AU
X-CSE-Spam-Level: 
X-CSE-Spam-Status: No, score=-2.6 required=4.0 tests=BAYES_00,UNPARSEABLE_RELAY 
	autolearn=ham version=3.1.3
Message-ID: <4726AD9A.8040707@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: [PATCH 2/3] Deadline iosched: Reset batch for ordered requests
References: <4726AD03.2080908@gelato.unsw.edu.au>
In-Reply-To: <4726AD03.2080908@gelato.unsw.edu.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The deadline I/O scheduler does not reset the batch count when starting
a new batch at a higher-sectored request.  This means the second and
subsequent batch in the same data direction will never exceed a single
request in size whenever higher-sectored requests are pending.

This patch gives new batches in the same data direction as old ones
their full quota of requests by resetting the batch count.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 block/deadline-iosched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index a44437e..cb94c83 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -306,12 +306,11 @@ dispatch_writes:
 dispatch_find_request:
 	/*
 	 * we are not running a batch, find best request for selected data_dir
+	 * and start a new batch
 	 */
 	if (deadline_check_fifo(dd, data_dir)) {
 		/* An expired request exists - satisfy it */
-		dd->batching = 0;
 		rq = rq_entry_fifo(dd->fifo_list[data_dir].next);
-		
 	} else if (dd->next_rq[data_dir]) {
 		/*
 		 * The last req was the same dir and we have a next request in
@@ -325,12 +324,13 @@ dispatch_find_request:
 		 * higher-sectored requests. Go back to the lowest sectored
 		 * request (1 way elevator) and start a new batch.
 		 */
-		dd->batching = 0;
 		node = rb_first(&dd->sort_list[data_dir]);
 		if (node)
 			rq = rb_entry_rq(node);
 	}
 
+	dd->batching = 0;
+
 dispatch_request:
 	/*
 	 * rq is the selected appropriate request.
