Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbZKZPxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbZKZPxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 10:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZKZPx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 10:53:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47736 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbZKZPx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 10:53:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=MZL2Un/S3xc8xyJbDk9j9XEvWv2fg3nqCXM9fmw1y4HWEMyjfWYGdagu88hTysSpVk
         RJGXcywvkKdrVfIAQuNLx7hC6lxPjBz3+CkIQbaisnHwehdBWsXBQh7Y9bcSZOFL95o8
         0HlFPQu0aPYA9dc+mWJ643rvHajbjDNTrqiLA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] add PATA host controller support for Cirrus Logic's EP93xx CPUs
Date: Thu, 26 Nov 2009 16:51:40 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.montavista.com>,
       Joao Ramos <joao.ramos@inov.pt>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Ryan Mallon <ryan@bluewatersys.com>
MIME-Version: 1.0
Message-Id: <200911261651.40928.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Based on the older IDE host driver by Joao Ramos and review comments
for it from Sergei Shtylyov.  Not yet tested with the real hardware.

Cc: Joao Ramos <joao.ramos@inov.pt>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>
Cc: Sergei Shtylyov <sshtylyov@ru.montavista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Depends on "libata: add private driver field to struct ata_device" patch:

    http://patchwork.kernel.org/patch/62926/

and also needs "ep93xx: enable/disable gpio pins for ide" one from:

    http://thread.gmane.org/gmane.linux.ports.arm.kernel/57688/focus=58730

( Could somebody please tell me if it has been merged already and/or
  where one can find the version which applies to more recent kernels? )

Additionally arch/arm specific parts should probably be split from this
patch before the final merge.


Sidenote:

I have neither the hardware nor much personal interest in adding support
for it so I did it mainly cause:

- IDE host driver wasn't merged due to policy change and I hate seeing fair
  amount of review work from me & Sergei going into waste. :)

- I was curious about some claims I've been hearing recently so I decided to
  verify them in practice (porting the driver to libata was relatively easy
  but unfortunately in the process it gained almost 50% in the LOC count..).

so if somebody would like to take over this patch feel free to do it.

 arch/arm/mach-ep93xx/core.c                     |   25 
 arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h |    1 
 arch/arm/mach-ep93xx/include/mach/platform.h    |    1 
 drivers/ata/Kconfig                             |   13 
 drivers/ata/Makefile                            |    1 
 drivers/ata/pata_ep93xx.c                       |  765 ++++++++++++++++++++++++
 6 files changed, 806 insertions(+)

Index: b/arch/arm/mach-ep93xx/core.c
===================================================================
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -714,6 +714,31 @@ void __init ep93xx_register_fb(struct ep
 	platform_device_register(&ep93xx_fb_device);
 }
 
+static struct resource ep93xx_ide_resources[] = {
+	{
+		.start	= EP93XX_IDE_PHYS_BASE,
+		.end	= EP93XX_IDE_PHYS_BASE + 0x37,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= IRQ_EP93XX_EXT3,
+		.end	= IRQ_EP93XX_EXT3,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device ep93xx_ide_device = {
+	.name		= "ep93xx-ide",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(ep93xx_ide_resources),
+	.resource	= ep93xx_ide_resources,
+};
+
+void __init ep93xx_register_ide(void)
+{
+	platform_device_register(&ep93xx_ide_device);
+}
+
 extern void ep93xx_gpio_init(void);
 
 void __init ep93xx_init_devices(void)
Index: b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
===================================================================
--- a/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
+++ b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
@@ -82,6 +82,7 @@
 #define EP93XX_BOOT_ROM_BASE		EP93XX_AHB_IOMEM(0x00090000)
 
 #define EP93XX_IDE_BASE			EP93XX_AHB_IOMEM(0x000a0000)
+#define EP93XX_IDE_PHYS_BASE		(EP93XX_AHB_PHYS_BASE + 0x000a0000)
 
 #define EP93XX_VIC1_BASE		EP93XX_AHB_IOMEM(0x000b0000)
 
Index: b/arch/arm/mach-ep93xx/include/mach/platform.h
===================================================================
--- a/arch/arm/mach-ep93xx/include/mach/platform.h
+++ b/arch/arm/mach-ep93xx/include/mach/platform.h
@@ -32,6 +32,7 @@ static inline void ep93xx_devcfg_clear_b
 	ep93xx_devcfg_set_clear(0x00, bits);
 }
 
+void ep93xx_register_ide(void);
 void ep93xx_register_eth(struct ep93xx_eth_data *data, int copy_addr);
 void ep93xx_register_i2c(struct i2c_board_info *devices, int num);
 void ep93xx_register_fb(struct ep93xxfb_mach_info *data);
Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -739,6 +739,19 @@ config PATA_OF_PLATFORM
 
 	  If unsure, say N.
 
+config PATA_EP93XX
+	tristate "Cirrus Logic EPxx (EP9312, EP9315) PATA support (Experimental)"
+	depends on ARM && ARCH_EP93XXA && EXPERIMENTAL
+	help
+	  This is a host controller driver for PATA hardware included in
+	  Cirrus Logic's EP9312 and EP9315 CPUs.
+
+	  Say Y here if you want to enable the PATA host controller support
+	  for your machine.
+
+	  Choose 'M' to compile this driver as a module; the module will be
+	  called 'pata_ep93xx'.
+
 config PATA_ICSIDE
 	tristate "Acorn ICS PATA support"
 	depends on ARM && ARCH_ACORN
Index: b/drivers/ata/Makefile
===================================================================
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_PATA_OCTEON_CF)	+= pata_oct
 obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
 obj-$(CONFIG_PATA_AT91)	+= pata_at91.o
 obj-$(CONFIG_PATA_OF_PLATFORM)	+= pata_of_platform.o
+obj-$(CONFIG_PATA_EP93XX)	+= pata_ep93xx.o
 obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
 # Should be last but two libata driver
 obj-$(CONFIG_PATA_ACPI)		+= pata_acpi.o
Index: b/drivers/ata/pata_ep93xx.c
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_ep93xx.c
@@ -0,0 +1,765 @@
+/*
+ * Support for Cirrus Logic's EP93xx (EP9312, EP9315) CPUs
+ * PATA host controller driver.
+ *
+ * Copyright (c) 2009, Bartlomiej Zolnierkiewicz
+ *
+ * Heavily based on the ep93xx-ide.c driver:
+ *
+ * Copyright (c) 2009, Joao Ramos <joao.ramos@inov.pt>
+ *		       INESC Inovacao (INOV)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * TODO:
+ * - PIO setup needs to be verified with the documentation
+ * - MWDMA and UDMA support
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/ioport.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/libata.h>
+#include <linux/delay.h>
+
+#define	DRV_NAME	"pata_ep93xx"
+
+/*
+ * Configuration and usage of the IDE device is made through the
+ * IDE Interface Register Map (EP93xx User's Guide, Section 27).
+ *
+ * This section holds common registers and flag definitions for
+ * that interface.
+ */
+
+enum {
+	/*
+	 * IDE Register offset
+	 */
+	IDECTRL			= 0x00,
+	IDECFG			= 0x04,
+	IDEMDMAOP		= 0x08,
+	IDEUDMAOP		= 0x0C,
+	IDEDATAOUT		= 0x10,
+	IDEDATAIN		= 0x14,
+	IDEMDMADATAOUT		= 0x18,
+	IDEMDMADATAIN		= 0x1C,
+	IDEUDMADATAOUT		= 0x20,
+	IDEUDMADATAIN		= 0x24,
+	IDEUDMASTS		= 0x28,
+	IDEUDMADEBUG		= 0x2C,
+	IDEUDMAWRBUFSTS		= 0x30,
+	IDEUDMARDBUFSTS		= 0x34,
+
+	/*
+	 * IDE Control Register bit fields
+	 */
+	IDECTRL_CS0N		= 0x00000001,
+	IDECTRL_CS1N		= 0x00000002,
+	IDECTRL_DA		= 0x0000001C,
+	IDECTRL_DIORN		= 0x00000020,
+	IDECTRL_DIOWN		= 0x00000040,
+	IDECTRL_DASPN		= 0x00000080,
+	IDECTRL_DMARQ		= 0x00000100,
+	IDECTRL_INTRQ		= 0x00000200,
+	IDECTRL_IORDY		= 0x00000400,
+
+	/*
+	 * IDE Configuration Register bit fields
+	 */
+	IDECFG_IDEEN		= 0x00000001,
+	IDECFG_PIO		= 0x00000002,
+	IDECFG_MDMA		= 0x00000004,
+	IDECFG_UDMA		= 0x00000008,
+	IDECFG_PIO_MODE_0	= 0x00000000,
+	IDECFG_PIO_MODE_1	= 0x00000010,
+	IDECFG_PIO_MODE_2	= 0x00000020,
+	IDECFG_PIO_MODE_3	= 0x00000030,
+	IDECFG_PIO_MODE_4	= 0x00000040,
+	IDECFG_MDMA_MODE_0	= 0x00000000,
+	IDECFG_MDMA_MODE_1	= 0x00000010,
+	IDECFG_MDMA_MODE_2	= 0x00000020,
+	IDECFG_UDMA_MODE_0	= 0x00000000,
+	IDECFG_UDMA_MODE_1	= 0x00000010,
+	IDECFG_UDMA_MODE_2	= 0x00000020,
+	IDECFG_UDMA_MODE_3	= 0x00000030,
+	IDECFG_UDMA_MODE_4	= 0x00000040,
+	IDECFG_WST		= 0x00000300,
+};
+
+/* hack to make it build without gpio support */
+/*
+extern void pata_ep93xx_aquire_gpios(void);
+extern void pata_ep93xx_release_gpios(void);
+*/
+
+static struct scsi_host_template pata_ep93xx_sht = {
+	ATA_PIO_SHT(DRV_NAME),
+};
+
+static void pata_ep93xx_set_piomode(struct ata_port *ap,
+				    struct ata_device *adev)
+{
+	void __iomem *base = ap->host->private_data;
+	struct ata_device *pair = ata_dev_pair(adev);
+	const struct ata_timing *t = ata_timing_find_mode(adev->pio_mode);
+	const struct ata_timing *cmd_t = t;
+	u32 reg = IDECFG_IDEEN | IDECFG_PIO;
+	u8 pio = adev->pio_mode - XFER_PIO_0;
+
+	if (pair && pair->pio_mode < adev->pio_mode)
+		cmd_t = ata_timing_find_mode(pair->pio_mode);
+
+	/*
+	 * store the adequate PIO mode timings, to be used later
+	 * by pata_ep93xx_{read,write}
+	 */
+	adev->private_data = (void *)t;
+	ap->private_data = (void *)cmd_t;
+
+	/* reconfigure IDE controller according to PIO mode (?) */
+	switch (pio) {
+	case 4:
+		reg |= IDECFG_PIO_MODE_4 | ((1 << 8) & IDECFG_WST);
+		break;
+	case 3:
+		reg |= IDECFG_PIO_MODE_3 | ((1 << 8) & IDECFG_WST);
+		break;
+	case 2:
+		reg |= IDECFG_PIO_MODE_2 | ((2 << 8) & IDECFG_WST);
+		break;
+	case 1:
+		reg |= IDECFG_PIO_MODE_1 | ((2 << 8) & IDECFG_WST);
+		break;
+	case 0:
+	default:
+		reg |= IDECFG_PIO_MODE_0 | ((3 << 8) & IDECFG_WST);
+		break;
+	}
+	writel(reg, base + IDECFG);
+}
+
+/*
+ * Check whether IORDY is asserted or not.
+ */
+static inline int pata_ep93xx_check_iordy(void __iomem *base)
+{
+	u32 reg = readl(base + IDECTRL);
+
+	return (reg & IDECTRL_IORDY) ? 1 : 0;
+}
+
+/*
+ * IDE Interface register map default state
+ * (shutdown)
+ */
+static void pata_ep93xx_clean_regs(void __iomem *base)
+{
+	/* disable IDE interface initially */
+	writel(IDECTRL_CS0N | IDECTRL_CS1N | IDECTRL_DIORN |
+		IDECTRL_DIOWN, base + IDECTRL);
+
+	/* clear IDE registers */
+	writel(0, base + IDECFG);
+	writel(0, base + IDEMDMAOP);
+	writel(0, base + IDEUDMAOP);
+	writel(0, base + IDEDATAOUT);
+	writel(0, base + IDEDATAIN);
+	writel(0, base + IDEMDMADATAOUT);
+	writel(0, base + IDEMDMADATAIN);
+	writel(0, base + IDEUDMADATAOUT);
+	writel(0, base + IDEUDMADATAIN);
+	writel(0, base + IDEUDMADEBUG);
+}
+
+static u16 __pata_ep93xx_read(void __iomem *base, void *addr,
+			      struct ata_timing *t)
+{
+	u32 reg;
+
+	reg = (unsigned long)addr | IDECTRL_DIORN | IDECTRL_DIOWN;
+	writel(reg, base + IDECTRL);
+	ndelay(t->setup);
+
+	reg &= ~IDECTRL_DIORN;
+	writel(reg, base + IDECTRL);
+	ndelay(t->act8b);
+
+	while (!pata_ep93xx_check_iordy(base))
+		cpu_relax();
+
+	reg |= IDECTRL_DIORN;
+	writel(reg, base + IDECTRL);
+	ndelay(t->cyc8b - t->act8b - t->setup);
+
+	return readl(base + IDEDATAIN);
+}
+
+static inline u16 pata_ep93xx_read(struct ata_port *ap, void *addr)
+{
+	void __iomem *base = ap->host->private_data;
+	struct ata_timing *t = (struct ata_timing *)ap->private_data;
+
+	return __pata_ep93xx_read(base, addr, t);
+}
+
+static void __pata_ep93xx_write(void __iomem *base, u16 value,
+				void *addr, struct ata_timing *t)
+{
+	u32 reg;
+
+	reg = (unsigned long)addr | IDECTRL_DIORN | IDECTRL_DIOWN;
+	writel(reg, base + IDECTRL);
+	ndelay(t->setup);
+
+	writel(value, base + IDEDATAOUT);
+
+	reg &= ~IDECTRL_DIOWN;
+	writel(reg, base + IDECTRL);
+	ndelay(t->act8b);
+
+	while (!pata_ep93xx_check_iordy(base))
+		cpu_relax();
+
+	reg |= IDECTRL_DIOWN;
+	writel(reg, base + IDECTRL);
+	ndelay(t->cyc8b - t->act8b - t->setup);
+}
+
+static inline void pata_ep93xx_write(struct ata_port *ap, u16 value,
+				     void *addr)
+{
+	void __iomem *base = ap->host->private_data;
+	struct ata_timing *t = (struct ata_timing *)ap->private_data;
+
+	__pata_ep93xx_write(base, value, addr, t);
+}
+
+/*
+ * EP93xx IDE PIO Transport Operations
+ */
+
+static u8 pata_ep93xx_check_status(struct ata_port *ap)
+{
+	return pata_ep93xx_read(ap, ap->ioaddr.status_addr);
+}
+
+static u8 pata_ep93xx_check_altstatus(struct ata_port *ap)
+{
+	return pata_ep93xx_read(ap, ap->ioaddr.ctl_addr);
+}
+
+static void pata_ep93xx_tf_load(struct ata_port *ap,
+				const struct ata_taskfile *tf)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
+
+	if (tf->ctl != ap->last_ctl) {
+		pata_ep93xx_write(ap, tf->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = tf->ctl;
+		ata_wait_idle(ap);
+	}
+
+	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
+		pata_ep93xx_write(ap, tf->hob_feature, ioaddr->feature_addr);
+		pata_ep93xx_write(ap, tf->hob_nsect, ioaddr->nsect_addr);
+		pata_ep93xx_write(ap, tf->hob_lbal, ioaddr->lbal_addr);
+		pata_ep93xx_write(ap, tf->hob_lbam, ioaddr->lbam_addr);
+		pata_ep93xx_write(ap, tf->hob_lbah, ioaddr->lbah_addr);
+		VPRINTK("hob: feat 0x%X nsect 0x%X, lba 0x%X 0x%X 0x%X\n",
+			tf->hob_feature,
+			tf->hob_nsect,
+			tf->hob_lbal,
+			tf->hob_lbam,
+			tf->hob_lbah);
+	}
+
+	if (is_addr) {
+		pata_ep93xx_write(ap, tf->feature, ioaddr->feature_addr);
+		pata_ep93xx_write(ap, tf->nsect, ioaddr->nsect_addr);
+		pata_ep93xx_write(ap, tf->lbal, ioaddr->lbal_addr);
+		pata_ep93xx_write(ap, tf->lbam, ioaddr->lbam_addr);
+		pata_ep93xx_write(ap, tf->lbah, ioaddr->lbah_addr);
+		VPRINTK("feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
+			tf->feature,
+			tf->nsect,
+			tf->lbal,
+			tf->lbam,
+			tf->lbah);
+	}
+
+	if (tf->flags & ATA_TFLAG_DEVICE) {
+		pata_ep93xx_write(ap, tf->device, ioaddr->device_addr);
+		VPRINTK("device 0x%X\n", tf->device);
+	}
+
+	ata_wait_idle(ap);
+}
+
+static void pata_ep93xx_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+
+	tf->command = pata_ep93xx_check_status(ap);
+	tf->feature = pata_ep93xx_read(ap, ioaddr->feature_addr);
+	tf->nsect = pata_ep93xx_read(ap, ioaddr->nsect_addr);
+	tf->lbal = pata_ep93xx_read(ap, ioaddr->lbal_addr);
+	tf->lbam = pata_ep93xx_read(ap, ioaddr->lbam_addr);
+	tf->lbah = pata_ep93xx_read(ap, ioaddr->lbah_addr);
+	tf->device = pata_ep93xx_read(ap, ioaddr->device_addr);
+
+	if (tf->flags & ATA_TFLAG_LBA48) {
+		pata_ep93xx_write(ap, tf->ctl | ATA_HOB, ioaddr->ctl_addr);
+		tf->hob_feature = pata_ep93xx_read(ap, ioaddr->feature_addr);
+		tf->hob_nsect = pata_ep93xx_read(ap, ioaddr->nsect_addr);
+		tf->hob_lbal = pata_ep93xx_read(ap, ioaddr->lbal_addr);
+		tf->hob_lbam = pata_ep93xx_read(ap, ioaddr->lbam_addr);
+		tf->hob_lbah = pata_ep93xx_read(ap, ioaddr->lbah_addr);
+		pata_ep93xx_write(ap, tf->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = tf->ctl;
+	}
+}
+
+static void pata_ep93xx_exec_command(struct ata_port *ap,
+				     const struct ata_taskfile *tf)
+{
+	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+
+	pata_ep93xx_write(ap, tf->command, ap->ioaddr.command_addr);
+	ata_sff_pause(ap);
+}
+
+static void pata_ep93xx_dev_select(struct ata_port *ap, unsigned int device)
+{
+	u8 tmp;
+
+	if (device == 0)
+		tmp = ATA_DEVICE_OBS;
+	else
+		tmp = ATA_DEVICE_OBS | ATA_DEV1;
+
+	pata_ep93xx_write(ap, tmp, ap->ioaddr.device_addr);
+	ata_sff_pause(ap);	/* needed; also flushes, for mmio */
+}
+
+static u8 pata_ep93xx_irq_on(struct ata_port *ap)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	u8 tmp;
+
+	ap->ctl &= ~ATA_NIEN;
+	ap->last_ctl = ap->ctl;
+
+	if (ioaddr->ctl_addr)
+		pata_ep93xx_write(ap, ap->ctl, ioaddr->ctl_addr);
+	tmp = ata_wait_idle(ap);
+
+	ap->ops->sff_irq_clear(ap);
+
+	return tmp;
+}
+
+unsigned int pata_ep93xx_data_xfer(struct ata_device *adev, unsigned char *buf,
+				   unsigned int buflen, int rw)
+{
+	struct ata_port *ap = adev->link->ap;
+	void __iomem *base = ap->host->private_data;
+	void *data_addr = ap->ioaddr.data_addr;
+	u16 *data = (u16 *)buf;
+	struct ata_timing *t = adev->private_data;
+	unsigned long flags;
+	unsigned int words = buflen >> 1;
+
+	local_irq_save(flags);
+
+	/* Transfer multiple of 2 bytes */
+	if (rw == READ) {
+		while (words--)
+			*data++ = cpu_to_le16(
+					__pata_ep93xx_read(base, data_addr, t));
+	} else {
+		while (words--)
+			__pata_ep93xx_write(base, le16_to_cpu(*data++),
+					    data_addr, t);
+	}
+
+	/* Transfer trailing byte, if any. */
+	if (unlikely(buflen & 0x01)) {
+		unsigned char pad[2];
+
+		/* Point buf to the tail of buffer */
+		buf += buflen - 1;
+
+		if (rw == READ) {
+			*pad = cpu_to_le16(
+					__pata_ep93xx_read(base, data_addr, t));
+			*buf = pad[0];
+		} else {
+			pad[0] = *buf;
+			__pata_ep93xx_write(base, le16_to_cpu(*pad),
+					    data_addr, t);
+		}
+		words++;
+	}
+
+	local_irq_restore(flags);
+
+	return words << 1;
+}
+
+static void pata_ep93xx_freeze(struct ata_port *ap)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+
+	ap->ctl |= ATA_NIEN;
+	ap->last_ctl = ap->ctl;
+
+	if (ioaddr->ctl_addr)
+		pata_ep93xx_write(ap, ap->ctl, ioaddr->ctl_addr);
+
+	/* Under certain circumstances, some controllers raise IRQ on
+	 * ATA_NIEN manipulation.  Also, many controllers fail to mask
+	 * previously pending IRQ on ATA_NIEN assertion.  Clear it.
+	 */
+	ap->ops->sff_check_status(ap);
+
+	ap->ops->sff_irq_clear(ap);
+}
+
+static unsigned int pata_ep93xx_devchk(struct ata_port *ap,
+				       unsigned int device)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	u8 nsect, lbal;
+
+	ap->ops->sff_dev_select(ap, device);
+
+	pata_ep93xx_write(ap, 0x55, ioaddr->nsect_addr);
+	pata_ep93xx_write(ap, 0xaa, ioaddr->lbal_addr);
+
+	pata_ep93xx_write(ap, 0xaa, ioaddr->nsect_addr);
+	pata_ep93xx_write(ap, 0x55, ioaddr->lbal_addr);
+
+	pata_ep93xx_write(ap, 0x55, ioaddr->nsect_addr);
+	pata_ep93xx_write(ap, 0xaa, ioaddr->lbal_addr);
+
+	nsect = pata_ep93xx_read(ap, ioaddr->nsect_addr);
+	lbal = pata_ep93xx_read(ap, ioaddr->lbal_addr);
+
+	if (nsect == 0x55 && lbal == 0xaa)
+		return 1;	/* we found a device */
+
+	return 0;		/* nothing found */
+}
+
+static int pata_ep93xx_wait_after_reset(struct ata_link *link,
+					unsigned int devmask,
+					unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	unsigned int dev0 = devmask & (1 << 0);
+	unsigned int dev1 = devmask & (1 << 1);
+	int rc, ret = 0;
+
+	msleep(ATA_WAIT_AFTER_RESET);
+
+	/* always check readiness of the master device */
+	rc = ata_sff_wait_ready(link, deadline);
+	/* -ENODEV means the odd clown forgot the D7 pulldown resistor
+	 * and TF status is 0xff, bail out on it too.
+	 */
+	if (rc)
+		return rc;
+
+	/* if device 1 was found in ata_devchk, wait for register
+	 * access briefly, then wait for BSY to clear.
+	 */
+	if (dev1) {
+		int i;
+
+		ap->ops->sff_dev_select(ap, 1);
+
+		/* Wait for register access.  Some ATAPI devices fail
+		 * to set nsect/lbal after reset, so don't waste too
+		 * much time on it.  We're gonna wait for !BSY anyway.
+		 */
+		for (i = 0; i < 2; i++) {
+			u8 nsect, lbal;
+
+			nsect = pata_ep93xx_read(ap, ioaddr->nsect_addr);
+			lbal = pata_ep93xx_read(ap, ioaddr->lbal_addr);
+			if (nsect == 1 && lbal == 1)
+				break;
+			msleep(50);	/* give drive a breather */
+		}
+
+		rc = ata_sff_wait_ready(link, deadline);
+		if (rc) {
+			if (rc != -ENODEV)
+				return rc;
+			ret = rc;
+		}
+	}
+
+	/* is all this really necessary? */
+	ap->ops->sff_dev_select(ap, 0);
+	if (dev1)
+		ap->ops->sff_dev_select(ap, 1);
+	if (dev0)
+		ap->ops->sff_dev_select(ap, 0);
+
+	return ret;
+}
+
+static int pata_ep93xx_bus_softreset(struct ata_port *ap, unsigned int devmask,
+				     unsigned long deadline)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+
+	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
+
+	/* software reset.  causes dev0 to be selected */
+	pata_ep93xx_write(ap, ap->ctl, ioaddr->ctl_addr);
+	udelay(20);	/* FIXME: flush */
+	pata_ep93xx_write(ap, ap->ctl | ATA_SRST, ioaddr->ctl_addr);
+	udelay(20);	/* FIXME: flush */
+	pata_ep93xx_write(ap, ap->ctl, ioaddr->ctl_addr);
+	ap->last_ctl = ap->ctl;
+
+	/* wait the port to become ready */
+	return pata_ep93xx_wait_after_reset(&ap->link, devmask, deadline);
+}
+
+static int pata_ep93xx_softreset(struct ata_link *link, unsigned int *classes,
+				 unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
+	unsigned int devmask = 0;
+	int rc;
+	u8 err;
+
+	DPRINTK("ENTER\n");
+
+	/* determine if device 0/1 are present */
+	if (pata_ep93xx_devchk(ap, 0))
+		devmask |= (1 << 0);
+	if (slave_possible && pata_ep93xx_devchk(ap, 1))
+		devmask |= (1 << 1);
+
+	/* select device 0 again */
+	ap->ops->sff_dev_select(ap, 0);
+
+	/* issue bus reset */
+	DPRINTK("about to softreset, devmask=%x\n", devmask);
+	rc = pata_ep93xx_bus_softreset(ap, devmask, deadline);
+	/* if link is occupied, -ENODEV too is an error */
+	if (rc && (rc != -ENODEV || sata_scr_valid(link))) {
+		ata_link_printk(link, KERN_ERR, "SRST failed (errno=%d)\n", rc);
+		return rc;
+	}
+
+	/* determine by signature whether we have ATA or ATAPI devices */
+	classes[0] = ata_sff_dev_classify(&link->device[0],
+					  devmask & (1 << 0), &err);
+	if (slave_possible && err != 0x81)
+		classes[1] = ata_sff_dev_classify(&link->device[1],
+						  devmask & (1 << 1), &err);
+
+	DPRINTK("EXIT, classes[0]=%u [1]=%u\n", classes[0], classes[1]);
+	return 0;
+}
+
+static void pata_ep93xx_postreset(struct ata_link *link, unsigned int *classes)
+{
+	struct ata_port *ap = link->ap;
+
+	ata_std_postreset(link, classes);
+
+	/* is double-select really necessary? */
+	if (classes[0] != ATA_DEV_NONE)
+		ap->ops->sff_dev_select(ap, 1);
+	if (classes[1] != ATA_DEV_NONE)
+		ap->ops->sff_dev_select(ap, 0);
+
+	/* bail out if no device is present */
+	if (classes[0] == ATA_DEV_NONE && classes[1] == ATA_DEV_NONE) {
+		DPRINTK("EXIT, no device\n");
+		return;
+	}
+
+	/* set up device control */
+	if (ap->ioaddr.ctl_addr) {
+		pata_ep93xx_write(ap, ap->ctl, ap->ioaddr.ctl_addr);
+		ap->last_ctl = ap->ctl;
+	}
+}
+
+static struct ata_port_operations pata_ep93xx_port_ops = {
+	.inherits		= &ata_sff_port_ops,
+
+	.set_piomode		= pata_ep93xx_set_piomode,
+
+	.sff_tf_load		= pata_ep93xx_tf_load,
+	.sff_tf_read		= pata_ep93xx_tf_read,
+	.sff_exec_command	= pata_ep93xx_exec_command,
+	.sff_check_status	= pata_ep93xx_check_status,
+	.sff_check_altstatus	= pata_ep93xx_check_altstatus,
+	.sff_dev_select		= pata_ep93xx_dev_select,
+
+	.sff_irq_on		= pata_ep93xx_irq_on,
+	.sff_data_xfer		= pata_ep93xx_data_xfer,
+
+	.freeze			= pata_ep93xx_freeze,
+	.softreset		= pata_ep93xx_softreset,
+	.postreset		= pata_ep93xx_postreset,
+};
+
+static int __init pata_ep93xx_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *mem_res;
+	void __iomem *ide_base;
+	struct ata_host *host;
+	struct ata_port *ap;
+	int irq;
+
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem_res) {
+		dev_err(dev, "could not retrieve device memory resources!\n");
+		return -ENXIO;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(dev, "could not retrieve device IRQ resource!\n");
+		return -ENXIO;
+	}
+
+	ide_base = devm_ioremap(dev, mem_res->start,
+				mem_res->end - mem_res->start + 1);
+	if (!ide_base) {
+		dev_err(dev, "could not map memory resources!\n");
+		return -ENOMEM;
+	}
+
+	host = ata_host_alloc(dev, 1);
+	if (!host) {
+		dev_err(dev, "failed to allocate memory for EP93xx ATA host\n");
+		return -ENOMEM;
+	}
+
+	host->private_data = ide_base;
+
+	ap = host->ports[0];
+	ap->ops = &pata_ep93xx_port_ops;
+	ap->flags |= ATA_FLAG_SLAVE_POSS;
+	ap->pio_mask = ATA_PIO4;
+
+	/*
+	 * the device IDE register to be accessed is selected through
+	 * IDECTRL register's specific bitfields 'DA', 'CS1n' and 'CS0n':
+	 *   b4   b3   b2    b1     b0
+	 *   A2   A1   A0   CS1n   CS0n
+	 * the values filled in this structure allows the value to be directly
+	 * ORed to the IDECTRL register, hence giving directly the A[2:0] and
+	 * CS1n/CS0n values for each IDE register.
+	 * The values correspond to the transformation:
+	 *   ((real IDE address) << 2) | CS1n value << 1 | CS0n value
+	 */
+	ap->ioaddr.data_addr	= (void *)0x02;
+	ap->ioaddr.error_addr	= (void *)0x06;
+	ap->ioaddr.feature_addr	= (void *)0x06;
+	ap->ioaddr.nsect_addr	= (void *)0x0A;
+	ap->ioaddr.lbal_addr	= (void *)0x0E;
+	ap->ioaddr.lbam_addr	= (void *)0x12;
+	ap->ioaddr.lbah_addr	= (void *)0x16;
+	ap->ioaddr.device_addr	= (void *)0x1A;
+	ap->ioaddr.status_addr	= (void *)0x1E;
+	ap->ioaddr.command_addr	= (void *)0x1E;
+	ap->ioaddr.ctl_addr	= (void *)0x01;
+
+	ata_port_desc(ap, "mmio 0x%llx", (unsigned long long)mem_res->start);
+
+	/* enforce EP93xx IDE controller reset state */
+	pata_ep93xx_clean_regs(ide_base);
+
+	/* set gpio port E, G and H for IDE */
+	pata_ep93xx_aquire_gpios();
+
+	/*
+	 * configure IDE interface:
+	 *   - IDE Master Enable
+	 *   - Polled IO Operation
+	 *   - PIO Mode 0 -> 3.33 MBps
+	 *   - 3 Wait States -> 30 ns
+	 */
+	writel(IDECFG_IDEEN | IDECFG_PIO | IDECFG_PIO_MODE_0 |
+		((3 << 8) & IDECFG_WST), ide_base + IDECFG);
+
+	dev_info(dev, "EP93xx PATA host controller driver initialized\n");
+
+	return ata_host_activate(host, irq, ata_sff_interrupt, 0,
+				 &pata_ep93xx_sht);
+}
+
+static int __devexit pata_ep93xx_remove(struct platform_device *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	void __iomem *base = host->private_data;
+
+	ata_host_detach(host);
+
+	/* reset state */
+	pata_ep93xx_clean_regs(base);
+
+	/* restore back GPIO port E, G and H for GPIO use */
+	pata_ep93xx_release_gpios();
+
+	return 0;
+}
+
+static struct platform_driver pata_ep93xx_driver = {
+	.remove = __exit_p(pata_ep93xx_remove),
+	.driver = {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init pata_ep93xx_init(void)
+{
+	return platform_driver_probe(&pata_ep93xx_driver, pata_ep93xx_probe);
+}
+
+static void __exit pata_ep93xx_exit(void)
+{
+	platform_driver_unregister(&pata_ep93xx_driver);
+}
+
+module_init(pata_ep93xx_init);
+module_exit(pata_ep93xx_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joao Ramos, Bartlomiej Zolnierkiewicz");
+MODULE_DESCRIPTION("EP93xx PATA host controller driver");
+MODULE_VERSION("1.0");
+MODULE_ALIAS("platform:pata_ep93xx");
