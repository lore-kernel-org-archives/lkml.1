Return-Path: <linux-kernel-owner+w=401wt.eu-S1766954AbXDSTkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766954AbXDSTkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766968AbXDSTkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:40:11 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:36144 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1766967AbXDSTkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:40:09 -0400
Message-ID: <4627C5D1.5010602@ru.mvista.com>
Date: Thu, 19 Apr 2007 23:41:05 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] ide: rework the code for selecting the best DMA
 transfer mode
References: <20070203135301.2546.54884.sendpatchset@localhost.localdomain> <20070203135323.2546.29438.sendpatchset@localhost.localdomain> <4627C386.9020407@ru.mvista.com>
In-Reply-To: <4627C386.9020407@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
>> [PATCH] ide: rework the code for selecting the best DMA transfer mode 
> 
> 
>> Depends on the "ide: fix UDMA/MWDMA/SWDMA masks" patch.
> 
> 
>   I'm now trying to rewrite hpt366.c to benefit more from these patches...
> and alas, this very patch seems to be breaking filtering (at least) in 
> this driver. :-]
> 
>> Index: b/drivers/ide/ide-dma.c
>> ===================================================================
>> --- a/drivers/ide/ide-dma.c
>> +++ b/drivers/ide/ide-dma.c
>> @@ -705,6 +705,80 @@ int ide_use_dma(ide_drive_t *drive)
>>  
>>  EXPORT_SYMBOL_GPL(ide_use_dma);
>>  
>> +static const u8 xfer_mode_bases[] = {
>> +    XFER_UDMA_0,
>> +    XFER_MW_DMA_0,
>> +    XFER_SW_DMA_0,
>> +};
>> +
>> +static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base)
>> +{
>> +    struct hd_driveid *id = drive->id;
>> +    ide_hwif_t *hwif = drive->hwif;
>> +    unsigned int mask = 0;
>> +
>> +    switch(base) {
>> +    case XFER_UDMA_0:
>> +        if ((id->field_valid & 4) == 0)
>> +            break;
>> +
>> +        mask = id->dma_ultra & hwif->ultra_mask;
>> +
>> +        if (hwif->udma_filter)
>> +            mask &= hwif->udma_filter(drive);
>> +
>> +        if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
>> +            mask &= 0x07;
 
>   Note the subtle difference between the old and new behavior: the old 
> driver code was applying UltraDMA filter *after*
> the cable type limit, and the new code does it *before*.

   Was there any particular reason to change that order?

[...]

>> Index: b/drivers/ide/pci/hpt366.c
>> ===================================================================
>> --- a/drivers/ide/pci/hpt366.c
>> +++ b/drivers/ide/pci/hpt366.c
>> @@ -513,43 +513,31 @@ static int check_in_drive_list(ide_drive
>>      return 0;
>>  }
>>  
>> -static u8 hpt3xx_ratemask(ide_drive_t *drive)
>> -{
>> -    struct hpt_info *info    = pci_get_drvdata(HWIF(drive)->pci_dev);
>> -    u8 mode            = info->max_mode;
>> -
>> -    if (!eighty_ninty_three(drive) && mode)
>> -        mode = min(mode, (u8)1);
>> -    return mode;
>> -}
>> -
>>  /*
>>   *    Note for the future; the SATA hpt37x we must set
>>   *    either PIO or UDMA modes 0,4,5
>>   */
>> - -static u8 hpt3xx_ratefilter(ide_drive_t *drive, u8 speed)
>> +
>> +static u8 hpt3xx_udma_filter(ide_drive_t *drive)
>>  {
>>      struct hpt_info *info    = pci_get_drvdata(HWIF(drive)->pci_dev);
>>      u8 chip_type        = info->chip_type;
>> -    u8 mode            = hpt3xx_ratemask(drive);
>> -
>> -    if (drive->media != ide_disk)
>> -        return min(speed, (u8)XFER_PIO_4);
>> +    u8 mode            = info->max_mode;
>> +    u8 mask;
>>  
>>      switch (mode) {
>>          case 0x04:
>> -            speed = min_t(u8, speed, XFER_UDMA_6);
>> +            mask = 0x7f;
>>              break;
>>          case 0x03:
>> -            speed = min_t(u8, speed, XFER_UDMA_5);
>> +            mask = 0x3f;
>>              if (chip_type >= HPT374)
>>                  break;
>>              if (!check_in_drive_list(drive, bad_ata100_5))
>>                  goto check_bad_ata33;
>>              /* fall thru */
>>          case 0x02:
>> -            speed = min_t(u8, speed, XFER_UDMA_4);
>> +            mask = 0x1f;
>>  
>>              /*
>>               * CHECK ME, Does this need to be changed to HPT374 ??
>> @@ -560,13 +548,13 @@ static u8 hpt3xx_ratefilter(ide_drive_t 
>>                  !check_in_drive_list(drive, bad_ata66_4))
>>                  goto check_bad_ata33;
>>  
>> -            speed = min_t(u8, speed, XFER_UDMA_3);
>> +            mask = 0x0f;
>>              if (HPT366_ALLOW_ATA66_3 &&
>>                  !check_in_drive_list(drive, bad_ata66_3))
>>                  goto check_bad_ata33;
>>              /* fall thru */
>>          case 0x01:
>> -            speed = min_t(u8, speed, XFER_UDMA_2);
>> +            mask = 0x07;
>>  
>>          check_bad_ata33:
>>              if (chip_type >= HPT370A)

>   This case 0x01 will *never* be hit for HPT370 chip with the new code, 
> therefore the filter won't get applied.

   Oh, and for HPT36x chips used with 40c cable too (unless they're artificaially reduced to UltraDMA/33 by the driver #define's).

>> @@ -576,10 +564,10 @@ static u8 hpt3xx_ratefilter(ide_drive_t 
>>              /* fall thru */
>>          case 0x00:
>>          default:
>> -            speed = min_t(u8, speed, XFER_MW_DMA_2);
>> +            mask = 0x00;
>>              break;

   Well, that case 0x00 should never actually happen.

>>      }
>> -    return speed;
>> +    return mask;
>>  }
> 
> [...]
> 
>> @@ -1270,6 +1272,7 @@ static void __devinit init_hwif_hpt366(i
>>      hwif->intrproc            = &hpt3xx_intrproc;
>>      hwif->maskproc            = &hpt3xx_maskproc;
>>      hwif->busproc            = &hpt3xx_busproc;
>> +    hwif->udma_filter        = &hpt3xx_udma_filter;
> 
> 
>   In fact, we only need a filter for HPT36x/370 chips -- I'll address it 
> in my patch.

>>      /*
>>       * HPT3xxN chips have some complications:

MBR, Sergei

