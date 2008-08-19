Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYHSSi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYHSSi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYHSShf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:37:35 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:24747 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYHSShX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=IVXSLCGxET53p2xtcqWNQD0+v0z+jYa/VcTugFQftxE3LB+ISCEzT8G/2j5Kn7e7Gh
         lQJsaYrplqN6rzXG0DUhh0RDmWRo8mzJqYZSJ0bdpuEejdUHCuD731vgkcUX/RXl2z2S
         WiaXTw0mSW/cl7ytbUkQ6n/R9ioekS86kGEXM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/5] ide: ->ide_dma_clear_irq() -> ->clear_irq()
Date: Tue, 19 Aug 2008 20:31:40 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192031.40288.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rename ->ide_dma_clear_irq method to ->clear_irq
  and move it from ide_hwif_t to struct ide_port_ops.

* Move ->waiting_for_dma check inside ->clear_irq method.

* Move ->dma_base check inside ->clear_irq method.

piix.c:
* Add ich_port_ops and remove init_hwif_ich() wrapper.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c   |   15 ++++-----------
 drivers/ide/pci/piix.c |   39 +++++++++++++++++++++++----------------
 include/linux/ide.h    |    4 ++--
 3 files changed, 29 insertions(+), 29 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1418,23 +1418,16 @@ irqreturn_t ide_intr (int irq, void *dev
 	del_timer(&hwgroup->timer);
 	spin_unlock(&ide_lock);
 
-	/* Some controllers might set DMA INTR no matter DMA or PIO;
-	 * bmdma status might need to be cleared even for
-	 * PIO interrupts to prevent spurious/lost irq.
-	 */
-	if (hwif->ide_dma_clear_irq && !(drive->waiting_for_dma))
-		/* ide_dma_end() needs bmdma status for error checking.
-		 * So, skip clearing bmdma status here and leave it
-		 * to ide_dma_end() if this is dma interrupt.
-		 */
-		hwif->ide_dma_clear_irq(drive);
+	if (hwif->port_ops && hwif->port_ops->clear_irq)
+		hwif->port_ops->clear_irq(drive);
 
 	if (drive->dev_flags & IDE_DFLAG_UNMASK)
 		local_irq_enable_in_hardirq();
+
 	/* service this interrupt, may set handler for next interrupt */
 	startstop = handler(drive);
-	spin_lock_irq(&ide_lock);
 
+	spin_lock_irq(&ide_lock);
 	/*
 	 * Note that handler() may have set things up for another
 	 * interrupt to occur soon, but it cannot happen until
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -215,17 +215,26 @@ static unsigned int init_chipset_ich(str
 }
 
 /**
- *	piix_dma_clear_irq	-	clear BMDMA status
- *	@drive: IDE drive to clear
+ *	ich_clear_irq	-	clear BMDMA status
+ *	@drive: IDE drive
  *
- *	Called from ide_intr() for PIO interrupts
- *	to clear BMDMA status as needed by ICHx
+ *	ICHx contollers set DMA INTR no matter DMA or PIO.
+ *	BMDMA status might need to be cleared even for
+ *	PIO interrupts to prevent spurious/lost IRQ.
  */
-static void piix_dma_clear_irq(ide_drive_t *drive)
+static void ich_clear_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	u8 dma_stat;
 
+	/*
+	 * ide_dma_end() needs BMDMA status for error checking.
+	 * So, skip clearing BMDMA status here and leave it
+	 * to ide_dma_end() if this is DMA interrupt.
+	 */
+	if (drive->waiting_for_dma || hwif->dma_base == 0)
+		return;
+
 	/* clear the INTR & ERROR bits */
 	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* Should we force the bit as well ? */
@@ -293,21 +302,19 @@ static void __devinit init_hwif_piix(ide
 		hwif->ultra_mask = hwif->mwdma_mask = hwif->swdma_mask = 0;
 }
 
-static void __devinit init_hwif_ich(ide_hwif_t *hwif)
-{
-	init_hwif_piix(hwif);
-
-	/* ICHx need to clear the BMDMA status for all interrupts */
-	if (hwif->dma_base)
-		hwif->ide_dma_clear_irq = &piix_dma_clear_irq;
-}
-
 static const struct ide_port_ops piix_port_ops = {
 	.set_pio_mode		= piix_set_pio_mode,
 	.set_dma_mode		= piix_set_dma_mode,
 	.cable_detect		= piix_cable_detect,
 };
 
+static const struct ide_port_ops ich_port_ops = {
+	.set_pio_mode		= piix_set_pio_mode,
+	.set_dma_mode		= piix_set_dma_mode,
+	.clear_irq		= ich_clear_irq,
+	.cable_detect		= piix_cable_detect,
+};
+
 #ifndef CONFIG_IA64
  #define IDE_HFLAGS_PIIX IDE_HFLAG_LEGACY_IRQS
 #else
@@ -331,9 +338,9 @@ static const struct ide_port_ops piix_po
 	{ \
 		.name		= DRV_NAME, \
 		.init_chipset	= init_chipset_ich, \
-		.init_hwif	= init_hwif_ich, \
+		.init_hwif	= init_hwif_piix, \
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
-		.port_ops	= &piix_port_ops, \
+		.port_ops	= &ich_port_ops, \
 		.host_flags	= IDE_HFLAGS_PIIX, \
 		.pio_mask	= ATA_PIO4, \
 		.swdma_mask	= ATA_SWDMA2_ONLY, \
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -702,6 +702,7 @@ extern const struct ide_tp_ops default_t
  * @resetproc:		routine to reset controller after a disk reset
  * @maskproc:		special host masking for drive selection
  * @quirkproc:		check host's drive quirk list
+ * @clear_irq:		clear IRQ
  *
  * @mdma_filter:	filter MDMA modes
  * @udma_filter:	filter UDMA modes
@@ -718,6 +719,7 @@ struct ide_port_ops {
 	void	(*resetproc)(ide_drive_t *);
 	void	(*maskproc)(ide_drive_t *, int);
 	void	(*quirkproc)(ide_drive_t *);
+	void	(*clear_irq)(ide_drive_t *);
 
 	u8	(*mdma_filter)(ide_drive_t *);
 	u8	(*udma_filter)(ide_drive_t *);
@@ -780,8 +782,6 @@ typedef struct hwif_s {
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
-	void (*ide_dma_clear_irq)(ide_drive_t *drive);
-
 	/* dma physical region descriptor table (cpu view) */
 	unsigned int	*dmatable_cpu;
 	/* dma physical region descriptor table (dma view) */
