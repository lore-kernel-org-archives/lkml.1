Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZFJHaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZFJHaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 03:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZFJH34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 03:29:56 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:6503 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075AbZFJH3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 03:29:55 -0400
From: Wolfgang =?utf-8?q?M=C3=BCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Wed, 10 Jun 2009 09:29:49 +0200
User-Agent: KMail/1.9.10
Cc: "David Brownell" <david-b@pacbell.net>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905250243.46984.david-b@pacbell.net> <200905251659.17396.wolfgang.mues@auerswald.de> <20090609200750.2fa38dfe@mjolnir.ossman.eu>
In-Reply-To: <20090609200750.2fa38dfe@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200906100929.49553.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5A7Vm54001085

Pierre,
Am Dienstag, 9. Juni 2009 schrieb Pierre Ossman:> This however is more relevant. But OTOH, I don't think mmc_spi has a> better idea if the status can be trusted or not than a higher layer.
> But the other drivers don't attempt to interpret the response from the> card. They just give the response back up and let the next layer deal> with it.
> Indeed. But I don't like the fact that we're hiding interpretation of> responses down in the driver. It should be up to the layer issuing the> MMC request how the response should be interpreted.
OK. I think you are right. The driver should only do a reasonable mapping, and the upper layer should do the interpretion.
Have you noticed that I have posted a revised revision of the patch named 
[PATCH] mmc_spi: don't use EINVAL for possible transmission errors
on 26th of May 2009? This was based on the discussion with Matt Flemming and David Brownell. (I have changed the name of the patch because the oldname was missleading now).
> Indeed. I'll queue up the patch.
Please queue up the new patch. Patch appended for reference here:
From: Wolfgang Muees <wolfgang.mues@auerswald.de>
o This patch changes the reported error code for the responses  to a command from EINVAL to EFAULT/ENOSYS, as EINVAL is reserved  for non-recoverable host errors, and the responses from  the SD/MMC card may be because of recoverable transmission  errors in the command or in the response. Response codes  in SPI mode are NOT protected by a checksum, so don't trust them.
This is a revised, minimal-invasive patch version. As Pierre Ossmanpointed out, EINVAL should only be used for non-recoverable errors(and is used so in the whole rest of the mmc framework).
I have checked every instance of EINVAL in the mmc framework - no changes were needed here. 
This patch is neccessary for doing a sensible retry managment in the mmmc block layer (patch will follow).
Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
---diff -uprN 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c--- 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c 2009-04-08 11:11:20.000000000 +0200+++ 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c  2009-05-26 09:37:28.000000000 +0200@@ -335,15 +335,16 @@ checkstatus:
        /* Status byte: the entire seven-bit R1 response.  */        if (cmd->resp[0] != 0) {-               if ((R1_SPI_PARAMETER | R1_SPI_ADDRESS-                                     | R1_SPI_ILLEGAL_COMMAND)+               if ((R1_SPI_PARAMETER | R1_SPI_ADDRESS)                                & cmd->resp[0])-                       value = -EINVAL;+                       value = -EFAULT; /* Bad address */+               else if (R1_SPI_ILLEGAL_COMMAND & cmd->resp[0])+                       value = -ENOSYS; /* Function not implemented */                else if (R1_SPI_COM_CRC & cmd->resp[0])-                       value = -EILSEQ;+                       value = -EILSEQ; /* Illegal byte sequence */                else if ((R1_SPI_ERASE_SEQ | R1_SPI_ERASE_RESET)                                & cmd->resp[0])-                       value = -EIO;+                       value = -EIO;    /* I/O error */                /* else R1_SPI_IDLE, "it's resetting" */        }
---
best regards i. A. Wolfgang Mües-- Auerswald GmbH & Co. KGHardware DevelopmentTelefon: +49 (0)5306 9219 0Telefax: +49 (0)5306 9219 94 E-Mail: Wolfgang.Mues@Auerswald.deWeb: http://www.auerswald.de --------------------------------------------------------------Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 CremlingenRegistriert beim AG Braunschweig HRA 13289p.h.G Auerswald Geschäftsführungsges. mbHRegistriert beim AG Braunschweig HRB 7463Geschäftsführer: Dipl-Ing. Gerhard Auerswald���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
