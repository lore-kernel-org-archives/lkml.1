Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbZCPL1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbZCPL1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbZCPL1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:27:30 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:1908 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755015AbZCPL13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:27:29 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH 3/7 revised] mmc_spi: adjust for delayed data token response
Date: Mon, 16 Mar 2009 12:23:03 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903161223.03402.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o some cards are not able to send the data token in time, but
  miss the time frame for some bits(!). So synchronize to the
  start of the token.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---

This is the revised patch #3, to apply after the already accepted 
patches #1,2 and #5. It contains the bugfix and a better explanation
of what is going on here.

diff -uprN 2_6_29_rc7_patch125/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch1253/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch125/drivers/mmc/host/mmc_spi.c	2009-03-11 13:00:06.000000000 +0100
+++ 2_6_29_rc7_patch1253/drivers/mmc/host/mmc_spi.c	2009-03-16 12:15:36.000000000 +0100
@@ -612,6 +612,7 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	struct spi_device	*spi = host->spi;
 	int			status, i;
 	struct scratch		*scratch = host->data;
+	u32			pattern;
 
 	if (host->mmc->use_spi_crc)
 		scratch->crc_val = cpu_to_be16(
@@ -639,8 +640,27 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	 * doesn't necessarily tell whether the write operation succeeded;
 	 * it just says if the transmission was ok and whether *earlier*
 	 * writes succeeded; see the standard.
-	 */
-	switch (SPI_MMC_RESPONSE_CODE(scratch->status[0])) {
+	 *
+	 * In practice, there are (even modern SDHC-)cards which are late
+	 * in sending the response, and miss the time frame by a few bits,
+	 * so we have to cope with this situation and check the response 
+	 * bit-by-bit. Arggh!!!
+	 */
+	pattern  = scratch->status[0] << 24;
+	pattern |= scratch->status[1] << 16;
+	pattern |= scratch->status[2] << 8;
+	pattern |= scratch->status[3];
+
+	/* First 3 bit of pattern are undefined */
+	pattern |= 0xE0000000;
+
+	/* left-adjust to leading 0 bit */
+	while (pattern & 0x80000000)
+		pattern <<= 1;
+	/* right-adjust for pattern matching. Code is in bit 4..0 now. */
+	pattern >>= 27;
+
+	switch (pattern) {
 	case SPI_RESPONSE_ACCEPTED:
 		status = 0;
 		break;
@@ -671,8 +691,9 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	/* Return when not busy.  If we didn't collect that status yet,
 	 * we'll need some more I/O.
 	 */
-	for (i = 1; i < sizeof(scratch->status); i++) {
-		if (scratch->status[i] != 0)
+	for (i = 4; i < sizeof(scratch->status); i++) {
+		/* card is non-busy if the most recent bit is 1 */
+		if (scratch->status[i] & 0x01)
 			return 0;
 	}
 	return mmc_spi_wait_unbusy(host, timeout);

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
