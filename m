Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbZFWGGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbZFWGGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZFWGGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:06:01 -0400
Received: from havoc.gtf.org ([69.61.125.42]:36735 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZFWGF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:05:59 -0400
Date: Tue, 23 Jun 2009 02:06:00 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20090623060600.GA9603@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig       |    8 +
 drivers/ata/Makefile      |    1 +
 drivers/ata/libata-core.c |   25 ++--
 drivers/ata/pata_at91.c   |  361 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/sata_fsl.c    |   35 +++++
 5 files changed, 420 insertions(+), 10 deletions(-)
 create mode 100644 drivers/ata/pata_at91.c

Dave Liu (1):
      sata_fsl: Add power mgmt support

Evgeni Golov (1):
      [libata] beautify module parameters

Sergey Matyukevich (1):
      [libata] PATA driver for CF interface on AT91SAM9260 SoC

Tejun Heo (1):
      libata: don't set IORDY for reset

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 2aa1908..b17c57f 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -679,6 +679,14 @@ config PATA_PLATFORM
 
 	  If unsure, say N.
 
+config PATA_AT91
+	tristate "PATA support for AT91SAM9260"
+	depends on ARM && ARCH_AT91
+	help
+	  This option enables support for IDE devices on the Atmel AT91SAM9260 SoC.
+
+	  If unsure, say N.
+
 config PATA_OF_PLATFORM
 	tristate "OpenFirmware platform device PATA support"
 	depends on PATA_PLATFORM && PPC_OF
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 1558059..38906f9 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_PATA_SCH)		+= pata_sch.o
 obj-$(CONFIG_PATA_BF54X)	+= pata_bf54x.o
 obj-$(CONFIG_PATA_OCTEON_CF)	+= pata_octeon_cf.o
 obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
+obj-$(CONFIG_PATA_AT91)	+= pata_at91.o
 obj-$(CONFIG_PATA_OF_PLATFORM)	+= pata_of_platform.o
 obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
 # Should be last but two libata driver
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ca4d208..045a486 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -125,19 +125,19 @@ MODULE_PARM_DESC(force, "Force ATA configurations including cable type, link spe
 
 static int atapi_enabled = 1;
 module_param(atapi_enabled, int, 0444);
-MODULE_PARM_DESC(atapi_enabled, "Enable discovery of ATAPI devices (0=off, 1=on)");
+MODULE_PARM_DESC(atapi_enabled, "Enable discovery of ATAPI devices (0=off, 1=on [default])");
 
 static int atapi_dmadir = 0;
 module_param(atapi_dmadir, int, 0444);
-MODULE_PARM_DESC(atapi_dmadir, "Enable ATAPI DMADIR bridge support (0=off, 1=on)");
+MODULE_PARM_DESC(atapi_dmadir, "Enable ATAPI DMADIR bridge support (0=off [default], 1=on)");
 
 int atapi_passthru16 = 1;
 module_param(atapi_passthru16, int, 0444);
-MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices; on by default (0=off, 1=on)");
+MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
 
 int libata_fua = 0;
 module_param_named(fua, libata_fua, int, 0444);
-MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on)");
+MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
 
 static int ata_ignore_hpa;
 module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
@@ -153,11 +153,11 @@ MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");
 
 int libata_noacpi = 0;
 module_param_named(noacpi, libata_noacpi, int, 0444);
-MODULE_PARM_DESC(noacpi, "Disables the use of ACPI in probe/suspend/resume when set");
+MODULE_PARM_DESC(noacpi, "Disable the use of ACPI in probe/suspend/resume (0=off [default], 1=on)");
 
 int libata_allow_tpm = 0;
 module_param_named(allow_tpm, libata_allow_tpm, int, 0444);
-MODULE_PARM_DESC(allow_tpm, "Permit the use of TPM commands");
+MODULE_PARM_DESC(allow_tpm, "Permit the use of TPM commands (0=off [default], 1=on)");
 
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Library module for ATA devices");
@@ -1993,11 +1993,17 @@ unsigned int ata_do_simple_cmd(struct ata_device *dev, u8 cmd)
  *	Check if the current speed of the device requires IORDY. Used
  *	by various controllers for chip configuration.
  */
-
 unsigned int ata_pio_need_iordy(const struct ata_device *adev)
 {
-	/* Controller doesn't support  IORDY. Probably a pointless check
-	   as the caller should know this */
+	/* Don't set IORDY if we're preparing for reset.  IORDY may
+	 * lead to controller lock up on certain controllers if the
+	 * port is not occupied.  See bko#11703 for details.
+	 */
+	if (adev->link->ap->pflags & ATA_PFLAG_RESETTING)
+		return 0;
+	/* Controller doesn't support IORDY.  Probably a pointless
+	 * check as the caller should know this.
+	 */
 	if (adev->link->ap->flags & ATA_FLAG_NO_IORDY)
 		return 0;
 	/* CF spec. r4.1 Table 22 says no iordy on PIO5 and PIO6.  */
@@ -2020,7 +2026,6 @@ unsigned int ata_pio_need_iordy(const struct ata_device *adev)
  *	Compute the highest mode possible if we are not using iordy. Return
  *	-1 if no iordy mode is available.
  */
-
 static u32 ata_pio_mask_no_iordy(const struct ata_device *adev)
 {
 	/* If we have no drive specific rule, then PIO 2 is non IORDY */
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
new file mode 100644
index 0000000..4b27617
--- /dev/null
+++ b/drivers/ata/pata_at91.c
@@ -0,0 +1,361 @@
+/*
+ * PATA driver for AT91SAM9260 Static Memory Controller
+ * with CompactFlash interface in True IDE mode
+ *
+ * Copyright (C) 2009 Matyukevich Sergey
+ *
+ * Based on:
+ *      * generic platform driver by Paul Mundt: drivers/ata/pata_platform.c
+ *      * pata_at32 driver by Kristoffer Nyborg Gregertsen
+ *      * at91_ide driver by Stanislaw Gruszka
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <scsi/scsi_host.h>
+#include <linux/ata.h>
+#include <linux/clk.h>
+#include <linux/libata.h>
+#include <linux/platform_device.h>
+#include <linux/ata_platform.h>
+
+#include <mach/at91sam9260_matrix.h>
+#include <mach/at91sam9_smc.h>
+#include <mach/at91sam9260.h>
+#include <mach/board.h>
+#include <mach/gpio.h>
+
+
+#define DRV_NAME "pata_at91"
+#define DRV_VERSION "0.1"
+
+#define CF_IDE_OFFSET	    0x00c00000
+#define CF_ALT_IDE_OFFSET   0x00e00000
+#define CF_IDE_RES_SIZE     0x08
+
+struct at91_ide_info {
+	unsigned long mode;
+	unsigned int cs;
+
+	void __iomem *ide_addr;
+	void __iomem *alt_addr;
+};
+
+const struct ata_timing initial_timing =
+	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
+
+static unsigned int calc_mck_cycles(unsigned int ns, unsigned int mck_hz)
+{
+	unsigned long mul;
+
+    /*
+     * cycles = x [nsec] * f [Hz] / 10^9 [ns in sec] =
+     *     x * (f / 1_000_000_000) =
+     *     x * ((f * 65536) / 1_000_000_000) / 65536 =
+     *     x * (((f / 10_000) * 65536) / 100_000) / 65536 =
+     */
+
+    mul = (mck_hz / 10000) << 16;
+    mul /= 100000;
+
+    return (ns * mul + 65536) >> 16;    /* rounding */
+}
+
+static void set_smc_mode(struct at91_ide_info *info)
+{
+    at91_sys_write(AT91_SMC_MODE(info->cs), info->mode);
+    return;
+}
+
+static void set_smc_timing(struct device *dev,
+		struct at91_ide_info *info, const struct ata_timing *ata)
+{
+	int read_cycle, write_cycle, active, recover;
+	int nrd_setup, nrd_pulse, nrd_recover;
+	int nwe_setup, nwe_pulse;
+
+	int ncs_write_setup, ncs_write_pulse;
+	int ncs_read_setup, ncs_read_pulse;
+
+	unsigned int mck_hz;
+	struct clk *mck;
+
+	read_cycle  = ata->cyc8b;
+	nrd_setup   = ata->setup;
+	nrd_pulse   = ata->act8b;
+	nrd_recover = ata->rec8b;
+
+	mck = clk_get(NULL, "mck");
+	BUG_ON(IS_ERR(mck));
+	mck_hz = clk_get_rate(mck);
+
+	read_cycle  = calc_mck_cycles(read_cycle, mck_hz);
+	nrd_setup   = calc_mck_cycles(nrd_setup, mck_hz);
+	nrd_pulse   = calc_mck_cycles(nrd_pulse, mck_hz);
+	nrd_recover = calc_mck_cycles(nrd_recover, mck_hz);
+
+	clk_put(mck);
+
+	active  = nrd_setup + nrd_pulse;
+	recover = read_cycle - active;
+
+	/* Need at least two cycles recovery */
+	if (recover < 2)
+		read_cycle = active + 2;
+
+	/* (CS0, CS1, DIR, OE) <= (CFCE1, CFCE2, CFRNW, NCSX) timings */
+	ncs_read_setup = 1;
+	ncs_read_pulse = read_cycle - 2;
+
+	/* Write timings same as read timings */
+	write_cycle = read_cycle;
+	nwe_setup = nrd_setup;
+	nwe_pulse = nrd_pulse;
+	ncs_write_setup = ncs_read_setup;
+	ncs_write_pulse = ncs_read_pulse;
+
+	dev_dbg(dev, "ATA timings: nrd_setup = %d nrd_pulse = %d nrd_cycle = %d\n",
+			nrd_setup, nrd_pulse, read_cycle);
+	dev_dbg(dev, "ATA timings: nwe_setup = %d nwe_pulse = %d nwe_cycle = %d\n",
+			nwe_setup, nwe_pulse, write_cycle);
+	dev_dbg(dev, "ATA timings: ncs_read_setup = %d ncs_read_pulse = %d\n",
+			ncs_read_setup, ncs_read_pulse);
+	dev_dbg(dev, "ATA timings: ncs_write_setup = %d ncs_write_pulse = %d\n",
+			ncs_write_setup, ncs_write_pulse);
+
+	at91_sys_write(AT91_SMC_SETUP(info->cs),
+			AT91_SMC_NWESETUP_(nwe_setup) |
+			AT91_SMC_NRDSETUP_(nrd_setup) |
+			AT91_SMC_NCS_WRSETUP_(ncs_write_setup) |
+			AT91_SMC_NCS_RDSETUP_(ncs_read_setup));
+
+	at91_sys_write(AT91_SMC_PULSE(info->cs),
+			AT91_SMC_NWEPULSE_(nwe_pulse) |
+			AT91_SMC_NRDPULSE_(nrd_pulse) |
+			AT91_SMC_NCS_WRPULSE_(ncs_write_pulse) |
+			AT91_SMC_NCS_RDPULSE_(ncs_read_pulse));
+
+	at91_sys_write(AT91_SMC_CYCLE(info->cs),
+			AT91_SMC_NWECYCLE_(write_cycle) |
+			AT91_SMC_NRDCYCLE_(read_cycle));
+
+	return;
+}
+
+static void pata_at91_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct at91_ide_info *info = ap->host->private_data;
+	struct ata_timing timing;
+	int ret;
+
+	/* Compute ATA timing and set it to SMC */
+	ret = ata_timing_compute(adev, adev->pio_mode, &timing, 1000, 0);
+	if (ret) {
+		dev_warn(ap->dev, "Failed to compute ATA timing %d, \
+				set PIO_0 timing\n", ret);
+		set_smc_timing(ap->dev, info, &initial_timing);
+	} else {
+		set_smc_timing(ap->dev, info, &timing);
+	}
+
+	/* Setup SMC mode */
+	set_smc_mode(info);
+
+	return;
+}
+
+static unsigned int pata_at91_data_xfer_noirq(struct ata_device *dev,
+		unsigned char *buf, unsigned int buflen, int rw)
+{
+	struct at91_ide_info *info = dev->link->ap->host->private_data;
+	unsigned int consumed;
+	unsigned long flags;
+	unsigned int mode;
+
+	local_irq_save(flags);
+	mode = at91_sys_read(AT91_SMC_MODE(info->cs));
+
+	/* set 16bit mode before writing data */
+	at91_sys_write(AT91_SMC_MODE(info->cs),
+			(mode & ~AT91_SMC_DBW) | AT91_SMC_DBW_16);
+
+	consumed = ata_sff_data_xfer(dev, buf, buflen, rw);
+
+	/* restore 8bit mode after data is written */
+	at91_sys_write(AT91_SMC_MODE(info->cs),
+			(mode & ~AT91_SMC_DBW) | AT91_SMC_DBW_8);
+
+	local_irq_restore(flags);
+	return consumed;
+}
+
+static struct scsi_host_template pata_at91_sht = {
+	ATA_PIO_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations pata_at91_port_ops = {
+	.inherits	= &ata_sff_port_ops,
+
+	.sff_data_xfer	= pata_at91_data_xfer_noirq,
+	.set_piomode	= pata_at91_set_piomode,
+	.cable_detect	= ata_cable_40wire,
+	.port_start	= ATA_OP_NULL,
+};
+
+static int __devinit pata_at91_probe(struct platform_device *pdev)
+{
+	struct at91_cf_data *board = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct at91_ide_info *info;
+	struct resource *mem_res;
+	struct ata_host *host;
+	struct ata_port *ap;
+	int irq_flags = 0;
+	int irq = 0;
+	int ret;
+
+	/*  get platform resources: IO/CTL memories and irq/rst pins */
+
+	if (pdev->num_resources != 1) {
+		dev_err(&pdev->dev, "invalid number of resources\n");
+		return -EINVAL;
+	}
+
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!mem_res) {
+		dev_err(dev, "failed to get mem resource\n");
+		return -EINVAL;
+	}
+
+	irq = board->irq_pin;
+
+	/* init ata host */
+
+	host = ata_host_alloc(dev, 1);
+
+	if (!host)
+		return -ENOMEM;
+
+	ap = host->ports[0];
+	ap->ops = &pata_at91_port_ops;
+	ap->flags |= ATA_FLAG_SLAVE_POSS;
+	ap->pio_mask = ATA_PIO4;
+
+	if (!irq) {
+		ap->flags |= ATA_FLAG_PIO_POLLING;
+		ata_port_desc(ap, "no IRQ, using PIO polling");
+	}
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+
+	if (!info) {
+		dev_err(dev, "failed to allocate memory for private data\n");
+		return -ENOMEM;
+	}
+
+	info->cs    = board->chipselect;
+	info->mode  = AT91_SMC_READMODE | AT91_SMC_WRITEMODE |
+		AT91_SMC_EXNWMODE_READY | AT91_SMC_BAT_SELECT |
+		AT91_SMC_DBW_8 | AT91_SMC_TDF_(0);
+
+	info->ide_addr = devm_ioremap(dev,
+			mem_res->start + CF_IDE_OFFSET, CF_IDE_RES_SIZE);
+
+	if (!info->ide_addr) {
+		dev_err(dev, "failed to map IO base\n");
+		ret = -ENOMEM;
+		goto err_ide_ioremap;
+	}
+
+	info->alt_addr = devm_ioremap(dev,
+			mem_res->start + CF_ALT_IDE_OFFSET, CF_IDE_RES_SIZE);
+
+	if (!info->alt_addr) {
+		dev_err(dev, "failed to map CTL base\n");
+		ret = -ENOMEM;
+		goto err_alt_ioremap;
+	}
+
+	ap->ioaddr.cmd_addr = info->ide_addr;
+	ap->ioaddr.ctl_addr = info->alt_addr + 0x06;
+	ap->ioaddr.altstatus_addr = ap->ioaddr.ctl_addr;
+
+	ata_sff_std_ports(&ap->ioaddr);
+
+	ata_port_desc(ap, "mmio cmd 0x%llx ctl 0x%llx",
+			(unsigned long long)mem_res->start + CF_IDE_OFFSET,
+			(unsigned long long)mem_res->start + CF_ALT_IDE_OFFSET);
+
+	host->private_data = info;
+
+	return ata_host_activate(host, irq ? gpio_to_irq(irq) : 0,
+			irq ? ata_sff_interrupt : NULL,
+			irq_flags, &pata_at91_sht);
+
+err_alt_ioremap:
+	devm_iounmap(dev, info->ide_addr);
+
+err_ide_ioremap:
+	kfree(info);
+
+	return ret;
+}
+
+static int __devexit pata_at91_remove(struct platform_device *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct at91_ide_info *info = host->private_data;
+	struct device *dev = &pdev->dev;
+
+	if (!host)
+		return 0;
+
+	ata_host_detach(host);
+
+	if (!info)
+		return 0;
+
+	devm_iounmap(dev, info->ide_addr);
+	devm_iounmap(dev, info->alt_addr);
+
+	kfree(info);
+	return 0;
+}
+
+static struct platform_driver pata_at91_driver = {
+	.probe		= pata_at91_probe,
+	.remove		= __devexit_p(pata_at91_remove),
+	.driver 	= {
+		.name		= DRV_NAME,
+		.owner		= THIS_MODULE,
+	},
+};
+
+static int __init pata_at91_init(void)
+{
+	return platform_driver_register(&pata_at91_driver);
+}
+
+static void __exit pata_at91_exit(void)
+{
+	platform_driver_unregister(&pata_at91_driver);
+}
+
+
+module_init(pata_at91_init);
+module_exit(pata_at91_exit);
+
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Driver for CF in True IDE mode on AT91SAM9260 SoC");
+MODULE_AUTHOR("Matyukevich Sergey");
+MODULE_VERSION(DRV_VERSION);
+
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 36b8629..94eaa43 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1378,6 +1378,37 @@ static int sata_fsl_remove(struct of_device *ofdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int sata_fsl_suspend(struct of_device *op, pm_message_t state)
+{
+	struct ata_host *host = dev_get_drvdata(&op->dev);
+	return ata_host_suspend(host, state);
+}
+
+static int sata_fsl_resume(struct of_device *op)
+{
+	struct ata_host *host = dev_get_drvdata(&op->dev);
+	struct sata_fsl_host_priv *host_priv = host->private_data;
+	int ret;
+	void __iomem *hcr_base = host_priv->hcr_base;
+	struct ata_port *ap = host->ports[0];
+	struct sata_fsl_port_priv *pp = ap->private_data;
+
+	ret = sata_fsl_init_controller(host);
+	if (ret) {
+		dev_printk(KERN_ERR, &op->dev,
+			"Error initialize hardware\n");
+		return ret;
+	}
+
+	/* Recovery the CHBA register in host controller cmd register set */
+	iowrite32(pp->cmdslot_paddr & 0xffffffff, hcr_base + CHBA);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static struct of_device_id fsl_sata_match[] = {
 	{
 		.compatible = "fsl,pq-sata",
@@ -1392,6 +1423,10 @@ static struct of_platform_driver fsl_sata_driver = {
 	.match_table	= fsl_sata_match,
 	.probe		= sata_fsl_probe,
 	.remove		= sata_fsl_remove,
+#ifdef CONFIG_PM
+	.suspend	= sata_fsl_suspend,
+	.resume		= sata_fsl_resume,
+#endif
 };
 
 static int __init sata_fsl_init(void)
