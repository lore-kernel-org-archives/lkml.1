Return-Path: <linux-kernel-owner+w=401wt.eu-S934532AbZFMBDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532AbZFMBDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 21:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934218AbZFMBCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 21:02:48 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:48424 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780AbZFMBCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 21:02:46 -0400
MIME-Version: 1.0
Date: Fri, 12 Jun 2009 18:02:48 -0700
X-Google-Sender-Auth: 5aa13f0adf180441
Message-ID: <c8284b5b0906121802p28440aa8x67e779d8f90ebaad@mail.gmail.com>
Subject: [PATCH 4/6] Unified AVR32/AT91 MCI Driver
From: Rob Emanuele <poorarm@shoreis.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the compile time configuration option for the
atmel-mci driver to cap the MCI CLKDIV register value to a minimum
value.

This is useful for debugging and for boards that have a long mci clock line.

Please read the whole set, try it out, and comment.

Thank you,

Rob Emanuele

---
 drivers/mmc/host/Kconfig     |   14 ++++++++++++++
 drivers/mmc/host/atmel-mci.c |   10 ++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 9e24029..9f797b2 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -150,6 +150,20 @@ config MMC_ATMELMCI

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
index b133baa..1c1a4b3 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -74,6 +74,10 @@ struct atmel_mci_dma {
 #define MMC_ALWAYS_RESET 0
 #endif

+#ifndef CONFIG_MMC_ATMELMCI_CLKDIV_CAP
+#define CONFIG_MMC_ATMELMCI_CLKDIV_CAP 0
+#endif
+
 /**
  * struct atmel_mci - MMC controller state shared between all slots
  * @lock: Spinlock protecting the queue and associated data.
@@ -876,6 +880,12 @@ static void atmci_set_ios(struct mmc_host *mmc,
struct mmc_ios *ios)
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
