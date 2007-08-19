Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbXHSS44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbXHSS44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 14:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXHSS4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 14:56:46 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:21868 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752247AbXHSS4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 14:56:45 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: bzolnier@gmail.com
Subject: [PATCH 1/4] ide: add ide_dev_is_sata() helper
Date: Sun, 19 Aug 2007 22:59:08 +0400
User-Agent: KMail/1.5
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708192259.08171.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the SATA drive detection code from eighty_ninty_three() into inline
ide_dev_is_sata() helper fixing it along the way to be more strict while
checking word 80 for the reserved values...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
This is against the current Linus tree and unfortunately I was able to only
compile test it since that tree gives MODPOST warning and dies early on bootup.
Well, I also have no SATA drive at hand... :-)

 drivers/ide/ide-iops.c |    3 +--
 include/linux/ide.h    |   13 +++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/ide/ide-iops.c
===================================================================
--- linux-2.6.orig/drivers/ide/ide-iops.c
+++ linux-2.6/drivers/ide/ide-iops.c
@@ -580,8 +580,7 @@ u8 eighty_ninty_three (ide_drive_t *driv
 	if (hwif->cbl != ATA_CBL_PATA80)
 		goto no_80w;
 
-	/* Check for SATA but only if we are ATA5 or higher */
-	if (id->hw_config == 0 && (id->major_rev_num & 0x7FE0))
+	if (ide_dev_is_sata(id))
 		return 1;
 
 	/*
Index: linux-2.6/include/linux/ide.h
===================================================================
--- linux-2.6.orig/include/linux/ide.h
+++ linux-2.6/include/linux/ide.h
@@ -1380,6 +1380,19 @@ static inline int ide_dev_has_iordy(stru
 	return ((id->field_valid & 2) && (id->capability & 8)) ? 1 : 0;
 }
 
+static inline int ide_dev_is_sata(struct hd_driveid *id)
+{
+	/*
+	 * See if word 93 is 0 AND drive is at least ATA-5 compatible
+	 * making sure that word 80 is valid by flipping its MSB --
+	 * this trick allows us to filter out reserved values of 0
+	 * and 0xffff along with the earlier ATA revisions.
+	 */
+	if (id->hw_config == 0 && (id->major_rev_num ^ 0x8000) >= 0x8020)
+		return 1;
+	return 0;
+}
+
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
 typedef struct ide_pio_timings_s {

