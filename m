Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbYHMV1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbYHMV1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYHMV0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:26:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:18786 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYHMV0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=XniXueODd+omSKBU39ZOyleWYAmtZuc1IdHzcBMOzNsamoIXwYOeSytZ4M5vAolkQe
         QeuzD6ij7uBKqDoDVC92iez67JEmEfEa+XGWHyfesO6za0iVAHl/h64LTe5uMNuOlDuM
         ly2561X2soOpsR87rK5QCBSPhrqcMIp8WeMBk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove unnecessary MAX_HWIFS checks from ide-probe.c
Date: Wed, 13 Aug 2008 23:23:50 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808132323.50671.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX_HWIFS is now always equal to the number of IDE major numbers.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -847,7 +847,6 @@ static void ide_port_tune_devices(ide_hw
 	}
 }
 
-#if MAX_HWIFS > 1
 /*
  * save_match() is used to simplify logic in init_irq() below.
  *
@@ -872,7 +871,6 @@ static void save_match(ide_hwif_t *hwif,
 	if (!m || m->irq != hwif->irq) /* don't undo a prior perfect match */
 		*match = new;
 }
-#endif /* MAX_HWIFS > 1 */
 
 /*
  * init request queue
@@ -1029,7 +1027,7 @@ static int init_irq (ide_hwif_t *hwif)
 
 	mutex_lock(&ide_cfg_mtx);
 	hwif->hwgroup = NULL;
-#if MAX_HWIFS > 1
+
 	/*
 	 * Group up with any other hwifs that share our irq(s).
 	 */
@@ -1054,7 +1052,7 @@ static int init_irq (ide_hwif_t *hwif)
 			}
 		}
 	}
-#endif /* MAX_HWIFS > 1 */
+
 	/*
 	 * If we are still without a hwgroup, then form a new one
 	 */
@@ -1513,19 +1511,14 @@ static int ide_find_port_slot(const stru
 	 * ports 0x1f0/0x170 (the ide0/ide1 defaults).
 	 */
 	mutex_lock(&ide_cfg_mtx);
-	if (MAX_HWIFS == 1) {
-		if (ide_indexes == 0 && i == 0)
-			idx = 1;
+	if (bootable) {
+		if ((ide_indexes | i) != (1 << MAX_HWIFS) - 1)
+			idx = ffz(ide_indexes | i);
 	} else {
-		if (bootable) {
-			if ((ide_indexes | i) != (1 << MAX_HWIFS) - 1)
-				idx = ffz(ide_indexes | i);
-		} else {
-			if ((ide_indexes | 3) != (1 << MAX_HWIFS) - 1)
-				idx = ffz(ide_indexes | 3);
-			else if ((ide_indexes & 3) != 3)
-				idx = ffz(ide_indexes);
-		}
+		if ((ide_indexes | 3) != (1 << MAX_HWIFS) - 1)
+			idx = ffz(ide_indexes | 3);
+		else if ((ide_indexes & 3) != 3)
+			idx = ffz(ide_indexes);
 	}
 	if (idx >= 0)
 		ide_indexes |= (1 << idx);
