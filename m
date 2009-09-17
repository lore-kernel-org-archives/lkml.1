Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZIQUtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZIQUtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZIQUte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:49:34 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46822 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbZIQUtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:49:32 -0400
Date: Thu, 17 Sep 2009 16:49:35 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20090917204935.GA7432@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bug fixes, and a new driver.



Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig        |    9 +
 drivers/ata/Makefile       |    1 +
 drivers/ata/ahci.c         |    4 +-
 drivers/ata/libata-core.c  |    4 +-
 drivers/ata/pata_amd.c     |    3 +
 drivers/ata/pata_atp867x.c |  548 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/sata_promise.c |  155 +++++++++++--
 include/linux/pci_ids.h    |    2 +
 8 files changed, 704 insertions(+), 22 deletions(-)
 create mode 100644 drivers/ata/pata_atp867x.c

John(Jung-Ik) Lee (1):
      libata: Add pata_atp867x driver for Artop/Acard ATP867X controllers

Mikael Pettersson (2):
      sata_promise: disable hotplug on 1st gen chips
      sata_promise: update reset code

Robert Hancock (1):
      pata_amd: do not filter out valid modes in nv_mode_filter

Tejun Heo (2):
      ahci: restore pci_intx() handling
      libata: fix spurious WARN_ON_ONCE() on port freeze

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ab2fa4e..f2df6e2 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -255,6 +255,15 @@ config PATA_ARTOP
 
 	  If unsure, say N.
 
+config PATA_ATP867X
+	tristate "ARTOP/Acard ATP867X PATA support"
+	depends on PCI
+	help
+	  This option enables support for ARTOP/Acard ATP867X PATA
+	  controllers.
+
+	  If unsure, say N.
+
 config PATA_AT32
 	tristate "Atmel AVR32 PATA support (Experimental)"
 	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 463eb52..01e126f 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
 obj-$(CONFIG_PATA_ALI)		+= pata_ali.o
 obj-$(CONFIG_PATA_AMD)		+= pata_amd.o
 obj-$(CONFIG_PATA_ARTOP)	+= pata_artop.o
+obj-$(CONFIG_PATA_ATP867X)	+= pata_atp867x.o
 obj-$(CONFIG_PATA_AT32)		+= pata_at32.o
 obj-$(CONFIG_PATA_ATIIXP)	+= pata_atiixp.o
 obj-$(CONFIG_PATA_CMD640_PCI)	+= pata_cmd640.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index d4cd9c2..acd1162 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2930,8 +2930,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ahci_sb600_32bit_only(pdev))
 		hpriv->flags |= AHCI_HFLAG_32BIT_ONLY;
 
-	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI))
-		pci_enable_msi(pdev);
+	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
+		pci_intx(pdev, 1);
 
 	/* save initial config */
 	ahci_save_initial_config(pdev, hpriv);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index df31dea..0ddaf43 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5024,8 +5024,6 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 		struct ata_device *dev = qc->dev;
 		struct ata_eh_info *ehi = &dev->link->eh_info;
 
-		WARN_ON_ONCE(ap->pflags & ATA_PFLAG_FROZEN);
-
 		if (unlikely(qc->err_mask))
 			qc->flags |= ATA_QCFLAG_FAILED;
 
@@ -5038,6 +5036,8 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 			}
 		}
 
+		WARN_ON_ONCE(ap->pflags & ATA_PFLAG_FROZEN);
+
 		/* read result TF if requested */
 		if (qc->flags & ATA_QCFLAG_RESULT_TF)
 			fill_result_tf(qc);
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 33a74f1..567f3f7 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -307,6 +307,9 @@ static unsigned long nv_mode_filter(struct ata_device *dev,
 		limit |= ATA_MASK_PIO;
 	if (!(limit & (ATA_MASK_MWDMA | ATA_MASK_UDMA)))
 		limit |= ATA_MASK_MWDMA | ATA_MASK_UDMA;
+	/* PIO4, MWDMA2, UDMA2 should always be supported regardless of
+	   cable detection result */
+	limit |= ata_pack_xfermask(ATA_PIO4, ATA_MWDMA2, ATA_UDMA2);
 
 	ata_port_printk(ap, KERN_DEBUG, "nv_mode_filter: 0x%lx&0x%lx->0x%lx, "
 			"BIOS=0x%lx (0x%x) ACPI=0x%lx%s\n",
diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
new file mode 100644
index 0000000..7990de9
--- /dev/null
+++ b/drivers/ata/pata_atp867x.c
@@ -0,0 +1,548 @@
+/*
+ * pata_atp867x.c - ARTOP 867X 64bit 4-channel UDMA133 ATA controller driver
+ *
+ *	(C) 2009 Google Inc. John(Jung-Ik) Lee <jilee@google.com>
+ *
+ * Per Atp867 data sheet rev 1.2, Acard.
+ * Based in part on early ide code from
+ *	2003-2004 by Eric Uhrhane, Google, Inc.
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *
+ * TODO:
+ *   1. RAID features [comparison, XOR, striping, mirroring, etc.]
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <scsi/scsi_host.h>
+#include <linux/libata.h>
+
+#define	DRV_NAME	"pata_atp867x"
+#define	DRV_VERSION	"0.7.5"
+
+/*
+ * IO Registers
+ * Note that all runtime hot priv ports are cached in ap private_data
+ */
+
+enum {
+	ATP867X_IO_CHANNEL_OFFSET	= 0x10,
+
+	/*
+	 * IO Register Bitfields
+	 */
+
+	ATP867X_IO_PIOSPD_ACTIVE_SHIFT	= 4,
+	ATP867X_IO_PIOSPD_RECOVER_SHIFT	= 0,
+
+	ATP867X_IO_DMAMODE_MSTR_SHIFT	= 0,
+	ATP867X_IO_DMAMODE_MSTR_MASK	= 0x07,
+	ATP867X_IO_DMAMODE_SLAVE_SHIFT	= 4,
+	ATP867X_IO_DMAMODE_SLAVE_MASK	= 0x70,
+
+	ATP867X_IO_DMAMODE_UDMA_6	= 0x07,
+	ATP867X_IO_DMAMODE_UDMA_5	= 0x06,
+	ATP867X_IO_DMAMODE_UDMA_4	= 0x05,
+	ATP867X_IO_DMAMODE_UDMA_3	= 0x04,
+	ATP867X_IO_DMAMODE_UDMA_2	= 0x03,
+	ATP867X_IO_DMAMODE_UDMA_1	= 0x02,
+	ATP867X_IO_DMAMODE_UDMA_0	= 0x01,
+	ATP867X_IO_DMAMODE_DISABLE	= 0x00,
+
+	ATP867X_IO_SYS_INFO_66MHZ	= 0x04,
+	ATP867X_IO_SYS_INFO_SLOW_UDMA5	= 0x02,
+	ATP867X_IO_SYS_MASK_RESERVED	= (~0xf1),
+
+	ATP867X_IO_PORTSPD_VAL		= 0x1143,
+	ATP867X_PREREAD_VAL		= 0x0200,
+
+	ATP867X_NUM_PORTS		= 4,
+	ATP867X_BAR_IOBASE		= 0,
+	ATP867X_BAR_ROMBASE		= 6,
+};
+
+#define ATP867X_IOBASE(ap)		((ap)->host->iomap[0])
+#define ATP867X_SYS_INFO(ap)		(0x3F + ATP867X_IOBASE(ap))
+
+#define ATP867X_IO_PORTBASE(ap, port)	(0x00 + ATP867X_IOBASE(ap) + \
+					(port) * ATP867X_IO_CHANNEL_OFFSET)
+#define ATP867X_IO_DMABASE(ap, port)	(0x40 + \
+					ATP867X_IO_PORTBASE((ap), (port)))
+
+#define ATP867X_IO_STATUS(ap, port)	(0x07 + \
+					ATP867X_IO_PORTBASE((ap), (port)))
+#define ATP867X_IO_ALTSTATUS(ap, port)	(0x0E + \
+					ATP867X_IO_PORTBASE((ap), (port)))
+
+/*
+ * hot priv ports
+ */
+#define ATP867X_IO_MSTRPIOSPD(ap, port)	(0x08 + \
+					ATP867X_IO_DMABASE((ap), (port)))
+#define ATP867X_IO_SLAVPIOSPD(ap, port)	(0x09 + \
+					ATP867X_IO_DMABASE((ap), (port)))
+#define ATP867X_IO_8BPIOSPD(ap, port)	(0x0A + \
+					ATP867X_IO_DMABASE((ap), (port)))
+#define ATP867X_IO_DMAMODE(ap, port)	(0x0B + \
+					ATP867X_IO_DMABASE((ap), (port)))
+
+#define ATP867X_IO_PORTSPD(ap, port)	(0x4A + \
+					ATP867X_IO_PORTBASE((ap), (port)))
+#define ATP867X_IO_PREREAD(ap, port)	(0x4C + \
+					ATP867X_IO_PORTBASE((ap), (port)))
+
+struct atp867x_priv {
+	void __iomem *dma_mode;
+	void __iomem *mstr_piospd;
+	void __iomem *slave_piospd;
+	void __iomem *eightb_piospd;
+	int		pci66mhz;
+};
+
+static inline u8 atp867x_speed_to_mode(u8 speed)
+{
+	return speed - XFER_UDMA_0 + 1;
+}
+
+static void atp867x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct atp867x_priv *dp = ap->private_data;
+	u8 speed = adev->dma_mode;
+	u8 b;
+	u8 mode;
+
+	mode = atp867x_speed_to_mode(speed);
+
+	/*
+	 * Doc 6.6.9: decrease the udma mode value by 1 for safer UDMA speed
+	 * on 66MHz bus
+	 *   rev-A: UDMA_1~4 (5, 6 no change)
+	 *   rev-B: all UDMA modes
+	 *   UDMA_0 stays not to disable UDMA
+	 */
+	if (dp->pci66mhz && mode > ATP867X_IO_DMAMODE_UDMA_0  &&
+	   (pdev->device == PCI_DEVICE_ID_ARTOP_ATP867B ||
+	    mode < ATP867X_IO_DMAMODE_UDMA_5))
+		mode--;
+
+	b = ioread8(dp->dma_mode);
+	if (adev->devno & 1) {
+		b = (b & ~ATP867X_IO_DMAMODE_SLAVE_MASK) |
+			(mode << ATP867X_IO_DMAMODE_SLAVE_SHIFT);
+	} else {
+		b = (b & ~ATP867X_IO_DMAMODE_MSTR_MASK) |
+			(mode << ATP867X_IO_DMAMODE_MSTR_SHIFT);
+	}
+	iowrite8(b, dp->dma_mode);
+}
+
+static int atp867x_get_active_clocks_shifted(unsigned int clk)
+{
+	unsigned char clocks = clk;
+
+	switch (clocks) {
+	case 0:
+		clocks = 1;
+		break;
+	case 1 ... 7:
+		break;
+	case 8 ... 12:
+		clocks = 7;
+		break;
+	default:
+		printk(KERN_WARNING "ATP867X: active %dclk is invalid. "
+			"Using default 8clk.\n", clk);
+		clocks = 0;	/* 8 clk */
+		break;
+	}
+	return clocks << ATP867X_IO_PIOSPD_ACTIVE_SHIFT;
+}
+
+static int atp867x_get_recover_clocks_shifted(unsigned int clk)
+{
+	unsigned char clocks = clk;
+
+	switch (clocks) {
+	case 0:
+		clocks = 1;
+		break;
+	case 1 ... 11:
+		break;
+	case 12:
+		clocks = 0;
+		break;
+	case 13: case 14:
+		--clocks;
+		break;
+	case 15:
+		break;
+	default:
+		printk(KERN_WARNING "ATP867X: recover %dclk is invalid. "
+			"Using default 15clk.\n", clk);
+		clocks = 0;	/* 12 clk */
+		break;
+	}
+	return clocks << ATP867X_IO_PIOSPD_RECOVER_SHIFT;
+}
+
+static void atp867x_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct ata_device *peer = ata_dev_pair(adev);
+	struct atp867x_priv *dp = ap->private_data;
+	u8 speed = adev->pio_mode;
+	struct ata_timing t, p;
+	int T, UT;
+	u8 b;
+
+	T = 1000000000 / 33333;
+	UT = T / 4;
+
+	ata_timing_compute(adev, speed, &t, T, UT);
+	if (peer && peer->pio_mode) {
+		ata_timing_compute(peer, peer->pio_mode, &p, T, UT);
+		ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
+	}
+
+	b = ioread8(dp->dma_mode);
+	if (adev->devno & 1)
+		b = (b & ~ATP867X_IO_DMAMODE_SLAVE_MASK);
+	else
+		b = (b & ~ATP867X_IO_DMAMODE_MSTR_MASK);
+	iowrite8(b, dp->dma_mode);
+
+	b = atp867x_get_active_clocks_shifted(t.active) |
+		atp867x_get_recover_clocks_shifted(t.recover);
+	if (dp->pci66mhz)
+		b += 0x10;
+
+	if (adev->devno & 1)
+		iowrite8(b, dp->slave_piospd);
+	else
+		iowrite8(b, dp->mstr_piospd);
+
+	/*
+	 * use the same value for comand timing as for PIO timimg
+	 */
+	iowrite8(b, dp->eightb_piospd);
+}
+
+static int atp867x_cable_detect(struct ata_port *ap)
+{
+	return ATA_CBL_PATA40_SHORT;
+}
+
+static struct scsi_host_template atp867x_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations atp867x_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.cable_detect		= atp867x_cable_detect,
+	.set_piomode		= atp867x_set_piomode,
+	.set_dmamode		= atp867x_set_dmamode,
+};
+
+
+#ifdef	ATP867X_DEBUG
+static void atp867x_check_res(struct pci_dev *pdev)
+{
+	int i;
+	unsigned long start, len;
+
+	/* Check the PCI resources for this channel are enabled */
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+		start = pci_resource_start(pdev, i);
+		len   = pci_resource_len(pdev, i);
+		printk(KERN_DEBUG "ATP867X: resource start:len=%lx:%lx\n",
+			start, len);
+	}
+}
+
+static void atp867x_check_ports(struct ata_port *ap, int port)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	struct atp867x_priv *dp = ap->private_data;
+
+	printk(KERN_DEBUG "ATP867X: port[%d] addresses\n"
+		"  cmd_addr	=0x%llx, 0x%llx\n"
+		"  ctl_addr	=0x%llx, 0x%llx\n"
+		"  bmdma_addr	=0x%llx, 0x%llx\n"
+		"  data_addr	=0x%llx\n"
+		"  error_addr	=0x%llx\n"
+		"  feature_addr	=0x%llx\n"
+		"  nsect_addr	=0x%llx\n"
+		"  lbal_addr	=0x%llx\n"
+		"  lbam_addr	=0x%llx\n"
+		"  lbah_addr	=0x%llx\n"
+		"  device_addr	=0x%llx\n"
+		"  status_addr	=0x%llx\n"
+		"  command_addr	=0x%llx\n"
+		"  dp->dma_mode	=0x%llx\n"
+		"  dp->mstr_piospd	=0x%llx\n"
+		"  dp->slave_piospd	=0x%llx\n"
+		"  dp->eightb_piospd	=0x%llx\n"
+		"  dp->pci66mhz		=0x%lx\n",
+		port,
+		(unsigned long long)ioaddr->cmd_addr,
+		(unsigned long long)ATP867X_IO_PORTBASE(ap, port),
+		(unsigned long long)ioaddr->ctl_addr,
+		(unsigned long long)ATP867X_IO_ALTSTATUS(ap, port),
+		(unsigned long long)ioaddr->bmdma_addr,
+		(unsigned long long)ATP867X_IO_DMABASE(ap, port),
+		(unsigned long long)ioaddr->data_addr,
+		(unsigned long long)ioaddr->error_addr,
+		(unsigned long long)ioaddr->feature_addr,
+		(unsigned long long)ioaddr->nsect_addr,
+		(unsigned long long)ioaddr->lbal_addr,
+		(unsigned long long)ioaddr->lbam_addr,
+		(unsigned long long)ioaddr->lbah_addr,
+		(unsigned long long)ioaddr->device_addr,
+		(unsigned long long)ioaddr->status_addr,
+		(unsigned long long)ioaddr->command_addr,
+		(unsigned long long)dp->dma_mode,
+		(unsigned long long)dp->mstr_piospd,
+		(unsigned long long)dp->slave_piospd,
+		(unsigned long long)dp->eightb_piospd,
+		(unsigned long)dp->pci66mhz);
+}
+#endif
+
+static int atp867x_set_priv(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct atp867x_priv *dp;
+	int port = ap->port_no;
+
+	dp = ap->private_data =
+		devm_kzalloc(&pdev->dev, sizeof(*dp), GFP_KERNEL);
+	if (dp == NULL)
+		return -ENOMEM;
+
+	dp->dma_mode	 = ATP867X_IO_DMAMODE(ap, port);
+	dp->mstr_piospd	 = ATP867X_IO_MSTRPIOSPD(ap, port);
+	dp->slave_piospd = ATP867X_IO_SLAVPIOSPD(ap, port);
+	dp->eightb_piospd = ATP867X_IO_8BPIOSPD(ap, port);
+
+	dp->pci66mhz =
+		ioread8(ATP867X_SYS_INFO(ap)) & ATP867X_IO_SYS_INFO_66MHZ;
+
+	return 0;
+}
+
+static void atp867x_fixup(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct ata_port *ap = host->ports[0];
+	int i;
+	u8 v;
+
+	/*
+	 * Broken BIOS might not set latency high enough
+	 */
+	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &v);
+	if (v < 0x80) {
+		v = 0x80;
+		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, v);
+		printk(KERN_DEBUG "ATP867X: set latency timer of device %s"
+			" to %d\n", pci_name(pdev), v);
+	}
+
+	/*
+	 * init 8bit io ports speed(0aaarrrr) to 43h and
+	 * init udma modes of master/slave to 0/0(11h)
+	 */
+	for (i = 0; i < ATP867X_NUM_PORTS; i++)
+		iowrite16(ATP867X_IO_PORTSPD_VAL, ATP867X_IO_PORTSPD(ap, i));
+
+	/*
+	 * init PreREAD counts
+	 */
+	for (i = 0; i < ATP867X_NUM_PORTS; i++)
+		iowrite16(ATP867X_PREREAD_VAL, ATP867X_IO_PREREAD(ap, i));
+
+	v = ioread8(ATP867X_IOBASE(ap) + 0x28);
+	v &= 0xcf;	/* Enable INTA#: bit4=0 means enable */
+	v |= 0xc0;	/* Enable PCI burst, MRM & not immediate interrupts */
+	iowrite8(v, ATP867X_IOBASE(ap) + 0x28);
+
+	/*
+	 * Turn off the over clocked udma5 mode, only for Rev-B
+	 */
+	v = ioread8(ATP867X_SYS_INFO(ap));
+	v &= ATP867X_IO_SYS_MASK_RESERVED;
+	if (pdev->device == PCI_DEVICE_ID_ARTOP_ATP867B)
+		v |= ATP867X_IO_SYS_INFO_SLOW_UDMA5;
+	iowrite8(v, ATP867X_SYS_INFO(ap));
+}
+
+static int atp867x_ata_pci_sff_init_host(struct ata_host *host)
+{
+	struct device *gdev = host->dev;
+	struct pci_dev *pdev = to_pci_dev(gdev);
+	unsigned int mask = 0;
+	int i, rc;
+
+	/*
+	 * do not map rombase
+	 */
+	rc = pcim_iomap_regions(pdev, 1 << ATP867X_BAR_IOBASE, DRV_NAME);
+	if (rc == -EBUSY)
+		pcim_pin_device(pdev);
+	if (rc)
+		return rc;
+	host->iomap = pcim_iomap_table(pdev);
+
+#ifdef	ATP867X_DEBUG
+	atp867x_check_res(pdev);
+
+	for (i = 0; i < PCI_ROM_RESOURCE; i++)
+		printk(KERN_DEBUG "ATP867X: iomap[%d]=0x%llx\n", i,
+			(unsigned long long)(host->iomap[i]));
+#endif
+
+	/*
+	 * request, iomap BARs and init port addresses accordingly
+	 */
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		struct ata_ioports *ioaddr = &ap->ioaddr;
+
+		ioaddr->cmd_addr = ATP867X_IO_PORTBASE(ap, i);
+		ioaddr->ctl_addr = ioaddr->altstatus_addr
+				 = ATP867X_IO_ALTSTATUS(ap, i);
+		ioaddr->bmdma_addr = ATP867X_IO_DMABASE(ap, i);
+
+		ata_sff_std_ports(ioaddr);
+		rc = atp867x_set_priv(ap);
+		if (rc)
+			return rc;
+
+#ifdef	ATP867X_DEBUG
+		atp867x_check_ports(ap, i);
+#endif
+		ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx",
+			(unsigned long)ioaddr->cmd_addr,
+			(unsigned long)ioaddr->ctl_addr);
+		ata_port_desc(ap, "bmdma 0x%lx",
+			(unsigned long)ioaddr->bmdma_addr);
+
+		mask |= 1 << i;
+	}
+
+	if (!mask) {
+		dev_printk(KERN_ERR, gdev, "no available native port\n");
+		return -ENODEV;
+	}
+
+	atp867x_fixup(host);
+
+	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+
+	rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
+	return rc;
+}
+
+static int atp867x_init_one(struct pci_dev *pdev,
+	const struct pci_device_id *id)
+{
+	static int printed_version;
+	static const struct ata_port_info info_867x = {
+		.flags		= ATA_FLAG_SLAVE_POSS,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask 	= ATA_UDMA6,
+		.port_ops	= &atp867x_ops,
+	};
+
+	struct ata_host *host;
+	const struct ata_port_info *ppi[] = { &info_867x, NULL };
+	int rc;
+
+	if (!printed_version++)
+		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	printk(KERN_INFO "ATP867X: ATP867 ATA UDMA133 controller (rev %02X)",
+		pdev->device);
+
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, ATP867X_NUM_PORTS);
+	if (!host) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			"failed to allocate ATA host\n");
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	rc = atp867x_ata_pci_sff_init_host(host);
+	if (rc) {
+		dev_printk(KERN_ERR, &pdev->dev, "failed to init host\n");
+		goto err_out;
+	}
+
+	pci_set_master(pdev);
+
+	rc = ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+				IRQF_SHARED, &atp867x_sht);
+	if (rc)
+		dev_printk(KERN_ERR, &pdev->dev, "failed to activate host\n");
+
+err_out:
+	return rc;
+}
+
+static struct pci_device_id atp867x_pci_tbl[] = {
+	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP867A),	0 },
+	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP867B),	0 },
+	{ },
+};
+
+static struct pci_driver atp867x_driver = {
+	.name 		= DRV_NAME,
+	.id_table 	= atp867x_pci_tbl,
+	.probe 		= atp867x_init_one,
+	.remove		= ata_pci_remove_one,
+};
+
+static int __init atp867x_init(void)
+{
+	return pci_register_driver(&atp867x_driver);
+}
+
+static void __exit atp867x_exit(void)
+{
+	pci_unregister_driver(&atp867x_driver);
+}
+
+MODULE_AUTHOR("John(Jung-Ik) Lee, Google Inc.");
+MODULE_DESCRIPTION("low level driver for Artop/Acard 867x ATA controller");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, atp867x_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
+
+module_init(atp867x_init);
+module_exit(atp867x_exit);
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index b1fd7d6..07d8d00 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -56,6 +56,7 @@ enum {
 	/* host register offsets (from host->iomap[PDC_MMIO_BAR]) */
 	PDC_INT_SEQMASK		= 0x40,	/* Mask of asserted SEQ INTs */
 	PDC_FLASH_CTL		= 0x44, /* Flash control register */
+	PDC_PCI_CTL		= 0x48, /* PCI control/status reg */
 	PDC_SATA_PLUG_CSR	= 0x6C, /* SATA Plug control/status reg */
 	PDC2_SATA_PLUG_CSR	= 0x60, /* SATAII Plug control/status reg */
 	PDC_TBG_MODE		= 0x41C, /* TBG mode (not SATAII) */
@@ -75,7 +76,17 @@ enum {
 	PDC_CTLSTAT		= 0x60,	/* IDE control and status (per port) */
 
 	/* per-port SATA register offsets (from ap->ioaddr.scr_addr) */
+	PDC_SATA_ERROR		= 0x04,
 	PDC_PHYMODE4		= 0x14,
+	PDC_LINK_LAYER_ERRORS	= 0x6C,
+	PDC_FPDMA_CTLSTAT	= 0xD8,
+	PDC_INTERNAL_DEBUG_1	= 0xF8,	/* also used for PATA */
+	PDC_INTERNAL_DEBUG_2	= 0xFC,	/* also used for PATA */
+
+	/* PDC_FPDMA_CTLSTAT bit definitions */
+	PDC_FPDMA_CTLSTAT_RESET			= 1 << 3,
+	PDC_FPDMA_CTLSTAT_DMASETUP_INT_FLAG	= 1 << 10,
+	PDC_FPDMA_CTLSTAT_SETDB_INT_FLAG	= 1 << 11,
 
 	/* PDC_GLOBAL_CTL bit definitions */
 	PDC_PH_ERR		= (1 <<  8), /* PCI error while loading packet */
@@ -195,9 +206,12 @@ static struct ata_port_operations pdc_sata_ops = {
 	.hardreset		= pdc_sata_hardreset,
 };
 
-/* First-generation chips need a more restrictive ->check_atapi_dma op */
+/* First-generation chips need a more restrictive ->check_atapi_dma op,
+   and ->freeze/thaw that ignore the hotplug controls. */
 static struct ata_port_operations pdc_old_sata_ops = {
 	.inherits		= &pdc_sata_ops,
+	.freeze			= pdc_freeze,
+	.thaw			= pdc_thaw,
 	.check_atapi_dma	= pdc_old_sata_check_atapi_dma,
 };
 
@@ -356,12 +370,76 @@ static int pdc_sata_port_start(struct ata_port *ap)
 	return 0;
 }
 
+static void pdc_fpdma_clear_interrupt_flag(struct ata_port *ap)
+{
+	void __iomem *sata_mmio = ap->ioaddr.scr_addr;
+	u32 tmp;
+
+	tmp = readl(sata_mmio + PDC_FPDMA_CTLSTAT);
+	tmp |= PDC_FPDMA_CTLSTAT_DMASETUP_INT_FLAG;
+	tmp |= PDC_FPDMA_CTLSTAT_SETDB_INT_FLAG;
+
+	/* It's not allowed to write to the entire FPDMA_CTLSTAT register
+	   when NCQ is running. So do a byte-sized write to bits 10 and 11. */
+	writeb(tmp >> 8, sata_mmio + PDC_FPDMA_CTLSTAT + 1);
+	readb(sata_mmio + PDC_FPDMA_CTLSTAT + 1); /* flush */
+}
+
+static void pdc_fpdma_reset(struct ata_port *ap)
+{
+	void __iomem *sata_mmio = ap->ioaddr.scr_addr;
+	u8 tmp;
+
+	tmp = (u8)readl(sata_mmio + PDC_FPDMA_CTLSTAT);
+	tmp &= 0x7F;
+	tmp |= PDC_FPDMA_CTLSTAT_RESET;
+	writeb(tmp, sata_mmio + PDC_FPDMA_CTLSTAT);
+	readl(sata_mmio + PDC_FPDMA_CTLSTAT); /* flush */
+	udelay(100);
+	tmp &= ~PDC_FPDMA_CTLSTAT_RESET;
+	writeb(tmp, sata_mmio + PDC_FPDMA_CTLSTAT);
+	readl(sata_mmio + PDC_FPDMA_CTLSTAT); /* flush */
+
+	pdc_fpdma_clear_interrupt_flag(ap);
+}
+
+static void pdc_not_at_command_packet_phase(struct ata_port *ap)
+{
+	void __iomem *sata_mmio = ap->ioaddr.scr_addr;
+	unsigned int i;
+	u32 tmp;
+
+	/* check not at ASIC packet command phase */
+	for (i = 0; i < 100; ++i) {
+		writel(0, sata_mmio + PDC_INTERNAL_DEBUG_1);
+		tmp = readl(sata_mmio + PDC_INTERNAL_DEBUG_2);
+		if ((tmp & 0xF) != 1)
+			break;
+		udelay(100);
+	}
+}
+
+static void pdc_clear_internal_debug_record_error_register(struct ata_port *ap)
+{
+	void __iomem *sata_mmio = ap->ioaddr.scr_addr;
+
+	writel(0xffffffff, sata_mmio + PDC_SATA_ERROR);
+	writel(0xffff0000, sata_mmio + PDC_LINK_LAYER_ERRORS);
+}
+
 static void pdc_reset_port(struct ata_port *ap)
 {
 	void __iomem *ata_ctlstat_mmio = ap->ioaddr.cmd_addr + PDC_CTLSTAT;
 	unsigned int i;
 	u32 tmp;
 
+	if (ap->flags & PDC_FLAG_GEN_II)
+		pdc_not_at_command_packet_phase(ap);
+
+	tmp = readl(ata_ctlstat_mmio);
+	tmp |= PDC_RESET;
+	writel(tmp, ata_ctlstat_mmio);
+
 	for (i = 11; i > 0; i--) {
 		tmp = readl(ata_ctlstat_mmio);
 		if (tmp & PDC_RESET)
@@ -376,6 +454,11 @@ static void pdc_reset_port(struct ata_port *ap)
 	tmp &= ~PDC_RESET;
 	writel(tmp, ata_ctlstat_mmio);
 	readl(ata_ctlstat_mmio);	/* flush */
+
+	if (sata_scr_valid(&ap->link) && (ap->flags & PDC_FLAG_GEN_II)) {
+		pdc_fpdma_reset(ap);
+		pdc_clear_internal_debug_record_error_register(ap);
+	}
 }
 
 static int pdc_pata_cable_detect(struct ata_port *ap)
@@ -626,11 +709,6 @@ static unsigned int pdc_sata_ata_port_to_ata_no(const struct ata_port *ap)
 	return pdc_port_no_to_ata_no(i, pdc_is_sataii_tx4(ap->flags));
 }
 
-static unsigned int pdc_sata_hotplug_offset(const struct ata_port *ap)
-{
-	return (ap->flags & PDC_FLAG_GEN_II) ? PDC2_SATA_PLUG_CSR : PDC_SATA_PLUG_CSR;
-}
-
 static void pdc_freeze(struct ata_port *ap)
 {
 	void __iomem *ata_mmio = ap->ioaddr.cmd_addr;
@@ -647,7 +725,7 @@ static void pdc_sata_freeze(struct ata_port *ap)
 {
 	struct ata_host *host = ap->host;
 	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
-	unsigned int hotplug_offset = pdc_sata_hotplug_offset(ap);
+	unsigned int hotplug_offset = PDC2_SATA_PLUG_CSR;
 	unsigned int ata_no = pdc_sata_ata_port_to_ata_no(ap);
 	u32 hotplug_status;
 
@@ -685,7 +763,7 @@ static void pdc_sata_thaw(struct ata_port *ap)
 {
 	struct ata_host *host = ap->host;
 	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
-	unsigned int hotplug_offset = pdc_sata_hotplug_offset(ap);
+	unsigned int hotplug_offset = PDC2_SATA_PLUG_CSR;
 	unsigned int ata_no = pdc_sata_ata_port_to_ata_no(ap);
 	u32 hotplug_status;
 
@@ -708,11 +786,50 @@ static int pdc_pata_softreset(struct ata_link *link, unsigned int *class,
 	return ata_sff_softreset(link, class, deadline);
 }
 
+static unsigned int pdc_ata_port_to_ata_no(const struct ata_port *ap)
+{
+	void __iomem *ata_mmio = ap->ioaddr.cmd_addr;
+	void __iomem *host_mmio = ap->host->iomap[PDC_MMIO_BAR];
+
+	/* ata_mmio == host_mmio + 0x200 + ata_no * 0x80 */
+	return (ata_mmio - host_mmio - 0x200) / 0x80;
+}
+
+static void pdc_hard_reset_port(struct ata_port *ap)
+{
+	void __iomem *host_mmio = ap->host->iomap[PDC_MMIO_BAR];
+	void __iomem *pcictl_b1_mmio = host_mmio + PDC_PCI_CTL + 1;
+	unsigned int ata_no = pdc_ata_port_to_ata_no(ap);
+	u8 tmp;
+
+	spin_lock(&ap->host->lock);
+
+	tmp = readb(pcictl_b1_mmio);
+	tmp &= ~(0x10 << ata_no);
+	writeb(tmp, pcictl_b1_mmio);
+	readb(pcictl_b1_mmio); /* flush */
+	udelay(100);
+	tmp |= (0x10 << ata_no);
+	writeb(tmp, pcictl_b1_mmio);
+	readb(pcictl_b1_mmio); /* flush */
+
+	spin_unlock(&ap->host->lock);
+}
+
 static int pdc_sata_hardreset(struct ata_link *link, unsigned int *class,
 			      unsigned long deadline)
 {
+	if (link->ap->flags & PDC_FLAG_GEN_II)
+		pdc_not_at_command_packet_phase(link->ap);
+	/* hotplug IRQs should have been masked by pdc_sata_freeze() */
+	pdc_hard_reset_port(link->ap);
 	pdc_reset_port(link->ap);
-	return sata_sff_hardreset(link, class, deadline);
+
+	/* sata_promise can't reliably acquire the first D2H Reg FIS
+	 * after hardreset.  Do non-waiting hardreset and request
+	 * follow-up SRST.
+	 */
+	return sata_std_hardreset(link, class, deadline);
 }
 
 static void pdc_error_handler(struct ata_port *ap)
@@ -832,14 +949,14 @@ static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 	spin_lock(&host->lock);
 
 	/* read and clear hotplug flags for all ports */
-	if (host->ports[0]->flags & PDC_FLAG_GEN_II)
+	if (host->ports[0]->flags & PDC_FLAG_GEN_II) {
 		hotplug_offset = PDC2_SATA_PLUG_CSR;
-	else
-		hotplug_offset = PDC_SATA_PLUG_CSR;
-	hotplug_status = readl(host_mmio + hotplug_offset);
-	if (hotplug_status & 0xff)
-		writel(hotplug_status | 0xff, host_mmio + hotplug_offset);
-	hotplug_status &= 0xff;	/* clear uninteresting bits */
+		hotplug_status = readl(host_mmio + hotplug_offset);
+		if (hotplug_status & 0xff)
+			writel(hotplug_status | 0xff, host_mmio + hotplug_offset);
+		hotplug_status &= 0xff;	/* clear uninteresting bits */
+	} else
+		hotplug_status = 0;
 
 	/* reading should also clear interrupts */
 	mask = readl(host_mmio + PDC_INT_SEQMASK);
@@ -1034,9 +1151,11 @@ static void pdc_host_init(struct ata_host *host)
 	tmp = readl(host_mmio + hotplug_offset);
 	writel(tmp | 0xff, host_mmio + hotplug_offset);
 
-	/* unmask plug/unplug ints */
 	tmp = readl(host_mmio + hotplug_offset);
-	writel(tmp & ~0xff0000, host_mmio + hotplug_offset);
+	if (is_gen2)	/* unmask plug/unplug ints */
+		writel(tmp & ~0xff0000, host_mmio + hotplug_offset);
+	else		/* mask plug/unplug ints */
+		writel(tmp | 0xff0000, host_mmio + hotplug_offset);
 
 	/* don't initialise TBG or SLEW on 2nd generation chips */
 	if (is_gen2)
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 8975add..3b6b788 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1529,6 +1529,8 @@
 #define PCI_DEVICE_ID_ARTOP_ATP860R	0x0007
 #define PCI_DEVICE_ID_ARTOP_ATP865	0x0008
 #define PCI_DEVICE_ID_ARTOP_ATP865R	0x0009
+#define PCI_DEVICE_ID_ARTOP_ATP867A	0x000A
+#define PCI_DEVICE_ID_ARTOP_ATP867B	0x000B
 #define PCI_DEVICE_ID_ARTOP_AEC7610	0x8002
 #define PCI_DEVICE_ID_ARTOP_AEC7612UW	0x8010
 #define PCI_DEVICE_ID_ARTOP_AEC7612U	0x8020
