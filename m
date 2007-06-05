Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbXFEQPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbXFEQPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764791AbXFEQOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:14:52 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:38483 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763816AbXFEQOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:14:51 -0400
Message-ID: <46658BF6.3080601@dgreaves.com>
Date: Tue, 05 Jun 2007 17:14:46 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mikpe@it.uu.se
Subject: Re: Linux 2.6.22-rc4 - sata_promise regression since -rc3
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So -rc4 is out there now, hopefully shrinking the regression list further. 

> I'd ask that people involved with the known regressions please test 
> whether they got fixed, and if you wrote a patch and it's still pending, 
> please make sure to push it upstream..

[Tejun, Jeff, added you since the bisect points to your patch.]

Sorry, mail glitch means I lost a couple of emails...

I said:
Compile warnings and a new regression: hang on boot during sata_promise
detection...

It turns out that the hang times out; it does boot after a while. It's missing 4
of my SATA disks though.
[in turn this means I can't test the hibernate regression against -rc4. But
testing that regression against a862b5c8cd5d847779a049a5fc8cf5b1e6f5fa07 shows
it is still there. Do I get a bonus for finding 2 regressions?]]

I also bisected and got:
Bisecting: 0 revisions left to test after this
[464cf177df7727efcc5506322fc5d0c8b896f545] libata: always use polling SETXFER

According to marc, Mikail said:
Please give us some details about your sata_promise problem:
- describe your hardware (Promise chip version, mainboard, chipset, etc)
I have a Promise TX-4 and onboard via-sata.
0000:00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] Host
Bridge (rev 80)
0000:00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
0000:00:0d.0 Unknown mass storage controller: Promise Technology, Inc. PDC20318
(SATA150 TX4) (rev 02)
0000:00:0f.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)

- which was the last kernel version prior to 2.6.22-rc4 that worked
2.6.22-rc3
- the kernel messages up to the hang, if you can capture them
Easier once I learned patience...

sata_promise 0000:00:0d.0: version 2.07
ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 16 (level, low) -> IRQ 17
scsi0 : sata_promise
scsi1 : sata_promise
scsi2 : sata_promise
scsi3 : sata_promise
ata1: SATA max UDMA/133 cmd 0xf880a200 ctl 0xf880a238 bmdma 0x00000000 irq 0
ata2: SATA max UDMA/133 cmd 0xf880a280 ctl 0xf880a2b8 bmdma 0x00000000 irq 0
ata3: SATA max UDMA/133 cmd 0xf880a300 ctl 0xf880a338 bmdma 0x00000000 irq 0
ata4: SATA max UDMA/133 cmd 0xf880a380 ctl 0xf880a3b8 bmdma 0x00000000 irq 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata1.00: ATA-7: Maxtor 6B250S0, BANC19J0, max UDMA/133
ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata1.00: qc timeout (cmd 0xef)
ata1.00: failed to set xfermode (err_mask=0x4)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata1.00: qc timeout (cmd 0xef)
ata1.00: failed to set xfermode (err_mask=0x4)
ata1.00: limiting speed to UDMA/133:PIO3
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata1.00: qc timeout (cmd 0xef)
ata1.00: failed to set xfermode (err_mask=0x4)
ata1.00: disabled
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata2.00: ATA-7: Maxtor 7Y250M0, YAR51EW0, max UDMA/133
ata2.00: 490234752 sectors, multi 0: LBA48
ata2.00: qc timeout (cmd 0xef)
ata2.00: failed to set xfermode (err_mask=0x4)
ata2: failed to recover some devices, retrying in 5 secs
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata2.00: qc timeout (cmd 0xef)
ata2.00: failed to set xfermode (err_mask=0x4)
ata2.00: limiting speed to UDMA/133:PIO3
ata2: failed to recover some devices, retrying in 5 secs
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata2.00: qc timeout (cmd 0xef)
ata2.00: failed to set xfermode (err_mask=0x4)
ata2.00: disabled
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata3.00: ATA-7: Maxtor 7Y250M0, YAR51EW0, max UDMA/133
ata3.00: 490234752 sectors, multi 0: LBA48
ata3.00: qc timeout (cmd 0xef)
ata3.00: failed to set xfermode (err_mask=0x4)
ata3: failed to recover some devices, retrying in 5 secs
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata3.00: qc timeout (cmd 0xef)
ata3.00: failed to set xfermode (err_mask=0x4)
ata3.00: limiting speed to UDMA/133:PIO3
ata3: failed to recover some devices, retrying in 5 secs
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata3.00: qc timeout (cmd 0xef)
ata3.00: failed to set xfermode (err_mask=0x4)
ata3.00: disabled
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata4.00: ATA-7: Maxtor 6B250S0, BANC1980, max UDMA/133
ata4.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata4.00: qc timeout (cmd 0xef)
ata4.00: failed to set xfermode (err_mask=0x4)
ata4: failed to recover some devices, retrying in 5 secs
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata4.00: qc timeout (cmd 0xef)
ata4.00: failed to set xfermode (err_mask=0x4)
ata4.00: limiting speed to UDMA/133:PIO3
ata4: failed to recover some devices, retrying in 5 secs
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata4.00: qc timeout (cmd 0xef)
ata4.00: failed to set xfermode (err_mask=0x4)
ata4.00: disabled
sata_via 0000:00:0f.0: version 2.2
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 16
sata_via 0000:00:0f.0: routed to hard irq line 0
scsi4 : sata_via
scsi5 : sata_via
ata5: SATA max UDMA/133 cmd 0x0001b000 ctl 0x0001a802 bmdma 0x00019800 irq 0
ata6: SATA max UDMA/133 cmd 0x0001a400 ctl 0x0001a002 bmdma 0x00019808 irq 0
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0x7F on port 0x0001b007
ATA: abnormal status 0x7F on port 0x0001b007
ata5.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata5.00: ATA-7: Maxtor 7B250S0, BANC1980, max UDMA/133
ata5.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata5.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
ata5.00: configured for UDMA/133
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0x7F on port 0x0001a407
ATA: abnormal status 0x7F on port 0x0001a407
ata6.00: ata_hpa_resize 1: sectors = 781422768, hpa_sectors = 781422768
ata6.00: ATA-7: ST3400620AS, 3.AAK, max UDMA/133
ata6.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata6.00: ata_hpa_resize 1: sectors = 781422768, hpa_sectors = 781422768
ata6.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      Maxtor 7B250S0   BANC PQ: 0 ANSI: 5
sd 4:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 4:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sda: sda1
sd 4:0:0:0: [sda] Attached SCSI disk
scsi 5:0:0:0: Direct-Access     ATA      ST3400620AS      3.AA PQ: 0 ANSI: 5
sd 5:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
sd 5:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sdb: sdb1 sdb2
sd 5:0:0:0: [sdb] Attached SCSI disk




