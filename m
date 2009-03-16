Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbZCPVQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbZCPVQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761797AbZCPVOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:14:06 -0400
Received: from [213.79.90.228] ([213.79.90.228]:2058 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761648AbZCPVOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:14:04 -0400
Date: Tue, 17 Mar 2009 00:14:02 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 09/11] sdhci: Add quirk for controllers that need IRQ
	re-init after reset
Message-ID: <20090316211402.GI9375@oksana.dev.rtsoft.ru>
References: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FSL eSDHC controllers losing signal/interrupt enable states after
reset, so we should re-enable them.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |    7 +++++++
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index cd6dab3..3a72fe2 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -134,6 +134,7 @@ static void sdhci_disable_card_detection(struct sdhci_host *host)
 static void sdhci_reset(struct sdhci_host *host, u8 mask)
 {
 	unsigned long timeout;
+	u32 uninitialized_var(ier);
 
 	if (host->quirks & SDHCI_QUIRK_NO_CARD_NO_RESET) {
 		if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) &
@@ -141,6 +142,9 @@ static void sdhci_reset(struct sdhci_host *host, u8 mask)
 			return;
 	}
 
+	if (host->quirks & SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET)
+		ier = sdhci_readl(host, SDHCI_INT_ENABLE);
+
 	sdhci_writeb(host, mask, SDHCI_SOFTWARE_RESET);
 
 	if (mask & SDHCI_RESET_ALL)
@@ -160,6 +164,9 @@ static void sdhci_reset(struct sdhci_host *host, u8 mask)
 		timeout--;
 		mdelay(1);
 	}
+
+	if (host->quirks & SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET)
+		sdhci_clear_set_irqs(host, SDHCI_INT_ALL_MASK, ier);
 }
 
 static void sdhci_init(struct sdhci_host *host)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index c5ce9ee..2962102 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -222,6 +222,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_NONSTANDARD_CLOCK			(1<<17)
 /* Controller does not like fast PIO transfers */
 #define SDHCI_QUIRK_PIO_NEEDS_DELAY			(1<<18)
+/* Controller losing signal/interrupt enable states after reset */
+#define SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET		(1<<19)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

