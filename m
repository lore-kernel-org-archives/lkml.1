Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbXLTB4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbXLTB4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXLTBhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:11604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662AbXLTBeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Oeldhy7BmQNALVDSuwuiuW8jZQw5RKcgSNjC8Go13881EDXnp1GbW73VzH+d0ZrwFdN0e/I25AFmQQvY1lDtI1Y48JCM/Fr1uop9MMreNGxqTQp7C0RE/toNPg7/nglorsE4u/T+3O5lXQ6LDliFqTbnYWv8v7Tcjl56l91b2S4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 31/63] ide-cd: remove STANDARD_ATAPI define
Date: Thu, 20 Dec 2007 02:16:09 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200216.09451.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove STANDARD_ATAPI define + drive-by coding style fixes.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   43 ++++++++++---------------------------------
 drivers/ide/ide-cd.h |   10 ----------
 2 files changed, 10 insertions(+), 43 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1754,7 +1754,6 @@ ide_do_rw_cdrom (ide_drive_t *drive, str
  * can also be NULL, in which case no sense information is returned.
  */
 
-#if ! STANDARD_ATAPI
 static inline
 int bin2bcd (int x)
 {
@@ -1776,9 +1775,6 @@ void msf_from_bcd (struct atapi_msf *msf
 	msf->frame  = bcd2bin (msf->frame);
 }
 
-#endif /* not STANDARD_ATAPI */
-
-
 static inline
 void lba_to_msf (int lba, byte *m, byte *s, byte *f)
 {
@@ -1809,12 +1805,11 @@ static int cdrom_check_status(ide_drive_
 	req.cmd[0] = GPCMD_TEST_UNIT_READY;
 	req.cmd_flags |= REQ_QUIET;
 
-#if ! STANDARD_ATAPI
-        /* the Sanyo 3 CD changer uses byte 7 of TEST_UNIT_READY to 
-           switch CDs instead of supporting the LOAD_UNLOAD opcode   */
-
+	/*
+	 * Sanyo 3 CD changer uses byte 7 of TEST_UNIT_READY to
+	 * switch CDs instead of supporting the LOAD_UNLOAD opcode.
+	 */
 	req.cmd[7] = cdi->sanyo_slot % 3;
-#endif /* not STANDARD_ATAPI */
 
 	return cdrom_queue_packet_command(drive, &req);
 }
@@ -2003,12 +1998,10 @@ static int cdrom_read_toc(ide_drive_t *d
 	if (stat)
 		return stat;
 
-#if ! STANDARD_ATAPI
 	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
 		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
 		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
-#endif  /* not STANDARD_ATAPI */
 
 	ntracks = toc->hdr.last_track - toc->hdr.first_track + 1;
 	if (ntracks <= 0)
@@ -2040,16 +2033,13 @@ static int cdrom_read_toc(ide_drive_t *d
 					   (ntracks + 1) *
 					   sizeof(struct atapi_toc_entry),
 					   sense);
-		if (stat) {
+		if (stat)
 			return stat;
-		}
-#if ! STANDARD_ATAPI
+
 		if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
 			toc->hdr.first_track = bin2bcd(CDROM_LEADOUT);
 			toc->hdr.last_track = bin2bcd(CDROM_LEADOUT);
-		} else
-#endif  /* not STANDARD_ATAPI */
-		{
+		} else {
 			toc->hdr.first_track = CDROM_LEADOUT;
 			toc->hdr.last_track = CDROM_LEADOUT;
 		}
@@ -2060,21 +2050,17 @@ static int cdrom_read_toc(ide_drive_t *d
 
 	toc->hdr.toc_length = ntohs (toc->hdr.toc_length);
 
-#if ! STANDARD_ATAPI
 	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
 		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
 		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
-#endif  /* not STANDARD_ATAPI */
 
-	for (i=0; i<=ntracks; i++) {
-#if ! STANDARD_ATAPI
+	for (i = 0; i <= ntracks; i++) {
 		if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
 			if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD)
 				toc->ent[i].track = bcd2bin(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
-#endif  /* not STANDARD_ATAPI */
 		toc->ent[i].addr.lba = msf_to_lba (toc->ent[i].addr.msf.minute,
 						   toc->ent[i].addr.msf.second,
 						   toc->ent[i].addr.msf.frame);
@@ -2094,7 +2080,6 @@ static int cdrom_read_toc(ide_drive_t *d
 		toc->last_session_lba = msf_to_lba(0, 2, 0); /* 0m 2s 0f */
 	}
 
-#if ! STANDARD_ATAPI
 	if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
 		/* Re-read multisession information using MSF format */
 		stat = cdrom_read_tocentry(drive, 0, 1, 1, (char *)&ms_tmp,
@@ -2107,7 +2092,6 @@ static int cdrom_read_toc(ide_drive_t *d
 					  	   ms_tmp.ent.addr.msf.second,
 						   ms_tmp.ent.addr.msf.frame);
 	}
-#endif  /* not STANDARD_ATAPI */
 
 	toc->xa_flag = (ms_tmp.hdr.first_track != ms_tmp.hdr.last_track);
 
@@ -2684,16 +2668,11 @@ int ide_cdrom_probe_capabilities (ide_dr
 	    strcmp(drive->id->model, "MATSHITADVD-ROM SR-8174") == 0)
 		cdi->mask &= ~CDC_PLAY_AUDIO;
 
-#if ! STANDARD_ATAPI
 	if (cdi->sanyo_slot > 0) {
 		cdi->mask &= ~CDC_SELECT_DISC;
 		nslots = 3;
-	}
-
-	else
-#endif /* not STANDARD_ATAPI */
-	if (mechtype == mechtype_individual_changer ||
-	    mechtype == mechtype_cartridge_changer) {
+	} else if (mechtype == mechtype_individual_changer ||
+		   mechtype == mechtype_cartridge_changer) {
 		nslots = cdrom_number_of_slots(cdi);
 		if (nslots > 1)
 			cdi->mask &= ~CDC_SELECT_DISC;
@@ -2847,7 +2826,6 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	else if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-3231"))
 		cd->cd_flags |= IDE_CD_FLAG_NO_SPEED_SELECT;
 
-#if ! STANDARD_ATAPI
 	if (strcmp (drive->id->model, "V003S0DS") == 0 &&
 	    drive->id->fw_rev[4] == '1' &&
 	    drive->id->fw_rev[6] <= '2') {
@@ -2880,7 +2858,6 @@ int ide_cdrom_setup (ide_drive_t *drive)
                  /* uses CD in slot 0 when value is set to 3 */
                  cdi->sanyo_slot = 3;
         }
-#endif /* not STANDARD_ATAPI */
 
 	nslots = ide_cdrom_probe_capabilities (drive);
 
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -18,16 +18,6 @@
 #define VERBOSE_IDE_CD_ERRORS 1
 #endif
 
-
-/* Turning this on will remove code to work around various nonstandard
-   ATAPI implementations.  If you know your drive follows the standard,
-   this will give you a slightly smaller kernel. */
-
-#ifndef STANDARD_ATAPI
-#define STANDARD_ATAPI 0
-#endif
-
-
 /*
  * typical timeout for packet command
  */
