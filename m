Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbXLTBvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbXLTBvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbXLTBgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:12071 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604AbXLTBew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JOHBHWpXjXTVtmKngWIbMShZY2ESGvhBeprjDahh02rgsCMAM+rAh+vYWURYgB4MELjRunVXnXY35V70BxGNrfYIlwqLn9foTscAVPWULS47N+REaCN7PtaD3PcNN1nlZkUyg9h0KBhtkbJ6pgDcynATiUlowd0WiKjNiFoLvaI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 47/63] ide-cd: factor out request sense fixup from cdrom_pc_intr()
Date: Thu, 20 Dec 2007 02:28:27 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200228.27682.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a preparation for cdrom_pc_intr() and cdrom_newpc_intr() merge.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1047,6 +1047,20 @@ static ide_startstop_t cdrom_start_read 
  * Execute all other packet commands.
  */
 
+static void ide_cd_request_sense_fixup(struct request *rq)
+{
+	/*
+	 * Some of the trailing request sense fields are optional,
+	 * and some drives don't send them.  Sigh.
+	 */
+	if (rq->cmd[0] == GPCMD_REQUEST_SENSE &&
+	    rq->data_len > 0 && rq->data_len <= 5)
+		while (rq->data_len > 0) {
+			*(u8 *)rq->data++ = 0;
+			--rq->data_len;
+		}
+}
+
 /* Interrupt routine for packet command completion. */
 static ide_startstop_t cdrom_pc_intr (ide_drive_t *drive)
 {
@@ -1069,16 +1083,7 @@ static ide_startstop_t cdrom_pc_intr (id
 	/* If DRQ is clear, the command has completed.
 	   Complain if we still have data left to transfer. */
 	if ((stat & DRQ_STAT) == 0) {
-		/* Some of the trailing request sense fields are optional, and
-		   some drives don't send them.  Sigh. */
-		if (rq->cmd[0] == GPCMD_REQUEST_SENSE &&
-		    rq->data_len > 0 &&
-		    rq->data_len <= 5) {
-			while (rq->data_len > 0) {
-				*(unsigned char *)rq->data++ = 0;
-				--rq->data_len;
-			}
-		}
+		ide_cd_request_sense_fixup(rq);
 
 		if (rq->data_len == 0)
 			cdrom_end_request(drive, 1);
