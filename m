Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbXEMXVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbXEMXVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbXEMXVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:21:10 -0400
Received: from usul.saidi.cx ([204.11.33.34]:32822 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756218AbXEMXVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:21:09 -0400
Message-ID: <46479D59.4020400@overt.org>
Date: Sun, 13 May 2007 16:20:57 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>, Tobias Bengtsson <tobbe@tobbe.nu>
CC: sdhci-devel@list.drzeus.cx, LKML <linux-kernel@vger.kernel.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-I-Got-Here: Yes
X-I-Got-Here: Yes3
Subject: [PATCH] sdhci: Add quirk to support polling for card presence
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is apparently at least one instance of the Ricoh SDHCI
implementation out there where card insertion (and possibly
removal) interrupts do not work - so the only way to detect
a change in the presence of a card is to poll.

This changes adds a polling quirk for the particular model
reported by Tobias. The change is tentative as it assumes
that removal interrupts do not work, but if they do work,
then we can optimise things by not polling when there is
a card present. So, it should not be committed until Tobias
has confirmed the removal behaviour one way or the other and
the change is accordingly updated.

The polling frequency is 3 seconds because I've been running
powertop and am paranoid about wakeups now. :-) I did some
testing locally by masking out the interrupt events and 3
seconds seems usable enough to me.

Signed-off-by: Philip Langdale <philipl@overt.org>

diff --git a/drivers/mmc/sdhci.c b/drivers/mmc/sdhci.c
index ff5bf73..8c5b2f5 100644
--- a/drivers/mmc/sdhci.c
+++ b/drivers/mmc/sdhci.c
@@ -34,6 +34,7 @@ static unsigned int debug_quirks = 0;
 /* Controller doesn't like some resets when there is no card inserted. */
 #define SDHCI_QUIRK_NO_CARD_NO_RESET			(1<<2)
 #define SDHCI_QUIRK_SINGLE_POWER_WRITE			(1<<3)
+#define SDHCI_QUIRK_NO_CARD_DETECT_INT			(1<<4)

 static const struct pci_device_id pci_ids[] __devinitdata = {
 	{
@@ -48,6 +49,16 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 	{
 		.vendor		= PCI_VENDOR_ID_RICOH,
 		.device		= PCI_DEVICE_ID_RICOH_R5C822,
+		.subvendor	= PCI_SUBVENDOR_ID_FUJITSU_SIEMENS,
+		.subdevice	= PCI_SUBDEVICE_ID_FUJITSU_SIEMENS_SI1520,
+		.driver_data	= SDHCI_QUIRK_FORCE_DMA |
+				  SDHCI_QUIRK_NO_CARD_NO_RESET |
+				  SDHCI_QUIRK_NO_CARD_DETECT_INT,
+	},
+
+	{
+		.vendor		= PCI_VENDOR_ID_RICOH,
+		.device		= PCI_DEVICE_ID_RICOH_R5C822,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 		.driver_data	= SDHCI_QUIRK_FORCE_DMA |
@@ -788,13 +799,15 @@ static void sdhci_tasklet_card(unsigned long param)
 {
 	struct sdhci_host *host;
 	unsigned long flags;
+	int present;

 	host = (struct sdhci_host*)param;

 	spin_lock_irqsave(&host->lock, flags);

-	if (!(readl(host->ioaddr + SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
-		if (host->mrq) {
+	present = readl(host->ioaddr + SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT;
+	if (present != host->present) {
+		if (!present && host->mrq) {
 			printk(KERN_ERR "%s: Card removed during transfer!\n",
 				mmc_hostname(host->mmc));
 			printk(KERN_ERR "%s: Resetting controller.\n",
@@ -806,11 +819,18 @@ static void sdhci_tasklet_card(unsigned long param)
 			host->mrq->cmd->error = MMC_ERR_FAILED;
 			tasklet_schedule(&host->finish_tasklet);
 		}
-	}

-	spin_unlock_irqrestore(&host->lock, flags);
+		spin_unlock_irqrestore(&host->lock, flags);
+
+		host->present = present;
+
+		mmc_detect_change(host->mmc, msecs_to_jiffies(500));
+	}

-	mmc_detect_change(host->mmc, msecs_to_jiffies(500));
+	if (host->chip->quirks & SDHCI_QUIRK_NO_CARD_DETECT_INT) {
+		host->detect_timer.expires = jiffies + 3 * HZ;
+		add_timer(&host->detect_timer);
+	}
 }

 static void sdhci_tasklet_finish(unsigned long param)
@@ -865,6 +885,15 @@ static void sdhci_tasklet_finish(unsigned long param)
 	mmc_request_done(host->mmc, mrq);
 }

+static void sdhci_detect_timer(unsigned long data)
+{
+	struct sdhci_host *host;
+
+	host = (struct sdhci_host*)data;
+
+	tasklet_schedule(&host->card_tasklet);
+}
+
 static void sdhci_timeout_timer(unsigned long data)
 {
 	struct sdhci_host *host;
@@ -1329,6 +1358,8 @@ static int __devinit sdhci_probe_slot(struct pci_dev *pdev, int slot)
 	 */
 	mmc->max_blk_count = 65535;

+	host->present = readl(host->ioaddr + SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT;;
+
 	/*
 	 * Init tasklets.
 	 */
@@ -1344,6 +1375,12 @@ static int __devinit sdhci_probe_slot(struct pci_dev *pdev, int slot)
 	if (ret)
 		goto untasklet;

+	if (host->chip->quirks & SDHCI_QUIRK_NO_CARD_DETECT_INT) {
+		setup_timer(&host->detect_timer, sdhci_detect_timer, (unsigned long)host);
+		host->detect_timer.expires = jiffies + 3 * HZ;
+		add_timer(&host->detect_timer);
+	}
+
 	sdhci_init(host);

 #ifdef CONFIG_MMC_DEBUG
@@ -1396,6 +1433,10 @@ static void sdhci_remove_slot(struct pci_dev *pdev, int slot)
 	tasklet_kill(&host->card_tasklet);
 	tasklet_kill(&host->finish_tasklet);

+	if (host->chip->quirks & SDHCI_QUIRK_NO_CARD_DETECT_INT) {
+		del_timer_sync(&host->detect_timer);
+	}
+
 	iounmap(host->ioaddr);

 	pci_release_region(pdev, host->bar);
diff --git a/drivers/mmc/sdhci.h b/drivers/mmc/sdhci.h
index 7400f4b..fafd1c4 100644
--- a/drivers/mmc/sdhci.h
+++ b/drivers/mmc/sdhci.h
@@ -198,6 +198,9 @@ struct sdhci_host {
 	struct tasklet_struct	finish_tasklet;

 	struct timer_list	timer;		/* Timer for timeouts */
+
+	struct timer_list	detect_timer;	/* Timer for card polling */
+	int			present;	/* Cached card present state */
 };

 struct sdhci_chip {
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ae849f0..e10eeaf 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2049,6 +2049,9 @@
 #define PCI_VENDOR_ID_VITESSE		0x1725
 #define PCI_DEVICE_ID_VITESSE_VSC7174	0x7174

+#define PCI_SUBVENDOR_ID_FUJITSU_SIEMENS	0x1734
+#define PCI_SUBDEVICE_ID_FUJITSU_SIEMENS_SI1520	0x10ad
+
 #define PCI_VENDOR_ID_LINKSYS		0x1737
 #define PCI_DEVICE_ID_LINKSYS_EG1064	0x1064

