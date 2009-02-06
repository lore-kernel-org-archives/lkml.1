Return-Path: <linux-kernel-owner+w=401wt.eu-S1761015AbZBFSJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015AbZBFSJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZBFSHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:07:01 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3240 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760225AbZBFSHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:07:00 -0500
Date: Fri, 6 Feb 2009 21:06:59 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 09/11] sdhci: Add set_clock callback
Message-ID: <20090206180659.GI11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
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
 drivers/mmc/host/sdhci.c |    5 +++++
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 0293368..3c1f1d5 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -969,6 +969,11 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 	if (clock == host->clock)
 		return;
 
+	if (host->ops->set_clock) {
+		host->ops->set_clock(host, clock);
+		return;
+	}
+
 	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
 
 	if (clock == 0)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 2e8dfd1..497276b 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -312,6 +312,8 @@ struct sdhci_ops {
 	void	(*writew)(struct sdhci_host *host, u16 val, sdhci_reg_t reg);
 	void	(*writeb)(struct sdhci_host *host, u8 val, sdhci_reg_t reg);
 
+	void	(*set_clock)(struct sdhci_host *host, unsigned int clock);
+
 	int	(*enable_dma)(struct sdhci_host *host);
 };
 
-- 
1.5.6.5

