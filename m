Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbYEWPoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbYEWPoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757659AbYEWPnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:43:49 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2533 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756804AbYEWPns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:43:48 -0400
Date: Fri, 23 May 2008 19:43:47 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 3/3] mmc: change .get_ro() callback semantics
Message-ID: <20080523154347.GC24862@polina.dev.rtsoft.ru>
References: <20080523154204.GA19803@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080523154204.GA19803@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_ro() callback must return values >= 0 for its logical state, and
negative errno values in case of error.

If particular host instance doesn't support RO/WP switch, it should
return -ENOSYS.

This patch changes some hosts in two ways:

1. Now functions should be smart to not return negative values in
   "RO asserted" case (particularly gpio_ calls could return negative
   values for the outermost GPIOs).

   Also, board code usually passes get_ro() callbacks that directly return
   gpioreg & bit result, so imxmmc, pxamci and mmc_spi's get_ro() handlers
   need take special care when returning platform's values to the mmc core.

2. In case of host instance didn't implement get_ro() callback, it should
   really return -ENOSYS and let the mmc core decide what to do about it
   (mmc core thinks the same way as the hosts, so it isn't functional
   change).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/core/sd.c       |    4 ++--
 drivers/mmc/host/at91_mci.c |    2 +-
 drivers/mmc/host/imxmmc.c   |    9 ++++++---
 drivers/mmc/host/mmc_spi.c  |    9 ++++++---
 drivers/mmc/host/pxamci.c   |    9 ++++++---
 include/linux/mmc/host.h    |    3 +++
 6 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 7ef3b15..b122eb9 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -494,13 +494,13 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	 * Check if read-only switch is active.
 	 */
 	if (!oldcard) {
-		if (!host->ops->get_ro) {
+		if (!host->ops->get_ro || host->ops->get_ro(host) < 0) {
 			printk(KERN_WARNING "%s: host does not "
 				"support reading read-only "
 				"switch. assuming write-enable.\n",
 				mmc_hostname(host));
 		} else {
-			if (host->ops->get_ro(host))
+			if (host->ops->get_ro(host) > 0)
 				mmc_card_set_readonly(card);
 		}
 	}
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 8979ad3..140c2b8 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -797,7 +797,7 @@ static int at91_mci_get_ro(struct mmc_host *mmc)
 	struct at91mci_host *host = mmc_priv(mmc);
 
 	if (host->board->wp_pin) {
-		read_only = gpio_get_value(host->board->wp_pin);
+		read_only = !!gpio_get_value(host->board->wp_pin);
 		printk(KERN_WARNING "%s: card is %s\n", mmc_hostname(mmc),
 				(read_only ? "read-only" : "read-write") );
 	}
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index 95f33e8..5167679 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -889,9 +889,12 @@ static int imxmci_get_ro(struct mmc_host *mmc)
 	struct imxmci_host *host = mmc_priv(mmc);
 
 	if (host->pdata && host->pdata->get_ro)
-		return host->pdata->get_ro(mmc_dev(mmc));
-	/* Host doesn't support read only detection so assume writeable */
-	return 0;
+		return !!host->pdata->get_ro(mmc_dev(mmc));
+	/*
+	 * Board doesn't support read only detection; let the mmc core
+	 * decide what to do.
+	 */
+	return -ENOSYS;
 }
 
 
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 724870c..85d9853 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1126,9 +1126,12 @@ static int mmc_spi_get_ro(struct mmc_host *mmc)
 	struct mmc_spi_host *host = mmc_priv(mmc);
 
 	if (host->pdata && host->pdata->get_ro)
-		return host->pdata->get_ro(mmc->parent);
-	/* board doesn't support read only detection; assume writeable */
-	return 0;
+		return !!host->pdata->get_ro(mmc->parent);
+	/*
+	 * Board doesn't support read only detection; let the mmc core
+	 * decide what to do.
+	 */
+	return -ENOSYS;
 }
 
 static int mmc_spi_get_cd(struct mmc_host *mmc)
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 65210fc..b6056bd 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -361,9 +361,12 @@ static int pxamci_get_ro(struct mmc_host *mmc)
 	struct pxamci_host *host = mmc_priv(mmc);
 
 	if (host->pdata && host->pdata->get_ro)
-		return host->pdata->get_ro(mmc_dev(mmc));
-	/* Host doesn't support read only detection so assume writeable */
-	return 0;
+		return !!host->pdata->get_ro(mmc_dev(mmc));
+	/*
+	 * Board doesn't support read only detection; let the mmc core
+	 * decide what to do.
+	 */
+	return -ENOSYS;
 }
 
 static void pxamci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index f2e9885..ef3b773 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -55,6 +55,9 @@ struct mmc_host_ops {
 	 * Avoid calling these three functions too often or in a "fast path",
 	 * since underlaying controller might implement them in an expensive
 	 * and/or slow way.
+	 *
+	 * .get_ro and .get_cd should return >= 0 for their logical values,
+	 * or negative errno value in case of error.
 	 */
 	void	(*set_ios)(struct mmc_host *host, struct mmc_ios *ios);
 	int	(*get_ro)(struct mmc_host *host);
-- 
1.5.5.1
