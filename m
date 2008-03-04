Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbYCDIhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbYCDIhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbYCDIbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:31:08 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:42859 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbYCDIbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:31:06 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 09/17] Add serial RapidIO controller support, which includes MPC8548, MPC8641.
Date: Wed,  5 Mar 2008 00:29:54 +0800
Message-Id: <1204648202-5495-9-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1204648202-5495-8-git-send-email-wei.zhang@freescale.com>
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-3-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-4-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-6-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-7-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-8-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 04 Mar 2008 08:30:35.0672 (UTC) FILETIME=[04C59180:01C87DD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c |   74 +++++++++++++++++++++++++++++++++++-----
 include/linux/rio.h           |    6 +++
 2 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 9dae418..1535d12 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -21,6 +21,7 @@
 #include <linux/rio.h>
 #include <linux/rio_drv.h>
 #include <linux/of_platform.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 
@@ -30,7 +31,12 @@
 #define IRQ_RIO_RX(m)		(((struct rio_priv *)(m->priv))->rxirq)
 
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
 
@@ -69,7 +75,7 @@
 
 struct rio_atmu_regs {
 	u32 rowtar;
-	u32 pad1;
+	u32 rowtear;
 	u32 rowbar;
 	u32 pad2;
 	u32 rowar;
@@ -95,7 +101,15 @@ struct rio_msg_regs {
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
@@ -175,8 +189,22 @@ static int fsl_rio_doorbell_send(struct rio_mport *mport,
 	struct rio_priv *priv = mport->priv;
 	pr_debug("fsl_doorbell_send: index %d destid %4.4x data %4.4x\n",
 		 index, destid, data);
-	out_be32(&priv->dbell_atmu_regs->rowtar, destid << 22);
-	out_be16(priv->dbell_win, data);
+	switch (mport->phy_type) {
+	case RIO_PHY_PARALLEL:
+		out_be32(&priv->dbell_atmu_regs->rowtar, destid << 22);
+		out_be16(priv->dbell_win, data);
+		break;
+	case RIO_PHY_SERIAL:
+		/* In the serial version silicons, such as MPC8548, MPC8641,
+		 * below operations is must be.
+		 */
+		out_be32(&priv->msg_regs->odmr, 0x00000000);
+		out_be32(&priv->msg_regs->odretcr, 0x00000004);
+		out_be32(&priv->msg_regs->oddpr, destid << 16);
+		out_be32(&priv->msg_regs->oddatr,data );
+		out_be32(&priv->msg_regs->odmr, 0x00000001);
+		break;
+	}
 
 	return 0;
 }
@@ -342,11 +370,22 @@ rio_hw_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 		memset(priv->msg_tx_ring.virt_buffer[priv->msg_tx_ring.tx_slot]
 				+ len, 0, RIO_MAX_MSG_SIZE - len);
 
-	/* Set mbox field for message */
-	desc->dport = mbox & 0x3;
+	switch(mport->phy_type) {
+	case RIO_PHY_PARALLEL:
+		/* Set mbox field for message */
+		desc->dport = mbox & 0x3;
 
-	/* Enable EOMI interrupt, set priority, and set destid */
-	desc->dattr = 0x28000000 | (rdev->destid << 2);
+		/* Enable EOMI interrupt, set priority, and set destid */
+		desc->dattr = 0x28000000 | (rdev->destid << 2);
+		break;
+	case RIO_PHY_SERIAL:
+		/* Set mbox field for message, and set destid */
+		desc->dport = (rdev->destid << 16) | ( mbox & 0x3);
+
+		/* Enable EOMI interrupt and priority */
+		desc->dattr = 0x28000000;
+		break;
+	}
 
 	/* Set transfer size aligned to next power of 2 (in double words) */
 	desc->dwcnt = is_power_of_2(len) ? len : 1 << get_bitmask_order(len);
@@ -923,6 +962,7 @@ int fsl_rio_setup(struct of_device *dev)
 	const u32 *dt_range, *cell;
 	struct resource regs;
 	int rlen;
+	u32 ccsr;
 	u64 law_start, law_size;
 	int paw, aw, sw;
 
@@ -1011,6 +1051,14 @@ int fsl_rio_setup(struct of_device *dev)
 
 	priv->regs_win = (u32) ioremap(regs.start, regs.end - regs.start + 1);
 
+	/* Probe the master port phy type */
+	ccsr = in_be32(priv->regs_win + RIO_CCSR);
+	port->phy_type = (ccsr & 1) ? RIO_PHY_SERIAL : RIO_PHY_PARALLEL;
+	dev_info(&dev->dev, "RapidIO PHY type: %s\n",
+			(port->phy_type == RIO_PHY_PARALLEL) ? "parallel" :
+			((port->phy_type == RIO_PHY_SERIAL) ? "serial" :
+			 "unknown"));
+
 	port->sys_size = (in_be32((priv->regs_win + RIO_PEF_CAR))
 					& RIO_PEF_CTLS) >> 4;
 	dev_info(&dev->dev, "RapidIO Common Transport System size: %d\n",
@@ -1020,7 +1068,13 @@ int fsl_rio_setup(struct of_device *dev)
 					+ RIO_ATMU_REGS_OFFSET);
 	priv->maint_atmu_regs = priv->atmu_regs + 1;
 	priv->dbell_atmu_regs = priv->atmu_regs + 2;
-	priv->msg_regs = (struct rio_msg_regs *)(priv->regs_win + RIO_MSG_REGS_OFFSET);
+	priv->msg_regs = (struct rio_msg_regs *)(priv->regs_win +
+				((port->phy_type == RIO_PHY_SERIAL) ?
+				RIO_S_MSG_REGS_OFFSET : RIO_P_MSG_REGS_OFFSET));
+
+	/* Set to receive any dist ID for serial RapidIO controller. */
+	if (port->phy_type == RIO_PHY_SERIAL)
+		out_be32((priv->regs_win + RIO_ISR_AACR), RIO_ISR_AACR_AA);
 
 	/* Configure maintenance transaction window */
 	out_be32(&priv->maint_atmu_regs->rowbar, 0x000c0000);
diff --git a/include/linux/rio.h b/include/linux/rio.h
index 4b0156d..b96cdf4 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -145,6 +145,11 @@ struct rio_dbell {
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
@@ -178,6 +183,7 @@ struct rio_mport {
 				 * 0 - Small size. 256 devices.
 				 * 1 - Large size, 65536 devices.
 				 */
+	enum rio_phy_type phy_type;	/* RapidIO phy type */
 	unsigned char name[40];
 	void *priv;		/* Master port private data */
 };
-- 
1.5.4

