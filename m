Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbXLTBkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbXLTBkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758940AbXLTBfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbXLTBeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=f2e56QHXZzvgrWwa2kecnABika+IKEWVne6MTcrzNJ2Sh5sQiyI9FeZkZ4yM2ZwJYv6cCfOsr6rT+ttSRmVvqkhG5XjQzzanyZvW+jrQl//s6u+QbutTfLMtcXOMIX0w/Dl1BaUyAyEsxdxL2f3hEsvQFV29b3/mjS1avZLM4Yc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 09/63] ide-cd: fix 'ireason' reporting in cdrom_pc_intr()
Date: Thu, 20 Dec 2007 01:58:32 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200158.32631.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mask 'ireason' variable so only the valid interrupt reason bits
will be reported on "drive appears confused" error.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1440,7 +1440,7 @@ static ide_startstop_t cdrom_pc_intr (id
 		return ide_stopped;
 
 	/* Read the interrupt reason and the transfer length. */
-	ireason = HWIF(drive)->INB(IDE_IREASON_REG);
+	ireason = HWIF(drive)->INB(IDE_IREASON_REG) & 0x3;
 	lowcyl  = HWIF(drive)->INB(IDE_BCOUNTL_REG);
 	highcyl = HWIF(drive)->INB(IDE_BCOUNTH_REG);
 
@@ -1481,7 +1481,7 @@ static ide_startstop_t cdrom_pc_intr (id
 	if (thislen > len) thislen = len;
 
 	/* The drive wants to be written to. */
-	if ((ireason & 3) == 0) {
+	if (ireason == 0) {
 		if (!rq->data) {
 			blk_dump_rq_flags(rq, "cdrom_pc_intr, write");
 			goto confused;
@@ -1503,7 +1503,7 @@ static ide_startstop_t cdrom_pc_intr (id
 	}
 
 	/* Same drill for reading. */
-	else if ((ireason & 3) == 2) {
+	else if (ireason == 2) {
 		if (!rq->data) {
 			blk_dump_rq_flags(rq, "cdrom_pc_intr, read");
 			goto confused;
