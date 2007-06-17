Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbXFQRD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbXFQRD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 13:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXFQRDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 13:03:19 -0400
Received: from h155.mvista.com ([63.81.120.155]:16308 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753463AbXFQRDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 13:03:18 -0400
Message-ID: <467569BD.9070506@ru.mvista.com>
Date: Sun, 17 Jun 2007 21:05:01 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ide: add short cables support
References: <200706101558.08990.bzolnier@gmail.com> <4672FC74.6020601@ru.mvista.com> <200706160140.28380.bzolnier@gmail.com>
In-Reply-To: <200706160140.28380.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>This patch allows users to override both host and device side cable detection
>>>with "ideX=ata66" kernel parameter.  Thanks to this it should be now possible
>>>to use UDMA > 2 modes on systems (laptops mainly) which use short 40-pin cable
>>>instead of 80-pin one.

>>>Next patches add automatic detection of some systems using short cables.

>>>Changes:

>>>* Rename hwif->udma_four to hwif->cbl and make it u8.

>>    Not sure if already short word "cable" was worth further shortening. :-)

> The name/usage is the same as in libata.

> When we add ->cable_detect method it will make grepping easier. 8)

    Hm... :-)

>>>Index: b/drivers/ide/pci/alim15x3.c
>>>===================================================================
>>>--- a/drivers/ide/pci/alim15x3.c
>>>+++ b/drivers/ide/pci/alim15x3.c
>>>@@ -594,7 +594,7 @@ out:
>>>  *	FIXME: frobs bits that are not defined on newer ALi devicea
>>>  */
>>> 
>>>-static unsigned int __devinit ata66_ali15x3 (ide_hwif_t *hwif)
>>>+static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
>>> {
>>> 	struct pci_dev *dev	= hwif->pci_dev;
>>> 	unsigned int ata66	= 0;
>>>@@ -657,7 +657,7 @@ static unsigned int __devinit ata66_ali1
>>> 
>>> 	local_irq_restore(flags);
>>> 
>>>-	return(ata66);
>>>+	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;

>>    Ahem... I'd think it was about the right time to fix the abomination which
>>those ata66 and cable_80_pin[2] are, something like this:

>>static unsigned int __devinit ata66_ali15x3 (ide_hwif_t *hwif)
>>{
>>         struct pci_dev *dev     = hwif->pci_dev;
>>         unsigned int cbl        = ATA_CBL_PATA40;
>>         unsigned long flags;
>>         u8 tmpbyte, mask	= hwif->channel ? 0x02 : 0x01;
>>
>>         local_irq_save(flags); /* Not sure if it's necessary... */
>>
>>         if (m5229_revision >= 0xC2) {
>>                 /*
>>                  * Ultra66 cable detection (from Host View)
>>                  * m5229, 0x4a, bit0: primary, bit1: secondary
>>		 * 0: 80 pin, 1: 40 pin
>>                  */
>>                 pci_read_config_byte(dev, 0x4a, &tmpbyte);
>>                 /*
>>                  * Allow ata66 if cable of current channel has 80 pins
>>                  */
>>                 cbl = (tmpbyte & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
>>         } else {

>>[Following code frankly speaking has no business being in this function]

> patch #3/5 already takes care of cable_80_pin[2] part,

    I really should have looked thru all the series but lacked the time. :-<

> ata66 part was left as an exercise for the reader ;-)

    Hm, now that I've looked at that patch I saw both these things killed.
What, you don't know your own code? ;-)

>>         local_irq_restore(flags); /* Not sure if it's necessary... */

>>	return cbl;

>>> }

>>> /**
>>>Index: b/drivers/ide/pci/serverworks.c
>>>===================================================================
>>>--- a/drivers/ide/pci/serverworks.c
>>>+++ b/drivers/ide/pci/serverworks.c
>>>@@ -329,9 +329,9 @@ static unsigned int __devinit init_chips
>>> 	return dev->irq;
>>> }
>>> 
>>>-static unsigned int __devinit ata66_svwks_svwks (ide_hwif_t *hwif)
>>>+static u8 __devinit ata66_svwks_svwks(ide_hwif_t *hwif)
>>> {
>>>-	return 1;
>>>+	return ATA_CBL_PATA80;
>>> }

>>    Hm, worth folding into ata66_svwks()...

> Yes and no...

> Alan did a very nice rewrite of cable detection code for pata_serverworks.c
> driver.  We may be better off just back-porting it (patches are welcomed).

    Thanks, no. I still have much to do. :-)

>>>Index: b/drivers/ide/pci/sis5513.c
>>>===================================================================
>>>--- a/drivers/ide/pci/sis5513.c
>>>+++ b/drivers/ide/pci/sis5513.c
>>>@@ -796,7 +796,7 @@ static unsigned int __devinit init_chips
>>> 	return 0;
>>> }
>>> 
>>>-static unsigned int __devinit ata66_sis5513 (ide_hwif_t *hwif)
>>>+static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
>>> {
>>> 	u8 ata66 = 0;
>>> 
>>>@@ -811,7 +811,8 @@ static unsigned int __devinit ata66_sis5
>>> 		pci_read_config_byte(hwif->pci_dev, 0x48, &reg48h);
>>> 		ata66 = (reg48h & mask) ? 0 : 1;
>>> 	}
>>>-        return ata66;
>>>+
>>>+	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
>>> }

>>    That doesn't look good as well. I think we should part with 'ata66' 
>>variable here completely...

> Could be fixed in the follow-up patch as we should also split ata66_sis5513()
> into two separate functions (one for chipset_family >= ATA_133 and one for
> chipset_family >= ATA_66).

    That's only worth doing if you actually intend to introduce cable_detect() 
method...

> Thanks,
> Bart

MBR, Sergei

