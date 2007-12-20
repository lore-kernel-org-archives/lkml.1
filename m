Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbXLTBlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbXLTBlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759061AbXLTBfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:12451 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303AbXLTBeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ec+pnWhIKuPbfYDpmqV7TiHfGBE1hSR3e2142vV+XmRkfkUNwM50SjGcHicd67nBd0PatMrv7Cc73I1vh/4xERFZ5T7lqjM9W/uynf0s7Jvokdk8aOK2nShvqXJB0wLLD7Az78ABc+BVv1QW6USQayGSjeIXjfbxMpNQDak5Bpc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 20/63] ide-cd: remove needless zeroing of 'info' fields from ide_cdrom_setup()
Date: Thu, 20 Dec 2007 02:08:20 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712200208.20568.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ide_cd_probe() zeroes 'info' prior to calling ide_cdrom_setup() so there
is no need to explicitly zero 'info' fields in the latter function.

Ditto for fields of CDROM_STATE_FLAGS(), CDROM_CONFIG_FLAGS() and 'cdi'
(all are embedded in 'info').

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-254 bytes
 drivers/ide/ide-cd.c |   44 +++++++-------------------------------------
 1 file changed, 7 insertions(+), 37 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2844,30 +2844,16 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	drive->special.all	= 0;
 
 	CDROM_STATE_FLAGS(drive)->media_changed = 1;
-	CDROM_STATE_FLAGS(drive)->toc_valid     = 0;
-	CDROM_STATE_FLAGS(drive)->door_locked   = 0;
 
 #if NO_DOOR_LOCKING
 	CDROM_CONFIG_FLAGS(drive)->no_doorlock = 1;
-#else
-	CDROM_CONFIG_FLAGS(drive)->no_doorlock = 0;
 #endif
-
-	CDROM_CONFIG_FLAGS(drive)->drq_interrupt = ((drive->id->config & 0x0060) == 0x20);
-	CDROM_CONFIG_FLAGS(drive)->is_changer = 0;
-	CDROM_CONFIG_FLAGS(drive)->cd_r = 0;
-	CDROM_CONFIG_FLAGS(drive)->cd_rw = 0;
-	CDROM_CONFIG_FLAGS(drive)->test_write = 0;
-	CDROM_CONFIG_FLAGS(drive)->dvd = 0;
-	CDROM_CONFIG_FLAGS(drive)->dvd_r = 0;
-	CDROM_CONFIG_FLAGS(drive)->dvd_ram = 0;
+	if ((drive->id->config & 0x0060) == 0x20)
+		CDROM_CONFIG_FLAGS(drive)->drq_interrupt = 1;
 	CDROM_CONFIG_FLAGS(drive)->no_eject = 1;
-	CDROM_CONFIG_FLAGS(drive)->supp_disc_present = 0;
-	CDROM_CONFIG_FLAGS(drive)->audio_play = 0;
 	CDROM_CONFIG_FLAGS(drive)->close_tray = 1;
-	
+
 	/* limit transfer size per interrupt. */
-	CDROM_CONFIG_FLAGS(drive)->limit_nframes = 0;
 	/* a testament to the nice quality of Samsung drives... */
 	if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-2430"))
 		CDROM_CONFIG_FLAGS(drive)->limit_nframes = 1;
@@ -2878,16 +2864,6 @@ int ide_cdrom_setup (ide_drive_t *drive)
 		CDROM_CONFIG_FLAGS(drive)->no_speed_select = 1;
 
 #if ! STANDARD_ATAPI
-	/* by default Sanyo 3 CD changer support is turned off and
-           ATAPI Rev 2.2+ standard support for CD changers is used */
-	cdi->sanyo_slot = 0;
-
-	CDROM_CONFIG_FLAGS(drive)->nec260 = 0;
-	CDROM_CONFIG_FLAGS(drive)->toctracks_as_bcd = 0;
-	CDROM_CONFIG_FLAGS(drive)->tocaddr_as_bcd = 0;
-	CDROM_CONFIG_FLAGS(drive)->playmsf_as_bcd = 0;
-	CDROM_CONFIG_FLAGS(drive)->subchan_as_bcd = 0;
-
 	if (strcmp (drive->id->model, "V003S0DS") == 0 &&
 	    drive->id->fw_rev[4] == '1' &&
 	    drive->id->fw_rev[6] <= '2') {
@@ -2921,8 +2897,10 @@ int ide_cdrom_setup (ide_drive_t *drive)
 		CDROM_CONFIG_FLAGS(drive)->playmsf_as_bcd = 1;
 		CDROM_CONFIG_FLAGS(drive)->subchan_as_bcd = 1;
 	}
-        /* Sanyo 3 CD changer uses a non-standard command
-           for CD changing */
+	/*
+	 * Sanyo 3 CD changer uses a non-standard command for CD changing
+	 * (by default standard ATAPI support for CD changers is used).
+	 */
         else if ((strcmp(drive->id->model, "CD-ROM CDR-C3 G") == 0) ||
                  (strcmp(drive->id->model, "CD-ROM CDR-C3G") == 0) ||
                  (strcmp(drive->id->model, "CD-ROM CDR_C36") == 0)) {
@@ -2931,14 +2909,6 @@ int ide_cdrom_setup (ide_drive_t *drive)
         }
 #endif /* not STANDARD_ATAPI */
 
-	info->toc		= NULL;
-	info->buffer		= NULL;
-	info->sector_buffered	= 0;
-	info->nsectors_buffered	= 0;
-	info->changer_info      = NULL;
-	info->last_block	= 0;
-	info->start_seek	= 0;
-
 	nslots = ide_cdrom_probe_capabilities (drive);
 
 	/*
