Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbXLTB5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbXLTB5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbXLTBhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:12451 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565AbXLTBee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nRVbriwHoKQ6IQbJLyZtrc7XigKzZhRa7+s9Pc/AUARPYC1wtdWwkZANenapm7UQT9uZJs/H7TCu3PavA/v9a4+fTsrV1PSwcqaxl7o3+Q/5qjKlZ6ukRqTUBJc3d/QvIVC/wFl5T+p4yk1OcUIrRm1TvRPfZ0txA/8BTP2TEI8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 28/63] ide-cd: remove struct atapi_capabilities_page
Date: Thu, 20 Dec 2007 02:13:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200213.47107.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Remove struct atapi_capabilities_page.

* Add ATAPI_CAPABILITIES_PAGE[_PAD]_SIZE define.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   62 +++++++-------
 drivers/ide/ide-cd.h |  223 ---------------------------------------------------
 2 files changed, 37 insertions(+), 248 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2373,13 +2373,12 @@ int ide_cdrom_lock_door (struct cdrom_de
 	return cdrom_lockdoor(drive, lock, NULL);
 }
 
-static
-int ide_cdrom_get_capabilities(ide_drive_t *drive, struct atapi_capabilities_page *cap)
+static int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 {
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *cdi = &info->devinfo;
 	struct packet_command cgc;
-	int stat, attempts = 3, size = sizeof(*cap);
+	int stat, attempts = 3, size = ATAPI_CAPABILITIES_PAGE_SIZE;
 
 	/*
 	 * ACER50 (and others?) require the full spec length mode sense
@@ -2387,9 +2386,9 @@ int ide_cdrom_get_capabilities(ide_drive
 	 */
 	if (!(!strcmp(drive->id->model, "ATAPI CD ROM DRIVE 50X MAX") ||
 	    !strcmp(drive->id->model, "WPI CDS-32X")))
-		size -= sizeof(cap->pad);
+		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
 
-	init_cdrom_command(&cgc, cap, size, CGC_DATA_UNKNOWN);
+	init_cdrom_command(&cgc, buf, size, CGC_DATA_UNKNOWN);
 	do { /* we seem to get stat=0x01,err=0x00 the first time (??) */
 		stat = cdrom_mode_sense(cdi, &cgc, GPMODE_CAPABILITIES_PAGE, 0);
 		if (!stat)
@@ -2398,20 +2397,22 @@ int ide_cdrom_get_capabilities(ide_drive
 	return stat;
 }
 
-static
-void ide_cdrom_update_speed (ide_drive_t *drive, struct atapi_capabilities_page *cap)
+static void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	u16 curspeed, maxspeed;
 
+	curspeed = *(u16 *)&buf[8 +  8];
+	maxspeed = *(u16 *)&buf[8 + 14];
+
 	/* The ACER/AOpen 24X cdrom has the speed fields byte-swapped */
 	if (!drive->id->model[0] &&
 	    !strncmp(drive->id->fw_rev, "241N", 4)) {
-		curspeed = le16_to_cpu(cap->curspeed);
-		maxspeed = le16_to_cpu(cap->maxspeed);
+		curspeed = le16_to_cpu(curspeed);
+		maxspeed = le16_to_cpu(maxspeed);
 	} else {
-		curspeed = be16_to_cpu(cap->curspeed);
-		maxspeed = be16_to_cpu(cap->maxspeed);
+		curspeed = be16_to_cpu(curspeed);
+		maxspeed = be16_to_cpu(maxspeed);
 	}
 
 	cd->state_flags.current_speed = (curspeed + (176/2)) / 176;
@@ -2424,14 +2425,14 @@ int ide_cdrom_select_speed (struct cdrom
 	ide_drive_t *drive = cdi->handle;
 	struct cdrom_info *cd = drive->driver_data;
 	struct request_sense sense;
-	struct atapi_capabilities_page cap;
+	u8 buf[ATAPI_CAPABILITIES_PAGE_SIZE];
 	int stat;
 
 	if ((stat = cdrom_select_speed(drive, speed, &sense)) < 0)
 		return stat;
 
-	if (!ide_cdrom_get_capabilities(drive, &cap)) {
-		ide_cdrom_update_speed(drive, &cap);
+	if (!ide_cdrom_get_capabilities(drive, buf)) {
+		ide_cdrom_update_speed(drive, buf);
 		cdi->speed = cd->state_flags.current_speed;
 	}
         return 0;
@@ -2615,7 +2616,8 @@ int ide_cdrom_probe_capabilities (ide_dr
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
-	struct atapi_capabilities_page cap;
+	u8 buf[ATAPI_CAPABILITIES_PAGE_SIZE];
+	mechtype_t mechtype;
 	int nslots = 1;
 
 	cdi->mask = (CDC_CD_R | CDC_CD_RW | CDC_DVD | CDC_DVD_R |
@@ -2645,26 +2647,28 @@ int ide_cdrom_probe_capabilities (ide_dr
 	cdi->handle = drive;
 	cdi->ops = &ide_cdrom_dops;
 
-	if (ide_cdrom_get_capabilities(drive, &cap))
+	if (ide_cdrom_get_capabilities(drive, buf))
 		return 0;
 
-	if (cap.lock == 0)
+	if ((buf[8 + 6] & 0x01) == 0)
 		cd->config_flags.no_doorlock = 1;
-	if (cap.eject)
+	if (buf[8 + 6] & 0x08)
 		cd->config_flags.no_eject = 0;
-	if (cap.cd_r_write)
+	if (buf[8 + 3] & 0x01)
 		cdi->mask &= ~CDC_CD_R;
-	if (cap.cd_rw_write)
+	if (buf[8 + 3] & 0x02)
 		cdi->mask &= ~(CDC_CD_RW | CDC_RAM);
-	if (cap.dvd_ram_read || cap.dvd_r_read || cap.dvd_rom)
+	if (buf[8 + 2] & 0x38)
 		cdi->mask &= ~CDC_DVD;
-	if (cap.dvd_ram_write)
+	if (buf[8 + 3] & 0x20)
 		cdi->mask &= ~(CDC_DVD_RAM | CDC_RAM);
-	if (cap.dvd_r_write)
+	if (buf[8 + 3] & 0x10)
 		cdi->mask &= ~CDC_DVD_R;
-	if (cap.audio_play)
+	if (buf[8 + 4] & 0x01)
 		cdi->mask &= ~CDC_PLAY_AUDIO;
-	if (cap.mechtype == mechtype_caddy || cap.mechtype == mechtype_popup)
+
+	mechtype = buf[8 + 6] >> 5;
+	if (mechtype == mechtype_caddy || mechtype == mechtype_popup)
 		cdi->mask |= CDC_CLOSE_TRAY;
 
 	/* Some drives used by Apple don't advertise audio play
@@ -2684,14 +2688,14 @@ int ide_cdrom_probe_capabilities (ide_dr
 
 	else
 #endif /* not STANDARD_ATAPI */
-	if (cap.mechtype == mechtype_individual_changer ||
-	    cap.mechtype == mechtype_cartridge_changer) {
+	if (mechtype == mechtype_individual_changer ||
+	    mechtype == mechtype_cartridge_changer) {
 		nslots = cdrom_number_of_slots(cdi);
 		if (nslots > 1)
 			cdi->mask &= ~CDC_SELECT_DISC;
 	}
 
-	ide_cdrom_update_speed(drive, &cap);
+	ide_cdrom_update_speed(drive, buf);
 
 	printk(KERN_INFO "%s: ATAPI", drive->name);
 
@@ -2716,7 +2720,7 @@ int ide_cdrom_probe_capabilities (ide_dr
 	else
 		printk(KERN_CONT " drive");
 
-	printk(KERN_CONT ", %dkB Cache\n", be16_to_cpu(cap.buffer_size));
+	printk(KERN_CONT ", %dkB Cache\n", be16_to_cpu(*(u16 *)&buf[8 + 12]));
 
 	return nslots;
 }
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -50,6 +50,10 @@
 #define SECTORS_PER_FRAME	(CD_FRAMESIZE >> SECTOR_BITS)
 #define SECTOR_BUFFER_SIZE	(CD_FRAMESIZE * 32)
 
+/* Capabilities Page size including 8 bytes of Mode Page Header */
+#define ATAPI_CAPABILITIES_PAGE_SIZE		(8 + 20)
+#define ATAPI_CAPABILITIES_PAGE_PAD_SIZE	4
+
 /* Configuration flags.  These describe the capabilities of the drive.
    They generally do not change after initialization, unless we learn
    more about the drive from stuff failing. */
@@ -124,225 +128,6 @@ struct atapi_toc {
 	  /* One extra for the leadout. */
 };
 
-/* This should probably go into cdrom.h along with the other
- * generic stuff now in the Mt. Fuji spec.
- */
-struct atapi_capabilities_page {
-	struct mode_page_header header;
-#if defined(__BIG_ENDIAN_BITFIELD)
-	__u8 parameters_saveable : 1;
-	__u8 reserved1           : 1;
-	__u8 page_code           : 6;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8 page_code           : 6;
-	__u8 reserved1           : 1;
-	__u8 parameters_saveable : 1;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-	byte     page_length;
-
-#if defined(__BIG_ENDIAN_BITFIELD)
-	__u8 reserved2           : 2;
-	/* Drive supports reading of DVD-RAM discs */
-	__u8 dvd_ram_read        : 1;
-	/* Drive supports reading of DVD-R discs */
-	__u8 dvd_r_read          : 1;
-	/* Drive supports reading of DVD-ROM discs */
-	__u8 dvd_rom             : 1;
-	/* Drive supports reading CD-R discs with addressing method 2 */
-	__u8 method2             : 1; /* reserved in 1.2 */
-	/* Drive can read from CD-R/W (CD-E) discs (orange book, part III) */
-	__u8 cd_rw_read		 : 1; /* reserved in 1.2 */
-	/* Drive supports read from CD-R discs (orange book, part II) */
-	__u8 cd_r_read           : 1; /* reserved in 1.2 */
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	/* Drive supports read from CD-R discs (orange book, part II) */
-	__u8 cd_r_read           : 1; /* reserved in 1.2 */
-	/* Drive can read from CD-R/W (CD-E) discs (orange book, part III) */
-	__u8 cd_rw_read          : 1; /* reserved in 1.2 */
-	/* Drive supports reading CD-R discs with addressing method 2 */
-	__u8 method2             : 1;
-	/* Drive supports reading of DVD-ROM discs */
-	__u8 dvd_rom             : 1;
-	/* Drive supports reading of DVD-R discs */
-	__u8 dvd_r_read          : 1;
-	/* Drive supports reading of DVD-RAM discs */
-	__u8 dvd_ram_read        : 1;
-	__u8 reserved2		 : 2;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-#if defined(__BIG_ENDIAN_BITFIELD)
-	__u8 reserved3           : 2;
-	/* Drive can write DVD-RAM discs */
-	__u8 dvd_ram_write       : 1;
-	/* Drive can write DVD-R discs */
-	__u8 dvd_r_write         : 1;
-	__u8 reserved3a          : 1;
-	/* Drive can fake writes */
-	__u8 test_write          : 1;
-	/* Drive can write to CD-R/W (CD-E) discs (orange book, part III) */
-	__u8 cd_rw_write	 : 1; /* reserved in 1.2 */
-	/* Drive supports write to CD-R discs (orange book, part II) */
-	__u8 cd_r_write          : 1; /* reserved in 1.2 */
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	/* Drive can write to CD-R discs (orange book, part II) */
-	__u8 cd_r_write          : 1; /* reserved in 1.2 */
-	/* Drive can write to CD-R/W (CD-E) discs (orange book, part III) */
-	__u8 cd_rw_write	 : 1; /* reserved in 1.2 */
-	/* Drive can fake writes */
-	__u8 test_write          : 1;
-	__u8 reserved3a          : 1;
-	/* Drive can write DVD-R discs */
-	__u8 dvd_r_write         : 1;
-	/* Drive can write DVD-RAM discs */
-	__u8 dvd_ram_write       : 1;
-	__u8 reserved3           : 2;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-#if defined(__BIG_ENDIAN_BITFIELD)
-	__u8 reserved4           : 1;
-	/* Drive can read multisession discs. */
-	__u8 multisession        : 1;
-	/* Drive can read mode 2, form 2 data. */
-	__u8 mode2_form2         : 1;
-	/* Drive can read mode 2, form 1 (XA) data. */
-	__u8 mode2_form1         : 1;
-	/* Drive supports digital output on port 2. */
-	__u8 digport2            : 1;
-	/* Drive supports digital output on port 1. */
-	__u8 digport1            : 1;
-	/* Drive can deliver a composite audio/video data stream. */
-	__u8 composite           : 1;
-	/* Drive supports audio play operations. */
-	__u8 audio_play          : 1;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	/* Drive supports audio play operations. */
-	__u8 audio_play          : 1;
-	/* Drive can deliver a composite audio/video data stream. */
-	__u8 composite           : 1;
-	/* Drive supports digital output on port 1. */
-	__u8 digport1            : 1;
-	/* Drive supports digital output on port 2. */
-	__u8 digport2            : 1;
-	/* Drive can read mode 2, form 1 (XA) data. */
-	__u8 mode2_form1         : 1;
-	/* Drive can read mode 2, form 2 data. */
-	__u8 mode2_form2         : 1;
-	/* Drive can read multisession discs. */
-	__u8 multisession        : 1;
-	__u8 reserved4           : 1;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-#if defined(__BIG_ENDIAN_BITFIELD)
-	__u8 reserved5           : 1;
-	/* Drive can return Media Catalog Number (UPC) info. */
-	__u8 upc                 : 1;
-	/* Drive can return International Standard Recording Code info. */
-	__u8 isrc                : 1;
-	/* Drive supports C2 error pointers. */
-	__u8 c2_pointers         : 1;
-	/* R-W data will be returned deinterleaved and error corrected. */
-	__u8 rw_corr             : 1;
-	/* Subchannel reads can return combined R-W information. */
-	__u8 rw_supported        : 1;
-	/* Drive can continue a read cdda operation from a loss of streaming.*/
-	__u8 cdda_accurate       : 1;
-	/* Drive can read Red Book audio data. */
-	__u8 cdda                : 1;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	/* Drive can read Red Book audio data. */
-	__u8 cdda                : 1;
-	/* Drive can continue a read cdda operation from a loss of streaming.*/
-	__u8 cdda_accurate       : 1;
-	/* Subchannel reads can return combined R-W information. */
-	__u8 rw_supported        : 1;
-	/* R-W data will be returned deinterleaved and error corrected. */
-	__u8 rw_corr             : 1;
-	/* Drive supports C2 error pointers. */
-	__u8 c2_pointers         : 1;
-	/* Drive can return International Standard Recording Code info. */
-	__u8 isrc                : 1;
-	/* Drive can return Media Catalog Number (UPC) info. */
-	__u8 upc                 : 1;
-	__u8 reserved5           : 1;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-#if defined(__BIG_ENDIAN_BITFIELD)
-	/* Drive mechanism types. */
-	mechtype_t mechtype	 : 3;
-	__u8 reserved6           : 1;
-	/* Drive can eject a disc or changer cartridge. */
-	__u8 eject               : 1;
-	/* State of prevent/allow jumper. */
-	__u8 prevent_jumper      : 1;
-	/* Present state of door lock. */
-	__u8 lock_state          : 1;
-	/* Drive can lock the door. */
-	__u8 lock                : 1;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-
-	/* Drive can lock the door. */
-	__u8 lock                : 1;
-	/* Present state of door lock. */
-	__u8 lock_state          : 1;
-	/* State of prevent/allow jumper. */
-	__u8 prevent_jumper      : 1;
-	/* Drive can eject a disc or changer cartridge. */
-	__u8 eject               : 1;
-	__u8 reserved6           : 1;
-	/* Drive mechanism types. */
-	mechtype_t mechtype	 : 3;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-#if defined(__BIG_ENDIAN_BITFIELD)
-	__u8 reserved7           : 4;
-	/* Drive supports software slot selection. */
-	__u8 sss                 : 1;  /* reserved in 1.2 */
-	/* Changer can report exact contents of slots. */
-	__u8 disc_present        : 1;  /* reserved in 1.2 */
-	/* Audio for each channel can be muted independently. */
-	__u8 separate_mute       : 1;
-	/* Audio level for each channel can be controlled independently. */
-	__u8 separate_volume     : 1;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-
-	/* Audio level for each channel can be controlled independently. */
-	__u8 separate_volume     : 1;
-	/* Audio for each channel can be muted independently. */
-	__u8 separate_mute       : 1;
-	/* Changer can report exact contents of slots. */
-	__u8 disc_present        : 1;  /* reserved in 1.2 */
-	/* Drive supports software slot selection. */
-	__u8 sss                 : 1;  /* reserved in 1.2 */
-	__u8 reserved7           : 4;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-	/* Note: the following four fields are returned in big-endian form. */
-	/* Maximum speed (in kB/s). */
-	unsigned short maxspeed;
-	/* Number of discrete volume levels. */
-	unsigned short n_vol_levels;
-	/* Size of cache in drive, in kB. */
-	unsigned short buffer_size;
-	/* Current speed (in kB/s). */
-	unsigned short curspeed;
-	char pad[4];
-};
-
 /* Extra per-device info for cdrom drives. */
 struct cdrom_info {
 	ide_drive_t	*drive;
