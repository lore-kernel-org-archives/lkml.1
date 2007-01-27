Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbXA0WLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbXA0WLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 17:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXA0WLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 17:11:11 -0500
Received: from www.osadl.org ([213.239.205.134]:32796 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752395AbXA0WLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 17:11:10 -0500
Subject: Re: Linux 2.6.20-rc6 - suspend / resume ata_piix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 27 Jan 2007 23:11:41 +0100
Message-Id: <1169935901.17469.159.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 18:58 -0800, Linus Torvalds wrote:
> It's been more than a week since -rc5, but I blame everybody (including 
> me) being away for Linux.conf.au and then me waiting for a few days 
> afterwards to let everybody sync up.

ata_piix survives exactly one suspend resume cylce. After resuming the
second time the disk is not longer usable.

After the first resume a simple "emacs -nw bla.txt" takes already ~45sec
to launch, but there are no kernel messages.

During the second resume the ATA interrupt gets disabled due to an
unhandled interrupt.

This is 100% reproducible. So I can provide as much info as needed.

	tglx

Boot:

SCSI subsystem initialized
libata version 2.00 loaded.
ata_piix 0000:00:1f.2: version 2.00ac7
ata_piix 0000:00:1f.2: MAP [ P0 P2 XX XX ]
ata_piix 0000:00:1f.2: invalid MAP value 0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 22 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ata1: SATA max UDMA/133 cmd 0x18D0 ctl 0x18C6 bmdma 0x18B0 irq 21
ata2: SATA max UDMA/133 cmd 0x18C8 ctl 0x18C2 bmdma 0x18B8 irq 21
scsi0 : ata_piix
PM: Adding info for No Bus:host0
ata1.00: ATA-7, max UDMA/133, 195371568 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
scsi1 : ata_piix
PM: Adding info for No Bus:host1
scsi 0:0:0:0: Direct-Access     ATA      ST9100824AS      3.14 PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sda: sda1 sda2 < sda5 > sda3
sd 0:0:0:0: Attached scsi disk sda

1st Suspend:

ata_piix 0000:00:1f.2: suspend
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
PIIX_IDE 0000:00:1f.1: suspend
....
PIIX_IDE 0000:00:1f.1: LATE suspend

1st Resume:

ata1.00: configured for UDMA/133
SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

2nd Suspend as above

2nd resume:
Initializing CPU#1
irq 21: nobody cared(try booting with the "irqpoll" option)
...
handlers:
[<f88e5b02>] (atat_interrupt+0x0/0x1cd [libata])
Disabling IRQ #21
....
ata1.00: qc timeout (cmd 0xe1)
ata1.00: failed to spin up (err_mask=0x4)
ata1.00: failed to set xfermode (err_mask=0x40)
ata1.00: limiting speed to UDMA/100
ata1: failed to recover some devies, retrying in 5 secs
....
sd 0:0:0:0: rejectimg I/O to offline device
....
ata1.00: ATA-7, max UDMA/133, 195371568 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 16
sd 0:0:0:0: rejectimg I/O to offline device
.....


