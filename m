Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZDWMb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZDWMb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbZDWM13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:27:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:38571 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbZDWM1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:27:25 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/12] swim: clean up request completion paths
Date: Thu, 23 Apr 2009 21:25:51 +0900
Message-Id: <1240489553-15724-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240489553-15724-1-git-send-email-tj@kernel.org>
References: <1240489553-15724-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 12:26:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swim curiously tries to update request parameters before calling
__blk_end_request() when __blk_end_request() will do it anyway and
unnecessarily checks whether current_nr_sectors is zero right after
fetching.

Drop unnecessary stuff and use standard block layer mechanisms.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Laurent Vivier <Laurent@lvivier.info>
---
 drivers/block/swim.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 6544a7b..97ef426 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -535,10 +535,6 @@ static void redo_fd_request(struct request_queue *q)
 			__blk_end_request_cur(req, -EIO);
 			continue;
 		}
-		if (req->current_nr_sectors == 0) {
-			__blk_end_request_cur(req, 0);
-			continue;
-		}
 		if (!fs->disk_in) {
 			__blk_end_request_cur(req, -EIO);
 			continue;
@@ -561,9 +557,6 @@ static void redo_fd_request(struct request_queue *q)
 				__blk_end_request_cur(req, -EIO);
 				continue;
 			}
-			req->nr_sectors -= req->current_nr_sectors;
-			req->sector += req->current_nr_sectors;
-			req->buffer += req->current_nr_sectors * 512;
 			__blk_end_request_cur(req, 0);
 			break;
 		}
-- 
1.6.0.2

