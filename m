Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbXA2Ba2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbXA2Ba2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 20:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXA2Ba1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 20:30:27 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:46287 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbXA2Ba0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 20:30:26 -0500
Date: Sun, 28 Jan 2007 19:29:46 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] libata: fix translation for START STOP UNIT
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Message-id: <45BD4E0A.7060501@shaw.ca>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------080408040500080807070707
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080408040500080807070707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Applies to 2.6.20-rc6.

---

libata's SCSI translation for the SCSI START STOP UNIT command with the 
START bit clear (i.e. stopping the drive) appears to be incorrect. It 
sends an ATA STANDBY command with the time period set to 0, which the 
code comment says means "now", but the ATA standard says this means 
disable the standby timer, which effectively does nothing. Change this 
to issue a STANDBY IMMEDIATE command which will actually spin the drive 
down. The SAT (SCSI/ATA Translation) standard revision 9 concurs with 
this choice.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/



--------------080408040500080807070707
Content-Type: text/plain;
 name="libata-fix-start-stop-unit-translation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata-fix-start-stop-unit-translation.patch"

--- linux-2.6.20-rc6nv/drivers/ata/libata-scsi.c	2007-01-28 16:59:58.000000000 -0600
+++ linux-2.6.20-rc6nvedit/drivers/ata/libata-scsi.c	2007-01-28 17:30:12.000000000 -0600
@@ -983,11 +983,10 @@ static unsigned int ata_scsi_start_stop_
 		}
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
-	} else {
-		tf->nsect = 0;	/* time period value (0 implies now) */
-		tf->command = ATA_CMD_STANDBY;
-		/* Consider: ATA STANDBY IMMEDIATE command */
-	}
+	} else
+		/* Issue ATA STANDBY IMMEDIATE command */
+		tf->command = ATA_CMD_STANDBYNOW1;
+
 	/*
 	 * Standby and Idle condition timers could be implemented but that
 	 * would require libata to implement the Power condition mode page

--------------080408040500080807070707--

