Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbYGOUjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbYGOUjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYGOUi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:38:57 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:33286 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYGOUi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:38:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent:from;
        b=dSPSofed1miXQPYee95z8oErg/d5rLoTkVXgJ6JFZ2Eaj7A5yH4R7B3JTl9n5EvAwM
         eIv7bWkGKqI9TvHfoqdankASJ+7XCZSJf2ZdtWVrpR1EOHCoDfSDPMNeYlp7sx2vLbDI
         jn1DjsF4vlya4RFMvINjaUN1gcj1hi3pmbcoc=
Date: Tue, 15 Jul 2008 22:39:13 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] ide-floppy fix
Message-ID: <20080715203913.GA23431@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	stable@kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200807161759.16803.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807161759.16803.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 05:59:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Tuesday 15 July 2008, Borislav Petkov wrote:
> 
> [...]
> 
> > On a different note, the current pata tree on top of v2.6.25-2125-g50515af blows
> > up here with the following error:
> > 
> > [    4.296729] Uniform Multi-Platform E-IDE driver
> > [    4.297905] ICH4: IDE controller (0x8086:0x24cb rev 0x02) at  PCI slot 0000:00:1f.1
> > [    4.297986] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
> > [    4.298153] ICH4: not 100% native mode: will probe irqs later
> > [    4.298213]     ide0: BM-DMA at 0xfc00-0xfc07
> > [    4.298282]     ide1: BM-DMA at 0xfc08-0xfc0f
> > [    4.561768] hda: QUANTUM FIREBALLlct10 20, ATA DISK drive
> > [    4.816724] hdb: SAMSUNG SP2014N, ATA DISK drive
> > [    4.867959] hda: drive side 80-wire cable detection failed, limiting max speed to UDMA33
> > [    4.868027] hda: UDMA/33 mode selected
> > [    4.868441] hdb: UDMA/100 mode selected
> > [    5.540683] hdc: IOMEGA ZIP 100 ATAPI, ATAPI FLOPPY drive
> > [    5.795564] hdd: IC35L120AVV207-0, ATA DISK drive
> > [    5.847295] hdd: host side 80-wire cable detection failed, limiting max speed to UDMA33
> > [    5.847362] hdd: UDMA/33 mode selected
> > [    5.847715] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > [    5.855487] ide1 at 0x170-0x177,0x376 on irq 15
> > [    5.875927] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> > [    5.876012] ide_generic: I/O resource 0x1F0-0x1F7 not free.
> > [    5.876074] ide_generic: I/O resource 0x170-0x177 not free.
> > [   11.342504] hde: no response (status = 0xa1), resetting drive
> > [   17.206535] hdf: no response (status = 0xa1), resetting drive
> 
> hde? hdf?
> 
> [...]

yep, looks strange to me too. Isn't that the MAX_HWIFS upper bound of a loop.. ?

> 
> > I tracked the error down to the call to ide_register_port(hwif) in
> > ide-probe.c:ide_host_register() which does device_register(&hwif->gendev) and
> > the hwif->gendev->kobj seems unitialized thus the WARN_ON on its refcount in
> > kref_get(). Will look into it more when i get some free time.
> 
> Unfortunately I couldn't reproduce this problem here (2.6.26 + pata tree)
> so please try to debug it and/or narrow it down to the guilty change.

Will do.

> > --
> > From: Borislav Petkov <petkovbb@gmail.com>
> > 
> > Check the correct flags-location for set features.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> Thanks, I folded the fix into original patch (->dev_flags is not yet
> upstream so -stable fix shouldn't be necessary).
> 
> While on it: I later noticed that there will be also need for common
> ATA/ATAPI ->dev_flags in the future so I wonder whether current
> ->dev_flags should be renamed to ->atapi_flags (& s/*DFLAG*/*AFLAG*/).
> 
> If there is agreement on this I'll fix it in pata tree.

... or if there's room, use a single ->dev_flags for all possible flag settings?

-- 
Regards/Gruﬂ,
    Boris.
