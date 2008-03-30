Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbYC3Pd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbYC3Pd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 11:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYC3PdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 11:33:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:13117 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYC3Pcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 11:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WTSc43jAG4piTdNx0TWgO0r5C4yhVzWGi4/eMjNsd1xBFahZbyq2qJrwP667f9+UWAvW4OPgZvGp2yuNS0ya1/VX1F8iIlMHIPxZvPuTtUOZq16XJUS2PYC1KUthN82PWItmT1r/xvKUJS9siVKkWa+lopj5IMhiLZUq9dDNr9s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/5] ide: add struct ide_io_ports
Date: Sun, 30 Mar 2008 17:12:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803301712.57588.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add struct ide_io_ports and use it instead of `unsigned long io_ports[]`
  in ide_hwif_t.

* Rename io_ports[] in hw_regs_t to io_ports_array[].

* Use un-named union for 'unsigned long io_ports_array[]' and 'struct
  ide_io_ports io_ports' in hw_regs_t.

* Remove IDE_*_OFFSET defines.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c        |    6 +--
 drivers/ide/arm/icside.c          |    7 ++-
 drivers/ide/arm/palm_bk3710.c     |    6 +--
 drivers/ide/arm/rapide.c          |    6 +--
 drivers/ide/cris/ide-cris.c       |   18 ++++-----
 drivers/ide/h8300/ide-h8300.c     |    6 +--
 drivers/ide/ide-cd.c              |    8 ++--
 drivers/ide/ide-floppy.c          |   12 +++---
 drivers/ide/ide-io.c              |   42 +++++++++-------------
 drivers/ide/ide-iops.c            |   72 +++++++++++++++++---------------------
 drivers/ide/ide-probe.c           |   41 +++++++++++----------
 drivers/ide/ide-tape.c            |   12 +++---
 drivers/ide/ide-taskfile.c        |   29 +++++++--------
 drivers/ide/ide.c                 |    2 -
 drivers/ide/legacy/buddha.c       |   14 +++----
 drivers/ide/legacy/falconide.c    |    6 +--
 drivers/ide/legacy/gayle.c        |   16 ++++----
 drivers/ide/legacy/ht6560b.c      |    4 +-
 drivers/ide/legacy/ide-cs.c       |    4 +-
 drivers/ide/legacy/ide_platform.c |    8 ++--
 drivers/ide/legacy/macide.c       |    4 +-
 drivers/ide/legacy/q40ide.c       |    6 +--
 drivers/ide/mips/au1xxx-ide.c     |    5 +-
 drivers/ide/mips/swarm.c          |    6 +--
 drivers/ide/pci/cmd640.c          |    8 ++--
 drivers/ide/pci/hpt366.c          |    2 -
 drivers/ide/pci/ns87415.c         |   12 +++---
 drivers/ide/pci/opti621.c         |    2 -
 drivers/ide/pci/scc_pata.c        |   23 ++++++------
 drivers/ide/pci/sgiioc4.c         |   26 ++++++-------
 drivers/ide/pci/siimage.c         |   27 ++++++--------
 drivers/ide/pci/trm290.c          |    2 -
 drivers/ide/ppc/mpc8xx.c          |    4 +-
 drivers/ide/ppc/pmac.c            |    7 ++-
 drivers/scsi/ide-scsi.c           |   13 +++---
 include/asm-arm/arch-sa1100/ide.h |    6 +--
 include/asm-cris/arch-v10/ide.h   |   11 ++---
 include/linux/ide.h               |   70 +++++++++++++++++++++---------------
 38 files changed, 274 insertions(+), 279 deletions(-)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -35,12 +35,12 @@ static int __init bastide_register(unsig
 	base += BAST_IDE_CS;
 	aux  += BAST_IDE_CS;
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw.io_ports[i] = (unsigned long)base;
+	for (i = 0; i <= 7; i++) {
+		hw.io_ports_array[i] = (unsigned long)base;
 		base += 0x20;
 	}
 
-	hw.io_ports[IDE_CONTROL_OFFSET] = aux + (6 * 0x20);
+	hw.io_ports.ctl_addr = aux + (6 * 0x20);
 	hw.irq = irq;
 
 	hwif = ide_find_port();
Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -426,11 +426,12 @@ icside_setup(void __iomem *base, struct 
 		 */
 		default_hwif_mmiops(hwif);
 
-		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-			hwif->io_ports[i] = port;
+		for (i = 0; i <= 7; i++) {
+			hwif->io_ports_array[i] = port;
 			port += 1 << info->stepping;
 		}
-		hwif->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)base + info->ctrloffset;
+		hwif->io_ports.ctl_addr =
+			(unsigned long)base + info->ctrloffset;
 		hwif->irq     = ec->irq;
 		hwif->chipset = ide_acorn;
 		hwif->gendev.parent = &ec->dev;
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -321,7 +321,7 @@ static int __devinit palm_bk3710_init_dm
 					  const struct ide_port_info *d)
 {
 	unsigned long base =
-		hwif->io_ports[IDE_DATA_OFFSET] - IDE_PALM_ATA_PRI_REG_OFFSET;
+		hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
 
 	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
 
@@ -386,8 +386,8 @@ static int __devinit palm_bk3710_probe(s
 
 	pribase = mem->start + IDE_PALM_ATA_PRI_REG_OFFSET;
 	for (i = 0; i < IDE_NR_PORTS - 2; i++)
-		hw.io_ports[i] = pribase + i;
-	hw.io_ports[IDE_CONTROL_OFFSET] = mem->start +
+		hw.io_ports_array[i] = pribase + i;
+	hw.io_ports.ctl_addr = mem->start +
 			IDE_PALM_ATA_PRI_CTL_OFFSET;
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -17,11 +17,11 @@ static void rapide_setup_ports(hw_regs_t
 	unsigned long port = (unsigned long)base;
 	int i;
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw->io_ports[i] = port;
+	for (i = 0; i <= 7; i++) {
+		hw->io_ports_array[i] = port;
 		port += sz;
 	}
-	hw->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
+	hw->io_ports.ctl_addr = (unsigned long)ctrl;
 	hw->irq = irq;
 }
 
Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -88,8 +88,8 @@ enum /* Transfer types */
 int
 cris_ide_ack_intr(ide_hwif_t* hwif)
 {
-	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2,
-	                         int, hwif->io_ports[0]);
+	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
+					       hwif->io_ports.data_addr);
 	REG_WR_INT(ata, regi_ata, rw_ack_intr, 1 << ctrl2.sel);
 	return 1;
 }
@@ -231,7 +231,7 @@ cris_ide_start_dma(ide_drive_t *drive, c
 	ide_hwif_t *hwif = drive->hwif;
 
 	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
-					       hwif->io_ports[IDE_DATA_OFFSET]);
+					       hwif->io_ports.data_addr);
 	reg_ata_rw_trf_cnt trf_cnt = {0};
 
 	mycontext.saved_data = (dma_descr_data*)virt_to_phys(d);
@@ -271,7 +271,7 @@ static int cris_dma_test_irq(ide_drive_t
 	int intr = REG_RD_INT(ata, regi_ata, r_intr);
 
 	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
-					       hwif->io_ports[IDE_DATA_OFFSET]);
+					       hwif->io_ports.data_addr);
 
 	return intr & (1 << ctrl2.sel) ? 1 : 0;
 }
@@ -531,7 +531,7 @@ static void cris_ide_start_dma(ide_drive
 	*R_ATA_CTRL_DATA =
 		cmd |
 		IO_FIELD(R_ATA_CTRL_DATA, data,
-			 drive->hwif->io_ports[IDE_DATA_OFFSET]) |
+			 drive->hwif->io_ports.data_addr) |
 		IO_STATE(R_ATA_CTRL_DATA, src_dst,  dma)  |
 		IO_STATE(R_ATA_CTRL_DATA, multi,    on)   |
 		IO_STATE(R_ATA_CTRL_DATA, dma_size, word);
@@ -550,7 +550,7 @@ static int cris_dma_test_irq(ide_drive_t
 {
 	int intr = *R_IRQ_MASK0_RD;
 	int bus = IO_EXTRACT(R_ATA_CTRL_DATA, sel,
-			     drive->hwif->io_ports[IDE_DATA_OFFSET]);
+			     drive->hwif->io_ports.data_addr);
 
 	return intr & (1 << (bus + IO_BITNR(R_IRQ_MASK0_RD, ata_irq0))) ? 1 : 0;
 }
@@ -644,7 +644,7 @@ cris_ide_inw(unsigned long reg) {
 		 * call will also timeout on busy, but as long as the
 		 * write is still performed, everything will be fine.
 		 */
-		if (cris_ide_get_reg(reg) == IDE_STATUS_OFFSET)
+		if (cris_ide_get_reg(reg) == 7)
 			return BUSY_STAT;
 		else
 			/* For other rare cases we assume 0 is good enough.  */
@@ -765,13 +765,13 @@ static void __init cris_setup_ports(hw_r
 	memset(hw, 0, sizeof(*hw));
 
 	for (i = 0; i <= 7; i++)
-		hw->io_ports[i] = base + cris_ide_reg_addr(i, 0, 1);
+		hw->io_ports_array[i] = base + cris_ide_reg_addr(i, 0, 1);
 
 	/*
 	 * the IDE control register is at ATA address 6,
 	 * with CS1 active instead of CS0
 	 */
-	hw->io_ports[IDE_CONTROL_OFFSET] = base + cris_ide_reg_addr(6, 1, 0);
+	hw->io_ports.ctl_addr = base + cris_ide_reg_addr(6, 1, 0);
 
 	hw->irq = ide_default_irq(0);
 	hw->ack_intr = cris_ide_ack_intr;
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -63,9 +63,9 @@ static inline void hw_setup(hw_regs_t *h
 	int i;
 
 	memset(hw, 0, sizeof(hw_regs_t));
-	for (i = 0; i <= IDE_STATUS_OFFSET; i++)
-		hw->io_ports[i] = CONFIG_H8300_IDE_BASE + H8300_IDE_GAP*i;
-	hw->io_ports[IDE_CONTROL_OFFSET] = CONFIG_H8300_IDE_ALT;
+	for (i = 0; i <= 7; i++)
+		hw->io_ports_array[i] = CONFIG_H8300_IDE_BASE + H8300_IDE_GAP*i;
+	hw->io_ports.ctl_addr = CONFIG_H8300_IDE_ALT;
 	hw->irq = EXT_IRQ0 + CONFIG_H8300_IDE_IRQ;
 	hw->chipset = ide_generic;
 }
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -560,7 +560,7 @@ static ide_startstop_t cdrom_start_packe
 		/* packet command */
 		spin_lock_irqsave(&ide_lock, flags);
 		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
-			       hwif->io_ports[IDE_COMMAND_OFFSET]);
+			       hwif->io_ports.command_addr);
 		ndelay(400);
 		spin_unlock_irqrestore(&ide_lock, flags);
 
@@ -952,9 +952,9 @@ static ide_startstop_t cdrom_newpc_intr(
 	}
 
 	/* ok we fall to pio :/ */
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]) & 0x3;
-	lowcyl  = hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
-	highcyl = hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr) & 0x3;
+	lowcyl  = hwif->INB(hwif->io_ports.lbam_addr);
+	highcyl = hwif->INB(hwif->io_ports.lbah_addr);
 
 	len = lowcyl + (256 * highcyl);
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -465,10 +465,10 @@ static ide_startstop_t idefloppy_pc_intr
 	}
 
 	/* Get the number of bytes to transfer */
-	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
-		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
+	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
+		  hwif->INB(hwif->io_ports.lbam_addr);
 	/* on this interrupt */
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __func__);
@@ -539,7 +539,7 @@ static ide_startstop_t idefloppy_transfe
 				"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) while "
 				"issuing a packet command\n");
@@ -586,7 +586,7 @@ static ide_startstop_t idefloppy_transfe
 				"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) "
 				"while issuing a packet command\n");
@@ -692,7 +692,7 @@ static ide_startstop_t idefloppy_issue_p
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
 		return (*pkt_xfer_routine) (drive);
 	}
 }
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -298,48 +298,43 @@ static void ide_complete_pm_request (ide
 void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
 
 	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data = hwif->INW(hwif->io_ports[IDE_DATA_OFFSET]);
+		u16 data = hwif->INW(io_ports->data_addr);
 
 		tf->data = data & 0xff;
 		tf->hob_data = (data >> 8) & 0xff;
 	}
 
 	/* be sure we're looking at the low order bits */
-	hwif->OUTB(drive->ctl & ~0x80, hwif->io_ports[IDE_CONTROL_OFFSET]);
+	hwif->OUTB(drive->ctl & ~0x80, io_ports->ctl_addr);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = hwif->INB(hwif->io_ports[IDE_NSECTOR_OFFSET]);
+		tf->nsect  = hwif->INB(io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = hwif->INB(hwif->io_ports[IDE_SECTOR_OFFSET]);
+		tf->lbal   = hwif->INB(io_ports->lbal_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = hwif->INB(hwif->io_ports[IDE_LCYL_OFFSET]);
+		tf->lbam   = hwif->INB(io_ports->lbam_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = hwif->INB(hwif->io_ports[IDE_HCYL_OFFSET]);
+		tf->lbah   = hwif->INB(io_ports->lbah_addr);
 	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = hwif->INB(hwif->io_ports[IDE_SELECT_OFFSET]);
+		tf->device = hwif->INB(io_ports->device_addr);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		hwif->OUTB(drive->ctl | 0x80,
-			   hwif->io_ports[IDE_CONTROL_OFFSET]);
+		hwif->OUTB(drive->ctl | 0x80, io_ports->ctl_addr);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature =
-				hwif->INB(hwif->io_ports[IDE_FEATURE_OFFSET]);
+			tf->hob_feature = hwif->INB(io_ports->feature_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   =
-				hwif->INB(hwif->io_ports[IDE_NSECTOR_OFFSET]);
+			tf->hob_nsect   = hwif->INB(io_ports->nsect_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    =
-				hwif->INB(hwif->io_ports[IDE_SECTOR_OFFSET]);
+			tf->hob_lbal    = hwif->INB(io_ports->lbal_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    =
-				hwif->INB(hwif->io_ports[IDE_LCYL_OFFSET]);
+			tf->hob_lbam    = hwif->INB(io_ports->lbam_addr);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    =
-				hwif->INB(hwif->io_ports[IDE_HCYL_OFFSET]);
+			tf->hob_lbah    = hwif->INB(io_ports->lbah_addr);
 	}
 }
 
@@ -454,7 +449,7 @@ static ide_startstop_t ide_ata_error(ide
 		if (err == ABRT_ERR) {
 			if (drive->select.b.lba &&
 			    /* some newer drives don't support WIN_SPECIFY */
-			    hwif->INB(hwif->io_ports[IDE_COMMAND_OFFSET]) ==
+			    hwif->INB(hwif->io_ports.command_addr) ==
 				WIN_SPECIFY)
 				return ide_stopped;
 		} else if ((err & BAD_CRC) == BAD_CRC) {
@@ -507,8 +502,7 @@ static ide_startstop_t ide_atapi_error(i
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE,
-			   hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTB(WIN_IDLEIMMEDIATE, hwif->io_ports.command_addr);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
@@ -1421,7 +1415,7 @@ static void unexpected_intr (int irq, id
 	 */
 	do {
 		if (hwif->irq == irq) {
-			stat = hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+			stat = hwif->INB(hwif->io_ports.status_addr);
 			if (!OK_STAT(stat, READY_STAT, BAD_STAT)) {
 				/* Try to not flood the console with msgs */
 				static unsigned long last_msgtime, count;
@@ -1511,7 +1505,7 @@ irqreturn_t ide_intr (int irq, void *dev
 			 * Whack the status register, just in case
 			 * we have a leftover pending IRQ.
 			 */
-			(void) hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+			(void) hwif->INB(hwif->io_ports.status_addr);
 #endif /* CONFIG_BLK_DEV_IDEPCI */
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -164,7 +164,7 @@ void SELECT_DRIVE (ide_drive_t *drive)
 	if (port_ops && port_ops->selectproc)
 		port_ops->selectproc(drive);
 
-	hwif->OUTB(drive->select.all, hwif->io_ports[IDE_SELECT_OFFSET]);
+	hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
 }
 
 void SELECT_MASK (ide_drive_t *drive, int mask)
@@ -194,24 +194,22 @@ static void ata_vlb_sync(ide_drive_t *dr
  */
 static void ata_input_data(ide_drive_t *drive, void *buffer, u32 wcount)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 io_32bit		= drive->io_32bit;
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	u8 io_32bit = drive->io_32bit;
 
 	if (io_32bit) {
 		if (io_32bit & 2) {
 			unsigned long flags;
 
 			local_irq_save(flags);
-			ata_vlb_sync(drive, hwif->io_ports[IDE_NSECTOR_OFFSET]);
-			hwif->INSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-				   wcount);
+			ata_vlb_sync(drive, io_ports->nsect_addr);
+			hwif->INSL(io_ports->data_addr, buffer, wcount);
 			local_irq_restore(flags);
 		} else
-			hwif->INSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-				   wcount);
+			hwif->INSL(io_ports->data_addr, buffer, wcount);
 	} else
-		hwif->INSW(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-			   wcount << 1);
+		hwif->INSW(io_ports->data_addr, buffer, wcount << 1);
 }
 
 /*
@@ -219,24 +217,22 @@ static void ata_input_data(ide_drive_t *
  */
 static void ata_output_data(ide_drive_t *drive, void *buffer, u32 wcount)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 io_32bit		= drive->io_32bit;
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	u8 io_32bit = drive->io_32bit;
 
 	if (io_32bit) {
 		if (io_32bit & 2) {
 			unsigned long flags;
 
 			local_irq_save(flags);
-			ata_vlb_sync(drive, hwif->io_ports[IDE_NSECTOR_OFFSET]);
-			hwif->OUTSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-				    wcount);
+			ata_vlb_sync(drive, io_ports->nsect_addr);
+			hwif->OUTSL(io_ports->data_addr, buffer, wcount);
 			local_irq_restore(flags);
 		} else
-			hwif->OUTSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-				    wcount);
+			hwif->OUTSL(io_ports->data_addr, buffer, wcount);
 	} else
-		hwif->OUTSW(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-			    wcount << 1);
+		hwif->OUTSW(io_ports->data_addr, buffer, wcount << 1);
 }
 
 /*
@@ -255,14 +251,13 @@ static void atapi_input_bytes(ide_drive_
 #if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
 	if (MACH_IS_ATARI || MACH_IS_Q40) {
 		/* Atari has a byte-swapped IDE interface */
-		insw_swapw(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-			   bytecount / 2);
+		insw_swapw(hwif->io_ports.data_addr, buffer, bytecount / 2);
 		return;
 	}
 #endif /* CONFIG_ATARI || CONFIG_Q40 */
 	hwif->ata_input_data(drive, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
-		hwif->INSW(hwif->io_ports[IDE_DATA_OFFSET],
+		hwif->INSW(hwif->io_ports.data_addr,
 			   (u8 *)buffer + (bytecount & ~0x03), 1);
 }
 
@@ -274,14 +269,13 @@ static void atapi_output_bytes(ide_drive
 #if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
 	if (MACH_IS_ATARI || MACH_IS_Q40) {
 		/* Atari has a byte-swapped IDE interface */
-		outsw_swapw(hwif->io_ports[IDE_DATA_OFFSET], buffer,
-			    bytecount / 2);
+		outsw_swapw(hwif->io_ports.data_addr, buffer, bytecount / 2);
 		return;
 	}
 #endif /* CONFIG_ATARI || CONFIG_Q40 */
 	hwif->ata_output_data(drive, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
-		hwif->OUTSW(hwif->io_ports[IDE_DATA_OFFSET],
+		hwif->OUTSW(hwif->io_ports.data_addr,
 			    (u8 *)buffer + (bytecount & ~0x03), 1);
 }
 
@@ -445,7 +439,7 @@ int drive_is_ready (ide_drive_t *drive)
 	 * an interrupt with another pci card/device.  We make no assumptions
 	 * about possible isa-pnp and pci-pnp issues yet.
 	 */
-	if (hwif->io_ports[IDE_CONTROL_OFFSET])
+	if (hwif->io_ports.ctl_addr)
 		stat = ide_read_altstatus(drive);
 	else
 		/* Note: this may clear a pending IRQ!! */
@@ -647,7 +641,7 @@ int ide_driveid_update(ide_drive_t *driv
 	SELECT_MASK(drive, 1);
 	ide_set_irq(drive, 1);
 	msleep(50);
-	hwif->OUTB(WIN_IDENTIFY, hwif->io_ports[IDE_COMMAND_OFFSET]);
+	hwif->OUTB(WIN_IDENTIFY, hwif->io_ports.command_addr);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -696,6 +690,7 @@ int ide_driveid_update(ide_drive_t *driv
 int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	int error = 0;
 	u8 stat;
 
@@ -734,10 +729,9 @@ int ide_config_drive_speed(ide_drive_t *
 	SELECT_MASK(drive, 0);
 	udelay(1);
 	ide_set_irq(drive, 0);
-	hwif->OUTB(speed, hwif->io_ports[IDE_NSECTOR_OFFSET]);
-	hwif->OUTB(SETFEATURES_XFER, hwif->io_ports[IDE_FEATURE_OFFSET]);
-	hwif->OUTBSYNC(drive, WIN_SETFEATURES,
-		       hwif->io_ports[IDE_COMMAND_OFFSET]);
+	hwif->OUTB(speed, io_ports->nsect_addr);
+	hwif->OUTB(SETFEATURES_XFER, io_ports->feature_addr);
+	hwif->OUTBSYNC(drive, WIN_SETFEATURES, io_ports->command_addr);
 	if (drive->quirk_list == 2)
 		ide_set_irq(drive, 1);
 
@@ -845,7 +839,7 @@ void ide_execute_command(ide_drive_t *dr
 
 	spin_lock_irqsave(&ide_lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	hwif->OUTBSYNC(drive, cmd, hwif->io_ports[IDE_COMMAND_OFFSET]);
+	hwif->OUTBSYNC(drive, cmd, hwif->io_ports.command_addr);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -1029,6 +1023,7 @@ static ide_startstop_t do_reset1 (ide_dr
 	unsigned long flags;
 	ide_hwif_t *hwif;
 	ide_hwgroup_t *hwgroup;
+	struct ide_io_ports *io_ports;
 	const struct ide_port_ops *port_ops;
 	u8 ctl;
 
@@ -1036,6 +1031,8 @@ static ide_startstop_t do_reset1 (ide_dr
 	hwif = HWIF(drive);
 	hwgroup = HWGROUP(drive);
 
+	io_ports = &hwif->io_ports;
+
 	/* We must not reset with running handlers */
 	BUG_ON(hwgroup->handler != NULL);
 
@@ -1045,8 +1042,7 @@ static ide_startstop_t do_reset1 (ide_dr
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		hwif->OUTBSYNC(drive, WIN_SRST,
-			       hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTBSYNC(drive, WIN_SRST, io_ports->command_addr);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
@@ -1062,7 +1058,7 @@ static ide_startstop_t do_reset1 (ide_dr
 	for (unit = 0; unit < MAX_DRIVES; ++unit)
 		pre_reset(&hwif->drives[unit]);
 
-	if (hwif->io_ports[IDE_CONTROL_OFFSET] == 0) {
+	if (io_ports->ctl_addr == 0) {
 		spin_unlock_irqrestore(&ide_lock, flags);
 		return ide_stopped;
 	}
@@ -1077,14 +1073,14 @@ static ide_startstop_t do_reset1 (ide_dr
 	 * recover from reset very quickly, saving us the first 50ms wait time.
 	 */
 	/* set SRST and nIEN */
-	hwif->OUTBSYNC(drive, drive->ctl|6, hwif->io_ports[IDE_CONTROL_OFFSET]);
+	hwif->OUTBSYNC(drive, drive->ctl|6, io_ports->ctl_addr);
 	/* more than enough time */
 	udelay(10);
 	if (drive->quirk_list == 2)
 		ctl = drive->ctl;	/* clear SRST and nIEN */
 	else
 		ctl = drive->ctl | 2;	/* clear SRST, leave nIEN */
-	hwif->OUTBSYNC(drive, ctl, hwif->io_ports[IDE_CONTROL_OFFSET]);
+	hwif->OUTBSYNC(drive, ctl, io_ports->ctl_addr);
 	/* more than enough time */
 	udelay(10);
 	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
@@ -1129,7 +1125,7 @@ int ide_wait_not_busy(ide_hwif_t *hwif, 
 		 * about locking issues (2.5 work ?).
 		 */
 		mdelay(1);
-		stat = hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+		stat = hwif->INB(hwif->io_ports.status_addr);
 		if ((stat & BUSY_STAT) == 0)
 			return 0;
 		/*
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -266,6 +266,7 @@ err_misc:
 static int actual_try_to_identify (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	int use_altstatus = 0, rc;
 	unsigned long timeout;
 	u8 s = 0, a = 0;
@@ -273,7 +274,7 @@ static int actual_try_to_identify (ide_d
 	/* take a deep breath */
 	msleep(50);
 
-	if (hwif->io_ports[IDE_CONTROL_OFFSET]) {
+	if (io_ports->ctl_addr) {
 		a = ide_read_altstatus(drive);
 		s = ide_read_status(drive);
 		if ((a ^ s) & ~INDEX_STAT)
@@ -291,10 +292,10 @@ static int actual_try_to_identify (ide_d
 	 */
 	if ((cmd == WIN_PIDENTIFY))
 		/* disable dma & overlap */
-		hwif->OUTB(0, hwif->io_ports[IDE_FEATURE_OFFSET]);
+		hwif->OUTB(0, io_ports->feature_addr);
 
 	/* ask drive for ID */
-	hwif->OUTB(cmd, hwif->io_ports[IDE_COMMAND_OFFSET]);
+	hwif->OUTB(cmd, io_ports->command_addr);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -355,7 +356,7 @@ static int try_to_identify (ide_drive_t 
 	 * interrupts during the identify-phase that
 	 * the irq handler isn't expecting.
 	 */
-	if (hwif->io_ports[IDE_CONTROL_OFFSET]) {
+	if (hwif->io_ports.ctl_addr) {
 		if (!hwif->irq) {
 			autoprobe = 1;
 			cookie = probe_irq_on();
@@ -395,7 +396,7 @@ static int ide_busy_sleep(ide_hwif_t *hw
 
 	do {
 		msleep(50);
-		stat = hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+		stat = hwif->INB(hwif->io_ports.status_addr);
 		if ((stat & BUSY_STAT) == 0)
 			return 0;
 	} while (time_before(jiffies, timeout));
@@ -427,6 +428,7 @@ static int ide_busy_sleep(ide_hwif_t *hw
 static int do_probe (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	int rc;
 	u8 stat;
 
@@ -447,7 +449,7 @@ static int do_probe (ide_drive_t *drive,
 	msleep(50);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	if (hwif->INB(hwif->io_ports[IDE_SELECT_OFFSET]) != drive->select.all &&
+	if (hwif->INB(io_ports->device_addr) != drive->select.all &&
 	    !drive->present) {
 		if (drive->select.b.unit != 0) {
 			/* exit with drive0 selected */
@@ -478,11 +480,9 @@ static int do_probe (ide_drive_t *drive,
 			printk(KERN_ERR "%s: no response (status = 0x%02x), "
 					"resetting drive\n", drive->name, stat);
 			msleep(50);
-			hwif->OUTB(drive->select.all,
-				   hwif->io_ports[IDE_SELECT_OFFSET]);
+			hwif->OUTB(drive->select.all, io_ports->device_addr);
 			msleep(50);
-			hwif->OUTB(WIN_SRST,
-				   hwif->io_ports[IDE_COMMAND_OFFSET]);
+			hwif->OUTB(WIN_SRST, io_ports->command_addr);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
@@ -518,7 +518,7 @@ static void enable_nest (ide_drive_t *dr
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->OUTB(EXABYTE_ENABLE_NEST, hwif->io_ports[IDE_COMMAND_OFFSET]);
+	hwif->OUTB(EXABYTE_ENABLE_NEST, hwif->io_ports.command_addr);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
@@ -984,6 +984,7 @@ static void ide_port_setup_devices(ide_h
  */
 static int init_irq (ide_hwif_t *hwif)
 {
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned int index;
 	ide_hwgroup_t *hwgroup;
 	ide_hwif_t *match = NULL;
@@ -1067,9 +1068,9 @@ static int init_irq (ide_hwif_t *hwif)
 		if (IDE_CHIPSET_IS_PCI(hwif->chipset))
 			sa = IRQF_SHARED;
 
-		if (hwif->io_ports[IDE_CONTROL_OFFSET])
+		if (io_ports->ctl_addr)
 			/* clear nIEN */
-			hwif->OUTB(0x08, hwif->io_ports[IDE_CONTROL_OFFSET]);
+			hwif->OUTB(0x08, io_ports->ctl_addr);
 
 		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
 	       		goto out_unlink;
@@ -1085,12 +1086,11 @@ static int init_irq (ide_hwif_t *hwif)
 
 #if !defined(__mc68000__)
 	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
-		hwif->io_ports[IDE_DATA_OFFSET],
-		hwif->io_ports[IDE_DATA_OFFSET]+7,
-		hwif->io_ports[IDE_CONTROL_OFFSET], hwif->irq);
+		io_ports->data_addr, io_ports->status_addr,
+		io_ports->ctl_addr, hwif->irq);
 #else
 	printk("%s at 0x%08lx on irq %d", hwif->name,
-		hwif->io_ports[IDE_DATA_OFFSET], hwif->irq);
+		io_ports->data_addr, hwif->irq);
 #endif /* __mc68000__ */
 	if (match)
 		printk(" (%sed with %s)",
@@ -1232,8 +1232,8 @@ static int hwif_init(ide_hwif_t *hwif)
 	int old_irq;
 
 	if (!hwif->irq) {
-		if (!(hwif->irq = ide_default_irq(hwif->io_ports[IDE_DATA_OFFSET])))
-		{
+		hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
+		if (!hwif->irq) {
 			printk("%s: DISABLED, NO IRQ\n", hwif->name);
 			return 0;
 		}
@@ -1262,7 +1262,8 @@ static int hwif_init(ide_hwif_t *hwif)
 	 *	It failed to initialise. Find the default IRQ for 
 	 *	this port and try that.
 	 */
-	if (!(hwif->irq = ide_default_irq(hwif->io_ports[IDE_DATA_OFFSET]))) {
+	hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
+	if (!hwif->irq) {
 		printk("%s: Disabled unable to get IRQ %d.\n",
 			hwif->name, old_irq);
 		goto out;
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -849,10 +849,10 @@ static ide_startstop_t idetape_pc_intr(i
 		return ide_do_reset(drive);
 	}
 	/* Get the number of bytes to transfer on this interrupt. */
-	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
-		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
+	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
+		  hwif->INB(hwif->io_ports.lbam_addr);
 
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
@@ -956,12 +956,12 @@ static ide_startstop_t idetape_transfer_
 				"yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
 		printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n");
 		udelay(100);
-		ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+		ireason = hwif->INB(hwif->io_ports.nsect_addr);
 		if (retries == 0) {
 			printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while "
 					"issuing a packet command, ignoring\n");
@@ -1058,7 +1058,7 @@ static ide_startstop_t idetape_issue_pc(
 				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
 	} else {
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
 		return idetape_transfer_pc(drive);
 	}
 }
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -36,6 +36,7 @@
 void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &task->tf;
 	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
@@ -59,34 +60,33 @@ void ide_tf_load(ide_drive_t *drive, ide
 		SELECT_MASK(drive, 0);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
-		hwif->OUTW((tf->hob_data << 8) | tf->data,
-			   hwif->io_ports[IDE_DATA_OFFSET]);
+		hwif->OUTW((tf->hob_data << 8) | tf->data, io_ports->data_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		hwif->OUTB(tf->hob_feature, hwif->io_ports[IDE_FEATURE_OFFSET]);
+		hwif->OUTB(tf->hob_feature, io_ports->feature_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		hwif->OUTB(tf->hob_nsect, hwif->io_ports[IDE_NSECTOR_OFFSET]);
+		hwif->OUTB(tf->hob_nsect, io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		hwif->OUTB(tf->hob_lbal, hwif->io_ports[IDE_SECTOR_OFFSET]);
+		hwif->OUTB(tf->hob_lbal, io_ports->lbal_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		hwif->OUTB(tf->hob_lbam, hwif->io_ports[IDE_LCYL_OFFSET]);
+		hwif->OUTB(tf->hob_lbam, io_ports->lbam_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		hwif->OUTB(tf->hob_lbah, hwif->io_ports[IDE_HCYL_OFFSET]);
+		hwif->OUTB(tf->hob_lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		hwif->OUTB(tf->feature, hwif->io_ports[IDE_FEATURE_OFFSET]);
+		hwif->OUTB(tf->feature, io_ports->feature_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		hwif->OUTB(tf->nsect, hwif->io_ports[IDE_NSECTOR_OFFSET]);
+		hwif->OUTB(tf->nsect, io_ports->nsect_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		hwif->OUTB(tf->lbal, hwif->io_ports[IDE_SECTOR_OFFSET]);
+		hwif->OUTB(tf->lbal, io_ports->lbal_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		hwif->OUTB(tf->lbam, hwif->io_ports[IDE_LCYL_OFFSET]);
+		hwif->OUTB(tf->lbam, io_ports->lbam_addr);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		hwif->OUTB(tf->lbah, hwif->io_ports[IDE_HCYL_OFFSET]);
+		hwif->OUTB(tf->lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		hwif->OUTB((tf->device & HIHI) | drive->select.all,
-			   hwif->io_ports[IDE_SELECT_OFFSET]);
+			   io_ports->device_addr);
 }
 
 int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
@@ -155,8 +155,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
 	case TASKFILE_OUT:
-		hwif->OUTBSYNC(drive, tf->command,
-			       hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTBSYNC(drive, tf->command, hwif->io_ports.command_addr);
 		ndelay(400);	/* FIXME */
 		return pre_task_out_intr(drive, task->rq);
 	case TASKFILE_MULTI_IN:
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -295,7 +295,7 @@ EXPORT_SYMBOL(ide_unregister);
 
 void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 {
-	memcpy(hwif->io_ports, hw->io_ports, sizeof(hwif->io_ports));
+	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
 	hwif->irq = hw->irq;
 	hwif->chipset = hw->chipset;
 	hwif->gendev.parent = hw->dev;
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -102,7 +102,7 @@ static int buddha_ack_intr(ide_hwif_t *h
 {
     unsigned char ch;
 
-    ch = z_readb(hwif->io_ports[IDE_IRQ_OFFSET]);
+    ch = z_readb(hwif->io_ports.irq_addr);
     if (!(ch & 0x80))
 	    return 0;
     return 1;
@@ -112,9 +112,9 @@ static int xsurf_ack_intr(ide_hwif_t *hw
 {
     unsigned char ch;
 
-    ch = z_readb(hwif->io_ports[IDE_IRQ_OFFSET]);
+    ch = z_readb(hwif->io_ports.irq_addr);
     /* X-Surf needs a 0 written to IRQ register to ensure ISA bit A11 stays at 0 */
-    z_writeb(0, hwif->io_ports[IDE_IRQ_OFFSET]); 
+    z_writeb(0, hwif->io_ports.irq_addr);
     if (!(ch & 0x80))
 	    return 0;
     return 1;
@@ -128,13 +128,13 @@ static void __init buddha_setup_ports(hw
 
 	memset(hw, 0, sizeof(*hw));
 
-	hw->io_ports[IDE_DATA_OFFSET] = base;
+	hw->io_ports.data_addr = base;
 
 	for (i = 1; i < 8; i++)
-		hw->io_ports[i] = base + 2 + i * 4;
+		hw->io_ports_array[i] = base + 2 + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ctl;
-	hw->io_ports[IDE_IRQ_OFFSET] = irq_port;
+	hw->io_ports.ctl_addr = ctl;
+	hw->io_ports.irq_addr = irq_port;
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -50,12 +50,12 @@ static void __init falconide_setup_ports
 
 	memset(hw, 0, sizeof(*hw));
 
-	hw->io_ports[IDE_DATA_OFFSET] = ATA_HD_BASE;
+	hw->io_ports.data_addr = ATA_HD_BASE;
 
 	for (i = 1; i < 8; i++)
-		hw->io_ports[i] = ATA_HD_BASE + 1 + i * 4;
+		hw->io_ports_array[i] = ATA_HD_BASE + 1 + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ATA_HD_BASE + ATA_HD_CONTROL;
+	hw->io_ports.ctl_addr = ATA_HD_BASE + ATA_HD_CONTROL;
 
 	hw->irq = IRQ_MFP_IDE;
 	hw->ack_intr = NULL;
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -77,7 +77,7 @@ static int gayle_ack_intr_a4000(ide_hwif
 {
     unsigned char ch;
 
-    ch = z_readb(hwif->io_ports[IDE_IRQ_OFFSET]);
+    ch = z_readb(hwif->io_ports.irq_addr);
     if (!(ch & GAYLE_IRQ_IDE))
 	return 0;
     return 1;
@@ -87,11 +87,11 @@ static int gayle_ack_intr_a1200(ide_hwif
 {
     unsigned char ch;
 
-    ch = z_readb(hwif->io_ports[IDE_IRQ_OFFSET]);
+    ch = z_readb(hwif->io_ports.irq_addr);
     if (!(ch & GAYLE_IRQ_IDE))
 	return 0;
-    (void)z_readb(hwif->io_ports[IDE_STATUS_OFFSET]);
-    z_writeb(0x7c, hwif->io_ports[IDE_IRQ_OFFSET]);
+    (void)z_readb(hwif->io_ports.status_addr);
+    z_writeb(0x7c, hwif->io_ports.irq_addr);
     return 1;
 }
 
@@ -103,13 +103,13 @@ static void __init gayle_setup_ports(hw_
 
 	memset(hw, 0, sizeof(*hw));
 
-	hw->io_ports[IDE_DATA_OFFSET] = base;
+	hw->io_ports.data_addr = base;
 
 	for (i = 1; i < 8; i++)
-		hw->io_ports[i] = base + 2 + i * 4;
+		hw->io_ports_array[i] = base + 2 + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ctl;
-	hw->io_ports[IDE_IRQ_OFFSET] = irq_port;
+	hw->io_ports.ctl_addr = ctl;
+	hw->io_ports.irq_addr = irq_port;
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -157,8 +157,8 @@ static void ht6560b_selectproc (ide_driv
 		/*
 		 * Set timing for this drive:
 		 */
-		outb(timing, hwif->io_ports[IDE_SELECT_OFFSET]);
-		(void)inb(hwif->io_ports[IDE_STATUS_OFFSET]);
+		outb(timing, hwif->io_ports.device_addr);
+		(void)inb(hwif->io_ports.status_addr);
 #ifdef DEBUG
 		printk("ht6560b: %s: select=%#x timing=%#x\n",
 			drive->name, select, timing);
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -140,8 +140,8 @@ static void ide_detach(struct pcmcia_dev
 
     ide_release(link);
 
-    release_region(hwif->io_ports[IDE_CONTROL_OFFSET], 1);
-    release_region(hwif->io_ports[IDE_DATA_OFFSET], 8);
+    release_region(hwif->io_ports.ctl_addr, 1);
+    release_region(hwif->io_ports.data_addr, 8);
 
     kfree(info);
 } /* ide_detach */
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -30,14 +30,14 @@ static void __devinit plat_ide_setup_por
 	unsigned long port = (unsigned long)base;
 	int i;
 
-	hw->io_ports[IDE_DATA_OFFSET] = port;
+	hw->io_ports.data_addr = port;
 
 	port += (1 << pdata->ioport_shift);
-	for (i = IDE_ERROR_OFFSET; i <= IDE_STATUS_OFFSET;
+	for (i = 1; i <= 7;
 	     i++, port += (1 << pdata->ioport_shift))
-		hw->io_ports[i] = port;
+		hw->io_ports_array[i] = port;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
+	hw->io_ports.ctl_addr = (unsigned long)ctrl;
 
 	hw->irq = irq;
 
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -72,9 +72,9 @@ static void __init macide_setup_ports(hw
 	memset(hw, 0, sizeof(*hw));
 
 	for (i = 0; i < 8; i++)
-		hw->io_ports[i] = base + i * 4;
+		hw->io_ports_array[i] = base + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = base + IDE_CONTROL;
+	hw->io_ports.ctl_addr = base + IDE_CONTROL;
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -80,10 +80,10 @@ void q40_ide_setup_ports ( hw_regs_t *hw
 	for (i = 0; i < IDE_NR_PORTS; i++) {
 		/* BIG FAT WARNING: 
 		   assumption: only DATA port is ever used in 16 bit mode */
-		if ( i==0 )
-			hw->io_ports[i] = Q40_ISA_IO_W(base + offsets[i]);
+		if (i == 0)
+			hw->io_ports_array[i] = Q40_ISA_IO_W(base + offsets[i]);
 		else
-			hw->io_ports[i] = Q40_ISA_IO_B(base + offsets[i]);
+			hw->io_ports_array[i] = Q40_ISA_IO_B(base + offsets[i]);
 	}
 
 	hw->irq = irq;
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -507,12 +507,11 @@ static int auide_ddma_init(ide_hwif_t *h
 static void auide_setup_ports(hw_regs_t *hw, _auide_hwif *ahwif)
 {
 	int i;
-	unsigned long *ata_regs = hw->io_ports;
+	unsigned long *ata_regs = hw->io_ports_array;
 
 	/* FIXME? */
-	for (i = 0; i < IDE_CONTROL_OFFSET; i++) {
+	for (i = 0; i < 8; i++)
 		*ata_regs++ = ahwif->regbase + (i << AU1XXX_ATA_REG_OFFSET);
-	}
 
 	/* set the Alternative Status register */
 	*ata_regs = ahwif->regbase + (14 << AU1XXX_ATA_REG_OFFSET);
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -113,10 +113,10 @@ static int __devinit swarm_ide_probe(str
 
 	hwif->chipset = ide_generic;
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		hwif->io_ports[i] =
+	for (i = 0; i <= 7; i++)
+		hwif->io_ports_array[i] =
 				(unsigned long)(base + ((0x1f0 + i) << 5));
-	hwif->io_ports[IDE_CONTROL_OFFSET] =
+	hwif->io_ports.ctl_addr =
 				(unsigned long)(base + (0x3f6 << 5));
 	hwif->irq = K_INT_GB_IDE;
 
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -347,12 +347,12 @@ static int __init secondary_port_respond
 
 	spin_lock_irqsave(&cmd640_lock, flags);
 
-	outb_p(0x0a, 0x170 + IDE_SELECT_OFFSET);	/* select drive0 */
+	outb_p(0x0a, 0x176);	/* select drive0 */
 	udelay(100);
-	if ((inb_p(0x170 + IDE_SELECT_OFFSET) & 0x1f) != 0x0a) {
-		outb_p(0x1a, 0x170 + IDE_SELECT_OFFSET); /* select drive1 */
+	if ((inb_p(0x176) & 0x1f) != 0x0a) {
+		outb_p(0x1a, 0x176); /* select drive1 */
 		udelay(100);
-		if ((inb_p(0x170 + IDE_SELECT_OFFSET) & 0x1f) != 0x1a) {
+		if ((inb_p(0x176) & 0x1f) != 0x1a) {
 			spin_unlock_irqrestore(&cmd640_lock, flags);
 			return 0; /* nothing responded */
 		}
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -760,7 +760,7 @@ static void hpt3xx_maskproc(ide_drive_t 
 		}
 	} else
 		outb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-		     hwif->io_ports[IDE_CONTROL_OFFSET]);
+		     hwif->io_ports.ctl_addr);
 }
 
 /*
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -72,8 +72,8 @@ static void __devinit superio_ide_init_i
 	base = pci_resource_start(pdev, port * 2) & ~3;
 	dmabase = pci_resource_start(pdev, 4) & ~3;
 
-	superio_ide_status[port] = base + IDE_STATUS_OFFSET;
-	superio_ide_select[port] = base + IDE_SELECT_OFFSET;
+	superio_ide_status[port] = base + 7;
+	superio_ide_select[port] = base + 6;
 	superio_ide_dma_status[port] = dmabase + (!port ? 2 : 0xa);
 
 	/* Clear error/interrupt, enable dma */
@@ -231,12 +231,12 @@ static void __devinit init_hwif_ns87415 
 		 *      SELECT_DRIVE() properly during first ide_probe_port().
 		 */
 		timeout = 10000;
-		outb(12, hwif->io_ports[IDE_CONTROL_OFFSET]);
+		outb(12, hwif->io_ports.ctl_addr);
 		udelay(10);
-		outb(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
+		outb(8, hwif->io_ports.ctl_adrr);
 		do {
 			udelay(50);
-			stat = hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+			stat = hwif->INB(hwif->io_ports.status_addr);
                 	if (stat == 0xff)
                         	break;
         	} while ((stat & BUSY_STAT) && --timeout);
@@ -244,7 +244,7 @@ static void __devinit init_hwif_ns87415 
 	}
 
 	if (!using_inta)
-		hwif->irq = ide_default_irq(hwif->io_ports[IDE_DATA_OFFSET]);
+		hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
 	else if (!hwif->irq && hwif->mate && hwif->mate->irq)
 		hwif->irq = hwif->mate->irq;	/* share IRQ with mate */
 
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -279,7 +279,7 @@ static void opti621_set_pio_mode(ide_dri
 
 	spin_lock_irqsave(&opti621_lock, flags);
 
-	reg_base = hwif->io_ports[IDE_DATA_OFFSET];
+	reg_base = hwif->io_ports.data_addr;
 
 	/* allow Register-B */
 	outb(0xc0, reg_base + CNTRL_REG);
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -334,7 +334,7 @@ static int scc_dma_end(ide_drive_t *driv
 
 	/* errata A308 workaround: Step5 (check data loss) */
 	/* We don't check non ide_disk because it is limited to UDMA4 */
-	if (!(in_be32((void __iomem *)hwif->io_ports[IDE_ALTSTATUS_OFFSET])
+	if (!(in_be32((void __iomem *)hwif->io_ports.ctl_addr)
 	      & ERR_STAT) &&
 	    drive->media == ide_disk && drive->current_speed > XFER_UDMA_4) {
 		reg = in_be32((void __iomem *)intsts_port);
@@ -438,7 +438,7 @@ static int scc_dma_test_irq(ide_drive_t 
 	u32 int_stat = in_be32((void __iomem *)hwif->dma_base + 0x014);
 
 	/* SCC errata A252,A308 workaround: Step4 */
-	if ((in_be32((void __iomem *)hwif->io_ports[IDE_ALTSTATUS_OFFSET])
+	if ((in_be32((void __iomem *)hwif->io_ports.ctl_addr)
 	     & ERR_STAT) &&
 	    (int_stat & INTSTS_INTRQ))
 		return 1;
@@ -584,6 +584,7 @@ static void __devinit init_mmio_iops_scc
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct scc_ports *ports = pci_get_drvdata(dev);
+	struct ide_io_ports *io_ports = &hwif->io_ports;
 	unsigned long dma_base = ports->dma;
 
 	ide_set_hwifdata(hwif, ports);
@@ -598,15 +599,15 @@ static void __devinit init_mmio_iops_scc
 	hwif->OUTSW = scc_ide_outsw;
 	hwif->OUTSL = scc_ide_outsl;
 
-	hwif->io_ports[IDE_DATA_OFFSET] = dma_base + 0x20;
-	hwif->io_ports[IDE_ERROR_OFFSET] = dma_base + 0x24;
-	hwif->io_ports[IDE_NSECTOR_OFFSET] = dma_base + 0x28;
-	hwif->io_ports[IDE_SECTOR_OFFSET] = dma_base + 0x2c;
-	hwif->io_ports[IDE_LCYL_OFFSET] = dma_base + 0x30;
-	hwif->io_ports[IDE_HCYL_OFFSET] = dma_base + 0x34;
-	hwif->io_ports[IDE_SELECT_OFFSET] = dma_base + 0x38;
-	hwif->io_ports[IDE_STATUS_OFFSET] = dma_base + 0x3c;
-	hwif->io_ports[IDE_CONTROL_OFFSET] = dma_base + 0x40;
+	io_ports->data_addr	= dma_base + 0x20;
+	io_ports->error_addr	= dma_base + 0x24;
+	io_ports->nsect_addr	= dma_base + 0x28;
+	io_ports->lbal_addr	= dma_base + 0x2c;
+	io_ports->lbam_addr	= dma_base + 0x30;
+	io_ports->lbah_addr	= dma_base + 0x34;
+	io_ports->device_addr	= dma_base + 0x38;
+	io_ports->status_addr	= dma_base + 0x3c;
+	io_ports->ctl_addr	= dma_base + 0x40;
 
 	hwif->irq = dev->irq;
 	hwif->dma_base = dma_base;
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -98,28 +98,28 @@ sgiioc4_init_hwif_ports(hw_regs_t * hw, 
 	int i;
 
 	/* Registers are word (32 bit) aligned */
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		hw->io_ports[i] = reg + i * 4;
+	for (i = 0; i <= 7; i++)
+		hw->io_ports_array[i] = reg + i * 4;
 
 	if (ctrl_port)
-		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
+		hw->io_ports.ctl_addr = ctrl_port;
 
 	if (irq_port)
-		hw->io_ports[IDE_IRQ_OFFSET] = irq_port;
+		hw->io_ports.irq_addr = irq_port;
 }
 
 static void
 sgiioc4_maskproc(ide_drive_t * drive, int mask)
 {
 	writeb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-	       (void __iomem *)drive->hwif->io_ports[IDE_CONTROL_OFFSET]);
+	       (void __iomem *)drive->hwif->io_ports.ctl_addr);
 }
 
 static int
 sgiioc4_checkirq(ide_hwif_t * hwif)
 {
 	unsigned long intr_addr =
-		hwif->io_ports[IDE_IRQ_OFFSET] + IOC4_INTR_REG * 4;
+		hwif->io_ports.irq_addr + IOC4_INTR_REG * 4;
 
 	if ((u8)readl((void __iomem *)intr_addr) & 0x03)
 		return 1;
@@ -134,8 +134,8 @@ sgiioc4_clearirq(ide_drive_t * drive)
 {
 	u32 intr_reg;
 	ide_hwif_t *hwif = HWIF(drive);
-	unsigned long other_ir =
-	    hwif->io_ports[IDE_IRQ_OFFSET] + (IOC4_INTR_REG << 2);
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long other_ir = io_ports->irq_addr + (IOC4_INTR_REG << 2);
 
 	/* Code to check for PCI error conditions */
 	intr_reg = readl((void __iomem *)other_ir);
@@ -147,12 +147,12 @@ sgiioc4_clearirq(ide_drive_t * drive)
 		 * a "clear" status if it got cleared.  If not, then spin
 		 * for a bit trying to clear it.
 		 */
-		u8 stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+		u8 stat = sgiioc4_INB(io_ports->status_addr);
 		int count = 0;
-		stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+		stat = sgiioc4_INB(io_ports->status_addr);
 		while ((stat & 0x80) && (count++ < 100)) {
 			udelay(1);
-			stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+			stat = sgiioc4_INB(io_ports->status_addr);
 		}
 
 		if (intr_reg & 0x02) {
@@ -162,9 +162,9 @@ sgiioc4_clearirq(ide_drive_t * drive)
 			    pci_stat_cmd_reg;
 
 			pci_err_addr_low =
-				readl((void __iomem *)hwif->io_ports[IDE_IRQ_OFFSET]);
+				readl((void __iomem *)io_ports->irq_addr);
 			pci_err_addr_high =
-				readl((void __iomem *)(hwif->io_ports[IDE_IRQ_OFFSET] + 4));
+				readl((void __iomem *)(io_ports->irq_addr + 4));
 			pci_read_config_dword(dev, PCI_COMMAND,
 					      &pci_stat_cmd_reg);
 			printk(KERN_ERR
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -622,9 +622,10 @@ static void __devinit init_mmio_iops_sii
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	void *addr		= pci_get_drvdata(dev);
 	u8 ch			= hwif->channel;
-	hw_regs_t		hw;
 	unsigned long		base;
 
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+
 	/*
 	 *	Fill in the basic HWIF bits
 	 */
@@ -638,7 +639,7 @@ static void __devinit init_mmio_iops_sii
 	 *	based I/O
 	 */
 
-	memset(&hw, 0, sizeof(hw_regs_t));
+	memset(io_ports, 0, sizeof(*io_ports));
 
 	base = (unsigned long)addr;
 	if (ch)
@@ -651,17 +652,15 @@ static void __devinit init_mmio_iops_sii
 	 *	so we can't currently use it sanely since we want to
 	 *	use LBA48 mode.
 	 */	
-	hw.io_ports[IDE_DATA_OFFSET]	= base;
-	hw.io_ports[IDE_ERROR_OFFSET]	= base + 1;
-	hw.io_ports[IDE_NSECTOR_OFFSET]	= base + 2;
-	hw.io_ports[IDE_SECTOR_OFFSET]	= base + 3;
-	hw.io_ports[IDE_LCYL_OFFSET]	= base + 4;
-	hw.io_ports[IDE_HCYL_OFFSET]	= base + 5;
-	hw.io_ports[IDE_SELECT_OFFSET]	= base + 6;
-	hw.io_ports[IDE_STATUS_OFFSET]	= base + 7;
-	hw.io_ports[IDE_CONTROL_OFFSET]	= base + 10;
-
-	hw.io_ports[IDE_IRQ_OFFSET]	= 0;
+	io_ports->data_addr	= base;
+	io_ports->error_addr	= base + 1;
+	io_ports->nsect_addr	= base + 2;
+	io_ports->lbal_addr	= base + 3;
+	io_ports->lbam_addr	= base + 4;
+	io_ports->lbah_addr	= base + 5;
+	io_ports->device_addr	= base + 6;
+	io_ports->status_addr	= base + 7;
+	io_ports->ctl_addr	= base + 10;
 
 	if (pdev_is_sata(dev)) {
 		base = (unsigned long)addr;
@@ -672,8 +671,6 @@ static void __devinit init_mmio_iops_sii
 		hwif->sata_scr[SATA_CONTROL_OFFSET]	= base + 0x100;
 	}
 
-	memcpy(hwif->io_ports, hw.io_ports, sizeof(hwif->io_ports));
-
 	hwif->irq = dev->irq;
 
 	hwif->dma_base = (unsigned long)addr + (ch ? 0x08 : 0x00);
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -298,7 +298,7 @@ static void __devinit init_hwif_trm290(i
 		if (old != compat && old_mask == 0xff) {
 			/* leave lower 10 bits untouched */
 			compat += (next_offset += 0x400);
-			hwif->io_ports[IDE_CONTROL_OFFSET] = compat + 2;
+			hwif->io_ports.ctl_addr = compat + 2;
 			outw(compat | 1, hwif->config_data);
 			new = inw(hwif->config_data);
 			printk(KERN_INFO "%s: control basereg workaround: "
Index: b/drivers/ide/ppc/mpc8xx.c
===================================================================
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -131,7 +131,7 @@ static int pcmcia_schlvl = PCMCIA_SCHLVL
 #if defined(CONFIG_IDE_8xx_PCCARD) || defined(CONFIG_IDE_8xx_DIRECT)
 static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
-	unsigned long *p = hw->io_ports;
+	unsigned long *p = hw->io_ports_array;
 	int i;
 
 	typedef struct {
@@ -314,7 +314,7 @@ static int __init m8xx_ide_init_ports(hw
 #if defined(CONFIG_IDE_EXT_DIRECT)
 static int __init m8xx_ide_init_ports(hw_regs_t *hw, unsigned long data_port)
 {
-	unsigned long *p = hw->io_ports;
+	unsigned long *p = hw->io_ports_array;
 	int i;
 
 	u32 ide_phy_base;
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -417,7 +417,7 @@ static void pmac_ide_kauai_selectproc(id
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
 
 #define PMAC_IDE_REG(x) \
-	((void __iomem *)((drive)->hwif->io_ports[IDE_DATA_OFFSET] + (x)))
+	((void __iomem *)((drive)->hwif->io_ports.data_addr + (x)))
 
 /*
  * Apply the timings of the proper unit (master/slave) to the shared
@@ -1086,8 +1086,9 @@ static void __devinit pmac_ide_init_port
 	int i;
 
 	for (i = 0; i < 8; ++i)
-		hw->io_ports[i] = base + i * 0x10;
-	hw->io_ports[8] = base + 0x160;
+		hw->io_ports_array[i] = base + i * 0x10;
+
+	hw->io_ports.ctl_addr = base + 0x160;
 }
 
 /*
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -258,8 +258,7 @@ idescsi_atapi_error(ide_drive_t *drive, 
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE,
-			   hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTB(WIN_IDLEIMMEDIATE, hwif->io_ports.command_addr);
 
 	rq->errors++;
 
@@ -410,9 +409,9 @@ static ide_startstop_t idescsi_pc_intr (
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
 	}
-	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
-		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
+		  hwif->INB(hwif->io_ports.lbam_addr);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
@@ -485,7 +484,7 @@ static ide_startstop_t idescsi_transfer_
 			"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-scsi: (IO,CoD) != (0,1) while "
 				"issuing a packet command\n");
@@ -575,7 +574,7 @@ static ide_startstop_t idescsi_issue_pc(
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports.command_addr);
 		return idescsi_transfer_pc(drive);
 	}
 }
Index: b/include/asm-arm/arch-sa1100/ide.h
===================================================================
--- a/include/asm-arm/arch-sa1100/ide.h
+++ b/include/asm-arm/arch-sa1100/ide.h
@@ -37,12 +37,12 @@ static inline void ide_init_hwif_ports(h
 
 	memset(hw, 0, sizeof(*hw));
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw->io_ports[i] = reg;
+	for (i = 0; i <= 7; i++) {
+		hw->io_ports_array[i] = reg;
 		reg += regincr;
 	}
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
+	hw->io_ports.ctl_addr = ctrl_port;
 
 	if (irq)
 		*irq = 0;
Index: b/include/asm-cris/arch-v10/ide.h
===================================================================
--- a/include/asm-cris/arch-v10/ide.h
+++ b/include/asm-cris/arch-v10/ide.h
@@ -59,22 +59,19 @@ static inline void ide_init_hwif_ports(h
 	int i;
 
 	/* fill in ports for ATA addresses 0 to 7 */
-
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
-		hw->io_ports[i] = data_port |
+	for (i = 0; i <= 7; i++) {
+		hw->io_ports_array[i] = data_port |
 			IO_FIELD(R_ATA_CTRL_DATA, addr, i) |
 			IO_STATE(R_ATA_CTRL_DATA, cs0, active);
 	}
 
 	/* the IDE control register is at ATA address 6, with CS1 active instead of CS0 */
-
-	hw->io_ports[IDE_CONTROL_OFFSET] = data_port |
+	hw->io_ports.ctl_addr = data_port |
 			IO_FIELD(R_ATA_CTRL_DATA, addr, 6) |
 			IO_STATE(R_ATA_CTRL_DATA, cs1, active);
 
 	/* whats this for ? */
-
-	hw->io_ports[IDE_IRQ_OFFSET] = 0;
+	hw->io_ports.irq_addr = 0;
 }
 
 static inline void ide_init_default_hwifs(void)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -63,23 +63,30 @@ typedef unsigned char	byte;	/* used ever
  */
 #define IDE_NR_PORTS		(10)
 
-#define IDE_DATA_OFFSET		(0)
-#define IDE_ERROR_OFFSET	(1)
-#define IDE_NSECTOR_OFFSET	(2)
-#define IDE_SECTOR_OFFSET	(3)
-#define IDE_LCYL_OFFSET		(4)
-#define IDE_HCYL_OFFSET		(5)
-#define IDE_SELECT_OFFSET	(6)
-#define IDE_STATUS_OFFSET	(7)
-#define IDE_CONTROL_OFFSET	(8)
-#define IDE_IRQ_OFFSET		(9)
-
-#define IDE_FEATURE_OFFSET	IDE_ERROR_OFFSET
-#define IDE_COMMAND_OFFSET	IDE_STATUS_OFFSET
-#define IDE_ALTSTATUS_OFFSET	IDE_CONTROL_OFFSET
-#define IDE_IREASON_OFFSET	IDE_NSECTOR_OFFSET
-#define IDE_BCOUNTL_OFFSET	IDE_LCYL_OFFSET
-#define IDE_BCOUNTH_OFFSET	IDE_HCYL_OFFSET
+struct ide_io_ports {
+	unsigned long	data_addr;
+
+	union {
+		unsigned long error_addr;	/*   read:  error */
+		unsigned long feature_addr;	/*  write: feature */
+	};
+
+	unsigned long	nsect_addr;
+	unsigned long	lbal_addr;
+	unsigned long	lbam_addr;
+	unsigned long	lbah_addr;
+
+	unsigned long	device_addr;
+
+	union {
+		unsigned long status_addr;	/*  read: status  */
+		unsigned long command_addr;	/* write: command */
+	};
+
+	unsigned long	ctl_addr;
+
+	unsigned long	irq_addr;
+};
 
 #define OK_STAT(stat,good,bad)	(((stat)&((good)|(bad)))==(good))
 #define BAD_R_STAT		(BUSY_STAT   | ERR_STAT)
@@ -158,7 +165,11 @@ typedef u8 hwif_chipset_t;
  * Structure to hold all information about the location of this port
  */
 typedef struct hw_regs_s {
-	unsigned long	io_ports[IDE_NR_PORTS];	/* task file registers */
+	union {
+		struct ide_io_ports	io_ports;
+		unsigned long		io_ports_array[IDE_NR_PORTS];
+	};
+
 	int		irq;			/* our irq number */
 	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
 	hwif_chipset_t  chipset;
@@ -174,10 +185,10 @@ static inline void ide_std_init_ports(hw
 {
 	unsigned int i;
 
-	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
-		hw->io_ports[i] = io_addr++;
+	for (i = 0; i <= 7; i++)
+		hw->io_ports_array[i] = io_addr++;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ctl_addr;
+	hw->io_ports.ctl_addr = ctl_addr;
 }
 
 #include <asm/ide.h>
@@ -426,8 +437,8 @@ typedef struct hwif_s {
 
 	char name[6];			/* name of interface, eg. "ide0" */
 
-		/* task file registers for pata and sata */
-	unsigned long	io_ports[IDE_NR_PORTS];
+	struct ide_io_ports	io_ports;
+
 	unsigned long	sata_scr[SATA_NR_PORTS];
 
 	ide_drive_t	drives[MAX_DRIVES];	/* drive info */
@@ -1314,29 +1325,28 @@ static inline void ide_set_irq(ide_drive
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	hwif->OUTB(drive->ctl | (on ? 0 : 2),
-		   hwif->io_ports[IDE_CONTROL_OFFSET]);
+	hwif->OUTB(drive->ctl | (on ? 0 : 2), hwif->io_ports.ctl_addr);
 }
 
 static inline u8 ide_read_status(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	return hwif->INB(hwif->io_ports[IDE_STATUS_OFFSET]);
+	return hwif->INB(hwif->io_ports.status_addr);
 }
 
 static inline u8 ide_read_altstatus(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	return hwif->INB(hwif->io_ports[IDE_CONTROL_OFFSET]);
+	return hwif->INB(hwif->io_ports.ctl_addr);
 }
 
 static inline u8 ide_read_error(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	return hwif->INB(hwif->io_ports[IDE_ERROR_OFFSET]);
+	return hwif->INB(hwif->io_ports.error_addr);
 }
 
 /*
@@ -1349,7 +1359,7 @@ static inline void ide_atapi_discard_dat
 
 	/* FIXME: use ->atapi_input_bytes */
 	while (bcount--)
-		(void)hwif->INB(hwif->io_ports[IDE_DATA_OFFSET]);
+		(void)hwif->INB(hwif->io_ports.data_addr);
 }
 
 static inline void ide_atapi_write_zeros(ide_drive_t *drive, unsigned bcount)
@@ -1358,7 +1368,7 @@ static inline void ide_atapi_write_zeros
 
 	/* FIXME: use ->atapi_output_bytes */
 	while (bcount--)
-		hwif->OUTB(0, hwif->io_ports[IDE_DATA_OFFSET]);
+		hwif->OUTB(0, hwif->io_ports.data_addr);
 }
 
 #endif /* _IDE_H */
