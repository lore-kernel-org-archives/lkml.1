Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbXLMHt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbXLMHt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761590AbXLMHtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:49:11 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:60600 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759759AbXLMHtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:49:04 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, paulus@samba.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 2/3] Add the RapidIO support to powerpc architecture with memory mapping support.
Date: Thu, 13 Dec 2007 15:58:17 +0800
Message-Id: <11975327073961-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11975327031199-git-send-email-wei.zhang@freescale.com>
References: <11975326982876-git-send-email-wei.zhang@freescale.com>
 <11975327031199-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 13 Dec 2007 07:48:29.0468 (UTC) FILETIME=[8D29EDC0:01C83D5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds the RapidIO support to powerpc with of-device support.
New Serial RapidIO of new Freescale processor, such as MPC8548, MPC8568,
is also added. The memory mapping API and simple Bitmap allocation are
added. Some bugs are fixed.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/Kconfig                |   12 +
 arch/powerpc/platforms/85xx/Kconfig |    1 +
 arch/powerpc/platforms/86xx/Kconfig |    1 +
 arch/powerpc/sysdev/Makefile        |    1 +
 arch/powerpc/sysdev/fsl_rio.c       | 1130 ++++++++++++++++++++++++++---------
 drivers/rapidio/Kconfig             |   18 +-
 drivers/rapidio/Makefile            |    1 +
 drivers/rapidio/rio-access.c        |   10 +-
 drivers/rapidio/rio-scan.c          |   53 ++-
 drivers/rapidio/rio-sysfs.c         |    3 +-
 drivers/rapidio/rio.c               |  486 +++++++++++++++-
 drivers/rapidio/rio.h               |    9 +-
 drivers/rapidio/sallocator/Kconfig  |    9 +
 drivers/rapidio/sallocator/Makefile |   12 +
 drivers/rapidio/sallocator/bitmap.c |  383 ++++++++++++
 include/linux/rio.h                 |   71 ++-
 include/linux/rio_drv.h             |   41 ++-
 17 files changed, 1900 insertions(+), 341 deletions(-)
 create mode 100644 drivers/rapidio/sallocator/Kconfig
 create mode 100644 drivers/rapidio/sallocator/Makefile
 create mode 100644 drivers/rapidio/sallocator/bitmap.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 18f397c..ee27b77 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -523,6 +523,18 @@ source "drivers/pci/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
+config FSL_RAPIDIO
+	bool
+	default n
+
+config RAPIDIO
+	bool "RapidIO support" if FSL_RAPIDIO
+	help
+	  If you say Y here, the kernel will include drivers and
+	  infrastructure code to support RapidIO interconnect devices.
+
+source "drivers/rapidio/Kconfig"
+
 source "drivers/pci/hotplug/Kconfig"
 
 endmenu
diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index 7748a3a..09c522d 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -56,6 +56,7 @@ config MPC85xx
 	select PPC_UDBG_16550
 	select PPC_INDIRECT_PCI if PCI
 	select MPIC
+	select FSL_RAPIDIO
 	select FSL_PCI if PCI
 	select SERIAL_8250_SHARE_IRQ if SERIAL_8250
 	default y if MPC8540_ADS || MPC85xx_CDS || MPC8560_ADS \
diff --git a/arch/powerpc/platforms/86xx/Kconfig b/arch/powerpc/platforms/86xx/Kconfig
index 21d1135..a6a6593 100644
--- a/arch/powerpc/platforms/86xx/Kconfig
+++ b/arch/powerpc/platforms/86xx/Kconfig
@@ -24,6 +24,7 @@ config MPC8641
 	select FSL_PCI if PCI
 	select PPC_UDBG_16550
 	select MPIC
+	select FSL_RAPIDIO
 	default y if MPC8641_HPCN
 
 config MPC8610
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index 99a77d7..073d197 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_U3_DART)		+= dart_iommu.o
 obj-$(CONFIG_MMIO_NVRAM)	+= mmio_nvram.o
 obj-$(CONFIG_FSL_SOC)		+= fsl_soc.o
 obj-$(CONFIG_FSL_PCI)		+= fsl_pci.o
+obj-$(CONFIG_FSL_RAPIDIO)	+= fsl_rio.o
 obj-$(CONFIG_TSI108_BRIDGE)	+= tsi108_pci.o tsi108_dev.o
 obj-$(CONFIG_QUICC_ENGINE)	+= qe_lib/
 obj-$(CONFIG_PPC_BESTCOMM)	+= bestcomm/
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index af2425e..525066c 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1,5 +1,8 @@
 /*
- * MPC85xx RapidIO support
+ * Freescale PowerPC RapidIO support
+ *
+ * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ * Zhang Wei <wei.zhang@freescale.com>, Jun 2007
  *
  * Copyright 2005 MontaVista Software, Inc.
  * Matt Porter <mporter@kernel.crashing.org>
@@ -8,6 +11,13 @@
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
+ *
+ * Changelog:
+ * Jun 2007 Zhang Wei <wei.zhang@freescale.com>
+ * - This file is moved from arch/ppc/ppc85xx_rio.c. And the OF-tree support
+ *   is added. New silicons such as MPC8548, MPC8641 are all supported.
+ *   Memory driver hardware operations are added.
+ *
  */
 
 #include <linux/init.h>
@@ -17,14 +27,41 @@
 #include <linux/interrupt.h>
 #include <linux/rio.h>
 #include <linux/rio_drv.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
 
 #include <asm/io.h>
+#include <asm/prom.h>
+#include "fsl_soc.h"
+
+/* RapidIO definition irq, which read from OF-tree */
+#define IRQ_RIO_BELL(m)		(((struct rio_priv *)(m->priv))->bellirq)
+#define IRQ_RIO_TX(m)		(((struct rio_priv *)(m->priv))->txirq)
+#define IRQ_RIO_RX(m)		(((struct rio_priv *)(m->priv))->rxirq)
+
+#define ERR(fmt, arg...) \
+	printk(KERN_ERR "RIO %s: " fmt, __FUNCTION__, ## arg)
+#define INFO(fmt...) printk(KERN_INFO "RIO: " fmt)
+#define IS_64BIT_RES ((sizeof(resource_size_t) == 8) ? 1 : 0)
 
-#define RIO_REGS_BASE		(CCSRBAR + 0xc0000)
 #define RIO_ATMU_REGS_OFFSET	0x10c00
-#define RIO_MSG_REGS_OFFSET	0x11000
+#define RIO_P_MSG_REGS_OFFSET	0x11000
+#define RIO_S_MSG_REGS_OFFSET	0x13000
+#define RIO_ESCSR		0x158
+#define RIO_CCSR		0x15c
+#define RIO_ISR_AACR		0x10120
+#define RIO_ISR_AACR_AA		0x1	/* Accept All ID */
 #define RIO_MAINT_WIN_SIZE	0x400000
 #define RIO_DBELL_WIN_SIZE	0x1000
+#define RIO_MAX_INB_ATMU	4
+#define RIO_MAX_OUTB_ATMU	8
+#define RIO_INB_ATMU_REGS_OFFSET	0x10de0
+#define RIO_ATMU_EN_MASK	0x80000000
+
+#define RIO_NREAD		0x4
+#define RIO_NWRITE		0x4
+#define RIO_NWRITE_R		0x5
+#define RIO_NREAD_R		0x5
 
 #define RIO_MSG_OMR_MUI		0x00000002
 #define RIO_MSG_OSR_TE		0x00000080
@@ -50,24 +87,33 @@
 #define DOORBELL_DSR_TE		0x00000080
 #define DOORBELL_DSR_QFI	0x00000010
 #define DOORBELL_DSR_DIQI	0x00000001
-#define DOORBELL_TID_OFFSET	0x03
-#define DOORBELL_SID_OFFSET	0x05
+#define DOORBELL_TID_OFFSET	0x02
+#define DOORBELL_SID_OFFSET	0x04
 #define DOORBELL_INFO_OFFSET	0x06
 
 #define DOORBELL_MESSAGE_SIZE	0x08
-#define DBELL_SID(x)		(*(u8 *)(x + DOORBELL_SID_OFFSET))
-#define DBELL_TID(x)		(*(u8 *)(x + DOORBELL_TID_OFFSET))
+#define DBELL_SID(x)		(*(u16 *)(x + DOORBELL_SID_OFFSET))
+#define DBELL_TID(x)		(*(u16 *)(x + DOORBELL_TID_OFFSET))
 #define DBELL_INF(x)		(*(u16 *)(x + DOORBELL_INFO_OFFSET))
 
 struct rio_atmu_regs {
 	u32 rowtar;
-	u32 pad1;
+	u32 rowtear;
 	u32 rowbar;
 	u32 pad2;
 	u32 rowar;
 	u32 pad3[3];
 };
 
+struct rio_inb_atmu_regs {
+	u32 riwtar;
+	u32 pad1;
+	u32 riwbar;
+	u32 pad2;
+	u32 riwar;
+	u32 pad3[3];
+};
+
 struct rio_msg_regs {
 	u32 omr;
 	u32 osr;
@@ -87,7 +133,15 @@ struct rio_msg_regs {
 	u32 ifqdpar;
 	u32 pad6;
 	u32 ifqepar;
-	u32 pad7[250];
+	u32 pad7[226];
+	u32 odmr;
+	u32 odsr;
+	u32 res0[4];
+	u32 oddpr;
+	u32 oddatr;
+	u32 res1[3];
+	u32 odretcr;
+	u32 res2[12];
 	u32 dmr;
 	u32 dsr;
 	u32 pad8;
@@ -112,20 +166,12 @@ struct rio_tx_desc {
 	u32 res4;
 };
 
-static u32 regs_win;
-static struct rio_atmu_regs *atmu_regs;
-static struct rio_atmu_regs *maint_atmu_regs;
-static struct rio_atmu_regs *dbell_atmu_regs;
-static u32 dbell_win;
-static u32 maint_win;
-static struct rio_msg_regs *msg_regs;
-
-static struct rio_dbell_ring {
+struct rio_dbell_ring {
 	void *virt;
 	dma_addr_t phys;
-} dbell_ring;
+};
 
-static struct rio_msg_tx_ring {
+struct rio_msg_tx_ring {
 	void *virt;
 	dma_addr_t phys;
 	void *virt_buffer[RIO_MAX_TX_RING_SIZE];
@@ -133,77 +179,110 @@ static struct rio_msg_tx_ring {
 	int tx_slot;
 	int size;
 	void *dev_id;
-} msg_tx_ring;
+};
 
-static struct rio_msg_rx_ring {
+struct rio_msg_rx_ring {
 	void *virt;
 	dma_addr_t phys;
 	void *virt_buffer[RIO_MAX_RX_RING_SIZE];
 	int rx_slot;
 	int size;
 	void *dev_id;
-} msg_rx_ring;
+};
+
+struct rio_priv {
+	volatile void __iomem *regs_win;
+	volatile struct rio_atmu_regs __iomem *atmu_regs;
+	volatile struct rio_atmu_regs __iomem *maint_atmu_regs;
+	volatile struct rio_atmu_regs __iomem *dbell_atmu_regs;
+	volatile void __iomem *dbell_win;
+	volatile void __iomem *maint_win;
+	volatile struct rio_msg_regs __iomem *msg_regs;
+	struct rio_dbell_ring dbell_ring;
+	struct rio_msg_tx_ring msg_tx_ring;
+	struct rio_msg_rx_ring msg_rx_ring;
+	int bellirq;
+	int txirq;
+	int rxirq;
+};
 
 /**
- * mpc85xx_rio_doorbell_send - Send a MPC85xx doorbell message
+ * fsl_rio_doorbell_send - Send a RapidIO doorbell message
  * @index: ID of RapidIO interface
  * @destid: Destination ID of target device
  * @data: 16-bit info field of RapidIO doorbell message
  *
- * Sends a MPC85xx doorbell message. Returns %0 on success or
+ * Sends a RapidIO doorbell message. Returns %0 on success or
  * %-EINVAL on failure.
  */
-static int mpc85xx_rio_doorbell_send(int index, u16 destid, u16 data)
+static int fsl_rio_doorbell_send(struct rio_mport *mport, int index, u16 destid, u16 data)
 {
-	pr_debug("mpc85xx_doorbell_send: index %d destid %4.4x data %4.4x\n",
-		 index, destid, data);
-	out_be32((void *)&dbell_atmu_regs->rowtar, destid << 22);
-	out_be16((void *)(dbell_win), data);
+	struct rio_priv *priv = mport->priv;
+	pr_debug("fsl_doorbell_send: index %d destid 0x%04x data 0x%04x\n",
+			index, destid, data);
+
+	switch (mport->phy_type) {
+	case RIO_PHY_SERIAL:
+		/* In the later version silicons, such as MPC8548, MPC8641,
+		 * below operations is must be.
+		 */
+		out_be32(&priv->msg_regs->odmr, 0x00000000);
+		out_be32(&priv->msg_regs->odretcr, 0x00000004);
+		out_be32(&priv->msg_regs->oddpr, destid << 16);
+		out_be32(&priv->msg_regs->oddatr,data );
+		out_be32(&priv->msg_regs->odmr, 0x00000001);
+		break;
+	case RIO_PHY_PARALLEL:
+		out_be32(&priv->dbell_atmu_regs->rowtar, destid << 22);
+		out_be16(priv->dbell_win, data);
+		break;
+	}
 
 	return 0;
 }
 
 /**
- * mpc85xx_local_config_read - Generate a MPC85xx local config space read
+ * fsl_local_config_read - Generate a RapidIO local config space read
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
  * @data: Value to be read into
  *
- * Generates a MPC85xx local configuration space read. Returns %0 on
+ * Generates a RapidIO local configuration space read. Returns %0 on
  * success or %-EINVAL on failure.
  */
-static int mpc85xx_local_config_read(int index, u32 offset, int len, u32 * data)
+static int fsl_local_config_read(struct rio_mport *mport, int index, u32 offset, int len, u32 * data)
 {
-	pr_debug("mpc85xx_local_config_read: index %d offset %8.8x\n", index,
-		 offset);
-	*data = in_be32((void *)(regs_win + offset));
+	struct rio_priv *priv = mport->priv;
+	pr_debug("fsl_local_config_read: index %d offset 0x%08x\n", index,
+			offset);
+	*data = in_be32(priv->regs_win + offset);
 
 	return 0;
 }
 
 /**
- * mpc85xx_local_config_write - Generate a MPC85xx local config space write
+ * fsl_local_config_write - Generate a RapidIO local config space write
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
  * @data: Value to be written
  *
- * Generates a MPC85xx local configuration space write. Returns %0 on
+ * Generates a RapidIO local configuration space write. Returns %0 on
  * success or %-EINVAL on failure.
  */
-static int mpc85xx_local_config_write(int index, u32 offset, int len, u32 data)
+static int fsl_local_config_write(struct rio_mport *mport, int index, u32 offset, int len, u32 data)
 {
-	pr_debug
-	    ("mpc85xx_local_config_write: index %d offset %8.8x data %8.8x\n",
-	     index, offset, data);
-	out_be32((void *)(regs_win + offset), data);
+	struct rio_priv *priv = mport->priv;
+	pr_debug("fsl_local_config_write: index %d offset 0x%08x data 0x%08x\n",
+			index, offset, data);
+	out_be32(priv->regs_win + offset, data);
 
 	return 0;
 }
 
 /**
- * mpc85xx_rio_config_read - Generate a MPC85xx read maintenance transaction
+ * fsl_rio_config_read - Generate a read maintenance transaction
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -211,31 +290,33 @@ static int mpc85xx_local_config_write(int index, u32 offset, int len, u32 data)
  * @len: Length (in bytes) of the maintenance transaction
  * @val: Location to be read into
  *
- * Generates a MPC85xx read maintenance transaction. Returns %0 on
+ * Generates a read maintenance transaction. Returns %0 on
  * success or %-EINVAL on failure.
  */
-static int
-mpc85xx_rio_config_read(int index, u16 destid, u8 hopcount, u32 offset, int len,
-			u32 * val)
+static int fsl_rio_config_read(struct rio_mport *mport, int index, u16 destid,
+		u8 hopcount, u32 offset, int len, u32 * val)
 {
-	u8 *data;
-
-	pr_debug
-	    ("mpc85xx_rio_config_read: index %d destid %d hopcount %d offset %8.8x len %d\n",
-	     index, destid, hopcount, offset, len);
-	out_be32((void *)&maint_atmu_regs->rowtar,
-		 (destid << 22) | (hopcount << 12) | ((offset & ~0x3) >> 9));
-
-	data = (u8 *) maint_win + offset;
+	volatile void __iomem *data;
+	struct rio_priv *priv = mport->priv;
+
+	pr_debug("fsl_rio_config_read: index %d destid %d hopcount %d "
+			"offset 0x%08x len %d\n",
+			index, destid, hopcount, offset, len);
+	out_be32(&priv->maint_atmu_regs->rowtar,
+		 ((destid & 0x3ff) << 22) | (hopcount << 12)
+		 | ((offset & ~0x3) >> 9));
+	out_be32(&priv->maint_atmu_regs->rowtear, (destid & 0xfc00) >> 10);
+
+	data = priv->maint_win + offset;
 	switch (len) {
 	case 1:
-		*val = in_8((u8 *) data);
+		*val = in_8(data);
 		break;
 	case 2:
-		*val = in_be16((u16 *) data);
+		*val = in_be16(data);
 		break;
 	default:
-		*val = in_be32((u32 *) data);
+		*val = in_be32(data);
 		break;
 	}
 
@@ -243,7 +324,7 @@ mpc85xx_rio_config_read(int index, u16 destid, u8 hopcount, u32 offset, int len,
 }
 
 /**
- * mpc85xx_rio_config_write - Generate a MPC85xx write maintenance transaction
+ * fsl_rio_config_write - Generate a write maintenance transaction
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -251,30 +332,32 @@ mpc85xx_rio_config_read(int index, u16 destid, u8 hopcount, u32 offset, int len,
  * @len: Length (in bytes) of the maintenance transaction
  * @val: Value to be written
  *
- * Generates an MPC85xx write maintenance transaction. Returns %0 on
+ * Generates an write maintenance transaction. Returns %0 on
  * success or %-EINVAL on failure.
  */
-static int
-mpc85xx_rio_config_write(int index, u16 destid, u8 hopcount, u32 offset,
-			 int len, u32 val)
+static int fsl_rio_config_write(struct rio_mport *mport, int index, u16 destid,
+		u8 hopcount, u32 offset, int len, u32 val)
 {
-	u8 *data;
-	pr_debug
-	    ("mpc85xx_rio_config_write: index %d destid %d hopcount %d offset %8.8x len %d val %8.8x\n",
-	     index, destid, hopcount, offset, len, val);
-	out_be32((void *)&maint_atmu_regs->rowtar,
-		 (destid << 22) | (hopcount << 12) | ((offset & ~0x3) >> 9));
-
-	data = (u8 *) maint_win + offset;
+	volatile void __iomem *data;
+	struct rio_priv *priv = mport->priv;
+	pr_debug("fsl_rio_config_write: index %d destid %d hopcount %d"
+			"offset 0x%08x len %d val 0x%08x\n",
+			index, destid, hopcount, offset, len, val);
+	out_be32(&priv->maint_atmu_regs->rowtar,
+		 ((destid & 0x3ff) << 22) | (hopcount << 12)
+		 | ((offset & ~0x3) >> 9));
+	out_be32(&priv->maint_atmu_regs->rowtear, (destid & 0xfc00) >> 10);
+
+	data = priv->maint_win + offset;
 	switch (len) {
 	case 1:
-		out_8((u8 *) data, val);
+		out_8(data, val);
 		break;
 	case 2:
-		out_be16((u16 *) data, val);
+		out_be16(data, val);
 		break;
 	default:
-		out_be32((u32 *) data, val);
+		out_be32(data, val);
 		break;
 	}
 
@@ -282,28 +365,204 @@ mpc85xx_rio_config_write(int index, u16 destid, u8 hopcount, u32 offset,
 }
 
 /**
- * rio_hw_add_outb_message - Add message to the MPC85xx outbound message queue
+ * fsl_rio_map_inb_mem -- Mapping inbound memory region.
+ * @lstart: Local memory space start address.
+ * @rstart: RapidIO space start address.
+ * @size: The mapping region size.
+ * @flags: Flags for mapping. 0 for using default flags.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the inbound mapping
+ * from rstart to lstart.
+ */
+static int fsl_rio_map_inb_mem(struct rio_mport *mport, resource_size_t lstart,
+		resource_size_t rstart,	resource_size_t size,
+		u32 flags)
+{
+	int i;
+	struct rio_priv *priv = mport->priv;
+	volatile struct rio_inb_atmu_regs __iomem *inbatmu =
+				(struct rio_inb_atmu_regs *)
+				(priv->regs_win + RIO_INB_ATMU_REGS_OFFSET) - 1;
+	int size_ffs;
+	resource_size_t align;
+
+	if (flags == 0)
+		flags = (RIO_NREAD_R << 4) | RIO_NWRITE_R;
+
+	align = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* Align the size */
+	if ((lstart + size) > (_ALIGN_DOWN(lstart, align) + align)) {
+		size_ffs = __ffs(_ALIGN_DOWN(lstart + size - 1, align));
+		size = 1 << (size_ffs +	(((_ALIGN_DOWN(lstart, 1 << size_ffs) +
+				(1 << size_ffs)) < (lstart + size)) ? 1 : 0));
+	} else
+		size = align;
+
+	if ((lstart & (size - 1)) != (rstart & (size - 1))) {
+		ERR("The local address 0x%x can not be aligned to the same size"
+			" 0x%x with the RapidIO space address 0x%x!\n", lstart,
+			size, rstart);
+		return -EINVAL;
+	}
+
+	/* Search for free inbound ATMU */
+	for (i = 1;
+		(i <= RIO_MAX_INB_ATMU) && (inbatmu->riwar & RIO_ATMU_EN_MASK);
+		i++, inbatmu--)
+		;
+
+	if (i > RIO_MAX_INB_ATMU) {
+		ERR("No free inbound ATMU!\n");
+		return -EBUSY;
+	}
+	out_be32(&inbatmu->riwtar, ((IS_64BIT_RES ? (lstart >> 32)
+				& 0xf : 0) << 20) | ((lstart >> 12) & 0xfffff));
+	out_be32(&inbatmu->riwbar, ((IS_64BIT_RES ? (rstart >> 32)
+				& 0x3 : 0) << 20) | ((rstart >> 12) & 0xfffff));
+	out_be32(&inbatmu->riwar, 0x80000000 | (0xf << 20)
+				| ((flags & 0xff) << 12)
+				| (__ilog2(size) - 1));
+	return 0;
+}
+
+/**
+ * fsl_rio_map_outb_mem -- Mapping outbound memory region.
+ * @lstart: Local memory space start address.
+ * @rstart: RapidIO space start address.
+ * @size: The mapping region size.
+ * @tid: The target RapidIO device id.
+ * @flags: Flags for mapping. 0 for using default flags.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the outbound mapping
+ * from lstart to rstart.
+ */
+static int fsl_rio_map_outb_mem(struct rio_mport *mport, resource_size_t lstart,
+		resource_size_t rstart,	resource_size_t size,
+		u16 tid, u32 flags)
+{
+	int i;
+	struct rio_priv *priv = mport->priv;
+	volatile struct rio_atmu_regs __iomem *outbatmu =
+			(struct rio_atmu_regs *)
+			(priv->regs_win + RIO_ATMU_REGS_OFFSET) + 1;
+	int size_ffs;
+	resource_size_t align;
+
+	if (flags == 0)
+		flags = (RIO_NREAD << 4) | RIO_NWRITE_R;
+
+	align = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* Align the size */
+	if ((lstart + size) > (_ALIGN_DOWN(lstart, align) + align)) {
+		size_ffs = __ffs(_ALIGN_DOWN(lstart + size - 1, align));
+		size = 1 << (size_ffs +	(((_ALIGN_DOWN(lstart, 1 << size_ffs) +
+				(1 << size_ffs)) < (lstart + size)) ? 1 : 0));
+	} else
+		size = align;
+
+	if ((lstart & (size - 1)) != (rstart & (size - 1))) {
+		ERR("The local address 0x%x can not be aligned to the same size"
+			" 0x%x with the RapidIO space address 0x%x!\n", lstart,
+			size, rstart);
+		return -EINVAL;
+	}
+
+	/* Search for free outbound ATMU */
+	for (i = 1;
+	      (i <= RIO_MAX_OUTB_ATMU) && (outbatmu->rowar & RIO_ATMU_EN_MASK);
+	      i++, outbatmu++)
+		;
+
+	if (i > RIO_MAX_OUTB_ATMU) {
+		ERR("No free outbound ATMU!\n");
+		return -EBUSY;
+	}
+	out_be32(&outbatmu->rowtar, ((tid & 0x3ff) << 22)
+			| ((IS_64BIT_RES ? (rstart >> 32) & 0x3 : 0) << 20)
+			| ((rstart >> 12) & 0xfffff));
+	if (mport->phy_type == RIO_PHY_SERIAL)
+		out_be32(&outbatmu->rowtear, tid >> 10);
+	out_be32(&outbatmu->rowbar, ((IS_64BIT_RES ?
+					(lstart >> 32) & 0xf : 0) << 20)
+					| ((lstart >> 12) & 0xfffff));
+	out_be32(&outbatmu->rowar, 0x80000000
+				| ((flags & 0xff) << 12)
+				| (__ilog2(size) - 1));
+	return 0;
+}
+
+/**
+ * fsl_rio_unmap_inb_mem -- Unmapping inbound memory region.
+ * @lstart: Local memory space start address.
+ */
+static void fsl_rio_unmap_inb_mem(struct rio_mport *mport, resource_size_t lstart)
+{
+	int i;
+	struct rio_priv *priv = mport->priv;
+	volatile struct rio_inb_atmu_regs __iomem *inbatmu = (struct rio_inb_atmu_regs *)
+			(priv->regs_win + RIO_INB_ATMU_REGS_OFFSET) - 1;
+
+	/* Search for inbound ATMU */
+	for (i = 1; i <= RIO_MAX_INB_ATMU ; i++, inbatmu--) {
+		u32 tar = ((IS_64BIT_RES ? (lstart >> 32) & 0xf : 0) << 20)
+			| ((lstart >> 12) & 0xfffff);
+		if (inbatmu->riwtar == tar) {
+			out_be32(&inbatmu->riwar, ~(RIO_ATMU_EN_MASK));
+			return;
+		}
+	}
+}
+
+/**
+ * fsl_rio_unmap_inb_mem -- Unmapping outbound memory region.
+ * @lstart: Local memory space start address.
+ */
+static void fsl_rio_unmap_outb_mem(struct rio_mport *mport, resource_size_t lstart)
+{
+	int i;
+	struct rio_priv *priv = mport->priv;
+	volatile struct rio_atmu_regs __iomem *outbatmu = (struct rio_atmu_regs *)
+			(priv->regs_win + RIO_ATMU_REGS_OFFSET) + 1;
+
+	/* Search for outbound ATMU */
+	for (i = 1; i <= RIO_MAX_OUTB_ATMU ; i++, outbatmu++) {
+		u32 bar = ((IS_64BIT_RES ? (lstart >> 32) & 0xf : 0) << 20)
+			| ((lstart >> 12) & 0xfffff);
+		if (outbatmu->rowbar == bar) {
+			out_be32(&outbatmu->rowar, ~(RIO_ATMU_EN_MASK));
+			return;
+		}
+	}
+}
+
+/**
+ * rio_hw_add_outb_message - Add message to the outbound message queue
  * @mport: Master port with outbound message queue
  * @rdev: Target of outbound message
  * @mbox: Outbound mailbox
  * @buffer: Message to add to outbound queue
  * @len: Length of message
  *
- * Adds the @buffer message to the MPC85xx outbound message queue. Returns
+ * Adds the @buffer message to the outbound message queue. Returns
  * %0 on success or %-EINVAL on failure.
  */
-int
-rio_hw_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
-			void *buffer, size_t len)
+int rio_hw_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev,
+		int mbox, void *buffer, size_t len)
 {
-	u32 omr;
+	struct rio_priv *priv = mport->priv;
 	struct rio_tx_desc *desc =
-	    (struct rio_tx_desc *)msg_tx_ring.virt + msg_tx_ring.tx_slot;
+	    (struct rio_tx_desc *)priv->msg_tx_ring.virt + priv->msg_tx_ring.tx_slot;
 	int ret = 0;
 
-	pr_debug
-	    ("RIO: rio_hw_add_outb_message(): destid %4.4x mbox %d buffer %8.8x len %8.8x\n",
-	     rdev->destid, mbox, (int)buffer, len);
+	pr_debug("RIO: rio_hw_add_outb_message(): "
+			"destid 0x%04x mbox %d buffer %p len 0x%08x\n",
+			rdev->destid, mbox, buffer, len);
 
 	if ((len < 8) || (len > RIO_MAX_MSG_SIZE)) {
 		ret = -EINVAL;
@@ -311,31 +570,40 @@ rio_hw_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 	}
 
 	/* Copy and clear rest of buffer */
-	memcpy(msg_tx_ring.virt_buffer[msg_tx_ring.tx_slot], buffer, len);
+	memcpy(priv->msg_tx_ring.virt_buffer[priv->msg_tx_ring.tx_slot], buffer, len);
 	if (len < (RIO_MAX_MSG_SIZE - 4))
-		memset((void *)((u32) msg_tx_ring.
-				virt_buffer[msg_tx_ring.tx_slot] + len), 0,
-		       RIO_MAX_MSG_SIZE - len);
+		memset(priv->msg_tx_ring.virt_buffer[priv->msg_tx_ring.tx_slot]
+				+ len, 0, RIO_MAX_MSG_SIZE - len);
 
-	/* Set mbox field for message */
-	desc->dport = mbox & 0x3;
+	switch(mport->phy_type) {
+	case RIO_PHY_SERIAL:
+		/* Set mbox field for message, and set destid */
+		desc->dport = (rdev->destid << 16) | ( mbox & 0x3);
 
-	/* Enable EOMI interrupt, set priority, and set destid */
-	desc->dattr = 0x28000000 | (rdev->destid << 2);
+		/* Enable EOMI interrupt and priority */
+		desc->dattr = 0x28000000;
+
+		/* Set mbox field for message */
+		desc->dport = mbox & 0x3;
+		break;
+	case RIO_PHY_PARALLEL:
+		/* Enable EOMI interrupt, set priority, and set destid */
+		desc->dattr = 0x28000000 | (rdev->destid << 2);
+		break;
+	}
 
 	/* Set transfer size aligned to next power of 2 (in double words) */
 	desc->dwcnt = is_power_of_2(len) ? len : 1 << get_bitmask_order(len);
 
 	/* Set snooping and source buffer address */
-	desc->saddr = 0x00000004 | msg_tx_ring.phys_buffer[msg_tx_ring.tx_slot];
+	desc->saddr = 0x00000004 | priv->msg_tx_ring.phys_buffer[priv->msg_tx_ring.tx_slot];
 
 	/* Increment enqueue pointer */
-	omr = in_be32((void *)&msg_regs->omr);
-	out_be32((void *)&msg_regs->omr, omr | RIO_MSG_OMR_MUI);
+	setbits32(&priv->msg_regs->omr, RIO_MSG_OMR_MUI);
 
 	/* Go to next descriptor */
-	if (++msg_tx_ring.tx_slot == msg_tx_ring.size)
-		msg_tx_ring.tx_slot = 0;
+	if (++priv->msg_tx_ring.tx_slot == priv->msg_tx_ring.size)
+		priv->msg_tx_ring.tx_slot = 0;
 
       out:
 	return ret;
@@ -344,40 +612,40 @@ rio_hw_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 EXPORT_SYMBOL_GPL(rio_hw_add_outb_message);
 
 /**
- * mpc85xx_rio_tx_handler - MPC85xx outbound message interrupt handler
+ * fsl_rio_tx_handler - outbound message interrupt handler
  * @irq: Linux interrupt number
  * @dev_instance: Pointer to interrupt-specific data
  *
  * Handles outbound message interrupts. Executes a register outbound
- * mailbox event handler and acks the interrupt occurrence.
+ * mailbox event handler and acks the interrupt occurence.
  */
-static irqreturn_t
-mpc85xx_rio_tx_handler(int irq, void *dev_instance)
+static irqreturn_t fsl_rio_tx_handler(int irq, void *dev_instance)
 {
 	int osr;
 	struct rio_mport *port = (struct rio_mport *)dev_instance;
+	struct rio_priv *priv = port->priv;
 
-	osr = in_be32((void *)&msg_regs->osr);
+	osr = in_be32(&priv->msg_regs->osr);
 
-	if (osr & RIO_MSG_OSR_TE) {
+	if (unlikely(osr & RIO_MSG_OSR_TE)) {
 		pr_info("RIO: outbound message transmission error\n");
-		out_be32((void *)&msg_regs->osr, RIO_MSG_OSR_TE);
+		out_be32(&priv->msg_regs->osr, RIO_MSG_OSR_TE);
 		goto out;
 	}
 
-	if (osr & RIO_MSG_OSR_QOI) {
+	if (unlikely(osr & RIO_MSG_OSR_QOI)) {
 		pr_info("RIO: outbound message queue overflow\n");
-		out_be32((void *)&msg_regs->osr, RIO_MSG_OSR_QOI);
+		out_be32(&priv->msg_regs->osr, RIO_MSG_OSR_QOI);
 		goto out;
 	}
 
 	if (osr & RIO_MSG_OSR_EOMI) {
-		u32 dqp = in_be32((void *)&msg_regs->odqdpar);
-		int slot = (dqp - msg_tx_ring.phys) >> 5;
-		port->outb_msg[0].mcback(port, msg_tx_ring.dev_id, -1, slot);
+		u32 dqp = in_be32(&priv->msg_regs->odqdpar);
+		int slot = (dqp - priv->msg_tx_ring.phys) >> 5;
+		port->outb_msg[0].mcback(port, priv->msg_tx_ring.dev_id, -1, slot);
 
 		/* Ack the end-of-message interrupt */
-		out_be32((void *)&msg_regs->osr, RIO_MSG_OSR_EOMI);
+		out_be32(&priv->msg_regs->osr, RIO_MSG_OSR_EOMI);
 	}
 
       out:
@@ -385,7 +653,7 @@ mpc85xx_rio_tx_handler(int irq, void *dev_instance)
 }
 
 /**
- * rio_open_outb_mbox - Initialize MPC85xx outbound mailbox
+ * rio_open_outb_mbox - Initialize outbound mailbox
  * @mport: Master port implementing the outbound message unit
  * @dev_id: Device specific pointer to pass on event
  * @mbox: Mailbox to open
@@ -398,6 +666,7 @@ mpc85xx_rio_tx_handler(int irq, void *dev_instance)
 int rio_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
 {
 	int i, j, rc = 0;
+	struct rio_priv *priv = mport->priv;
 
 	if ((entries < RIO_MIN_TX_RING_SIZE) ||
 	    (entries > RIO_MAX_TX_RING_SIZE) || (!is_power_of_2(entries))) {
@@ -406,54 +675,54 @@ int rio_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entr
 	}
 
 	/* Initialize shadow copy ring */
-	msg_tx_ring.dev_id = dev_id;
-	msg_tx_ring.size = entries;
+	priv->msg_tx_ring.dev_id = dev_id;
+	priv->msg_tx_ring.size = entries;
 
-	for (i = 0; i < msg_tx_ring.size; i++) {
-		if (!
-		    (msg_tx_ring.virt_buffer[i] =
+	for (i = 0; i < priv->msg_tx_ring.size; i++) {
+		priv->msg_tx_ring.virt_buffer[i] =
 		     dma_alloc_coherent(NULL, RIO_MSG_BUFFER_SIZE,
-					&msg_tx_ring.phys_buffer[i],
-					GFP_KERNEL))) {
+					&priv->msg_tx_ring.phys_buffer[i],
+					GFP_KERNEL);
+		if (!priv->msg_tx_ring.virt_buffer[i]) {
 			rc = -ENOMEM;
-			for (j = 0; j < msg_tx_ring.size; j++)
-				if (msg_tx_ring.virt_buffer[j])
+			for (j = 0; j < priv->msg_tx_ring.size; j++)
+				if (priv->msg_tx_ring.virt_buffer[j])
 					dma_free_coherent(NULL,
 							  RIO_MSG_BUFFER_SIZE,
-							  msg_tx_ring.
+							  priv->msg_tx_ring.
 							  virt_buffer[j],
-							  msg_tx_ring.
+							  priv->msg_tx_ring.
 							  phys_buffer[j]);
 			goto out;
 		}
 	}
 
 	/* Initialize outbound message descriptor ring */
-	if (!(msg_tx_ring.virt = dma_alloc_coherent(NULL,
-						    msg_tx_ring.size *
+	priv->msg_tx_ring.virt = dma_alloc_coherent(NULL,
+						    priv->msg_tx_ring.size *
 						    RIO_MSG_DESC_SIZE,
-						    &msg_tx_ring.phys,
-						    GFP_KERNEL))) {
+						    &priv->msg_tx_ring.phys,
+						    GFP_KERNEL);
+	if (!priv->msg_tx_ring.virt) {
 		rc = -ENOMEM;
 		goto out_dma;
 	}
-	memset(msg_tx_ring.virt, 0, msg_tx_ring.size * RIO_MSG_DESC_SIZE);
-	msg_tx_ring.tx_slot = 0;
+	priv->msg_tx_ring.tx_slot = 0;
 
 	/* Point dequeue/enqueue pointers at first entry in ring */
-	out_be32((void *)&msg_regs->odqdpar, msg_tx_ring.phys);
-	out_be32((void *)&msg_regs->odqepar, msg_tx_ring.phys);
+	out_be32(&priv->msg_regs->odqdpar, priv->msg_tx_ring.phys);
+	out_be32(&priv->msg_regs->odqepar, priv->msg_tx_ring.phys);
 
 	/* Configure for snooping */
-	out_be32((void *)&msg_regs->osar, 0x00000004);
+	out_be32(&priv->msg_regs->osar, 0x00000004);
 
 	/* Clear interrupt status */
-	out_be32((void *)&msg_regs->osr, 0x000000b3);
+	out_be32(&priv->msg_regs->osr, 0x000000b3);
 
 	/* Hook up outbound message handler */
-	if ((rc =
-	     request_irq(MPC85xx_IRQ_RIO_TX, mpc85xx_rio_tx_handler, 0,
-			 "msg_tx", (void *)mport)) < 0)
+	rc = request_irq(IRQ_RIO_TX(mport), fsl_rio_tx_handler, 0, "msg_tx",
+			mport);
+	if (rc < 0)
 		goto out_irq;
 
 	/*
@@ -463,34 +732,33 @@ int rio_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entr
 	 *      Chaining mode
 	 *      Disable
 	 */
-	out_be32((void *)&msg_regs->omr, 0x00100220);
+	out_be32(&priv->msg_regs->omr, 0x00100220);
 
 	/* Set number of entries */
-	out_be32((void *)&msg_regs->omr,
-		 in_be32((void *)&msg_regs->omr) |
+	setbits32(&priv->msg_regs->omr,
 		 ((get_bitmask_order(entries) - 2) << 12));
 
 	/* Now enable the unit */
-	out_be32((void *)&msg_regs->omr, in_be32((void *)&msg_regs->omr) | 0x1);
+	setbits32(&priv->msg_regs->omr, 0x1);
 
       out:
 	return rc;
 
       out_irq:
-	dma_free_coherent(NULL, msg_tx_ring.size * RIO_MSG_DESC_SIZE,
-			  msg_tx_ring.virt, msg_tx_ring.phys);
+	dma_free_coherent(NULL, priv->msg_tx_ring.size * RIO_MSG_DESC_SIZE,
+			  priv->msg_tx_ring.virt, priv->msg_tx_ring.phys);
 
       out_dma:
-	for (i = 0; i < msg_tx_ring.size; i++)
+	for (i = 0; i < priv->msg_tx_ring.size; i++)
 		dma_free_coherent(NULL, RIO_MSG_BUFFER_SIZE,
-				  msg_tx_ring.virt_buffer[i],
-				  msg_tx_ring.phys_buffer[i]);
+				  priv->msg_tx_ring.virt_buffer[i],
+				  priv->msg_tx_ring.phys_buffer[i]);
 
 	return rc;
 }
 
 /**
- * rio_close_outb_mbox - Shut down MPC85xx outbound mailbox
+ * rio_close_outb_mbox - Shut down outbound mailbox
  * @mport: Master port implementing the outbound message unit
  * @mbox: Mailbox to close
  *
@@ -499,36 +767,37 @@ int rio_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entr
  */
 void rio_close_outb_mbox(struct rio_mport *mport, int mbox)
 {
+	struct rio_priv *priv = mport->priv;
 	/* Disable inbound message unit */
-	out_be32((void *)&msg_regs->omr, 0);
+	out_be32(&priv->msg_regs->omr, 0);
 
 	/* Free ring */
-	dma_free_coherent(NULL, msg_tx_ring.size * RIO_MSG_DESC_SIZE,
-			  msg_tx_ring.virt, msg_tx_ring.phys);
+	dma_free_coherent(NULL, priv->msg_tx_ring.size * RIO_MSG_DESC_SIZE,
+			  priv->msg_tx_ring.virt, priv->msg_tx_ring.phys);
 
 	/* Free interrupt */
-	free_irq(MPC85xx_IRQ_RIO_TX, (void *)mport);
+	free_irq(IRQ_RIO_TX(mport), mport);
 }
 
 /**
- * mpc85xx_rio_rx_handler - MPC85xx inbound message interrupt handler
+ * fsl_rio_rx_handler - inbound message interrupt handler
  * @irq: Linux interrupt number
  * @dev_instance: Pointer to interrupt-specific data
  *
  * Handles inbound message interrupts. Executes a registered inbound
- * mailbox event handler and acks the interrupt occurrence.
+ * mailbox event handler and acks the interrupt occurence.
  */
-static irqreturn_t
-mpc85xx_rio_rx_handler(int irq, void *dev_instance)
+static irqreturn_t fsl_rio_rx_handler(int irq, void *dev_instance)
 {
 	int isr;
 	struct rio_mport *port = (struct rio_mport *)dev_instance;
+	struct rio_priv *priv = port->priv;
 
-	isr = in_be32((void *)&msg_regs->isr);
+	isr = in_be32(&priv->msg_regs->isr);
 
-	if (isr & RIO_MSG_ISR_TE) {
+	if (unlikely(isr & RIO_MSG_ISR_TE)) {
 		pr_info("RIO: inbound message reception error\n");
-		out_be32((void *)&msg_regs->isr, RIO_MSG_ISR_TE);
+		out_be32(&priv->msg_regs->isr, RIO_MSG_ISR_TE);
 		goto out;
 	}
 
@@ -540,10 +809,10 @@ mpc85xx_rio_rx_handler(int irq, void *dev_instance)
 		 * make the callback with an unknown/invalid mailbox number
 		 * argument.
 		 */
-		port->inb_msg[0].mcback(port, msg_rx_ring.dev_id, -1, -1);
+		port->inb_msg[0].mcback(port, priv->msg_rx_ring.dev_id, -1, -1);
 
 		/* Ack the queueing interrupt */
-		out_be32((void *)&msg_regs->isr, RIO_MSG_ISR_DIQI);
+		out_be32(&priv->msg_regs->isr, RIO_MSG_ISR_DIQI);
 	}
 
       out:
@@ -551,7 +820,7 @@ mpc85xx_rio_rx_handler(int irq, void *dev_instance)
 }
 
 /**
- * rio_open_inb_mbox - Initialize MPC85xx inbound mailbox
+ * rio_open_inb_mbox - Initialize inbound mailbox
  * @mport: Master port implementing the inbound message unit
  * @dev_id: Device specific pointer to pass on event
  * @mbox: Mailbox to open
@@ -564,6 +833,7 @@ mpc85xx_rio_rx_handler(int irq, void *dev_instance)
 int rio_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
 {
 	int i, rc = 0;
+	struct rio_priv *priv = mport->priv;
 
 	if ((entries < RIO_MIN_RX_RING_SIZE) ||
 	    (entries > RIO_MAX_RX_RING_SIZE) || (!is_power_of_2(entries))) {
@@ -572,36 +842,37 @@ int rio_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entri
 	}
 
 	/* Initialize client buffer ring */
-	msg_rx_ring.dev_id = dev_id;
-	msg_rx_ring.size = entries;
-	msg_rx_ring.rx_slot = 0;
-	for (i = 0; i < msg_rx_ring.size; i++)
-		msg_rx_ring.virt_buffer[i] = NULL;
+	priv->msg_rx_ring.dev_id = dev_id;
+	priv->msg_rx_ring.size = entries;
+	priv->msg_rx_ring.rx_slot = 0;
+	for (i = 0; i < priv->msg_rx_ring.size; i++)
+		priv->msg_rx_ring.virt_buffer[i] = NULL;
 
 	/* Initialize inbound message ring */
-	if (!(msg_rx_ring.virt = dma_alloc_coherent(NULL,
-						    msg_rx_ring.size *
+	priv->msg_rx_ring.virt = dma_alloc_coherent(NULL,
+						    priv->msg_rx_ring.size *
 						    RIO_MAX_MSG_SIZE,
-						    &msg_rx_ring.phys,
-						    GFP_KERNEL))) {
+						    &priv->msg_rx_ring.phys,
+						    GFP_KERNEL);
+	if (!priv->msg_rx_ring.virt) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
 	/* Point dequeue/enqueue pointers at first entry in ring */
-	out_be32((void *)&msg_regs->ifqdpar, (u32) msg_rx_ring.phys);
-	out_be32((void *)&msg_regs->ifqepar, (u32) msg_rx_ring.phys);
+	out_be32(&priv->msg_regs->ifqdpar, (u32) priv->msg_rx_ring.phys);
+	out_be32(&priv->msg_regs->ifqepar, (u32) priv->msg_rx_ring.phys);
 
 	/* Clear interrupt status */
-	out_be32((void *)&msg_regs->isr, 0x00000091);
+	out_be32(&priv->msg_regs->isr, 0x00000091);
 
 	/* Hook up inbound message handler */
-	if ((rc =
-	     request_irq(MPC85xx_IRQ_RIO_RX, mpc85xx_rio_rx_handler, 0,
-			 "msg_rx", (void *)mport)) < 0) {
+	rc = request_irq(IRQ_RIO_RX(mport), fsl_rio_rx_handler, 0,
+			 "msg_rx", mport);
+	if (rc < 0) {
 		dma_free_coherent(NULL, RIO_MSG_BUFFER_SIZE,
-				  msg_tx_ring.virt_buffer[i],
-				  msg_tx_ring.phys_buffer[i]);
+				  priv->msg_tx_ring.virt_buffer[i],
+				  priv->msg_tx_ring.phys_buffer[i]);
 		goto out;
 	}
 
@@ -612,22 +883,21 @@ int rio_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entri
 	 *      Unmask all interrupt sources
 	 *      Disable
 	 */
-	out_be32((void *)&msg_regs->imr, 0x001b0060);
+	out_be32(&priv->msg_regs->imr, 0x001b0060);
 
 	/* Set number of queue entries */
-	out_be32((void *)&msg_regs->imr,
-		 in_be32((void *)&msg_regs->imr) |
-		 ((get_bitmask_order(entries) - 2) << 12));
+	setbits32(&priv->msg_regs->imr,
+			((get_bitmask_order(entries) - 2) << 12));
 
 	/* Now enable the unit */
-	out_be32((void *)&msg_regs->imr, in_be32((void *)&msg_regs->imr) | 0x1);
+	setbits32(&priv->msg_regs->imr, 0x1);
 
       out:
 	return rc;
 }
 
 /**
- * rio_close_inb_mbox - Shut down MPC85xx inbound mailbox
+ * rio_close_inb_mbox - Shut down inbound mailbox
  * @mport: Master port implementing the inbound message unit
  * @mbox: Mailbox to close
  *
@@ -636,44 +906,45 @@ int rio_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entri
  */
 void rio_close_inb_mbox(struct rio_mport *mport, int mbox)
 {
+	struct rio_priv *priv = mport->priv;
 	/* Disable inbound message unit */
-	out_be32((void *)&msg_regs->imr, 0);
+	out_be32(&priv->msg_regs->imr, 0);
 
 	/* Free ring */
-	dma_free_coherent(NULL, msg_rx_ring.size * RIO_MAX_MSG_SIZE,
-			  msg_rx_ring.virt, msg_rx_ring.phys);
+	dma_free_coherent(NULL, priv->msg_rx_ring.size * RIO_MAX_MSG_SIZE,
+			  priv->msg_rx_ring.virt, priv->msg_rx_ring.phys);
 
 	/* Free interrupt */
-	free_irq(MPC85xx_IRQ_RIO_RX, (void *)mport);
+	free_irq(IRQ_RIO_RX(mport), mport);
 }
 
 /**
- * rio_hw_add_inb_buffer - Add buffer to the MPC85xx inbound message queue
+ * rio_hw_add_inb_buffer - Add buffer to the inbound message queue
  * @mport: Master port implementing the inbound message unit
  * @mbox: Inbound mailbox number
  * @buf: Buffer to add to inbound queue
  *
- * Adds the @buf buffer to the MPC85xx inbound message queue. Returns
+ * Adds the @buf buffer to the inbound message queue. Returns
  * %0 on success or %-EINVAL on failure.
  */
 int rio_hw_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
 {
 	int rc = 0;
+	struct rio_priv *priv = mport->priv;
 
 	pr_debug("RIO: rio_hw_add_inb_buffer(), msg_rx_ring.rx_slot %d\n",
-		 msg_rx_ring.rx_slot);
+		 priv->msg_rx_ring.rx_slot);
 
-	if (msg_rx_ring.virt_buffer[msg_rx_ring.rx_slot]) {
-		printk(KERN_ERR
-		       "RIO: error adding inbound buffer %d, buffer exists\n",
-		       msg_rx_ring.rx_slot);
+	if (unlikely(priv->msg_rx_ring.virt_buffer[priv->msg_rx_ring.rx_slot])) {
+		ERR("error adding inbound buffer %d, buffer exists\n",
+		       priv->msg_rx_ring.rx_slot);
 		rc = -EINVAL;
 		goto out;
 	}
 
-	msg_rx_ring.virt_buffer[msg_rx_ring.rx_slot] = buf;
-	if (++msg_rx_ring.rx_slot == msg_rx_ring.size)
-		msg_rx_ring.rx_slot = 0;
+	priv->msg_rx_ring.virt_buffer[priv->msg_rx_ring.rx_slot] = buf;
+	if (++priv->msg_rx_ring.rx_slot == priv->msg_rx_ring.size)
+		priv->msg_rx_ring.rx_slot = 0;
 
       out:
 	return rc;
@@ -682,7 +953,7 @@ int rio_hw_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
 EXPORT_SYMBOL_GPL(rio_hw_add_inb_buffer);
 
 /**
- * rio_hw_get_inb_message - Fetch inbound message from the MPC85xx message unit
+ * rio_hw_get_inb_message - Fetch inbound message from the message unit
  * @mport: Master port implementing the inbound message unit
  * @mbox: Inbound mailbox number
  *
@@ -691,36 +962,35 @@ EXPORT_SYMBOL_GPL(rio_hw_add_inb_buffer);
  */
 void *rio_hw_get_inb_message(struct rio_mport *mport, int mbox)
 {
-	u32 imr;
-	u32 phys_buf, virt_buf;
+	u32 phys_buf;
+	void *virt_buf = NULL;
 	void *buf = NULL;
 	int buf_idx;
+	struct rio_priv *priv = mport->priv;
 
-	phys_buf = in_be32((void *)&msg_regs->ifqdpar);
+	phys_buf = in_be32(&priv->msg_regs->ifqdpar);
 
 	/* If no more messages, then bail out */
-	if (phys_buf == in_be32((void *)&msg_regs->ifqepar))
+	if (phys_buf == in_be32(&priv->msg_regs->ifqepar))
 		goto out2;
 
-	virt_buf = (u32) msg_rx_ring.virt + (phys_buf - msg_rx_ring.phys);
-	buf_idx = (phys_buf - msg_rx_ring.phys) / RIO_MAX_MSG_SIZE;
-	buf = msg_rx_ring.virt_buffer[buf_idx];
+	virt_buf = priv->msg_rx_ring.virt + (phys_buf - priv->msg_rx_ring.phys);
+	buf_idx = (phys_buf - priv->msg_rx_ring.phys) / RIO_MAX_MSG_SIZE;
+	buf = priv->msg_rx_ring.virt_buffer[buf_idx];
 
-	if (!buf) {
-		printk(KERN_ERR
-		       "RIO: inbound message copy failed, no buffers\n");
+	if (unlikely(!buf)) {
+		ERR("inbound message copy failed, no buffers\n");
 		goto out1;
 	}
 
 	/* Copy max message size, caller is expected to allocate that big */
-	memcpy(buf, (void *)virt_buf, RIO_MAX_MSG_SIZE);
+	memcpy(buf, virt_buf, RIO_MAX_MSG_SIZE);
 
 	/* Clear the available buffer */
-	msg_rx_ring.virt_buffer[buf_idx] = NULL;
+	priv->msg_rx_ring.virt_buffer[buf_idx] = NULL;
 
       out1:
-	imr = in_be32((void *)&msg_regs->imr);
-	out_be32((void *)&msg_regs->imr, imr | RIO_MSG_IMR_MI);
+	setbits32(&priv->msg_regs->imr, RIO_MSG_IMR_MI);
 
       out2:
 	return buf;
@@ -729,45 +999,44 @@ void *rio_hw_get_inb_message(struct rio_mport *mport, int mbox)
 EXPORT_SYMBOL_GPL(rio_hw_get_inb_message);
 
 /**
- * mpc85xx_rio_dbell_handler - MPC85xx doorbell interrupt handler
+ * fsl_rio_dbell_handler - doorbell interrupt handler
  * @irq: Linux interrupt number
  * @dev_instance: Pointer to interrupt-specific data
  *
  * Handles doorbell interrupts. Parses a list of registered
  * doorbell event handlers and executes a matching event handler.
  */
-static irqreturn_t
-mpc85xx_rio_dbell_handler(int irq, void *dev_instance)
+static irqreturn_t fsl_rio_dbell_handler(int irq, void *dev_instance)
 {
 	int dsr;
 	struct rio_mport *port = (struct rio_mport *)dev_instance;
+	struct rio_priv *priv = port->priv;
 
-	dsr = in_be32((void *)&msg_regs->dsr);
+	dsr = in_be32(&priv->msg_regs->dsr);
 
 	if (dsr & DOORBELL_DSR_TE) {
 		pr_info("RIO: doorbell reception error\n");
-		out_be32((void *)&msg_regs->dsr, DOORBELL_DSR_TE);
+		out_be32(&priv->msg_regs->dsr, DOORBELL_DSR_TE);
 		goto out;
 	}
 
 	if (dsr & DOORBELL_DSR_QFI) {
 		pr_info("RIO: doorbell queue full\n");
-		out_be32((void *)&msg_regs->dsr, DOORBELL_DSR_QFI);
+		out_be32(&priv->msg_regs->dsr, DOORBELL_DSR_QFI);
 		goto out;
 	}
 
 	/* XXX Need to check/dispatch until queue empty */
 	if (dsr & DOORBELL_DSR_DIQI) {
 		u32 dmsg =
-		    (u32) dbell_ring.virt +
-		    (in_be32((void *)&msg_regs->dqdpar) & 0xfff);
-		u32 dmr;
+		    (u32) priv->dbell_ring.virt +
+		    (in_be32(&priv->msg_regs->dqdpar) & 0xfff);
 		struct rio_dbell *dbell;
 		int found = 0;
 
-		pr_debug
-		    ("RIO: processing doorbell, sid %2.2x tid %2.2x info %4.4x\n",
-		     DBELL_SID(dmsg), DBELL_TID(dmsg), DBELL_INF(dmsg));
+		pr_debug("RIO: processing doorbell, sid 0x%02x tid 0x%02x "
+				"info 0x%04x\n", DBELL_SID(dmsg),
+				DBELL_TID(dmsg), DBELL_INF(dmsg));
 
 		list_for_each_entry(dbell, &port->dbells, node) {
 			if ((dbell->res->start <= DBELL_INF(dmsg)) &&
@@ -780,13 +1049,13 @@ mpc85xx_rio_dbell_handler(int irq, void *dev_instance)
 			dbell->dinb(port, dbell->dev_id, DBELL_SID(dmsg), DBELL_TID(dmsg),
 				    DBELL_INF(dmsg));
 		} else {
-			pr_debug
-			    ("RIO: spurious doorbell, sid %2.2x tid %2.2x info %4.4x\n",
-			     DBELL_SID(dmsg), DBELL_TID(dmsg), DBELL_INF(dmsg));
+			pr_debug("RIO: spurious doorbell, sid 0x%02x "
+					"tid 0x%02x info %4.4x\n",
+					DBELL_SID(dmsg), DBELL_TID(dmsg),
+					DBELL_INF(dmsg));
 		}
-		dmr = in_be32((void *)&msg_regs->dmr);
-		out_be32((void *)&msg_regs->dmr, dmr | DOORBELL_DMR_DI);
-		out_be32((void *)&msg_regs->dsr, DOORBELL_DSR_DIQI);
+		setbits32(&priv->msg_regs->dmr, DOORBELL_DMR_DI);
+		out_be32(&priv->msg_regs->dsr, DOORBELL_DSR_DIQI);
 	}
 
       out:
@@ -794,67 +1063,76 @@ mpc85xx_rio_dbell_handler(int irq, void *dev_instance)
 }
 
 /**
- * mpc85xx_rio_doorbell_init - MPC85xx doorbell interface init
+ * fsl_rio_doorbell_init - doorbell interface init
  * @mport: Master port implementing the inbound doorbell unit
  *
  * Initializes doorbell unit hardware and inbound DMA buffer
- * ring. Called from mpc85xx_rio_setup(). Returns %0 on success
+ * ring. Called from fsl_rio_setup(). Returns %0 on success
  * or %-ENOMEM on failure.
  */
-static int mpc85xx_rio_doorbell_init(struct rio_mport *mport)
+static int fsl_rio_doorbell_init(struct rio_mport *mport, phys_addr_t dbaddr)
 {
 	int rc = 0;
+	struct rio_priv *priv = mport->priv;
 
 	/* Map outbound doorbell window immediately after maintenance window */
-	if (!(dbell_win =
-	      (u32) ioremap(mport->iores.start + RIO_MAINT_WIN_SIZE,
-			    RIO_DBELL_WIN_SIZE))) {
-		printk(KERN_ERR
-		       "RIO: unable to map outbound doorbell window\n");
+	priv->dbell_win = ioremap(dbaddr, RIO_DBELL_WIN_SIZE);
+	if (!priv->dbell_win) {
+		ERR("unable to map outbound doorbell window\n");
 		rc = -ENOMEM;
 		goto out;
 	}
 
 	/* Initialize inbound doorbells */
-	if (!(dbell_ring.virt = dma_alloc_coherent(NULL,
+	priv->dbell_ring.virt = dma_alloc_coherent(NULL,
 						   512 * DOORBELL_MESSAGE_SIZE,
-						   &dbell_ring.phys,
-						   GFP_KERNEL))) {
-		printk(KERN_ERR "RIO: unable allocate inbound doorbell ring\n");
+						   &priv->dbell_ring.phys,
+						   GFP_KERNEL);
+	if (!priv->dbell_ring.virt) {
+		ERR("unable allocate inbound doorbell ring\n");
 		rc = -ENOMEM;
-		iounmap((void *)dbell_win);
+		iounmap(priv->dbell_win);
 		goto out;
 	}
 
 	/* Point dequeue/enqueue pointers at first entry in ring */
-	out_be32((void *)&msg_regs->dqdpar, (u32) dbell_ring.phys);
-	out_be32((void *)&msg_regs->dqepar, (u32) dbell_ring.phys);
+	out_be32(&priv->msg_regs->dqdpar, (u32) priv->dbell_ring.phys);
+	out_be32(&priv->msg_regs->dqepar, (u32) priv->dbell_ring.phys);
 
 	/* Clear interrupt status */
-	out_be32((void *)&msg_regs->dsr, 0x00000091);
+	out_be32(&priv->msg_regs->dsr, 0x00000091);
 
 	/* Hook up doorbell handler */
-	if ((rc =
-	     request_irq(MPC85xx_IRQ_RIO_BELL, mpc85xx_rio_dbell_handler, 0,
-			 "dbell_rx", (void *)mport) < 0)) {
-		iounmap((void *)dbell_win);
+	rc = request_irq(IRQ_RIO_BELL(mport), fsl_rio_dbell_handler, 0,
+			 "dbell_rx", mport);
+	if (rc < 0) {
+		iounmap(priv->dbell_win);
 		dma_free_coherent(NULL, 512 * DOORBELL_MESSAGE_SIZE,
-				  dbell_ring.virt, dbell_ring.phys);
-		printk(KERN_ERR
-		       "MPC85xx RIO: unable to request inbound doorbell irq");
+				  priv->dbell_ring.virt, priv->dbell_ring.phys);
+		ERR("unable to request inbound doorbell irq");
 		goto out;
 	}
 
 	/* Configure doorbells for snooping, 512 entries, and enable */
-	out_be32((void *)&msg_regs->dmr, 0x00108161);
+	out_be32(&priv->msg_regs->dmr, 0x00108161);
 
       out:
 	return rc;
 }
 
+u32 rio_get_mport_id(struct rio_mport *mport)
+{
+	u32 mport_id = 0;
+
+	rio_local_read_config_32(mport, 0x60, &mport_id);
+	mport_id = mport->sys_size ? (mport_id & 0xffff) : ((mport_id >> 16) & 0xff);
+	return mport_id;
+
+}
+
 static char *cmdline = NULL;
 
-static int mpc85xx_rio_get_hdid(int index)
+static int fsl_rio_get_hdid(int index)
 {
 	/* XXX Need to parse multiple entries in some format */
 	if (!cmdline)
@@ -863,7 +1141,7 @@ static int mpc85xx_rio_get_hdid(int index)
 	return simple_strtol(cmdline, NULL, 0);
 }
 
-static int mpc85xx_rio_get_cmdline(char *s)
+static int fsl_rio_get_cmdline(char *s)
 {
 	if (!s)
 		return 0;
@@ -872,61 +1150,345 @@ static int mpc85xx_rio_get_cmdline(char *s)
 	return 1;
 }
 
-__setup("riohdid=", mpc85xx_rio_get_cmdline);
+__setup("riohdid=", fsl_rio_get_cmdline);
+
+static struct rio_mem_ops fsl_mem_ops = {
+	.map_inb = fsl_rio_map_inb_mem,
+	.map_outb = fsl_rio_map_outb_mem,
+	.unmap_inb = fsl_rio_unmap_inb_mem,
+	.unmap_outb = fsl_rio_unmap_outb_mem,
+};
+
+static inline void fsl_rio_info(u32 ccsr)
+{
+	if (ccsr & 1) {
+		/* Serial phy */
+		INFO("Hardware port width: ");
+		switch (ccsr >> 30) {
+		case 0:
+			printk("1\n");
+			break;
+		case 1:
+			printk("4\n");
+			break;
+		default:
+			printk("Unknown\n");
+			break;;
+		}
+
+		INFO("Training connection status: ");
+		switch ((ccsr >> 27) & 7) {
+		case 0:
+			printk("Single-lane 0\n");
+			break;
+		case 1:
+			printk("Single-lane 2\n");
+			break;
+		case 2:
+			printk("Four-lane\n");
+			break;
+		default:
+			printk("Unknown\n");
+		}
+	} else {
+		/* Parallel phy */
+		if (ccsr & 0x80000000)
+			INFO("Output port operating in 8-bit mode\n");
+		if (ccsr & 0x08000000)
+			INFO("Input port operating in 8-bit mode\n");
+	}
+
+}
+
+static inline u8 hw_port_width(u32 ccsr)
+{
+	u8 pw = ccsr >> 30;
+	switch (pw) {
+	case 0:
+		return 1;
+	case 1:
+		return 4;
+	default:
+		return 0;
+	}
+}
+
+static int of_cells_get(struct device_node *np, const char *str)
+{
+	struct device_node *tmp = NULL;
+	const int *var = NULL;
+
+	var = of_get_property(np, str, NULL);
+	tmp = of_get_parent(np);
+
+	while (!var && tmp) {
+		var = (int *)of_get_property(tmp, str, NULL);
+		of_node_put(tmp);
+		tmp = of_get_parent(np);
+	}
+
+	return (var ? *var : 0);
+}
 
 /**
- * mpc85xx_rio_setup - Setup MPC85xx RapidIO interface
- * @law_start: Starting physical address of RapidIO LAW
- * @law_size: Size of RapidIO LAW
+ * fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
  *
- * Initializes MPC85xx RapidIO hardware interface, configures
+ * Initializes Freescale PowerPC RapidIO hardware interface, configures
  * master port with system-specific info, and registers the
  * master port with the RapidIO subsystem.
  */
-void mpc85xx_rio_setup(int law_start, int law_size)
+int fsl_rio_setup(struct of_device *dev)
 {
-	struct rio_ops *ops;
-	struct rio_mport *port;
+	struct rio_ops *ops = NULL;
+	struct rio_mport *port = NULL;
+	const u32 *dt_range;
+	int rlen = 0;
+	resource_size_t law_start = 0, law_size = 0;
+	struct resource regs;
+	int rc;
+	enum rio_phy_type phy_type;
+	volatile void __iomem *regs_win = NULL;
+	struct rio_priv *priv = NULL;
+	u32 ccsr;
+	int paw, aw, psw;
+	struct device_node *pa;
+
+	if (!dev->node) {
+		ERR("Dev ofnode is NULL\n");
+		return -EFAULT;
+	}
+
+	dt_range = of_get_property(dev->node, "ranges", &rlen);
+	if (!dt_range) {
+		ERR("Can't get %s property 'ranges'\n", dev->node->full_name);
+		return -EFAULT;
+	}
+
+	aw = of_cells_get(dev->node, "#address-cells");
+	pa = of_get_parent(dev->node);
+	paw = of_cells_get(pa, "#address-cells");
+	psw = of_cells_get(pa, "#size-cells");
+	of_node_put(pa);
 
-	ops = kmalloc(sizeof(struct rio_ops), GFP_KERNEL);
-	ops->lcread = mpc85xx_local_config_read;
-	ops->lcwrite = mpc85xx_local_config_write;
-	ops->cread = mpc85xx_rio_config_read;
-	ops->cwrite = mpc85xx_rio_config_write;
-	ops->dsend = mpc85xx_rio_doorbell_send;
+	law_start = of_read_number(dt_range + aw, paw);
+	law_size = of_read_number(dt_range + aw + paw, psw);
 
-	port = kmalloc(sizeof(struct rio_mport), GFP_KERNEL);
+	rc = of_address_to_resource(dev->node, 0, &regs);
+	if (rc) {
+		ERR("Can't get %s property 'reg'\n", dev->node->full_name);
+		return -EFAULT;
+	}
+	INFO("Of-device full name %s\n", dev->node->full_name);
+	INFO("LAW start 0x%016llx, size 0x%016llx.\n", (u64)law_start,
+						(u64)law_size);
+	INFO("Regs start 0x%08x size 0x%08x\n",	regs.start,
+						regs.end - regs.start + 1);
+
+	regs_win = ioremap(regs.start, regs.end - regs.start + 1);
+	if (!regs_win) {
+		ERR("Can't remap io for 'regs_win'\n");
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	/* Probe the RapidIO phy type */
+	ccsr = in_be32(regs_win + RIO_CCSR);
+	if (ccsr & 1)
+		phy_type = RIO_PHY_SERIAL;
+	else
+		phy_type = RIO_PHY_PARALLEL;
+	INFO("Phy type: ");
+	switch (phy_type) {
+	case RIO_PHY_SERIAL:
+		printk("serial\n");
+		break;
+	case RIO_PHY_PARALLEL:
+		printk("parallel");
+		break;
+	default:
+		printk("Unknown type %d\n", phy_type);
+		rc = -EINVAL;
+		goto err;
+	};
+	fsl_rio_info(ccsr);
+
+
+	/* Checking the port training status */
+	if (in_be32((regs_win + RIO_ESCSR)) & 1) {
+		ERR("Port is not ready. Try to restart connection...\n");
+		switch (phy_type) {
+		case RIO_PHY_SERIAL:
+			/* Disable ports */
+			out_be32(regs_win + RIO_CCSR, 0);
+			/* Set 1x lane */
+			setbits32(regs_win + RIO_CCSR, 0x02000000);
+			/* Enable ports */
+			setbits32(regs_win + RIO_CCSR, 0x00600000);
+			break;
+		case RIO_PHY_PARALLEL:
+			/* Disable ports */
+			out_be32(regs_win + RIO_CCSR, 0x22000000);
+			/* Enable ports */
+			out_be32(regs_win + RIO_CCSR, 0x44000000);
+			break;
+		}
+		if (in_be32((regs_win + RIO_ESCSR)) & 1) {
+			ERR("Port restart failed.\n");
+			rc = -ENOLINK;
+			goto err;
+		}
+		INFO("Port restart success!\n");
+		ccsr = in_be32(regs_win + RIO_CCSR);
+		fsl_rio_info(ccsr);
+	}
+
+	ops = kzalloc(sizeof(struct rio_ops), GFP_KERNEL);
+	ops->lcread = fsl_local_config_read;
+	ops->lcwrite = fsl_local_config_write;
+	ops->cread = fsl_rio_config_read;
+	ops->cwrite = fsl_rio_config_write;
+	ops->dsend = fsl_rio_doorbell_send;
+
+	port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
+	if (!port) {
+		ERR("Can't alloc memory for 'port'\n");
+		rc = -ENOMEM;
+		goto err;
+	}
 	port->id = 0;
 	port->index = 0;
+
+	port->sys_size = (in_be32((regs_win + RIO_PEF_CAR))
+				& RIO_PEF_CTLS) >> 4;
+	INFO("RapidIO Common Transport System size: %d\n",
+			port->sys_size ? 65536 : 256);
+
+	port->phy_type = phy_type;
+
+	priv = kzalloc(sizeof(struct rio_priv), GFP_KERNEL);
+	if (!priv) {
+		ERR("Can't alloc memory for 'priv'\n");
+		rc = -ENOMEM;
+		goto err;
+	}
+	port->priv = priv;
+	priv->regs_win = regs_win;
 	INIT_LIST_HEAD(&port->dbells);
 	port->iores.start = law_start;
 	port->iores.end = law_start + law_size;
 	port->iores.flags = IORESOURCE_MEM;
+	port->iores.name = "rio_io_win";
+
+	priv->bellirq = irq_of_parse_and_map(dev->node, 2);
+	priv->txirq = irq_of_parse_and_map(dev->node, 3);
+	priv->rxirq = irq_of_parse_and_map(dev->node, 4);
+	INFO("bellirq: %d, txirq: %d, rxirq %d\n", priv->bellirq,
+				priv->txirq, priv->rxirq);
 
 	rio_init_dbell_res(&port->riores[RIO_DOORBELL_RESOURCE], 0, 0xffff);
 	rio_init_mbox_res(&port->riores[RIO_INB_MBOX_RESOURCE], 0, 0);
 	rio_init_mbox_res(&port->riores[RIO_OUTB_MBOX_RESOURCE], 0, 0);
+
 	strcpy(port->name, "RIO0 mport");
 
 	port->ops = ops;
-	port->host_deviceid = mpc85xx_rio_get_hdid(port->id);
+	port->mops = &fsl_mem_ops;
+	port->host_deviceid = fsl_rio_get_hdid(port->id);
 
 	rio_register_mport(port);
 
-	regs_win = (u32) ioremap(RIO_REGS_BASE, 0x20000);
-	atmu_regs = (struct rio_atmu_regs *)(regs_win + RIO_ATMU_REGS_OFFSET);
-	maint_atmu_regs = atmu_regs + 1;
-	dbell_atmu_regs = atmu_regs + 2;
-	msg_regs = (struct rio_msg_regs *)(regs_win + RIO_MSG_REGS_OFFSET);
+	priv->atmu_regs = (struct rio_atmu_regs *)(regs_win +
+			RIO_ATMU_REGS_OFFSET);
+	priv->maint_atmu_regs = priv->atmu_regs + 1;
+	priv->dbell_atmu_regs = priv->atmu_regs + 2;
+	priv->msg_regs = (struct rio_msg_regs *)(regs_win +
+				((port->phy_type == RIO_PHY_SERIAL)
+					? RIO_S_MSG_REGS_OFFSET
+					: RIO_P_MSG_REGS_OFFSET));
+
+	/* Set to receive any dist ID for serial RapidIO controller. */
+	if (port->phy_type == RIO_PHY_SERIAL)
+		out_be32((regs_win + RIO_ISR_AACR), RIO_ISR_AACR_AA);
 
 	/* Configure maintenance transaction window */
-	out_be32((void *)&maint_atmu_regs->rowbar, 0x000c0000);
-	out_be32((void *)&maint_atmu_regs->rowar, 0x80077015);
+	if (!rio_request_io_region(port, NULL, law_start, RIO_MAINT_WIN_SIZE,
+				"maint_win", RIO_RESOURCE_MAINT, NULL)) {
+		rc = -EPERM;
+		ERR("request maint win error!\n");
+		goto err;
+	}
+	out_be32(&priv->maint_atmu_regs->rowbar,
+				(law_start >> 12) & 0xffffff);
+	out_be32(&priv->maint_atmu_regs->rowar, 0x80077000
+			| (__ilog2(RIO_MAINT_WIN_SIZE) - 1));
 
-	maint_win = (u32) ioremap(law_start, RIO_MAINT_WIN_SIZE);
+	priv->maint_win = ioremap(law_start, RIO_MAINT_WIN_SIZE);
 
 	/* Configure outbound doorbell window */
-	out_be32((void *)&dbell_atmu_regs->rowbar, 0x000c0400);
-	out_be32((void *)&dbell_atmu_regs->rowar, 0x8004200b);
-	mpc85xx_rio_doorbell_init(port);
+	if (!rio_request_io_region(port, NULL, law_start + RIO_MAINT_WIN_SIZE,
+			RIO_DBELL_WIN_SIZE,
+			"dbell_win", RIO_RESOURCE_DOORBELL, NULL)) {
+		rc = -EPERM;
+		ERR("request doorbell win error!\n");
+		goto err;
+	}
+	out_be32(&priv->dbell_atmu_regs->rowbar, ((law_start +
+					RIO_MAINT_WIN_SIZE) >> 12) & 0xfffff);
+	out_be32(&priv->dbell_atmu_regs->rowar, 0x80042000
+			| (__ilog2(RIO_DBELL_WIN_SIZE) - 1));
+	rc = fsl_rio_doorbell_init(port, law_start + RIO_MAINT_WIN_SIZE);
+	if (rc)
+		goto err;
+
+	return 0;
+
+err:
+	if (regs_win)
+		iounmap(regs_win);
+	if (ops)
+		kfree(ops);
+	if (port)
+		kfree(port);
+	if (priv)
+		kfree(priv);
+	return rc;
+}
+
+/* The probe function for RapidIO peer-to-peer network.
+ */
+static int __devinit fsl_of_rio_rpn_probe(struct of_device *dev,
+				     const struct of_device_id *match)
+{
+	int rc;
+	printk(KERN_INFO "Setting up RapidIO peer-to-peer network %s\n",
+			dev->node->full_name);
+
+	rc = fsl_rio_setup(dev);
+	if (rc)
+		goto out;
+
+	/* Enumerate all registered ports */
+	rc = rio_init_mports();
+out:
+	return rc;
+};
+
+static struct of_device_id fsl_of_rio_rpn_ids[] = {
+	{
+		.compatible = "fsl,rapidio-delta",
+	},
+	{},
+};
+
+static struct of_platform_driver fsl_of_rio_rpn_driver = {
+	.name = "fsl-of-rio",
+	.match_table = fsl_of_rio_rpn_ids,
+	.probe = fsl_of_rio_rpn_probe,
+};
+
+static __init int fsl_of_rio_rpn_init(void)
+{
+	return of_register_platform_driver(&fsl_of_rio_rpn_driver);
 }
+
+subsys_initcall(fsl_of_rio_rpn_init);
diff --git a/drivers/rapidio/Kconfig b/drivers/rapidio/Kconfig
index 4142115..f669108 100644
--- a/drivers/rapidio/Kconfig
+++ b/drivers/rapidio/Kconfig
@@ -1,14 +1,6 @@
 #
 # RapidIO configuration
 #
-config RAPIDIO_8_BIT_TRANSPORT
-	bool "8-bit transport addressing"
-	depends on RAPIDIO
-	---help---
-	  By default, the kernel assumes a 16-bit addressed RapidIO
-	  network. By selecting this option, the kernel will support
-	  an 8-bit addressed network.
-
 config RAPIDIO_DISC_TIMEOUT
 	int "Discovery timeout duration (seconds)"
 	depends on RAPIDIO
@@ -16,3 +8,13 @@ config RAPIDIO_DISC_TIMEOUT
 	---help---
 	  Amount of time a discovery node waits for a host to complete
 	  enumeration before giving up.
+
+config RAPIDIO_PROC_FS
+	bool "I/O and Memory resource debug"
+	depends on RAPIDIO && PROC_FS
+	default y
+	---help---
+	  Enable this option, it will create a /proc/riores node for
+	  monitoring the RapidIO I/O and Memory resource.
+
+source "drivers/rapidio/sallocator/Kconfig"
diff --git a/drivers/rapidio/Makefile b/drivers/rapidio/Makefile
index 7c0e181..e5b2f11 100644
--- a/drivers/rapidio/Makefile
+++ b/drivers/rapidio/Makefile
@@ -4,3 +4,4 @@
 obj-y += rio.o rio-access.o rio-driver.o rio-scan.o rio-sysfs.o
 
 obj-$(CONFIG_RAPIDIO)		+= switches/
+obj-$(CONFIG_RAPIDIO)		+= sallocator/
diff --git a/drivers/rapidio/rio-access.c b/drivers/rapidio/rio-access.c
index 8b56bbd..a3824ba 100644
--- a/drivers/rapidio/rio-access.c
+++ b/drivers/rapidio/rio-access.c
@@ -48,7 +48,7 @@ int __rio_local_read_config_##size \
 	u32 data = 0;							\
 	if (RIO_##size##_BAD) return RIO_BAD_SIZE;			\
 	spin_lock_irqsave(&rio_config_lock, flags);			\
-	res = mport->ops->lcread(mport->id, offset, len, &data);	\
+	res = mport->ops->lcread(mport, mport->id, offset, len, &data);	\
 	*value = (type)data;						\
 	spin_unlock_irqrestore(&rio_config_lock, flags);		\
 	return res;							\
@@ -71,7 +71,7 @@ int __rio_local_write_config_##size \
 	unsigned long flags;						\
 	if (RIO_##size##_BAD) return RIO_BAD_SIZE;			\
 	spin_lock_irqsave(&rio_config_lock, flags);			\
-	res = mport->ops->lcwrite(mport->id, offset, len, value);	\
+	res = mport->ops->lcwrite(mport, mport->id, offset, len, value);\
 	spin_unlock_irqrestore(&rio_config_lock, flags);		\
 	return res;							\
 }
@@ -108,7 +108,7 @@ int rio_mport_read_config_##size \
 	u32 data = 0;							\
 	if (RIO_##size##_BAD) return RIO_BAD_SIZE;			\
 	spin_lock_irqsave(&rio_config_lock, flags);			\
-	res = mport->ops->cread(mport->id, destid, hopcount, offset, len, &data); \
+	res = mport->ops->cread(mport, mport->id, destid, hopcount, offset, len, &data); \
 	*value = (type)data;						\
 	spin_unlock_irqrestore(&rio_config_lock, flags);		\
 	return res;							\
@@ -131,7 +131,7 @@ int rio_mport_write_config_##size \
 	unsigned long flags;						\
 	if (RIO_##size##_BAD) return RIO_BAD_SIZE;			\
 	spin_lock_irqsave(&rio_config_lock, flags);			\
-	res = mport->ops->cwrite(mport->id, destid, hopcount, offset, len, value); \
+	res = mport->ops->cwrite(mport, mport->id, destid, hopcount, offset, len, value); \
 	spin_unlock_irqrestore(&rio_config_lock, flags);		\
 	return res;							\
 }
@@ -166,7 +166,7 @@ int rio_mport_send_doorbell(struct rio_mport *mport, u16 destid, u16 data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&rio_doorbell_lock, flags);
-	res = mport->ops->dsend(mport->id, destid, data);
+	res = mport->ops->dsend(mport, mport->id, destid, data);
 	spin_unlock_irqrestore(&rio_doorbell_lock, flags);
 
 	return res;
diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 4442072..9d52e9b 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -73,7 +73,7 @@ static u16 rio_get_device_id(struct rio_mport *port, u16 destid, u8 hopcount)
 
 	rio_mport_read_config_32(port, destid, hopcount, RIO_DID_CSR, &result);
 
-	return RIO_GET_DID(result);
+	return RIO_GET_DID(port->sys_size, result);
 }
 
 /**
@@ -88,7 +88,7 @@ static u16 rio_get_device_id(struct rio_mport *port, u16 destid, u8 hopcount)
 static void rio_set_device_id(struct rio_mport *port, u16 destid, u8 hopcount, u16 did)
 {
 	rio_mport_write_config_32(port, destid, hopcount, RIO_DID_CSR,
-				  RIO_SET_DID(did));
+				  RIO_SET_DID(port->sys_size, did));
 }
 
 /**
@@ -100,7 +100,8 @@ static void rio_set_device_id(struct rio_mport *port, u16 destid, u8 hopcount, u
  */
 static void rio_local_set_device_id(struct rio_mport *port, u16 did)
 {
-	rio_local_write_config_32(port, RIO_DID_CSR, RIO_SET_DID(did));
+	rio_local_write_config_32(port, RIO_DID_CSR, RIO_SET_DID(port->sys_size,
+				did));
 }
 
 /**
@@ -350,8 +351,17 @@ static struct rio_dev *rio_setup_device(struct rio_net *net,
 		rswitch->switchid = next_switchid;
 		rswitch->hopcount = hopcount;
 		rswitch->destid = destid;
+		if (!(rswitch->route_table = kzalloc(sizeof(u16)*
+					RIO_MAX_ROUTE_ENTRIES(port->sys_size),
+					GFP_KERNEL))) {
+			kfree(rdev);
+			rdev = NULL;
+			kfree(rswitch);
+			goto out;
+		}
 		/* Initialize switch route table */
-		for (rdid = 0; rdid < RIO_MAX_ROUTE_ENTRIES; rdid++)
+		for (rdid = 0; rdid < RIO_MAX_ROUTE_ENTRIES(port->sys_size);
+				rdid++)
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
 		rdev->rswitch = rswitch;
 		sprintf(rio_name(rdev), "%02x:s:%04x", rdev->net->id,
@@ -480,7 +490,7 @@ static u16 rio_get_host_deviceid_lock(struct rio_mport *port, u8 hopcount)
 {
 	u32 result;
 
-	rio_mport_read_config_32(port, RIO_ANY_DESTID, hopcount,
+	rio_mport_read_config_32(port, RIO_ANY_DESTID(port->sys_size), hopcount,
 				 RIO_HOST_DID_LOCK_CSR, &result);
 
 	return (u16) (result & 0xffff);
@@ -571,14 +581,16 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 	}
 
 	/* Attempt to acquire device lock */
-	rio_mport_write_config_32(port, RIO_ANY_DESTID, hopcount,
+	rio_mport_write_config_32(port, RIO_ANY_DESTID(port->sys_size),
+				  hopcount,
 				  RIO_HOST_DID_LOCK_CSR, port->host_deviceid);
 	while ((tmp = rio_get_host_deviceid_lock(port, hopcount))
 	       < port->host_deviceid) {
 		/* Delay a bit */
 		mdelay(1);
 		/* Attempt to acquire device lock again */
-		rio_mport_write_config_32(port, RIO_ANY_DESTID, hopcount,
+		rio_mport_write_config_32(port, RIO_ANY_DESTID(port->sys_size),
+					  hopcount,
 					  RIO_HOST_DID_LOCK_CSR,
 					  port->host_deviceid);
 	}
@@ -590,7 +602,8 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 	}
 
 	/* Setup new RIO device */
-	if ((rdev = rio_setup_device(net, port, RIO_ANY_DESTID, hopcount, 1))) {
+	if ((rdev = rio_setup_device(net, port, RIO_ANY_DESTID(port->sys_size),
+					hopcount, 1))) {
 		/* Add device to the global and bus/net specific list. */
 		list_add_tail(&rdev->net_list, &net->devices);
 	} else
@@ -598,7 +611,8 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 
 	if (rio_is_switch(rdev)) {
 		next_switchid++;
-		sw_inport = rio_get_swpinfo_inport(port, RIO_ANY_DESTID, hopcount);
+		sw_inport = rio_get_swpinfo_inport(port,
+				RIO_ANY_DESTID(port->sys_size), hopcount);
 		rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
 				    port->host_deviceid, sw_inport);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
@@ -612,7 +626,8 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 		}
 
 		num_ports =
-		    rio_get_swpinfo_tports(port, RIO_ANY_DESTID, hopcount);
+		    rio_get_swpinfo_tports(port, RIO_ANY_DESTID(port->sys_size),
+						hopcount);
 		pr_debug(
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
 		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
@@ -624,13 +639,15 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 			cur_destid = next_destid;
 
 			if (rio_sport_is_active
-			    (port, RIO_ANY_DESTID, hopcount, port_num)) {
+			    (port, RIO_ANY_DESTID(port->sys_size), hopcount,
+			     port_num)) {
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
 				rio_route_add_entry(port, rdev->rswitch,
 						    RIO_GLOBAL_TABLE,
-						    RIO_ANY_DESTID, port_num);
+						    RIO_ANY_DESTID(port->sys_size),
+						    port_num);
 
 				if (rio_enum_peer(net, port, hopcount + 1) < 0)
 					return -1;
@@ -735,7 +752,8 @@ rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
-				for (ndestid = 0; ndestid < RIO_ANY_DESTID;
+				for (ndestid = 0;
+				     ndestid < RIO_ANY_DESTID(port->sys_size);
 				     ndestid++) {
 					rio_route_get_entry(port, rdev->rswitch,
 							    RIO_GLOBAL_TABLE,
@@ -796,7 +814,7 @@ static int rio_mport_is_active(struct rio_mport *port)
  * network list of associated master ports. Returns a
  * RIO network pointer on success or %NULL on failure.
  */
-static struct rio_net __devinit *rio_alloc_net(struct rio_mport *port)
+static struct rio_net *rio_alloc_net(struct rio_mport *port)
 {
 	struct rio_net *net;
 
@@ -917,7 +935,9 @@ static void rio_build_route_tables(void)
 
 	list_for_each_entry(rdev, &rio_devices, global_list)
 	    if (rio_is_switch(rdev))
-		for (i = 0; i < RIO_MAX_ROUTE_ENTRIES; i++) {
+		for (i = 0;
+		     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
+		     i++) {
 			if (rio_route_get_entry
 			    (rdev->net->hport, rdev->rswitch, RIO_GLOBAL_TABLE,
 			     i, &sport) < 0)
@@ -981,7 +1001,8 @@ int rio_disc_mport(struct rio_mport *mport)
 		del_timer_sync(&rio_enum_timer);
 
 		pr_debug("done\n");
-		if (rio_disc_peer(net, mport, RIO_ANY_DESTID, 0) < 0) {
+		if (rio_disc_peer(net, mport, RIO_ANY_DESTID(mport->sys_size),
+					0) < 0) {
 			printk(KERN_INFO
 			       "RIO: master port %d device has failed discovery\n",
 			       mport->id);
diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index 659e311..97a147f 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -43,7 +43,8 @@ static ssize_t routes_show(struct device *dev, struct device_attribute *attr, ch
 	if (!rdev->rswitch)
 		goto out;
 
-	for (i = 0; i < RIO_MAX_ROUTE_ENTRIES; i++) {
+	for (i = 0; i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
+			i++) {
 		if (rdev->rswitch->route_table[i] == RIO_INVALID_ROUTE)
 			continue;
 		str +=
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index f644807..c3b3c7e 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -2,9 +2,16 @@
  * RapidIO interconnect services
  * (RapidIO Interconnect Specification, http://www.rapidio.org)
  *
+ * Copyright (C) 2007 Freescale Semiconductor, Inc.
+ * Author: Zhang Wei, wei.zhang@freescale.com, Jun 2007
+ *
  * Copyright 2005 MontaVista Software, Inc.
  * Matt Porter <mporter@kernel.crashing.org>
  *
+ * Changelog:
+ * Jun 2007 Zhang Wei <wei.zhang@freescale.com>
+ * - Add memory mapping support.
+ *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
@@ -23,10 +30,22 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/dma-mapping.h>
+#include <linux/hardirq.h>
 
 #include "rio.h"
 
+#define ERR(fmt, arg...) \
+	printk(KERN_ERR "%s:%s: " fmt,  __FILE__, __FUNCTION__, ## arg)
+
 static LIST_HEAD(rio_mports);
+static LIST_HEAD(rio_inb_mems);
+static LIST_HEAD(rio_outb_mems);
+
+static DEFINE_SPINLOCK(rio_config_lock);
 
 /**
  * rio_local_get_device_id - Get the base/extended device id for a port
@@ -42,7 +61,7 @@ u16 rio_local_get_device_id(struct rio_mport *port)
 
 	rio_local_read_config_32(port, RIO_DID_CSR, &result);
 
-	return (RIO_GET_DID(result));
+	return (RIO_GET_DID(port->sys_size, result));
 }
 
 /**
@@ -332,6 +351,350 @@ int rio_release_outb_dbell(struct rio_dev *rdev, struct resource *res)
 }
 
 /**
+ * rio_request_io_region -- request resource in RapidIO IO region
+ * @mport: Master port
+ * @devid: Device specific pointer to pass
+ * @start: IO resource start address
+ * @size: IO resource size
+ * @name: Resource name
+ * @flag: Flag for resource
+ * @res: Return resource which has been allocated. If res == NULL,
+ *       the function will alloc the memory for return resource.
+ *
+ * Return: The resource which has been allocated.
+ */
+struct resource *rio_request_io_region(struct rio_mport *mport, void *devid,
+		resource_size_t start, resource_size_t size,
+		const char *name, unsigned long flags,
+		struct resource *res)
+{
+	if (!res && !(res = kmalloc(sizeof(struct resource), GFP_KERNEL))) {
+		ERR("No free memory for res alloc!\n");
+		goto err;
+	}
+	memset(res, 0, sizeof(struct resource));
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* if start == 0 then auto locate the start address */
+	if (!start) {
+		if (allocate_resource(&mport->iores, res, size,
+				mport->iores.start, mport->iores.end,
+				size, NULL, NULL) < 0) {
+			ERR("allocte resource error!\n");
+			goto err;
+		}
+		res->name = name;
+		res->flags = flags;
+	} else {
+		rio_init_io_res(res, start, start + size - 1, name, flags);
+		if (request_resource(&mport->iores, res) < 0) {
+			ERR("Can't get SRIO IO resource!\n");
+			goto err;
+		}
+	}
+	return res;
+
+err:
+	if (res)
+		kfree(res);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(rio_request_io_region);
+
+/**
+ * rio_map_inb_region -- Mapping inbound memory region.
+ * @mport: Master port.
+ * @mem: Memory struction for mapping.
+ * @rflags: Flags for mapping.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the mapping from the mem->riores to mem->iores.
+ */
+int rio_map_inb_region(struct rio_mport *mport, struct rio_mem *mem, u32 rflags)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->mops)
+		return -1;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	rc = mport->mops->map_inb(mport, mem->iores.start, mem->riores.start, mem->size, rflags);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+	return rc;
+}
+
+/**
+ * rio_map_outb_region -- Mapping outbound memory region.
+ * @mport: Master port.
+ * @tid: Target RapidIO device id.
+ * @mem: Memory struction for mapping.
+ * @rflags: Flags for mapping.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the mapping from the mem->iores to mem->riores.
+ */
+int rio_map_outb_region(struct rio_mport *mport, u16 tid,
+		struct rio_mem *mem, u32 rflags)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->mops)
+		return -1;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	rc = mport->mops->map_outb(mport, mem->iores.start, mem->riores.start, mem->size, tid, rflags);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+	return rc;
+}
+
+/**
+ * rio_unmap_inb_region -- Unmap the inbound memory region
+ * @mport: Master port
+ * @mem: Memory struction for unmapping.
+ */
+void rio_unmap_inb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	unsigned long flags;
+	if (!mport->mops)
+		return;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	mport->mops->unmap_inb(mport, mem->iores.start);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+}
+
+/**
+ * rio_unmap_outb_region -- Unmap the outbound memory region
+ * @mport: Master port
+ * @mem: Memory struction for unmapping.
+ */
+void rio_unmap_outb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	unsigned long flags;
+	if (!mport->mops)
+		return;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	mport->mops->unmap_outb(mport, mem->iores.start);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+}
+
+/**
+ * rio_release_inb_region -- Release the inbound region resource.
+ * @mport: Master port
+ * @mem: Inbound region descriptor
+ *
+ * Return 0 is successed.
+ */
+int rio_release_inb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	int rc = 0;
+	if (!mem)
+		return rc;
+	rio_unmap_inb_region(mport, mem);
+	if (mem->virt)
+		dma_free_coherent(NULL, mem->size, mem->virt, mem->iores.start);
+
+	if (mem->iores.parent)
+		rc = release_resource(&mem->iores);
+	if (mem->riores.parent && !rc)
+		rc = release_resource(&mem->riores);
+
+	if (mem->node.prev)
+		list_del(&mem->node);
+
+	kfree(mem);
+
+	return rc;
+}
+
+/**
+ * rio_request_inb_region -- Request inbound memory region
+ * @mport: Master port
+ * @dev_id: Device specific pointer to pass
+ * @size: The request memory windows size
+ * @name: The region name
+ * @owner: The region owner driver id
+ *
+ * Retrun: The rio_mem struction for inbound memory descriptor.
+ *
+ * This function is used for request RapidIO space inbound region. If the size
+ * less than 4096 or not aligned to 2^N, it will be adjusted. The function will
+ * alloc a block of local DMA memory of the size for inbound region target and
+ * request a RapidIO region for inbound region source. Then the inbound region
+ * will be claimed in RapidIO space and the local DMA memory will be added to
+ * local inbound memory list. The rio_mem with the inbound relationship will
+ * be returned.
+ */
+struct rio_mem *rio_request_inb_region(struct rio_mport *mport, void *dev_id,
+		resource_size_t size, const char *name, u32 owner)
+{
+	struct rio_mem *rmem = NULL;
+	int ret;
+
+	rmem = kzalloc(sizeof(struct rio_mem), GFP_KERNEL);
+	if (!rmem)
+		goto err;
+
+	/* Align the size to 2^N */
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* Alloc the RapidIO space */
+	ret = rio_space_request(mport, size, &rmem->riores);
+	if (ret) {
+		printk(KERN_ERR "RIO space request error! ret = %d\n", ret);
+		goto err;
+	}
+
+	rmem->riores.name = name;
+	rmem->size = rmem->riores.end - rmem->riores.start + 1;
+
+	/* Initialize inbound memory */
+	if (!(rmem->virt = dma_alloc_coherent(NULL, rmem->size,
+				&rmem->iores.start, GFP_KERNEL))) {
+		ERR("Inbound memory alloc error\n");
+		goto err;
+	}
+	rmem->iores.end = rmem->iores.start + rmem->size - 1;
+	rmem->owner = owner;
+
+	/* Map RIO space to local DMA memory */
+	if ((ret = rio_map_inb_region(mport, rmem, 0))) {
+		printk(KERN_ERR "RIO map inbound mem error, ret = %d\n", ret);
+		goto err;
+	}
+
+	/* Claim the region */
+	if ((ret = rio_space_claim(rmem))) {
+		printk(KERN_ERR "RIO inbound mem claim error, ret = %d\n", ret);
+		goto err;
+	}
+	list_add(&rmem->node, &rio_inb_mems);
+
+	return rmem;
+
+err:
+	rio_release_inb_region(mport, rmem);
+	return NULL;
+}
+
+/**
+ * rio_release_outb_region -- Release the outbound region resource.
+ * @mport: Master port
+ * @mem: Outbound region descriptor
+ *
+ * Return 0 is successed.
+ */
+int rio_release_outb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	int rc = 0;
+	if (!mem)
+		return rc;
+	rio_unmap_outb_region(mport, mem);
+	rio_space_release(mem);
+	if (mem->virt)
+		iounmap(mem->virt);
+
+	if (mem->iores.parent)
+		rc = release_resource(&mem->iores);
+	if (mem->riores.parent && !rc)
+		rc = release_resource(&mem->riores);
+
+	if (mem->node.prev)
+		list_del(&mem->node);
+
+	kfree(mem);
+
+	return rc;
+}
+
+/** rio_prepare_io_mem -- Prepare IO region for RapidIO outbound mapping
+ * @mport: Master port
+ * @dev: RIO device specific pointer to pass
+ * @size: Request IO size
+ * @name: The request IO resource name
+ *
+ * Return: The rio_mem descriptor with IO region resource.
+ *
+ * This function request IO region firstly and ioremap it for preparing
+ * outbound window mapping. The function do not map the outbound region
+ * because ioremap can not located at the interrupt action function.
+ * The function can be called in the initialization for just prepared.
+ */
+struct rio_mem *rio_prepare_io_mem(struct rio_mport *mport,
+		struct rio_dev *dev, resource_size_t size, const char *name)
+{
+	struct rio_mem *rmem = NULL;
+
+	rmem = kzalloc(sizeof(struct rio_mem), GFP_KERNEL);
+	if (!rmem)
+		goto err;
+
+	/* Align the size to 2^N */
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* Request RapidIO IO region */
+	if (!(rio_request_io_region(mport, dev, 0, size,
+				name, RIO_RESOURCE_MEM, &rmem->iores))) {
+		ERR("RIO io region request error!\n");
+		goto err;
+	}
+
+	rmem->virt = ioremap((phys_addr_t)(rmem->iores.start), size);
+	rmem->size = size;
+
+	list_add(&rmem->node, &rio_outb_mems);
+	return rmem;
+err:
+	rio_release_outb_region(mport, rmem);
+	return NULL;
+}
+
+/** rio_request_outb_region -- Request IO region and get outbound region
+ *                             for RapidIO outbound mapping
+ * @mport: Master port
+ * @dev_id: RIO device specific pointer to pass
+ * @size: Request IO size
+ * @name: The request IO resource name
+ * @owner: The outbound region owned driver
+ *
+ * Return: The rio_mem descriptor with IO region resource.
+ *
+ * This function request IO region firstly and ioremap it for preparing
+ * outbound window mapping. And it will find the RapidIO region owned by
+ * the driver id. Then map it. Be careful about that the ioremap can not
+ * be called in the interrupt event action function.
+ */
+struct rio_mem *rio_request_outb_region(struct rio_mport *mport, void *dev_id,
+			resource_size_t size, const char *name, u32 owner)
+{
+	struct rio_mem *rmem = NULL;
+	struct rio_dev *dev = dev_id;
+
+	if (!dev)
+		goto err;
+
+	rmem = rio_prepare_io_mem(mport, dev, size, name);
+	if (!rmem)
+		goto err;
+
+	if (rio_space_find_mem(mport, dev->destid, owner, &rmem->riores)) {
+		ERR("Can not find RIO region meet the ownerid %x\n", owner);
+		goto err;
+	}
+
+	/* Map the rio space to local */
+	if (rio_map_outb_region(mport, dev->destid, rmem, 0)) {
+		ERR("RIO map outb error!\n");
+		goto err;
+	}
+	return rmem;
+err:
+	rio_release_outb_region(mport, rmem);
+	return NULL;
+}
+
+/**
  * rio_mport_get_feature - query for devices' extended features
  * @port: Master port to issue transaction
  * @local: Indicate a local master port or remote device access
@@ -476,8 +839,8 @@ int rio_init_mports(void)
 					port->iores.end - port->iores.start,
 					port->name)) {
 			printk(KERN_ERR
-			       "RIO: Error requesting master port region %8.8lx-%8.8lx\n",
-			       port->iores.start, port->iores.end - 1);
+			       "RIO: Error requesting master port region %016llx-%016llx\n",
+			       (u64)port->iores.start, (u64)port->iores.end - 1);
 			rc = -ENOMEM;
 			goto out;
 		}
@@ -486,6 +849,7 @@ int rio_init_mports(void)
 			rio_enum_mport(port);
 		else
 			rio_disc_mport(port);
+		rio_space_init(port);
 	}
 
       out:
@@ -508,3 +872,119 @@ EXPORT_SYMBOL_GPL(rio_request_inb_mbox);
 EXPORT_SYMBOL_GPL(rio_release_inb_mbox);
 EXPORT_SYMBOL_GPL(rio_request_outb_mbox);
 EXPORT_SYMBOL_GPL(rio_release_outb_mbox);
+
+#ifdef CONFIG_RAPIDIO_PROC_FS
+enum { MAX_IORES_LEVEL = 5 };
+
+struct riors {
+	struct rio_mport *mp;
+	int res;
+	struct resource *p;
+} riomres;
+
+static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct resource *p = v;
+	struct riors *rs = m->private;
+
+	(*pos)++;
+	if (p->child)
+		return p->child;
+	while (!p->sibling && p->parent)
+		p = p->parent;
+	if (p->sibling)
+		return p->sibling;
+	else {
+		rs->res++;
+		if(rs->res >= RIO_MAX_MPORT_RESOURCES) {
+			rs->mp = list_entry(rs->mp->node.next, struct rio_mport, node);
+			rs->res = 0;
+			if (&rs->mp->node == &rio_mports)
+				return NULL;
+		}
+		seq_printf(m, "%2d: ", rs->res);
+		rs->p = &rs->mp->riores[rs->res];
+		p = rs->p;
+
+		return p;
+	}
+}
+
+static void *r_start(struct seq_file *m, loff_t *pos)
+{
+	struct riors *rs = m->private;
+	struct resource *p;
+
+	if (*pos) {
+		*pos = 0;
+		return NULL;
+	}
+
+	rs->mp = list_entry(rio_mports.next, struct rio_mport, node);
+	rs->res = -1;
+	rs->p = &rs->mp->iores;
+	p = rs->p;
+
+	seq_printf(m, "IO: ");
+
+	return p;
+}
+
+static void r_stop(struct seq_file *m, void *v)
+{
+}
+
+static int r_show(struct seq_file *m, void *v)
+{
+	struct riors *rs = m->private;
+	struct resource *root = rs->p;
+	struct resource *r = v, *p;
+	int width = root->end < 0x10000 ? 4 : 8;
+	int depth;
+
+	for (depth = 0, p = r; p->parent && depth < MAX_IORES_LEVEL; depth++, p = p->parent)
+		if (p == root)
+			break;
+	seq_printf(m, "%*s%0*llx-%0*llx : %s\n",
+			depth * 2, "",
+			width, (unsigned long long) r->start,
+			width, (unsigned long long) r->end,
+			r->name ? r->name : "<BAD>");
+	return 0;
+}
+
+static const struct seq_operations resource_op = {
+	.start	= r_start,
+	.next	= r_next,
+	.stop	= r_stop,
+	.show	= r_show,
+};
+
+static int riores_open(struct inode *inode, struct file *file)
+{
+	int res = seq_open(file, &resource_op);
+	if (!res) {
+		struct seq_file *m = file->private_data;
+		m->private = &riomres;
+	}
+	return res;
+}
+
+static const struct file_operations proc_riores_operations = {
+	.open		= riores_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init rioresources_init(void)
+{
+	struct proc_dir_entry *entry;
+
+	entry = create_proc_entry("riores", 0, NULL);
+	if (entry)
+		entry->proc_fops = &proc_riores_operations;
+	return 0;
+}
+__initcall(rioresources_init);
+#endif
diff --git a/drivers/rapidio/rio.h b/drivers/rapidio/rio.h
index b242cee..7a3b62e 100644
--- a/drivers/rapidio/rio.h
+++ b/drivers/rapidio/rio.h
@@ -51,10 +51,5 @@ extern struct rio_route_ops __end_rio_route_ops[];
 	DECLARE_RIO_ROUTE_SECTION(.rio_route_ops,			\
 			vid, did, add_hook, get_hook)
 
-#ifdef CONFIG_RAPIDIO_8_BIT_TRANSPORT
-#define RIO_GET_DID(x)	((x & 0x00ff0000) >> 16)
-#define RIO_SET_DID(x)	((x & 0x000000ff) << 16)
-#else
-#define RIO_GET_DID(x)	(x & 0xffff)
-#define RIO_SET_DID(x)	(x & 0xffff)
-#endif
+#define RIO_GET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x00ff0000) >> 16))
+#define RIO_SET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x000000ff) << 16))
diff --git a/drivers/rapidio/sallocator/Kconfig b/drivers/rapidio/sallocator/Kconfig
new file mode 100644
index 0000000..a33a1b8
--- /dev/null
+++ b/drivers/rapidio/sallocator/Kconfig
@@ -0,0 +1,9 @@
+choice
+	prompt "Default RapidIO Space Allocator"
+	depends on RAPIDIO
+	default RIO_SA_DEFAULT_BITMAP
+
+	config RIO_SA_DEFAULT_BITMAP
+		bool "Bitmap"
+
+endchoice
diff --git a/drivers/rapidio/sallocator/Makefile b/drivers/rapidio/sallocator/Makefile
new file mode 100644
index 0000000..437201c
--- /dev/null
+++ b/drivers/rapidio/sallocator/Makefile
@@ -0,0 +1,12 @@
+#
+# Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+#
+# Author: Zhang Wei, wei.zhang@freescale.com, Jun 2007
+#
+# This is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+
+obj-$(CONFIG_RIO_SA_DEFAULT_BITMAP) += bitmap.o
diff --git a/drivers/rapidio/sallocator/bitmap.c b/drivers/rapidio/sallocator/bitmap.c
new file mode 100644
index 0000000..d10bbf9
--- /dev/null
+++ b/drivers/rapidio/sallocator/bitmap.c
@@ -0,0 +1,383 @@
+/*
+ * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ * Author: Zhang Wei, wei.zhang@freescale.com, Jun 2007
+ *
+ * Description:
+ * RapidIO space allocator bitmap arithmetic.
+ * The Bitmap allocator make the whole RapidIO device have the same fixed
+ * inbound memory window. And on the top of each device inbound window,
+ * there is a sect0 area, which will use for recording the individual
+ * driver owned memory space in device.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/rio.h>
+#include <linux/rio_drv.h>
+#include <linux/rio_ids.h>
+#include <linux/rio_regs.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/dma-mapping.h>
+
+#include "../rio.h"
+
+#undef DEBUG
+
+#define RIO_SBLOCK_SIZE	4096
+
+#define ERR(fmt, arg...) \
+	printk(KERN_ERR "ERROR %s - %s: " fmt,  __FILE__, __FUNCTION__, ## arg)
+#ifdef DEBUG
+#define DBG(fmt...) printk(fmt)
+#else
+#define DBG(fmt...) do {} while (0)
+#endif
+
+#define IS_64BIT_RES ((sizeof(resource_size_t) == 8) ? 1 : 0)
+#define SA_BITMAP_DRV_ID	0x4249544d
+#define SA_RIO_RESERVE_SPACE	0x4000000
+
+/* Definition for struct rio_res:ctrl */
+#define SA_RIO_RES_CTRL_EN	0x80000000
+struct rio_res {
+	u32 ctrl;	/* Control words
+			 * Bit 31: Enable bit.
+			 */
+	u32 addr;	/* The start addr bits [0-31] of RapidIO window */
+	u32 extaddr;	/* The start addr bits [32-63] of RapidIO window */
+	u32 size;	/* The size bits [0-31] of RapidIO window */
+	u32 extsize;	/* The size bits [32-63] of RapidIO window */
+	u32 owner;	/* The owner driver id */
+	u32 rev[2];	/* For align 32 bytes */
+};
+
+#define SA_BITMAP_MAX_INB_RES	32
+struct rio_sect0 {
+	u32	id;		/* ID for Bitmap space allocater driver */
+	u32	rioid;		/* RapidIO device id */
+	u32	width;		/* The resource width for RIO space, 32 or 64 */
+	u8	rev1[56];	/* Align to 64 bytes */
+	struct rio_res inb_res[SA_BITMAP_MAX_INB_RES];
+	u8	rev2[4096 - 64 - SA_BITMAP_MAX_INB_RES * 32];
+				/* Fill for 4096 bytes */
+};
+
+/* if select 64bit resource, we can use 34-bit rio address, otherwise 32-bit */
+static int rio_addr_size;
+static struct resource *root;
+static struct rio_mem sect0mem;		/* Sect 0 memory data */
+static struct rio_sect0	*sect0;
+static struct rio_mem *sblock_buf;
+
+/**
+ * get_rio_addr_size -- get the RapidIO space address size.
+ *
+ * If it's a 64-bit system, the RapidIO space address size could be 34bit,
+ * otherwise, it should be 32 bit.
+ */
+static inline int get_rio_addr_size(void)
+{
+	return (sizeof(resource_size_t) == 8) ? 34 : 32;
+}
+
+/**
+ * rio_space_request -- request RapidIO space.
+ * @mport: RIO master port.
+ * @size: The request space size, must >= 4096.
+ * @new: The resource which required.
+ *
+ * Return:
+ *	0 -- Success
+ *	-EINVAL -- size is wrong (<4096)
+ *	-EFAULT -- new is NULL
+ *	others -- return from allocate_resource()
+ *
+ * This function request a memory from RapidIO space.
+ */
+int rio_space_request(struct rio_mport *mport, resource_size_t size,
+			struct resource *new)
+{
+	int ret = 0;
+
+	/* Align the size to 2^N */
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	memset(new, 0, sizeof(struct resource));
+
+	ret = allocate_resource(root, new, size, root->start, root->end,
+			size, NULL, 0);
+	if (ret) {
+		ERR("No more resource for size 0x%08x!\n", size);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+#ifdef DEBUG
+/**
+ * rio_sa_dump_sect0 -- Dump the sect0 content.
+ * @psect0: The point of sect0
+ */
+static void rio_sa_dump_sect0(struct rio_sect0 *psect0)
+{
+	int i;
+
+	if (!psect0)
+		return;
+
+	printk("Rio Sect0 %p dump:\n", psect0);
+	printk("...id = 0x%08x, width = %d, rioid = %d \n",
+			psect0->id, psect0->width, psect0->rioid);
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if (psect0->inb_res[i].ctrl & SA_RIO_RES_CTRL_EN)
+			printk("...inb_res[%d]: ctrl 0x%08x, owner 0x%08x\n"
+				"\t\textaddr 0x%08x, addr 0x%08x\n"
+				"\t\textsize 0x%08x, size 0x%08x\n", i,
+			       psect0->inb_res[i].ctrl,
+			       psect0->inb_res[i].owner,
+			       psect0->inb_res[i].extaddr,
+			       psect0->inb_res[i].addr,
+			       psect0->inb_res[i].extsize,
+			       psect0->inb_res[i].size);
+}
+#endif
+
+/**
+ * rio_space_claim -- Claim the memory in RapidIO space
+ * @mem: The memory should be claimed.
+ *
+ * When you get a memory space and get ready of it, you should claim it in
+ * RapidIO space. Then, the other device could get the memory by calling
+ * rio_space_find_mem().
+ */
+int rio_space_claim(struct rio_mem *mem)
+{
+	int i;
+
+	if (!sect0) {
+		ERR("Sect0 is NULL!\n");
+		return -EINVAL;
+	}
+#ifdef DEBUG
+	rio_sa_dump_sect0(sect0);
+#endif
+
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if (!(sect0->inb_res[i].ctrl & SA_RIO_RES_CTRL_EN)) {
+			sect0->inb_res[i].ctrl |= SA_RIO_RES_CTRL_EN;
+			sect0->inb_res[i].addr = (u32)(mem->riores.start);
+			sect0->inb_res[i].size = (u32)(mem->riores.end
+					- mem->riores.start + 1);
+			if (IS_64BIT_RES) {
+				sect0->inb_res[i].extaddr =
+					(u64)mem->riores.start >> 32;
+				sect0->inb_res[i].extsize =
+					(u64)(mem->riores.end
+						- mem->riores.start + 1) >> 32;
+			}
+			sect0->inb_res[i].owner = mem->owner;
+			DBG("The new inbound rio mem added:\n");
+			DBG("...inb_res[%d]: ctrl 0x%08x, owner 0x%08x\n"
+				"\t\textaddr 0x%08x, addr 0x%08x\n"
+				"\t\textsize 0x%08x, size 0x%08x\n", i,
+			       sect0->inb_res[i].ctrl,
+			       sect0->inb_res[i].owner,
+			       sect0->inb_res[i].extaddr,
+			       sect0->inb_res[i].addr,
+			       sect0->inb_res[i].extsize,
+			       sect0->inb_res[i].size);
+			return 0;
+		}
+
+	ERR("No free inbound window!\n");
+	return -EBUSY;
+}
+
+/**
+ * rio_space_release -- remove the memory record from RapidIO space.
+ *		        It's the pair function of rio_space_claim().
+ *
+ * @inbmem: The memory should be release.
+ */
+void rio_space_release(struct rio_mem *inbmem)
+{
+	int i;
+
+	/* Remove it from sect0 inb_res array */
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if ((sect0->inb_res[i].ctrl & SA_RIO_RES_CTRL_EN) &&
+				(((u64)sect0->inb_res[i].extaddr << 32 |
+				  sect0->inb_res[i].addr)
+				== (u64)inbmem->riores.start)) {
+			sect0->inb_res[i].ctrl = 0;
+			sect0->inb_res[i].addr = 0;
+			sect0->inb_res[i].extaddr = 0;
+			sect0->inb_res[i].size = 0;
+			sect0->inb_res[i].extsize = 0;
+		}
+}
+
+/**
+ * rio_space_get_dev_mem -- get the whole owned inbound space of
+ *			    RapidIO device with did.
+ */
+static struct resource *rio_space_get_dev_mem(struct rio_mport *mport,
+		u16 did, struct resource *res)
+{
+	if(!res && !(res = kmalloc(sizeof(struct resource), GFP_KERNEL))) {
+		ERR("resource alloc error!\n");
+		return NULL;
+	}
+	memset(res, 0, sizeof(struct resource));
+
+	res->start = SA_RIO_RESERVE_SPACE + (did
+		<< (rio_addr_size - __ilog2(RIO_ANY_DESTID(mport->sys_size)
+						+ 1)));
+	res->end = res->start +
+		(1 << (rio_addr_size - __ilog2(RIO_ANY_DESTID(mport->sys_size)
+						+ 1))) - 1;
+	res->flags = RIO_RESOURCE_MEM;
+
+	return res;
+}
+
+/**
+ * rio_space_find_mem -- Find the memory space (RIO) of the rio driver owned.
+ * @mport: RIO master port.
+ * @tid: The target RapidIO device id which will be searched.
+ * @owner: The driver id as the search keyword.
+ * @res: The result of finding.
+ *
+ * return:
+ *	0 -- Success
+ *	-EFAULT -- Remote sect0 is a bad address
+ *	-EPROTONOSUPPORT -- The remote space allocator protocol is not support
+ *
+ * This function will find the memory located in RapidIO space, which is owned
+ * by the driver. If the remote RapidIO device use the diffrent space allocator,
+ * it will return -EPROTONOSUPPORT.
+ */
+int rio_space_find_mem(struct rio_mport *mport, u16 tid,
+			u32 owner, struct resource *res)
+{
+	volatile struct rio_sect0 __iomem *rsect0;
+	int i;
+	int ret = 0;
+	u32 width;
+
+	rio_space_get_dev_mem(mport, tid, &sblock_buf->riores);
+	sblock_buf->size = RIO_SBLOCK_SIZE;
+	rio_map_outb_region(mport, tid, sblock_buf, 0);
+
+	if (!sblock_buf->virt) {
+		ERR("Sect0 block buffer is NULL!\n");
+		ret = -EFAULT;
+		goto out;
+	}
+	rsect0 = sblock_buf->virt;
+
+	if (in_be32(&rsect0->id) != SA_BITMAP_DRV_ID) {
+		DBG("The target RapidIO space allocator is not rio_sa_bitmap! "
+				"id = 0x%x\n", rsect0->id);
+		ret = -EPROTONOSUPPORT;
+		goto out;
+	}
+
+#ifdef DEBUG
+	/* Dump remote sect0 for debug */
+	DBG("Dump the remote RIO dev %d sect0\n", tid);
+	rio_sa_dump_sect0(rsect0);
+#endif
+
+	width = in_be32(&rsect0->width);
+	if (sizeof(resource_size_t) * 8 < width)
+		printk(KERN_WARNING "WARNING: The system width %d is smaller "
+			"than the remote RapidIO space address width %d!",
+			sizeof(resource_size_t) * 8, width);
+
+	/* Find the rio space block */
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if ((in_be32(&rsect0->inb_res[i].ctrl) & SA_RIO_RES_CTRL_EN)
+			  && (in_be32(&rsect0->inb_res[i].owner) == owner )) {
+			if (!res) {
+				ERR("Resource NULL error!\n");
+				ret = -EFAULT;
+				goto out;
+			}
+			memset(res, 0, sizeof(struct resource));
+			res->start = (IS_64BIT_RES && (width > 32)) ?
+				in_be32(&rsect0->inb_res[i].extaddr) << 32 : 0
+				| rsect0->inb_res[i].addr;
+			res->end = res->start - 1 +
+				  ((in_be32(&rsect0->inb_res[i].size)) |
+				  ((IS_64BIT_RES && (width > 32)) ?
+				  ((u64)(in_be32(&rsect0->inb_res[i].extsize))
+				   << 32) : 0));
+			goto out;
+		}
+
+out:
+	rio_unmap_outb_region(mport, sblock_buf);
+	return ret;
+}
+
+/**
+ * rio_space_init -- RapidIO space allocator initialization function.
+ * @mport: The master port.
+ */
+int rio_space_init(struct rio_mport *mport)
+{
+	root = &mport->riores[RIO_INB_MEM_RESOURCE];
+	memset(root, 0, sizeof(struct resource));
+
+	rio_addr_size = get_rio_addr_size();
+
+	rio_space_get_dev_mem(mport, rio_get_mport_id(mport), root);
+	root->name = "rio_space_inb";
+
+	/* Alloc the sect 0 for space managerment */
+	memset(&sect0mem, 0, sizeof(struct rio_mem));
+	if(!(sect0mem.virt = dma_alloc_coherent(NULL, RIO_SBLOCK_SIZE,
+					&sect0mem.iores.start, GFP_KERNEL))) {
+		ERR("sect0 memory alloc error!\n");
+		return -ENOMEM;
+	}
+	sect0mem.iores.end = sect0mem.iores.start + RIO_SBLOCK_SIZE - 1;
+	sect0mem.size = RIO_SBLOCK_SIZE;
+
+	if(rio_space_request(mport, RIO_SBLOCK_SIZE, &sect0mem.riores))
+		return -ENOMEM;
+
+	sect0mem.riores.name = "sect 0";
+	sect0 = sect0mem.virt;
+	sect0->id = SA_BITMAP_DRV_ID;
+	sect0->rioid = rio_get_mport_id(mport);
+	sect0->width = rio_addr_size;
+
+	/* map outbond window to access rio inb */
+	rio_map_inb_region(mport, &sect0mem, 0);
+
+	/* Init sblock buffer for block seeking */
+	sblock_buf = rio_prepare_io_mem(mport, NULL, RIO_SBLOCK_SIZE,
+			"sblock_buf");
+	if (!sblock_buf)
+		return -ENOMEM;
+
+	return 0;
+}
diff --git a/include/linux/rio.h b/include/linux/rio.h
index 68e3f68..d39d381 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -23,7 +23,6 @@
 #include <linux/device.h>
 #include <linux/rio_regs.h>
 
-#define RIO_ANY_DESTID		0xff
 #define RIO_NO_HOPCOUNT		-1
 #define RIO_INVALID_DESTID	0xffff
 
@@ -39,11 +38,8 @@
 					   entry is invalid (no route
 					   exists for the device ID) */
 
-#ifdef CONFIG_RAPIDIO_8_BIT_TRANSPORT
-#define RIO_MAX_ROUTE_ENTRIES	(1 << 8)
-#else
-#define RIO_MAX_ROUTE_ENTRIES	(1 << 16)
-#endif
+#define RIO_MAX_ROUTE_ENTRIES(size)	(size ? (1 << 16) : (1 << 8))
+#define RIO_ANY_DESTID(size)		(size ? 0xffff : 0xff)
 
 #define RIO_MAX_MBOX		4
 #define RIO_MAX_MSG_SIZE	0x1000
@@ -69,6 +65,8 @@
 #define RIO_DOORBELL_RESOURCE	0
 #define RIO_INB_MBOX_RESOURCE	1
 #define RIO_OUTB_MBOX_RESOURCE	2
+#define RIO_INB_MEM_RESOURCE	3
+#define RIO_OUTB_MEM_RESOURCE	4
 
 extern struct bus_type rio_bus_type;
 extern struct list_head rio_devices;	/* list of all devices */
@@ -149,6 +147,11 @@ struct rio_dbell {
 	void *dev_id;
 };
 
+enum rio_phy_type {
+	RIO_PHY_PARALLEL,
+	RIO_PHY_SERIAL,
+};
+
 /**
  * struct rio_mport - RIO master port info
  * @dbells: List of doorbell events
@@ -174,9 +177,16 @@ struct rio_mport {
 	struct rio_msg outb_msg[RIO_MAX_MBOX];
 	int host_deviceid;	/* Host device ID */
 	struct rio_ops *ops;	/* maintenance transaction functions */
+	struct rio_mem_ops *mops; /* Memory functions */
 	unsigned char id;	/* port ID, unique among all ports */
 	unsigned char index;	/* port index, unique among all port
 				   interfaces of the same type */
+	unsigned int sys_size;	/* RapidIO common transport system size.
+				 * 0 - Small size. 256 devices.
+				 * 1 - Large size, 65536 devices.
+				 */
+	enum rio_phy_type phy_type; /* RapidIO phy type */
+	void *priv;		/* Master port private data */
 	unsigned char name[40];
 };
 
@@ -211,7 +221,7 @@ struct rio_switch {
 	u16 switchid;
 	u16 hopcount;
 	u16 destid;
-	u8 route_table[RIO_MAX_ROUTE_ENTRIES];
+	u16 *route_table;
 	int (*add_entry) (struct rio_mport * mport, u16 destid, u8 hopcount,
 			  u16 table, u16 route_destid, u8 route_port);
 	int (*get_entry) (struct rio_mport * mport, u16 destid, u8 hopcount,
@@ -229,18 +239,19 @@ struct rio_switch {
  * @dsend: Callback to send a doorbell message.
  */
 struct rio_ops {
-	int (*lcread) (int index, u32 offset, int len, u32 * data);
-	int (*lcwrite) (int index, u32 offset, int len, u32 data);
-	int (*cread) (int index, u16 destid, u8 hopcount, u32 offset, int len,
+	int (*lcread) (struct rio_mport *, int index, u32 offset, int len, u32 * data);
+	int (*lcwrite) (struct rio_mport *, int index, u32 offset, int len, u32 data);
+	int (*cread) (struct rio_mport *, int index, u16 destid, u8 hopcount, u32 offset, int len,
 		      u32 * data);
-	int (*cwrite) (int index, u16 destid, u8 hopcount, u32 offset, int len,
+	int (*cwrite) (struct rio_mport *, int index, u16 destid, u8 hopcount, u32 offset, int len,
 		       u32 data);
-	int (*dsend) (int index, u16 destid, u16 data);
+	int (*dsend) (struct rio_mport *, int index, u16 destid, u16 data);
 };
 
 #define RIO_RESOURCE_MEM	0x00000100
 #define RIO_RESOURCE_DOORBELL	0x00000200
 #define RIO_RESOURCE_MAILBOX	0x00000400
+#define RIO_RESOURCE_MAINT	0x00000800
 
 #define RIO_RESOURCE_CACHEABLE	0x00010000
 #define RIO_RESOURCE_PCI	0x00020000
@@ -309,6 +320,42 @@ struct rio_route_ops {
 			 u16 table, u16 route_destid, u8 * route_port);
 };
 
+/**
+ * Struct for RIO memory definition.
+ * @node: Node in list of memories
+ * @virt: The virtual address for mapped memory accessing.
+ * @owner: The owner id of this memory.
+ * @size: The size of memory space, it should same to iores and riores.
+ * @iores: The resource of local IO region for mapping.
+ * @riores: The resource of mapped RapidIO space region.
+ */
+struct rio_mem {
+	struct list_head node;
+	void *virt;
+	u32 owner;
+	resource_size_t size;
+	struct resource iores;
+	struct resource riores;
+};
+
+/**
+ * Struct for RIO memory definition.
+ * @map_inb: The function for mapping inbound memory window.
+ * @map_outb: The function for mapping outbound memory window.
+ * @unmap_inb: The function for unmapping inbound memory window.
+ * @unmap_outb: The function for unmapping outbound memory window.
+ */
+struct rio_mem_ops {
+	int (*map_inb) (struct rio_mport *, resource_size_t lstart,
+			resource_size_t rstart,
+			resource_size_t size, u32 flags);
+	int (*map_outb) (struct rio_mport *, resource_size_t lstart,
+			resource_size_t rstart,
+			resource_size_t size, u16 tid, u32 flags);
+	void (*unmap_inb) (struct rio_mport *, resource_size_t lstart);
+	void (*unmap_outb) (struct rio_mport *, resource_size_t lstart);
+};
+
 /* Architecture and hardware-specific functions */
 extern int rio_init_mports(void);
 extern void rio_register_mport(struct rio_mport *);
diff --git a/include/linux/rio_drv.h b/include/linux/rio_drv.h
index 7adb2a1..70f778b 100644
--- a/include/linux/rio_drv.h
+++ b/include/linux/rio_drv.h
@@ -334,6 +334,16 @@ static inline void rio_init_dbell_res(struct resource *res, u16 start, u16 end)
 	res->flags = RIO_RESOURCE_DOORBELL;
 }
 
+static inline void rio_init_io_res(struct resource *res, resource_size_t start,
+		resource_size_t end, const char *name, unsigned long flag)
+{
+	memset(res, 0, sizeof(struct resource));
+	res->start = start;
+	res->end = end;
+	res->name = name;
+	res->flags = flag;
+}
+
 /**
  * RIO_DEVICE - macro used to describe a specific RIO device
  * @dev: the 16 bit RIO device ID
@@ -408,13 +418,33 @@ extern int rio_request_inb_dbell(struct rio_mport *, void *, u16, u16,
 extern int rio_release_inb_dbell(struct rio_mport *, u16, u16);
 extern struct resource *rio_request_outb_dbell(struct rio_dev *, u16, u16);
 extern int rio_release_outb_dbell(struct rio_dev *, struct resource *);
+extern struct resource *rio_request_io_region(struct rio_mport *, void *,
+				u32, u32, const char *, unsigned long,
+				struct resource *);
+extern struct rio_mem *rio_prepare_io_mem(struct rio_mport *, struct rio_dev *,
+				resource_size_t, const char *);
 
 /* Memory region management */
-int rio_claim_resource(struct rio_dev *, int);
-int rio_request_regions(struct rio_dev *, char *);
-void rio_release_regions(struct rio_dev *);
-int rio_request_region(struct rio_dev *, int, char *);
-void rio_release_region(struct rio_dev *, int);
+extern struct rio_mem *rio_request_inb_region(struct rio_mport *, void *,
+				resource_size_t, const char *, u32);
+extern struct rio_mem *rio_request_outb_region(struct rio_mport *,
+		void *, resource_size_t, const char *, u32);
+extern int rio_release_inb_region(struct rio_mport *, struct rio_mem *);
+extern int rio_release_outb_region(struct rio_mport *, struct rio_mem *);
+
+/* Memory low-level mapping functions */
+extern int rio_map_inb_region(struct rio_mport *, struct rio_mem *, u32);
+extern int rio_map_outb_region(struct rio_mport *, u16, struct rio_mem *, u32);
+extern void rio_unmap_inb_region(struct rio_mport *, struct rio_mem *);
+extern void rio_unmap_outb_region(struct rio_mport *, struct rio_mem *);
+
+/* Memory Allocator */
+extern int rio_space_request(struct rio_mport *, resource_size_t,
+						struct resource *);
+extern int rio_space_find_mem(struct rio_mport *, u16, u32, struct resource *);
+extern int rio_space_init(struct rio_mport *);
+extern int rio_space_claim(struct rio_mem *);
+extern void rio_space_release(struct rio_mem *);
 
 /* LDM support */
 int rio_register_driver(struct rio_driver *);
@@ -464,6 +494,7 @@ extern u16 rio_local_get_device_id(struct rio_mport *port);
 extern struct rio_dev *rio_get_device(u16 vid, u16 did, struct rio_dev *from);
 extern struct rio_dev *rio_get_asm(u16 vid, u16 did, u16 asm_vid, u16 asm_did,
 				   struct rio_dev *from);
+extern u32 rio_get_mport_id(struct rio_mport *);
 
 #endif				/* __KERNEL__ */
 #endif				/* LINUX_RIO_DRV_H */
-- 
1.5.2

