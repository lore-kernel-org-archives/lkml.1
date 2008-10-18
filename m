Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbYJRLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbYJRLnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 07:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYJRLnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 07:43:03 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:42134 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbYJRLnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 07:43:00 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: pata_it821x in 2.6.27 - works but no LBA48 and "hdparm -t" is slower
Date: Sat, 18 Oct 2008 13:42:48 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810181342.50615.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
big thanks to Alan Cox for the work on pata_it821x driver. I just upgraded to 2.6.27
and my RAID1 on IT8212 controller now works without any patching.

Good that I haven't resized my 30GB partition to full drive capacity yet because LBA48
does not work:

ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
pata_it821x 0000:00:12.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
pata_it821x: controller in smart mode.
pata_it821x 0000:00:12.0: setting latency timer to 64
pata_it821x: Firmware 02/09/3030
0: MWDMA2 RAID1RAID 0+1 Volume: 0 SAMSUNG HD400LD
1: MWDMA2 RAID1RAID 0+1 Volume: 0 SAMSUNG HD400LD
scsi2 : pata_it821x
scsi3 : pata_it821x
ata3: PATA max UDMA/133 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
ata4: PATA max UDMA/133 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
ata3.00: ATA-4: Integrated Technology Express Inc, , max MWDMA2
ata3.00: 268435455 sectors, multi 0: LBA
                                        ^^ no 48 here

ata3.00: RAID1 volume.
ata3.00: configured for DMA
scsi 2:0:0:0: Direct-Access     ATA      Integrated Techn n/a  PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 268435455 512-byte hardware sectors (137439 MB)
                                                       ^^^^^^ should be 400088

sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 268435455 512-byte hardware sectors (137439 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0


Also "hdparm -t" is slower (but "hdparm -t --direct" isn't - so it probably isn't pata_it821x issue):
2.6.26 (with my crappy patch):
/dev/sdb:
 Timing buffered disk reads:   60 MB in  3.01 seconds =  19.91 MB/sec

/dev/sdb:
 Timing O_DIRECT disk reads:  194 MB in  3.00 seconds =  64.62 MB/sec

/dev/sdb:

 Model=Integrated Technology Express Inc       , FwRev=, SerialNo=▒PX
 Config={ }
 RawCHS=0/0/0, TrkSize=0, SectSize=0, ECCbytes=0
 BuffType=unknown, BuffSize=0kB, MaxMultSect=0
 (maybe): CurCHS=0/0/0, CurSects=0, LBA=no
 IORDY=no
 PIO modes:  pio0
 AdvancedPM=no

 * signifies the current active mode

2.6.27:
/dev/sdb:
 Timing buffered disk reads:   48 MB in  3.08 seconds =  15.57 MB/sec

/dev/sdb:
 Timing O_DIRECT disk reads:  196 MB in  3.02 seconds =  64.81 MB/sec

/dev/sdb:

 Model=Integrated Technology Express Inc       , FwRev=, SerialNo=▒'T
 Config={ }
 RawCHS=0/0/0, TrkSize=0, SectSize=0, ECCbytes=0
 BuffType=unknown, BuffSize=0kB, MaxMultSect=0
 (maybe): CurCHS=0/0/0, CurSects=0, LBA=yes, LBAsects=781422766
 IORDY=no
 PIO modes:  pio0
 DMA modes:  mdma0 mdma1 mdma2
 AdvancedPM=no
 Drive conforms to: Unspecified:  ATA/ATAPI-0,1,2,3,4

 * signifies the current active mode

-- 
Ondrej Zary
