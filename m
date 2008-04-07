Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYDGS7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYDGS7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYDGS7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:59:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:23134 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYDGS73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:59:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=rnOJS+V0xU2q/kc5tcBFOyfpQQCsq+vzfDpLIRgZPkI9ZYSX8UWm4FyQccSyPcADbzhSNMhLYLRYkBWVVvY+LFXjVca2DkxsCvSA1RDTY/bHcFv7mGlWqi/X8rWz6j7n2MbtDvv2McUOgfRSoZjjAlaRhijtMQB4BDZJ/yuHK0Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and ->ata_*put_data methods
Date: Mon, 7 Apr 2008 21:13:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
References: <200803301714.04527.bzolnier@gmail.com> <200803302134.42569.bzolnier@gmail.com> <Pine.LNX.4.64.0803310750230.6871@anakin>
In-Reply-To: <Pine.LNX.4.64.0803310750230.6871@anakin>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804072113.42441.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008, Geert Uytterhoeven wrote:
> On Sun, 30 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 30 March 2008, Geert Uytterhoeven wrote:
> > > On Sun, 30 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> > > > * Add ->atapi_{in,out}put_bytes and ->ata_{in,out}put_data methods to
> > > >   falconide and q40ide host drivers (->ata_* methods are implemented on
> > > >   top of ->atapi_* methods so they also do byte-swapping now).
> > > > 
> > > > * Cleanup atapi_{in,out}put_bytes().
> > > 
> > > Thanks!
> > > 
> > > One remaining issue (for which the fix has never been submitted upstream so
> > > far) with Atari and Q40 is that due to the byteswapped interface, the driveid
> > > is also byteswapped, so it has to be unswapped again in ide_fix_driveid().
> > 
> > My patch causes unswapping for _all_ data coming from the device so I wonder
> > whether the ide_fix_driveid() fix is still needed?
> 
> I'll give it a try on Aranym...
> 
> > [ I now recall some discussion that we shouldn't un-swap fs requests because
> >   of how the things were done in the past fs itself is stored byte-swapped on
> >   the disk - if this is the case I will recast the patch to pass rq to
> >   ->ata_*put_data in ide_pio_sector() and check rq->cmd_type == REQ_TYPE_FS
> >   in falconide/q40ide_*put_data() to decide whether to unswap data or not ]
> 
> Yes, the data on the disk is stored byte-swapped.
> So it's only the drive ID and packet commands that should be swapped.

"take 2" against IDE tree follows

[ I hope to merge it into IDE tree tomorrow if people are fine with it. ]

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] falconide/q40ide: add ->atapi_*put_bytes and ->ata_*put_data methods (take 2)

* Add ->atapi_{in,out}put_bytes and ->ata_{in,out}put_data methods to
  falconide and q40ide host drivers (->ata_* methods are implemented on
  top of ->atapi_* methods so they also do byte-swapping now).

* Cleanup atapi_{in,out}put_bytes().

v2:
* Add 'struct request *rq' argument to ->ata_{in,out}put_data methods
  and don't byte-swap disk fs requests (we shouldn't un-swap fs requests
  because fs itself is stored byte-swapped on the disk) - this is how
  things were done before the patch (ideally device mapper should be
  used instead but it would break existing setups and would have some
  performance impact).

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@debian.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
PS no point in adding rq to ->atapi* methods as the next patch in series
merges ->ata* and ->atapi* methods

 drivers/ide/cris/ide-cris.c    |   14 ++++++++------
 drivers/ide/ide-io.c           |    2 +-
 drivers/ide/ide-iops.c         |   26 +++++++-------------------
 drivers/ide/ide-probe.c        |    2 +-
 drivers/ide/ide-taskfile.c     |   16 +++++++++-------
 drivers/ide/legacy/falconide.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/ide/legacy/q40ide.c    |   34 ++++++++++++++++++++++++++++++++++
 include/linux/ide.h            |    4 ++--
 8 files changed, 98 insertions(+), 36 deletions(-)

Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -673,8 +673,10 @@ cris_ide_inb(unsigned long reg)
 	return (unsigned char)cris_ide_inw(reg);
 }
 
-static void cris_ide_input_data (ide_drive_t *drive, void *, unsigned int);
-static void cris_ide_output_data (ide_drive_t *drive, void *, unsigned int);
+static void cris_ide_input_data(ide_drive_t *, struct request *,
+				void *, unsigned int);
+static void cris_ide_output_data(ide_drive_t *, struct request *,
+				 void *, unsigned int);
 static void cris_atapi_input_bytes(ide_drive_t *drive, void *, unsigned int);
 static void cris_atapi_output_bytes(ide_drive_t *drive, void *, unsigned int);
 
@@ -900,8 +902,8 @@ cris_atapi_output_bytes (ide_drive_t *dr
 /*
  * This is used for most PIO data transfers *from* the IDE interface
  */
-static void
-cris_ide_input_data (ide_drive_t *drive, void *buffer, unsigned int wcount)
+static void cris_ide_input_data(ide_drive_t *drive, struct request *rq,
+				void *buffer, unsigned int wcount)
 {
 	cris_atapi_input_bytes(drive, buffer, wcount << 2);
 }
@@ -909,8 +911,8 @@ cris_ide_input_data (ide_drive_t *drive,
 /*
  * This is used for most PIO data transfers *to* the IDE interface
  */
-static void
-cris_ide_output_data (ide_drive_t *drive, void *buffer, unsigned int wcount)
+static void cris_ide_output_data(ide_drive_t *drive, struct request *,
+				 void *buffer, unsigned int wcount)
 {
 	cris_atapi_output_bytes(drive, buffer, wcount << 2);
 }
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -422,7 +422,7 @@ static void try_to_flush_leftover_data (
 		u32 wcount = (i > 16) ? 16 : i;
 
 		i -= wcount;
-		HWIF(drive)->ata_input_data(drive, buffer, wcount);
+		drive->hwif->ata_input_data(drive, NULL, buffer, wcount);
 	}
 }
 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -192,7 +192,8 @@ static void ata_vlb_sync(ide_drive_t *dr
 /*
  * This is used for most PIO data transfers *from* the IDE interface
  */
-static void ata_input_data(ide_drive_t *drive, void *buffer, u32 wcount)
+static void ata_input_data(ide_drive_t *drive, struct request *rq,
+			   void *buffer, u32 wcount)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -215,7 +216,8 @@ static void ata_input_data(ide_drive_t *
 /*
  * This is used for most PIO data transfers *to* the IDE interface
  */
-static void ata_output_data(ide_drive_t *drive, void *buffer, u32 wcount)
+static void ata_output_data(ide_drive_t *drive, struct request *rq,
+			    void *buffer, u32 wcount)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -248,14 +250,7 @@ static void atapi_input_bytes(ide_drive_
 	ide_hwif_t *hwif = HWIF(drive);
 
 	++bytecount;
-#if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
-	if (MACH_IS_ATARI || MACH_IS_Q40) {
-		/* Atari has a byte-swapped IDE interface */
-		insw_swapw(hwif->io_ports.data_addr, buffer, bytecount / 2);
-		return;
-	}
-#endif /* CONFIG_ATARI || CONFIG_Q40 */
-	hwif->ata_input_data(drive, buffer, bytecount / 4);
+	hwif->ata_input_data(drive, NULL, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
 		hwif->INSW(hwif->io_ports.data_addr,
 			   (u8 *)buffer + (bytecount & ~0x03), 1);
@@ -266,14 +261,7 @@ static void atapi_output_bytes(ide_drive
 	ide_hwif_t *hwif = HWIF(drive);
 
 	++bytecount;
-#if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
-	if (MACH_IS_ATARI || MACH_IS_Q40) {
-		/* Atari has a byte-swapped IDE interface */
-		outsw_swapw(hwif->io_ports.data_addr, buffer, bytecount / 2);
-		return;
-	}
-#endif /* CONFIG_ATARI || CONFIG_Q40 */
-	hwif->ata_output_data(drive, buffer, bytecount / 4);
+	hwif->ata_output_data(drive, NULL, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
 		hwif->OUTSW(hwif->io_ports.data_addr,
 			    (u8 *)buffer + (bytecount & ~0x03), 1);
@@ -668,7 +656,7 @@ int ide_driveid_update(ide_drive_t *driv
 		local_irq_restore(flags);
 		return 0;
 	}
-	hwif->ata_input_data(drive, id, SECTOR_WORDS);
+	hwif->ata_input_data(drive, NULL, id, SECTOR_WORDS);
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
+	hwif->ata_input_data(drive, NULL, id, SECTOR_WORDS);
 
 	drive->id_read = 1;
 	local_irq_enable();
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -283,7 +283,8 @@ static u8 wait_drive_not_busy(ide_drive_
 	return stat;
 }
 
-static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
+static void ide_pio_sector(ide_drive_t *drive, struct request *rq,
+			   unsigned int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
@@ -323,9 +324,9 @@ static void ide_pio_sector(ide_drive_t *
 
 	/* do the actual data transfer */
 	if (write)
-		hwif->ata_output_data(drive, buf, SECTOR_WORDS);
+		hwif->ata_output_data(drive, rq, buf, SECTOR_WORDS);
 	else
-		hwif->ata_input_data(drive, buf, SECTOR_WORDS);
+		hwif->ata_input_data(drive, rq, buf, SECTOR_WORDS);
 
 	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
 #ifdef CONFIG_HIGHMEM
@@ -333,13 +334,14 @@ static void ide_pio_sector(ide_drive_t *
 #endif
 }
 
-static void ide_pio_multi(ide_drive_t *drive, unsigned int write)
+static void ide_pio_multi(ide_drive_t *drive, struct request *rq,
+			  unsigned int write)
 {
 	unsigned int nsect;
 
 	nsect = min_t(unsigned int, drive->hwif->nleft, drive->mult_count);
 	while (nsect--)
-		ide_pio_sector(drive, write);
+		ide_pio_sector(drive, rq, write);
 }
 
 static void ide_pio_datablock(ide_drive_t *drive, struct request *rq,
@@ -362,10 +364,10 @@ static void ide_pio_datablock(ide_drive_
 	switch (drive->hwif->data_phase) {
 	case TASKFILE_MULTI_IN:
 	case TASKFILE_MULTI_OUT:
-		ide_pio_multi(drive, write);
+		ide_pio_multi(drive, rq, write);
 		break;
 	default:
-		ide_pio_sector(drive, write);
+		ide_pio_sector(drive, rq, write);
 		break;
 	}
 
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -44,6 +44,36 @@
 int falconide_intr_lock;
 EXPORT_SYMBOL(falconide_intr_lock);
 
+static void falconide_atapi_input_bytes(ide_drive_t *drive, void *buf,
+					unsigned int len)
+{
+	insw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void falconide_atapi_output_bytes(ide_drive_t *drive, void *buf,
+					 unsigned int len)
+{
+	outsw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void falconide_ata_input_data(ide_drive_t *drive, struct request *rq,
+				     void *buf, unsigned int wcount)
+{
+	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+		return insw(drive->hwif->io_ports.data_addr, buf, wcount * 2);
+
+	falconide_atapi_input_bytes(drive, buf, wcount * 4);
+}
+
+static void falconide_ata_output_data(ide_drive_t *drive, struct request *rq,
+				      void *buf, unsigned int wcount)
+{
+	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+		return outsw(drive->hwif->io_ports.data_addr, buf, wcount * 2);
+
+	falconide_atapi_output_bytes(drive, buf, wcount * 4);
+}
+
 static void __init falconide_setup_ports(hw_regs_t *hw)
 {
 	int i;
@@ -89,6 +119,12 @@ static int __init falconide_init(void)
 
 		ide_init_port_hw(hwif, &hw);
 
+		/* Atari has a byte-swapped IDE interface */
+		hwif->atapi_input_bytes  = falconide_atapi_input_bytes;
+		hwif->atapi_output_bytes = falconide_atapi_output_bytes;
+		hwif->ata_input_data	 = falconide_ata_input_data;
+		hwif->ata_output_data	 = falconide_ata_output_data;
+
 		ide_get_lock(NULL, NULL);
 		ide_device_add(idx, NULL);
 		ide_release_lock();
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -90,7 +90,35 @@ void q40_ide_setup_ports ( hw_regs_t *hw
 	hw->ack_intr = ack_intr;
 }
 
+static void q40ide_atapi_input_bytes(ide_drive_t *drive, void *buf,
+				     unsigned int len)
+{
+	insw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
 
+static void q40ide_atapi_output_bytes(ide_drive_t *drive, void *buf,
+				      unsigned int len)
+{
+	outsw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void q40ide_ata_input_data(ide_drive_t *drive, struct request *rq,
+				  void *buf, unsigned int wcount)
+{
+	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+		return insw(drive->hwif->io_ports.data_addr, buf, wcount * 2);
+
+	q40ide_atapi_input_bytes(drive, buf, wcount * 4);
+}
+
+static void q40ide_ata_output_data(ide_drive_t *drive, struct request *rq,
+				   void *buf, unsigned int wcount)
+{
+	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+		return outsw(drive->hwif->io_ports.data_addr, buf, wcount * 2);
+
+	q40ide_atapi_output_bytes(drive, buf, wcount * 4);
+}
 
 /* 
  * the static array is needed to have the name reported in /proc/ioports,
@@ -141,6 +169,12 @@ static int __init q40ide_init(void)
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw);
 
+		/* Q40 has a byte-swapped IDE interface */
+		hwif->atapi_input_bytes  = q40ide_atapi_input_bytes;
+		hwif->atapi_output_bytes = q40ide_atapi_output_bytes;
+		hwif->ata_input_data	 = q40ide_ata_input_data;
+		hwif->ata_output_data	 = q40ide_ata_output_data;
+
 		idx[i] = hwif->index;
 	}
     }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -469,8 +469,8 @@ typedef struct hwif_s {
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
-	void (*ata_input_data)(ide_drive_t *, void *, u32);
-	void (*ata_output_data)(ide_drive_t *, void *, u32);
+	void (*ata_input_data)(ide_drive_t *, struct request *, void *, u32);
+	void (*ata_output_data)(ide_drive_t *, struct request *, void *, u32);
 
 	void (*atapi_input_bytes)(ide_drive_t *, void *, u32);
 	void (*atapi_output_bytes)(ide_drive_t *, void *, u32);
