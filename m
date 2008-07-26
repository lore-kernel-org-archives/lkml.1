Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbYGZNnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbYGZNnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYGZNmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:42:23 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:42093 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYGZNmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Uci+ZiSnAv5ZzK/d/rHjmk7bNid35iHhbI/KUuigImLLUHIqFqGP/iEt9MEkmbfdp4
         Eiz+MA2c0IsmDRfthIvDv+7gBLZCxLf5cXgMAgFmSaQDNTLL6IpUvE/PY3V/awDobO62
         miYKeETn9299GlOMABkXGEn/k/GtCkZaIhOkU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2008 15:40:17 +0200
Message-Id: <20080726134017.10589.12439.sendpatchset@localhost.localdomain>
In-Reply-To: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/10] ide: fix EXABYTENEST handling in probe_for_drive()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix EXABYTENEST handling in probe_for_drive() (so drive->present
is checked for "nested" device) and cleanup enable_nest().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -542,11 +542,6 @@ static void enable_nest (ide_drive_t *dr
 		printk(KERN_CONT "failed (status = 0x%02x)\n", stat);
 	else
 		printk(KERN_CONT "success\n");
-
-	/* if !(success||timed-out) */
-	if (do_probe(drive, ATA_CMD_ID_ATA) >= 2)
-		/* look for ATAPI device */
-		(void)do_probe(drive, ATA_CMD_ID_ATAPI);
 }
 
 /**
@@ -586,19 +581,22 @@ static inline u8 probe_for_drive (ide_dr
 	strcpy(m, "UNKNOWN");
 
 	/* skip probing? */
-	if (!drive->noprobe)
-	{
+	if (!drive->noprobe) {
+retry:
 		/* if !(success||timed-out) */
 		if (do_probe(drive, ATA_CMD_ID_ATA) >= 2)
 			/* look for ATAPI device */
 			(void)do_probe(drive, ATA_CMD_ID_ATAPI);
+
 		if (!drive->present)
 			/* drive not found */
 			return 0;
 
-		if (strstr(m, "E X A B Y T E N E S T"))
+		if (strstr(m, "E X A B Y T E N E S T")) {
 			enable_nest(drive);
-	
+			goto retry;
+		}
+
 		/* identification failed? */
 		if (!drive->id_read) {
 			if (drive->media == ide_disk) {
