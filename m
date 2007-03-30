Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXC3VJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXC3VJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbXC3VJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:09:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58170 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXC3VJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:09:10 -0400
Date: Fri, 30 Mar 2007 14:03:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Albert Lee <albertcc@tw.ibm.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Adam Hawks <awhawks@us.ibm.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 01/37] ide: clear bmdma status in ide_intr() for ICHx
	controllers (revised #4)
Message-ID: <20070330210348.GB29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-clear-bmdma-status-in-ide_intr-for-ichx-controllers.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Albert Lee <albertcc@tw.ibm.com>

ide: clear bmdma status in ide_intr() for ICHx controllers (revised #4)

patch 1/2 (revised):
- Fix drive->waiting_for_dma to work with CDB-intr devices.
- Do the dma status clearing in ide_intr() and add a new
  hwif->ide_dma_clear_irq for Intel ICHx controllers.

Revised per Alan, Sergei and Bart's advice.

Patch against 2.6.20-rc6. Tested ok on my ICH4 and pdc20275 adapters.
Please review/apply, thanks.

Signed-off-by: Albert Lee <albertcc@tw.ibm.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adam Hawks <awhawks@us.ibm.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-cd.c   |    8 ++++++
 drivers/ide/ide-io.c   |   11 ++++++++
 drivers/ide/ide.c      |    1 
 drivers/ide/pci/piix.c |   63 +++++++++++++++++++++++++++++++++++++------------
 include/linux/ide.h    |    1 
 5 files changed, 69 insertions(+), 15 deletions(-)

--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -930,6 +930,10 @@ static ide_startstop_t cdrom_start_packe
 		HWIF(drive)->OUTB(drive->ctl, IDE_CONTROL_REG);
  
 	if (CDROM_CONFIG_FLAGS (drive)->drq_interrupt) {
+		/* waiting for CDB interrupt, not DMA yet. */
+		if (info->dma)
+			drive->waiting_for_dma = 0;
+
 		/* packet command */
 		ide_execute_command(drive, WIN_PACKETCMD, handler, ATAPI_WAIT_PC, cdrom_timer_expiry);
 		return ide_started;
@@ -972,6 +976,10 @@ static ide_startstop_t cdrom_transfer_pa
 		/* Check for errors. */
 		if (cdrom_decode_status(drive, DRQ_STAT, NULL))
 			return ide_stopped;
+
+		/* Ok, next interrupt will be DMA interrupt. */
+		if (info->dma)
+			drive->waiting_for_dma = 1;
 	} else {
 		/* Otherwise, we must wait for DRQ to get set. */
 		if (ide_wait_stat(&startstop, drive, DRQ_STAT,
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1646,6 +1646,17 @@ irqreturn_t ide_intr (int irq, void *dev
 	del_timer(&hwgroup->timer);
 	spin_unlock(&ide_lock);
 
+	/* Some controllers might set DMA INTR no matter DMA or PIO;
+	 * bmdma status might need to be cleared even for
+	 * PIO interrupts to prevent spurious/lost irq.
+	 */
+	if (hwif->ide_dma_clear_irq && !(drive->waiting_for_dma))
+		/* ide_dma_end() needs bmdma status for error checking.
+		 * So, skip clearing bmdma status here and leave it
+		 * to ide_dma_end() if this is dma interrupt.
+		 */
+		hwif->ide_dma_clear_irq(drive);
+
 	if (drive->unmask)
 		local_irq_enable_in_hardirq();
 	/* service this interrupt, may set handler for next interrupt */
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -503,6 +503,7 @@ static void ide_hwif_restore(ide_hwif_t 
 	hwif->ide_dma_on		= tmp_hwif->ide_dma_on;
 	hwif->ide_dma_off_quietly	= tmp_hwif->ide_dma_off_quietly;
 	hwif->ide_dma_test_irq		= tmp_hwif->ide_dma_test_irq;
+	hwif->ide_dma_clear_irq		= tmp_hwif->ide_dma_clear_irq;
 	hwif->ide_dma_host_on		= tmp_hwif->ide_dma_host_on;
 	hwif->ide_dma_host_off		= tmp_hwif->ide_dma_host_off;
 	hwif->ide_dma_lostirq		= tmp_hwif->ide_dma_lostirq;
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -411,17 +411,14 @@ fast_ata_pio:
 }
 
 /**
- *	init_chipset_piix	-	set up the PIIX chipset
- *	@dev: PCI device to set up
- *	@name: Name of the device
+ *	piix_is_ichx	-	check if ICHx
+ *	@dev: PCI device to check
  *
- *	Initialize the PCI device as required. For the PIIX this turns
- *	out to be nice and simple
+ *	returns 1 if ICHx, 0 otherwise.
  */
- 
-static unsigned int __devinit init_chipset_piix (struct pci_dev *dev, const char *name)
+static int piix_is_ichx(struct pci_dev *dev)
 {
-        switch(dev->device) {
+        switch (dev->device) {
 		case PCI_DEVICE_ID_INTEL_82801EB_1:
 		case PCI_DEVICE_ID_INTEL_82801AA_1:
 		case PCI_DEVICE_ID_INTEL_82801AB_1:
@@ -439,19 +436,51 @@ static unsigned int __devinit init_chips
 		case PCI_DEVICE_ID_INTEL_ICH7_21:
 		case PCI_DEVICE_ID_INTEL_ESB2_18:
 		case PCI_DEVICE_ID_INTEL_ICH8_6:
-		{
-			unsigned int extra = 0;
-			pci_read_config_dword(dev, 0x54, &extra);
-			pci_write_config_dword(dev, 0x54, extra|0x400);
-		}
-		default:
-			break;
+			return 1;
 	}
 
 	return 0;
 }
 
 /**
+ *	init_chipset_piix	-	set up the PIIX chipset
+ *	@dev: PCI device to set up
+ *	@name: Name of the device
+ *
+ *	Initialize the PCI device as required. For the PIIX this turns
+ *	out to be nice and simple
+ */
+
+static unsigned int __devinit init_chipset_piix (struct pci_dev *dev, const char *name)
+{
+	if (piix_is_ichx(dev)) {
+		unsigned int extra = 0;
+		pci_read_config_dword(dev, 0x54, &extra);
+		pci_write_config_dword(dev, 0x54, extra|0x400);
+	}
+
+	return 0;
+}
+
+/**
+ *	piix_dma_clear_irq	-	clear BMDMA status
+ *	@drive: IDE drive to clear
+ *
+ *	Called from ide_intr() for PIO interrupts
+ *	to clear BMDMA status as needed by ICHx
+ */
+static void piix_dma_clear_irq(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = HWIF(drive);
+	u8 dma_stat;
+
+	/* clear the INTR & ERROR bits */
+	dma_stat = hwif->INB(hwif->dma_status);
+	/* Should we force the bit as well ? */
+	hwif->OUTB(dma_stat, hwif->dma_status);
+}
+
+/**
  *	init_hwif_piix		-	fill in the hwif for the PIIX
  *	@hwif: IDE interface
  *
@@ -487,6 +516,10 @@ static void __devinit init_hwif_piix(ide
 	if (!hwif->dma_base)
 		return;
 
+	/* ICHx need to clear the bmdma status for all interrupts */
+	if (piix_is_ichx(hwif->pci_dev))
+		hwif->ide_dma_clear_irq = &piix_dma_clear_irq;
+
 	hwif->atapi_dma = 1;
 	hwif->ultra_mask = 0x3f;
 	hwif->mwdma_mask = 0x06;
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -727,6 +727,7 @@ typedef struct hwif_s {
 	int (*ide_dma_on)(ide_drive_t *drive);
 	int (*ide_dma_off_quietly)(ide_drive_t *drive);
 	int (*ide_dma_test_irq)(ide_drive_t *drive);
+	void (*ide_dma_clear_irq)(ide_drive_t *drive);
 	int (*ide_dma_host_on)(ide_drive_t *drive);
 	int (*ide_dma_host_off)(ide_drive_t *drive);
 	int (*ide_dma_lostirq)(ide_drive_t *drive);

-- 
