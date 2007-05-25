Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbXEYWDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbXEYWDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXEYWDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:03:11 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58023 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbXEYWDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:03:09 -0400
Date: Fri, 25 May 2007 18:03:07 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       mikpe@it.uu.se
Subject: [git patches] libata fixes
Message-ID: <20070525220307.GA2914@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


And a few trivial documentation patches.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-scsi.c  |    5 ++-
 drivers/ata/pata_artop.c   |    2 +-
 drivers/ata/pata_hpt37x.c  |   27 ++++++++++---------------
 drivers/ata/pata_it821x.c  |    3 +-
 drivers/ata/pata_scc.c     |   46 ++++++++++++++++++++++++++-----------------
 drivers/ata/pata_via.c     |    9 ++++---
 drivers/ata/sata_mv.c      |   44 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/sata_promise.c |    2 +-
 drivers/ata/sata_sis.c     |    2 +-
 drivers/ata/sata_via.c     |    3 ++
 10 files changed, 98 insertions(+), 45 deletions(-)

Alan Cox (2):
      pata: Trivia
      pata_hpt37x: Further improvements based on the IDE updates and vendor drivers

Jeff Garzik (4):
      [libata] sata_promise: fix flags typo
      [libata] sata_mv: add TODO list
      [libata] Fix decoding of 6-byte commands
      [libata] sata_via, pata_via: Add PCI IDs.

Tony Breeds (1):
      Fix build failure for drivers/ata/pata_scc.c

Uwe Koziolek (1):
      libata: sata_sis fixes

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 242c43e..b3900cf 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1050,14 +1050,15 @@ static unsigned int ata_scsi_flush_xlat(struct ata_queued_cmd *qc)
 static void scsi_6_lba_len(const u8 *cdb, u64 *plba, u32 *plen)
 {
 	u64 lba = 0;
-	u32 len = 0;
+	u32 len;
 
 	VPRINTK("six-byte command\n");
 
+	lba |= ((u64)(cdb[1] & 0x1f)) << 16;
 	lba |= ((u64)cdb[2]) << 8;
 	lba |= ((u64)cdb[3]);
 
-	len |= ((u32)cdb[4]);
+	len = cdb[4];
 
 	*plba = lba;
 	*plen = len;
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 7b4810c..03b6ddd 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -97,7 +97,7 @@ static int artop6260_pre_reset(struct ata_port *ap, unsigned long deadline)
  *	artop6260_cable_detect	-	identify cable type
  *	@ap: Port
  *
- *	Identify the cable type for the ARTOp interface in question
+ *	Identify the cable type for the ARTOP interface in question
  */
 
 static int artop6260_cable_detect(struct ata_port *ap)
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index a54c174..6446735 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.5"
+#define DRV_VERSION	"0.6.6"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -931,15 +931,6 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = 0x7f,
 		.port_ops = &hpt372_port_ops
 	};
-	/* HPT371, 372 and friends - UDMA100 at 50MHz clock */
-	static const struct ata_port_info info_hpt372_50 = {
-		.sht = &hpt37x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
-		.port_ops = &hpt372_port_ops
-	};
 	/* HPT374 - UDMA133 */
 	static const struct ata_port_info info_hpt374 = {
 		.sht = &hpt37x_sht,
@@ -1098,17 +1089,21 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		 *	use a 50MHz DPLL by choice
 		 */
 		unsigned int f_low, f_high;
-		int adjust;
+		int dpll, adjust;
 
-		clock_slot = 2;
+		/* Compute DPLL */
+		dpll = 2;
 		if (port->udma_mask & 0xE0)
-			clock_slot = 3;
+			dpll = 3;
 
-		f_low = (MHz[clock_slot] * chip_table->base) / 192;
+		f_low = (MHz[clock_slot] * 48) / MHz[dpll];
 		f_high = f_low + 2;
+		if (clock_slot > 1)
+			f_high += 2;
 
 		/* Select the DPLL clock. */
 		pci_write_config_byte(dev, 0x5b, 0x21);
+		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
 
 		for(adjust = 0; adjust < 8; adjust++) {
 			if (hpt37x_calibrate_dpll(dev))
@@ -1124,12 +1119,12 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			printk(KERN_WARNING "hpt37x: DPLL did not stabilize.\n");
 			return -ENODEV;
 		}
-		if (clock_slot == 3)
+		if (dpll == 3)
 			private_data = (void *)hpt37x_timings_66;
 		else
 			private_data = (void *)hpt37x_timings_50;
 
-		printk(KERN_INFO "hpt37x: Bus clock %dMHz, using DPLL.\n", MHz[clock_slot]);
+		printk(KERN_INFO "hpt37x: Bus clock %dMHz, using DPLL.\n", MHz[dpll]);
 	} else {
 		private_data = (void *)chip_table->clocks[clock_slot];
 		/*
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index ff9a6fd..b3456d7 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -1,5 +1,5 @@
 /*
- * ata-it821x.c 	- IT821x PATA for new ATA layer
+ * pata_it821x.c 	- IT821x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
  *
@@ -65,7 +65,6 @@
  *
  *  TODO
  *	-	ATAPI and other speed filtering
- *	-	Command filter in smart mode
  *	-	RAID configuration ioctls
  */
 
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index aa138d2..61502bc 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -489,23 +489,26 @@ static unsigned int scc_devchk (struct ata_port *ap,
  *	Note: Original code is ata_bus_post_reset().
  */
 
-static void scc_bus_post_reset (struct ata_port *ap, unsigned int devmask)
+static int scc_bus_post_reset(struct ata_port *ap, unsigned int devmask,
+                              unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 	unsigned int dev0 = devmask & (1 << 0);
 	unsigned int dev1 = devmask & (1 << 1);
-	unsigned long timeout;
+	int rc;
 
 	/* if device 0 was found in ata_devchk, wait for its
 	 * BSY bit to clear
 	 */
-	if (dev0)
-		ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
+	if (dev0) {
+		rc = ata_wait_ready(ap, deadline);
+		if (rc && rc != -ENODEV)
+			return rc;
+	}
 
 	/* if device 1 was found in ata_devchk, wait for
 	 * register access, then wait for BSY to clear
 	 */
-	timeout = jiffies + ATA_TMOUT_BOOT;
 	while (dev1) {
 		u8 nsect, lbal;
 
@@ -514,14 +517,15 @@ static void scc_bus_post_reset (struct ata_port *ap, unsigned int devmask)
 		lbal = in_be32(ioaddr->lbal_addr);
 		if ((nsect == 1) && (lbal == 1))
 			break;
-		if (time_after(jiffies, timeout)) {
-			dev1 = 0;
-			break;
-		}
+		if (time_after(jiffies, deadline))
+			return -EBUSY;
 		msleep(50);	/* give drive a breather */
 	}
-	if (dev1)
-		ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
+	if (dev1) {
+		rc = ata_wait_ready(ap, deadline);
+		if (rc && rc != -ENODEV)
+			return rc;
+	}
 
 	/* is all this really necessary? */
 	ap->ops->dev_select(ap, 0);
@@ -529,6 +533,8 @@ static void scc_bus_post_reset (struct ata_port *ap, unsigned int devmask)
 		ap->ops->dev_select(ap, 1);
 	if (dev0)
 		ap->ops->dev_select(ap, 0);
+
+	return 0;
 }
 
 /**
@@ -537,8 +543,8 @@ static void scc_bus_post_reset (struct ata_port *ap, unsigned int devmask)
  *	Note: Original code is ata_bus_softreset().
  */
 
-static unsigned int scc_bus_softreset (struct ata_port *ap,
-				       unsigned int devmask)
+static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
+                                      unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
@@ -570,7 +576,7 @@ static unsigned int scc_bus_softreset (struct ata_port *ap,
 	if (scc_check_status(ap) == 0xFF)
 		return 0;
 
-	scc_bus_post_reset(ap, devmask);
+	scc_bus_post_reset(ap, devmask, deadline);
 
 	return 0;
 }
@@ -579,11 +585,13 @@ static unsigned int scc_bus_softreset (struct ata_port *ap,
  *	scc_std_softreset - reset host port via ATA SRST
  *	@ap: port to reset
  *	@classes: resulting classes of attached devices
+ *	@deadline: deadline jiffies for the operation
  *
  *	Note: Original code is ata_std_softreset().
  */
 
-static int scc_std_softreset (struct ata_port *ap, unsigned int *classes)
+static int scc_std_softreset (struct ata_port *ap, unsigned int *classes,
+                              unsigned long deadline)
 {
 	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
 	unsigned int devmask = 0, err_mask;
@@ -607,7 +615,7 @@ static int scc_std_softreset (struct ata_port *ap, unsigned int *classes)
 
 	/* issue bus reset */
 	DPRINTK("about to softreset, devmask=%x\n", devmask);
-	err_mask = scc_bus_softreset(ap, devmask);
+	err_mask = scc_bus_softreset(ap, devmask, deadline);
 	if (err_mask) {
 		ata_port_printk(ap, KERN_ERR, "SRST failed (err_mask=0x%x)\n",
 				err_mask);
@@ -676,10 +684,11 @@ static void scc_bmdma_stop (struct ata_queued_cmd *qc)
 
 		if (reg & INTSTS_BMSINT) {
 			unsigned int classes;
+			unsigned long deadline = jiffies + ATA_TMOUT_BOOT;
 			printk(KERN_WARNING "%s: Internal Bus Error\n", DRV_NAME);
 			out_be32(bmid_base + SCC_DMA_INTST, INTSTS_BMSINT);
 			/* TBD: SW reset */
-			scc_std_softreset(ap, &classes);
+			scc_std_softreset(ap, &classes, deadline);
 			continue;
 		}
 
@@ -862,9 +871,10 @@ static void scc_bmdma_freeze (struct ata_port *ap)
 /**
  *	scc_pata_prereset - prepare for reset
  *	@ap: ATA port to be reset
+ *	@deadline: deadline jiffies for the operation
  */
 
-static int scc_pata_prereset (struct ata_port *ap, unsigned long deadline)
+static int scc_pata_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	ap->cbl = ATA_CBL_PATA80;
 	return ata_std_prereset(ap, deadline);
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 708dfc0..a8462f1 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -621,10 +621,11 @@ static int via_reinit_one(struct pci_dev *pdev)
 #endif
 
 static const struct pci_device_id via[] = {
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C576_1), },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C586_1), },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_6410), },
-	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_SATA_EIDE), },
+	{ PCI_VDEVICE(VIA, 0x0571), },
+	{ PCI_VDEVICE(VIA, 0x0581), },
+	{ PCI_VDEVICE(VIA, 0x1571), },
+	{ PCI_VDEVICE(VIA, 0x3164), },
+	{ PCI_VDEVICE(VIA, 0x5324), },
 
 	{ },
 };
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 705a020..c957e6e 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -21,6 +21,50 @@
  *
  */
 
+/*
+  sata_mv TODO list:
+
+  1) Needs a full errata audit for all chipsets.  I implemented most
+  of the errata workarounds found in the Marvell vendor driver, but
+  I distinctly remember a couple workarounds (one related to PCI-X)
+  are still needed.
+
+  2) Convert to LibATA new EH.  Required for hotplug, NCQ, and sane
+  probing/error handling in general.  MUST HAVE.
+
+  3) Add hotplug support (easy, once new-EH support appears)
+
+  4) Add NCQ support (easy to intermediate, once new-EH support appears)
+
+  5) Investigate problems with PCI Message Signalled Interrupts (MSI).
+
+  6) Add port multiplier support (intermediate)
+
+  7) Test and verify 3.0 Gbps support
+
+  8) Develop a low-power-consumption strategy, and implement it.
+
+  9) [Experiment, low priority] See if ATAPI can be supported using
+  "unknown FIS" or "vendor-specific FIS" support, or something creative
+  like that.
+
+  10) [Experiment, low priority] Investigate interrupt coalescing.
+  Quite often, especially with PCI Message Signalled Interrupts (MSI),
+  the overhead reduced by interrupt mitigation is quite often not
+  worth the latency cost.
+
+  11) [Experiment, Marvell value added] Is it possible to use target
+  mode to cross-connect two Linux boxes with Marvell cards?  If so,
+  creating LibATA target mode support would be very interesting.
+
+  Target mode, for those without docs, is the ability to directly
+  connect two SATA controllers.
+
+  13) Verify that 7042 is fully supported.  I only have a 6042.
+
+*/
+
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 3a7d9b5..2b924a6 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -297,7 +297,7 @@ static const struct ata_port_info pdc_port_info[] = {
 
 	/* board_2057x_pata */
 	{
-		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS,
+		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS |
 				  PDC_FLAG_GEN_II,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 51d9251..221099d 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -255,7 +255,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	struct ata_port_info pi = sis_port_info;
-	const struct ata_port_info *ppi[] = { &pi, NULL };
+	const struct ata_port_info *ppi[] = { &pi, &pi };
 	struct ata_host *host;
 	u32 genctl, val;
 	u8 pmr;
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 01bba26..e8b90e7 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -85,6 +85,9 @@ static const struct pci_device_id svia_pci_tbl[] = {
 	{ PCI_VDEVICE(VIA, 0x0591), vt6420 },
 	{ PCI_VDEVICE(VIA, 0x3149), vt6420 },
 	{ PCI_VDEVICE(VIA, 0x3249), vt6421 },
+	{ PCI_VDEVICE(VIA, 0x5287), vt6420 },
+	{ PCI_VDEVICE(VIA, 0x5372), vt6420 },
+	{ PCI_VDEVICE(VIA, 0x7372), vt6420 },
 
 	{ }	/* terminate list */
 };
