Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbXJTGz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbXJTGz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 02:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbXJTGzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 02:55:48 -0400
Received: from nn7.de ([85.214.94.156]:50782 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbXJTGzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 02:55:47 -0400
Subject: sata sil3114 vs. certain seagate drives results in filesystem
	corruptions
From: Soeren Sonnenburg <kernel@nn7.de>
To: linux-ide@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, Bernd Schubert <bs@q-leap.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 20 Oct 2007 06:55:24 +0000
Message-Id: <1192863324.5720.162.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I finally managed to find a *reproducible* setup and way to trigger
random corruptions using a sata sil 3114 controller connected to 4
seagate drives

port 1: ST3400832AS sda
port 2: ST3400620AS sdb
port 3: ST3750640AS sdc
port 4: ST3750640AS sdd

sda & sdb form md0 via a raid1 setup followed by an additional
devicemapper layer ( root ). sdc and sdb are separate and also have an
additional device mapper layer ( public ) and ( backups ).

Now when I write large files of zeros to root(sda&sdb) and read the file
back in it contains a few nonzero entries:

# dd if=/dev/zero of=/foo bs=1M count=2000
# hexdump /foo
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
<after >1GB random parts, within large blocks of zeroes> 

I can reliably trigger this on the md0 / devmapper-root setup when I
write about 2GB of data (note that this machine has 1.5G of memory - and
still 1GB is often enough to see this problem). Here it does not matter
where in the filesystem I do these writes.

As a test I did the same on sdc / devmapper-public and
sdd/devmapper-backups with even 30G of zeros. Nothing, no errors
everything is perfectly OK.

So I thought that this is also the the sil mod15write problem
http://home-tj.org/wiki/index.php/Sil_m15w and applied patches 1 & 2
from http://lkml.org/lkml/2007/10/11/115 (adding my two disks) and
rebooted. Now there was some MOD15 stuff in dmesg for the two disks but
still apart from the disks being even slower it was of no use - the
corruption problem was still there (I then also tried patch 3 from Bernd
but that immediately caused oopses fs/errors). So it looks like the
problem I am having is different...

Now I remembered that this machine also has two idle promise pdc20376
sata ports where I first tried the ST3400832AS (sda) and ST3400620AS
(sdb) on about a year ago
http://lists.openwall.net/linux-kernel/2006/08/27/106 . At that time I
just saw random error messages and then finally hangs - quoting Tejon
Heo:

 "I see.  your drive is reporting error for some reason and libata is 
failing to recover."

Now promise_sata is converted to new EH, so I simply gave it a go, i.e.
I attached ST3400832AS and ST3400620AS to the promise controller and
rebooted and redid the experiments from above.

No data corruptions whatsoever. I even ran the dd on all three devmapped
mount points simultaneously with a size of 30GB each, still no
corruption. However the error messages I've seen a year ago are back for
the ST3400832AS and ST3400620AS attached to the promise controller (see
below).

Please find all the details below:

- uname

Linux 2.6.23.1 #3 PREEMPT Fri Oct 19 20:39:45 CEST 2007 i686 GNU/Linux

- lspci

00:0e.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
00:0e.0 0104: 1095:3114 (rev 02)

00:08.0 RAID bus controller: Promise Technology, Inc. PDC20376 (FastTrak 376) (rev 02)
00:08.0 0104: 105a:3376 (rev 02)

- proc interrupts

 17:    4434549   IO-APIC-fasteoi   sata_promise, sata_sil, ohci1394

- dmesg

sata_sil 0000:00:0e.0: version 2.3
ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 17 (level, low) -> IRQ 17
sata_sil 0000:00:0e.0: Applying R_ERR on DMA activate FIS errata fix
scsi3 : sata_sil
scsi4 : sata_sil
scsi5 : sata_sil
scsi6 : sata_sil
ata4: SATA max UDMA/100 cmd 0xf882e080 ctl 0xf882e08a bmdma 0xf882e000 irq 17
ata5: SATA max UDMA/100 cmd 0xf882e0c0 ctl 0xf882e0ca bmdma 0xf882e008 irq 17
ata6: SATA max UDMA/100 cmd 0xf882e280 ctl 0xf882e28a bmdma 0xf882e200 irq 17
ata7: SATA max UDMA/100 cmd 0xf882e2c0 ctl 0xf882e2ca bmdma 0xf882e208 irq 17
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata4.00: ATA-7: ST3400832AS, 3.01, max UDMA/133
ata4.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/100
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata5.00: ATA-7: ST3400620AS, 3.AAE, max UDMA/133
ata5.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata5.00: configured for UDMA/100
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata6.00: ATA-7: ST3750640AS, 3.AAE, max UDMA/133
ata6.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata6.00: configured for UDMA/100
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata7.00: ATA-7: ST3750640AS, 3.AAC, max UDMA/133
ata7.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata7.00: configured for UDMA/100
scsi 3:0:0:0: Direct-Access     ATA      ST3400832AS      3.01 PQ: 0 ANSI: 5
sd 3:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: unknown partition table
sd 3:0:0:0: [sda] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: Direct-Access     ATA      ST3400620AS      3.AA PQ: 0 ANSI: 5
sd 4:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: unknown partition table
sd 4:0:0:0: [sdb] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg1 type 0
scsi 5:0:0:0: Direct-Access     ATA      ST3750640AS      3.AA PQ: 0 ANSI: 5
sd 5:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
sd 5:0:0:0: [sdc] Write Protect is off
sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
sd 5:0:0:0: [sdc] Write Protect is off
sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: unknown partition table
sd 5:0:0:0: [sdc] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg2 type 0
scsi 6:0:0:0: Direct-Access     ATA      ST3750640AS      3.AA PQ: 0 ANSI: 5
sd 6:0:0:0: [sdd] 1465149168 512-byte hardware sectors (750156 MB)
sd 6:0:0:0: [sdd] Write Protect is off
sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sdd] 1465149168 512-byte hardware sectors (750156 MB)
sd 6:0:0:0: [sdd] Write Protect is off
sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: unknown partition table
sd 6:0:0:0: [sdd] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg3 type 0


- promise errors:

ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x100 action 0x2
ata1.00: port_status 0x20200000
ata1.00: cmd 25/00:00:c0:b6:74/00:01:20:00:00/e0 tag 0 cdb 0x0 data 131072 in
         res 51/0c:00:c0:b6:74/0c:01:20:00:00/e0 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x100 action 0x2
ata2.00: port_status 0x20200000
ata2.00: cmd c8/00:00:40:16:fe/00:00:00:00:00/e1 tag 0 cdb 0x0 data 131072 in
         res 51/0c:00:40:16:fe/00:00:00:00:00/e1 Emask 0x10 (ATA bus error)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x100 action 0x2
ata2.00: port_status 0x20200000
ata2.00: cmd c8/00:50:58:25:e3/00:00:00:00:00/ec tag 0 cdb 0x0 data 40960 in
         res 51/0c:50:58:25:e3/00:00:00:00:00/ec Emask 0x10 (ATA bus error)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x100 action 0x2
ata2.00: port_status 0x20200000
ata2.00: cmd c8/00:08:b0:54:b0/00:00:00:00:00/ed tag 0 cdb 0x0 data 4096 in
         res 51/0c:08:b0:54:b0/00:00:00:00:00/ed Emask 0x10 (ATA bus error)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x100 action 0x2
ata2.00: port_status 0x20200000
ata2.00: cmd 25/00:00:f8:af:c0/00:02:12:00:00/e0 tag 0 cdb 0x0 data 262144 in
         res 51/0c:00:f8:af:c0/0c:02:12:00:00/e0 Emask 0x10 (ATA bus error)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x100 action 0x2
ata2.00: port_status 0x20200000
ata2.00: cmd c8/00:00:60:f5:e2/00:00:00:00:00/e2 tag 0 cdb 0x0 data 131072 in
         res 51/0c:00:60:f5:e2/0c:02:12:00:00/e2 Emask 0x10 (ATA bus error)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x100 action 0x2
ata2.00: port_status 0x20200000
ata2.00: cmd 25/00:f0:80:54:da/00:00:12:00:00/e0 tag 0 cdb 0x0 data 122880 in
         res 51/0c:f0:80:54:da/0c:00:12:00:00/e0 Emask 0x10 (ATA bus error)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Open for suggestions/ideas,
Soeren.
