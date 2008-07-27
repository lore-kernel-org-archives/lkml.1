Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbYG0S6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbYG0S6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 14:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758907AbYG0S6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 14:58:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:8298 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758852AbYG0S6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 14:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=QL6+dgREOeWX9v9akLTHbNdhbHbBVp0I8b8Y2eHtVnehJhsc96DObq9YuUS83ra/Ek
         PO0577gL3wnwN9Q9GwPpWcdR5KWAMDFl09d3XXBGy4Wmqaztnk4WpG7RDzb4jH3Y5tFk
         SAlGT8Ytn3JpwrEgnkvyFLxcp3eBvQ3a9sf8I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Elias Oltmanns <eo@nebensachen.de>
Date: Sun, 27 Jul 2008 20:56:17 +0200
Message-Id: <20080727185617.4660.7668.sendpatchset@localhost.localdomain>
In-Reply-To: <20080727185602.4660.66530.sendpatchset@localhost.localdomain>
References: <20080727185602.4660.66530.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/3] ide: preparations for /proc/ide/hd*/settings rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After rework settings will be no longer created dynamically
for each device so we need to make some fixups first.

* Use set_[ksettings,unmaskirq]() as a set function for
  ["keepsettings","unmaskirq"] setting.

* Allow writes to ["io_32bit","unmaskirq"] settings also when
  drive->no_[io_32bit,unmask] is set (this is checked later inside
  set_[io_32bit,unmaskirq]() anywyay and keeps consistency with
  the corresponding HDIO_SET_[32BIT,UNMASKINTR] ioctls).

* Use max possible multi sectors value (16) as an allowed max for
  "multcount" setting.  set_multcount() set function checks against
  device's max possbile value anyway and it makes the proc setting
  consistent with the corresponding HDIO_SET_MULTCOUNT ioctl.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |    3 +--
 drivers/ide/ide-proc.c |    6 +++---
 drivers/ide/ide.c      |    4 ++--
 include/linux/ide.h    |    2 ++
 4 files changed, 8 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -767,8 +767,7 @@ static void idedisk_add_settings(ide_dri
 			&drive->bios_sect, NULL);
 	ide_add_setting(drive, "address", SETTING_RW, TYPE_BYTE, 0, 2, 1, 1,
 			&drive->addressing, set_lba_addressing);
-	ide_add_setting(drive, "multcount", SETTING_RW, TYPE_BYTE, 0,
-			drive->id[ATA_ID_MAX_MULTSECT] & 0xff, 1, 1,
+	ide_add_setting(drive, "multcount", SETTING_RW, TYPE_BYTE, 0, 16, 1, 1,
 			&drive->mult_count, set_multcount);
 	ide_add_setting(drive, "nowerr", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
 			&drive->nowerr, set_nowerr);
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -368,11 +368,11 @@ void ide_add_generic_settings (ide_drive
 /*
  *			  drive		setting name		read/write access				data type	min	max				mul_factor	div_factor	data pointer			set function
  */
-	__ide_add_setting(drive,	"io_32bit",		drive->no_io_32bit ? SETTING_READ : SETTING_RW,	TYPE_BYTE,	0,	1 + (SUPPORT_VLB_SYNC << 1),	1,		1,		&drive->io_32bit,		set_io_32bit,	0);
-	__ide_add_setting(drive,	"keepsettings",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->keep_settings,		NULL,		0);
+	__ide_add_setting(drive,	"io_32bit",		SETTING_RW,					TYPE_BYTE,	0,	1 + (SUPPORT_VLB_SYNC << 1),	1,		1,		&drive->io_32bit,		set_io_32bit,	0);
+	__ide_add_setting(drive,	"keepsettings",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->keep_settings,		set_ksettings,	0);
 	__ide_add_setting(drive,	"nice1",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->nice1,			NULL,		0);
 	__ide_add_setting(drive,	"pio_mode",		SETTING_WRITE,					TYPE_BYTE,	0,	255,				1,		1,		NULL,				set_pio_mode,	0);
-	__ide_add_setting(drive,	"unmaskirq",		drive->no_unmask ? SETTING_READ : SETTING_RW,	TYPE_BYTE,	0,	1,				1,		1,		&drive->unmask,			NULL,		0);
+	__ide_add_setting(drive,	"unmaskirq",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->unmask,			set_unmaskirq,	0);
 	__ide_add_setting(drive,	"using_dma",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->using_dma,		set_using_dma,	0);
 	__ide_add_setting(drive,	"init_speed",		SETTING_RW,					TYPE_BYTE,	0,	70,				1,		1,		&drive->init_speed,		NULL,		0);
 	__ide_add_setting(drive,	"current_speed",	SETTING_RW,					TYPE_BYTE,	0,	70,				1,		1,		&drive->current_speed,		set_xfer_rate,	0);
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -305,7 +305,7 @@ int set_io_32bit(ide_drive_t *drive, int
 	return 0;
 }
 
-static int set_ksettings(ide_drive_t *drive, int arg)
+int set_ksettings(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 1)
 		return -EINVAL;
@@ -394,7 +394,7 @@ int set_pio_mode(ide_drive_t *drive, int
 	return 0;
 }
 
-static int set_unmaskirq(ide_drive_t *drive, int arg)
+int set_unmaskirq(ide_drive_t *drive, int arg)
 {
 	if (drive->no_unmask)
 		return -EPERM;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -697,7 +697,9 @@ typedef struct ide_driver_s ide_driver_t
 extern struct mutex ide_setting_mtx;
 
 int set_io_32bit(ide_drive_t *, int);
+int set_ksettings(ide_drive_t *, int);
 int set_pio_mode(ide_drive_t *, int);
+int set_unmaskirq(ide_drive_t *, int);
 int set_using_dma(ide_drive_t *, int);
 
 /* ATAPI packet command flags */
