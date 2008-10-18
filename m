Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbYJRQa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbYJRQa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 12:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYJRQat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 12:30:49 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:45173 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYJRQas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 12:30:48 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] Re: pata_it821x in 2.6.27 - works but no LBA48 and "hdparm -t" is slower
Date: Sat, 18 Oct 2008 18:30:37 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200810181342.50615.linux@rainbow-software.org>
In-Reply-To: <200810181342.50615.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810181830.39023.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 October 2008 13:42:48 Ondrej Zary wrote:
> Hello,
> big thanks to Alan Cox for the work on pata_it821x driver. I just upgraded
> to 2.6.27 and my RAID1 on IT8212 controller now works without any patching.
>
> Good that I haven't resized my 30GB partition to full drive capacity yet
> because LBA48 does not work:
>
> ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> pata_it821x 0000:00:12.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) ->
> IRQ 11 pata_it821x: controller in smart mode.
> pata_it821x 0000:00:12.0: setting latency timer to 64
> pata_it821x: Firmware 02/09/3030
> 0: MWDMA2 RAID1RAID 0+1 Volume: 0 SAMSUNG HD400LD
> 1: MWDMA2 RAID1RAID 0+1 Volume: 0 SAMSUNG HD400LD
> scsi2 : pata_it821x
> scsi3 : pata_it821x
> ata3: PATA max UDMA/133 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
> ata4: PATA max UDMA/133 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
> ata3.00: ATA-4: Integrated Technology Express Inc, , max MWDMA2
> ata3.00: 268435455 sectors, multi 0: LBA
>                                         ^^ no 48 here
>
> ata3.00: RAID1 volume.
> ata3.00: configured for DMA
> scsi 2:0:0:0: Direct-Access     ATA      Integrated Techn n/a  PQ: 0 ANSI:
> 5 sd 2:0:0:0: [sdb] 268435455 512-byte hardware sectors (137439 MB)
>                                                        ^^^^^^ should be
> 400088
>
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA sd 2:0:0:0: [sdb] 268435455 512-byte hardware sectors
> (137439 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA sdb: sdb1 sdb2 sdb3 sdb4
> sd 2:0:0:0: [sdb] Attached SCSI disk
> sd 2:0:0:0: Attached scsi generic sg2 type 0
>
>
> Also "hdparm -t" is slower (but "hdparm -t --direct" isn't - so it probably
> isn't pata_it821x issue): 2.6.26 (with my crappy patch):
> /dev/sdb:
>  Timing buffered disk reads:   60 MB in  3.01 seconds =  19.91 MB/sec
>
> /dev/sdb:
>  Timing O_DIRECT disk reads:  194 MB in  3.00 seconds =  64.62 MB/sec
>
> /dev/sdb:
>
>  Model=Integrated Technology Express Inc       , FwRev=, SerialNo=▒PX
>  Config={ }
>  RawCHS=0/0/0, TrkSize=0, SectSize=0, ECCbytes=0
>  BuffType=unknown, BuffSize=0kB, MaxMultSect=0
>  (maybe): CurCHS=0/0/0, CurSects=0, LBA=no
>  IORDY=no
>  PIO modes:  pio0
>  AdvancedPM=no
>
>  * signifies the current active mode
>
> 2.6.27:
> /dev/sdb:
>  Timing buffered disk reads:   48 MB in  3.08 seconds =  15.57 MB/sec
>
> /dev/sdb:
>  Timing O_DIRECT disk reads:  196 MB in  3.02 seconds =  64.81 MB/sec
>
> /dev/sdb:
>
>  Model=Integrated Technology Express Inc       , FwRev=, SerialNo=▒'T
>  Config={ }
>  RawCHS=0/0/0, TrkSize=0, SectSize=0, ECCbytes=0
>  BuffType=unknown, BuffSize=0kB, MaxMultSect=0
>  (maybe): CurCHS=0/0/0, CurSects=0, LBA=yes, LBAsects=781422766
>  IORDY=no
>  PIO modes:  pio0
>  DMA modes:  mdma0 mdma1 mdma2
>  AdvancedPM=no
>  Drive conforms to: Unspecified:  ATA/ATAPI-0,1,2,3,4
>
>  * signifies the current active mode

This patch fixes LBA48 on pata_it821x RAID volumes - and to my surprise, also
increases the "hdparm -t" speed back. Haven't tested access to >128GB area.

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
ata3.00: 781422766 sectors, multi 0: LBA48
ata3.00: RAID1 volume.
ata3.00: configured for DMA
scsi 2:0:0:0: Direct-Access     ATA      Integrated Techn n/a  PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0


/dev/sdb:
 Timing buffered disk reads:   60 MB in  3.01 seconds =  19.91 MB/sec



Fix LBA48 on pata_it821x RAID volumes.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.27-orig/drivers/ata/pata_it821x.c	2008-10-18 17:09:07.000000000 +0200
+++ linux-2.6.27-pentium/drivers/ata/pata_it821x.c	2008-10-18 17:10:24.000000000 +0200
@@ -557,9 +557,8 @@
 	if (strstr(model_num, "Integrated Technology Express")) {
 		/* Set feature bits the firmware neglects */
 		id[49] |= 0x0300;	/* LBA, DMA */
-		id[82] |= 0x0400;	/* LBA48 */
 		id[83] &= 0x7FFF;
-		id[83] |= 0x4000;	/* Word 83 is valid */
+		id[83] |= 0x4400;	/* Word 83 is valid and LBA48 */
 		id[86] |= 0x0400;	/* LBA48 on */
 		id[ATA_ID_MAJOR_VER] |= 0x1F;
 	}


-- 
Ondrej Zary
