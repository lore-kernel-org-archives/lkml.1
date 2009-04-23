Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZDWM1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZDWM1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZDWM1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:27:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:38549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbZDWM1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:27:20 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/12] amiflop,ataflop,xd,mg_disk: clean up unnecessary stuff from block drivers
Date: Thu, 23 Apr 2009 21:25:44 +0900
Message-Id: <1240489553-15724-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240489553-15724-1-git-send-email-tj@kernel.org>
References: <1240489553-15724-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 12:26:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq_data_dir() can only be READ or WRITE and rq->sector and nr_sectors
are always automatically updated after partial request completion.
Don't worry about rq_data_dir() not being either READ or WRITE or
manually update sector and nr_sectors.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jörg Dorchain <joerg@dorchain.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: unsik Kim <donari75@gmail.com>
---
 drivers/block/amiflop.c |    7 -------
 drivers/block/ataflop.c |    4 ----
 drivers/block/mg_disk.c |   10 ----------
 drivers/block/xd.c      |    9 ++-------
 4 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index b99a2a6..8ff95f2 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1371,11 +1371,6 @@ static void redo_fd_request(void)
 		       "0x%08lx\n", track, sector, data);
 #endif
 
-		if ((rq_data_dir(CURRENT) != READ) && (rq_data_dir(CURRENT) != WRITE)) {
-			printk(KERN_WARNING "do_fd_request: unknown command\n");
-			__blk_end_request_cur(CURRENT, -EIO);
-			goto repeat;
-		}
 		if (get_track(drive, track) == -1) {
 			__blk_end_request_cur(CURRENT, -EIO);
 			goto repeat;
@@ -1407,8 +1402,6 @@ static void redo_fd_request(void)
 			break;
 		}
 	}
-	CURRENT->nr_sectors -= CURRENT->current_nr_sectors;
-	CURRENT->sector += CURRENT->current_nr_sectors;
 
 	__blk_end_request_cur(CURRENT, 0);
 	goto repeat;
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 44a8702..2506728 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -732,8 +732,6 @@ static void do_fd_action( int drive )
 		    }
 		    else {
 			/* all sectors finished */
-			CURRENT->nr_sectors -= CURRENT->current_nr_sectors;
-			CURRENT->sector += CURRENT->current_nr_sectors;
 			__blk_end_request_cur(CURRENT, 0);
 			redo_fd_request();
 			return;
@@ -1139,8 +1137,6 @@ static void fd_rwsec_done1(int status)
 	}
 	else {
 		/* all sectors finished */
-		CURRENT->nr_sectors -= CURRENT->current_nr_sectors;
-		CURRENT->sector += CURRENT->current_nr_sectors;
 		__blk_end_request_cur(CURRENT, 0);
 		redo_fd_request();
 	}
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 62acb2e..9d16e2a 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -560,11 +560,6 @@ static void mg_request_poll(struct request_queue *q)
 			case WRITE:
 				mg_write(req);
 				break;
-			default:
-				printk(KERN_WARNING "%s:%d unknown command\n",
-						__func__, __LINE__);
-				__blk_end_request_cur(req, -EIO);
-				break;
 			}
 		}
 	}
@@ -614,11 +609,6 @@ static unsigned int mg_issue_req(struct request *req,
 		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
 		break;
-	default:
-		printk(KERN_WARNING "%s:%d unknown command\n",
-				__func__, __LINE__);
-		__blk_end_request_cur(req, -EIO);
-		break;
 	}
 	return MG_ERR_NONE;
 }
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 6f6ad82..14be4c1 100644
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
 			__blk_end_request_cur(req, -EIO);
 			continue;
 		}
-		if (rw != READ && rw != WRITE) {
-			printk("do_xd_request: unknown request\n");
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
 		for (retry = 0; (retry < XD_RETRIES) && !res; retry++)
-			res = xd_readwrite(rw, disk, req->buffer, block, count);
+			res = xd_readwrite(rq_data_dir(req), disk, req->buffer,
+					   block, count);
 		/* wrap up, 0 = success, -errno = fail */
 		__blk_end_request_cur(req, res);
 	}
-- 
1.6.0.2

