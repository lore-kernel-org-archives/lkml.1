Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbZBTRfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbZBTRfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759143AbZBTRdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:33:35 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3023 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759139AbZBTRde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:33:34 -0500
Date: Fri, 20 Feb 2009 20:33:29 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 11/13] sdhci: Add quirk for controllers that need IRQ
	re-init after reset
Message-ID: <20090220173329.GK7583@oksana.dev.rtsoft.ru>
References: <20090220173228.GA5091@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090220173228.GA5091@oksana.dev.rtsoft.ru>
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
index eff615d..91f021d 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -189,6 +189,7 @@ static void sdhci_disable_card_detection(struct sdhci_host *host)
 static void sdhci_reset(struct sdhci_host *host, u8 mask)
 {
 	unsigned long timeout;
+	u32 uninitialized_var(ier);
 
 	if (host->quirks & SDHCI_QUIRK_NO_CARD_NO_RESET) {
 		if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) &
@@ -196,6 +197,9 @@ static void sdhci_reset(struct sdhci_host *host, u8 mask)
 			return;
 	}
 
+	if (host->quirks & SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET)
+		ier = sdhci_readl(host, SDHCI_INT_ENABLE);
+
 	sdhci_writeb(host, mask, SDHCI_SOFTWARE_RESET);
 
 	if (mask & SDHCI_RESET_ALL)
@@ -215,6 +219,9 @@ static void sdhci_reset(struct sdhci_host *host, u8 mask)
 		timeout--;
 		mdelay(1);
 	}
+
+	if (host->quirks & SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET)
+		sdhci_clear_set_irqs(host, SDHCI_INT_ALL_MASK, ier);
 }
 
 static void sdhci_init(struct sdhci_host *host)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 44c820a..5c5a950 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -229,6 +229,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_NONSTANDARD_CLOCK			(1<<19)
 /* Controller does not like fast PIO transfers */
 #define SDHCI_QUIRK_PIO_NEEDS_DELAY			(1<<20)
+/* Controller losing signal/interrupt enable states after reset */
+#define SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET		(1<<21)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

