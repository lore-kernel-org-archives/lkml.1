Return-Path: <linux-kernel-owner+w=401wt.eu-S1946082AbXBBVMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946082AbXBBVMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946088AbXBBVMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:12:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:55667 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946082AbXBBVMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:12:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=H+hroIs2aNrYm/gnNUWsa2uKKbjIXtWphQes7XU/FaMRxDXuanxjiV8ZPGwGCXzImSPBH4UPe7JJT1yu3NxMiFfLLgRFclGn9soNGtavLFSH47pdP1Z8q/FVxkNop4wuX9fIYZtVtO9NOqs3WbaPhEoCwezda2XTMHWb90A/0Bs=
Message-ID: <45C3AA48.6030104@gmail.com>
Date: Fri, 02 Feb 2007 22:16:56 +0100
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] ide: make ide_hwif_t.ide_dma_host_on void
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>	 <20070119003220.14846.14258.sendpatchset@localhost.localdomain>	 <45B27F9A.9070001@ru.mvista.com> <58cb370e0702021128g15cac87ar507c20e78ded9464@mail.gmail.com>
In-Reply-To: <58cb370e0702021128g15cac87ar507c20e78ded9464@mail.gmail.com>
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
>> [PATCH] ide: make ide_hwif_t.ide_dma_host_on void
> 
>> * since ide_hwif_t.ide_dma_host_on is called either when drive->using_dma == 1
>>   or when return value is discarded make it void, also drop "ide_" prefix
>> * make __ide_dma_host_on() void and drop "__" prefix
> 
>    Below are some nits which also apply to the previous patch...
> 
>> Index: b/drivers/ide/pci/atiixp.c
>> ===================================================================
>> --- a/drivers/ide/pci/atiixp.c
>> +++ b/drivers/ide/pci/atiixp.c
>> @@ -101,7 +101,7 @@ static u8 atiixp_dma_2_pio(u8 xfer_rate)
>>       }
>>  }
>>
>> -static int atiixp_ide_dma_host_on(ide_drive_t *drive)
>> +static void atiixp_ide_dma_host_on(ide_drive_t *drive)
>>  {
> 
>    Would seem logical to get rid of ide_ in this function's name also...

fixed in v2 version of the patch, thanks

>>       struct pci_dev *dev = drive->hwif->pci_dev;
>>       unsigned long flags;
> [...]
>> Index: b/drivers/ide/pci/sgiioc4.c
>> ===================================================================
>> --- a/drivers/ide/pci/sgiioc4.c
>> +++ b/drivers/ide/pci/sgiioc4.c
> [...]
>> @@ -307,13 +307,8 @@ sgiioc4_ide_dma_test_irq(ide_drive_t * d
>>       return sgiioc4_checkirq(HWIF(drive));
>>  }
>>
>> -static int
>> -sgiioc4_ide_dma_host_on(ide_drive_t * drive)
>> +static void sgiioc4_ide_dma_host_on(ide_drive_t * drive)
> 
>    Same comment here...

ditto

I also fixed the previous patch.

>>  {
>> -     if (drive->using_dma)
>> -             return 0;
>> -
>> -     return 1;
>>  }
>>
>>  static void sgiioc4_ide_dma_host_off(ide_drive_t * drive)
>> @@ -610,7 +605,7 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
>>       hwif->ide_dma_on = &sgiioc4_ide_dma_on;
>>       hwif->dma_off_quietly = &sgiioc4_ide_dma_off_quietly;
>>       hwif->ide_dma_test_irq = &sgiioc4_ide_dma_test_irq;
>> -     hwif->ide_dma_host_on = &sgiioc4_ide_dma_host_on;
>> +     hwif->dma_host_on = &sgiioc4_ide_dma_host_on;
>>       hwif->dma_host_off = &sgiioc4_ide_dma_host_off;
>>       hwif->ide_dma_lostirq = &sgiioc4_ide_dma_lostirq;
>>       hwif->ide_dma_timeout = &__ide_dma_timeout;
> 
>    Unrelated note: not sure why this default value needs explicit
> assignemnt...

SGIIOC4 is not PCI IDE BMDMA compatible - it uses its own SG list
format which supports 64-bit addresses.  Thus sgiioc4 driver doesn't use
the default IDE PCI initialization code [ ide_setup_pci_device[s]() ].

The default values are only assigned when using ide_setup_pci_device[s]():

ide_setup_pci_device[s]()
	do_ide_setup_pci_device()
		ide_pci_setup_ports()
			->init_setup_dma() [ or ide_hwif_setup_dma() ]
				->init_dma [ or ide_setup_dma() ]

Thanks,
Bart

