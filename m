Return-Path: <linux-kernel-owner+w=401wt.eu-S1946131AbXBBWer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946131AbXBBWer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 17:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946133AbXBBWer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 17:34:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:23177 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946129AbXBBWeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 17:34:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mlT+jukxdqk8Sfi1BdV444Mw28o4T8ju8E9s+7AD8VJZe0u8n+OV/P0FyXFot9Bmg68b9zZ9I9i7/P5u/w2TBF8Bpwt9Zk15ZvBsP75DwV8QggV+TEHxvDjeiRSlpCo14FIQ3Aig92AwntfJOIMoWBDhUKctiZgDh1GHwpJ7jv0=
Message-ID: <45C3BDA8.8040201@gmail.com>
Date: Fri, 02 Feb 2007 23:39:36 +0100
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/15] ide: make ide_hwif_t.ide_dma_{host_off,off_quietly}
 void
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>	 <20070119003213.14846.1366.sendpatchset@localhost.localdomain>	 <45B281FA.9050107@ru.mvista.com> <58cb370e0702021206h205ff983r88fb4bdbea42ed9f@mail.gmail.com>
In-Reply-To: <58cb370e0702021206h205ff983r88fb4bdbea42ed9f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sergei Shtylyov wrote:
> 
> Hello again. :-)
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
>> [PATCH] ide: make ide_hwif_t.ide_dma_{host_off,off_quietly} void
> 
>    Below are my nits on the patch itself, and the code it changes.
> 
>> Index: b/drivers/ide/pci/atiixp.c
>> ===================================================================
>> --- a/drivers/ide/pci/atiixp.c
>> +++ b/drivers/ide/pci/atiixp.c
>> @@ -121,7 +121,7 @@ static int atiixp_ide_dma_host_on(ide_dr
>>       return __ide_dma_host_on(drive);
>>  }
>>
>> -static int atiixp_ide_dma_host_off(ide_drive_t *drive)
>> +static void atiixp_ide_dma_host_off(ide_drive_t *drive)
>>  {
>>       struct pci_dev *dev = drive->hwif->pci_dev;
>>       unsigned long flags;
> [...]
>> @@ -306,7 +306,7 @@ static void __devinit init_hwif_atiixp(i
>>               hwif->udma_four = 0;
>>
>>       hwif->ide_dma_host_on = &atiixp_ide_dma_host_on;
>> -     hwif->ide_dma_host_off = &atiixp_ide_dma_host_off;
>> +     hwif->dma_host_off = &atiixp_ide_dma_host_off;
>>       hwif->ide_dma_check = &atiixp_dma_check;
>>       if (!noautodma)
>>               hwif->autodma = 1;
> 
>    Would seem logical to get rid of ide_ in the function's name also...

done

>> Index: b/drivers/ide/pci/sgiioc4.c
>> ===================================================================
>> --- a/drivers/ide/pci/sgiioc4.c
>> +++ b/drivers/ide/pci/sgiioc4.c
>> @@ -282,12 +282,11 @@ sgiioc4_ide_dma_on(ide_drive_t * drive)
>>       return HWIF(drive)->ide_dma_host_on(drive);
>>  }
>>
>> -static int
>> -sgiioc4_ide_dma_off_quietly(ide_drive_t * drive)
>> +static void sgiioc4_ide_dma_off_quietly(ide_drive_t *drive)
>>  {
>>       drive->using_dma = 0;
>>
>> -     return HWIF(drive)->ide_dma_host_off(drive);
>> +     drive->hwif->dma_host_off(drive);
>>  }
>>
>>  static int sgiioc4_ide_dma_check(ide_drive_t *drive)
>> @@ -317,12 +316,9 @@ sgiioc4_ide_dma_host_on(ide_drive_t * dr
>>       return 1;
>>  }
>>
>> -static int
>> -sgiioc4_ide_dma_host_off(ide_drive_t * drive)
>> +static void sgiioc4_ide_dma_host_off(ide_drive_t * drive)
>>  {
>>       sgiioc4_clearirq(drive);
>> -
>> -     return 0;
>>  }
>>
>>  static int
>> @@ -612,10 +608,10 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
>>       hwif->ide_dma_end = &sgiioc4_ide_dma_end;
>>       hwif->ide_dma_check = &sgiioc4_ide_dma_check;
>>       hwif->ide_dma_on = &sgiioc4_ide_dma_on;
>> -     hwif->ide_dma_off_quietly = &sgiioc4_ide_dma_off_quietly;
>> +     hwif->dma_off_quietly = &sgiioc4_ide_dma_off_quietly;
>>       hwif->ide_dma_test_irq = &sgiioc4_ide_dma_test_irq;
>>       hwif->ide_dma_host_on = &sgiioc4_ide_dma_host_on;
>> -     hwif->ide_dma_host_off = &sgiioc4_ide_dma_host_off;
>> +     hwif->dma_host_off = &sgiioc4_ide_dma_host_off;
>>       hwif->ide_dma_lostirq = &sgiioc4_ide_dma_lostirq;
>>       hwif->ide_dma_timeout = &__ide_dma_timeout;
> 
>    The same here...

done

>> Index: b/drivers/ide/pci/sl82c105.c
>> ===================================================================
>> --- a/drivers/ide/pci/sl82c105.c
>> +++ b/drivers/ide/pci/sl82c105.c
>> @@ -261,26 +261,24 @@ static int sl82c105_ide_dma_on (ide_driv
>>
>>       if (config_for_dma(drive)) {
>>               config_for_pio(drive, 4, 0, 0);
> 
>   Ugh, this forces PIO4 on fallback... and dma_on() doesn't select any modes
> in any other driver but this one. :-/

>From looking at config_for_dma() it seems that it is a bug and it is safe to
remove config_for_pio() call (as your "[PATCH] sl82c105: DMA support fixes" does).

>> -             return HWIF(drive)->ide_dma_off_quietly(drive);
>> +             drive->hwif->dma_off_quietly(drive);
>> +             return 0;
>>       }
>>       printk(KERN_INFO "%s: DMA enabled\n", drive->name);
>>       return __ide_dma_on(drive);
>>  }
>>
>> -static int sl82c105_ide_dma_off_quietly (ide_drive_t *drive)
>> +static void sl82c105_ide_dma_off_quietly(ide_drive_t *drive)
> 
>    Also worth renaming...

done

>>  {
>>       u8 speed = XFER_PIO_0;
>> -     int rc;
>> -
>> +
>>       DBG(("sl82c105_ide_dma_off_quietly(drive:%s)\n", drive->name));
>>
>> -     rc = __ide_dma_off_quietly(drive);
>> +     ide_dma_off_quietly(drive);
>>       if (drive->pio_speed)
> 
>    Should always be non-zero since explicitly initialized.

yes

>>               speed = drive->pio_speed - XFER_PIO_0;
>>       config_for_pio(drive, speed, 0, 1);
>>       drive->current_speed = drive->pio_speed;
> 
>    dma_off() shouldn't be changing current_speed IMHO.

yep and your "[PATCH] sl82c105: DMA support fixes" fixes it

Bart
