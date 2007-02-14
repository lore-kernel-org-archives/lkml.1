Return-Path: <linux-kernel-owner+w=401wt.eu-S1751156AbXBNRqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbXBNRqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbXBNRqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:46:11 -0500
Received: from mail.tmr.com ([64.65.253.246]:43232 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbXBNRqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:46:11 -0500
Message-ID: <45D34B47.5090005@tmr.com>
Date: Wed, 14 Feb 2007 12:47:51 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Greg Trounson <gregt@maths.otago.ac.nz>
CC: linux-kernel@vger.kernel.org
Subject: Re: AHCI - remove probing of ata2
References: <45D25E37.1060106@maths.otago.ac.nz>
In-Reply-To: <45D25E37.1060106@maths.otago.ac.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Trounson wrote:
> At the risk of sounding like a "me too" post:
> 
> I also have an Asus P5W-DH, with the following drives connected:
> 
> SATA: ST3250820AS, connected to sata1
> PATA: HL-DT-ST GSA-H12N, ATAPI DVD Writer, Primary master
> 
> On bootup of 2.6.19 and 2.6.20, the kernel stalls for 1 minute when 
> probing sata2, eventually giving up and continuing the boot process.  
> There is no physical sata2 connector on the Motherboard, just solder 
> lugs between sata1 and sata3.  From other users I understand this is 
> really a Silicon Image SIL4723 SATA to 2-Port SATA splitter.  It is 
> detected by the kernel as a disk, as below.
> 
> The relevant part of the boot process looks like:
> ...
> libata version 2.00 loaded.
> ahci 0000:00:1f.2: version 2.0
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 22
> PCI: Setting latency timer of device 0000:00:1f.2 to 64
> ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA 
> mode
> ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part
> ata1: SATA max UDMA/133 cmd 0xF882A900 ctl 0x0 bmdma 0x0 irq 219
> ata2: SATA max UDMA/133 cmd 0xF882A980 ctl 0x0 bmdma 0x0 irq 219
> ata3: SATA max UDMA/133 cmd 0xF882AA00 ctl 0x0 bmdma 0x0 irq 219
> ata4: SATA max UDMA/133 cmd 0xF882AA80 ctl 0x0 bmdma 0x0 irq 219
> scsi0 : ahci
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ (depth 31/32)
> ata1.00: ata1: dev 0 multi count 16
> ata1.00: configured for UDMA/133
> scsi1 : ahci
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> 
> ...waits 20 seconds...
> 
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
> 
> ...waits 5 seconds...
> 
> ata2: port is slow to respond, please be patient (Status 0x80)
> 
> ...waits 30 seconds...
> 
> ata2: port failed to respond (30 secs, Status 0x80)
> ata2: COMRESET failed (device not ready)
> ata2: hardreset failed, retrying in 5 secs
> 
> ...waits 5 seconds...
> 
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: ATA-6, max UDMA/133, 640 sectors: LBA
> ata2.00: ata2: dev 0 multi count 1
> ata2.00: configured for UDMA/133
> scsi2 : ahci
> ata3: SATA link down (SStatus 0 SControl 300)
> ...
> 
> A bit of poking about shows:
> 
> fdisk -l /dev/sdb
> Disk /dev/sdb: 0 MB, 327680 bytes
> 255 heads, 63 sectors/track, 0 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk /dev/sdb doesn't contain a valid partition table
> 
> So it presents itself as a 320k disk, filled with zeroes as below:
> 
> dd if=/dev/sdb |hexdump
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0050000
> 
> 640+0 records in
> 640+0 records out
> 327680 bytes (328 kB) copied, 0.0106662 seconds, 30.7 MB/s
> 
> Note that this is not a fatal error.  The machine still boots 
> eventually, but the seemingly mandatory 60 second pause makes startup 
> rather cumbersome for the user.
> 
> So far none of the suggested fixes have managed to stop ata2 from being 
> detected. (noprobe=ata2, irqpoll, etc).  I understand this problem 
> wasn't present in 2.6.16 so the problem must lie in some patch since 
> then.  I see Tejun is working towards patches for this and I would be 
> happy to try them here.
> 
Is this 320k of cache memory, or in any way some actual storage on the 
system? Have you tried to write to it out of curiosity? Seems odd that 
it would be detected if there were nothing at all present, although 
obviously it could be artifact.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
