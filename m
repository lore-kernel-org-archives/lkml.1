Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbXLTBxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbXLTBxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757508AbXLTBeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503AbXLTBeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CRH9bxi/2xEP1i6fNCUmsdjbm6yg81fAREBF5bNGMaIWsYZTNs7YOM9zZNXtpvXuTK6S53H3haBOO7XCu0HryS1cX7U3tVt4wK5wDvKfR47n41Nj4VhpQPXCdgxHAQntexaE3r3CD3C1WsIej0s5QODFZmAxgRS7kYaetTHJ4qs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 13/63] ide-cd: fix DMA error handling in cdrom_newpc_intr()
Date: Thu, 20 Dec 2007 02:02:06 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200202.06988.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make cdrom_newpc_intr() match cdrom_{read,write}_intr() w.r.t.
handling DMA errors:

* disable DMA before cdrom_decode_status() call

* log the device name and the type of the request (read/write)

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1663,6 +1663,11 @@ static ide_startstop_t cdrom_newpc_intr(
 	if (dma) {
 		info->dma = 0;
 		dma_error = HWIF(drive)->ide_dma_end(drive);
+		if (dma_error) {
+			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
+					rq_data_dir(rq) ? "write" : "read");
+			ide_dma_off(drive);
+		}
 	}
 
 	if (cdrom_decode_status(drive, 0, &stat))
@@ -1672,11 +1677,8 @@ static ide_startstop_t cdrom_newpc_intr(
 	 * using dma, transfer is complete now
 	 */
 	if (dma) {
-		if (dma_error) {
-			printk(KERN_ERR "ide-cd: dma error\n");
-			ide_dma_off(drive);
+		if (dma_error)
 			return ide_error(drive, "dma error", stat);
-		}
 
 		end_that_request_chunk(rq, 1, rq->data_len);
 		rq->data_len = 0;
