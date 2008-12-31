Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYLaTN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYLaTN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbYLaTNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:13:48 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:52542 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYLaTNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:13:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=HIj6rNOBmOPVVJrj/vee2kRg4/gbheicJ+fB5XVBiNbEsi02Cj3k2+6Jkhi4bDAG/T
         /e5pqfTwLmqgwhJkCohDSqNUpOPOEHRFMEMbGyCObETNbNmhiQTUq/SVF3CszV45zIlj
         RWFMw0cxWC57hdFv6KGyPmEt/kqIuLmd8rQio=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] ide: motherboard-info based blacklist for ide-dma
Date: Wed, 31 Dec 2008 20:12:46 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-next-20081229; KDE/4.1.3; i686; ; )
Cc: Kirill Smelkov <kirr@mns.spb.ru>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kirr@landau.phys.spbu.ru,
       Dmitry Gryazin <gdu@mns.spb.ru>
References: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru> <495A4CC0.6000000@ru.mvista.com>
In-Reply-To: <495A4CC0.6000000@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812312012.46496.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 December 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Kirill Smelkov wrote:
> 
> > From: Dmitry Gryazin <gdu@mns.spb.ru>
> 
> > We need to keep our kernel working on both legacy and modern hardware.
> 
> > As it turned out, some boards don't have proper IDE DMA support for
> > CompactFlash (CF) adaptors, because pin connectors which relate to DMA are left
> > unsoldered (*).
> 
> > To verify this we even bought external IDE CF adaptor which showed the same
> > symthoms, and then manually soldered pins that were left dangling, and voila,
> > DMA started to work!
> 
> > Again, as they say, lots of manufacturers of not-so-new hardware did CF
> > soldering by the wrong way with respect to DMA, so we need a workaround.
> 
> > For this __ide_dma_bad_drive function is enhance to check not only drives
> > blacklist but motherboards blacklist too.
> 
> > Please apply before 2.6.29
> 
> > (*) On IEI PCISA-C3/EDEN the kernel boots _very_ slowly, becuase we have lots
> > of DMA timer expiry:
> 
> >     <~30s pause>
> >     hdc: dma_timer_epiry: dma_status == 0x21
> >     hdc: DMA timeout error
> >     ...
> >     hdc: DMA disabled
> >     ide1: dma reset
> > 
> >     <and the whole story repeats:>
> >     <~30s pause>
> >     hdc: dma_timer_epiry: dma_status == 0x21
> >     ...
> 
>     Are you aware of ide_core.nodma= option which allows disabling DMA per 
> interface/drive? Read Documentation/ide/ide.txt please. I should note that 
> nodma option has been there for ages in one or other form.

While it can be workarounded manually using "ide_core.nodma" we should really
be aiming at ease of use for the end users and always let the code handle such
issues automatically if possible.

> > Also see this posts from 2006 where they say this is usually a problem with CF
> > adapter not fully soldered:
> 
> > http://lkml.org/lkml/2006/5/23/198
> > http://lkml.org/lkml/2006/6/20/164
> 
> > Signed-off-by: Dmitry Gryazin <gdu@mns.spb.ru>
> > Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> 
>     NAK.
> 
> > diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
> > index fffd117..adb5d9d 100644
> > --- a/drivers/ide/ide-dma.c
> > +++ b/drivers/ide/ide-dma.c
> > @@ -33,6 +33,21 @@
> >  #include <linux/ide.h>
> >  #include <linux/scatterlist.h>
> >  #include <linux/dma-mapping.h>
> > +#include <linux/dmi.h>
> > +
> > +/* Internal structure for blacklisted boards */
> > +struct board_blacklist_entry {
> > +	const char *board_vendor;
> > +	const char *board_name;
> > +	const char *drive_name;
> > +};
> > +
> > +/* Blacklisted boards which have problems with DMA */
> > +static const struct board_blacklist_entry board_blacklist[] = {
> > +	/* on IEI PCISA-C3 CF adapter pin connectors for DMA are missing */
> > +	{ "FIC"		,	"PT-2200"	,	"hdc"	},
> > +	{ NULL		,	NULL		,	NULL	}
> > +};
> >  
> >  static const struct drive_list_entry drive_whitelist[] = {
> >  	{ "Micropolis 2112A"	,       NULL		},
> > @@ -207,6 +222,30 @@ void ide_dma_on(ide_drive_t *drive)
> >  	drive->hwif->dma_ops->dma_host_set(drive, 1);
> >  }
> >  
> > +static int __ide_dma_bad_adaptor(ide_drive_t *drive)
> > +{
> > +	const struct board_blacklist_entry *table = board_blacklist;
> > +
> > +	const char *board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
> > +	const char *board_name   = dmi_get_system_info(DMI_BOARD_NAME);
> > +
> > +	if (!board_vendor || !board_name)
> > +		return 0;
> > +
> > +	for ( ; table->board_name ; table++)
> > +		if ((!strcmp(board_vendor, table->board_vendor)) &&
> > +		    (!strcmp(board_name,   table->board_name))   &&
> > +		    (!strcmp(drive->name,  table->drive_name))) {
> > +			printk(KERN_WARNING "%s: Disabling (U)DMA for %s "
> > +				"(Board %s %s is blacklisted)\n", drive->name,
> > +				(char *)&drive->id[ATA_ID_PROD], board_vendor,
> > +				board_name);
> > +			return 1;
> > +		}
> > +
> > +	return 0;
> > +}
> > +
> 
>     This code doesn't anyhow discriminate the case of on-board CF and say 
> normal IDE PCI card plugged into such board -- with latter having no issues 
> with DMA whatsoever. E.g. AMD Geode GX2 dev. board (DB2301) has CF slot (with 
> unsoldered DMA pins, IIRC) and 3 PCI slots where you can plug a normal IDE card.

True.  However it should be possible to handle it correctly by adding the
DMA quirk to the respective host drivers (seems to be via82cxxx.c in case of
IEI PCISA-C3/EDEN).

Kirill, could you please look into adding such quirk to via82cxxx instead?

[ It seems the best place to add it would be via_init_one() as we could just
  clear host DMA masks (please also remember to first check if the controller
  is an external one -- for VIA it could only be VT6410).  BTW it should be
  possible to greatly simplify DMI checking by using dmi_check_system() helper
  similarly how it's already done for cable detection in via82cxxx. ]

Sergei, care to handle AMD Geode GX2 case?

Thanks,
Bart
