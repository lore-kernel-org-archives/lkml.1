Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZBARuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZBARuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZBARsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:48:40 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:6833 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbZBARsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:48:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=FkwAMXI1vQzEufCx+F+4MC7Sz86im1t/ngLIKL9Ie/0zs6VBYpCpZU1gJWI0DufwW+
         DtJlxH4rIC3Rz1hIIqMVEoHiWjdlPEss3Anj0lE21eEE8CjF+Z3pSLRrrWIp3vs6bGbb
         OC0+U+k1PpL894Q6VICI7g2JxUbdmQXR9rXhk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:49:30 +0100
Message-Id: <20090201174930.19144.68338.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/15] ide: fix memleak on failure in probe_for_drive()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix memleak on failure in probe_for_drive()

Always free drive->id in probe_for_drive() if device is not present.

While at it:
- remove dead IDE_DFLAG_DEAD flag
- remove superfluous IDE_DFLAG_PRESENT check

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   22 +++++++++-------------
 include/linux/ide.h     |    2 --
 2 files changed, 9 insertions(+), 15 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -228,15 +228,9 @@ static void do_identify(ide_drive_t *dri
 	m[ATA_ID_PROD_LEN - 1] = '\0';
 
 	if (strstr(m, "E X A B Y T E N E S T"))
-		goto err_misc;
-
-	drive->dev_flags |= IDE_DFLAG_PRESENT;
-	drive->dev_flags &= ~IDE_DFLAG_DEAD;
-
-	return;
-err_misc:
-	kfree(id);
-	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
+		drive->dev_flags &= ~IDE_DFLAG_PRESENT;
+	else
+		drive->dev_flags |= IDE_DFLAG_PRESENT;
 }
 
 /**
@@ -505,8 +499,7 @@ static u8 probe_for_drive(ide_drive_t *d
 		}
 
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			/* drive not found */
-			return 0;
+			goto out_free;
 
 		/* identification failed? */
 		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
@@ -530,7 +523,7 @@ static u8 probe_for_drive(ide_drive_t *d
 	}
 
 	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-		return 0;
+		goto out_free;
 
 	/* The drive wasn't being helpful. Add generic info only */
 	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
@@ -543,7 +536,10 @@ static u8 probe_for_drive(ide_drive_t *d
 		ide_disk_init_mult_count(drive);
 	}
 
-	return !!(drive->dev_flags & IDE_DFLAG_PRESENT);
+	return 1;
+out_free:
+	kfree(drive->id);
+	return 0;
 }
 
 static void hwif_release_dev(struct device *dev)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -494,8 +494,6 @@ enum {
 	IDE_DFLAG_NICE1			= (1 << 5),
 	/* device is physically present */
 	IDE_DFLAG_PRESENT		= (1 << 6),
-	/* device ejected hint */
-	IDE_DFLAG_DEAD			= (1 << 7),
 	/* id read from device (synthetic if not set) */
 	IDE_DFLAG_ID_READ		= (1 << 8),
 	IDE_DFLAG_NOPROBE		= (1 << 9),
