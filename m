Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbYGPTN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbYGPTN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbYGPTNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:13:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:10356 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbYGPTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QositK8PJCIDkwjEnYHI9nCmKGBpe1rRKN/7stFC44uU6ph9OPXASSn6hT7GiPRQDD
         J6EAuqeK0jvpYPk1jB3QnzstrePKOn6Gvhl5f9KEecUUzcCojnROqKCe+5k655HW5ypi
         R6eY52BYB2aqCu0wDqsNzPOU08QCveNo9k+wo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-floppy fix
Date: Wed, 16 Jul 2008 19:56:46 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, stable@kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200807152258.49462.bzolnier@gmail.com> <20080716052047.GA12383@gollum.tnic>
In-Reply-To: <20080716052047.GA12383@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161956.46981.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2008, Borislav Petkov wrote:
> On Tue, Jul 15, 2008 at 10:58:48PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 15 July 2008, Borislav Petkov wrote:
> > > On Wed, Jul 16, 2008 at 05:59:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > 
> > > > Hi,
> > > > 
> > > > On Tuesday 15 July 2008, Borislav Petkov wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > On a different note, the current pata tree on top of v2.6.25-2125-g50515af blows
> > > > > up here with the following error:
> > > > > 
> > > > > [    4.296729] Uniform Multi-Platform E-IDE driver
> > > > > [    4.297905] ICH4: IDE controller (0x8086:0x24cb rev 0x02) at  PCI slot 0000:00:1f.1
> > > > > [    4.297986] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
> > > > > [    4.298153] ICH4: not 100% native mode: will probe irqs later
> > > > > [    4.298213]     ide0: BM-DMA at 0xfc00-0xfc07
> > > > > [    4.298282]     ide1: BM-DMA at 0xfc08-0xfc0f
> > > > > [    4.561768] hda: QUANTUM FIREBALLlct10 20, ATA DISK drive
> > > > > [    4.816724] hdb: SAMSUNG SP2014N, ATA DISK drive
> > > > > [    4.867959] hda: drive side 80-wire cable detection failed, limiting max speed to UDMA33
> > > > > [    4.868027] hda: UDMA/33 mode selected
> > > > > [    4.868441] hdb: UDMA/100 mode selected
> > > > > [    5.540683] hdc: IOMEGA ZIP 100 ATAPI, ATAPI FLOPPY drive
> > > > > [    5.795564] hdd: IC35L120AVV207-0, ATA DISK drive
> > > > > [    5.847295] hdd: host side 80-wire cable detection failed, limiting max speed to UDMA33
> > > > > [    5.847362] hdd: UDMA/33 mode selected
> > > > > [    5.847715] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > > > > [    5.855487] ide1 at 0x170-0x177,0x376 on irq 15
> > > > > [    5.875927] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> > > > > [    5.876012] ide_generic: I/O resource 0x1F0-0x1F7 not free.
> > > > > [    5.876074] ide_generic: I/O resource 0x170-0x177 not free.
> > > > > [   11.342504] hde: no response (status = 0xa1), resetting drive
> > > > > [   17.206535] hdf: no response (status = 0xa1), resetting drive
> > > > 
> > > > hde? hdf?
> > > > 
> > > > [...]
> > > 
> > > yep, looks strange to me too. Isn't that the MAX_HWIFS upper bound of a loop.. ?
> > 
> > Close, it is related to MAX_HWIFS being upper bound on hws[]
> > in ide_generic.c but now we loop for ARRAY_SIZE(legacy_bases).
> > 
> > IOW there is a memset(hws, 0, MAX_HWIFS) missing at the top of
> > ide_generic_init() (please re-test after adding it).
> > 
> > This may also explain the later problems with ide_host_register().

I fixed this in pata tree now with:

"ide-generic: remove ide_default_{io_base,irq}() inlines (take 2)" patch

> > > > > From: Borislav Petkov <petkovbb@gmail.com>
> > > > > 
> > > > > Check the correct flags-location for set features.
> > > > > 
> > > > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > > > 
> > > > Thanks, I folded the fix into original patch (->dev_flags is not yet
> > > > upstream so -stable fix shouldn't be necessary).
> > > > 
> > > > While on it: I later noticed that there will be also need for common
> > > > ATA/ATAPI ->dev_flags in the future so I wonder whether current
> > > > ->dev_flags should be renamed to ->atapi_flags (& s/*DFLAG*/*AFLAG*/).
> > > > 
> > > > If there is agreement on this I'll fix it in pata tree.
> > > 
> > > ... or if there's room, use a single ->dev_flags for all possible flag settings?
> > 
> > Unfortunately there isn't enough room left (27 bits are occupied ATM)
> > and having u64 ->dev_flags sucks...
> 
> I'm pretty sure some of the 27 will be removed later but yeah, u64 flags is
> kinda bad since it has to be always atomically updated and this has to be
> explicitly staged on 32bit cpus due to the wordsize. I guess two flags members

->dev_flags -> ->atapi_flags & co. are also in pata tree now

> are the easiest thing to do for now, you might add some comments to both so we
> know which is which.

Sure, I will remember about this when it comes time for ->dev_flags.

Thanks,
Bart
