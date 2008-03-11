Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbYCKJNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbYCKJNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYCKJKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:10:25 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:61156 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbYCKJKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:10:21 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, akpm@linux-foundation.org,
       galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 10/17] Add RapidIO connection info print out and re-training for break connection.
Date: Tue, 11 Mar 2008 17:07:51 +0800
Message-Id: <1205226478-7641-10-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1205226478-7641-9-git-send-email-wei.zhang@freescale.com>
References: <1205226478-7641-1-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-2-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-3-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-4-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-5-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-6-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-7-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-8-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-9-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 11 Mar 2008 09:10:01.0758 (UTC) FILETIME=[AFF5E3E0:01C88357]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c |   71 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 935822a..dca8eea 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -942,6 +942,48 @@ static int fsl_rio_get_cmdline(char *s)
 
 __setup("riohdid=", fsl_rio_get_cmdline);
 
+static inline void fsl_rio_info(struct device *dev, u32 ccsr)
+{
+	const char *str;
+	if (ccsr & 1) {
+		/* Serial phy */
+		switch (ccsr >> 30) {
+		case 0:
+			str = "1";
+			break;
+		case 1:
+			str = "4";
+			break;
+		default:
+			str = "Unknown";
+			break;;
+		}
+		dev_info(dev, "Hardware port width: %s\n", str);
+
+		switch ((ccsr >> 27) & 7) {
+		case 0:
+			str = "Single-lane 0";
+			break;
+		case 1:
+			str = "Single-lane 2";
+			break;
+		case 2:
+			str = "Four-lane";
+			break;
+		default:
+			str = "Unknown";
+			break;
+		}
+		dev_info(dev, "Training connection status: %s\n", str);
+	} else {
+		/* Parallel phy */
+		if (!(ccsr & 0x80000000))
+			dev_info(dev, "Output port operating in 8-bit mode\n");
+		if (!(ccsr & 0x08000000))
+			dev_info(dev, "Input port operating in 8-bit mode\n");
+	}
+}
+
 /**
  * fsl_rio_setup - Setup MPC85xx RapidIO interface
  * @fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
@@ -1055,6 +1097,35 @@ int fsl_rio_setup(struct of_device *dev)
 			(port->phy_type == RIO_PHY_PARALLEL) ? "parallel" :
 			((port->phy_type == RIO_PHY_SERIAL) ? "serial" :
 			 "unknown"));
+	/* Checking the port training status */
+	if (in_be32((priv->regs_win + RIO_ESCSR)) & 1) {
+		dev_err(&dev->dev, "Port is not ready. "
+				   "Try to restart connection...\n");
+		switch (port->phy_type) {
+		case RIO_PHY_SERIAL:
+			/* Disable ports */
+			out_be32(priv->regs_win + RIO_CCSR, 0);
+			/* Set 1x lane */
+			setbits32(priv->regs_win + RIO_CCSR, 0x02000000);
+			/* Enable ports */
+			setbits32(priv->regs_win + RIO_CCSR, 0x00600000);
+			break;
+		case RIO_PHY_PARALLEL:
+			/* Disable ports */
+			out_be32(priv->regs_win + RIO_CCSR, 0x22000000);
+			/* Enable ports */
+			out_be32(priv->regs_win + RIO_CCSR, 0x44000000);
+			break;
+		}
+		msleep(100);
+		if (in_be32((priv->regs_win + RIO_ESCSR)) & 1) {
+			dev_err(&dev->dev, "Port restart failed.\n");
+			rc = -ENOLINK;
+			goto err;
+		}
+		dev_info(&dev->dev, "Port restart success!\n");
+	}
+	fsl_rio_info(&dev->dev, ccsr);
 
 	port->sys_size = (in_be32((priv->regs_win + RIO_PEF_CAR))
 					& RIO_PEF_CTLS) >> 4;
-- 
1.5.4

