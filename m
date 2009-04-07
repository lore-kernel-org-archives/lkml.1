Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZDGNtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZDGNtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZDGNs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:48:56 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:19923 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752840AbZDGNsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:48:55 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 4/7 revised II] mmc_spi: do not check CID and CSD blocks with CRC16
Date: Tue, 7 Apr 2009 14:48:16 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904071548.17091.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o Some cards are not able to calculate a valid CRC16 value
  for CID and CSD reads (CRC for 512 byte data blocks is OK).
  By moving the CRC enable after the read of CID and CSD, these
  cards can be used. This patch was tested with a faulty 8 GByte
  takeMS Class 6 SDHC card. This patch was suggested by
  Pierre Ossman <drzeus@drzeus.cx>.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---

diff -uprN 2_6_29_rc7_patch1253/drivers/mmc/core/sd.c 2_6_29_rc7_patch12534/drivers/mmc/core/sd.c
--- 2_6_29_rc7_patch1253/drivers/mmc/core/sd.c	2009-03-04 02:05:22.000000000 +0100
+++ 2_6_29_rc7_patch12534/drivers/mmc/core/sd.c	2009-04-07 15:39:22.000000000 +0200
@@ -363,15 +363,6 @@ static int mmc_sd_init_card(struct mmc_h
 		goto err;
 
 	/*
-	 * For SPI, enable CRC as appropriate.
-	 */
-	if (mmc_host_is_spi(host)) {
-		err = mmc_spi_set_crc(host, use_spi_crc);
-		if (err)
-			goto err;
-	}
-
-	/*
 	 * Fetch CID from card.
 	 */
 	if (mmc_host_is_spi(host))
@@ -458,6 +449,18 @@ static int mmc_sd_init_card(struct mmc_h
 	}
 
 	/*
+	 * For SPI, enable CRC as appropriate.
+	 * This CRC enable is located AFTER the reading of the
+	 * card registers because some SDHC cards are not able
+	 * to provide valid CRCs for non-512-byte blocks.
+	 */
+	if (mmc_host_is_spi(host)) {
+		err = mmc_spi_set_crc(host, use_spi_crc);
+		if (err)
+			goto free_card;
+	}
+
+	/*
 	 * Attempt to change to high-speed (if supported)
 	 */
 	err = mmc_switch_hs(card);
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
