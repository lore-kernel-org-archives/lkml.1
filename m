Return-Path: <linux-kernel-owner+w=401wt.eu-S934220AbZFMBC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220AbZFMBC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 21:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762311AbZFMBCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 21:02:40 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:48424 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763094AbZFMBCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 21:02:39 -0400
MIME-Version: 1.0
Date: Fri, 12 Jun 2009 18:02:41 -0700
X-Google-Sender-Auth: a4637cc6644bd213
Message-ID: <c8284b5b0906121802y1e595c5el4a3a99fe7b2da750@mail.gmail.com>
Subject: [PATCH 3/6] Unified AVR32/AT91 MCI Driver Reset Patch
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
atmel-mci driver to reset the Atmel MCI controller before every
command.

This is sometimes needed for the Atmel controller / board to function
properly.  In the case of the at91sam9g20-ek this is needed.

Please read the whole set, try it out, and comment.

Thank you,

Rob Emanuele

---
 drivers/mmc/host/Kconfig     |   10 ++++++++++
 drivers/mmc/host/atmel-mci.c |   11 ++++++++++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 6e2f52b..9e24029 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -150,6 +150,16 @@ config MMC_ATMELMCI

 endchoice

+config MMC_ATMELMCI_ALWAYS_RESET
+	bool "Reset before every request.  Sometimes needed for buggy chips."
+	depends on MMC_ATMELMCI
+	help
+	  There are reports that some buggy controllers work better
+	  with a reset before every command.  This may improve your
+	  controller's reliability.
+
+	  If unsure, say N.
+
 config MMC_ATMELMCI_DMA
 	bool "Atmel MCI DMA support (EXPERIMENTAL)"
 	depends on MMC_ATMELMCI && AVR32 && DMA_ENGINE && EXPERIMENTAL
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 497dd51..b133baa 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -65,6 +65,15 @@ struct atmel_mci_dma {
 #endif
 };

+/*
+ * Configuration options from the kernel config
+ */
+#ifdef CONFIG_MMC_ATMELMCI_ALWAYS_RESET
+#define MMC_ALWAYS_RESET 1
+#else
+#define MMC_ALWAYS_RESET 0
+#endif
+
 /**
  * struct atmel_mci - MMC controller state shared between all slots
  * @lock: Spinlock protecting the queue and associated data.
@@ -714,7 +723,7 @@ static void atmci_start_request(struct atmel_mci *host,
 	host->completed_events = 0;
 	host->data_status = 0;

-	if (host->need_reset) {
+	if (host->need_reset || MMC_ALWAYS_RESET) {
 		mci_writel(host, CR, MCI_CR_SWRST);
 		mci_writel(host, CR, MCI_CR_MCIEN);
 		mci_writel(host, MR, host->mode_reg);
-- 
1.6.0.4
