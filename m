Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZIMA0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZIMA0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 20:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZIMA0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 20:26:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:26935 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbZIMA0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 20:26:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:x-system-of-record;
	b=pskKSlyDYvZXK1qRP4Q3n8qCArOdnZAkCcP9WnZ+TRZWwXPPfhpjj+tgVtlzzxBiL
	qQlFDGB34hIGiktx9lgVw==
MIME-Version: 1.0
In-Reply-To: <8b5805ff0909121717w1516c273k2a568779b9c31662@mail.gmail.com>
References: <8b5805ff0909111906j68c20c3yf7226f2798a67d80@mail.gmail.com> 
	<1252721641.28368.34.camel@desktop> <8b5805ff0909120359g2faf661br463b19518d935110@mail.gmail.com> 
	<4AABD122.2000400@gmail.com> <8b5805ff0909121717w1516c273k2a568779b9c31662@mail.gmail.com>
From: "Jung-Ik (John) Lee" <jilee@google.com>
Date: Sat, 12 Sep 2009 17:26:21 -0700
Message-ID: <8b5805ff0909121726g2f1a78c1o1ff7289e059eabe5@mail.gmail.com>
Subject: Re: [PATCH] libata: Add pata_atp867x driver for Artop/Acard ATP867X 
	controllers
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@google.com>,
       Gwendal Grignou <gwendal@google.com>, Eric Uhrhane <ericu@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John(Jung-Ik) Lee <jilee@google.com>

This is a new pata driver for ARTOP 867X 64bit 4-channel UDMA133 ATA ctrls.
Based on the Atp867 data sheet rev 1.2, Acard, and in part on early ide codes
from Eric Uhrhane <ericu@google.com>.

Signed-off-by: John(Jung-Ik) Lee <jilee@google.com>
Reviewed-by:  Grant Grundler <grundler@google.com>
Reviewed-by:  Gwendal Gringo <gwendal@google.com>
---

 drivers/ata/Kconfig        |    9 +
 drivers/ata/Makefile       |    1 +
 drivers/ata/pata_atp867x.c |  578 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h    |    2 +
 4 files changed, 590 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index b17c57f..2e1e678 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -244,6 +244,15 @@ config PATA_ARTOP

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
index 38906f9..3372007 100644
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
diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
new file mode 100644
index 0000000..4ebf555
--- /dev/null
+++ b/drivers/ata/pata_atp867x.c
@@ -0,0 +1,578 @@
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
+ * Note that all runtime hot ports are cached in ap private_data
+ */
+
+#define ATP867X_IO_CHANNEL_OFFSET	0x10
+#define ATP867X_IOBASE(d)		pci_resource_start((d), 0)
+#define ATP867X_SYS_INFO(d)		(0x3F + ATP867X_IOBASE(d))
+
+#define ATP867X_IO_PORTBASE(d, port)	(0x00 + ATP867X_IOBASE(d) + \
+					(port) * ATP867X_IO_CHANNEL_OFFSET)
+#define ATP867X_IO_DMABASE(d, port)	(0x40 + \
+					ATP867X_IO_PORTBASE((d), (port)))
+
+#define ATP867X_IO_STATUS(d, port)	(0x07 + \
+					ATP867X_IO_PORTBASE((d), (port)))
+#define ATP867X_IO_ALTSTATUS(d, port)	(0x0E + \
+					ATP867X_IO_PORTBASE((d), (port)))
+
+#define ATP867X_IO_MSTRPIOSPD(d, port)	(0x08 + ATP867X_IO_DMABASE((d), (port)))
+#define ATP867X_IO_SLAVPIOSPD(d, port)	(0x09 + ATP867X_IO_DMABASE((d), (port)))
+#define ATP867X_IO_8BPIOSPD(d, port)	(0x0A + ATP867X_IO_DMABASE((d), (port)))
+#define ATP867X_IO_DMAMODE(d, port)	(0x0B + ATP867X_IO_DMABASE((d), (port)))
+
+#define ATP867X_IO_PORTSPEED(d, port)	(0x4A + \
+					ATP867X_IO_PORTBASE((d), (port)))
+#define ATP867X_IO_PREREAD(d, port)	(0x4C + \
+					ATP867X_IO_PORTBASE((d), (port)))
+
+/*
+ * IO Register Bitfields
+ */
+
+#define ATP867X_IO_PIOSPD_ACTIVE_SHIFT	4
+#define ATP867X_IO_PIOSPD_RECOVER_SHIFT	0
+
+#define ATP867X_IO_DMAMODE_MSTR_SHIFT	0
+#define ATP867X_IO_DMAMODE_MSTR_MASK	0x07
+#define ATP867X_IO_DMAMODE_SLAVE_SHIFT	4
+#define ATP867X_IO_DMAMODE_SLAVE_MASK	0x70
+
+#define ATP867X_IO_DMAMODE_UDMA_6	0x07
+#define ATP867X_IO_DMAMODE_UDMA_5	0x06
+#define ATP867X_IO_DMAMODE_UDMA_4	0x05
+#define ATP867X_IO_DMAMODE_UDMA_3	0x04
+#define ATP867X_IO_DMAMODE_UDMA_2	0x03
+#define ATP867X_IO_DMAMODE_UDMA_1	0x02
+#define ATP867X_IO_DMAMODE_UDMA_0	0x01
+#define ATP867X_IO_DMAMODE_DISABLE	0x00
+
+#define ATP867X_IO_SYS_INFO_66MHZ	0x04
+#define ATP867X_IO_SYS_INFO_SLOW_UDMA5	0x02
+#define ATP867X_IO_SYS_MASK_RESERVED	(~0xf1)
+
+#define ATP867X_IO_PORTSPEED_VAL	0x1143
+#define ATP867X_PREREAD_VAL		0x0200
+
+#define ATP867X_NUM_PORTS		4
+#define ATP867X_BAR_IOBASE		0
+#define ATP867X_BAR_ROMBASE		6
+
+struct atp867x_priv {
+	unsigned long	dma_mode;
+	unsigned long	mstr_piospd;
+	unsigned long	slave_piospd;
+	unsigned long	eightb_piospd;
+	int		pci66mhz;
+};
+
+
+static void atp867x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	struct atp867x_priv *dp = ap->private_data;
+	u8 speed = adev->dma_mode;
+	u8 b;
+	u8 mode;
+
+
+	switch (speed) {
+	case XFER_UDMA_6:
+		mode = ATP867X_IO_DMAMODE_UDMA_6;
+		break;
+	case XFER_UDMA_5:
+		mode = ATP867X_IO_DMAMODE_UDMA_5;
+		break;
+	case XFER_UDMA_4:
+		mode = ATP867X_IO_DMAMODE_UDMA_4;
+		break;
+	case XFER_UDMA_3:
+		mode = ATP867X_IO_DMAMODE_UDMA_3;
+		break;
+	case XFER_UDMA_2:
+		mode = ATP867X_IO_DMAMODE_UDMA_2;
+		break;
+	case XFER_UDMA_1:
+		mode = ATP867X_IO_DMAMODE_UDMA_1;
+		break;
+	case XFER_UDMA_0:
+		mode = ATP867X_IO_DMAMODE_UDMA_0;
+		break;
+	default:
+		printk(KERN_WARNING "ATP867X: Unsupported speed %#x."
+			" Default to XFER_UDMA_0.\n", (unsigned)speed);
+		mode = ATP867X_IO_DMAMODE_UDMA_0;
+	}
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
+	b = inb(dp->dma_mode);
+	if (adev->devno & 1) {
+		b = (b & ~ATP867X_IO_DMAMODE_SLAVE_MASK) |
+			(mode << ATP867X_IO_DMAMODE_SLAVE_SHIFT);
+	} else {
+		b = (b & ~ATP867X_IO_DMAMODE_MSTR_MASK) |
+			(mode << ATP867X_IO_DMAMODE_MSTR_SHIFT);
+	}
+	outb(b, dp->dma_mode);
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
+	UT = T/4;
+
+	switch (speed) {
+	case XFER_PIO_4:
+	case XFER_PIO_3:
+	case XFER_PIO_2:
+	case XFER_PIO_1:
+	case XFER_PIO_0:
+	case XFER_PIO_SLOW:
+		break;
+	default:
+		printk(KERN_WARNING "ATP867X: Unsupported speed %#x."
+			" Default to XFER_PIO_0.\n", (unsigned)speed);
+		speed = XFER_PIO_0;
+	}
+
+	ata_timing_compute(adev, speed, &t, T, UT);
+	if (peer && peer->pio_mode) {
+		ata_timing_compute(peer, peer->pio_mode, &p, T, UT);
+		ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
+	}
+
+	b = inb(dp->dma_mode);
+	if (adev->devno & 1)
+		b = (b & ~ATP867X_IO_DMAMODE_SLAVE_MASK);
+	else
+		b = (b & ~ATP867X_IO_DMAMODE_MSTR_MASK);
+	outb(b, dp->dma_mode);
+
+	b = atp867x_get_active_clocks_shifted(t.active) |
+		atp867x_get_recover_clocks_shifted(t.recover);
+	if (dp->pci66mhz)
+		b += 0x10;
+
+	if (adev->devno & 1)
+		outb(b, dp->slave_piospd);
+	else
+		outb(b, dp->mstr_piospd);
+
+	/*
+	 * use the same value for comand timing as for PIO timimg
+	 */
+	outb(b, dp->eightb_piospd);
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
+static void atp867x_check_ports(struct ata_port *ap, struct pci_dev *pdev)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	struct atp867x_priv *dp = ap->private_data;
+	int port = ap->port_no;
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
+		"  dp->eightb_piospd	=0x%llx\n",
+		port,
+		(unsigned long long)ioaddr->cmd_addr,
+			ATP867X_IO_PORTBASE(pdev, port),
+		(unsigned long long)ioaddr->ctl_addr,
+			ATP867X_IO_ALTSTATUS(pdev, port),
+		(unsigned long long)ioaddr->bmdma_addr,
+			ATP867X_IO_DMABASE(pdev, port),
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
+		(unsigned long long)dp->eightb_piospd);
+}
+#endif
+
+static inline void atp867x_get_ports(struct pci_dev *dev, unsigned int port,
+	unsigned long *base, unsigned long *control)
+{
+	*base = ATP867X_IO_PORTBASE(dev, port);
+	*control = ATP867X_IO_ALTSTATUS(dev, port);
+}
+
+static inline unsigned long atp867x_get_dma_base(struct pci_dev *dev,
+	unsigned int port)
+{
+	return ATP867X_IO_DMABASE(dev, port);
+}
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
+	dp->dma_mode	 = ATP867X_IO_DMAMODE(pdev, port);
+	dp->mstr_piospd	 = ATP867X_IO_MSTRPIOSPD(pdev, port);
+	dp->slave_piospd = ATP867X_IO_SLAVPIOSPD(pdev, port);
+	dp->eightb_piospd = ATP867X_IO_8BPIOSPD(pdev, port);
+
+	dp->pci66mhz = inb(ATP867X_SYS_INFO(pdev)) & ATP867X_IO_SYS_INFO_66MHZ;
+
+	return 0;
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
+		unsigned long base, control, dmabase;
+		struct ata_port *ap = host->ports[i];
+		struct ata_ioports *ioaddr = &ap->ioaddr;
+
+		atp867x_get_ports(pdev, i, &base, &control);
+		dmabase = atp867x_get_dma_base(pdev, i);
+
+		ioaddr->cmd_addr = devm_ioport_map(gdev, base, 8);
+		ioaddr->ctl_addr = ioaddr->altstatus_addr =
+				devm_ioport_map(gdev, control, 1);
+		ioaddr->bmdma_addr = devm_ioport_map(gdev, dmabase, 8);
+
+		ata_sff_std_ports(ioaddr);
+		rc = atp867x_set_priv(ap);
+		if (rc)
+			return rc;
+
+#ifdef	ATP867X_DEBUG
+		atp867x_check_ports(ap, pdev);
+#endif
+		ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", base, control);
+		ata_port_desc(ap, "bmdma 0x%lx", dmabase);
+
+		mask |= 1 << i;
+	}
+
+	if (!mask) {
+		dev_printk(KERN_ERR, gdev, "no available native port\n");
+		return -ENODEV;
+	}
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
+	int i, rc;
+	u8 v;
+
+	if (!printed_version++)
+		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
+
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
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
+		outw(ATP867X_IO_PORTSPEED_VAL, ATP867X_IO_PORTSPEED(pdev, i));
+
+	/*
+	 * init PreREAD counts
+	 */
+	for (i = 0; i < ATP867X_NUM_PORTS; i++)
+		outw(ATP867X_PREREAD_VAL, ATP867X_IO_PREREAD(pdev, i));
+
+	v = inb(ATP867X_IOBASE(pdev) + 0x28);
+	v &= 0xcf;	/* Enable INTA#: bit4=0 means enable */
+	v |= 0xc0;	/* Enable PCI burst, MRM & not immediate interrupts */
+	outb(v, ATP867X_IOBASE(pdev) + 0x28);
+
+	/*
+	 * Turn off the over clocked udma5 mode, only for Rev-B
+	 */
+	v = inb(ATP867X_SYS_INFO(pdev));
+	v &= ATP867X_IO_SYS_MASK_RESERVED;
+	if (pdev->device == PCI_DEVICE_ID_ARTOP_ATP867B)
+		v |= ATP867X_IO_SYS_INFO_SLOW_UDMA5;
+	outb(v, ATP867X_SYS_INFO(pdev));
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
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 73b46b6..1de1fab 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1521,6 +1521,8 @@
 #define PCI_DEVICE_ID_ARTOP_ATP860R	0x0007
 #define PCI_DEVICE_ID_ARTOP_ATP865	0x0008
 #define PCI_DEVICE_ID_ARTOP_ATP865R	0x0009
+#define PCI_DEVICE_ID_ARTOP_ATP867A	0x000A
+#define PCI_DEVICE_ID_ARTOP_ATP867B	0x000B
 #define PCI_DEVICE_ID_ARTOP_AEC7610	0x8002
 #define PCI_DEVICE_ID_ARTOP_AEC7612UW	0x8010
 #define PCI_DEVICE_ID_ARTOP_AEC7612U	0x8020
