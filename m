Return-Path: <linux-kernel-owner+w=401wt.eu-S1760474AbXLTBlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474AbXLTBlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759089AbXLTBfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:12071 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353AbXLTBeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=mWp0G1maEB2KfRS8awXkbHUVLSrrH/TAKmhBjxuW7rj6NOoNwx+l2/hO36Zzng6uMm0ZcRZR2jmgF//yebzFWIdB715KRz9fNR//dr4gETWUO3f/j9m+UF4vw1/ISLEydlqENlgH6IeFIcVfVuPOZalWQBCS3cZr1HShAsmAAg0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 21/63] ide-cd: remove unused and write-only struct ide_cd_config_flags fields
Date: Thu, 20 Dec 2007 02:08:43 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200208.43246.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


unused fields:
* ->writing
* ->reserved

write-only fields:
* ->playmsf_as_bcd
* ->subchan_as_bcd
* ->test_write
* ->supp_disc_present

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-120 bytes
 drivers/ide/ide-cd.c |   18 ++----------------
 drivers/ide/ide-cd.h |    7 -------
 2 files changed, 2 insertions(+), 23 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2672,8 +2672,6 @@ int ide_cdrom_probe_capabilities (ide_dr
 		CDROM_CONFIG_FLAGS(drive)->cd_rw = 1;
 		CDROM_CONFIG_FLAGS(drive)->ram = 1;
 	}
-	if (cap.test_write)
-		CDROM_CONFIG_FLAGS(drive)->test_write = 1;
 	if (cap.dvd_ram_read || cap.dvd_r_read || cap.dvd_rom)
 		CDROM_CONFIG_FLAGS(drive)->dvd = 1;
 	if (cap.dvd_ram_write) {
@@ -2706,10 +2704,9 @@ int ide_cdrom_probe_capabilities (ide_dr
 #endif /* not STANDARD_ATAPI */
 	if (cap.mechtype == mechtype_individual_changer ||
 	    cap.mechtype == mechtype_cartridge_changer) {
-		if ((nslots = cdrom_number_of_slots(cdi)) > 1) {
+		nslots = cdrom_number_of_slots(cdi);
+		if (nslots > 1)
 			CDROM_CONFIG_FLAGS(drive)->is_changer = 1;
-			CDROM_CONFIG_FLAGS(drive)->supp_disc_present = 1;
-		}
 	}
 
 	ide_cdrom_update_speed(drive, &cap);
@@ -2871,10 +2868,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 		   Some versions of this drive like to talk BCD. */
 		CDROM_CONFIG_FLAGS(drive)->toctracks_as_bcd = 1;
 		CDROM_CONFIG_FLAGS(drive)->tocaddr_as_bcd = 1;
-		CDROM_CONFIG_FLAGS(drive)->playmsf_as_bcd = 1;
-		CDROM_CONFIG_FLAGS(drive)->subchan_as_bcd = 1;
 	}
-
 	else if (strcmp (drive->id->model, "V006E0DS") == 0 &&
 	    drive->id->fw_rev[4] == '1' &&
 	    drive->id->fw_rev[6] <= '2') {
@@ -2887,16 +2881,8 @@ int ide_cdrom_setup (ide_drive_t *drive)
 		   This drive was released before the 1.2 version
 		   of the spec. */
 		CDROM_CONFIG_FLAGS(drive)->tocaddr_as_bcd = 1;
-		CDROM_CONFIG_FLAGS(drive)->playmsf_as_bcd = 1;
-		CDROM_CONFIG_FLAGS(drive)->subchan_as_bcd = 1;
 		CDROM_CONFIG_FLAGS(drive)->nec260         = 1;
 	}
-	else if (strcmp(drive->id->model, "WEARNES CDD-120") == 0 &&
-		 strncmp(drive->id->fw_rev, "A1.1", 4) == 0) { /* FIXME */
-		/* Wearnes */
-		CDROM_CONFIG_FLAGS(drive)->playmsf_as_bcd = 1;
-		CDROM_CONFIG_FLAGS(drive)->subchan_as_bcd = 1;
-	}
 	/*
 	 * Sanyo 3 CD changer uses a non-standard command for CD changing
 	 * (by default standard ATAPI support for CD changers is used).
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -59,10 +59,8 @@ struct ide_cd_config_flags {
 	__u8 no_doorlock	: 1; /* Drive cannot lock the door. */
 	__u8 no_eject		: 1; /* Drive cannot eject the disc. */
 	__u8 nec260		: 1; /* Drive is a pre-1.2 NEC 260 drive. */
-	__u8 playmsf_as_bcd	: 1; /* PLAYMSF command takes BCD args. */
 	__u8 tocaddr_as_bcd	: 1; /* TOC addresses are in BCD. */
 	__u8 toctracks_as_bcd	: 1; /* TOC track numbers are in BCD. */
-	__u8 subchan_as_bcd	: 1; /* Subchannel info is in BCD. */
 	__u8 is_changer		: 1; /* Drive is a changer. */
 	__u8 cd_r		: 1; /* Drive can write to CD-R media . */
 	__u8 cd_rw		: 1; /* Drive can write to CD-R/W media . */
@@ -70,19 +68,14 @@ struct ide_cd_config_flags {
 	__u8 dvd_r		: 1; /* Drive can write DVD-R */
 	__u8 dvd_ram		: 1; /* Drive can write DVD-RAM */
 	__u8 ram		: 1; /* generic WRITE (dvd-ram/mrw) */
-	__u8 test_write		: 1; /* Drive can fake writes */
-	__u8 supp_disc_present	: 1; /* Changer can report exact contents
-					of slots. */
 	__u8 limit_nframes	: 1; /* Drive does not provide data in
 					multiples of SECTOR_SIZE when more
 					than one interrupt is needed. */
 	__u8 seeking		: 1; /* Seeking in progress */
 	__u8 audio_play		: 1; /* can do audio related commands */
 	__u8 close_tray		: 1; /* can close the tray */
-	__u8 writing		: 1; /* pseudo write in progress */
 	__u8 mo_drive		: 1; /* drive is an MO device */
 	__u8 no_speed_select	: 1; /* SET_CD_SPEED command is unsupported. */
-	__u8 reserved		: 1;
 	byte max_speed;		     /* Max speed of the drive */
 };
 #define CDROM_CONFIG_FLAGS(drive) (&(((struct cdrom_info *)(drive->driver_data))->config_flags))
