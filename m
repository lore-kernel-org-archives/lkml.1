Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbYCVVwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbYCVVwj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758078AbYCVVvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:51:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:4232 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060AbYCVVvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AwOYy/ErzPRwi71yYMcMPHDEwyban9Ca+HKf8fg9ViAzIgUq7gEHWs0h3CPmj7/pcZHa+iHQMW/QldfYdyNhfGGLdN/RCR1kFw1MIriY/U7uCRD/i4hHVot5Vr4PF7ws6O1kqOzU1BnRNNBodfikApFhhFCi5KUO29eKMbv87Ko=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 22 Mar 2008 23:06:46 +0100
Message-Id: <20080322220646.17636.51978.sendpatchset@localhost.localdomain>
In-Reply-To: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
References: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/8] ide: remove obsoleted "hdx=autotune" kernel parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove obsoleted "hdx=autotune" kernel parameter
  (we always auto-tune PIO if possible nowadays).

* Remove no longer needed ide_drive_t.autotune flag.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt |    7 -------
 drivers/ide/ide-probe.c   |    4 +---
 drivers/ide/ide.c         |    5 +----
 include/linux/ide.h       |    1 -
 4 files changed, 2 insertions(+), 15 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -196,13 +196,6 @@ Summary of ide driver parameters for ker
 
  "hdx=cyl,head,sect"	: disk drive is present, with specified geometry
 
- "hdx=autotune"		: driver will attempt to tune interface speed
-			  to the fastest PIO mode supported,
-			  if possible for this drive only.
-			  Not fully supported by all chipset types,
-			  and quite likely to cause trouble with
-			  older/odd IDE drives.
-
  "hdx=nodma"		: disallow DMA
 
  "ide=doubler"		: probe/support IDE doublers on Amiga
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -826,8 +826,7 @@ static void ide_port_tune_devices(ide_hw
 		ide_drive_t *drive = &hwif->drives[unit];
 
 		if (drive->present) {
-			if (drive->autotune)
-				ide_set_max_pio(drive);
+			ide_set_max_pio(drive);
 
 			drive->nice1 = 1;
 
@@ -1324,7 +1323,6 @@ static void ide_port_init_devices(ide_hw
 			drive->unmask = 1;
 		if (hwif->host_flags & IDE_HFLAG_NO_UNMASK_IRQS)
 			drive->no_unmask = 1;
-		drive->autotune = 1;
 	}
 
 	if (port_ops && port_ops->port_init_devs)
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -851,7 +851,7 @@ static int __init ide_setup(char *s)
 	if (s[0] == 'h' && s[1] == 'd' && s[2] >= 'a' && s[2] <= max_drive) {
 		const char *hd_words[] = {
 			"none", "noprobe", "nowerr", "cdrom", "nodma",
-			"autotune", "-7", "-8", "-9", "-10",
+			"-6", "-7", "-8", "-9", "-10",
 			"noflush", "remap", "remap63", "scsi", NULL };
 		unit = s[2] - 'a';
 		hw   = unit / MAX_DRIVES;
@@ -879,9 +879,6 @@ static int __init ide_setup(char *s)
 			case -5: /* nodma */
 				drive->nodma = 1;
 				goto done;
-			case -6: /* "autotune" */
-				drive->autotune = 1;
-				goto obsolete_option;
 			case -11: /* noflush */
 				drive->noflush = 1;
 				goto done;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -322,7 +322,6 @@ typedef struct ide_drive_s {
 	unsigned atapi_overlap	: 1;	/* ATAPI overlap (not supported) */
 	unsigned doorlocking	: 1;	/* for removable only: door lock/unlock works */
 	unsigned nodma		: 1;	/* disallow DMA */
-	unsigned autotune	: 1;	/* 0=default, 1=autotune */
 	unsigned remap_0_to_1	: 1;	/* 0=noremap, 1=remap 0->1 (for EZDrive) */
 	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
 	unsigned vdma		: 1;	/* 1=doing PIO over DMA 0=doing normal DMA */
