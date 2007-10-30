Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbXJ3EF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbXJ3EF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbXJ3EFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:05:18 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:45246 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbXJ3EFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:05:16 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 30 Oct 2007 15:05:02 +1100
X-Spam-Score: 0.001
X-CSE-Spam-Checker-Version: SpamAssassin 3.1.3 (2006-06-01) on 
	note.orchestra.cse.unsw.EDU.AU
X-CSE-Spam-Level: 
X-CSE-Spam-Status: No, score=-2.6 required=4.0 tests=BAYES_00,UNPARSEABLE_RELAY 
	autolearn=ham version=3.1.3
Message-ID: <4726AD6E.8020509@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: [PATCH 1/3] Deadline iosched: Factor out finding latter request
References: <4726AD03.2080908@gelato.unsw.edu.au>
In-Reply-To: <4726AD03.2080908@gelato.unsw.edu.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Factor finding the next request in sector-sorted order into
a function deadline_latter_request.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 block/deadline-iosched.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 1a511ff..a44437e 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -55,6 +55,20 @@ static void deadline_move_request(struct deadline_data *, struct request *);
 
 #define RQ_RB_ROOT(dd, rq)	(&(dd)->sort_list[rq_data_dir((rq))])
 
+/*
+ * get the request after `rq' in sector-sorted order
+ */
+static inline struct request *
+deadline_latter_request(struct request *rq)
+{
+	struct rb_node *node = rb_next(&rq->rb_node);
+
+	if (node)
+		return rb_entry_rq(node);
+
+	return NULL;
+}
+
 static void
 deadline_add_rq_rb(struct deadline_data *dd, struct request *rq)
 {
@@ -74,13 +88,8 @@ deadline_del_rq_rb(struct deadline_data *dd, struct request *rq)
 {
 	const int data_dir = rq_data_dir(rq);
 
-	if (dd->next_rq[data_dir] == rq) {
-		struct rb_node *rbnext = rb_next(&rq->rb_node);
-
-		dd->next_rq[data_dir] = NULL;
-		if (rbnext)
-			dd->next_rq[data_dir] = rb_entry_rq(rbnext);
-	}
+	if (dd->next_rq[data_dir] == rq)
+		dd->next_rq[data_dir] = deadline_latter_request(rq);
 
 	elv_rb_del(RQ_RB_ROOT(dd, rq), rq);
 }
@@ -198,14 +207,11 @@ static void
 deadline_move_request(struct deadline_data *dd, struct request *rq)
 {
 	const int data_dir = rq_data_dir(rq);
-	struct rb_node *rbnext = rb_next(&rq->rb_node);
 
 	dd->next_rq[READ] = NULL;
 	dd->next_rq[WRITE] = NULL;
+	dd->next_rq[data_dir] = deadline_latter_request(rq);
 
-	if (rbnext)
-		dd->next_rq[data_dir] = rb_entry_rq(rbnext);
-	
 	dd->last_sector = rq->sector + rq->nr_sectors;
 
 	/*
