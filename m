Return-Path: <linux-kernel-owner+w=401wt.eu-S1946189AbXBCAp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946189AbXBCAp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946195AbXBCAp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:45:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:27967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946194AbXBCApZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:45:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=O83zBz32pk2OyqxpPCo8QxNWCDf2eqNiUWBkwvroKVWK34b2/6xn0FL9kVnrY4wI1kyo4VpbMncpuhqdz1ilv7W/Kq2d+tTYu4NzF+g7NS1XW+ZC+yEgS5fjK2Rmjfn6BoYRQjDXrR0nPDXmknp0ofBcMdGs014/VB58AQMWB2Y=
Message-ID: <45C3DC48.1040505@gmail.com>
Date: Sat, 03 Feb 2007 01:50:16 +0100
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>	 <20070119003226.14846.87052.sendpatchset@localhost.localdomain>	 <45B4FFBD.40507@ru.mvista.com> <58cb370e0702021606m4eb6f682xfa4bf769d398cf9@mail.gmail.com>
In-Reply-To: <58cb370e0702021606m4eb6f682xfa4bf769d398cf9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sergei Shtylyov wrote:
> 
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
>> [PATCH] ide: fix UDMA/MWDMA/SWDMA masks
> 
>> * use 0x00 instead of 0x80 to disable ->{ultra,mwdma,swdma}_mask
>> * add udma_mask field to ide_pci_device_t and use it to initialize
>>   ->ultra_mask in aec62xx, pdc202xx_new and pdc202xx_old drivers
>> * fix UDMA masks to match with chipset specific *_ratemask()
>>   (alim15x3, hpt366, serverworks and siimage drivers need UDMA mask
>>    filtering method - done in the next patch)
> 
>    More issues with aec62xx.c driver, found after looking at the next
> patch...
> 
>> Index: b/drivers/ide/pci/aec62xx.c
>> ===================================================================
>> --- a/drivers/ide/pci/aec62xx.c
>> +++ b/drivers/ide/pci/aec62xx.c
>> @@ -270,11 +270,13 @@ static unsigned int __devinit init_chips
>>
>>  static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
>>  {
>> +     struct pci_dev *dev = hwif->pci_dev;
>> +
>>       hwif->autodma = 0;
>>       hwif->tuneproc = &aec62xx_tune_drive;
>>       hwif->speedproc = &aec62xx_tune_chipset;
>>
>> -     if (hwif->pci_dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
>> +     if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
>>               hwif->serialized = hwif->channel;
>>
>>       if (hwif->mate)
>> @@ -286,7 +288,16 @@ static void __devinit init_hwif_aec62xx(
>>               return;
>>       }
>>
>> -     hwif->ultra_mask = 0x7f;
>> +     hwif->ultra_mask = hwif->cds->udma_mask;
>> +
>> +     /* atp865 and atp865r */
>> +     if (hwif->ultra_mask == 0x3f) {
>> +             unsigned long io = pci_resource_start(dev, 4);
>> +
>> +             if (inb(io) & 0x10)
>> +                     hwif->ultra_mask = 0x7f; /* udma0-6 */
>> +     }
>> +
> 
>    Looks like another intruduced buglet: you're reading DMA command, but
> aec62xx_ratemask() was reading DMA status originally for this bit.

Doh, fixed.  Thanks for catching this.

>>       hwif->mwdma_mask = 0x07;
>>       hwif->swdma_mask = 0x07;
> 
>    Hm, caught another nit: this driver doesn't actually support single-word
> DMA modes... :-)

added to TODO

>> Index: b/drivers/ide/pci/alim15x3.c
>> ===================================================================
>> --- a/drivers/ide/pci/alim15x3.c
>> +++ b/drivers/ide/pci/alim15x3.c
>> @@ -765,8 +765,17 @@ static void __devinit init_hwif_common_a
>>
>>       hwif->atapi_dma = 1;
>>
>> -     if (m5229_revision > 0x20)
>> -             hwif->ultra_mask = 0x7f;
>> +     if (m5229_revision <= 0x20)
>> +             hwif->ultra_mask = 0x00; /* no udma */
>> +     else if (m5229_revision < 0xC2)
>> +             hwif->ultra_mask = 0x07; /* udma0-2 */
>> +     else if (m5229_revision == 0xC2 || m5229_revision == 0xC3)
>> +             hwif->ultra_mask = 0x1f; /* udma0-4 */
>> +     else if (m5229_revision == 0xC4)
>> +             hwif->ultra_mask = 0x3f; /* udma0-5 */
>> +     else
>> +             hwif->ultra_mask = 0x7f; /* udma0-6 */
>> +
>>       hwif->mwdma_mask = 0x07;
>>       hwif->swdma_mask = 0x07;
> 
>    Ugh, I'm not seeing any *actual* support for MW/SW DMA in this driver...
> And PIO setting via speedproc() method is broken -- it passes to tuneproc()
> method mode number not biased by -XFER_PIO_0 beforehand.  Will cook up some
> patch, maybe... :-/

Please do, I added this to IDE TODO to not forget about the issue...

Thanks,
Bart

