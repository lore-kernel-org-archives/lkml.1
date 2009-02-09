Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbZBIRGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbZBIRGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZBIRFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:05:52 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:44324 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbZBIRFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:05:51 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [resend] Resume from hibernation fails with pata_it821x RAID volume
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Mon, 9 Feb 2009 18:05:39 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902091805.42285.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009 18:56:35 Alan Cox wrote:
> >     See CodingStyle chapter 8 for the preferred multiline comment style.
> >
> > > +		memset(&id[ATA_ID_SERNO], 0x20, ATA_ID_SERNO_LEN);
> >
> >     Why not ' '?
> >
> > MBR, Sergei
>
> Digging into the docs the RAID serial number (and what that means isn't
> defined anywhere I can see) is byte offset 54-73 in each of the 4 128
> byte blocks returned by the chip status query we do at boot
> (it821x_probe_firmware).

Yes, found it there. But it seems to be the same number as present in the 
IDENTIFY data. It contains date and time of boot (matches RAID_SERIAL_NUMBER 
structure found in iteraid.h in driver source from ITE) instead of date and 
time of RAID creation.

I don't have any better solution than the patch below. Generating the serial
number from drives containing the array is not an option as it prevents
resume if one of the drives fails.


Fix resume on pata_it821x RAID volume by clearing the serial number in 
IDENTIFY data. The serial number is different on each boot, breaking
validation on resume from hibernation.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.28-orig/drivers/ata/pata_it821x.c	2009-01-02 17:18:36.000000000 +0100
+++ linux/drivers/ata/pata_it821x.c	2009-02-09 17:52:21.000000000 +0100
@@ -561,6 +561,9 @@
 		id[83] |= 0x4400;	/* Word 83 is valid and LBA48 */
 		id[86] |= 0x0400;	/* LBA48 on */
 		id[ATA_ID_MAJOR_VER] |= 0x1F;
+		/* Clear the serial number because it's different each boot
+		   which breaks validation on resume */
+		memset(&id[ATA_ID_SERNO], ' ', ATA_ID_SERNO_LEN);
 	}
 	return err_mask;
 }



-- 
Ondrej Zary
