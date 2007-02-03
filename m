Return-Path: <linux-kernel-owner+w=401wt.eu-S1946183AbXBCAey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946183AbXBCAey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933406AbXBCAew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:34:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:18750 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933402AbXBCAev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:34:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Del23SxyOiFO/3VDlFuUyctxc1H7N38GMukGwivH6U3xx+ELDwj3yMzAfHkBORanSArMk8pykGS6HHs7x14HbnUaVd3ucIDhBwhyq1ITSKyoNY3qlXhP0gjYU0EpYaG8XvLI6zremtu7MRVuoPHwQ9P0cz3O3JlZFkfs5sYDSKg=
Message-ID: <45C3D9CE.8020202@gmail.com>
Date: Sat, 03 Feb 2007 01:39:42 +0100
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>	 <20070119003226.14846.87052.sendpatchset@localhost.localdomain>	 <45B4E401.6070208@ru.mvista.com> <58cb370e0702021606v4efa6143lf060e6aab9782c35@mail.gmail.com>
In-Reply-To: <58cb370e0702021606v4efa6143lf060e6aab9782c35@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

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
>    More nit picking (-:
> 
>> Index: b/drivers/ide/pci/cmd64x.c
>> ===================================================================
>> --- a/drivers/ide/pci/cmd64x.c
>> +++ b/drivers/ide/pci/cmd64x.c
>> @@ -695,9 +695,10 @@ static void __devinit init_hwif_cmd64x(i
>>       hwif->swdma_mask = 0x07;
>>
>>       if (dev->device == PCI_DEVICE_ID_CMD_643)
>> -             hwif->ultra_mask = 0x80;
>> +             hwif->ultra_mask = 0x00;
>>       if (dev->device == PCI_DEVICE_ID_CMD_646)
>> -             hwif->ultra_mask = (class_rev > 0x04) ? 0x07 : 0x80;
>> +             hwif->ultra_mask =
>> +                     (class_rev == 0x05 || class_rev == 0x07) ? 0x07 : 0x00;
>>       if (dev->device == PCI_DEVICE_ID_CMD_648)
>>               hwif->ultra_mask = 0x1f;
> 
>    Hm, well, this doesn't look consistent with the changes in other drivers.
> This driver asks for explicit hwif->cds->ultra_mask initializers, IMO...
>    You'd only have to check for PCI-646 revisions < 5 then...

reworked

>> Index: b/drivers/ide/pci/piix.c
>> ===================================================================
>> --- a/drivers/ide/pci/piix.c
>> +++ b/drivers/ide/pci/piix.c
>> @@ -493,7 +493,7 @@ static void __devinit init_hwif_piix(ide
>>               case PCI_DEVICE_ID_INTEL_82371FB_0:
>>               case PCI_DEVICE_ID_INTEL_82371FB_1:
>>               case PCI_DEVICE_ID_INTEL_82371SB_1:
>> -                     hwif->ultra_mask = 0x80;
>> +                     hwif->ultra_mask = 0x00;
>>                       break;
>>               case PCI_DEVICE_ID_INTEL_82371AB:
>>               case PCI_DEVICE_ID_INTEL_82443MX_1:
>> @@ -501,6 +501,10 @@ static void __devinit init_hwif_piix(ide
>>               case PCI_DEVICE_ID_INTEL_82801AB_1:
>>                       hwif->ultra_mask = 0x07;
>>                       break;
>> +             case PCI_DEVICE_ID_INTEL_82801AA_1:
>> +             case PCI_DEVICE_ID_INTEL_82372FB_1:
>> +                     hwif->ultra_mask = 0x1f;
>> +                     break;
> 
>    Alas, I'm afraid this part is wrong!
>    At least, the cable detection should work for 82801AA the same way as for
> the 82801Bx and newer chips, if Intel's datasheet is to be trusted... I think
> we should fall thru here.

yes (extra "break:" shouldn't be there), fixed

>>               default:
>>                       if (!hwif->udma_four)
>>                               hwif->udma_four = piix_cable_detect(hwif);
> 
>    This one also certainly asks for explicit hwif->cds->ultra_mask
> initializers... Thus almost all of this switch statement could go away...
	
Alas doing it now would make the nice DECLARE_PIIX_DEV() macro go away
(=> a lot of duplicated code)... could be done in the future...

Thanks,
Bart

