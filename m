Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYCOO6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYCOO6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 10:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYCOO6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 10:58:44 -0400
Received: from pecan.exetel.com.au ([220.233.0.17]:51420 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751871AbYCOO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 10:58:43 -0400
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 3/3] memstick: optimize setup of JMicron host parameters
Date: Sun, 16 Mar 2008 01:58:38 +1100
Message-Id: <1205593118-30418-3-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1205593118-30418-2-git-send-email-oakad@exemail.com.au>
References: <1205593118-30418-1-git-send-email-oakad@exemail.com.au>
 <1205593118-30418-2-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Set correct clock management values to improve over-all performance.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/host/jmb38x_ms.c |   60 ++++++++++++++++++------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index e5a52f2..ed90a43 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -130,6 +130,12 @@ struct jmb38x_ms {
 #define PAD_PU_PD_ON_MS_SOCK0 0x5f8f0000
 #define PAD_PU_PD_ON_MS_SOCK1 0x0f0f0000
 
+#define CLOCK_CONTROL_40MHZ   0x00000001
+#define CLOCK_CONTROL_50MHZ   0x00000002
+#define CLOCK_CONTROL_60MHZ   0x00000008
+#define CLOCK_CONTROL_62_5MHZ 0x0000000c
+#define CLOCK_CONTROL_OFF     0x00000000
+
 enum {
 	CMD_READY    = 0x01,
 	FIFO_READY   = 0x02,
@@ -604,19 +610,18 @@ static void jmb38x_ms_reset(struct jmb38x_ms_host *host)
 {
 	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
 
-	writel(host_ctl | HOST_CONTROL_RESET_REQ | HOST_CONTROL_RESET,
-	       host->addr + HOST_CONTROL);
+	writel(HOST_CONTROL_RESET_REQ, host->addr + HOST_CONTROL);
 
 	while (HOST_CONTROL_RESET_REQ
 	       & (host_ctl = readl(host->addr + HOST_CONTROL))) {
-		ndelay(100);
-		dev_dbg(&host->chip->pdev->dev, "reset\n");
+		ndelay(20);
+		dev_dbg(&host->chip->pdev->dev, "reset %08x\n", host_ctl);
 	}
 
-	writel(INT_STATUS_ALL, host->addr + INT_STATUS_ENABLE);
+	writel(HOST_CONTROL_RESET, host->addr + HOST_CONTROL);
+	mmiowb();
 	writel(INT_STATUS_ALL, host->addr + INT_SIGNAL_ENABLE);
-
-	dev_dbg(&host->chip->pdev->dev, "reset\n");
+	writel(INT_STATUS_ALL, host->addr + INT_STATUS_ENABLE);
 }
 
 static void jmb38x_ms_set_param(struct memstick_host *msh,
@@ -624,10 +629,8 @@ static void jmb38x_ms_set_param(struct memstick_host *msh,
 				int value)
 {
 	struct jmb38x_ms_host *host = memstick_priv(msh);
-	unsigned int host_ctl;
-	unsigned long flags;
-
-	spin_lock_irqsave(&host->lock, flags);
+	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
+	unsigned int clock_ctl = CLOCK_CONTROL_40MHZ, clock_delay = 0;
 
 	switch (param) {
 	case MEMSTICK_POWER:
@@ -635,60 +638,57 @@ static void jmb38x_ms_set_param(struct memstick_host *msh,
 			jmb38x_ms_reset(host);
 
 			writel(host->id ? PAD_PU_PD_ON_MS_SOCK1
-					  : PAD_PU_PD_ON_MS_SOCK0,
+					: PAD_PU_PD_ON_MS_SOCK0,
 			       host->addr + PAD_PU_PD);
 
 			writel(PAD_OUTPUT_ENABLE_MS,
 			       host->addr + PAD_OUTPUT_ENABLE);
 
-			host_ctl = readl(host->addr + HOST_CONTROL);
-			host_ctl |= 7;
-			writel(host_ctl | (HOST_CONTROL_POWER_EN
-					   | HOST_CONTROL_CLOCK_EN),
-			       host->addr + HOST_CONTROL);
+			host_ctl = 7;
+			host_ctl |= HOST_CONTROL_POWER_EN
+				 | HOST_CONTROL_CLOCK_EN;
+			writel(host_ctl, host->addr + HOST_CONTROL);
 
 			dev_dbg(&host->chip->pdev->dev, "power on\n");
 		} else if (value == MEMSTICK_POWER_OFF) {
-			writel(readl(host->addr + HOST_CONTROL)
-			       & ~(HOST_CONTROL_POWER_EN
-				   | HOST_CONTROL_CLOCK_EN),
-			       host->addr +  HOST_CONTROL);
+			host_ctl &= ~(HOST_CONTROL_POWER_EN
+				      | HOST_CONTROL_CLOCK_EN);
+			writel(host_ctl, host->addr +  HOST_CONTROL);
 			writel(0, host->addr + PAD_OUTPUT_ENABLE);
 			writel(PAD_PU_PD_OFF, host->addr + PAD_PU_PD);
 			dev_dbg(&host->chip->pdev->dev, "power off\n");
 		}
 		break;
 	case MEMSTICK_INTERFACE:
-		/* jmb38x_ms_reset(host); */
-
-		host_ctl = readl(host->addr + HOST_CONTROL);
 		host_ctl &= ~(3 << HOST_CONTROL_IF_SHIFT);
-		/* host_ctl |= 7; */
 
 		if (value == MEMSTICK_SERIAL) {
 			host_ctl &= ~HOST_CONTROL_FAST_CLK;
 			host_ctl |= HOST_CONTROL_IF_SERIAL
 				    << HOST_CONTROL_IF_SHIFT;
 			host_ctl |= HOST_CONTROL_REI;
-			writel(0, host->addr + CLOCK_DELAY);
+			clock_ctl = CLOCK_CONTROL_40MHZ;
+			clock_delay = 0;
 		} else if (value == MEMSTICK_PAR4) {
 			host_ctl |= HOST_CONTROL_FAST_CLK;
 			host_ctl |= HOST_CONTROL_IF_PAR4
 				    << HOST_CONTROL_IF_SHIFT;
 			host_ctl &= ~HOST_CONTROL_REI;
-			writel(4, host->addr + CLOCK_DELAY);
+			clock_ctl = CLOCK_CONTROL_40MHZ;
+			clock_delay = 4;
 		} else if (value == MEMSTICK_PAR8) {
 			host_ctl |= HOST_CONTROL_FAST_CLK;
 			host_ctl |= HOST_CONTROL_IF_PAR8
 				    << HOST_CONTROL_IF_SHIFT;
 			host_ctl &= ~HOST_CONTROL_REI;
-			writel(4, host->addr + CLOCK_DELAY);
+			clock_ctl = CLOCK_CONTROL_60MHZ;
+			clock_delay = 0;
 		}
 		writel(host_ctl, host->addr + HOST_CONTROL);
+		writel(clock_ctl, host->addr + CLOCK_CONTROL);
+		writel(clock_delay, host->addr + CLOCK_DELAY);
 		break;
 	};
-
-	spin_unlock_irqrestore(&host->lock, flags);
 }
 
 #ifdef CONFIG_PM
-- 
1.5.3.6

