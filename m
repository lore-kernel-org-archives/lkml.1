Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZIHSSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZIHSSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZIHSSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:18:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60028 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751944AbZIHSSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:18:30 -0400
Date: Tue, 8 Sep 2009 14:18:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-ide@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Limiting DMA speeds for individual IDE drives
In-Reply-To: <20090908185306.0f30c07b@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0909081409040.2653-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Alan Cox wrote:

> > I've got a situation where a drive claims to be capable of supporting
> > UDMA/100, but it's in a noisy environment and gets lots of errors at
> > that speed.  I'd like to limit it to UDMA/66 or even UDMA/33.
> 
> That should never occur with a proper cable and I would be concerned the
> fault might be something more problematic such as speed misconfiguration
> or an incompatibility. Which driver is in use ?

The cable indeed is likely to be at fault.  The same drive worked okay
at the higher speed with a different cable (which unfortunately is
unavailable for use in the final deployment).  This is using the old
IDE driver.  Here's an extract from the log, with
ide-core.ignore_cable=0 specified on the command line:

Linux version 2.6.27-gentoo-r10 (root@raise) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #1 SMP PREEMPT Tue Apr 21 15:06:03 UTC 2009
...
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x24cb rev 0x02)
pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
piix 0000:00:1f.1: IDE port disabled
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
ide: ignoring cable detection for ide0
    ide0: BM-DMA at 0xf000-0xf007
Probing IDE interface ide0...
hda: STEC MACH-8 SSD, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hda: max request size: 512KiB
hda: 60789456 sectors (31124 MB), CHS=16383/255/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3
...
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0xc4 { DriveStatusError BadCRC UncorrectableError }, LBAsect=14823116, sector=14823116
ide: failed opcode was: unknown
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0xc4 { DriveStatusError BadCRC UncorrectableError }, LBAsect=15133492, sector=15133492
ide: failed opcode was: unknown
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0xc4 { DriveStatusError BadCRC UncorrectableError }, LBAsect=9478100, sector=9478100
ide: failed opcode was: unknown
Etc.; you get the idea...


> > The hdparm command should be able to do this but I can't run it until 
> > the system has booted, by which time a bunch of CRC and possibly other 
> > errors have already occurred.  Ideally it should be possible to limit 
> 
> Only the data transfers are CRC protected and at high speed, but noise at
> low speed would be a real concern as the commands are sent low speed but
> without protection on PATA devices - so a bit flip can send a DMA to the
> wrong sector.
> 
> > the speed starting as early as device detection, but I can't find any 
> > way to do it.  Is there support for such a thing or will I have to hack 
> > it in?
> 
> You can disallow DMA but not clip DMA to UDMA33 with the old driver. You
> could disallow DMA at boot and reallow it with a speed set by hdparm in
> your boot scripts...


On Tue, 8 Sep 2009, Frederik Deweerdt wrote:

> Does passing ide=nodma at bootime, and then having init set the DMA at
> the right speed, would work?

I'll recommend trying that out.  Thanks to both of you for the advice.

Alan Stern

