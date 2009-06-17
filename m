Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbZFQA4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbZFQA4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762196AbZFQAze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:55:34 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:60577 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761217AbZFQAzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:55:31 -0400
From: Rob Emanuele <rob@emanuele.us>
To: nicolas.ferre@atmel.com
Cc: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, Rob Emanuele <rob@emanuele.us>
Subject: [PATCH 3/6] atmel-mci: Optional controller reset before every command
Date: Tue, 16 Jun 2009 17:54:36 -0700
Message-Id: <1245200079-6323-3-git-send-email-rob@emanuele.us>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1245200079-6323-1-git-send-email-rob@emanuele.us>
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the compile time configuration option for the atmel-mci driver to reset the Atmel MCI controller before every command.

This is sometimes needed for the Atmel controller / board to function properly.

Signed-off-by: Rob Emanuele <rob@emanuele.us>
---
 drivers/mmc/host/Kconfig     |   10 ++++++++++
 drivers/mmc/host/atmel-mci.c |   11 ++++++++++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index a0eaf69..5875125 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -161,6 +161,16 @@ config MMC_ATMELMCI
 
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
index 98b25de..e5894f6 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -63,6 +63,15 @@ struct atmel_mci_dma {
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
@@ -720,7 +729,7 @@ static void atmci_start_request(struct atmel_mci *host,
 	host->completed_events = 0;
 	host->data_status = 0;
 
-	if (host->need_reset) {
+	if (host->need_reset || MMC_ALWAYS_RESET) {
 		mci_writel(host, CR, MCI_CR_SWRST);
 		mci_writel(host, CR, MCI_CR_MCIEN);
 		mci_writel(host, MR, host->mode_reg);
-- 
1.6.0.4

