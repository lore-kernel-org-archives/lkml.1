Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbZCPVPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbZCPVPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761731AbZCPVOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:14:03 -0400
Received: from [213.79.90.228] ([213.79.90.228]:2047 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761715AbZCPVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:14:01 -0400
Date: Tue, 17 Mar 2009 00:13:59 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 07/11] sdhci: Add set_clock callback and a quirk for
	nonstandard clocks
Message-ID: <20090316211359.GG9375@oksana.dev.rtsoft.ru>
References: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
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
index 34ab77b..75d0ecb 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -949,6 +949,12 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
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
index aab0652..b9bc622 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -218,6 +218,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<15)
 /* Controller reports inverted write-protect state */
 #define SDHCI_QUIRK_INVERTED_WRITE_PROTECT		(1<<16)
+/* Controller has nonstandard clock management */
+#define SDHCI_QUIRK_NONSTANDARD_CLOCK			(1<<17)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
@@ -284,6 +286,8 @@ struct sdhci_ops {
 	void		(*writeb)(struct sdhci_host *host, u8 val, int reg);
 #endif
 
+	void	(*set_clock)(struct sdhci_host *host, unsigned int clock);
+
 	int		(*enable_dma)(struct sdhci_host *host);
 	unsigned int	(*get_max_clock)(struct sdhci_host *host);
 	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
-- 
1.5.6.5

