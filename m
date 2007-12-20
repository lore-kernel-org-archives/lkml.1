Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbXLTB7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbXLTB7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759291AbXLTBh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbXLTBea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=c0HEjWw4fS5lEMufiqdhL9lSm8Ues7nLtmW0KjxQ7HjyW4uDnX0v0PTk4vnnRRgWF4ZfQZqizwJ/a9XiLG87MNBWV08RuYLiHXCqA4ahEbphUKtBMEVm3hORmf8KndRxu9zJ8OoVSXn9cWqoXovAvop1JkiTWO7pC3xyqzRv3ng=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 25/63] ide-cd: remove redundant config flags
Date: Thu, 20 Dec 2007 02:11:36 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200211.37052.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Use CDC_* flags directly and remove redundant flags from ->config_flags.

While at it:
* Add KERN_CONT to printk()-s in ide_cdrom_probe_capabilities().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-294 bytes
 drivers/ide/ide-cd.c |  102 ++++++++++++++++++++-------------------------------
 drivers/ide/ide-cd.h |   10 -----
 2 files changed, 40 insertions(+), 72 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1868,6 +1868,8 @@ cdrom_lockdoor(ide_drive_t *drive, int l
 static int cdrom_eject(ide_drive_t *drive, int ejectflag,
 		       struct request_sense *sense)
 {
+	struct cdrom_info *cd = drive->driver_data;
+	struct cdrom_device_info *cdi = &cd->devinfo;
 	struct request req;
 	char loej = 0x02;
 
@@ -1881,7 +1883,7 @@ static int cdrom_eject(ide_drive_t *driv
 	cdrom_prepare_request(drive, &req);
 
 	/* only tell drive to close tray if open, if it can do that */
-	if (ejectflag && !CDROM_CONFIG_FLAGS(drive)->close_tray)
+	if (ejectflag && (cdi->mask & CDC_CLOSE_TRAY))
 		loej = 0;
 
 	req.sense = sense;
@@ -2142,6 +2144,8 @@ static int cdrom_read_subchannel(ide_dri
 static int cdrom_select_speed(ide_drive_t *drive, int speed,
 			      struct request_sense *sense)
 {
+	struct cdrom_info *cd = drive->driver_data;
+	struct cdrom_device_info *cdi = &cd->devinfo;
 	struct request req;
 	cdrom_prepare_request(drive, &req);
 
@@ -2156,9 +2160,8 @@ static int cdrom_select_speed(ide_drive_
 	req.cmd[2] = (speed >> 8) & 0xff;	
 	/* Read Drive speed in kbytes/second LSB */
 	req.cmd[3] = speed & 0xff;
-	if (CDROM_CONFIG_FLAGS(drive)->cd_r ||
-	    CDROM_CONFIG_FLAGS(drive)->cd_rw ||
-	    CDROM_CONFIG_FLAGS(drive)->dvd_r) {
+	if ((cdi->mask & (CDC_CD_R | CDC_CD_RW | CDC_DVD_R)) !=
+	    (CDC_CD_R | CDC_CD_RW | CDC_DVD_R)) {
 		/* Write Drive speed in kbytes/second MSB */
 		req.cmd[4] = (speed >> 8) & 0xff;
 		/* Write Drive speed in kbytes/second LSB */
@@ -2588,33 +2591,10 @@ static int ide_cdrom_register (ide_drive
 	struct cdrom_device_info *devinfo = &info->devinfo;
 
 	devinfo->ops = &ide_cdrom_dops;
-	devinfo->mask = 0;
 	devinfo->speed = CDROM_STATE_FLAGS(drive)->current_speed;
 	devinfo->capacity = nslots;
 	devinfo->handle = drive;
 	strcpy(devinfo->name, drive->name);
-	
-	/* set capability mask to match the probe. */
-	if (!CDROM_CONFIG_FLAGS(drive)->cd_r)
-		devinfo->mask |= CDC_CD_R;
-	if (!CDROM_CONFIG_FLAGS(drive)->cd_rw)
-		devinfo->mask |= CDC_CD_RW;
-	if (!CDROM_CONFIG_FLAGS(drive)->dvd)
-		devinfo->mask |= CDC_DVD;
-	if (!CDROM_CONFIG_FLAGS(drive)->dvd_r)
-		devinfo->mask |= CDC_DVD_R;
-	if (!CDROM_CONFIG_FLAGS(drive)->dvd_ram)
-		devinfo->mask |= CDC_DVD_RAM;
-	if (!CDROM_CONFIG_FLAGS(drive)->is_changer)
-		devinfo->mask |= CDC_SELECT_DISC;
-	if (!CDROM_CONFIG_FLAGS(drive)->audio_play)
-		devinfo->mask |= CDC_PLAY_AUDIO;
-	if (!CDROM_CONFIG_FLAGS(drive)->close_tray)
-		devinfo->mask |= CDC_CLOSE_TRAY;
-	if (!CDROM_CONFIG_FLAGS(drive)->mo_drive)
-		devinfo->mask |= CDC_MO_DRIVE;
-	if (!CDROM_CONFIG_FLAGS(drive)->ram)
-		devinfo->mask |= CDC_RAM;
 
 	if (CDROM_CONFIG_FLAGS(drive)->no_speed_select)
 		devinfo->mask |= CDC_SELECT_SPEED;
@@ -2631,9 +2611,12 @@ int ide_cdrom_probe_capabilities (ide_dr
 	struct atapi_capabilities_page cap;
 	int nslots = 1;
 
+	cdi->mask = (CDC_CD_R | CDC_CD_RW | CDC_DVD | CDC_DVD_R |
+		     CDC_DVD_RAM | CDC_SELECT_DISC | CDC_PLAY_AUDIO |
+		     CDC_MO_DRIVE | CDC_RAM);
+
 	if (drive->media == ide_optical) {
-		CDROM_CONFIG_FLAGS(drive)->mo_drive = 1;
-		CDROM_CONFIG_FLAGS(drive)->ram = 1;
+		cdi->mask &= ~(CDC_MO_DRIVE | CDC_RAM);
 		printk(KERN_ERR "%s: ATAPI magneto-optical drive\n", drive->name);
 		return nslots;
 	}
@@ -2641,7 +2624,7 @@ int ide_cdrom_probe_capabilities (ide_dr
 	if (CDROM_CONFIG_FLAGS(drive)->nec260 ||
 	    !strcmp(drive->id->model,"STINGRAY 8422 IDE 8X CD-ROM 7-27-95")) {
 		CDROM_CONFIG_FLAGS(drive)->no_eject = 0;
-		CDROM_CONFIG_FLAGS(drive)->audio_play = 1;
+		cdi->mask &= ~CDC_PLAY_AUDIO;
 		return nslots;
 	}
 
@@ -2663,23 +2646,19 @@ int ide_cdrom_probe_capabilities (ide_dr
 	if (cap.eject)
 		CDROM_CONFIG_FLAGS(drive)->no_eject = 0;
 	if (cap.cd_r_write)
-		CDROM_CONFIG_FLAGS(drive)->cd_r = 1;
-	if (cap.cd_rw_write) {
-		CDROM_CONFIG_FLAGS(drive)->cd_rw = 1;
-		CDROM_CONFIG_FLAGS(drive)->ram = 1;
-	}
+		cdi->mask &= ~CDC_CD_R;
+	if (cap.cd_rw_write)
+		cdi->mask &= ~(CDC_CD_RW | CDC_RAM);
 	if (cap.dvd_ram_read || cap.dvd_r_read || cap.dvd_rom)
-		CDROM_CONFIG_FLAGS(drive)->dvd = 1;
-	if (cap.dvd_ram_write) {
-		CDROM_CONFIG_FLAGS(drive)->dvd_ram = 1;
-		CDROM_CONFIG_FLAGS(drive)->ram = 1;
-	}
+		cdi->mask &= ~CDC_DVD;
+	if (cap.dvd_ram_write)
+		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
 	if (cap.dvd_r_write)
-		CDROM_CONFIG_FLAGS(drive)->dvd_r = 1;
+		cdi->mask &= ~CDC_DVD_R;
 	if (cap.audio_play)
-		CDROM_CONFIG_FLAGS(drive)->audio_play = 1;
+		cdi->mask &= ~CDC_PLAY_AUDIO;
 	if (cap.mechtype == mechtype_caddy || cap.mechtype == mechtype_popup)
-		CDROM_CONFIG_FLAGS(drive)->close_tray = 0;
+		cdi->mask |= CDC_CLOSE_TRAY;
 
 	/* Some drives used by Apple don't advertise audio play
 	 * but they do support reading TOC & audio datas
@@ -2688,11 +2667,11 @@ int ide_cdrom_probe_capabilities (ide_dr
 	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8186") == 0 ||
 	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8176") == 0 ||
 	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8174") == 0)
-		CDROM_CONFIG_FLAGS(drive)->audio_play = 1;
+		cdi->mask &= ~CDC_PLAY_AUDIO;
 
 #if ! STANDARD_ATAPI
 	if (cdi->sanyo_slot > 0) {
-		CDROM_CONFIG_FLAGS(drive)->is_changer = 1;
+		cdi->mask &= ~CDC_SELECT_DISC;
 		nslots = 3;
 	}
 
@@ -2702,7 +2681,7 @@ int ide_cdrom_probe_capabilities (ide_dr
 	    cap.mechtype == mechtype_cartridge_changer) {
 		nslots = cdrom_number_of_slots(cdi);
 		if (nslots > 1)
-			CDROM_CONFIG_FLAGS(drive)->is_changer = 1;
+			cdi->mask &= ~CDC_SELECT_DISC;
 	}
 
 	ide_cdrom_update_speed(drive, &cap);
@@ -2711,22 +2690,22 @@ int ide_cdrom_probe_capabilities (ide_dr
 	printk(KERN_INFO "%s: ATAPI", drive->name);
 	if (CDROM_CONFIG_FLAGS(drive)->max_speed)
 		printk(" %dX", CDROM_CONFIG_FLAGS(drive)->max_speed);
-	printk(" %s", CDROM_CONFIG_FLAGS(drive)->dvd ? "DVD-ROM" : "CD-ROM");
+	printk(KERN_CONT " %s", (cdi->mask & CDC_DVD) ? "CD-ROM" : "DVD-ROM");
+
+	if ((cdi->mask & CDC_DVD_R) == 0 || (cdi->mask & CDC_DVD_RAM) == 0)
+		printk(KERN_CONT " DVD%s%s",
+				 (cdi->mask & CDC_DVD_R) ? "" : "-R",
+				 (cdi->mask & CDC_DVD_RAM) ? "" : "-RAM");
+
+	if ((cdi->mask & CDC_CD_R) == 0 || (cdi->mask & CDC_CD_RW) == 0)
+		printk(KERN_CONT " CD%s%s",
+				 (cdi->mask & CDC_CD_R) ? "" : "-R",
+				 (cdi->mask & CDC_CD_RW) ? "" : "/RW");
 
-	if (CDROM_CONFIG_FLAGS(drive)->dvd_r|CDROM_CONFIG_FLAGS(drive)->dvd_ram)
-        	printk(" DVD%s%s", 
-        	(CDROM_CONFIG_FLAGS(drive)->dvd_r)? "-R" : "", 
-        	(CDROM_CONFIG_FLAGS(drive)->dvd_ram)? "-RAM" : "");
-
-        if (CDROM_CONFIG_FLAGS(drive)->cd_r|CDROM_CONFIG_FLAGS(drive)->cd_rw) 
-        	printk(" CD%s%s", 
-        	(CDROM_CONFIG_FLAGS(drive)->cd_r)? "-R" : "", 
-        	(CDROM_CONFIG_FLAGS(drive)->cd_rw)? "/RW" : "");
-
-        if (CDROM_CONFIG_FLAGS(drive)->is_changer) 
-        	printk(" changer w/%d slots", nslots);
-        else 	
-        	printk(" drive");
+	if ((cdi->mask & CDC_SELECT_DISC) == 0)
+		printk(KERN_CONT " changer w/%d slots", nslots);
+	else
+		printk(KERN_CONT " drive");
 
 	printk(KERN_CONT ", %dkB Cache\n", be16_to_cpu(cap.buffer_size));
 
@@ -2844,7 +2823,6 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	if ((drive->id->config & 0x0060) == 0x20)
 		CDROM_CONFIG_FLAGS(drive)->drq_interrupt = 1;
 	CDROM_CONFIG_FLAGS(drive)->no_eject = 1;
-	CDROM_CONFIG_FLAGS(drive)->close_tray = 1;
 
 	/* limit transfer size per interrupt. */
 	/* a testament to the nice quality of Samsung drives... */
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -61,20 +61,10 @@ struct ide_cd_config_flags {
 	__u8 nec260		: 1; /* Drive is a pre-1.2 NEC 260 drive. */
 	__u8 tocaddr_as_bcd	: 1; /* TOC addresses are in BCD. */
 	__u8 toctracks_as_bcd	: 1; /* TOC track numbers are in BCD. */
-	__u8 is_changer		: 1; /* Drive is a changer. */
-	__u8 cd_r		: 1; /* Drive can write to CD-R media . */
-	__u8 cd_rw		: 1; /* Drive can write to CD-R/W media . */
-	__u8 dvd		: 1; /* Drive is a DVD-ROM */
-	__u8 dvd_r		: 1; /* Drive can write DVD-R */
-	__u8 dvd_ram		: 1; /* Drive can write DVD-RAM */
-	__u8 ram		: 1; /* generic WRITE (dvd-ram/mrw) */
 	__u8 limit_nframes	: 1; /* Drive does not provide data in
 					multiples of SECTOR_SIZE when more
 					than one interrupt is needed. */
 	__u8 seeking		: 1; /* Seeking in progress */
-	__u8 audio_play		: 1; /* can do audio related commands */
-	__u8 close_tray		: 1; /* can close the tray */
-	__u8 mo_drive		: 1; /* drive is an MO device */
 	__u8 no_speed_select	: 1; /* SET_CD_SPEED command is unsupported. */
 	byte max_speed;		     /* Max speed of the drive */
 };
