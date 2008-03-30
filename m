Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYC3Tc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYC3Tc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYC3TbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 15:31:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:30632 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYC3Tau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 15:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=PIMgqU49RHkNthc0ml3St16//cGeiNNJ2K8dAGEV8lOvL2Qii3H5KfcQSV8+1GcmT0z2FyVe8jC5PQg4vQ1JR14lMake93wdgQyODTComd/fyrn2QntBUSHtrErbOLsoYoBQXkBhBv+qBk7p/H424Ud1vaOzpHetW+sym2lEV0E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/6] ide: merge ->atapi_*put_bytes and ->ata_*put_data methods
Date: Sun, 30 Mar 2008 21:41:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803302141.03013.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Merge ->atapi_{in,out}put_bytes and ->ata_{in,out}put_data methods
  into new ->{in,out}put_data methods which take number of bytes to
  transfer as an argument and always do padding.

While at it:

* Use 'hwif' or 'drive->hwif' instead of 'HWIF(drive)'.

There should be no functional changes caused by this patch (all users
of ->ata_{in,out}put_data methods were using multiply-of-4 word counts).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cris/ide-cris.c    |   46 +++++++--------------------
 drivers/ide/ide-cd.c           |   10 +++---
 drivers/ide/ide-floppy.c       |   16 ++++++---
 drivers/ide/ide-io.c           |    2 -
 drivers/ide/ide-iops.c         |   68 +++++++++++++++--------------------------
 drivers/ide/ide-probe.c        |    2 -
 drivers/ide/ide-tape.c         |   11 +++---
 drivers/ide/ide-taskfile.c     |    4 +-
 drivers/ide/legacy/falconide.c |   24 ++------------
 drivers/ide/legacy/q40ide.c    |   24 ++------------
 drivers/scsi/ide-scsi.c        |   27 +++++++---------
 include/linux/ide.h            |   11 ++----
 12 files changed, 88 insertions(+), 157 deletions(-)

Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -673,10 +673,8 @@ cris_ide_inb(unsigned long reg)
 	return (unsigned char)cris_ide_inw(reg);
 }
 
-static void cris_ide_input_data (ide_drive_t *drive, void *, unsigned int);
-static void cris_ide_output_data (ide_drive_t *drive, void *, unsigned int);
-static void cris_atapi_input_bytes(ide_drive_t *drive, void *, unsigned int);
-static void cris_atapi_output_bytes(ide_drive_t *drive, void *, unsigned int);
+static void cris_input_data(ide_drive_t *, void *, unsigned int);
+static void cris_output_data(ide_drive_t *, void *, unsigned int);
 
 static void cris_dma_host_set(ide_drive_t *drive, int on)
 {
@@ -814,10 +812,9 @@ static int __init init_e100_ide(void)
 
 		ide_init_port_hw(hwif, &hw);
 
-		hwif->ata_input_data = &cris_ide_input_data;
-		hwif->ata_output_data = &cris_ide_output_data;
-		hwif->atapi_input_bytes = &cris_atapi_input_bytes;
-		hwif->atapi_output_bytes = &cris_atapi_output_bytes;
+		hwif->input_data  = cris_input_data;
+		hwif->output_data = cris_output_data;
+
 		hwif->OUTB = &cris_ide_outb;
 		hwif->OUTW = &cris_ide_outw;
 		hwif->OUTBSYNC = &cris_ide_outbsync;
@@ -847,17 +844,16 @@ static int __init init_e100_ide(void)
 static cris_dma_descr_type mydescr __attribute__ ((__aligned__(16)));
 
 /*
- * The following routines are mainly used by the ATAPI drivers.
+ * This is used for most PIO data transfers *from* the IDE interface
  *
  * These routines will round up any request for an odd number of bytes,
  * so if an odd bytecount is specified, be sure that there's at least one
  * extra byte allocated for the buffer.
  */
 static void
-cris_atapi_input_bytes (ide_drive_t *drive, void *buffer, unsigned int bytecount)
+cris_input_data(ide_drive_t *drive, void *buffer, unsigned int bytecount)
 {
-	D(printk("atapi_input_bytes, buffer 0x%x, count %d\n",
-	         buffer, bytecount));
+	D(printk("input_data, buffer 0x%x, count %d\n", buffer, bytecount));
 
 	if(bytecount & 1) {
 		printk("warning, odd bytecount in cdrom_in_bytes = %d.\n", bytecount);
@@ -875,11 +871,13 @@ cris_atapi_input_bytes (ide_drive_t *dri
 	LED_DISK_READ(0);
 }
 
+/*
+ * This is used for most PIO data transfers *to* the IDE interface
+ */
 static void
-cris_atapi_output_bytes (ide_drive_t *drive, void *buffer, unsigned int bytecount)
+cris_output_data(ide_drive_t *drive, void *buffer, unsigned int bytecount)
 {
-	D(printk("atapi_output_bytes, buffer 0x%x, count %d\n",
-	         buffer, bytecount));
+	D(printk("output_data, buffer 0x%x, count %d\n", buffer, bytecount));
 
 	if(bytecount & 1) {
 		printk("odd bytecount %d in atapi_out_bytes!\n", bytecount);
@@ -897,24 +895,6 @@ cris_atapi_output_bytes (ide_drive_t *dr
 	LED_DISK_WRITE(0);
 }
 
-/*
- * This is used for most PIO data transfers *from* the IDE interface
- */
-static void
-cris_ide_input_data (ide_drive_t *drive, void *buffer, unsigned int wcount)
-{
-	cris_atapi_input_bytes(drive, buffer, wcount << 2);
-}
-
-/*
- * This is used for most PIO data transfers *to* the IDE interface
- */
-static void
-cris_ide_output_data (ide_drive_t *drive, void *buffer, unsigned int wcount)
-{
-	cris_atapi_output_bytes(drive, buffer, wcount << 2);
-}
-
 /* we only have one DMA channel on the chip for ATA, so we can keep these statically */
 static cris_dma_descr_type ata_descrs[MAX_DMA_DESCRS] __attribute__ ((__aligned__(16)));
 static unsigned int ata_tot_size;
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -613,7 +613,7 @@ static ide_startstop_t cdrom_transfer_pa
 		cmd_len = ATAPI_MIN_CDB_BYTES;
 
 	/* send the command to the device */
-	HWIF(drive)->atapi_output_bytes(drive, rq->cmd, cmd_len);
+	hwif->output_data(drive, rq->cmd, cmd_len);
 
 	/* start the DMA if need be */
 	if (info->dma)
@@ -639,7 +639,7 @@ static void ide_cd_drain_data(ide_drive_
 	while (nsects > 0) {
 		static char dum[SECTOR_SIZE];
 
-		drive->hwif->atapi_input_bytes(drive, dum, sizeof(dum));
+		drive->hwif->input_data(drive, dum, sizeof(dum));
 		nsects--;
 	}
 }
@@ -666,7 +666,7 @@ static int ide_cd_check_ireason(ide_driv
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
 				drive->name, __func__);
 
-		xf = rw ? hwif->atapi_output_bytes : hwif->atapi_input_bytes;
+		xf = rw ? hwif->output_data : hwif->input_data;
 		ide_cd_pad_transfer(drive, xf, len);
 	} else  if (rw == 0 && ireason == 1) {
 		/*
@@ -1019,10 +1019,10 @@ static ide_startstop_t cdrom_newpc_intr(
 
 	if (ireason == 0) {
 		write = 1;
-		xferfunc = HWIF(drive)->atapi_output_bytes;
+		xferfunc = hwif->output_data;
 	} else {
 		write = 0;
-		xferfunc = HWIF(drive)->atapi_input_bytes;
+		xferfunc = hwif->input_data;
 	}
 
 	/* transfer data */
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -231,6 +231,7 @@ static int idefloppy_end_request(ide_dri
 static void ide_floppy_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  unsigned int bcount, int direction)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = pc->rq;
 	struct req_iterator iter;
 	struct bio_vec *bvec;
@@ -246,9 +247,9 @@ static void ide_floppy_io_buffers(ide_dr
 
 		data = bvec_kmap_irq(bvec, &flags);
 		if (direction)
-			drive->hwif->atapi_output_bytes(drive, data, count);
+			hwif->output_data(drive, data, count);
 		else
-			drive->hwif->atapi_input_bytes(drive, data, count);
+			hwif->input_data(drive, data, count);
 		bvec_kunmap_irq(data, &flags);
 
 		bcount -= count;
@@ -503,9 +504,9 @@ static ide_startstop_t idefloppy_pc_intr
 		}
 	}
 	if (pc->flags & PC_FLAG_WRITING)
-		xferfunc = hwif->atapi_output_bytes;
+		xferfunc = hwif->output_data;
 	else
-		xferfunc = hwif->atapi_input_bytes;
+		xferfunc = hwif->input_data;
 
 	if (pc->buf)
 		xferfunc(drive, pc->cur_pos, bcount);
@@ -548,8 +549,10 @@ static ide_startstop_t idefloppy_transfe
 
 	/* Set the interrupt routine */
 	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
+
 	/* Send the actual packet */
-	HWIF(drive)->atapi_output_bytes(drive, floppy->pc->c, 12);
+	hwif->output_data(drive, floppy->pc->c, 12);
+
 	return ide_started;
 }
 
@@ -569,7 +572,8 @@ static int idefloppy_transfer_pc2(ide_dr
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 	/* Send the actual packet */
-	HWIF(drive)->atapi_output_bytes(drive, floppy->pc->c, 12);
+	drive->hwif->output_data(drive, floppy->pc->c, 12);
+
 	/* Timeout for the packet command */
 	return IDEFLOPPY_WAIT_CMD;
 }
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -422,7 +422,7 @@ static void try_to_flush_leftover_data (
 		u32 wcount = (i > 16) ? 16 : i;
 
 		i -= wcount;
-		HWIF(drive)->ata_input_data(drive, buffer, wcount);
+		drive->hwif->input_data(drive, buffer, wcount * 4);
 	}
 }
 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -191,34 +191,45 @@ static void ata_vlb_sync(ide_drive_t *dr
 
 /*
  * This is used for most PIO data transfers *from* the IDE interface
+ *
+ * These routines will round up any request for an odd number of bytes,
+ * so if an odd len is specified, be sure that there's at least one
+ * extra byte allocated for the buffer.
  */
-static void ata_input_data(ide_drive_t *drive, void *buffer, u32 wcount)
+static void ata_input_data(ide_drive_t *drive, void *buf, unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long data_addr = io_ports->data_addr;
 	u8 io_32bit = drive->io_32bit;
 
+	len++;
+
 	if (io_32bit) {
 		if (io_32bit & 2) {
 			unsigned long flags;
 
 			local_irq_save(flags);
 			ata_vlb_sync(drive, io_ports->nsect_addr);
-			hwif->INSL(io_ports->data_addr, buffer, wcount);
+			hwif->INSL(data_addr, buf, len / 4);
 			local_irq_restore(flags);
 		} else
-			hwif->INSL(io_ports->data_addr, buffer, wcount);
+			hwif->INSL(data_addr, buf, len / 4);
+
+		if ((len & 3) >= 2)
+			hwif->INSW(data_addr, (u8 *)buf + (len & ~3), 1);
 	} else
-		hwif->INSW(io_ports->data_addr, buffer, wcount << 1);
+		hwif->INSW(data_addr, buf, len / 2);
 }
 
 /*
  * This is used for most PIO data transfers *to* the IDE interface
  */
-static void ata_output_data(ide_drive_t *drive, void *buffer, u32 wcount)
+static void ata_output_data(ide_drive_t *drive, void *buf, unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
+	unsigned long data_addr = io_ports->data_addr;
 	u8 io_32bit = drive->io_32bit;
 
 	if (io_32bit) {
@@ -227,50 +238,21 @@ static void ata_output_data(ide_drive_t 
 
 			local_irq_save(flags);
 			ata_vlb_sync(drive, io_ports->nsect_addr);
-			hwif->OUTSL(io_ports->data_addr, buffer, wcount);
+			hwif->OUTSL(data_addr, buf, len / 4);
 			local_irq_restore(flags);
 		} else
-			hwif->OUTSL(io_ports->data_addr, buffer, wcount);
-	} else
-		hwif->OUTSW(io_ports->data_addr, buffer, wcount << 1);
-}
-
-/*
- * The following routines are mainly used by the ATAPI drivers.
- *
- * These routines will round up any request for an odd number of bytes,
- * so if an odd bytecount is specified, be sure that there's at least one
- * extra byte allocated for the buffer.
- */
-
-static void atapi_input_bytes(ide_drive_t *drive, void *buffer, u32 bytecount)
-{
-	ide_hwif_t *hwif = HWIF(drive);
+			hwif->OUTSL(data_addr, buf, len / 4);
 
-	++bytecount;
-	hwif->ata_input_data(drive, buffer, bytecount / 4);
-	if ((bytecount & 0x03) >= 2)
-		hwif->INSW(hwif->io_ports.data_addr,
-			   (u8 *)buffer + (bytecount & ~0x03), 1);
-}
-
-static void atapi_output_bytes(ide_drive_t *drive, void *buffer, u32 bytecount)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-
-	++bytecount;
-	hwif->ata_output_data(drive, buffer, bytecount / 4);
-	if ((bytecount & 0x03) >= 2)
-		hwif->OUTSW(hwif->io_ports.data_addr,
-			    (u8 *)buffer + (bytecount & ~0x03), 1);
+		if ((len & 3) >= 2)
+			hwif->OUTSW(data_addr, (u8 *)buf + (len & ~3), 1);
+	} else
+		hwif->OUTSW(data_addr, buf, len / 2);
 }
 
 void default_hwif_transport(ide_hwif_t *hwif)
 {
-	hwif->ata_input_data		= ata_input_data;
-	hwif->ata_output_data		= ata_output_data;
-	hwif->atapi_input_bytes		= atapi_input_bytes;
-	hwif->atapi_output_bytes	= atapi_output_bytes;
+	hwif->input_data  = ata_input_data;
+	hwif->output_data = ata_output_data;
 }
 
 void ide_fix_driveid (struct hd_driveid *id)
@@ -654,7 +636,7 @@ int ide_driveid_update(ide_drive_t *driv
 		local_irq_restore(flags);
 		return 0;
 	}
-	hwif->ata_input_data(drive, id, SECTOR_WORDS);
+	hwif->input_data(drive, id, SECTOR_SIZE);
 	(void)ide_read_status(drive);	/* clear drive IRQ */
 	local_irq_enable();
 	local_irq_restore(flags);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -126,7 +126,7 @@ static inline void do_identify (ide_driv
 
 	id = drive->id;
 	/* read 512 bytes of id info */
-	hwif->ata_input_data(drive, id, SECTOR_WORDS);
+	hwif->input_data(drive, id, SECTOR_SIZE);
 
 	drive->id_read = 1;
 	local_irq_enable();
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -406,7 +406,7 @@ static void idetape_input_buffers(ide_dr
 		count = min(
 			(unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
 			bcount);
-		HWIF(drive)->atapi_input_bytes(drive, bh->b_data +
+		drive->hwif->input_data(drive, bh->b_data +
 					atomic_read(&bh->b_count), count);
 		bcount -= count;
 		atomic_add(count, &bh->b_count);
@@ -432,7 +432,7 @@ static void idetape_output_buffers(ide_d
 			return;
 		}
 		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
-		HWIF(drive)->atapi_output_bytes(drive, pc->b_data, count);
+		drive->hwif->output_data(drive, pc->b_data, count);
 		bcount -= count;
 		pc->b_data += count;
 		pc->b_count -= count;
@@ -883,10 +883,10 @@ static ide_startstop_t idetape_pc_intr(i
 				"data than expected - allowing transfer\n");
 		}
 		iobuf = &idetape_input_buffers;
-		xferfunc = hwif->atapi_input_bytes;
+		xferfunc = hwif->input_data;
 	} else {
 		iobuf = &idetape_output_buffers;
-		xferfunc = hwif->atapi_output_bytes;
+		xferfunc = hwif->output_data;
 	}
 
 	if (pc->bh)
@@ -982,7 +982,8 @@ static ide_startstop_t idetape_transfer_
 		hwif->dma_ops->dma_start(drive);
 #endif
 	/* Send the actual packet */
-	HWIF(drive)->atapi_output_bytes(drive, pc->c, 12);
+	hwif->output_data(drive, pc->c, 12);
+
 	return ide_started;
 }
 
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -323,9 +323,9 @@ static void ide_pio_sector(ide_drive_t *
 
 	/* do the actual data transfer */
 	if (write)
-		hwif->ata_output_data(drive, buf, SECTOR_WORDS);
+		hwif->output_data(drive, buf, SECTOR_SIZE);
 	else
-		hwif->ata_input_data(drive, buf, SECTOR_WORDS);
+		hwif->input_data(drive, buf, SECTOR_SIZE);
 
 	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
 #ifdef CONFIG_HIGHMEM
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -44,30 +44,16 @@
 int falconide_intr_lock;
 EXPORT_SYMBOL(falconide_intr_lock);
 
-static void falconide_atapi_input_bytes(ide_drive_t *drive, void *buf,
-					unsigned int len)
+static void falconide_input_data(ide_drive_t *drive, void *buf, unsigned len)
 {
 	insw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
 }
 
-static void falconide_atapi_output_bytes(ide_drive_t *drive, void *buf,
-					 unsigned int len)
+static void falconide_output_data(ide_drive_t *drive, void *buf, unsigned len)
 {
 	outsw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
 }
 
-static void falconide_ata_input_data(ide_drive_t *drive, void *buf,
-				     unsigned int wcount)
-{
-	falconide_atapi_input_bytes(drive, buf, wcount * 4);
-}
-
-static void falconide_ata_output_data(ide_drive_t *drive, void *buf,
-				      unsigned int wcount)
-{
-	falconide_atapi_output_bytes(drive, buf, wcount * 4);
-}
-
 static void __init falconide_setup_ports(hw_regs_t *hw)
 {
 	int i;
@@ -114,10 +100,8 @@ static int __init falconide_init(void)
 		ide_init_port_hw(hwif, &hw);
 
 		/* Atari has a byte-swapped IDE interface */
-		hwif->atapi_input_bytes  = falconide_atapi_input_bytes;
-		hwif->atapi_output_bytes = falconide_atapi_output_bytes;
-		hwif->ata_input_data	 = falconide_ata_input_data;
-		hwif->ata_output_data	 = falconide_ata_output_data;
+		hwif->input_data  = falconide_input_data;
+		hwif->output_data = falconide_output_data;
 
 		ide_get_lock(NULL, NULL);
 		ide_device_add(idx, NULL);
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -90,30 +90,16 @@ void q40_ide_setup_ports ( hw_regs_t *hw
 	hw->ack_intr = ack_intr;
 }
 
-static void q40ide_atapi_input_bytes(ide_drive_t *drive, void *buf,
-				     unsigned int len)
+static void q40ide_input_data(ide_drive_t *drive, void *buf, unsigned int len)
 {
 	insw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
 }
 
-static void q40ide_atapi_output_bytes(ide_drive_t *drive, void *buf,
-				      unsigned int len)
+static void q40ide_output_data(ide_drive_t *drive, void *buf, unsigned int len)
 {
 	outsw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
 }
 
-static void q40ide_ata_input_data(ide_drive_t *drive, void *buf,
-				  unsigned int wcount)
-{
-	q40ide_atapi_input_bytes(drive, buf, wcount * 4);
-}
-
-static void q40ide_ata_output_data(ide_drive_t *drive, void *buf,
-				   unsigned int wcount)
-{
-	q40ide_atapi_output_bytes(drive, buf, wcount * 4);
-}
-
 /* 
  * the static array is needed to have the name reported in /proc/ioports,
  * hwif->name unfortunately isn't available yet
@@ -164,10 +150,8 @@ static int __init q40ide_init(void)
 		ide_init_port_hw(hwif, &hw);
 
 		/* Q40 has a byte-swapped IDE interface */
-		hwif->atapi_input_bytes  = q40ide_atapi_input_bytes;
-		hwif->atapi_output_bytes = q40ide_atapi_output_bytes;
-		hwif->ata_input_data	 = q40ide_ata_input_data;
-		hwif->ata_output_data	 = q40ide_ata_output_data;
+		hwif->input_data  = q40ide_input_data;
+		hwif->output_data = q40ide_output_data;
 
 		idx[i] = hwif->index;
 	}
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -134,6 +134,7 @@ static inline idescsi_scsi_t *drive_to_i
 static void idescsi_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		unsigned int bcount)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	int count;
 	char *buf;
 
@@ -145,14 +146,12 @@ static void idescsi_input_buffers(ide_dr
 			local_irq_save(flags);
 			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
 					pc->sg->offset;
-			drive->hwif->atapi_input_bytes(drive,
-						buf + pc->b_count, count);
+			hwif->input_data(drive, buf + pc->b_count, count);
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
 			buf = sg_virt(pc->sg);
-			drive->hwif->atapi_input_bytes(drive,
-						buf + pc->b_count, count);
+			hwif->input_data(drive, buf + pc->b_count, count);
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
@@ -172,6 +171,7 @@ static void idescsi_input_buffers(ide_dr
 static void idescsi_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		unsigned int bcount)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	int count;
 	char *buf;
 
@@ -183,14 +183,12 @@ static void idescsi_output_buffers(ide_d
 			local_irq_save(flags);
 			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
 						pc->sg->offset;
-			drive->hwif->atapi_output_bytes(drive,
-						buf + pc->b_count, count);
+			hwif->output_data(drive, buf + pc->b_count, count);
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
 			buf = sg_virt(pc->sg);
-			drive->hwif->atapi_output_bytes(drive,
-						buf + pc->b_count, count);
+			hwif->output_data(drive, buf + pc->b_count, count);
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
@@ -431,7 +429,8 @@ static ide_startstop_t idescsi_pc_intr (
 						idescsi_input_buffers(drive, pc,
 									temp);
 					else
-						drive->hwif->atapi_input_bytes(drive, pc->cur_pos, temp);
+						hwif->input_data(drive,
+							pc->cur_pos, temp);
 					printk(KERN_ERR "ide-scsi: transferred"
 							" %d of %d bytes\n",
 							temp, bcount);
@@ -452,15 +451,13 @@ static ide_startstop_t idescsi_pc_intr (
 		if (pc->sg)
 			idescsi_input_buffers(drive, pc, bcount);
 		else
-			hwif->atapi_input_bytes(drive, pc->cur_pos,
-						bcount);
+			hwif->input_data(drive, pc->cur_pos, bcount);
 	} else {
 		pc->flags |= PC_FLAG_WRITING;
 		if (pc->sg)
 			idescsi_output_buffers(drive, pc, bcount);
 		else
-			hwif->atapi_output_bytes(drive, pc->cur_pos,
-						 bcount);
+			hwif->output_data(drive, pc->cur_pos, bcount);
 	}
 	/* Update the current position */
 	pc->xferred += bcount;
@@ -493,8 +490,10 @@ static ide_startstop_t idescsi_transfer_
 	BUG_ON(HWGROUP(drive)->handler != NULL);
 	/* Set the interrupt routine */
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
+
 	/* Send the actual packet */
-	drive->hwif->atapi_output_bytes(drive, scsi->pc->c, 12);
+	hwif->output_data(drive, scsi->pc->c, 12);
+
 	if (pc->flags & PC_FLAG_DMA_OK) {
 		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
 		hwif->dma_ops->dma_start(drive);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -469,11 +469,8 @@ typedef struct hwif_s {
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
-	void (*ata_input_data)(ide_drive_t *, void *, u32);
-	void (*ata_output_data)(ide_drive_t *, void *, u32);
-
-	void (*atapi_input_bytes)(ide_drive_t *, void *, u32);
-	void (*atapi_output_bytes)(ide_drive_t *, void *, u32);
+	void (*input_data)(ide_drive_t *, void *, unsigned int);
+	void (*output_data)(ide_drive_t *, void *, unsigned int);
 
 	void (*ide_dma_clear_irq)(ide_drive_t *drive);
 
@@ -1357,7 +1354,7 @@ static inline void ide_atapi_discard_dat
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	/* FIXME: use ->atapi_input_bytes */
+	/* FIXME: use ->input_data */
 	while (bcount--)
 		(void)hwif->INB(hwif->io_ports.data_addr);
 }
@@ -1366,7 +1363,7 @@ static inline void ide_atapi_write_zeros
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	/* FIXME: use ->atapi_output_bytes */
+	/* FIXME: use ->output_data */
 	while (bcount--)
 		hwif->OUTB(0, hwif->io_ports.data_addr);
 }
