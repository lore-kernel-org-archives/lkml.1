Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbZADUdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbZADUdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 15:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZADUdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 15:33:05 -0500
Received: from homer.mvista.com ([63.81.120.155]:38414 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751140AbZADUdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 15:33:03 -0500
Message-ID: <49611CF4.9030103@ru.mvista.com>
Date: Sun, 04 Jan 2009 23:32:52 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Kirill Smelkov <kirr@mns.spb.ru>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kirr@landau.phys.spbu.ru,
       Dmitry Gryazin <gdu@mns.spb.ru>
Subject: Re: [PATCH] ide: motherboard-info based blacklist for ide-dma
References: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru> <495A4CC0.6000000@ru.mvista.com> <200812312012.46496.bzolnier@gmail.com>
In-Reply-To: <200812312012.46496.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>> We need to keep our kernel working on both legacy and modern hardware.
>>>       
>>> As it turned out, some boards don't have proper IDE DMA support for
>>> CompactFlash (CF) adaptors, because pin connectors which relate to DMA are left
>>> unsoldered (*).
>>>       
>>> To verify this we even bought external IDE CF adaptor which showed the same
>>> symthoms, and then manually soldered pins that were left dangling, and voila,
>>> DMA started to work!
>>>       
>>> Again, as they say, lots of manufacturers of not-so-new hardware did CF
>>> soldering by the wrong way with respect to DMA, so we need a workaround.
>>>       
>>> For this __ide_dma_bad_drive function is enhance to check not only drives
>>> blacklist but motherboards blacklist too.
>>>       
>>> Please apply before 2.6.29
>>>       
>>> (*) On IEI PCISA-C3/EDEN the kernel boots _very_ slowly, becuase we have lots
>>> of DMA timer expiry:
>>>       
>>>     <~30s pause>
>>>     hdc: dma_timer_epiry: dma_status == 0x21
>>>     hdc: DMA timeout error
>>>     ...
>>>     hdc: DMA disabled
>>>     ide1: dma reset
>>>
>>>     <and the whole story repeats:>
>>>     <~30s pause>
>>>     hdc: dma_timer_epiry: dma_status == 0x21
>>>     ...
>>>       
>>     Are you aware of ide_core.nodma= option which allows disabling DMA per 
>> interface/drive? Read Documentation/ide/ide.txt please. I should note that 
>> nodma option has been there for ages in one or other form.
>>     
>
> While it can be workarounded manually using "ide_core.nodma" we should really
> be aiming at ease of use for the end users and always let the code handle such
> issues automatically if possible.
>   

   I'd agree. The patch didn't seem to provide an accpetable form of 
such workaround though... although looks like I wasn't looking 
attentively enough.

>>> diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
>>> index fffd117..adb5d9d 100644
>>> --- a/drivers/ide/ide-dma.c
>>> +++ b/drivers/ide/ide-dma.c
>>> @@ -33,6 +33,21 @@
>>>  #include <linux/ide.h>
>>>  #include <linux/scatterlist.h>
>>>  #include <linux/dma-mapping.h>
>>> +#include <linux/dmi.h>
>>> +
>>> +/* Internal structure for blacklisted boards */
>>> +struct board_blacklist_entry {
>>> +	const char *board_vendor;
>>> +	const char *board_name;
>>> +	const char *drive_name;
>>> +};
>>> +
>>> +/* Blacklisted boards which have problems with DMA */
>>> +static const struct board_blacklist_entry board_blacklist[] = {
>>> +	/* on IEI PCISA-C3 CF adapter pin connectors for DMA are missing */
>>> +	{ "FIC"		,	"PT-2200"	,	"hdc"	},
>>>       

   I don't get it... FIC PT-2200 was Pentium class motherboard with 
Intel's 430HX chipset not having CF slot at all (as googling for its 
name has revealed). How it is connected to the (relatively modern) 
PCISA-C3/EPIC board?! What are you trying to smuggle into kernel? :-) Or 
this board just reports the bogus DMI IDs?

>>> @@ -207,6 +222,30 @@ void ide_dma_on(ide_drive_t *drive)
>>>  	drive->hwif->dma_ops->dma_host_set(drive, 1);
>>>  }
>>>  
>>> +static int __ide_dma_bad_adaptor(ide_drive_t *drive)
>>> +{
>>> +	const struct board_blacklist_entry *table = board_blacklist;
>>> +
>>> +	const char *board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
>>> +	const char *board_name   = dmi_get_system_info(DMI_BOARD_NAME);
>>> +
>>> +	if (!board_vendor || !board_name)
>>> +		return 0;
>>> +
>>> +	for ( ; table->board_name ; table++)
>>> +		if ((!strcmp(board_vendor, table->board_vendor)) &&
>>> +		    (!strcmp(board_name,   table->board_name))   &&
>>> +		    (!strcmp(drive->name,  table->drive_name))) {
>>> +			printk(KERN_WARNING "%s: Disabling (U)DMA for %s "
>>> +				"(Board %s %s is blacklisted)\n", drive->name,
>>> +				(char *)&drive->id[ATA_ID_PROD], board_vendor,
>>> +				board_name);
>>> +			return 1;
>>> +		}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>       
>>     This code doesn't anyhow discriminate the case of on-board CF and say 
>>     

   Hm, previously I failed to notice that the patch tries to 
discriminate this case based on applying the workaround only to the 
drive with certain name ("hdc"). However, it still seems wrong to place 
this workaround in __ide_dma_bad_drive() as it's not actually connected 
to the deficiency of a specific drive but to the definciency of the CF 
slot itself. Moreover, depending on the PCI cards plugged, the drive's 
name may change...

>> normal IDE PCI card plugged into such board -- with latter having no issues 
>>     

   And the PT-2200 board did have PCI and even ISA slots... oh wait, 
that's really another board. :-) That EPIC board is PICMG however, so 
can have a backplane with PCI slots.

>> with DMA whatsoever. E.g. AMD Geode GX2 dev. board (DB2301) has CF slot (with 
>> unsoldered DMA pins, IIRC) and 3 PCI slots where you can plug a normal IDE card.    
>
> True.  However it should be possible to handle it correctly by adding the
> DMA quirk to the respective host drivers (seems to be via82cxxx.c in case of
> IEI PCISA-C3/EDEN).  

   Yeah, this seems a viable approach...

> Kirill, could you please look into adding such quirk to via82cxxx instead?
>
> [ It seems the best place to add it would be via_init_one() as we could just
>   

   No, not really -- the issue is not at all as simple as this patch 
tried to present it. Looking at its "Quick Startup Reference" 
(http://f.ipc2u.ru/files/add/doc/496/M_PCISA-C800EV_ENG.pdf), the EPIC 
board has *two* normal IDE connectors in addition to the CF slot 
(connected to the secondary port -- and it seems possible that a hard 
drive can be connected to the same port as CF), so the right place seems 
to rather be in [mu]dma_filter() methods -- and the decision should be 
strictly based on the drive type indicating CF, i.e. by calling 
ata_id_is_cfa().

> Sergei, care to handle AMD Geode GX2 case?
>   

   Eh... the DB2301 board I had on my desk for a long time died in my 
hands 12/31, that same day when I NAKed this patch -- sort of NY 
present/ :-) Well, actually it stopped to boot the BIOS several weeks 
before that, then it just stopped to power up. We probably have another 
one (not sure if it's alive still) but all MV's development work for 
Geode GX2 stoped like 3 years ago. And now I'm not even sure that CF DMA 
issue really existed there -- I wasn't directly involved with CF related 
issues we had at the time of the active development, so my memory might 
be wrong. What I can say for sure is that the CF slot on DB2301 board 
coexisted with the normal IDE connector on CS5535's single channel and 
both CF and hard disk worked simultaneously (if you were lucky :-). I'll 
see if I have the board schematics from which I may be able to tell if 
the issue really existed.

> Thanks,
> Bart
>   
MBR, Sergei


