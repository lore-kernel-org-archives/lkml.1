Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbXLTBfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbXLTBfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbXLTBeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbXLTBeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WmM4ZCJZp+BmUqNd5X1MBEhvfE4wPOVgatzTW3uhxu+f4K6C2TdwUxhde/u81PAmbsDPCfBQod2yxZXZDEHbbZhWMCO1U3+4lfv/3MlTsh8hRnrS3Jhq9hwMIb43m4hyUTbw5uW70viTOfC0tC0sZCSPEVhvWzXSRJPBzrSY7DY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 01/63] ide-cd: fix SAMSUNG CD-ROM SCR-3231 quirk
Date: Thu, 20 Dec 2007 01:50:28 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200150.29036.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cdi->mask is cleared by ide_cdrom_register() which is called after the quirk.

Fix it by adding new ->no_speed_select flag to struct ide_cd_config_flags
and using it in ide_cdrom_register() to set CDC_SELECT_SPEED flag.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    5 ++++-
 drivers/ide/ide-cd.h |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2903,6 +2903,9 @@ static int ide_cdrom_register (ide_drive
 	if (!CDROM_CONFIG_FLAGS(drive)->ram)
 		devinfo->mask |= CDC_RAM;
 
+	if (CDROM_CONFIG_FLAGS(drive)->no_speed_select)
+		devinfo->mask |= CDC_SELECT_SPEED;
+
 	devinfo->disk = info->disk;
 	return register_cdrom(devinfo);
 }
@@ -3155,7 +3158,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 		CDROM_CONFIG_FLAGS(drive)->limit_nframes = 1;
 	/* the 3231 model does not support the SET_CD_SPEED command */
 	else if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-3231"))
-		cdi->mask |= CDC_SELECT_SPEED;
+		CDROM_CONFIG_FLAGS(drive)->no_speed_select = 1;
 
 #if ! STANDARD_ATAPI
 	/* by default Sanyo 3 CD changer support is turned off and
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -91,7 +91,8 @@ struct ide_cd_config_flags {
 	__u8 close_tray		: 1; /* can close the tray */
 	__u8 writing		: 1; /* pseudo write in progress */
 	__u8 mo_drive		: 1; /* drive is an MO device */
-	__u8 reserved		: 2;
+	__u8 no_speed_select	: 1; /* SET_CD_SPEED command is unsupported. */
+	__u8 reserved		: 1;
 	byte max_speed;		     /* Max speed of the drive */
 };
 #define CDROM_CONFIG_FLAGS(drive) (&(((struct cdrom_info *)(drive->driver_data))->config_flags))
