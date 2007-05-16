Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbXEPJeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbXEPJeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbXEPJeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:34:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:56876 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXEPJeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gzyZwNgiHNZU1Laa171AHeD1X1X6v/eCLQAa+2hTOUvwDNlgyRCeL4u/PogjkUSbkDpTSnieyVP8YzTlgyoGPnMO0enagTUwIkIzGK+H/4lGqQVypeXmR8DXtUuiKO9cZp0Ns7j0mu4lcoBM9r+YogZ2tLCUqLuMkn5keGbOPaw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Thomas Kuther <gimpel@sonnenkinder.org>
Subject: Re: IT821x: no DMA since 2.6.21
Date: Wed, 16 May 2007 11:46:19 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070515125308.3a9f6442@SiRiUS.home> <200705160258.15928.bzolnier@gmail.com> <20070516100924.11273ce4@SiRiUS.home>
In-Reply-To: <20070516100924.11273ce4@SiRiUS.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705161146.19497.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 16 May 2007, Thomas Kuther wrote:
> On Mi, 16.05.07 02:58 Bartlomiej Zolnierkiewicz wrote:
> 
> > 
> > Hi,
> > 
> > On Tuesday 15 May 2007, Alan Cox wrote:
> > > On Tue, 15 May 2007 12:53:08 +0200
> > > Thomas Kuther <gimpel@sonnenkinder.org> wrote:
> > > 
> > > > Hi!
> > > > 
> > > > Since 2.6.21 I have a problem with the it821x driver on my ITE
> > > > 8212 controller.
> > > > Now I saw some updates to it821x in 2.6.22-rc1 and gave that a
> > > > try, but the problem persists.
> > > 
> > > I've had multiple reports of this. I would recommend you use the
> > > libata driver. IT821x hasn't changed over the past few releases so
> > > its someting
> > 
> > commit 0e9b4e535fec7e2a189952670937adfbe2826b63
> > Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Date:   Sat May 5 22:03:50 2007 +0200
> > 
> >     it821x: PIO mode setup fixes
> > 
> > ...
> > 
> > *cough, cough* ;)
> > 
> > > in the core IDE code that broke it [note it might not of course be
> > > that the problem is in the core code..].
> > 
> > The real problem seems to be that IT821x "virtual" ID misses info
> > about supported DMA modes (while it seems to contain enabled DMA
> > mode info).

Close but not really it, the it821x_fixup() was done after probe_hwif()
so IDE core code was using the original (incorrect) value of id->field_valid
(before "id->field_valid &= 1" fixup).

The rest of the problem analysis is still valid (DMA worked by pure luck
before Jens' fixes).

> > This would be the logical explanation why the driver broke after:
> > 
> > [...]
> > 
> > It seems that somebody has already debugged this issue to
> > the aforementioned changes:
> > 
> > http://lkml.org/lkml/2007/1/14/110
> > 
> > 
> > Thomas, does the following patch against 2.6.22-rc1 fix the issue?
> > 
> 
> Hi Bartlomiej,
> 
> yes, this patch completely fixes it. Looks very good now even.
> I loaded it with option noraid=1
> 
> ------------------------------8<----------------------------
> IT8212: IDE controller at PCI slot 0000:00:09.0
> ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 18
> IT8212: chipset revision 17
> it8212: forcing bypass mode.
> it821x: controller in pass through mode.
> IT8212: 100% native mode on irq 18
>     ide2: BM-DMA at 0xdc00-0xdc07, BIOS settings: hde:pio, hdf:pio
>     ide3: BM-DMA at 0xdc08-0xdc0f, BIOS settings: hdg:pio, hdh:pio
> Probing IDE interface ide2...
> hde: SAMSUNG SP2514N, ATA DISK drive
> hdf: Maxtor 6Y120L0, ATA DISK drive
> hde: selected mode 0x45
> hdf: selected mode 0x46
> ide2 at 0xec00-0xec07,0xe802 on irq 18
> hde: max request size: 512KiB
> hde: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63,
> UDMA(100) hde: cache flushes supported
>  hde: hde1
> hdf: max request size: 128KiB
> hdf: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=65535/16/63,
> UDMA(133) hdf: cache flushes supported
> -------------------------------------->8------------------------------
> So all those drive seek errors are gone too.
> Hdparm does not complain anymore, speed is OK.
> Nice, so I can get rid of libata again, as all other drives run with the
> IDE layer too. 
> 
> Many thanks!
> 
> Shall I test it without "noraid=1" too? 

Please do, the main goal of the patch was to fix "RAID mode"
("noraid=1" should work fine also without the patch?).

Thanks,
Bart
