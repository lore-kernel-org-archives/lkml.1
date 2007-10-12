Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbXJLEBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbXJLEBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbXJLEBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:01:23 -0400
Received: from havoc.gtf.org ([69.61.125.42]:40034 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbXJLEBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:01:22 -0400
Date: Fri, 12 Oct 2007 00:01:21 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, shaggy@austin.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] JFS: fix bio-related build breakage
Message-ID: <20071012040121.GA16274@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 57c3b8a..ccfd029 100644
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
