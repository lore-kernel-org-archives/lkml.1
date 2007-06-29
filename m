Return-Path: <linux-kernel-owner+w=401wt.eu-S933095AbXF2MnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbXF2MnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760676AbXF2Mm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:42:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35184 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755016AbXF2Mm4 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:42:56 -0400
Date: Fri, 29 Jun 2007 22:42:48 +1000
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Regression: 2.6.22-rcX: hda: lost interrupt
Message-ID: <20070629124248.GJ989688@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

After updating an x86_64 machine from 2.6.21 to 2.6.22-rc6 and
fighting off the where-the-fuck-did-my-serial-console-go blues
(legacy_serial.force), I finally discovered why the damn thing
wasn't booting - the machine was sitting there in a loop outputting
"hda: lost interrupt" over and over again during hardware
discovery (hda = dvd drive).

It doesn't happen on every boot - more boots hung than failed,
though, while I was trying to work out where my serial port
went and get some work done.

Since I've had the console operative, the boot hangs are
basically like:

ESB2: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 20 (level, low) -> IRQ20
ESB2: chipset revision 9
ESB2: not 100% native mode: will probe irqs later
    ide0: DM-DMA at 0x50a0-0x50a7, BIOS settings: hda:DMA, hdb:pio
    ide1: DM-DMA at 0x50a8-0x50af, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
hda: probing with STATUS(0xa0) instead of ALTSTATUS(0x58)
hda: <some ctrl char>, ATAPI UNKNOWN (type 31) drive
hdb: probing with STATUS(0xb0) instead of ALTSTATUS(0x00)
hdb: probing with STATUS(0xa1) instead of ALTSTATUS(0x51)
hdb: <some ctrl char>, ATAPI UNKNOWN (type 31) drive
hda: set_drive_speed_status: status=0x58 { DriveReady SeekComplete DataRequest }
hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hda: set_drive_speed_status: error=0x04 { AbortedCommand }
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: lost interrupt
hda: lost interrupt
hda: lost interrupt
hda: lost interrupt
hda: lost interrupt
hda: lost interrupt
hda: lost interrupt
hda: lost interrupt
hda: lost interrupt
hda: lost interrupt
hda: lost interrupt
......

The success boots I've had (looking at the boot logs) have all
failed to discover the dvd drive correctly except one. The
one that dsicovered it still had errors, though. Errors
look like:

ESB2: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 20 (level, low) -> IRQ20
ESB2: chipset revision 9
ESB2: not 100% native mode: will probe irqs later
    ide0: DM-DMA at 0x50a0-0x50a7, BIOS settings: hda:DMA, hdb:pio
    ide1: DM-DMA at 0x50a8-0x50af, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
hda: probing with STATUS(0xa0) instead of ALTSTATUS(0x58)
hda: <some ctrl char>, ATAPI UNKNOWN (type 31) drive
hdb: probing with STATUS(0xb0) instead of ALTSTATUS(0x00)
hdb: probing with STATUS(0xa1) instead of ALTSTATUS(0x51)
hdb: <some ctrl char>, ATAPI UNKNOWN (type 31) drive
hda: set_drive_speed_status: status=0x58 { DriveReady SeekComplete DataRequest }
hda: selected mode 0x0
hda: set_drive_speed_status: status=0x58 { DriveReady SeekComplete DataRequest }
hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hda: set_drive_speed_status: error=0x04 { AbortedCommand }
hda: selected mode 0x0
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

Another failure mode:

hda: probing with STATUS(0xa0) instead of ALTSTATUS(0x58)
hda: <some ctrl char>, ATAPI UNKNOWN (type 31) drive
hdb: probing with STATUS(0xb0) instead of ALTSTATUS(0x00)
hdb: probing with STATUS(0xb0) instead of ALTSTATUS(0x00)
hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hda: set_drive_speed_status: error=0x04 { AbortedCommand }
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: lost interrupt
hda: task_in_intr: status=0x51 { DriveReady SeekComplete Error }
hda: task_in_intr: error=0x04 { AbortedCommand }
ide: failed opcode was: 0xa1

And another:

hda: host side 80-wire cable detection failed, limiting max speed to UDMA33
hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hda: set_drive_speed_status: error=0x04 { AbortedCommand }
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: lost interrupt

And other boots were a combination of the ones above.

And the boot that really read the drive type properly but had
scary warnings:

ESB2: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 20 (level, low) -> IRQ20
ESB2: chipset revision 9
ESB2: not 100% native mode: will probe irqs later
    ide0: DM-DMA at 0x50a0-0x50a7, BIOS settings: hda:DMA, hdb:pio
    ide1: DM-DMA at 0x50a8-0x50af, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
hda: DV-28E-R, ATAPI CD/DVD-ROM drive
hda: selected mode 0x42
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 24X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hda: status error: status=0x50 { DriveReady SeekComplete }
ide: failed opcode was: unknown
hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hda: drive not ready for command
hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hda: drive not ready for command
<repeat another 10 times>

I haven't seen any failures like this on 2.6.21 or earlier, so
this is appears to be new to 2.6.22-rc.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
