Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbYFQORw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbYFQORw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759344AbYFQORm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:17:42 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:18039 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759315AbYFQORl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:17:41 -0400
Date: Tue, 17 Jun 2008 18:17:39 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mmc: change .get_ro() callback semantics
Message-ID: <20080617141739.GC8376@polina.dev.rtsoft.ru>
References: <20080617141607.GA2712@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080617141607.GA2712@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now get_ro() callback must return 0/1 values for its logical states, and
negative errno values in case of error. If particular host instance doesn't
support RO/WP switch, it should return -ENOSYS.

This patch changes some hosts in two ways:

1. Now functions should be smart to not return negative values in
   "RO asserted" case (particularly gpio_ calls could return negative
   values for the outermost GPIOs).

   Also, board code usually passes get_ro() callbacks that directly return
   gpioreg & bit result, so at91_mci, imxmmc, pxamci and mmc_spi's get_ro()
   handlers need take special care when returning platform's values to the
   mmc core.

2. In case of host instance didn't implement get_ro() callback, it should
   really return -ENOSYS and let the mmc core decide what to do about it
   (mmc core thinks the same way as the hosts, so it isn't functional
   change).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/core/sd.c       |    4 ++--
 drivers/mmc/host/at91_mci.c |   18 +++++++-----------
 drivers/mmc/host/imxmmc.c   |    9 ++++++---
 drivers/mmc/host/mmc_spi.c  |    9 ++++++---
 drivers/mmc/host/pxamci.c   |    9 ++++++---
 drivers/mmc/host/wbsd.c     |    2 +-
 include/linux/mmc/host.h    |   12 ++++++++++++
 7 files changed, 40 insertions(+), 23 deletions(-)

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
index 8979ad3..b9d4ed6 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -793,19 +793,15 @@ static irqreturn_t at91_mmc_det_irq(int irq, void *_host)
 
 static int at91_mci_get_ro(struct mmc_host *mmc)
 {
-	int read_only = 0;
 	struct at91mci_host *host = mmc_priv(mmc);
 
-	if (host->board->wp_pin) {
-		read_only = gpio_get_value(host->board->wp_pin);
-		printk(KERN_WARNING "%s: card is %s\n", mmc_hostname(mmc),
-				(read_only ? "read-only" : "read-write") );
-	}
-	else {
-		printk(KERN_WARNING "%s: host does not support reading read-only "
-				"switch.  Assuming write-enable.\n", mmc_hostname(mmc));
-	}
-	return read_only;
+	if (host->board->wp_pin)
+		return !!gpio_get_value(host->board->wp_pin);
+	/*
+	 * Board doesn't support read only detection; let the mmc core
+	 * decide what to do.
+	 */
+	return -ENOSYS;
 }
 
 static const struct mmc_host_ops at91_mci_ops = {
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
index 547eb85..4e82f64 100644
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
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index be624a0..9283b85 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -939,7 +939,7 @@ static int wbsd_get_ro(struct mmc_host *mmc)
 
 	spin_unlock_bh(&host->lock);
 
-	return csr & WBSD_WRPT;
+	return !!(csr & WBSD_WRPT);
 }
 
 static const struct mmc_host_ops wbsd_ops = {
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 6188e19..753b723 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -58,6 +58,18 @@ struct mmc_host_ops {
 	 *
 	 * Also note that these functions might sleep, so don't call them
 	 * in the atomic contexts!
+	 *
+	 * Return values for the get_ro callback should be:
+	 *   0 for a read/write card
+	 *   1 for a read-only card
+	 *   -ENOSYS when not supported (equal to NULL callback)
+	 *   or a negative errno value when something bad happened
+	 *
+	 * Return values for the get_ro callback should be:
+	 *   0 for a absent card
+	 *   1 for a present card
+	 *   -ENOSYS when not supported (equal to NULL callback)
+	 *   or a negative errno value when something bad happened
 	 */
 	void	(*set_ios)(struct mmc_host *host, struct mmc_ios *ios);
 	int	(*get_ro)(struct mmc_host *host);
-- 
1.5.5.4
