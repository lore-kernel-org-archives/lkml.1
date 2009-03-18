Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZCRJxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZCRJxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbZCRJw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:52:56 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2779 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753756AbZCRJwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:52:55 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 4/7 revised] mmc_spi: do not check CID and CSD blocks with CRC16
Date: Wed, 18 Mar 2009 10:52:39 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903181052.39586.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o Some cards are not able to calculate a valid CRC16 value
  for CID and CSD reads (CRC for 512 byte data blocks is OK).
  So ommit the check for CRC16, as CID and CSD have a checksum
  inside the block.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---

This is patch #4 revised to apply after #1,#2,#5 (already applied) 
and #3 (acked by David Brownell). Documentation was extended.
There were some suggestions to move this check into an upper layer
but none of these tries were a valid solution, so stick with this
minimal change here in the readblock function.

diff -uprN 2_6_29_rc7_patch1253/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch12534/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch1253/drivers/mmc/host/mmc_spi.c	2009-03-16 12:15:36.000000000 +0100
+++ 2_6_29_rc7_patch12534/drivers/mmc/host/mmc_spi.c	2009-03-18 10:32:45.000000000 +0100
@@ -767,7 +767,13 @@ mmc_spi_readblock(struct mmc_spi_host *h
 		return -EIO;
 	}
 
-	if (host->mmc->use_spi_crc) {
+	/* Omitt the CRC check for CID reads. There are some SDHC
+	 * cards which don't supply a valid CRC after CID reads.
+	 * All data reads have len == MMC_SPI_BLOCKSIZE, so use this
+	 * check to distinguish between data reads and CID/CSD reads.
+	 * Note that CID/CSD has it's own CRC7 value inside the structure.
+	 */
+	if (host->mmc->use_spi_crc && (t->len == MMC_SPI_BLOCKSIZE)) {
 		u16 crc = crc_itu_t(0, t->rx_buf, t->len);
 
 		be16_to_cpus(&scratch->crc_val);

---
regards

i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
