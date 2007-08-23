Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbXHWKIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbXHWKIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbXHWKIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:08:40 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39591 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbXHWKIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:08:39 -0400
Date: Thu, 23 Aug 2007 06:08:33 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070823100833.GA24725@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes + more laptop IDs

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c   |    7 ++++++-
 drivers/ata/pata_pdc2027x.c |   18 +++++++++---------
 drivers/ata/pata_sis.c      |    1 +
 drivers/ata/pata_via.c      |    5 ++++-
 4 files changed, 20 insertions(+), 11 deletions(-)

Alan Cox (2):
      pata_sis: Add the FSC Amilo and friends
      pata_via: Add Arima W730-K8 and other rebadgings

Mikael Pettersson (1):
      pata_pdc2027x: PLL detection fixes

Tejun Heo (2):
      libata: fix n_sectors failure handling during revalidation
      libata: don't check n_sectors during revalidation if zero

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 99d4fbf..2ad4dda 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3700,11 +3700,16 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int readid_flags)
 		goto fail;
 
 	/* verify n_sectors hasn't changed */
-	if (dev->class == ATA_DEV_ATA && dev->n_sectors != n_sectors) {
+	if (dev->class == ATA_DEV_ATA && n_sectors &&
+	    dev->n_sectors != n_sectors) {
 		ata_dev_printk(dev, KERN_INFO, "n_sectors mismatch "
 			       "%llu != %llu\n",
 			       (unsigned long long)n_sectors,
 			       (unsigned long long)dev->n_sectors);
+
+		/* restore original n_sectors */
+		dev->n_sectors = n_sectors;
+
 		rc = -ENODEV;
 		goto fail;
 	}
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 69a5aa4..e3245b3 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -563,13 +563,13 @@ static long pdc_read_counter(struct ata_host *host)
 	u32 bccrl, bccrh, bccrlv, bccrhv;
 
 retry:
-	bccrl = readl(mmio_base + PDC_BYTE_COUNT) & 0xffff;
-	bccrh = readl(mmio_base + PDC_BYTE_COUNT + 0x100) & 0xffff;
+	bccrl = readl(mmio_base + PDC_BYTE_COUNT) & 0x7fff;
+	bccrh = readl(mmio_base + PDC_BYTE_COUNT + 0x100) & 0x7fff;
 	rmb();
 
 	/* Read the counter values again for verification */
-	bccrlv = readl(mmio_base + PDC_BYTE_COUNT) & 0xffff;
-	bccrhv = readl(mmio_base + PDC_BYTE_COUNT + 0x100) & 0xffff;
+	bccrlv = readl(mmio_base + PDC_BYTE_COUNT) & 0x7fff;
+	bccrhv = readl(mmio_base + PDC_BYTE_COUNT + 0x100) & 0x7fff;
 	rmb();
 
 	counter = (bccrh << 15) | bccrl;
@@ -692,16 +692,16 @@ static long pdc_detect_pll_input_clock(struct ata_host *host)
 	struct timeval start_time, end_time;
 	long pll_clock, usec_elapsed;
 
-	/* Read current counter value */
-	start_count = pdc_read_counter(host);
-	do_gettimeofday(&start_time);
-
 	/* Start the test mode */
 	scr = readl(mmio_base + PDC_SYS_CTL);
 	PDPRINTK("scr[%X]\n", scr);
 	writel(scr | (0x01 << 14), mmio_base + PDC_SYS_CTL);
 	readl(mmio_base + PDC_SYS_CTL); /* flush */
 
+	/* Read current counter value */
+	start_count = pdc_read_counter(host);
+	do_gettimeofday(&start_time);
+
 	/* Let the counter run for 100 ms. */
 	mdelay(100);
 
@@ -719,7 +719,7 @@ static long pdc_detect_pll_input_clock(struct ata_host *host)
 	usec_elapsed = (end_time.tv_sec - start_time.tv_sec) * 1000000 +
 		(end_time.tv_usec - start_time.tv_usec);
 
-	pll_clock = (start_count - end_count) / 100 *
+	pll_clock = ((start_count - end_count) & 0x3fffffff) / 100 *
 		(100000000 / usec_elapsed);
 
 	PDPRINTK("start[%ld] end[%ld] \n", start_count, end_count);
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 66bd0e8..2bd7645 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -54,6 +54,7 @@ struct sis_laptop {
 static const struct sis_laptop sis_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
+	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
 	/* end marker */
 	{ 0, }
 };
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index f645fe2..ea18e33 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -63,7 +63,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME "pata_via"
-#define DRV_VERSION "0.3.1"
+#define DRV_VERSION "0.3.2"
 
 /*
  *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
@@ -144,6 +144,9 @@ static int via_cable_override(struct pci_dev *pdev)
 	/* Systems by DMI */
 	if (dmi_check_system(cable_dmi_table))
 		return 1;
+	/* Arima W730-K8/Targa Visionary 811/... */
+	if (pdev->subsystem_vendor == 0x161F && pdev->subsystem_device == 0x2032)
+		return 1;
 	return 0;
 }
 
