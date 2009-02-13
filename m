Return-Path: <linux-kernel-owner+w=401wt.eu-S1762359AbZBMOuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762359AbZBMOuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761592AbZBMOrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:47:39 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:16771 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761581AbZBMOri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:47:38 -0500
Date: Fri, 13 Feb 2009 17:47:35 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 10/13] sdhci: Add quirk for controllers that need small
	delays for PIO
Message-ID: <20090213144735.GJ23889@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
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
index f63db25..eff615d 100644
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
index 63b436a..44c820a 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -227,6 +227,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_32BIT_REGISTERS			(1<<18)
 /* Controller has nonstandard clock management */
 #define SDHCI_QUIRK_NONSTANDARD_CLOCK			(1<<19)
+/* Controller does not like fast PIO transfers */
+#define SDHCI_QUIRK_PIO_NEEDS_DELAY			(1<<20)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

