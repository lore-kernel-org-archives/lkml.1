Return-Path: <linux-kernel-owner+w=401wt.eu-S1761132AbYCDIgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132AbYCDIgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYCDIbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:31:07 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:42858 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbYCDIbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:31:06 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 14/17] Add the RapidIO master port maintance and doorbell window to space resources.
Date: Wed,  5 Mar 2008 00:29:59 +0800
Message-Id: <1204648202-5495-14-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1204648202-5495-13-git-send-email-wei.zhang@freescale.com>
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-3-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-4-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-6-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-7-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-8-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-9-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-10-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-11-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-12-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-13-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 04 Mar 2008 08:30:37.0032 (UTC) FILETIME=[05951680:01C87DD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the RapidIO master port maintance and doorbell IO windows to
RIO space resources.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c |   26 +++++++++++++++++++++-----
 include/linux/rio.h           |    1 +
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index c260ae5..350db4e 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -192,6 +192,8 @@ struct rio_priv {
 	int bellirq;
 	int txirq;
 	int rxirq;
+	struct resource maint_res;
+	struct resource dbell_res;
 };
 
 /**
@@ -1363,15 +1365,29 @@ int fsl_rio_setup(struct of_device *dev)
 		out_be32((priv->regs_win + RIO_ISR_AACR), RIO_ISR_AACR_AA);
 
 	/* Configure maintenance transaction window */
-	out_be32(&priv->maint_atmu_regs->rowbar, 0x000c0000);
-	out_be32(&priv->maint_atmu_regs->rowar, 0x80077015);
+	rio_init_io_res(&priv->maint_res, law_start, RIO_MAINT_WIN_SIZE,
+			"maint_win", RIO_RESOURCE_MAINT);
+	rc = rio_request_io_region(port, &priv->maint_res);
+	if (rc) {
+		dev_err(&dev->dev, "request maint window error!\n");
+		goto err;
+	}
+	out_be32(&priv->maint_atmu_regs->rowbar, (law_start >> 12) & 0xffffff);
+	out_be32(&priv->maint_atmu_regs->rowar, 0x80077000
+					| (__ilog2(RIO_MAINT_WIN_SIZE) - 1));
 
 	priv->maint_win = (u32) ioremap(law_start, RIO_MAINT_WIN_SIZE);
 
 	/* Configure outbound doorbell window */
-	out_be32(&priv->dbell_atmu_regs->rowbar, 0x000c0400);
-	out_be32(&priv->dbell_atmu_regs->rowar, 0x8004200b);
-	fsl_rio_doorbell_init(port);
+	rio_init_io_res(&priv->dbell_res, law_start + RIO_MAINT_WIN_SIZE,
+			RIO_DBELL_WIN_SIZE, "dbell_win", RIO_RESOURCE_DOORBELL);
+	out_be32(&priv->dbell_atmu_regs->rowbar, (priv->dbell_res.start >> 12)
+							& 0xffffff);
+	out_be32(&priv->dbell_atmu_regs->rowar, 0x80042000
+					| (__ilog2(RIO_DBELL_WIN_SIZE) - 1));
+	rc = fsl_rio_doorbell_init(port);
+	if (rc)
+		goto err;
 
 	return 0;
 err:
diff --git a/include/linux/rio.h b/include/linux/rio.h
index d8ff4b8..c4acb52 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -257,6 +257,7 @@ struct rio_ops {
 #define RIO_RESOURCE_MEM	0x00000100
 #define RIO_RESOURCE_DOORBELL	0x00000200
 #define RIO_RESOURCE_MAILBOX	0x00000400
+#define RIO_RESOURCE_MAINT	0x00000800
 
 #define RIO_RESOURCE_CACHEABLE	0x00010000
 #define RIO_RESOURCE_PCI	0x00020000
-- 
1.5.4

