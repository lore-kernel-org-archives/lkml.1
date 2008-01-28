Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbYA1TKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbYA1TKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762013AbYA1TJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:09:42 -0500
Received: from smtp.nokia.com ([192.100.105.134]:52137 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762003AbYA1TJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:09:40 -0500
Message-ID: <479E27E6.7050707@indt.org.br>
Date: Mon, 28 Jan 2008 15:07:18 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] MMC: OMAP: Remove cover switch handling to allow adding
 multislot support
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:09:04.0399 (UTC) FILETIME=[3FAE69F0:01C861E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

This patch removes the MMC cover switch handling temporarily
to make following multislot patches cleaner.

MMC cover switch handling will be added back in later patches
after adding basic multislot support.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
---
 drivers/mmc/host/omap.c |  152 +----------------------------------------------
 1 files changed, 1 insertions(+), 151 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 3844eb8..721955a 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -96,8 +96,6 @@
  * when the cover switch is open */
 #define OMAP_MMC_SWITCH_POLL_DELAY	500
 
-static int mmc_omap_enable_poll = 1;
-
 struct mmc_omap_host {
 	int			initialized;
 	int			suspended;
@@ -134,62 +132,11 @@ struct mmc_omap_host {
 	short			power_pin;
 	short			wp_pin;
 
-	int			switch_pin;
 	struct work_struct	switch_work;
 	struct timer_list	switch_timer;
 	int			switch_last_state;
 };
 
-static inline int
-mmc_omap_cover_is_open(struct mmc_omap_host *host)
-{
-	if (host->switch_pin < 0)
-		return 0;
-	return omap_get_gpio_datain(host->switch_pin);
-}
-
-static ssize_t
-mmc_omap_show_cover_switch(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	struct mmc_omap_host *host = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%s\n", mmc_omap_cover_is_open(host) ? "open" :
-			"closed");
-}
-
-static DEVICE_ATTR(cover_switch, S_IRUGO, mmc_omap_show_cover_switch, NULL);
-
-static ssize_t
-mmc_omap_show_enable_poll(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n", mmc_omap_enable_poll);
-}
-
-static ssize_t
-mmc_omap_store_enable_poll(struct device *dev,
-	struct device_attribute *attr, const char *buf,
-	size_t size)
-{
-	int enable_poll;
-
-	if (sscanf(buf, "%10d", &enable_poll) != 1)
-		return -EINVAL;
-
-	if (enable_poll != mmc_omap_enable_poll) {
-		struct mmc_omap_host *host = dev_get_drvdata(dev);
-
-		mmc_omap_enable_poll = enable_poll;
-		if (enable_poll && host->switch_pin >= 0)
-			schedule_work(&host->switch_work);
-	}
-	return size;
-}
-
-static DEVICE_ATTR(enable_poll, 0664,
-		   mmc_omap_show_enable_poll, mmc_omap_store_enable_poll);
-
 static void
 mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd)
 {
@@ -500,8 +447,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 						host->cmd->opcode !=
 						MMC_SEND_OP_COND &&
 						host->cmd->opcode !=
-						MMC_APP_CMD &&
-						!mmc_omap_cover_is_open(host))
+						MMC_APP_CMD)
 					dev_err(mmc_dev(host->mmc),
 						"command timeout, CMD %d\n",
 						host->cmd->opcode);
@@ -550,54 +496,6 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t mmc_omap_switch_irq(int irq, void *dev_id)
-{
-	struct mmc_omap_host *host = (struct mmc_omap_host *) dev_id;
-
-	schedule_work(&host->switch_work);
-
-	return IRQ_HANDLED;
-}
-
-static void mmc_omap_switch_timer(unsigned long arg)
-{
-	struct mmc_omap_host *host = (struct mmc_omap_host *) arg;
-
-	schedule_work(&host->switch_work);
-}
-
-static void mmc_omap_switch_handler(struct work_struct *work)
-{
-	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host, switch_work);
-	struct mmc_card *card;
-	static int complained = 0;
-	int cards = 0, cover_open;
-
-	if (host->switch_pin == -1)
-		return;
-	cover_open = mmc_omap_cover_is_open(host);
-	if (cover_open != host->switch_last_state) {
-		kobject_uevent(&host->dev->kobj, KOBJ_CHANGE);
-		host->switch_last_state = cover_open;
-	}
-	mmc_detect_change(host->mmc, 0);
-	list_for_each_entry(card, &host->mmc->cards, node) {
-		if (mmc_card_present(card))
-			cards++;
-	}
-	if (mmc_omap_cover_is_open(host)) {
-		if (!complained) {
-			dev_info(mmc_dev(host->mmc), "cover is open\n");
-			complained = 1;
-		}
-		if (mmc_omap_enable_poll)
-			mod_timer(&host->switch_timer, jiffies +
-				msecs_to_jiffies(OMAP_MMC_SWITCH_POLL_DELAY));
-	} else {
-		complained = 0;
-	}
-}
-
 /* Prepare to transfer the next segment of a scatterlist */
 static void
 mmc_omap_prepare_dma(struct mmc_omap_host *host, struct mmc_data *data)
@@ -1063,7 +961,6 @@ static int __init mmc_omap_probe(struct platform_device *pdev)
 	 * the card detect sensing.
 	 */
 	host->power_pin = minfo->power_pin;
-	host->switch_pin = minfo->switch_pin;
 	host->wp_pin = minfo->wp_pin;
 	host->use_dma = 1;
 	host->dma_ch = -1;
@@ -1108,48 +1005,10 @@ static int __init mmc_omap_probe(struct platform_device *pdev)
 	host->dev = &pdev->dev;
 	platform_set_drvdata(pdev, host);
 
-	if (host->switch_pin >= 0) {
-		INIT_WORK(&host->switch_work, mmc_omap_switch_handler);
-		init_timer(&host->switch_timer);
-		host->switch_timer.function = mmc_omap_switch_timer;
-		host->switch_timer.data = (unsigned long) host;
-		if (omap_request_gpio(host->switch_pin) != 0) {
-			dev_warn(mmc_dev(host->mmc), "Unable to get GPIO pin for MMC cover switch\n");
-			host->switch_pin = -1;
-			goto no_switch;
-		}
-
-		omap_set_gpio_direction(host->switch_pin, 1);
-		ret = request_irq(OMAP_GPIO_IRQ(host->switch_pin),
-				  mmc_omap_switch_irq, IRQF_TRIGGER_RISING, DRIVER_NAME, host);
-		if (ret) {
-			dev_warn(mmc_dev(host->mmc), "Unable to get IRQ for MMC cover switch\n");
-			omap_free_gpio(host->switch_pin);
-			host->switch_pin = -1;
-			goto no_switch;
-		}
-		ret = device_create_file(&pdev->dev, &dev_attr_cover_switch);
-		if (ret == 0) {
-			ret = device_create_file(&pdev->dev, &dev_attr_enable_poll);
-			if (ret != 0)
-				device_remove_file(&pdev->dev, &dev_attr_cover_switch);
-		}
-		if (ret) {
-			dev_warn(mmc_dev(host->mmc), "Unable to create sysfs attributes\n");
-			free_irq(OMAP_GPIO_IRQ(host->switch_pin), host);
-			omap_free_gpio(host->switch_pin);
-			host->switch_pin = -1;
-			goto no_switch;
-		}
-		if (mmc_omap_enable_poll && mmc_omap_cover_is_open(host))
-			schedule_work(&host->switch_work);
-	}
-
 	mmc_add_host(mmc);
 
 	return 0;
 
-no_switch:
 	/* FIXME: Free other resources too. */
 	if (host) {
 		if (host->iclk && !IS_ERR(host->iclk))
@@ -1188,15 +1047,6 @@ static int mmc_omap_remove(struct platform_device *pdev)
 
 	if (host->power_pin >= 0)
 		omap_free_gpio(host->power_pin);
-	if (host->switch_pin >= 0) {
-		device_remove_file(&pdev->dev, &dev_attr_enable_poll);
-		device_remove_file(&pdev->dev, &dev_attr_cover_switch);
-		free_irq(OMAP_GPIO_IRQ(host->switch_pin), host);
-		omap_free_gpio(host->switch_pin);
-		host->switch_pin = -1;
-		del_timer_sync(&host->switch_timer);
-		flush_scheduled_work();
-	}
 	if (host->iclk && !IS_ERR(host->iclk))
 		clk_put(host->iclk);
 	if (host->fclk && !IS_ERR(host->fclk))
-- 1.5.3.GIT

