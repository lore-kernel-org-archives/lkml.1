Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXLTBrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXLTBrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbXLTBgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:12147 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbXLTBfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:35:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KJYlUQwIECHMUOc+OahtkxMws6e+2mNweS7T4Obtavin32N6SVWfj6FfQq5vOv99CHindkGveqMozCfh68lbe6e6JzQZdAiZus13G7XvFAjvSt5JOFVnt0soXnmgBU9nAYFfy5aYwrssq+xVHi5KE5lLR/KVsHOxgJwHlCTaQsQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 57/63] ide-cd: unify moving to the next buffer in cdrom_rw_intr()
Date: Thu, 20 Dec 2007 02:35:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200235.59108.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the fact that for the first loop rq->current_nr_sectors is always
set and unify moving to the next buffer for read/write requests.

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-46 bytes
 drivers/ide/ide-cd.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1287,13 +1287,6 @@ static ide_startstop_t cdrom_rw_intr(ide
 	while (sectors_to_transfer > 0) {
 		int this_transfer;
 
-		/*
-		 * If we've filled the present buffer but there's another
-		 * chained buffer after it, move on.
-		 */
-		if (!write && rq->current_nr_sectors == 0 && rq->nr_sectors)
-			cdrom_end_request(drive, 1);
-
 		if (!rq->current_nr_sectors) {
 			if (!write)
 				/*
@@ -1327,7 +1320,7 @@ static ide_startstop_t cdrom_rw_intr(ide
 		/*
 		 * current buffer complete, move on
 		 */
-		if (write && rq->current_nr_sectors == 0 && rq->nr_sectors)
+		if (rq->current_nr_sectors == 0 && rq->nr_sectors)
 			cdrom_end_request(drive, 1);
 	}
 
