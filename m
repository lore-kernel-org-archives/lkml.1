Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbZCEUbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbZCEUbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 15:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbZCEU2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 15:28:48 -0500
Received: from [213.79.90.228] ([213.79.90.228]:46829 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755655AbZCEU2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 15:28:46 -0500
Date: Thu, 5 Mar 2009 23:28:44 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 08/11] sdhci: Add quirk for controllers that need small
	delays for PIO
Message-ID: <20090305202844.GH28709@oksana.dev.rtsoft.ru>
References: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small udelay is needed to make eSDHC work in PIO mode. Without
the delay reading causes endless interrupt storm, and writing
corrupts data. The first guess would be that we must wait for
some bit in some register, but I didn't find any reliable bits
that change before and after the delay.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |    3 +++
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index a476616..4382f53 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -391,6 +391,9 @@ static void sdhci_transfer_pio(struct sdhci_host *host)
 		mask = ~0;
 
 	while (sdhci_readl(host, SDHCI_PRESENT_STATE) & mask) {
+		if (host->quirks & SDHCI_QUIRK_PIO_NEEDS_DELAY)
+			udelay(100);
+
 		if (host->data->flags & MMC_DATA_READ)
 			sdhci_read_block_pio(host);
 		else
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 18a334a..8c41667 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -218,6 +218,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_INVERTED_WRITE_PROTECT		(1<<16)
 /* Controller has nonstandard clock management */
 #define SDHCI_QUIRK_NONSTANDARD_CLOCK			(1<<17)
+/* Controller does not like fast PIO transfers */
+#define SDHCI_QUIRK_PIO_NEEDS_DELAY			(1<<18)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

