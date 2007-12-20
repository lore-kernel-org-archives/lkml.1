Return-Path: <linux-kernel-owner+w=401wt.eu-S1761917AbXLTBzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761917AbXLTBzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759432AbXLTBhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:12451 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697AbXLTBeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=iTptIb+VPaHolzuyZVOo7t39gPnIlFkmy5//2tevPag/2bCirRUPbC+LU2xaT08PMtxbYAiVm/3/BdX5McTrpI+D141RnByPrvlo6bT7lDFctmq2lqkn9qOoGGCvwNUQzHyDh9DsNBuDEyfHSuCVFobT/7+/DgxSThnFL0CUKi0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 32/63] ide-cd: use BCD2BIN()/BIN2BCD() macros from <linux/bcd.h>
Date: Thu, 20 Dec 2007 02:17:03 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200217.03918.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use BCD2BIN()/BIN2BCD() macros from <linux/bcd.h>
and remove the local bcd2bin()/bin2bcd() inlines.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
+15 bytes :(
 drivers/ide/ide-cd.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -46,6 +46,7 @@
 #include <linux/ide.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/bcd.h>
 
 #include <scsi/scsi.h>	/* For SCSI -> ATAPI command conversion */
 
@@ -1754,25 +1755,12 @@ ide_do_rw_cdrom (ide_drive_t *drive, str
  * can also be NULL, in which case no sense information is returned.
  */
 
-static inline
-int bin2bcd (int x)
-{
-	return (x%10) | ((x/10) << 4);
-}
-
-
-static inline
-int bcd2bin (int x)
-{
-	return (x >> 4) * 10 + (x & 0x0f);
-}
-
 static
 void msf_from_bcd (struct atapi_msf *msf)
 {
-	msf->minute = bcd2bin (msf->minute);
-	msf->second = bcd2bin (msf->second);
-	msf->frame  = bcd2bin (msf->frame);
+	msf->minute = BCD2BIN(msf->minute);
+	msf->second = BCD2BIN(msf->second);
+	msf->frame  = BCD2BIN(msf->frame);
 }
 
 static inline
@@ -1999,8 +1987,8 @@ static int cdrom_read_toc(ide_drive_t *d
 		return stat;
 
 	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
-		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
-		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
+		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
+		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
 	}
 
 	ntracks = toc->hdr.last_track - toc->hdr.first_track + 1;
@@ -2037,8 +2025,8 @@ static int cdrom_read_toc(ide_drive_t *d
 			return stat;
 
 		if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
-			toc->hdr.first_track = bin2bcd(CDROM_LEADOUT);
-			toc->hdr.last_track = bin2bcd(CDROM_LEADOUT);
+			toc->hdr.first_track = (u8)BIN2BCD(CDROM_LEADOUT);
+			toc->hdr.last_track = (u8)BIN2BCD(CDROM_LEADOUT);
 		} else {
 			toc->hdr.first_track = CDROM_LEADOUT;
 			toc->hdr.last_track = CDROM_LEADOUT;
@@ -2051,14 +2039,14 @@ static int cdrom_read_toc(ide_drive_t *d
 	toc->hdr.toc_length = ntohs (toc->hdr.toc_length);
 
 	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
-		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
-		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
+		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
+		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
 	}
 
 	for (i = 0; i <= ntracks; i++) {
 		if (info->cd_flags & IDE_CD_FLAG_TOCADDR_AS_BCD) {
 			if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD)
-				toc->ent[i].track = bcd2bin(toc->ent[i].track);
+				toc->ent[i].track = BCD2BIN(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
 		toc->ent[i].addr.lba = msf_to_lba (toc->ent[i].addr.msf.minute,
