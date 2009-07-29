Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZG2CCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZG2CCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZG2CCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:02:15 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58351 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZG2CCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:02:13 -0400
Date: Tue, 28 Jul 2009 22:02:12 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090729020212.GA14503@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A bunch of one-liners, except for an embedded driver update (pata_at91)
and Tejun's HPA unlocking fix.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c           |    4 ++
 drivers/ata/ata_piix.c       |    3 ++
 drivers/ata/libata-core.c    |   30 ++++++++++++++----
 drivers/ata/libata-eh.c      |    2 +-
 drivers/ata/pata_at91.c      |   67 ++++++++++++++++++++++-------------------
 drivers/ata/pata_octeon_cf.c |    3 +-
 drivers/ata/pata_pcmcia.c    |    1 +
 drivers/ata/sata_mv.c        |    2 +-
 drivers/ata/sata_sil.c       |    2 +-
 include/linux/libata.h       |    1 +
 10 files changed, 73 insertions(+), 42 deletions(-)

Bartlomiej Zolnierkiewicz (2):
      libata: add missing NULL pointer check to ata_eh_reset()
      libata: remove superfluous NULL pointer checks

David Milburn (1):
      ahci: add device IDs for Ibex Peak ahci controllers

Sergey Matyukevich (1):
      libata: Updates and fixes for pata_at91 driver

Steve Conklin (2):
      ata_piix: Add new laptop short cable IDs
      ata_piix: Add new short cable ID

Tejun Heo (1):
      libata: accept late unlocking of HPA

Wolfram Sang (1):
      pata_pcmcia: add CNF-CDROM-ID

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 336eb1e..958c1fa 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -515,10 +515,14 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3a22), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3b22), board_ahci }, /* PCH AHCI */
+	{ PCI_VDEVICE(INTEL, 0x3b23), board_ahci }, /* PCH AHCI */
 	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b25), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b29), board_ahci }, /* PCH AHCI */
 	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b2f), board_ahci }, /* PCH AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index d0a14cf..56b8a3f 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -596,9 +596,12 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
 	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
+	{ 0x27DF, 0x1028, 0x02b0 },	/* ICH7 on unknown Dell */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
+	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unkown HP  */
 	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
+	{ 0x27DF, 0x152D, 0x0778 },	/* ICH7 on unknown Intel */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
 	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
 	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2c6aeda..8ac98ff 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1515,6 +1515,7 @@ static int ata_hpa_resize(struct ata_device *dev)
 
 		return rc;
 	}
+	dev->n_native_sectors = native_sectors;
 
 	/* nothing to do? */
 	if (native_sectors <= sectors || !ata_ignore_hpa) {
@@ -4099,6 +4100,7 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 		       unsigned int readid_flags)
 {
 	u64 n_sectors = dev->n_sectors;
+	u64 n_native_sectors = dev->n_native_sectors;
 	int rc;
 
 	if (!ata_dev_enabled(dev))
@@ -4128,16 +4130,30 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	/* verify n_sectors hasn't changed */
 	if (dev->class == ATA_DEV_ATA && n_sectors &&
 	    dev->n_sectors != n_sectors) {
-		ata_dev_printk(dev, KERN_INFO, "n_sectors mismatch "
+		ata_dev_printk(dev, KERN_WARNING, "n_sectors mismatch "
 			       "%llu != %llu\n",
 			       (unsigned long long)n_sectors,
 			       (unsigned long long)dev->n_sectors);
-
-		/* restore original n_sectors */
-		dev->n_sectors = n_sectors;
-
-		rc = -ENODEV;
-		goto fail;
+		/*
+		 * Something could have caused HPA to be unlocked
+		 * involuntarily.  If n_native_sectors hasn't changed
+		 * and the new size matches it, keep the device.
+		 */
+		if (dev->n_native_sectors == n_native_sectors &&
+		    dev->n_sectors > n_sectors &&
+		    dev->n_sectors == n_native_sectors) {
+			ata_dev_printk(dev, KERN_WARNING,
+				       "new n_sectors matches native, probably "
+				       "late HPA unlock, continuing\n");
+			/* keep using the old n_sectors */
+			dev->n_sectors = n_sectors;
+		} else {
+			/* restore original n_[native]_sectors and fail */
+			dev->n_native_sectors = n_native_sectors;
+			dev->n_sectors = n_sectors;
+			rc = -ENODEV;
+			goto fail;
+		}
 	}
 
 	return 0;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 1a07c06..79711b6 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2327,7 +2327,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	struct ata_port *ap = link->ap;
 	struct ata_link *slave = ap->slave_link;
 	struct ata_eh_context *ehc = &link->eh_context;
-	struct ata_eh_context *sehc = &slave->eh_context;
+	struct ata_eh_context *sehc = slave ? &slave->eh_context : NULL;
 	unsigned int *classes = ehc->classes;
 	unsigned int lflags = link->flags;
 	int verbose = !(ehc->i.flags & ATA_EHI_QUIET);
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 8561a9f..5702aff 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -26,9 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/ata_platform.h>
 
-#include <mach/at91sam9260_matrix.h>
 #include <mach/at91sam9_smc.h>
-#include <mach/at91sam9260.h>
 #include <mach/board.h>
 #include <mach/gpio.h>
 
@@ -44,65 +42,62 @@ struct at91_ide_info {
 	unsigned long mode;
 	unsigned int cs;
 
+	struct clk *mck;
+
 	void __iomem *ide_addr;
 	void __iomem *alt_addr;
 };
 
-const struct ata_timing initial_timing =
+static const struct ata_timing initial_timing =
 	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
 
-static unsigned int calc_mck_cycles(unsigned int ns, unsigned int mck_hz)
+static unsigned long calc_mck_cycles(unsigned long ns, unsigned long mck_hz)
 {
 	unsigned long mul;
 
-    /*
-     * cycles = x [nsec] * f [Hz] / 10^9 [ns in sec] =
-     *     x * (f / 1_000_000_000) =
-     *     x * ((f * 65536) / 1_000_000_000) / 65536 =
-     *     x * (((f / 10_000) * 65536) / 100_000) / 65536 =
-     */
+	/*
+	* cycles = x [nsec] * f [Hz] / 10^9 [ns in sec] =
+	*     x * (f / 1_000_000_000) =
+	*     x * ((f * 65536) / 1_000_000_000) / 65536 =
+	*     x * (((f / 10_000) * 65536) / 100_000) / 65536 =
+	*/
 
-    mul = (mck_hz / 10000) << 16;
-    mul /= 100000;
+	mul = (mck_hz / 10000) << 16;
+	mul /= 100000;
 
-    return (ns * mul + 65536) >> 16;    /* rounding */
+	return (ns * mul + 65536) >> 16;    /* rounding */
 }
 
 static void set_smc_mode(struct at91_ide_info *info)
 {
-    at91_sys_write(AT91_SMC_MODE(info->cs), info->mode);
-    return;
+	at91_sys_write(AT91_SMC_MODE(info->cs), info->mode);
+	return;
 }
 
 static void set_smc_timing(struct device *dev,
 		struct at91_ide_info *info, const struct ata_timing *ata)
 {
-	int read_cycle, write_cycle, active, recover;
-	int nrd_setup, nrd_pulse, nrd_recover;
-	int nwe_setup, nwe_pulse;
+	unsigned long read_cycle, write_cycle, active, recover;
+	unsigned long nrd_setup, nrd_pulse, nrd_recover;
+	unsigned long nwe_setup, nwe_pulse;
 
-	int ncs_write_setup, ncs_write_pulse;
-	int ncs_read_setup, ncs_read_pulse;
+	unsigned long ncs_write_setup, ncs_write_pulse;
+	unsigned long ncs_read_setup, ncs_read_pulse;
 
-	unsigned int mck_hz;
-	struct clk *mck;
+	unsigned long mck_hz;
 
 	read_cycle  = ata->cyc8b;
 	nrd_setup   = ata->setup;
 	nrd_pulse   = ata->act8b;
 	nrd_recover = ata->rec8b;
 
-	mck = clk_get(NULL, "mck");
-	BUG_ON(IS_ERR(mck));
-	mck_hz = clk_get_rate(mck);
+	mck_hz = clk_get_rate(info->mck);
 
 	read_cycle  = calc_mck_cycles(read_cycle, mck_hz);
 	nrd_setup   = calc_mck_cycles(nrd_setup, mck_hz);
 	nrd_pulse   = calc_mck_cycles(nrd_pulse, mck_hz);
 	nrd_recover = calc_mck_cycles(nrd_recover, mck_hz);
 
-	clk_put(mck);
-
 	active  = nrd_setup + nrd_pulse;
 	recover = read_cycle - active;
 
@@ -121,13 +116,13 @@ static void set_smc_timing(struct device *dev,
 	ncs_write_setup = ncs_read_setup;
 	ncs_write_pulse = ncs_read_pulse;
 
-	dev_dbg(dev, "ATA timings: nrd_setup = %d nrd_pulse = %d nrd_cycle = %d\n",
+	dev_dbg(dev, "ATA timings: nrd_setup = %lu nrd_pulse = %lu nrd_cycle = %lu\n",
 			nrd_setup, nrd_pulse, read_cycle);
-	dev_dbg(dev, "ATA timings: nwe_setup = %d nwe_pulse = %d nwe_cycle = %d\n",
+	dev_dbg(dev, "ATA timings: nwe_setup = %lu nwe_pulse = %lu nwe_cycle = %lu\n",
 			nwe_setup, nwe_pulse, write_cycle);
-	dev_dbg(dev, "ATA timings: ncs_read_setup = %d ncs_read_pulse = %d\n",
+	dev_dbg(dev, "ATA timings: ncs_read_setup = %lu ncs_read_pulse = %lu\n",
 			ncs_read_setup, ncs_read_pulse);
-	dev_dbg(dev, "ATA timings: ncs_write_setup = %d ncs_write_pulse = %d\n",
+	dev_dbg(dev, "ATA timings: ncs_write_setup = %lu ncs_write_pulse = %lu\n",
 			ncs_write_setup, ncs_write_pulse);
 
 	at91_sys_write(AT91_SMC_SETUP(info->cs),
@@ -217,6 +212,7 @@ static int __devinit pata_at91_probe(struct platform_device *pdev)
 	struct resource *mem_res;
 	struct ata_host *host;
 	struct ata_port *ap;
+
 	int irq_flags = 0;
 	int irq = 0;
 	int ret;
@@ -261,6 +257,13 @@ static int __devinit pata_at91_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	info->mck = clk_get(NULL, "mck");
+
+	if (IS_ERR(info->mck)) {
+		dev_err(dev, "failed to get access to mck clock\n");
+		return -ENODEV;
+	}
+
 	info->cs    = board->chipselect;
 	info->mode  = AT91_SMC_READMODE | AT91_SMC_WRITEMODE |
 		AT91_SMC_EXNWMODE_READY | AT91_SMC_BAT_SELECT |
@@ -304,6 +307,7 @@ err_alt_ioremap:
 	devm_iounmap(dev, info->ide_addr);
 
 err_ide_ioremap:
+	clk_put(info->mck);
 	kfree(info);
 
 	return ret;
@@ -326,6 +330,7 @@ static int __devexit pata_at91_remove(struct platform_device *pdev)
 
 	devm_iounmap(dev, info->ide_addr);
 	devm_iounmap(dev, info->alt_addr);
+	clk_put(info->mck);
 
 	kfree(info);
 	return 0;
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 8d9343a..abdd19f 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -653,7 +653,8 @@ static irqreturn_t octeon_cf_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		ocd = ap->dev->platform_data;
-		if (!ap || (ap->flags & ATA_FLAG_DISABLED))
+
+		if (ap->flags & ATA_FLAG_DISABLED)
 			continue;
 
 		ocd = ap->dev->platform_data;
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index f4d009e..dc99e26 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -411,6 +411,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID123("PCMCIA", "IDE CARD", "F1", 0x281f1c5d, 0x1907960c, 0xf7fde8b9),
 	PCMCIA_DEVICE_PROD_ID12("ARGOSY", "CD-ROM", 0x78f308dc, 0x66536591),
 	PCMCIA_DEVICE_PROD_ID12("ARGOSY", "PnPIDE", 0x78f308dc, 0x0c694728),
+	PCMCIA_DEVICE_PROD_ID12("CNF   ", "CD-ROM", 0x46d7db81, 0x66536591),
 	PCMCIA_DEVICE_PROD_ID12("CNF CD-M", "CD-ROM", 0x7d93b852, 0x66536591),
 	PCMCIA_DEVICE_PROD_ID12("Creative Technology Ltd.", "PCMCIA CD-ROM Interface Card", 0xff8c8a45, 0xfe8020c4),
 	PCMCIA_DEVICE_PROD_ID12("Digital Equipment Corporation.", "Digital Mobile Media CD-ROM", 0x17692a66, 0xef1dcbde),
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 23714ae..c19417e 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2514,7 +2514,7 @@ static void mv_unexpected_intr(struct ata_port *ap, int edma_was_enabled)
 	char *when = "idle";
 
 	ata_ehi_clear_desc(ehi);
-	if (!ap || (ap->flags & ATA_FLAG_DISABLED)) {
+	if (ap->flags & ATA_FLAG_DISABLED) {
 		when = "disabled";
 	} else if (edma_was_enabled) {
 		when = "EDMA enabled";
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 030ec07..35bd5cc 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -532,7 +532,7 @@ static irqreturn_t sil_interrupt(int irq, void *dev_instance)
 		struct ata_port *ap = host->ports[i];
 		u32 bmdma2 = readl(mmio_base + sil_port[ap->port_no].bmdma2);
 
-		if (unlikely(!ap || ap->flags & ATA_FLAG_DISABLED))
+		if (unlikely(ap->flags & ATA_FLAG_DISABLED))
 			continue;
 
 		/* turn off SATA_IRQ if not supported */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 79b6d7f..e5b6e33 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -589,6 +589,7 @@ struct ata_device {
 #endif
 	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
 	u64			n_sectors;	/* size of device, if ATA */
+	u64			n_native_sectors; /* native size, if ATA */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	unsigned long		unpark_deadline;
 
