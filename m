Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbXHaUF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbXHaUF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXHaUFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:05:20 -0400
Received: from h155.mvista.com ([63.81.120.155]:44941 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752091AbXHaUFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:05:17 -0400
Message-ID: <46D87525.6060303@ru.mvista.com>
Date: Sat, 01 Sep 2007 00:08:05 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] hpt366: UltraDMA filter for SATA cards (take 3)
References: <200708252328.03826.sshtylyov@ru.mvista.com> <200708271922.23349.bzolnier@gmail.com>
In-Reply-To: <200708271922.23349.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>The Marvell bridge chips used on HighPoint SATA cards do not seem to support
>>the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes, so the driver needs
>>to account for this in the udma_filter() method.  In order to achieve that, do
>>the following changes:

>>- install the method for all chips, not only HPT36x/370 and impove the code
>>  formatting by killing the extra tabs while at it;

>>- add to the end of the 'switch' statement in the method cases for HPT372[AN]
>>  and HPT374 chips upon which the known SATA cards are based;

>>- use hwif->ultra_mask as a default mask for the ide_dma_filter() method to
>>  behave correctly;

>>- move the HPT370[A] cases below the HPT36x case for consistency...

>>Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

>>---
>>Argh!  I've managed to put = instead of &= here and there, so please disregard
>>the take #2... :-/

> Not to mention that there was already take #2 on Aug 19 2007
> (the version of the patch which is currently in IDE quilt tree)...

    I've just changed my mind about which series it'd beliong too -- propply 
need to post [0/n] message before the series....

>>This version doesn't use explicit UltraDMA masks, so converting them to the
>>ATA_UDMA* is left for another, global patch.  This patch against the current

> I have already other patches which are based on the previous version of the
> patch and I don't find the idea of re-doing them especially tempting...

    Too bad. :-)
    I don't find the idea if the open coded masks depnding on HPT3*_ALLOW_ATA* 
for a catch all udma_filter() method especially tempting to. :-)

>>Linus' tree and unfortunately I was able to only compile test it since that
>>tree gives MODPOST warning and dies early on bootup.

>>Index: linux-2.6/drivers/ide/pci/hpt366.c
>>===================================================================
>>--- linux-2.6.orig/drivers/ide/pci/hpt366.c
>>+++ linux-2.6/drivers/ide/pci/hpt366.c
>>@@ -1,5 +1,5 @@
>> /*
>>- * linux/drivers/ide/pci/hpt366.c		Version 1.11	Aug 11, 2007
>>+ * linux/drivers/ide/pci/hpt366.c		Version 1.12	Aug 25, 2007
>>  *
>>  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
>>  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
>>@@ -114,6 +114,7 @@
>>  *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
>>  *   the register setting lists into the table indexed by the clock selected
>>  * - set the correct hwif->ultra_mask for each individual chip
>>+ * - add UltraDMA mode filtering for the HPT37[24] based SATA cards
>>  *	Sergei Shtylyov, <sshtylyov@ru.mvista.com> or <source@mvista.com>
>>  */
>> 
>>@@ -524,36 +525,38 @@ static int check_in_drive_list(ide_drive

> (the real) take #2 also updated hpt3xx_udma_filter() comment

     I've probably dropped that part in anticipation of adding mdma_filter... 
I agree -- future has always come. B-)

>> static u8 hpt3xx_udma_filter(ide_drive_t *drive)
>> {
>>-	struct hpt_info *info	= pci_get_drvdata(HWIF(drive)->pci_dev);
>>-	u8 mask;
>>+	ide_hwif_t *hwif	= HWIF(drive);
>>+	struct hpt_info *info	= pci_get_drvdata(hwif->pci_dev);
>>+	u8 mask 		= hwif->ultra_mask;
>> 
>> 	switch (info->chip_type) {
>>-	case HPT370A:
>>-		if (!HPT370_ALLOW_ATA100_5 ||
>>-		    check_in_drive_list(drive, bad_ata100_5))
>>-			return 0x1f;
>>-		else
>>-			return 0x3f;
>>-	case HPT370:
>>-		if (!HPT370_ALLOW_ATA100_5 ||
>>-		    check_in_drive_list(drive, bad_ata100_5))
>>-			mask = 0x1f;
>>-		else
>>-			mask = 0x3f;
>>-		break;
>> 	case HPT36x:
>>-		if (!HPT366_ALLOW_ATA66_4 ||
>>+		if (HPT366_ALLOW_ATA66_4 &&
>> 		    check_in_drive_list(drive, bad_ata66_4))
>>-			mask = 0x0f;
>>-		else
>>-			mask = 0x1f;
>>+			mask &= ~0x10;
>> 
>>-		if (!HPT366_ALLOW_ATA66_3 ||
>>+		if (HPT366_ALLOW_ATA66_3 &&
>> 		    check_in_drive_list(drive, bad_ata66_3))
>>-			mask = 0x07;
>>+			mask &= ~0x08;
>> 		break;
>>+	case HPT370 :
>>+	case HPT370A:
>>+		if (HPT370_ALLOW_ATA100_5 &&
>>+		    check_in_drive_list(drive, bad_ata100_5))
>>+			mask &= ~0x20;
>>+
>>+		if (info->chip_type == HPT370A)
>>+			return mask;
>>+		break;
>>+	case HPT372 :
>>+	case HPT372A:
>>+	case HPT372N:
>>+	case HPT374 :
>>+		if (ide_dev_is_sata(drive->id))
>>+			mask &= ~0x0e;
>>+		/* Fall thru */
>> 	default:
>>-		return 0x7f;
>>+		return mask;
>> 	}

> I really don't see the advantage of "mask &=" over the previous

    Considered the smaller code? ;-)

> code ("mask = ATA_UDMA*") which was just more readable IMO.

    Like I said, I don't want to be tied by HPT3*_ALLOW_ATA* here and there 
(BTW, this approach was in revision #0 which I've never published :-).

> I'm staying with (the real) take #2 of this patch for now.

    I'll respin RSN... but not take #2, alas. B-)

> Bart

MBR, Sergei
