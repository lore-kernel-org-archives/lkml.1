Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353Ab0A0O0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0A0O0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317Ab0A0O0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:26:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45085 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0A0O0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:26:30 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] flush block device before reset
Date: Wed, 27 Jan 2010 19:54:05 +0530
Message-Id: <1264602246-12880-3-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1264602246-12880-1-git-send-email-ngupta@vflare.org>
References: <1264602246-12880-1-git-send-email-ngupta@vflare.org>
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
index 0a376c2..64f49c9 100644
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

