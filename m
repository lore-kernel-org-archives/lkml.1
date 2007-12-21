Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbXLUKhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbXLUKhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbXLUKhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:37:42 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:54718 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXLUKhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:37:40 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, paulus@samba.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 2/3] (Resend part #1) Add the RapidIO support to powerpc architecture with memory mapping support.
Date: Fri, 21 Dec 2007 17:58:43 +0800
Message-Id: <11982311233889-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.2
X-OriginalArrivalTime: 21 Dec 2007 09:48:34.0786 (UTC) FILETIME=[A72C3420:01C843B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds the RapidIO support to powerpc with of-device support.
New Serial RapidIO of new Freescale processor, such as MPC8548, MPC8568,
is also added.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/Kconfig                |   12 +
 arch/powerpc/platforms/85xx/Kconfig |    1 +
 arch/powerpc/platforms/86xx/Kconfig |    1 +
 arch/powerpc/sysdev/Makefile        |    1 +
 arch/powerpc/sysdev/fsl_rio.c       | 1130 ++++++++++++++++++++++++++---------
 5 files changed, 861 insertions(+), 284 deletions(-)

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
-- 
1.5.2

