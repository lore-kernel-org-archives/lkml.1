Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbXIAPqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbXIAPqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 11:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbXIAPqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 11:46:00 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:49032 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754098AbXIAPp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 11:45:59 -0400
Message-ID: <46D989DE.7030409@ru.mvista.com>
Date: Sat, 01 Sep 2007 19:48:46 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: John Sigler <linux.kernel@free.fr>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete
 Error }
References: <46D59ED2.4000900@free.fr> <20070829174657.09c7de3c@the-village.bc.nu> <46D67D09.6090101@free.fr> <46D69E03.9080403@vc.cvut.cz> <46D6B85C.5050509@free.fr>
In-Reply-To: <46D6B85C.5050509@free.fr>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

>>> What do the warnings mean? :-)

>> That your drive does not support set transfer mode/speed command at 

    Which is perfectly valid in the original ATA spec.

>> all, or that value which kernel tried is not supported by the drive...

    They just should skip programming the drive in this case, and set its 
default speed to the chipset.

>> I would guess that some contractor wrote firmware for device for PQI 
>> in one day for $100, and before that somebody else designed ATA-SD 
>> bridge for PQI for another $100.

    Hehe.

>> I guess that these two printk()s happen because drive claims to 
>> support pio0,1,2 - so Linux tries pio2, drive refuses, Linux tries 

   Which it shuldn't do since the drive only indicates its default mode (modes 
0-2 aren't included in the PIO support mask -- there's only 3 and 4 there).

>> pio1, drive refuses, and finally as pio0 is default, that one gets 
>> used.  Which is more or less confirmed by having no '*' sign in front 
>> of any pio - with "real" drives you should see '*' in front of one of 
>> listed dma/pio modes.

>> You should ask reseller how they can ship drive which does not conform 
>> to any ATA standard...

    Doesn't it conform to ATA? :-)

> I took drivers/ide/pci/via82cxxx.c and sprinkled ENTER/EXIT printk's.
> http://lxr.linux.no/source/drivers/ide/pci/via82cxxx.c

> via82cxxx_tune_drive() and via82cxxx_ide_dma_check() both call 
> via_set_drive() which calls ide_config_drive_speed().

> http://lxr.linux.no/source/drivers/ide/ide-iops.c#L769
> 
>   if (error)
>   {
>     (void) ide_dump_status(drive, "set_drive_speed_status", stat);
>     printk(KERN_INFO "EXIT %s error\n", __func__);
>     return error;
>   }

> Does someone know why error is not set to 0?

    Why it *does* set to one, you wanted to ask? Because it *does* get set 
after a loop above exits.

> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> VP_IDE: IDE controller at PCI slot 0000:00:07.1
> VP_IDE: chipset revision 6
> VP_IDE: not 100% native mode: will probe irqs later
> VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
>     ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:pio, hdb:pio
>     ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:pio, hdd:pio
> Probing IDE interface ide0...
> hda: PQI IDE DiskOnModule, ATA DISK drive
> ENTER via82cxxx_tune_drive
> ENTER via_set_drive
> ENTER ide_config_drive_speed
> hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
> hda: set_drive_speed_status: error=0x04 { DriveStatusError }
> EXIT ide_config_drive_speed error
> ENTER via_set_speed
> EXIT via_set_speed
> EXIT via_set_drive
> EXIT via82cxxx_tune_drive pio == 255

    255 is PIO auto-tuning request.

> ENTER via82cxxx_ide_dma_check
> ENTER via_set_drive
> ENTER ide_config_drive_speed
> hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
> hda: set_drive_speed_status: error=0x04 { DriveStatusError }

MBR, Sergei
