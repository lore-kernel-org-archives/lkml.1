Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbZAOMgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbZAOMgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764509AbZAOMgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:36:25 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:38543 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763518AbZAOMgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:36:22 -0500
X-Greylist: delayed 2600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 07:36:21 EST
From: Dmitry Gryazin <gdu@mns.spb.ru>
Organization: MNS
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] ide: motherboard-info based blacklist for ide-dma
Date: Thu, 15 Jan 2009 14:48:52 +0300
User-Agent: KMail/1.9.9
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Kirill Smelkov <kirr@mns.spb.ru>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, navy-patches@mns.spb.ru
References: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru> <49611CF4.9030103@ru.mvista.com> <4961478B.9060005@ru.mvista.com>
In-Reply-To: <4961478B.9060005@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901151448.52900.gdu@mns.spb.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello for everybody.

First of all I'd like to say that we are sorry for so looong delay with 
replying.

My name is Dmitry Gryazin, and I'm a collegue of Kirill Smelkov. I'll reply to 
the issues you've raised inline:

On Monday 05 January 2009 02:34:35 am Sergei Shtylyov wrote:
[...]
> >>>     Are you aware of ide_core.nodma= option which allows disabling
> >>> DMA per interface/drive? Read Documentation/ide/ide.txt please. I
> >>> should note that nodma option has been there for ages in one or
> >>> other form.
> >>
> >> While it can be workarounded manually using "ide_core.nodma" we
> >> should really
> >> be aiming at ease of use for the end users and always let the code
> >> handle such
> >> issues automatically if possible.
> >
> >   I'd agree. The patch didn't seem to provide an accpetable form of
> > such workaround though... although looks like I wasn't looking
> > attentively enough.

We know about "ide_core.nodma" and we have been using it for PCISA-C3 for 
ages. But we have to support three different motherboards (some of them are 
with CF problems, some of them not) with one home-made distribution now.

So, the idea was to get it works automatically.

> >>>> diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
> >>>> index fffd117..adb5d9d 100644
> >>>> --- a/drivers/ide/ide-dma.c
> >>>> +++ b/drivers/ide/ide-dma.c
> >>>> @@ -33,6 +33,21 @@
> >>>>  #include <linux/ide.h>
> >>>>  #include <linux/scatterlist.h>
> >>>>  #include <linux/dma-mapping.h>
> >>>> +#include <linux/dmi.h>
> >>>> +
> >>>> +/* Internal structure for blacklisted boards */
> >>>> +struct board_blacklist_entry {
> >>>> +    const char *board_vendor;
> >>>> +    const char *board_name;
> >>>> +    const char *drive_name;
> >>>> +};
> >>>> +
> >>>> +/* Blacklisted boards which have problems with DMA */
> >>>> +static const struct board_blacklist_entry board_blacklist[] = {
> >>>> +    /* on IEI PCISA-C3 CF adapter pin connectors for DMA are
> >>>> missing */
> >>>> +    { "FIC"        ,    "PT-2200"    ,    "hdc"    },
> >
> >   I don't get it... FIC PT-2200 was Pentium class motherboard with
> > Intel's 430HX chipset not having CF slot at all (as googling for its
> > name has revealed). How it is connected to the (relatively modern)
> > PCISA-C3/EPIC board?! What are you trying to smuggle into kernel? :-)
> > Or this board just reports the bogus DMI IDs?

Yes, PCISA-C3 (with BIOS v1.3) says vendor="FIC" and name="PT-2200".
It's a pity that vendors don't care to correctly assign DMI IDs, so that we 
can't fully rely on them.

As Bartlomiej suggests, one of the way to solve this problem is to use IDE 
controller as additional criterion to decide on which port/drive DMA should 
be off.

> >>>> @@ -207,6 +222,30 @@ void ide_dma_on(ide_drive_t *drive)
> >>>>      drive->hwif->dma_ops->dma_host_set(drive, 1);
> >>>>  }
> >>>>
> >>>> +static int __ide_dma_bad_adaptor(ide_drive_t *drive)
> >>>> +{
> >>>> +    const struct board_blacklist_entry *table = board_blacklist;
> >>>> +
> >>>> +    const char *board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
> >>>> +    const char *board_name   = dmi_get_system_info(DMI_BOARD_NAME);
> >>>> +
> >>>> +    if (!board_vendor || !board_name)
> >>>> +        return 0;
> >>>> +
> >>>> +    for ( ; table->board_name ; table++)
> >>>> +        if ((!strcmp(board_vendor, table->board_vendor)) &&
> >>>> +            (!strcmp(board_name,   table->board_name))   &&
> >>>> +            (!strcmp(drive->name,  table->drive_name))) {
> >>>> +            printk(KERN_WARNING "%s: Disabling (U)DMA for %s "
> >>>> +                "(Board %s %s is blacklisted)\n", drive->name,
> >>>> +                (char *)&drive->id[ATA_ID_PROD], board_vendor,
> >>>> +                board_name);
> >>>> +            return 1;
> >>>> +        }
> >>>> +
> >>>> +    return 0;
> >>>> +}
> >>>> +
> >>>
> >>>     This code doesn't anyhow discriminate the case of on-board CF
> >>> and say
> >
> >   Hm, previously I failed to notice that the patch tries to
> > discriminate this case based on applying the workaround only to the
> > drive with certain name ("hdc"). However, it still seems wrong to
> > place this workaround in __ide_dma_bad_drive() as it's not actually
> > connected to the deficiency of a specific drive but to the definciency
> > of the CF slot itself. Moreover, depending on the PCI cards plugged,
> > the drive's name may change...
> >
> >>> normal IDE PCI card plugged into such board -- with latter having no
> >>> issues

Yes, I've to agree that using "hdc" is not correct.

> >> True.  However it should be possible to handle it correctly by adding
> >> the
> >> DMA quirk to the respective host drivers (seems to be via82cxxx.c in
> >> case of
> >> IEI PCISA-C3/EDEN).
> >
> >   Yeah, this seems a viable approach...
> >
> >> Kirill, could you please look into adding such quirk to via82cxxx
> >> instead?
> >>
> >> [ It seems the best place to add it would be via_init_one() as we
> >> could just
> >
> >   No, not really -- the issue is not at all as simple as this patch
> > tried to present it. Looking at its "Quick Startup Reference"
> > (http://f.ipc2u.ru/files/add/doc/496/M_PCISA-C800EV_ENG.pdf), the EPIC
> > board has *two* normal IDE connectors in addition to the CF slot
> > (connected to the secondary port -- and it seems possible that a hard
> > drive can be connected to the same port as CF), so the right place
> > seems to rather be in [mu]dma_filter() methods -- and the decision
> > should be strictly based on the drive type indicating CF, i.e. by
> > calling ata_id_is_cfa().

As you suggest, we could use the following criterions:

    Board vendor="FIC"		&&
    Board name="PT-2200"	&&
    VIA-family IDE controller	&&
    drive type=CF

It should work good enough.

To test it I also tried to install external IDE CF adaptor to the secondary 
IDE controller (both master and slave). And it's also identified as CF drive 
type. And we turn off DMA for it. But since external CF adaptor could be 
wired right, turning DMA off would be incorrect in some cases.

Yes, _that_ particular external IDE/CF adaptor that we bought, has the same  
problem, so turning DMA off on it should be correct. We even decided to 
verify ourselves that wrong soldering is the cause of problems, and wired 
manually necessary pins, and, voila, DMA works. So the question is:

    Is it right to implement the above-mentioned criterion, which would work 
    correctly in 99 cases of 100, but will pessimistically turn DMA off in
    rare cases (e.g. rightly wired external IDE/CF adaptor attached to
    PCISA/C3), or is the whole problem unsolvable?

We could not come up with the right criterion which selects exactly on-board 
CF slot, so if there is no satisfactory 100% reliable solution maybe it 
doesn't make sense to continue...

We ask for help and advice what to do now.

Thanks beforehand,
Dmitry, Kirill.
