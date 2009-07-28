Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbZG1HvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbZG1HvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZG1HvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:51:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:55524 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751137AbZG1HvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:51:05 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/FMGgcMsDF+O+B4j+2DNuI/3b2iTf+uEknZibAL/
	ooP7GPjveMZU1I
Date: Tue, 28 Jul 2009 09:51:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ian Molton <ian@mnementh.co.uk>
cc: linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       akpm@linux-foundation.org, Matt Fleming <matt@console-pimps.org>,
       Philip Langdale <philipl@overt.org>
Subject: [PATCH] tmio_mmc: Optionally support using platform clock
Message-ID: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the platform device has a clock associated with the tmio-mmc device, 
use it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <damm@opensource.se>
---

Depends (at least logically) on 
http://marc.info/?l=linux-kernel&m=124782904228865&w=2

Sorry if I forgot anyone who volunteered to help out with MMC patches.

 drivers/mmc/host/tmio_mmc.c |   21 +++++++++++++++++++++
 drivers/mmc/host/tmio_mmc.h |    3 +++
 include/linux/mfd/tmio.h    |    1 +
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index c246191..2a01572 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -32,6 +32,7 @@
 #include <linux/mmc/host.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tmio.h>
+#include <linux/clk.h>
 
 #include "tmio_mmc.h"
 
@@ -57,10 +58,18 @@ static void tmio_mmc_clk_stop(struct tmio_mmc_host *host)
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, ~0x0100 &
 		sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL));
 	msleep(10);
+	if (!IS_ERR(host->clk) && host->clk_is_running) {
+		clk_disable(host->clk);
+		host->clk_is_running = false;
+	}
 }
 
 static void tmio_mmc_clk_start(struct tmio_mmc_host *host)
 {
+	if (!IS_ERR(host->clk) && !host->clk_is_running &&
+	    !clk_enable(host->clk))
+		host->clk_is_running = true;
+
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, 0x0100 |
 		sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL));
 	msleep(10);
@@ -567,6 +576,11 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 			goto unmap_cnf;
 	}
 
+	host->clk = clk_get(&dev->dev, pdata->clk_name);
+
+	if (!IS_ERR(host->clk) && !clk_enable(host->clk))
+		host->clk_is_running = true;
+
 	/* Enable the MMC/SD Control registers */
 	sd_config_write16(host, CNF_CMD, SDCREN);
 	sd_config_write32(host, CNF_CTL_BASE,
@@ -608,6 +622,11 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	return 0;
 
 unmap_cnf:
+	if (!IS_ERR(host->clk)) {
+		clk_disable(host->clk);
+		host->clk_is_running = false;
+		clk_put(host->clk);
+	}
 	if (host->cnf)
 		iounmap(host->cnf);
 unmap_ctl:
@@ -632,6 +651,8 @@ static int __devexit tmio_mmc_remove(struct platform_device *dev)
 		if (host->cnf)
 			iounmap(host->cnf);
 		mmc_free_host(mmc);
+		if (!IS_ERR(host->clk))
+			clk_put(host->clk);
 	}
 
 	return 0;
diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 45f06aa..a76d237 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -108,6 +108,7 @@
 		sd_ctrl_write32((host), CTL_STATUS, mask); \
 	} while (0)
 
+struct clk;
 
 struct tmio_mmc_host {
 	void __iomem *cnf;
@@ -117,6 +118,8 @@ struct tmio_mmc_host {
 	struct mmc_request      *mrq;
 	struct mmc_data         *data;
 	struct mmc_host         *mmc;
+	struct clk		*clk;
+	bool			clk_is_running;
 	int                     irq;
 
 	/* pio related stuff */
diff --git a/include/linux/mfd/tmio.h b/include/linux/mfd/tmio.h
index 6b9c5d0..e405895 100644
--- a/include/linux/mfd/tmio.h
+++ b/include/linux/mfd/tmio.h
@@ -23,6 +23,7 @@
  */
 struct tmio_mmc_data {
 	const unsigned int		hclk;
+	const char			*clk_name;
 };
 
 /*
-- 
1.6.2.4

