Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbXLTBz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbXLTBz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbXLTBha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11733 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726AbXLTBej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=iv/+WOkZ1AGQdNj48HugJm7PylXBt7yhmAowTpxlNn14j3ByXTrsN8/t05Y2f+s4TsMix3XeTid4NyBmk2kyN3xviyUd7E3vyyWdaeVgQWXlcEHBrU/8sM4Z0Sbql0poVgV3CjPTveg8AvtrT/m16he6+nU85Vkjjm292Zn086c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 33/63] ide-cd: re-organize handling of quirky devices
Date: Thu, 20 Dec 2007 02:18:42 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200218.42462.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Re-organize handling of quirky devices:

* Add struct cd_list_entry, ide_cd_quirks_list[] and ide_cd_flags() helper.

* Set flags returned by ide_cd_flags() in ide_cdrom_setup().

* Add IDE_CD_FLAG_VERTOS_{300_SSD,600_ESD} and IDE_CD_FLAG_SANYO_3CD flags.

* Move device quirks from ide_cdrom_setup() to ide_cd_quirks_list[].

* Rename IDE_CD_FLAG_NEC260 to IDE_CD_FLAG_PRE_ATAPI12 and handle
  quirky Stingray 8X CD-ROM using ide_cd_quirks_list[].

* Add IDE_CD_FLAG_FULL_CAPS_PAGE flag and handle quirky ACER 50X CD-ROM
  / WPI 32X CD-ROM using ide_cd_quirk_list[].

* Add IDE_CD_FLAG_PLAY_AUDIO_OK flag and handle quirky MATSHITA DVD-ROMs
  using ide_cd_quirks_list[].

* Add IDE_CD_FLAG_LE_SPEED_FIELDS flag and handle quirky ACER/AOpen 24X
  CD-ROM using ide_cd_quirk_list[].

* Fix some comments about quirky devices while at it.

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |  138 ++++++++++++++++++++++++++++-----------------------
 drivers/ide/ide-cd.h |   10 ++-
 2 files changed, 84 insertions(+), 64 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2356,12 +2356,7 @@ static int ide_cdrom_get_capabilities(id
 	struct packet_command cgc;
 	int stat, attempts = 3, size = ATAPI_CAPABILITIES_PAGE_SIZE;
 
-	/*
-	 * ACER50 (and others?) require the full spec length mode sense
-	 * page capabilities size, but older drives break.
-	 */
-	if (!(!strcmp(drive->id->model, "ATAPI CD ROM DRIVE 50X MAX") ||
-	    !strcmp(drive->id->model, "WPI CDS-32X")))
+	if ((info->cd_flags & IDE_CD_FLAG_FULL_CAPS_PAGE) == 0)
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
 
 	init_cdrom_command(&cgc, buf, size, CGC_DATA_UNKNOWN);
@@ -2381,9 +2376,7 @@ static void ide_cdrom_update_speed(ide_d
 	curspeed = *(u16 *)&buf[8 +  8];
 	maxspeed = *(u16 *)&buf[8 + 14];
 
-	/* The ACER/AOpen 24X cdrom has the speed fields byte-swapped */
-	if (!drive->id->model[0] &&
-	    !strncmp(drive->id->fw_rev, "241N", 4)) {
+	if (cd->cd_flags & IDE_CD_FLAG_LE_SPEED_FIELDS) {
 		curspeed = le16_to_cpu(curspeed);
 		maxspeed = le16_to_cpu(maxspeed);
 	} else {
@@ -2606,8 +2599,7 @@ int ide_cdrom_probe_capabilities (ide_dr
 		return nslots;
 	}
 
-	if ((cd->cd_flags & IDE_CD_FLAG_NEC260) ||
-	    !strcmp(drive->id->model,"STINGRAY 8422 IDE 8X CD-ROM 7-27-95")) {
+	if (cd->cd_flags & IDE_CD_FLAG_PRE_ATAPI12) {
 		cd->cd_flags &= ~IDE_CD_FLAG_NO_EJECT;
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 		return nslots;
@@ -2640,22 +2632,13 @@ int ide_cdrom_probe_capabilities (ide_dr
 		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
 	if (buf[8 + 3] & 0x10)
 		cdi->mask &= ~CDC_DVD_R;
-	if (buf[8 + 4] & 0x01)
+	if ((buf[8 + 4] & 0x01) || (cd->cd_flags & IDE_CD_FLAG_PLAY_AUDIO_OK))
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 
 	mechtype = buf[8 + 6] >> 5;
 	if (mechtype == mechtype_caddy || mechtype == mechtype_popup)
 		cdi->mask |= CDC_CLOSE_TRAY;
 
-	/* Some drives used by Apple don't advertise audio play
-	 * but they do support reading TOC & audio datas
-	 */
-	if (strcmp(drive->id->model, "MATSHITADVD-ROM SR-8187") == 0 ||
-	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8186") == 0 ||
-	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8176") == 0 ||
-	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8174") == 0)
-		cdi->mask &= ~CDC_PLAY_AUDIO;
-
 	if (cdi->sanyo_slot > 0) {
 		cdi->mask &= ~CDC_SELECT_DISC;
 		nslots = 3;
@@ -2784,11 +2767,74 @@ static int ide_cdrom_prep_fn(struct requ
 	return 0;
 }
 
+struct cd_list_entry {
+	const char	*id_model;
+	const char	*id_firmware;
+	unsigned int	cd_flags;
+};
+
+static const struct cd_list_entry ide_cd_quirks_list[] = {
+	/* Limit transfer size per interrupt. */
+	{ "SAMSUNG CD-ROM SCR-2430", NULL,   IDE_CD_FLAG_LIMIT_NFRAMES	    },
+	{ "SAMSUNG CD-ROM SCR-2432", NULL,   IDE_CD_FLAG_LIMIT_NFRAMES	    },
+	/* SCR-3231 doesn't support the SET_CD_SPEED command. */
+	{ "SAMSUNG CD-ROM SCR-3231", NULL,   IDE_CD_FLAG_NO_SPEED_SELECT    },
+	/* Old NEC260 (not R) was released before ATAPI 1.2 spec. */
+	{ "NEC CD-ROM DRIVE:260",    "1.01", IDE_CD_FLAG_TOCADDR_AS_BCD |
+					     IDE_CD_FLAG_PRE_ATAPI12,	    },
+	/* Vertos 300, some versions of this drive like to talk BCD. */
+	{ "V003S0DS",		     NULL,   IDE_CD_FLAG_VERTOS_300_SSD,    },
+	/* Vertos 600 ESD. */
+	{ "V006E0DS",		     NULL,   IDE_CD_FLAG_VERTOS_600_ESD,    },
+	/*
+	 * Sanyo 3 CD changer uses a non-standard command for CD changing
+	 * (by default standard ATAPI support for CD changers is used).
+	 */
+	{ "CD-ROM CDR-C3 G",	     NULL,   IDE_CD_FLAG_SANYO_3CD	    },
+	{ "CD-ROM CDR-C3G",	     NULL,   IDE_CD_FLAG_SANYO_3CD	    },
+	{ "CD-ROM CDR_C36",	     NULL,   IDE_CD_FLAG_SANYO_3CD	    },
+	/* Stingray 8X CD-ROM. */
+	{ "STINGRAY 8422 IDE 8X CD-ROM 7-27-95", NULL, IDE_CD_FLAG_PRE_ATAPI12},
+	/*
+	 * ACER 50X CD-ROM and WPI 32X CD-ROM require the full spec length
+	 * mode sense page capabilities size, but older drives break.
+	 */
+	{ "ATAPI CD ROM DRIVE 50X MAX",	NULL,	IDE_CD_FLAG_FULL_CAPS_PAGE  },
+	{ "WPI CDS-32X",		NULL,	IDE_CD_FLAG_FULL_CAPS_PAGE  },
+	/* ACER/AOpen 24X CD-ROM has the speed fields byte-swapped. */
+	{ "",			     "241N", IDE_CD_FLAG_LE_SPEED_FIELDS    },
+	/*
+	 * Some drives used by Apple don't advertise audio play
+	 * but they do support reading TOC & audio datas.
+	 */
+	{ "MATSHITADVD-ROM SR-8187", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
+	{ "MATSHITADVD-ROM SR-8186", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
+	{ "MATSHITADVD-ROM SR-8176", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
+	{ "MATSHITADVD-ROM SR-8174", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
+	{ NULL, NULL, 0 }
+};
+
+static unsigned int ide_cd_flags(struct hd_driveid *id)
+{
+	const struct cd_list_entry *cle = ide_cd_quirks_list;
+
+	while (cle->id_model) {
+		if (strcmp(cle->id_model, id->model) == 0 &&
+		    (cle->id_firmware == NULL ||
+		     strstr(id->fw_rev, cle->id_firmware)))
+			return cle->cd_flags;
+		cle++;
+	}
+
+	return 0;
+}
+
 static
 int ide_cdrom_setup (ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
+	struct hd_driveid *id = drive->id;
 	int nslots;
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
@@ -2799,53 +2845,21 @@ int ide_cdrom_setup (ide_drive_t *drive)
 
 	drive->special.all	= 0;
 
-	cd->cd_flags |= IDE_CD_FLAG_MEDIA_CHANGED;
+	cd->cd_flags = IDE_CD_FLAG_MEDIA_CHANGED | IDE_CD_FLAG_NO_EJECT |
+		       ide_cd_flags(id);
 
-	if ((drive->id->config & 0x0060) == 0x20)
+	if ((id->config & 0x0060) == 0x20)
 		cd->cd_flags |= IDE_CD_FLAG_DRQ_INTERRUPT;
-	cd->cd_flags |= IDE_CD_FLAG_NO_EJECT;
 
-	/* limit transfer size per interrupt. */
-	/* a testament to the nice quality of Samsung drives... */
-	if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-2430") ||
-	    !strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-2432"))
-		cd->cd_flags |= IDE_CD_FLAG_LIMIT_NFRAMES;
-	/* the 3231 model does not support the SET_CD_SPEED command */
-	else if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-3231"))
-		cd->cd_flags |= IDE_CD_FLAG_NO_SPEED_SELECT;
-
-	if (strcmp (drive->id->model, "V003S0DS") == 0 &&
-	    drive->id->fw_rev[4] == '1' &&
-	    drive->id->fw_rev[6] <= '2') {
-		/* Vertos 300.
-		   Some versions of this drive like to talk BCD. */
+	if ((cd->cd_flags & IDE_CD_FLAG_VERTOS_300_SSD) &&
+	    id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
 		cd->cd_flags |= (IDE_CD_FLAG_TOCTRACKS_AS_BCD |
 				 IDE_CD_FLAG_TOCADDR_AS_BCD);
-	}
-	else if (strcmp (drive->id->model, "V006E0DS") == 0 &&
-	    drive->id->fw_rev[4] == '1' &&
-	    drive->id->fw_rev[6] <= '2') {
-		/* Vertos 600 ESD. */
+	else if ((cd->cd_flags & IDE_CD_FLAG_VERTOS_600_ESD) &&
+		 id->fw_rev[4] == '1' && id->fw_rev[6] <= '2')
 		cd->cd_flags |= IDE_CD_FLAG_TOCTRACKS_AS_BCD;
-	}
-	else if (strcmp(drive->id->model, "NEC CD-ROM DRIVE:260") == 0 &&
-		 strncmp(drive->id->fw_rev, "1.01", 4) == 0) { /* FIXME */
-		/* Old NEC260 (not R).
-		   This drive was released before the 1.2 version
-		   of the spec. */
-		cd->cd_flags |= (IDE_CD_FLAG_TOCADDR_AS_BCD |
-				 IDE_CD_FLAG_NEC260);
-	}
-	/*
-	 * Sanyo 3 CD changer uses a non-standard command for CD changing
-	 * (by default standard ATAPI support for CD changers is used).
-	 */
-        else if ((strcmp(drive->id->model, "CD-ROM CDR-C3 G") == 0) ||
-                 (strcmp(drive->id->model, "CD-ROM CDR-C3G") == 0) ||
-                 (strcmp(drive->id->model, "CD-ROM CDR_C36") == 0)) {
-                 /* uses CD in slot 0 when value is set to 3 */
-                 cdi->sanyo_slot = 3;
-        }
+	else if (cd->cd_flags & IDE_CD_FLAG_SANYO_3CD)
+		cdi->sanyo_slot = 3;	/* 3 => use CD in slot 0 */
 
 	nslots = ide_cdrom_probe_capabilities (drive);
 
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -44,8 +44,8 @@ enum {
 	IDE_CD_FLAG_NO_DOORLOCK		= (1 << 1),
 	/* Drive cannot eject the disc. */
 	IDE_CD_FLAG_NO_EJECT		= (1 << 2),
-	/* Drive is a pre-1.2 NEC 260 drive. */
-	IDE_CD_FLAG_NEC260		= (1 << 3),
+	/* Drive is a pre ATAPI 1.2 drive. */
+	IDE_CD_FLAG_PRE_ATAPI12		= (1 << 3),
 	/* TOC addresses are in BCD. */
 	IDE_CD_FLAG_TOCADDR_AS_BCD	= (1 << 4),
 	/* TOC track numbers are in BCD. */
@@ -65,6 +65,12 @@ enum {
 	IDE_CD_FLAG_DOOR_LOCKED		= (1 << 10),
 	/* SET_CD_SPEED command is unsupported. */
 	IDE_CD_FLAG_NO_SPEED_SELECT	= (1 << 11),
+	IDE_CD_FLAG_VERTOS_300_SSD	= (1 << 12),
+	IDE_CD_FLAG_VERTOS_600_ESD	= (1 << 13),
+	IDE_CD_FLAG_SANYO_3CD		= (1 << 14),
+	IDE_CD_FLAG_FULL_CAPS_PAGE	= (1 << 15),
+	IDE_CD_FLAG_PLAY_AUDIO_OK	= (1 << 16),
+	IDE_CD_FLAG_LE_SPEED_FIELDS	= (1 << 17),
 };
 
 /* Structure of a MSF cdrom address. */
