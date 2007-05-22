Return-Path: <linux-kernel-owner+w=401wt.eu-S1764099AbXEVB7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764099AbXEVB7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758344AbXEVB7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:59:42 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:55181 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758288AbXEVB7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:59:41 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200705220159.l4M1xTmN015593@turbo.physics.adelaide.edu.au>
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
To: alan@lxorguk.ukuu.org.uk (Alan Cox)
Date: Tue, 22 May 2007 11:29:29 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe), jesse.barnes@intel.com,
       hancockr@shaw.ca (Robert Hancock), linux-kernel@vger.kernel.org
In-Reply-To: <20070522013901.70bf7be8@the-village.bc.nu> from "Alan Cox" at May 22, 2007 01:39:01 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Are we talking CONFIG_PATA_MARVELL here?  If so then the kernel I just
> > booted has this set to "y" (ie: built-in) and yet the drive is still not
> > detected.  Is there a newer version of this driver somewhere?  The kernel
> > was 2.6.22-rc2.
> 
> Should be current. Its known to work fine for that chip so you might need
> to do some debugging and provide more detail.

I got someone to go into the BIOS setup (I am debugging this remotely) and
check the IDE/ATA related options.  The two relevant options were set
as follows:

  ATA/IDE Mode: <Native>    [ Choices: Legacy, Native ]
  Configure SATA as: <IDE>  [ Choices: IDE, RAID, AHCI ]

I had them change the "Configure SATA as" setting from "IDE" to "AHCI"
and then reboot into 2.6.22-rc2.  At this point things appear to be much
happier:

  ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
  Probing IDE interface ide0...
  Probing IDE interface ide1...
  :
  ahci 0000:00:1f.2: version 2.1
  ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
  ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
  ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
  PCI: Setting latency timer of device 0000:00:1f.2 to 64
  scsi0 : ahci
  :
  scsi5 : ahci
  ata1: SATA max UDMA/133 cmd 0xf882a100 ctl 0x00000000 bmdma 0x00000000 irq 0
  :
  ata6: SATA max UDMA/133 cmd 0xf882a380 ctl 0x00000000 bmdma 0x00000000 irq 0
  ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata1.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
  ata1.00: ATA-7: WDC WD2500AAJS-00RYA0, 12.01B01, max UDMA/133
  ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
  ata1.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
  ata1.00: configured for UDMA/133
  ata2: SATA link down (SStatus 0 SControl 300)
  :
  ata6: SATA link down (SStatus 0 SControl 300)
  scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500AAJS-0 12.0 PQ: 0 ANSI: 5
  sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
  sd 0:0:0:0: [sda] Write Protect is off
  :
  sd 0:0:0:0: [sda] Attached SCSI disk
  ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 16
  PCI: Setting latency timer of device 0000:02:00.0 to 64
  scsi6 : pata_marvell
  scsi7 : pata_marvell
  ata7: PATA max UDMA/100 cmd 0x00011018 ctl 0x00011026 bmdma 0x00011000 irq 0
  ata8: DUMMY
  BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
  ata7.00: ATAPI, max UDMA/66
  ata7.00: limited to UDMA/33 due to 40-wire cable
  ata7.00: configured for UDMA/33
  scsi 6:0:0:0: CD-ROM            SONY     DVD RW DRU-830A  SS25 PQ: 0 ANSI: 5
  sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
  Uniform CD-ROM driver Revision: 3.20
  sr 6:0:0:0: Attached scsi CD-ROM sr0
  sr 6:0:0:0: Attached scsi generic sg1 type 5

Therefore it seems that for whatever reason, the marvell_pata driver will
only find the Marvell PATA IDE controller if the *SATA* mode in the BIOS is
set to "AHCI".  It's somewhat counter-intuitive, but since AHCI is the
"correct" setting for SATA performance reasons it's probably not such a bad
thing.

So, thanks for all the suggestions; the problem appears solved.

Regards
  jonathan
