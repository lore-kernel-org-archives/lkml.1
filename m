Return-Path: <linux-kernel-owner+w=401wt.eu-S932144AbZKMKk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbZKMKk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932121AbZKMKkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:40:23 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:49706 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbZKMKkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:40:21 -0500
From: Li Yang <leoli@freescale.com>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Li Yang <leoli@freescale.com>, Jin Qing <b24347@freescale.com>
Subject: [PATCH] mtd/nand: fix multi-chip suspend problem
Date: Fri, 13 Nov 2009 19:22:33 +0800
Message-Id: <1258111353-21556-1-git-send-email-leoli@freescale.com>
X-Mailer: git-send-email 1.6.3.1.6.g4bf1f
X-OriginalArrivalTime: 13 Nov 2009 10:40:13.0088 (UTC) FILETIME=[AE2C5200:01CA644D]
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Symptom:
device_suspend(): mtd_cls_suspend+0x0/0x58 returns -11
PM: Device mtd14 failed to suspend: error -11
PM: Some devices failed to suspend

This patch enables other chips to be suspended if the active chip of
the controller has been suspended.

Signed-off-by: Jin Qing <b24347@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/mtd/nand/nand_base.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 2957cc7..6d2f562 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -697,10 +697,16 @@ nand_get_device(struct nand_chip *chip, struct mtd_info *mtd, int new_state)
 		spin_unlock(lock);
 		return 0;
 	}
-	if (new_state == FL_PM_SUSPENDED) {
-		spin_unlock(lock);
-		return (chip->state == FL_PM_SUSPENDED) ? 0 : -EAGAIN;
-	}
+	if (new_state == FL_PM_SUSPENDED)
+		if (chip->controller->active->state == FL_PM_SUSPENDED) {
+			chip->state = FL_PM_SUSPENDED;
+			spin_unlock(lock);
+			return 0;
+		} else {
+			spin_unlock(lock);
+			return -EAGAIN;
+		}
+
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(wq, &wait);
 	spin_unlock(lock);
-- 
1.6.3.1.6.g4bf1f

