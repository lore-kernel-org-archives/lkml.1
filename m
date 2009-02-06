Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZBFNMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZBFNMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZBFNMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:12:22 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:55162 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbZBFNMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:12:21 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] [resend] Resume from hibernation fails with pata_it821x RAID volume
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Fri, 6 Feb 2009 14:12:07 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902061412.09839.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
hibernation didn't work for me since I started to use IT8212 controller. Now I 
did some debugging (booting with no_console_suspend init=/bin/sh).

Found that resume fails (2.6.28) with "serial number mismatch 'some 
garbage' != 'some other garbage'" and "revalidation failed" messages. That's 
because the controller firmware fills different serial number in the IDENTIFY 
every boot.

The patch below fixes the resume simply clearing the serial number. The proper 
fix would be probably to fill in the serial number of the RAID volume 
instead. I assume that there must be something like that stored on the drives 
but I don't know where.


Fix resume on pata_it821x RAID volume by clearing the serial number in 
IDENTIFY data, which is otherwise different on each boot.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.28-orig/drivers/ata/pata_it821x.c	2009-01-02 17:18:36.000000000 
+0100
+++ linux/drivers/ata/pata_it821x.c	2009-02-02 17:47:57.000000000 +0100
@@ -561,6 +561,9 @@
 		id[83] |= 0x4400;	/* Word 83 is valid and LBA48 */
 		id[86] |= 0x0400;	/* LBA48 on */
 		id[ATA_ID_MAJOR_VER] |= 0x1F;
+		/* Clear the serial number because it's different each boot
+		   which breaks validation on resume */
+		memset(&id[ATA_ID_SERNO], 0x20, ATA_ID_SERNO_LEN);
 	}
 	return err_mask;
 }


-- 
Ondrej Zary
