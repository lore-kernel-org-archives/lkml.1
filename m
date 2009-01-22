Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZAVB72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZAVB72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 20:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZAVB7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 20:59:19 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:44838 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754904AbZAVB7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 20:59:18 -0500
Date: Thu, 22 Jan 2009 04:59:17 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, Xie Xiaobo <X.Xie@freescale.com>,
       Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>,
       sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 01/10] sdhci: Add quirk for controllers with no end-of-busy
	IRQ
Message-ID: <20090122015917.GA11492@oksana.dev.rtsoft.ru>
References: <20090122015649.GA6835@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090122015649.GA6835@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben-linux@fluff.org>

The Samsung SDHCI (and FSL eSDHC) controller block seems to fail
to generate an INT_DATA_END after the transfer has completed and
the bus busy state finished.

Changes in e809517f6fa5803a5a1cd56026f0e2190fc13d5c to use the
new busy method are the cause of the behaviour change.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |    5 ++++-
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 4d010a9..72cb7ef 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1286,8 +1286,11 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 		if (host->cmd->data)
 			DBG("Cannot wait for busy signal when also "
 				"doing a data transfer");
-		else
+		else if (!(host->quirks & SDHCI_QUIRK_NO_BUSY_IRQ))
 			return;
+
+		/* The controller does not support the end-of-busy IRQ,
+		 * fall through and take the SDHCI_INT_RESPONSE */
 	}
 
 	if (intmask & SDHCI_INT_RESPONSE)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 31f4b15..73c03c6 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -210,6 +210,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_SMALL_PIO			(1<<13)
 /* Controller supports high speed but doesn't have the caps bit set */
 #define SDHCI_QUIRK_FORCE_HIGHSPEED			(1<<14)
+/* Controller does not provide transfer-complete interrupt when not busy */
+#define SDHCI_QUIRK_NO_BUSY_IRQ				(1<<15)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

