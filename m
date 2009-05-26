Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZEZH4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZEZH4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZEZH4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:56:38 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:5952 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751420AbZEZH4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:56:38 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH] mmc_spi: don't use EINVAL for possible transmission errors
Date: Tue, 26 May 2009 08:56:19 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905260956.19587.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o This patch changes the reported error code for the responses
  to a command from EINVAL to EFAULT/ENOSYS, as EINVAL is reserved
  for non-recoverable host errors, and the responses from
  the SD/MMC card may be because of recoverable transmission
  errors in the command or in the response. Response codes
  in SPI mode are NOT protected by a checksum, so don't trust them.

This is a revised, minimal-invasive patch version. As Pierre Ossman
pointed out, EINVAL should only be used for non-recoverable errors
(and is used so in the whole rest of the mmc framework).

I have checked every instance of EINVAL in the mmc framework - no 
changes were needed here. 

This patch is neccessary for doing a sensible retry managment in the 
mmmc block layer (patch will follow).

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---
diff -uprN 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c	2009-04-08 11:11:20.000000000 +0200
+++ 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c	2009-05-26 09:37:28.000000000 +0200
@@ -335,15 +335,16 @@ checkstatus:

 	/* Status byte: the entire seven-bit R1 response.  */
 	if (cmd->resp[0] != 0) {
-		if ((R1_SPI_PARAMETER | R1_SPI_ADDRESS
-				      | R1_SPI_ILLEGAL_COMMAND)
+		if ((R1_SPI_PARAMETER | R1_SPI_ADDRESS)
 				& cmd->resp[0])
-			value = -EINVAL;
+			value = -EFAULT; /* Bad address */
+		else if (R1_SPI_ILLEGAL_COMMAND & cmd->resp[0])
+			value = -ENOSYS; /* Function not implemented */
 		else if (R1_SPI_COM_CRC & cmd->resp[0])
-			value = -EILSEQ;
+			value = -EILSEQ; /* Illegal byte sequence */
 		else if ((R1_SPI_ERASE_SEQ | R1_SPI_ERASE_RESET)
 				& cmd->resp[0])
-			value = -EIO;
+			value = -EIO;    /* I/O error */
 		/* else R1_SPI_IDLE, "it's resetting" */
 	}

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
