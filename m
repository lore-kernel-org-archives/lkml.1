Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZCKN0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZCKN0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbZCKN0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:26:13 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2157 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753857AbZCKN0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:26:12 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 4/7] mmc_spi: do not check CID and CSD blocks with CRC16
Date: Wed, 11 Mar 2009 14:25:48 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903111425.48656.wolfgang.mues@auerswald.de>
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
This is one of a line of patches to enhance the usability of
the mmc spi host port driver from "don't work with most SD cards"
to "work with nearly all SD cards" (including those ugly cards
with non-byte-aligned responses).

diff -uprN 2_6_29_rc7_patch3_delayed_data_response/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch4_no_crc_on_CID_CSD/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch3_delayed_data_response/drivers/mmc/host/mmc_spi.c	2009-03-11 13:42:48.000000000 +0100
+++ 2_6_29_rc7_patch4_no_crc_on_CID_CSD/drivers/mmc/host/mmc_spi.c	2009-03-11 13:43:13.000000000 +0100
@@ -762,7 +762,11 @@ mmc_spi_readblock(struct mmc_spi_host *h
 		return -EIO;
 	}
 
-	if (host->mmc->use_spi_crc) {
+	/* Omitt the CRC check for CID and CSD reads. There are some SDHC
+	 * cards which don't supply a valid CRC after CID reads.
+	 * Note that the CID has it's own CRC7 value inside the data block.
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
