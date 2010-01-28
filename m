Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962Ab0A1Pq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0A1Pq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752Ab0A1PqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:46:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:61828 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab0A1PqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:46:14 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] Flush block device before reset
Date: Thu, 28 Jan 2010 21:13:38 +0530
Message-Id: <1264693423-2694-3-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
References: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we flush block device before freeing all metadata
during reset ioctl.

Signed-off-by: Nitin Gupta <ngupta@vflar.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index 05273c0..3567ee3 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -1000,6 +1000,9 @@ static void reset_device(struct ramzswap *rzs)
 	unsigned entries_per_page;
 	unsigned long num_table_pages, entry = 0;
 
+	/* Do not accept any new I/O request */
+	rzs->init_done = 0;
+
 	if (rzs->backing_swap && !rzs->num_extents)
 		is_backing_blkdev = 1;
 
@@ -1073,9 +1076,6 @@ static void reset_device(struct ramzswap *rzs)
 
 	rzs->disksize = 0;
 	rzs->memlimit = 0;
-
-	/* Back to uninitialized state */
-	rzs->init_done = 0;
 }
 
 static int ramzswap_ioctl_init_device(struct ramzswap *rzs)
@@ -1276,6 +1276,11 @@ static int ramzswap_ioctl(struct block_device *bdev, fmode_t mode,
 			ret = -EBUSY;
 			goto out;
 		}
+
+		/* Make sure all pending I/O is finished */
+		if (bdev)
+			fsync_bdev(bdev);
+
 		ret = ramzswap_ioctl_reset_device(rzs);
 		break;
 
-- 
1.6.2.5

