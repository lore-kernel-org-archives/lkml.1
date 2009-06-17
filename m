Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbZFQA4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbZFQA4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762283AbZFQAze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:55:34 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:38915 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760299AbZFQAzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:55:33 -0400
From: Rob Emanuele <rob@emanuele.us>
To: nicolas.ferre@atmel.com
Cc: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, Rob Emanuele <rob@emanuele.us>
Subject: [PATCH 4/6] atmel-mci: CLKDIV cap to restrict the MCI controller speed
Date: Tue, 16 Jun 2009 17:54:37 -0700
Message-Id: <1245200079-6323-4-git-send-email-rob@emanuele.us>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1245200079-6323-1-git-send-email-rob@emanuele.us>
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the compile time configuration option for the atmel-mci driver to cap the MCI CLKDIV register value to a minimum value.

This is useful for debugging and for boards that have a long mci clock line.

Signed-off-by: Rob Emanuele <rob@emanuele.us>
---
 drivers/mmc/host/Kconfig     |   14 ++++++++++++++
 drivers/mmc/host/atmel-mci.c |   10 ++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 5875125..b628037 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -161,6 +161,20 @@ config MMC_ATMELMCI
 
 endchoice
 
+config MMC_ATMELMCI_CLKDIV_CAP
+	int "Cap the CLKDIV to keep the controller from going too fast."
+	depends on MMC_ATMELMCI
+	default 0
+	range 0 255
+	help
+	  This is the lowest value the clock divisor for the MMC
+	  controller can be.  Value is between 0 and 255.
+	  MCI_CK = MCK/(2*(CLKDIV+1))
+	  Raising this value may improve your controller's reliability
+	  at the cost of speed.
+
+	  If unsure, leave at 0.
+
 config MMC_ATMELMCI_ALWAYS_RESET
 	bool "Reset before every request.  Sometimes needed for buggy chips."
 	depends on MMC_ATMELMCI
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index e5894f6..601dae7 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -72,6 +72,10 @@ struct atmel_mci_dma {
 #define MMC_ALWAYS_RESET 0
 #endif
 
+#ifndef CONFIG_MMC_ATMELMCI_CLKDIV_CAP
+#define CONFIG_MMC_ATMELMCI_CLKDIV_CAP 0
+#endif
+
 /**
  * struct atmel_mci - MMC controller state shared between all slots
  * @lock: Spinlock protecting the queue and associated data.
@@ -882,6 +886,12 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 				clock_min, host->bus_hz / (2 * 256));
 			clkdiv = 255;
 		}
+		if (clkdiv < CONFIG_MMC_ATMELMCI_CLKDIV_CAP) {
+			dev_warn(&mmc->class_dev,
+				"clkdiv %u too fast; capped using %u\n",
+				 clkdiv, CONFIG_MMC_ATMELMCI_CLKDIV_CAP);
+			clkdiv = CONFIG_MMC_ATMELMCI_CLKDIV_CAP;
+		}
 
 		host->mode_reg = MCI_MR_CLKDIV(clkdiv);
 
-- 
1.6.0.4

