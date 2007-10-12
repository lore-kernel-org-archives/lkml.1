Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbXJLRTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbXJLRTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762392AbXJLRSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:18:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762194AbXJLRSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:18:36 -0400
Date: Fri, 12 Oct 2007 18:18:31 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: [2.6.24 PATCH 12/25] dm: tidy bio_io_error usage
Message-ID: <20071012171831.GX24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Milan Broz <mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

Use bio_io_error() in only two places and tidy the code,
preparing for later patches.

There is no functional change in this patch.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   37 ++++++++++++++++++-------------------
 1 files changed, 18 insertions(+), 19 deletions(-)

Index: linux-2.6.23/drivers/md/dm.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm.c	2007-10-12 13:15:35.000000000 +0100
+++ linux-2.6.23/drivers/md/dm.c	2007-10-12 13:18:04.000000000 +0100
@@ -751,15 +751,13 @@ static void __clone_and_map(struct clone
 /*
  * Split the bio into several clones.
  */
-static void __split_bio(struct mapped_device *md, struct bio *bio)
+static int __split_bio(struct mapped_device *md, struct bio *bio)
 {
 	struct clone_info ci;
 
 	ci.map = dm_get_table(md);
-	if (!ci.map) {
-		bio_io_error(bio);
-		return;
-	}
+	if (unlikely(!ci.map))
+		return -EIO;
 
 	ci.md = md;
 	ci.bio = bio;
@@ -779,6 +777,8 @@ static void __split_bio(struct mapped_de
 	/* drop the extra reference count */
 	dec_pending(ci.io, 0);
 	dm_table_put(ci.map);
+
+	return 0;
 }
 /*-----------------------------------------------------------------
  * CRUD END
@@ -790,7 +790,7 @@ static void __split_bio(struct mapped_de
  */
 static int dm_request(struct request_queue *q, struct bio *bio)
 {
-	int r;
+	int r = -EIO;
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
 
@@ -815,18 +815,11 @@ static int dm_request(struct request_que
 	while (test_bit(DMF_BLOCK_IO, &md->flags)) {
 		up_read(&md->io_lock);
 
-		if (bio_rw(bio) == READA) {
-			bio_io_error(bio);
-			return 0;
-		}
-
-		r = queue_io(md, bio);
-		if (r < 0) {
-			bio_io_error(bio);
-			return 0;
+		if (bio_rw(bio) != READA)
+			r = queue_io(md, bio);
 
-		} else if (r == 0)
-			return 0;	/* deferred successfully */
+		if (r <= 0)
+			goto out_req;
 
 		/*
 		 * We're in a while loop, because someone could suspend
@@ -835,8 +828,13 @@ static int dm_request(struct request_que
 		down_read(&md->io_lock);
 	}
 
-	__split_bio(md, bio);
+	r = __split_bio(md, bio);
 	up_read(&md->io_lock);
+
+out_req:
+	if (r < 0)
+		bio_io_error(bio);
+
 	return 0;
 }
 
@@ -1251,7 +1249,8 @@ static void __flush_deferred_io(struct m
 	while (c) {
 		n = c->bi_next;
 		c->bi_next = NULL;
-		__split_bio(md, c);
+		if (__split_bio(md, c))
+			bio_io_error(c);
 		c = n;
 	}
 }
