Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab0CLBfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 20:35:21 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:44601 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab0CLBfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 20:35:19 -0500
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201003120131.o2C1Vhcr030787@turbo.physics.adelaide.edu.au>
Subject: Re: 2.9.29.2: ide-tape: panic when probing device at boot
To: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
Date: Fri, 12 Mar 2010 12:01:43 +1030 (CST)
Cc: petkovbb@googlemail.com (Borislav Petkov), hancockrwd@gmail.com,
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       tj@kernel.org (Tejun Heo),
       bzolnier@gmail.com (Bartlomiej Zolnierkiewicz),
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <201001050538.o055c5eF021739@turbo.physics.adelaide.edu.au> from "Jonathan Woithe" at Jan 05, 2010 04:08:04 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Following up on my email from several months ago.  Sorry for the delay.

> > On Mon, Jan 04, 2010 at 11:45:12AM +1030, Jonathan Woithe wrote:
> > > Has there been any movement on this in recent months?  I gave 2.6.30 a whirl
> > > on the machine when that was released but it still gave major problems with
> > > the ide-tape driver.  Is 2.6.32 likely to be improved?  If so I'll make
> > > arrangements to test that version.
> > 
> > Yes, please do test 2.6.32 to see whether it fixes your problem. If you still
> > get that oops, please apply the following patch and send me the _whole_ dmesg
> > output of the machine.
> 
> Ok, will do.  Since it is a production machine and I've got linux.conf.au
> coming up it may be a couple of weeks before I get to do the test.  I'll
> advise the outcome once I have tested it.
> 
> Robert Hancock wrote:
> > You could also try using libata instead of IDE drivers and see if they 
> > work any better for you..
> 
> Yes, a good suggestion (I'm not sure why I neglected to try that initially). 
> I'll test that too and report back.

I've finally had an opportunity to test a few things.  I grabbed 2.6.33 and
configured libata support for the PATA controller (a VIA TV82CXXX) using the
"VIA PATA" option.  I disabled support for the legacy IDE driver.  Upon
booting 2.6.33's libata drivers correctly identified the two SATA HDDs in
the system, the PATA CDROM drive (secondary master) and the PATA tape unit
(primary master).  However, at this point things stopped - it seemed as if
the kernel lost the ability to communicate with either SATA HDD since it
reported timeouts on accesses to sda and sdb.

I haven't had a chance to test whether the inability to access the HDDs
comes as a result of the use of the VIA PATA libata driver or whether 2.6.33
has some inherant problem with VIA SATA controllers.  If I get a chance I'll
test that later today.  In any case, where do you suggest we go from here?

Unfortunately I didn't have time to note the precise errors seeen under
2.6.33 since I couldn't keep the machine down for very long.  I'll see if I
can repeat the test in a less busy part of the day later to get this
information.

Some system details:
  00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID
    Controller (rev 80)
  00:0f.1 IDE interface: VIA Technologies, Inc.
    VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)

00:0f.0 has two WD2502ABYS SATA HDDs connected.  Both drives have the
"1.5Gbps" jumper set because this chipset only supports 1.5Gbps but the
drives by default won't auto-negotiate down to this speed.  00:0f.1 has
an IDE tape drive (SONY SDX-260V) attached to primary master and a CD writer
(LITE-ON LTR-32123S) attached to secondary master.

Interface notes during boot on 2.6.24.2:

  Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
  ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
  VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:0f.1
  ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 5
  PCI: setting IRQ 5 as level-triggered
  ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [LNKE] -> GSI 5 (level, low) ->
    IRQ 5
  PCI: VIA VLink IRQ fixup for 0000:00:0f.1, from 255 to 5
  VP_IDE: not 100% native mode: will probe irqs later
  VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
      ide0: BM-DMA at 0xa000-0xa007, BIOS settings: hda:DMA, hdb:pio
      ide1: BM-DMA at 0xa008-0xa00f, BIOS settings: hdc:DMA, hdd:pio
  Probing IDE interface ide0...  
  hda: SONY SDX-260V, ATAPI TAPE drive
  hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
  hda: UDMA/100 mode selected 
  ide0 at 0x1f0-0x1f7,0x3f6 on irq 14 
  Probing IDE interface ide1...
  hdc: LITE-ON LTR-32123S, ATAPI CD/DVD-ROM drive
  hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
  hdc: UDMA/33 mode selected
  ide1 at 0x170-0x177,0x376 on irq 15
  hdc: ATAPI 40X CD-ROM CD-R/RW drive, 2048kB Cache
  Uniform CD-ROM driver Revision: 3.20
  ide-tape: hda <-> ht0: SONY SDX-260V rev 0100
  ide-tape: hda: overriding capabilities->speed (assuming 650KB/sec)
  ide-tape: hda: overriding capabilities->max_speed (assuming 650KB/sec)
  ide-tape: decreasing stage size
  ide-tape: decreasing stage size
  ide-tape: decreasing stage size
  ide-tape: hda <-> ht0: 650KBps, 126*32kB buffer, 6336kB pipeline, 100ms
    tDSC, DMA
  st: Version 20070203, fixed bufsize 32768, s/g segs 256 
  :
  sata_via 0000:00:0f.0: version 2.3
  ACPI: PCI Interrupt Link [LNKF] BIOS reported IRQ 0, using IRQ 9
  ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 9
  PCI: setting IRQ 9 as level-triggered
  ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [LNKF] -> GSI 9 (level, low) ->
    IRQ 9
  PCI: VIA VLink IRQ fixup for 0000:00:0f.0, from 5 to 9
  sata_via 0000:00:0f.0: routed to hard irq line 9
  scsi0 : sata_via
  scsi1 : sata_via
  ata1: SATA max UDMA/133 cmd 0xd000 ctl 0xb800 bmdma 0xa800 irq 9
  ata2: SATA max UDMA/133 cmd 0xb400 ctl 0xb000 bmdma 0xa808 irq 9
  ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  ata1.00: ATA-8: WDC WD2502ABYS-01B7A0, 02.03B02, max UDMA/133
  ata1.00: 490350672 sectors, multi 16: LBA48 NCQ (depth 0/32) 
  ata1.00: configured for UDMA/133
  ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  ata2.00: ATA-8: WDC WD2502ABYS-01B7A0, 02.03B02, max UDMA/133
  ata2.00: 490350672 sectors, multi 16: LBA48 NCQ (depth 0/32) 
  ata2.00: configured for UDMA/133

Regards
  jonathan
