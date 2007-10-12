Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbXJLGR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbXJLGR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXJLGRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:17:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45402 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbXJLGRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:17:49 -0400
Date: Fri, 12 Oct 2007 07:17:47 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] more bio fallout
Message-ID: <20071012061747.GZ8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 2473e2a..a2da76b 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -169,7 +169,6 @@ static void end_bio_io_page(struct bio *bio, int error)
 	else
 		printk(KERN_WARNING "gfs2: error %d reading superblock\n", error);
 	unlock_page(page);
-	return 0;
 }
 
 static void gfs2_sb_in(struct gfs2_sb_host *sb, const void *buf)
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 3429fa7..bbc588d 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2162,7 +2162,7 @@ static void lbmStartIO(struct lbuf * bp)
 	/* check if journaling to disk has been disabled */
 	if (log->no_integrity) {
 		bio->bi_size = 0;
-		lbmIODone(bio, 0, 0);
+		lbmIODone(bio, 0);
 	} else {
 		submit_bio(WRITE_SYNC, bio);
 		INCREMENT(lmStat.submitted);
@@ -2234,8 +2234,6 @@ static void lbmIODone(struct bio *bio, int error)
 
 		/* wakeup I/O initiator */
 		LCACHE_WAKEUP(&bp->l_ioevent);
-
-		return 0;
 	}
 
 	/*
@@ -2260,7 +2258,6 @@ static void lbmIODone(struct bio *bio, int error)
 	if (bp->l_flag & lbmDIRECT) {
 		LCACHE_WAKEUP(&bp->l_ioevent);
 		LCACHE_UNLOCK(flags);
-		return 0;
 	}
 
 	tail = log->wqueue;
@@ -2339,8 +2336,6 @@ static void lbmIODone(struct bio *bio, int error)
 
 		LCACHE_UNLOCK(flags);	/* unlock+enable */
 	}
-
-	return 0;
 }
 
 int jfsIOWait(void *arg)
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 1332adc..941369c 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -291,8 +291,6 @@ static void metapage_read_end_io(struct bio *bio, int err)
 
 	dec_io(page, last_read_complete);
 	bio_put(bio);
-
-	return 0;
 }
 
 static void remove_from_logsync(struct metapage *mp)
@@ -349,7 +347,6 @@ static void metapage_write_end_io(struct bio *bio, int err)
 	}
 	dec_io(page, last_write_complete);
 	bio_put(bio);
-	return 0;
 }
 
 static int metapage_writepage(struct page *page, struct writeback_control *wbc)
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index ad6626e..bdf6002 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -216,7 +216,7 @@ static void o2hb_wait_on_io(struct o2hb_region *reg,
 	wait_for_completion(&wc->wc_io_complete);
 }
 
-static int o2hb_bio_end_io(struct bio *bio,
+static void o2hb_bio_end_io(struct bio *bio,
 			   int error)
 {
 	struct o2hb_bio_wait_ctxt *wc = bio->bi_private;
@@ -228,7 +228,6 @@ static int o2hb_bio_end_io(struct bio *bio,
 
 	o2hb_bio_wait_dec(wc, 1);
 	bio_put(bio);
-	return 0;
 }
 
 /* Setup a Bio to cover I/O against num_slots slots starting at
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 3f13519..6f4c29e 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -323,7 +323,7 @@ xfs_iomap_valid(
 /*
  * BIO completion handler for buffered IO.
  */
-STATIC int
+STATIC void
 xfs_end_bio(
 	struct bio		*bio,
 	int			error)
@@ -339,7 +339,6 @@ xfs_end_bio(
 	bio_put(bio);
 
 	xfs_finish_ioend(ioend, 0);
-	return 0;
 }
 
 STATIC void
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 6a75f4d..39f44ee 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1103,7 +1103,7 @@ _xfs_buf_ioend(
 	}
 }
 
-STATIC int
+STATIC void
 xfs_buf_bio_end_io(
 	struct bio		*bio,
 	int			error)
@@ -1139,7 +1139,6 @@ xfs_buf_bio_end_io(
 
 	_xfs_buf_ioend(bp, 1);
 	bio_put(bio);
-	return 0;
 }
 
 STATIC void
