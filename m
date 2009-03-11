Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZCKN3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZCKN3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZCKN2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:28:54 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2167 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752344AbZCKN2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:28:54 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 5/7] mmc_spi: allow higher timeouts for SPI mode
Date: Wed, 11 Mar 2009 14:28:39 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903111428.39831.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o Some SD cards have very high timeouts in SPI mode.
  So adjust the timeouts from theory to practice.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---
This is one of a line of patches to enhance the usability of
the mmc spi host port driver from "don't work with most SD cards"
to "work with nearly all SD cards" (including those ugly cards
with non-byte-aligned responses).

diff -uprN 2_6_29_rc7_patch4_no_crc_on_CID_CSD/drivers/mmc/core/core.c 2_6_29_rc7_patch5_extra_spi_timeouts/drivers/mmc/core/core.c
--- 2_6_29_rc7_patch4_no_crc_on_CID_CSD/drivers/mmc/core/core.c	2009-03-04 02:05:22.000000000 +0100
+++ 2_6_29_rc7_patch5_extra_spi_timeouts/drivers/mmc/core/core.c	2009-03-10 12:06:16.000000000 +0100
@@ -297,6 +297,21 @@ void mmc_set_data_timeout(struct mmc_dat
 			data->timeout_clks = 0;
 		}
 	}
+	/*
+	 * Some cards need very high timeouts if driven in SPI mode.
+	 * The worst observed timeout was 900ms after writing a
+	 * continuous stream of data until the internal logic
+	 * overflowed.
+	 */
+	if (mmc_host_is_spi(card->host)) {
+		if (data->flags & MMC_DATA_WRITE) {
+			if (data->timeout_ns < 1000000000)
+				data->timeout_ns = 1000000000;	/* 1s */
+		} else {
+			if (data->timeout_ns < 100000000)
+				data->timeout_ns =  100000000;	/* 100ms */
+		}
+	}
 }
 EXPORT_SYMBOL(mmc_set_data_timeout);

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
