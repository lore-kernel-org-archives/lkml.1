Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098Ab0A2QDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0A2QDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946Ab0A2QDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:03:46 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab0A2QDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:03:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=h0rdHnv9MbjOcNkuyw8WUe1q5K4arOQ2psi8kz+iEkPf9+UgI1/2vnXGTsXnWw3crA
         mvmmO9jxULDCGhJ2vcjlpzXx6+TVfZxzyTbGbSqx7R8oexIk5XOAh1iUmaQaWp0iTIxV
         STBHFc/F/X7EZuNaYyurf7hJKJGkkCENx3PVE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:03:34 +0100
Message-Id: <20100129160334.21495.95047.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 04/68] ata: make ATA timings code independent of libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ata: make ATA timings code independent of libata

* Fix ata_timing_compute() arguments to be independent of libata.

* Move ATA timings enums and function declarations to <linux/ata.h>.

* Add CONFIG_ATA_TIMINGS config option.

* Remove bogus error checks from some host drivers while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig          |    4 ++++
 drivers/ata/Makefile         |    4 +++-
 drivers/ata/ata-timings.c    |    5 ++---
 drivers/ata/pata_ali.c       |   19 +++++++++++++------
 drivers/ata/pata_amd.c       |    8 +++-----
 drivers/ata/pata_at32.c      |    8 ++------
 drivers/ata/pata_at91.c      |   18 ++++--------------
 drivers/ata/pata_atp867x.c   |    5 +++--
 drivers/ata/pata_cmd640.c    |    9 ++++-----
 drivers/ata/pata_cmd64x.c    |   13 ++++++-------
 drivers/ata/pata_cypress.c   |    5 +----
 drivers/ata/pata_icside.c    |    4 ++--
 drivers/ata/pata_legacy.c    |   32 +++++++++++++++++---------------
 drivers/ata/pata_ns87410.c   |    7 ++-----
 drivers/ata/pata_ns87415.c   |    2 +-
 drivers/ata/pata_octeon_cf.c |    4 ++--
 drivers/ata/pata_via.c       |    5 +++--
 include/linux/ata.h          |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/libata.h       |   37 -------------------------------------
 19 files changed, 115 insertions(+), 117 deletions(-)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -2,11 +2,15 @@
 # SATA/PATA driver configuration
 #
 
+config ATA_TIMINGS
+	bool
+
 menuconfig ATA
 	tristate "Serial ATA and Parallel ATA drivers"
 	depends on HAS_IOMEM
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
+	select ATA_TIMINGS
 	select SCSI
 	---help---
 	  If you want to use a ATA hard disk, ATA tape drive, ATA CD-ROM or
Index: b/drivers/ata/Makefile
===================================================================
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,4 +1,6 @@
 
+obj-$(CONFIG_ATA_TIMINGS)	+= ata-timings.o
+
 obj-$(CONFIG_ATA)		+= libata.o
 
 obj-$(CONFIG_SATA_AHCI)		+= ahci.o
@@ -83,7 +85,7 @@ obj-$(CONFIG_ATA_GENERIC)	+= ata_generic
 # Should be last libata driver
 obj-$(CONFIG_PATA_LEGACY)	+= pata_legacy.o
 
-libata-objs	:= ata-timings.o libata-core.o libata-scsi.o libata-eh.o
+libata-objs	:= libata-core.o libata-scsi.o libata-eh.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
Index: b/drivers/ata/ata-timings.c
===================================================================
--- a/drivers/ata/ata-timings.c
+++ b/drivers/ata/ata-timings.c
@@ -100,10 +100,9 @@ const struct ata_timing *ata_timing_find
 }
 EXPORT_SYMBOL_GPL(ata_timing_find_mode);
 
-int ata_timing_compute(struct ata_device *adev, unsigned short speed,
+int ata_timing_compute(const u16 *id, u8 speed, u8 pio_speed,
 		       struct ata_timing *t, int T, int UT)
 {
-	const u16 *id = adev->id;
 	const struct ata_timing *s;
 	struct ata_timing p;
 
@@ -150,7 +149,7 @@ int ata_timing_compute(struct ata_device
 	 */
 
 	if (speed > XFER_PIO_6) {
-		ata_timing_compute(adev, adev->pio_mode, &p, T, UT);
+		ata_timing_compute(id, pio_speed, pio_speed, &p, T, UT);
 		ata_timing_merge(&p, t, t, ATA_TIMING_ALL);
 	}
 
Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -210,13 +210,16 @@ static void ali_set_piomode(struct ata_p
 	struct ata_timing t;
 	unsigned long T =  1000000000 / 33333;	/* PCI clock based */
 
-	ata_timing_compute(adev, adev->pio_mode, &t, T, 1);
+	ata_timing_compute(adev->id, adev->pio_mode, adev->pio_mode, &t, T, 1);
 	if (pair) {
 		struct ata_timing p;
-		ata_timing_compute(pair, pair->pio_mode, &p, T, 1);
+
+		ata_timing_compute(pair->id, pair->pio_mode, pair->pio_mode,
+				   &p, T, 1);
 		ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
 		if (pair->dma_mode) {
-			ata_timing_compute(pair, pair->dma_mode, &p, T, 1);
+			ata_timing_compute(pair->id, pair->dma_mode,
+					   pair->pio_mode, &p, T, 1);
 			ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
 		}
 	}
@@ -256,13 +259,17 @@ static void ali_set_dmamode(struct ata_p
 			pci_write_config_byte(pdev, 0x4B, reg4b);
 		}
 	} else {
-		ata_timing_compute(adev, adev->dma_mode, &t, T, 1);
+		ata_timing_compute(adev->id, adev->dma_mode, adev->pio_mode,
+				   &t, T, 1);
 		if (pair) {
 			struct ata_timing p;
-			ata_timing_compute(pair, pair->pio_mode, &p, T, 1);
+
+			ata_timing_compute(pair->id, pair->pio_mode,
+					   pair->pio_mode, &p, T, 1);
 			ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
 			if (pair->dma_mode) {
-				ata_timing_compute(pair, pair->dma_mode, &p, T, 1);
+				ata_timing_compute(pair->id, pair->dma_mode,
+						   pair->pio_mode, &p, T, 1);
 				ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
 			}
 		}
Index: b/drivers/ata/pata_amd.c
===================================================================
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -59,13 +59,11 @@ static void timing_setup(struct ata_port
 	if (clock >= 2)
 		UT = T / 2;
 
-	if (ata_timing_compute(adev, speed, &at, T, UT) < 0) {
-		dev_printk(KERN_ERR, &pdev->dev, "unknown mode %d.\n", speed);
-		return;
-	}
+	ata_timing_compute(adev->id, speed, adev->pio_mode, &at, T, UT);
 
 	if (peer) {
-		ata_timing_compute(peer, peer->pio_mode, &apeer, T, UT);
+		ata_timing_compute(peer->id, peer->pio_mode,
+				   peer->pio_mode, &apeer, T, UT);
 		ata_timing_merge(&apeer, &at, &at, ATA_TIMING_8BIT);
 	}
 
Index: b/drivers/ata/pata_at32.c
===================================================================
--- a/drivers/ata/pata_at32.c
+++ b/drivers/ata/pata_at32.c
@@ -150,15 +150,11 @@ static void pata_at32_set_piomode(struct
 {
 	struct ata_timing timing;
 	struct at32_ide_info *info = ap->host->private_data;
-
 	int ret;
+	u8 mode = adev->pio_mode;
 
 	/* Compute ATA timing */
-	ret = ata_timing_compute(adev, adev->pio_mode, &timing, 1000, 0);
-	if (ret) {
-		dev_warn(ap->dev, "Failed to compute ATA timing %d\n", ret);
-		return;
-	}
+	ata_timing_compute(adev->id, mode, mode, &timing, 1000, 0);
 
 	/* Setup SMC to ATA timing */
 	ret = pata_at32_setup_timing(ap->dev, info, &timing);
Index: b/drivers/ata/pata_at91.c
===================================================================
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -48,9 +48,6 @@ struct at91_ide_info {
 	void __iomem *alt_addr;
 };
 
-static const struct ata_timing initial_timing =
-	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
-
 static unsigned long calc_mck_cycles(unsigned long ns, unsigned long mck_hz)
 {
 	unsigned long mul;
@@ -148,22 +145,15 @@ static void pata_at91_set_piomode(struct
 {
 	struct at91_ide_info *info = ap->host->private_data;
 	struct ata_timing timing;
-	int ret;
+	u8 mode = adev->pio_mode;
 
 	/* Compute ATA timing and set it to SMC */
-	ret = ata_timing_compute(adev, adev->pio_mode, &timing, 1000, 0);
-	if (ret) {
-		dev_warn(ap->dev, "Failed to compute ATA timing %d, \
-				set PIO_0 timing\n", ret);
-		set_smc_timing(ap->dev, info, &initial_timing);
-	} else {
-		set_smc_timing(ap->dev, info, &timing);
-	}
+	ata_timing_compute(adev->id, mode, mode, &timing, 1000, 0);
+
+	set_smc_timing(ap->dev, info, &timing);
 
 	/* Setup SMC mode */
 	set_smc_mode(info);
-
-	return;
 }
 
 static unsigned int pata_at91_data_xfer_noirq(struct ata_device *dev,
Index: b/drivers/ata/pata_atp867x.c
===================================================================
--- a/drivers/ata/pata_atp867x.c
+++ b/drivers/ata/pata_atp867x.c
@@ -223,9 +223,10 @@ static void atp867x_set_piomode(struct a
 	T = 1000000000 / 33333;
 	UT = T / 4;
 
-	ata_timing_compute(adev, speed, &t, T, UT);
+	ata_timing_compute(adev->id, speed, adev->pio_mode, &t, T, UT);
 	if (peer && peer->pio_mode) {
-		ata_timing_compute(peer, peer->pio_mode, &p, T, UT);
+		ata_timing_compute(peer->id, peer->pio_mode, peer->pio_mode,
+				   &p, T, UT);
 		ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
 	}
 
Index: b/drivers/ata/pata_cmd640.c
===================================================================
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -59,16 +59,15 @@ static void cmd640_set_piomode(struct at
 	int arttim = ARTIM0 + 2 * adev->devno;
 	struct ata_device *pair = ata_dev_pair(adev);
 
-	if (ata_timing_compute(adev, adev->pio_mode, &t, T, 0) < 0) {
-		printk(KERN_ERR DRV_NAME ": mode computation failed.\n");
-		return;
-	}
+	ata_timing_compute(adev->id, adev->pio_mode, adev->pio_mode, &t, T, 0);
 
 	/* The second channel has shared timings and the setup timing is
 	   messy to switch to merge it for worst case */
 	if (ap->port_no && pair) {
 		struct ata_timing p;
-		ata_timing_compute(pair, pair->pio_mode, &p, T, 1);
+
+		ata_timing_compute(pair->id, pair->pio_mode, pair->pio_mode,
+				   &p, T, 1);
 		ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP);
 	}
 
Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -145,10 +145,8 @@ static void cmd64x_set_timing(struct ata
 
 	/* ata_timing_compute is smart and will produce timings for MWDMA
 	   that don't violate the drives PIO capabilities. */
-	if (ata_timing_compute(adev, mode, &t, T, 0) < 0) {
-		printk(KERN_ERR DRV_NAME ": mode computation failed.\n");
-		return;
-	}
+	ata_timing_compute(adev->id, mode, adev->pio_mode, &t, T, 0);
+
 	if (ap->port_no) {
 		/* Slave has shared address setup */
 		struct ata_device *pair = ata_dev_pair(adev);
@@ -156,11 +154,12 @@ static void cmd64x_set_timing(struct ata
 		if (pair) {
 			struct ata_timing tp;
 
-			ata_timing_compute(pair, pair->pio_mode, &tp, T, 0);
+			ata_timing_compute(pair->id, pair->pio_mode,
+					pair->pio_mode, &tp, T, 0);
 			ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
 			if (pair->dma_mode) {
-				ata_timing_compute(pair, pair->dma_mode,
-						&tp, T, 0);
+				ata_timing_compute(pair->id, pair->dma_mode,
+						pair->pio_mode, &tp, T, 0);
 				ata_timing_merge(&tp, &t, &t, ATA_TIMING_SETUP);
 			}
 		}
Index: b/drivers/ata/pata_cypress.c
===================================================================
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -57,10 +57,7 @@ static void cy82c693_set_piomode(struct
 	short time_16, time_8;
 	u32 addr;
 
-	if (ata_timing_compute(adev, adev->pio_mode, &t, T, 1) < 0) {
-		printk(KERN_ERR DRV_NAME ": mome computation failed.\n");
-		return;
-	}
+	ata_timing_compute(adev->id, adev->pio_mode, adev->pio_mode, &t, T, 1);
 
 	time_16 = clamp_val(t.recover - 1, 0, 15) |
 		  (clamp_val(t.active - 1, 0, 15) << 4);
Index: b/drivers/ata/pata_icside.c
===================================================================
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -186,6 +186,7 @@ static const expansioncard_ops_t pata_ic
 static void pata_icside_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pata_icside_state *state = ap->host->private_data;
+	const u16 *id = adev->id;
 	struct ata_timing t;
 	unsigned int cycle;
 	char iomd_type;
@@ -193,8 +194,7 @@ static void pata_icside_set_dmamode(stru
 	/*
 	 * DMA is based on a 16MHz clock
 	 */
-	if (ata_timing_compute(adev, adev->dma_mode, &t, 1000, 1))
-		return;
+	ata_timing_compute(id, adev->dma_mode, adev->pio_mode, &t, 1000, 1);
 
 	/*
 	 * Choose the IOMD cycle timing which ensure that the interface
Index: b/drivers/ata/pata_legacy.c
===================================================================
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -357,11 +357,11 @@ static struct ata_port_operations pdc202
 
 static void ht6560a_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	u8 active, recover;
+	u8 mode = adev->pio_mode, active, recover;
 	struct ata_timing t;
 
 	/* Get the timing data in cycles. For now play safe at 50Mhz */
-	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
+	ata_timing_compute(adev->id, mode, mode, &t, 20000, 1000);
 
 	active = clamp_val(t.active, 2, 15);
 	recover = clamp_val(t.recover, 4, 15);
@@ -391,11 +391,11 @@ static struct ata_port_operations ht6560
 
 static void ht6560b_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	u8 active, recover;
+	u8 mode = adev->pio_mode, active, recover;
 	struct ata_timing t;
 
 	/* Get the timing data in cycles. For now play safe at 50Mhz */
-	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
+	ata_timing_compute(adev->id, mode, mode, &t, 20000, 1000);
 
 	active = clamp_val(t.active, 2, 15);
 	recover = clamp_val(t.recover, 2, 16);
@@ -456,7 +456,7 @@ static u8 opti_syscfg(u8 reg)
 static void opti82c611a_set_piomode(struct ata_port *ap,
 						struct ata_device *adev)
 {
-	u8 active, recover, setup;
+	u8 mode = adev->pio_mode, active, recover, setup;
 	struct ata_timing t;
 	struct ata_device *pair = ata_dev_pair(adev);
 	int clock;
@@ -472,13 +472,14 @@ static void opti82c611a_set_piomode(stru
 	clock = 1000000000 / khz[ioread8(ap->ioaddr.lbah_addr) & 0x03];
 
 	/* Get the timing data in cycles */
-	ata_timing_compute(adev, adev->pio_mode, &t, clock, 1000);
+	ata_timing_compute(adev->id, mode, mode, &t, clock, 1000);
 
 	/* Setup timing is shared */
 	if (pair) {
 		struct ata_timing tp;
-		ata_timing_compute(pair, pair->pio_mode, &tp, clock, 1000);
 
+		ata_timing_compute(pair->id, pair->pio_mode, pair->pio_mode,
+				   &tp, clock, 1000);
 		ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
 	}
 
@@ -531,7 +532,7 @@ static struct ata_port_operations opti82
 
 static void opti82c46x_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	u8 active, recover, setup;
+	u8 mode = adev->pio_mode, active, recover, setup;
 	struct ata_timing t;
 	struct ata_device *pair = ata_dev_pair(adev);
 	int clock;
@@ -551,13 +552,14 @@ static void opti82c46x_set_piomode(struc
 	clock = 1000000000 / khz[sysclk];
 
 	/* Get the timing data in cycles */
-	ata_timing_compute(adev, adev->pio_mode, &t, clock, 1000);
+	ata_timing_compute(adev->id, mode, mode, &t, clock, 1000);
 
 	/* Setup timing is shared */
 	if (pair) {
 		struct ata_timing tp;
-		ata_timing_compute(pair, pair->pio_mode, &tp, clock, 1000);
 
+		ata_timing_compute(pair->id, pair->pio_mode, pair->pio_mode,
+				   &tp, clock, 1000);
 		ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
 	}
 
@@ -651,10 +653,10 @@ static void qdi65x0_set_piomode(struct a
 	struct ata_timing t;
 	struct legacy_data *ld_qdi = ap->host->private_data;
 	int active, recovery;
-	u8 timing;
+	u8 mode = adev->pio_mode, timing;
 
 	/* Get the timing data in cycles */
-	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+	ata_timing_compute(adev->id, mode, mode, &t, 30303, 1000);
 
 	if (ld_qdi->fast) {
 		active = 8 - clamp_val(t.active, 1, 8);
@@ -786,16 +788,16 @@ static void winbond_set_piomode(struct a
 	struct ata_timing t;
 	struct legacy_data *ld_winbond = ap->host->private_data;
 	int active, recovery;
-	u8 reg;
+	u8 mode = adev->pio_mode, reg;
 	int timing = 0x88 + (ap->port_no * 4) + (adev->devno * 2);
 
 	reg = winbond_readcfg(ld_winbond->timing, 0x81);
 
 	/* Get the timing data in cycles */
 	if (reg & 0x40)		/* Fast VLB bus, assume 50MHz */
-		ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
+		ata_timing_compute(adev->id, mode, mode, &t, 20000, 1000);
 	else
-		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+		ata_timing_compute(adev->id, mode, mode, &t, 30303, 1000);
 
 	active = (clamp_val(t.active, 3, 17) - 1) & 0x0F;
 	recovery = (clamp_val(t.recover, 1, 15) + 1) & 0x0F;
Index: b/drivers/ata/pata_ns87410.c
===================================================================
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -65,7 +65,7 @@ static void ns87410_set_piomode(struct a
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int port = 0x40 + 4 * ap->port_no;
-	u8 idetcr, idefr;
+	u8 mode = adev->pio_mode, idetcr, idefr;
 	struct ata_timing at;
 
 	static const u8 activebits[15] = {
@@ -85,10 +85,7 @@ static void ns87410_set_piomode(struct a
 	else
 		idefr &= ~0x04;
 
-	if (ata_timing_compute(adev, adev->pio_mode, &at, 30303, 1) < 0) {
-		dev_printk(KERN_ERR, &pdev->dev, "unknown mode %d.\n", adev->pio_mode);
-		return;
-	}
+	ata_timing_compute(adev->id, mode, mode, &at, 30303, 1);
 
 	at.active = clamp_val(at.active, 2, 16) - 2;
 	at.setup = clamp_val(at.setup, 1, 4) - 1;
Index: b/drivers/ata/pata_ns87415.c
===================================================================
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -64,7 +64,7 @@ static void ns87415_set_mode(struct ata_
 	/* Timing register format is 17 - low nybble read timing with
 	   the high nybble being 16 - x for recovery time in PCI clocks */
 
-	ata_timing_compute(adev, adev->pio_mode, &t, T, 0);
+	ata_timing_compute(adev->id, adev->pio_mode, adev->pio_mode, &t, T, 0);
 
 	clocking = 17 - clamp_val(t.active, 2, 17);
 	clocking |= (16 - clamp_val(t.recover, 1, 16)) << 4;
Index: b/drivers/ata/pata_octeon_cf.c
===================================================================
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -104,11 +104,11 @@ static void octeon_cf_set_piomode(struct
 	int t1;
 	int t2;
 	int t2i;
+	u8 mode = dev->pio_mode;
 
 	T = (int)(2000000000000LL / octeon_get_clock_rate());
 
-	if (ata_timing_compute(dev, dev->pio_mode, &timing, T, T))
-		BUG();
+	ata_timing_compute(dev->id, mode, mode, &timing, T, T);
 
 	t1 = timing.setup;
 	if (t1)
Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -252,12 +252,13 @@ static void via_do_set_mode(struct ata_p
 	}
 
 	/* Calculate the timing values we require */
-	ata_timing_compute(adev, mode, &t, T, UT);
+	ata_timing_compute(adev->id, mode, adev->pio_mode, &t, T, UT);
 
 	/* We share 8bit timing so we must merge the constraints */
 	if (peer) {
 		if (peer->pio_mode) {
-			ata_timing_compute(peer, peer->pio_mode, &p, T, UT);
+			ata_timing_compute(peer->id, peer->pio_mode,
+					   peer->pio_mode, &p, T, UT);
 			ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
 		}
 	}
Index: b/include/linux/ata.h
===================================================================
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -1156,4 +1156,47 @@ static inline u8 ata_mwdma_to_pio(u8 mwd
 	return needed_pio[mwdma] - XFER_PIO_0;
 }
 
+enum {
+	/* Timing constants */
+	ATA_TIMING_SETUP	= (1 << 0),
+	ATA_TIMING_ACT8B	= (1 << 1),
+	ATA_TIMING_REC8B	= (1 << 2),
+	ATA_TIMING_CYC8B	= (1 << 3),
+	ATA_TIMING_8BIT		= ATA_TIMING_ACT8B | ATA_TIMING_REC8B |
+				  ATA_TIMING_CYC8B,
+	ATA_TIMING_ACTIVE	= (1 << 4),
+	ATA_TIMING_RECOVER	= (1 << 5),
+	ATA_TIMING_DMACK_HOLD	= (1 << 6),
+	ATA_TIMING_CYCLE	= (1 << 7),
+	ATA_TIMING_UDMA		= (1 << 8),
+	ATA_TIMING_ALL		= ATA_TIMING_SETUP | ATA_TIMING_ACT8B |
+				  ATA_TIMING_REC8B | ATA_TIMING_CYC8B |
+				  ATA_TIMING_ACTIVE | ATA_TIMING_RECOVER |
+				  ATA_TIMING_DMACK_HOLD | ATA_TIMING_CYCLE |
+				  ATA_TIMING_UDMA,
+
+};
+
+struct ata_timing {
+	unsigned short mode;		/* ATA mode */
+	unsigned short setup;		/* t1 */
+	unsigned short act8b;		/* t2 for 8-bit I/O */
+	unsigned short rec8b;		/* t2i for 8-bit I/O */
+	unsigned short cyc8b;		/* t0 for 8-bit I/O */
+	unsigned short active;		/* t2 or tD */
+	unsigned short recover;		/* t2i or tK */
+	unsigned short dmack_hold;	/* tj */
+	unsigned short cycle;		/* t0 */
+	unsigned short udma;		/* t2CYCTYP/2 */
+};
+
+#ifdef CONFIG_ATA_TIMINGS
+extern const struct ata_timing *ata_timing_find_mode(u8 xfer_mode);
+extern int ata_timing_compute(const u16 *, u8, u8,
+			      struct ata_timing *, int, int);
+extern void ata_timing_merge(const struct ata_timing *,
+			     const struct ata_timing *, struct ata_timing *,
+			     unsigned int);
+#endif
+
 #endif /* __LINUX_ATA_H__ */
Index: b/include/linux/libata.h
===================================================================
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -390,24 +390,6 @@ enum {
 	ATAPI_PASS_THRU		= 3,		/* SAT pass-thru */
 	ATAPI_MISC		= 4,		/* the rest */
 
-	/* Timing constants */
-	ATA_TIMING_SETUP	= (1 << 0),
-	ATA_TIMING_ACT8B	= (1 << 1),
-	ATA_TIMING_REC8B	= (1 << 2),
-	ATA_TIMING_CYC8B	= (1 << 3),
-	ATA_TIMING_8BIT		= ATA_TIMING_ACT8B | ATA_TIMING_REC8B |
-				  ATA_TIMING_CYC8B,
-	ATA_TIMING_ACTIVE	= (1 << 4),
-	ATA_TIMING_RECOVER	= (1 << 5),
-	ATA_TIMING_DMACK_HOLD	= (1 << 6),
-	ATA_TIMING_CYCLE	= (1 << 7),
-	ATA_TIMING_UDMA		= (1 << 8),
-	ATA_TIMING_ALL		= ATA_TIMING_SETUP | ATA_TIMING_ACT8B |
-				  ATA_TIMING_REC8B | ATA_TIMING_CYC8B |
-				  ATA_TIMING_ACTIVE | ATA_TIMING_RECOVER |
-				  ATA_TIMING_DMACK_HOLD | ATA_TIMING_CYCLE |
-				  ATA_TIMING_UDMA,
-
 	/* ACPI constants */
 	ATA_ACPI_FILTER_SETXFER	= 1 << 0,
 	ATA_ACPI_FILTER_LOCK	= 1 << 1,
@@ -883,19 +865,6 @@ struct ata_port_info {
 	void 			*private_data;
 };
 
-struct ata_timing {
-	unsigned short mode;		/* ATA mode */
-	unsigned short setup;		/* t1 */
-	unsigned short act8b;		/* t2 for 8-bit I/O */
-	unsigned short rec8b;		/* t2i for 8-bit I/O */
-	unsigned short cyc8b;		/* t0 for 8-bit I/O */
-	unsigned short active;		/* t2 or tD */
-	unsigned short recover;		/* t2i or tK */
-	unsigned short dmack_hold;	/* tj */
-	unsigned short cycle;		/* t0 */
-	unsigned short udma;		/* t2CYCTYP/2 */
-};
-
 /*
  * Core layer - drivers/ata/libata-core.c
  */
@@ -1029,12 +998,6 @@ extern void ata_pio_queue_task(struct at
 
 /* Timing helpers */
 extern unsigned int ata_pio_need_iordy(const struct ata_device *);
-extern const struct ata_timing *ata_timing_find_mode(u8 xfer_mode);
-extern int ata_timing_compute(struct ata_device *, unsigned short,
-			      struct ata_timing *, int, int);
-extern void ata_timing_merge(const struct ata_timing *,
-			     const struct ata_timing *, struct ata_timing *,
-			     unsigned int);
 extern u8 ata_timing_cycle2mode(unsigned int xfer_shift, int cycle);
 
 /* PCI */
