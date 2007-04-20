Return-Path: <linux-kernel-owner+w=401wt.eu-S2993106AbXDTR7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993106AbXDTR7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993078AbXDTR7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:59:34 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:47887 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993106AbXDTR7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:59:33 -0400
Message-ID: <4628FFBB.2090900@ru.mvista.com>
Date: Fri, 20 Apr 2007 22:00:27 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] ide: rework the code for selecting the best DMA
 transfer mode
References: <20070203135301.2546.54884.sendpatchset@localhost.localdomain> <20070203135323.2546.29438.sendpatchset@localhost.localdomain> <4627C386.9020407@ru.mvista.com> <4627C5D1.5010602@ru.mvista.com> <4628D64B.7080500@ru.mvista.com>
In-Reply-To: <4628D64B.7080500@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>> Index: b/drivers/ide/pci/hpt366.c
>>>> ===================================================================
>>>> --- a/drivers/ide/pci/hpt366.c
>>>> +++ b/drivers/ide/pci/hpt366.c
>>>> @@ -513,43 +513,31 @@ static int check_in_drive_list(ide_drive
>>>>      return 0;
>>>>  }
>>>>  
>>>> -static u8 hpt3xx_ratemask(ide_drive_t *drive)
>>>> -{
>>>> -    struct hpt_info *info    = pci_get_drvdata(HWIF(drive)->pci_dev);
>>>> -    u8 mode            = info->max_mode;
>>>> -
>>>> -    if (!eighty_ninty_three(drive) && mode)
>>>> -        mode = min(mode, (u8)1);
>>>> -    return mode;
>>>> -}
>>>> -
>>>>  /*
>>>>   *    Note for the future; the SATA hpt37x we must set
>>>>   *    either PIO or UDMA modes 0,4,5
>>>>   */
>>>> - -static u8 hpt3xx_ratefilter(ide_drive_t *drive, u8 speed)
>>>> +
>>>> +static u8 hpt3xx_udma_filter(ide_drive_t *drive)
>>>>  {
>>>>      struct hpt_info *info    = pci_get_drvdata(HWIF(drive)->pci_dev);
>>>>      u8 chip_type        = info->chip_type;
>>>> -    u8 mode            = hpt3xx_ratemask(drive);
>>>> -
>>>> -    if (drive->media != ide_disk)
>>>> -        return min(speed, (u8)XFER_PIO_4);
>>>> +    u8 mode            = info->max_mode;
>>>> +    u8 mask;
>>>>  
>>>>      switch (mode) {
>>>>          case 0x04:
>>>> -            speed = min_t(u8, speed, XFER_UDMA_6);
>>>> +            mask = 0x7f;
>>>>              break;
>>>>          case 0x03:
>>>> -            speed = min_t(u8, speed, XFER_UDMA_5);
>>>> +            mask = 0x3f;
>>>>              if (chip_type >= HPT374)
>>>>                  break;
>>>>              if (!check_in_drive_list(drive, bad_ata100_5))
>>>>                  goto check_bad_ata33;
>>>>              /* fall thru */
>>>>          case 0x02:
>>>> -            speed = min_t(u8, speed, XFER_UDMA_4);
>>>> +            mask = 0x1f;
>>>>  
>>>>              /*
>>>>               * CHECK ME, Does this need to be changed to HPT374 ??
>>>> @@ -560,13 +548,13 @@ static u8 hpt3xx_ratefilter(ide_drive_t 
>>>>                  !check_in_drive_list(drive, bad_ata66_4))
>>>>                  goto check_bad_ata33;
>>>>  
>>>> -            speed = min_t(u8, speed, XFER_UDMA_3);

  Hm, found a buglet in my former filtering rewrite -- the condition in the preceding if stmt should be a reverse one, and speed limitation to XFER_UDMA_3 should have been left under it.  With the current code, XFER_UDMA_2 limitation wouldn't have been applied if the same drive is not in both 'bad_ata66_4' and 'bad_ata66_3' lists -- this, however, actually is not the case since WDC AC310200R drive is in both these lists (maybe I wrote it this way because of this fact :-).

>>>> +            mask = 0x0f;
>>>>              if (HPT366_ALLOW_ATA66_3 &&
>>>>                  !check_in_drive_list(drive, bad_ata66_3))
>>>>                  goto check_bad_ata33;
>>>>              /* fall thru */
>>>>          case 0x01:
>>>> -            speed = min_t(u8, speed, XFER_UDMA_2);
>>>> +            mask = 0x07;
>>>>  
>>>>          check_bad_ata33:
>>>>              if (chip_type >= HPT370A)

>>>   This case 0x01 will *never* be hit for HPT370 chip with the new 
>>> code, therefore the filter won't get applied.

>>   Oh, and for HPT36x chips used with 40c cable too (unless they're 
>> artificaially reduced to UltraDMA/33 by the driver #define's).

>   It will still get applied since the code always resorts to looking up 
> the 'bad_ata33' list for HPT36x/370.
> I've got a bit muddled in my own code -- not sure if it got much clearer 
> after I'd untangled hpt3xx_ratemask() / hpt3xx_ratefilter() puzzle. :-)

  Yeah, I'm definitely having trouble understanding my own code after some months have passed... :-/

MBR, Sergei

