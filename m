Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbZENLYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbZENLYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbZENLYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:24:44 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:12423 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754948AbZENLYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:24:43 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Thu, 14 May 2009 12:24:27 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905141324.27908.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o This patch changes the reported error code for the responses
  to a command from EINVAL/EIO to EILSEQ, as EINVAL is reserved
  for non-recoverable host errors, and the responses from
  the SD/MMC card may be because of recoverable transmission
  errors in the command or in the response. Response codes
  are NOT protected by a checksum, so don't trust them.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---
diff -uprN 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c	2009-04-08 11:11:20.000000000 +0200
+++ 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c	2009-05-14 12:49:42.000000000 +0200
@@ -334,17 +334,18 @@ checkstatus:
 	cmd->error = 0;

 	/* Status byte: the entire seven-bit R1 response.  */
-	if (cmd->resp[0] != 0) {
-		if ((R1_SPI_PARAMETER | R1_SPI_ADDRESS
-				      | R1_SPI_ILLEGAL_COMMAND)
-				& cmd->resp[0])
-			value = -EINVAL;
-		else if (R1_SPI_COM_CRC & cmd->resp[0])
-			value = -EILSEQ;
-		else if ((R1_SPI_ERASE_SEQ | R1_SPI_ERASE_RESET)
-				& cmd->resp[0])
-			value = -EIO;
-		/* else R1_SPI_IDLE, "it's resetting" */
+	/*
+	 * Note that we have a problem here: as the response is NOT protected
+	 * by a CRC or checksum, a transmission error in the response will
+	 * be interpreted as an error code. So we map all error codes to
+	 * EILSEQ here, to allow for the upper layer to retry the command.
+	 * If one of these error codes is a non-recoverable error, retries
+	 * will do no harm.
+	 */
+
+	/* Allow only 0 and R1_SPI_IDLE here */
+	if (cmd->resp[0] & ~R1_SPI_IDLE) {
+		value = -EILSEQ;
 	}

 	switch (mmc_spi_resp_type(cmd)) {
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
