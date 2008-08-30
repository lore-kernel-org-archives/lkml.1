Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbYHaAT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbYHaAT5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 20:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYHaATu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 20:19:50 -0400
Received: from eloth.gjh.sk ([193.87.79.100]:40290 "EHLO eloth.gjh.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbYHaATt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 20:19:49 -0400
X-Greylist: delayed 1762 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Aug 2008 20:19:49 EDT
Message-ID: <48B9DCBE.3000306@gjh.sk>
Date: Sun, 31 Aug 2008 01:50:22 +0200
From: Peter Ambroz <comp@gjh.sk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080830)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Subject: Marvell 6145 PATA controller
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Will talk about 2.6.25 kernel.
I had recently a problem with marvell pata controllers. Exactly speaking 
of "IDE interface: Marvell Technology Group Ltd. 88SE6145 SATA II PCI-E 
controller", pci-id 11ab:6145.
There is a (pseudo) driver in the kernel for handling that controller, 
called pata_marvell, but it doesn't claim the device.
Instead, ahci driver claims that device, and then just does nothing. 
Devices connected to the marvell are not seen by kernel.

After looking into the source code I found out that both ahci.c and 
pata_marvell.c list that device in their pci_device_id structure (which 
wouldn't be problem, if both drivers worked with the controller, but 
ahci.c just doesn't)

The first solution to this was found very quickly by using google: just 
add kernel parameter all-generic-ide, and the marvell controller will be 
recognized by ide-generic driver, and HDD's, CDROM's on that marvell 
controller are also found (as hda, hdb).

The second solution is to remove few lines from ahci.c which lists the 
marvell 6145 device (and probably also marvell 6121).
Short patch included below.
After that, kernel finally uses the pata_marvell driver, and my pata 
devices are registered with kernel (as sda, sdb).

The third solution is to not use ahci driver when using pata_marvell. 
But this is not possible with lots of motherboards which have Intel 
corp. SATA controller + marvell sata / pata controller.

AFAIK, the second idea (patch the source) would solve problems for lots 
of people asking for the solution. (the first idea with the 
all-generic-ide doesn't work for everybody)

I would suggest patching the ahci.c, and I appreciate any 
suggestions/comments.

For the sake of completness, here are relevant parts of dmesg:
(0000:03:00.0 is the mentioned marvell 6145 sata/pata controller)
scenario 1: ahci takes the controller, no devices are detected

----------CUT-----------
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
ahci 0000:03:00.0: controller can't do NCQ, turning off CAP_NCQ
ahci 0000:03:00.0: MV_AHCI HACK: port_map 1f -> f
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 5 ports 3 Gbps 0xf impl IDE mode
ahci 0000:03:00.0: flags: 64bit stag pmp slum part
PCI: Setting latency timer of device 0000:03:00.0 to 64
scsi7 : ahci
scsi8 : ahci
scsi9 : ahci
scsi10 : ahci
scsi11 : ahci
ata7: SATA max UDMA/133 abar m1024@0xfe8ffc00 port 0xfe8ffd00 irq 16
ata8: SATA max UDMA/133 abar m1024@0xfe8ffc00 port 0xfe8ffd80 irq 16
ata9: SATA max UDMA/133 abar m1024@0xfe8ffc00 port 0xfe8ffe00 irq 16
ata10: SATA max UDMA/133 abar m1024@0xfe8ffc00 port 0xfe8ffe80 irq 16
ata11: DUMMY
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
ata9: SATA link down (SStatus 0 SControl 300)
ata10: SATA link down (SStatus 0 SControl 300)
----------CUT-----------



scenario 2: pata_marvell takes the controller, everything is fine

----------CUT-----------
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:03:00.0 to 64
scsi7 : pata_marvell
scsi8 : pata_marvell
ata7: PATA max UDMA/100 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 16
ata8: PATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 16
BAR5:00:04 01:7F 02:22 03:C8 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 
0B:00 0C:1F 0D:00 0E:00 0F:00
ata7.00: ATA-7: Maxtor 7L250R0, BAJ41G20, max UDMA/133
ata7.00: 490234752 sectors, multi 0: LBA48
ata7.01: ATAPI: HL-DT-ST DVDRAM GSA-H42N, RL00, max UDMA/66
ata7.00: configured for UDMA/100
ata7.01: configured for UDMA/66
BAR5:00:04 01:7F 02:22 03:C8 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 
0B:00 0C:1F 0D:00 0E:00 0F:00
scsi 7:0:0:0: Direct-Access     ATA      Maxtor 7L250R0   BAJ4 PQ: 0 ANSI: 5
sd 7:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 7:0:0:0: [sdb] Write Protect is off
sd 7:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 7:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 7:0:0:0: [sdb] Write Protect is off
sd 7:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sdb: sdb1
sd 7:0:0:0: [sdb] Attached SCSI disk
sd 7:0:0:0: Attached scsi generic sg1 type 0
scsi 7:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-H42N  RL00 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 7:0:1:0: Attached scsi CD-ROM sr0
sr 7:0:1:0: Attached scsi generic sg2 type 5
----------CUT-----------


..and the patch that was used (very simple):
----------CUT-----------
--- drivers/ata/ahci.c	2008-08-28 23:11:37.000000000 +0200
+++ drivers/ata/ahci.c	2008-08-30 20:08:59.000000000 +0200
@@ -590,10 +590,6 @@
  	{ PCI_VDEVICE(SI, 0x1185), board_ahci }, /* SiS 966 */
  	{ PCI_VDEVICE(SI, 0x0186), board_ahci }, /* SiS 968 */

-	/* Marvell */
-	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
-	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
-
  	/* Generic, PCI class code for AHCI */
  	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
  	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
----------CUT-----------


With regards,
    Peter Ambroz
