Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbZCMFIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbZCMFIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbZCMFFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:05:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:44935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955AbZCMFFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:05:14 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
       =?utf-8?q?J=C3=B6rg=20Dorchain?= <joerg@dorchain.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 14/14] block: clean up unnecessary stuff from block drivers
Date: Fri, 13 Mar 2009 14:02:58 +0900
Message-Id: <1236920578-2179-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236920578-2179-1-git-send-email-tj@kernel.org>
References: <1236920578-2179-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 05:03:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

rq_data_dir() can only be READ or WRITE and rq->sector and nr_sectors
are always automatically updated after partial request completion.
Don't worry about rq_data_dir() not being either READ or WRITE or
manually update sector and nr_sectors.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jörg Dorchain <joerg@dorchain.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/amiflop.c |    7 -------
 drivers/block/ataflop.c |    4 ----
 drivers/block/xd.c      |    9 ++-------
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 163750e..72ee010 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1371,11 +1371,6 @@ static void redo_fd_request(void)
 		       "0x%08lx\n", track, sector, data);
 #endif
 
-		if ((rq_data_dir(CURRENT) != READ) && (rq_data_dir(CURRENT) != WRITE)) {
-			printk(KERN_WARNING "do_fd_request: unknown command\n");
-			__blk_end_request_all(CURRENT, -EIO);
-			goto repeat;
-		}
 		if (get_track(drive, track) == -1) {
 			__blk_end_request_all(CURRENT, -EIO);
 			goto repeat;
@@ -1407,8 +1402,6 @@ static void redo_fd_request(void)
 			break;
 		}
 	}
-	CURRENT->nr_sectors -= CURRENT->current_nr_sectors;
-	CURRENT->sector += CURRENT->current_nr_sectors;
 
 	__blk_end_request_all(CURRENT, 0);
 	goto repeat;
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index c9844f0..d19c9d6 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -732,8 +732,6 @@ static void do_fd_action( int drive )
 		    }
 		    else {
 			/* all sectors finished */
-			CURRENT->nr_sectors -= CURRENT->current_nr_sectors;
-			CURRENT->sector += CURRENT->current_nr_sectors;
 			__blk_end_request_all(CURRENT, 0);
 			redo_fd_request();
 			return;
@@ -1139,8 +1137,6 @@ static void fd_rwsec_done1(int status)
 	}
 	else {
 		/* all sectors finished */
-		CURRENT->nr_sectors -= CURRENT->current_nr_sectors;
-		CURRENT->sector += CURRENT->current_nr_sectors;
 		__blk_end_request_all(CURRENT, 0);
 		redo_fd_request();
 	}
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 291ddc3..85d8ef3 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -308,7 +308,6 @@ static void do_xd_request (struct request_queue * q)
 	while ((req = elv_next_request(q)) != NULL) {
 		unsigned block = req->sector;
 		unsigned count = req->nr_sectors;
-		int rw = rq_data_dir(req);
 		XD_INFO *disk = req->rq_disk->private_data;
 		int res = 0;
 		int retry;
@@ -321,13 +320,9 @@ static void do_xd_request (struct request_queue * q)
 			__blk_end_request_all(req, -EIO);
 			continue;
 		}
-		if (rw != READ && rw != WRITE) {
-			printk("do_xd_request: unknown request\n");
-			__blk_end_request_all(req, -EIO);
-			continue;
-		}
 		for (retry = 0; (retry < XD_RETRIES) && !res; retry++)
-			res = xd_readwrite(rw, disk, req->buffer, block, count);
+			res = xd_readwrite(rq_data_dir(req), disk, req->buffer,
+					   block, count);
 		/* wrap up, 0 = success, -errno = fail */
 		__blk_end_request_all(req, res);
 	}
-- 
1.6.0.2

