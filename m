Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbZEaOfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbZEaOfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbZEaOeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:34:24 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49478 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbZEaOeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JN1iG5qRVIUkX06alHfOdQRYsrqMtqtXsocNTz61ZwV/wZKym7+yqz3s0atPrnhele
         49MO2cq6Lr+HZsrWLMFR59bYOA0X3iM5E0A3LvpPulad4TQVM2i/+WVplolySAg+w5go
         TgVte3cNFB5qbPOAhTUMDts+KyLulqrleku+Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
Date: Sun, 31 May 2009 16:39:39 +0200
Message-Id: <20090531143939.7164.82399.sendpatchset@localhost.localdomain>
In-Reply-To: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/4] ide: preserve Host Protected Area by default
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: preserve Host Protected Area by default

>From the perspective of most users of recent systems, disabling Host
Protected Area (HPA) can break vendor RAID formats, GPT partitions and
risks corrupting firmware or overwriting vendor system recovery tools.

Unfortunately the original (kernels < 2.6.30) behavior (unconditionally
disabling HPA and using full disk capacity) was introduced at the time
when the main use of HPA was to make the drive look small enough for the
BIOS to allow the system to boot with large capacity drives.

Thus to allow the maximum compatibility with the existing setups (using
HPA and partitioned with HPA disabled) we automatically disable HPA if
any partitions overlapping HPA are detected.  Additionally HPA can also
be disabled using the "nohpa" module parameter (i.e. "ide_core.nohpa=0.0"
to disable HPA on /dev/hda).

While at it:
- remove stale "idebus=" entry from Documentation/kernel-parameters.txt

Cc: Robert Hancock <hancockrwd@gmail.com>
Cc: Frans Pop <elendil@planet.nl>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
[patch description was based on input from Alan Cox and Frans Pop]
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt           |    2 ++
 Documentation/kernel-parameters.txt |    7 ++-----
 drivers/ide/ide-disk.c              |    3 +++
 drivers/ide/ide.c                   |   10 ++++++++++
 include/linux/ide.h                 |    2 ++
 5 files changed, 19 insertions(+), 5 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -216,6 +216,8 @@ Other kernel parameters for ide_core are
 
 * "noflush=[interface_number.device_number]" to disable flush requests
 
+* "nohpa=[interface_number.device_number]" to disable Host Protected Area
+
 * "noprobe=[interface_number.device_number]" to skip probing
 
 * "nowerr=[interface_number.device_number]" to ignore the WRERR_STAT bit
Index: b/Documentation/kernel-parameters.txt
===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -872,11 +872,8 @@ and is between 256 and 4096 characters. 
 
 	ide-core.nodma=	[HW] (E)IDE subsystem
 			Format: =0.0 to prevent dma on hda, =0.1 hdb =1.0 hdc
-			.vlb_clock .pci_clock .noflush .noprobe .nowerr .cdrom
-			.chs .ignore_cable are additional options
-			See Documentation/ide/ide.txt.
-
-	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
+			.vlb_clock .pci_clock .noflush .nohpa .noprobe .nowerr
+			.cdrom .chs .ignore_cable are additional options
 			See Documentation/ide/ide.txt.
 
 	ide-pci-generic.all-generic-ide [HW] (E)IDE subsystem
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -332,6 +332,9 @@ static void idedisk_check_hpa(ide_drive_
 			 capacity, sectors_to_MB(capacity),
 			 set_max, sectors_to_MB(set_max));
 
+	if ((drive->dev_flags & IDE_DFLAG_NOHPA) == 0)
+		return;
+
 	set_max = idedisk_set_max_address(drive, set_max, lba48);
 
 	if (set_max) {
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -211,6 +211,11 @@ static unsigned int ide_noflush;
 module_param_call(noflush, ide_set_dev_param_mask, NULL, &ide_noflush, 0);
 MODULE_PARM_DESC(noflush, "disable flush requests for a device");
 
+static unsigned int ide_nohpa;
+
+module_param_call(nohpa, ide_set_dev_param_mask, NULL, &ide_nohpa, 0);
+MODULE_PARM_DESC(nohpa, "disable Host Protected Area for a device");
+
 static unsigned int ide_noprobe;
 
 module_param_call(noprobe, ide_set_dev_param_mask, NULL, &ide_noprobe, 0);
@@ -281,6 +286,11 @@ static void ide_dev_apply_params(ide_dri
 				 drive->name);
 		drive->dev_flags |= IDE_DFLAG_NOFLUSH;
 	}
+	if (ide_nohpa & (1 << i)) {
+		printk(KERN_INFO "ide: disabling Host Protected Area for %s\n",
+				 drive->name);
+		drive->dev_flags |= IDE_DFLAG_NOHPA;
+	}
 	if (ide_noprobe & (1 << i)) {
 		printk(KERN_INFO "ide: skipping probe for %s\n", drive->name);
 		drive->dev_flags |= IDE_DFLAG_NOPROBE;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -459,6 +459,8 @@ enum {
 	IDE_DFLAG_NICE1			= (1 << 5),
 	/* device is physically present */
 	IDE_DFLAG_PRESENT		= (1 << 6),
+	/* disable Host Protected Area */
+	IDE_DFLAG_NOHPA			= (1 << 7),
 	/* id read from device (synthetic if not set) */
 	IDE_DFLAG_ID_READ		= (1 << 8),
 	IDE_DFLAG_NOPROBE		= (1 << 9),
