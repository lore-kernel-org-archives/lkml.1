Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZCEUaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZCEUaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 15:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZCEU2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 15:28:46 -0500
Received: from [213.79.90.228] ([213.79.90.228]:46828 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755312AbZCEU2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 15:28:45 -0500
Date: Thu, 5 Mar 2009 23:28:42 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 07/11] sdhci: Add set_clock callback and a quirk for
	nonstandard clocks
Message-ID: <20090305202842.GG28709@oksana.dev.rtsoft.ru>
References: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FSL eSDHC hosts have incompatible register map to manage the SDCLK.
This patch adds set_clock callback so that drivers could overwrite
set_clock behaviour.

Similar patch[1] was posted by Ben Dooks, though in Ben's version the
callback is named change_clock, plus the patch has some unrelated bits
that makes the patch difficult to reuse.

[1] http://lkml.org/lkml/2008/12/2/160

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |    6 ++++++
 drivers/mmc/host/sdhci.h |    4 ++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index cca80d3..a476616 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1004,6 +1004,12 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 	if (clock == host->clock)
 		return;
 
+	if (host->ops->set_clock) {
+		host->ops->set_clock(host, clock);
+		if (host->quirks & SDHCI_QUIRK_NONSTANDARD_CLOCK)
+			return;
+	}
+
 	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
 
 	if (clock == 0)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 34f1849..18a334a 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -216,6 +216,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<15)
 /* Controller reports inverted write-protect state */
 #define SDHCI_QUIRK_INVERTED_WRITE_PROTECT		(1<<16)
+/* Controller has nonstandard clock management */
+#define SDHCI_QUIRK_NONSTANDARD_CLOCK			(1<<17)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
@@ -280,6 +282,8 @@ struct sdhci_ops {
 	void		(*writew)(struct sdhci_host *host, u16 val, int reg);
 	void		(*writeb)(struct sdhci_host *host, u8 val, int reg);
 
+	void	(*set_clock)(struct sdhci_host *host, unsigned int clock);
+
 	int		(*enable_dma)(struct sdhci_host *host);
 	unsigned int	(*get_max_clock)(struct sdhci_host *host);
 	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
-- 
1.5.6.5

