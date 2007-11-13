Return-Path: <linux-kernel-owner+w=401wt.eu-S1761785AbXKMVHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785AbXKMVHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759599AbXKMVHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:07:44 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:57914 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759677AbXKMVHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:07:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TEoBYFqcQXznT6gMthDOJqJM8U6L8qzQIlSe6jBbjRDjLJcUqEpAXtBPpZe0DdNaSDEahVELyDSQE2hIKBB2S5k9jHSQ7+FUMA+IpNx7aUysKUh0kJsUFbSgO9DO6YznQQlQV9jZh0CZCz+Lyyo3sxytqL67SV9pvLvFYkhtZZw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Tue, 13 Nov 2007 22:13:25 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132213.25808.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Contains cmd64x regression fix from Sergei + some minor fixes.


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig         |    4 ----
 drivers/ide/cris/ide-cris.c |    3 +--
 drivers/ide/ide-io.c        |    6 +-----
 drivers/ide/ide-lib.c       |    1 +
 drivers/ide/pci/cmd64x.c    |    5 +++--
 drivers/ide/pci/cs5530.c    |    3 +--
 drivers/ide/pci/it821x.c    |    3 +--
 drivers/ide/pci/jmicron.c   |    3 +--
 drivers/ide/pci/sc1200.c    |    3 +--
 drivers/ide/pci/sis5513.c   |    1 -
 drivers/ide/ppc/pmac.c      |    1 +
 drivers/ide/setup-pci.c     |    5 -----
 12 files changed, 11 insertions(+), 27 deletions(-)


Adrian Bunk (1):
      ide: BLK_DEV_IDECD help: remove outdated note

Bartlomiej Zolnierkiewicz (6):
      ide-pmac: skip conservative PIO "downgrade"
      ide: add missing HOB bit clearing to ide_dump_ata_status()
      ide: use drive->select.all for REQ_TYPE_ATA_TASK in execute_drive_cmd()
      ide: don't BUG() on unsupported transfer modes
      it821x/jmicron: fix return value of {it821x,jmicron}_init_one()
      ide: remove stale/incorrect comment from setup-pci.c

Sergei Shtylyov (1):
      cmd64x: don't clear the other channel's interrupt


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index d1e8df1..e445fe6 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -203,10 +203,6 @@ config BLK_DEV_IDECD
 	  CD-ROM drive, you can say N to all other CD-ROM options, but be sure
 	  to say Y or M to "ISO 9660 CD-ROM file system support".
 
-	  Note that older versions of LILO (LInux LOader) cannot properly deal
-	  with IDE/ATAPI CD-ROMs, so install LILO 16 or higher, available from
-	  <http://lilo.go.dyndns.org/>.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called ide-cd.
 
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index e196aef..7f5bc2e 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -748,8 +748,7 @@ static void cris_set_dma_mode(ide_drive_t *drive, const u8 speed)
 			hold = ATA_DMA2_HOLD;
 			break;
 		default:
-			BUG();
-			break;
+			return;
 	}
 
 	if (speed >= XFER_UDMA_0)
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 7550118..db22d1f 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -885,7 +885,6 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 		return do_rw_taskfile(drive, args);
 	} else if (rq->cmd_type == REQ_TYPE_ATA_TASK) {
 		u8 *args = rq->buffer;
-		u8 sel;
  
 		if (!args)
 			goto done;
@@ -903,10 +902,7 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
  		hwif->OUTB(args[3], IDE_SECTOR_REG);
  		hwif->OUTB(args[4], IDE_LCYL_REG);
  		hwif->OUTB(args[5], IDE_HCYL_REG);
- 		sel = (args[6] & ~0x10);
- 		if (drive->select.b.unit)
- 			sel |= 0x10;
- 		hwif->OUTB(sel, IDE_SELECT_REG);
+ 		hwif->OUTB((args[6] & 0xEF)|drive->select.all, IDE_SELECT_REG);
  		ide_cmd(drive, args[0], args[2], &drive_cmd_intr);
  		return ide_started;
  	} else if (rq->cmd_type == REQ_TYPE_ATA_CMD) {
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index af86433..1609b86 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -514,6 +514,7 @@ static u8 ide_dump_ata_status(ide_drive_t *drive, const char *msg, u8 stat)
 			if (drive->addressing == 1) {
 				__u64 sectors = 0;
 				u32 low = 0, high = 0;
+				hwif->OUTB(drive->ctl&~0x80, IDE_CONTROL_REG);
 				low = ide_read_24(drive);
 				hwif->OUTB(drive->ctl|0x80, IDE_CONTROL_REG);
 				high = ide_read_24(drive);
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index ea0143e..51fca44 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cmd64x.c		Version 1.50	May 10, 2007
+ * linux/drivers/ide/pci/cmd64x.c		Version 1.51	Nov 8, 2007
  *
  * cmd64x.c: Enable interrupts at initialization time on Ultra/PCI machines.
  *           Due to massive hardware bugs, UltraDMA is only supported
@@ -339,7 +339,8 @@ static int cmd648_ide_dma_end (ide_drive_t *drive)
 	u8  mrdmode		= inb(hwif->dma_master + 0x01);
 
 	/* clear the interrupt bit */
-	outb(mrdmode | irq_mask, hwif->dma_master + 0x01);
+	outb((mrdmode & ~(MRDMODE_INTR_CH0 | MRDMODE_INTR_CH1)) | irq_mask,
+	     hwif->dma_master + 0x01);
 
 	return err;
 }
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index 5994089..5476903 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -117,8 +117,7 @@ static void cs5530_set_dma_mode(ide_drive_t *drive, const u8 mode)
 		case XFER_MW_DMA_1:	timings = 0x00012121; break;
 		case XFER_MW_DMA_2:	timings = 0x00002020; break;
 		default:
-			BUG();
-			break;
+			return;
 	}
 	basereg = CS5530_BASEREG(drive->hwif);
 	reg = inl(basereg + 4);			/* get drive0 config register */
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 5c99754..99b7d76 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -653,8 +653,7 @@ static const struct ide_port_info it821x_chipsets[] __devinitdata = {
 
 static int __devinit it821x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_setup_pci_device(dev, &it821x_chipsets[id->driver_data]);
-	return 0;
+	return ide_setup_pci_device(dev, &it821x_chipsets[id->driver_data]);
 }
 
 static const struct pci_device_id it821x_pci_tbl[] = {
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index bdf64d9..0083eaf 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -139,8 +139,7 @@ static const struct ide_port_info jmicron_chipset __devinitdata = {
 
 static int __devinit jmicron_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_setup_pci_device(dev, &jmicron_chipset);
-	return 0;
+	return ide_setup_pci_device(dev, &jmicron_chipset);
 }
 
 /* All JMB PATA controllers have and will continue to have the same
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 0a7b320..707d5ff 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -186,8 +186,7 @@ static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
 			}
 			break;
 		default:
-			BUG();
-			break;
+			return;
 	}
 
 	if (unit == 0) {			/* are we configuring drive0? */
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 6b7bb53..f6e2ab3 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -356,7 +356,6 @@ static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
 			sis_program_timings(drive, speed);
 			break;
 		default:
-			BUG();
 			break;
 	}
 }
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 816b531..5afdfef 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1138,6 +1138,7 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	hwif->drives[0].autotune = IDE_TUNE_AUTO;
 	hwif->drives[1].autotune = IDE_TUNE_AUTO;
 	hwif->host_flags = IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
+			   IDE_HFLAG_PIO_NO_DOWNGRADE |
 			   IDE_HFLAG_POST_SET_MODE;
 	hwif->pio_mask = ATA_PIO4;
 	hwif->set_pio_mode = pmac_ide_set_pio_mode;
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 02d14bf..25fd090 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -7,11 +7,6 @@
  *  May be copied or modified under the terms of the GNU General Public License
  */
 
-/*
- *  This module provides support for automatic detection and
- *  configuration of all PCI IDE interfaces present in a system.  
- */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
