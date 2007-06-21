Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbXFUToB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbXFUToB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbXFUTnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:43:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:60231 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbXFUTnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:43:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NmBMPNwl3e2EnTxYqVMDHafH8wPZmps9PDOIAbDIb3nc6nJKN8NErU55pTWhbps4sJWCkhNUhuebqgQEJnWeNafIdXrBrHORYUSbw7Z03BnTJgueVAbUurFjD1R2CqtiQeTUcdGl0F3E2U9UsBvMGLiPRExc3CaQIAwnE3zs754=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 1/5] ide: add short cables support
Date: Thu, 21 Jun 2007 21:38:23 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200706101558.08990.bzolnier@gmail.com> <200706160140.28380.bzolnier@gmail.com> <467569BD.9070506@ru.mvista.com>
In-Reply-To: <467569BD.9070506@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706212138.23623.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 June 2007, Sergei Shtylyov wrote:

[ ... ]

> >>>Index: b/drivers/ide/pci/alim15x3.c
> >>>===================================================================
> >>>--- a/drivers/ide/pci/alim15x3.c
> >>>+++ b/drivers/ide/pci/alim15x3.c
> >>>@@ -594,7 +594,7 @@ out:
> >>>  *	FIXME: frobs bits that are not defined on newer ALi devicea
> >>>  */
> >>> 
> >>>-static unsigned int __devinit ata66_ali15x3 (ide_hwif_t *hwif)
> >>>+static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
> >>> {
> >>> 	struct pci_dev *dev	= hwif->pci_dev;
> >>> 	unsigned int ata66	= 0;
> >>>@@ -657,7 +657,7 @@ static unsigned int __devinit ata66_ali1
> >>> 
> >>> 	local_irq_restore(flags);
> >>> 
> >>>-	return(ata66);
> >>>+	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
> 
> >>    Ahem... I'd think it was about the right time to fix the abomination which
> >>those ata66 and cable_80_pin[2] are, something like this:
> 
> >>static unsigned int __devinit ata66_ali15x3 (ide_hwif_t *hwif)
> >>{
> >>         struct pci_dev *dev     = hwif->pci_dev;
> >>         unsigned int cbl        = ATA_CBL_PATA40;
> >>         unsigned long flags;
> >>         u8 tmpbyte, mask	= hwif->channel ? 0x02 : 0x01;
> >>
> >>         local_irq_save(flags); /* Not sure if it's necessary... */
> >>
> >>         if (m5229_revision >= 0xC2) {
> >>                 /*
> >>                  * Ultra66 cable detection (from Host View)
> >>                  * m5229, 0x4a, bit0: primary, bit1: secondary
> >>		 * 0: 80 pin, 1: 40 pin
> >>                  */
> >>                 pci_read_config_byte(dev, 0x4a, &tmpbyte);
> >>                 /*
> >>                  * Allow ata66 if cable of current channel has 80 pins
> >>                  */
> >>                 cbl = (tmpbyte & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
> >>         } else {
> 
> >>[Following code frankly speaking has no business being in this function]
> 
> > patch #3/5 already takes care of cable_80_pin[2] part,
> 
>     I really should have looked thru all the series but lacked the time. :-<
> 
> > ata66 part was left as an exercise for the reader ;-)
> 
>     Hm, now that I've looked at that patch I saw both these things killed.
> What, you don't know your own code? ;-)

It seems that I indeed dealt with ata66 part already... :-)

However I had something different in mind while writing about code gymnastics
- code unrelated to cable detection should be split off from ata66_ali15x3. 

Thanks,
Bart
