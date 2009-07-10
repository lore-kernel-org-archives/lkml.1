Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbZGJMj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbZGJMj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZGJMhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:37:39 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34863 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZGJMh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:37:28 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:40:41 +0300
Message-Id: <20090710124041.1262.30914.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 5/32] mmc: add mmc card sleep and awake support
X-OriginalArrivalTime: 10 Jul 2009 12:37:04.0691 (UTC) FILETIME=[215D8830:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b2f023bed880e3560aaa7de5caa6f899d79840f5 Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Tue, 12 May 2009 19:46:14 +0300
Subject: [PATCH] mmc: add mmc card sleep and awake support

Add support for the new MMC command SLEEP_AWAKE.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/core/core.c    |   40 ++++++++++++++++++++++++++++++++
 drivers/mmc/core/core.h    |    2 +
 drivers/mmc/core/mmc.c     |   54 +++++++++++++++++++++++++++++++++++++++----
 drivers/mmc/core/mmc_ops.c |   36 +++++++++++++++++++++++++++++
 drivers/mmc/core/mmc_ops.h |    1 +
 include/linux/mmc/card.h   |    2 +
 include/linux/mmc/host.h   |    5 ++++
 include/linux/mmc/mmc.h    |    2 +
 8 files changed, 137 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index b76a0f7..1461025 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1176,6 +1176,46 @@ void mmc_power_restore_host(struct mmc_host *host)
 }
 EXPORT_SYMBOL(mmc_power_restore_host);
 
+int mmc_card_awake(struct mmc_host *host)
+{
+	int err = -ENOSYS;
+
+	mmc_bus_get(host);
+
+	if (host->bus_ops && !host->bus_dead && host->bus_ops->awake)
+		err = host->bus_ops->awake(host);
+
+	mmc_bus_put(host);
+
+	return err;
+}
+EXPORT_SYMBOL(mmc_card_awake);
+
+int mmc_card_sleep(struct mmc_host *host)
+{
+	int err = -ENOSYS;
+
+	mmc_bus_get(host);
+
+	if (host->bus_ops && !host->bus_dead && host->bus_ops->awake)
+		err = host->bus_ops->sleep(host);
+
+	mmc_bus_put(host);
+
+	return err;
+}
+EXPORT_SYMBOL(mmc_card_sleep);
+
+int mmc_card_can_sleep(struct mmc_host *host)
+{
+	struct mmc_card *card = host->card;
+
+	if (card && mmc_card_mmc(card) && card->ext_csd.rev >= 3)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(mmc_card_can_sleep);
+
 #ifdef CONFIG_PM
 
 /**
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index f7eb4c4..c386348 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -16,6 +16,8 @@
 #define MMC_CMD_RETRIES        3
 
 struct mmc_bus_ops {
+	int (*awake)(struct mmc_host *);
+	int (*sleep)(struct mmc_host *);
 	void (*remove)(struct mmc_host *);
 	void (*detect)(struct mmc_host *);
 	void (*suspend)(struct mmc_host *);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 01f7226..8e2e3d2 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -160,7 +160,6 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 {
 	int err;
 	u8 *ext_csd;
-	unsigned int ext_csd_struct;
 
 	BUG_ON(!card);
 
@@ -207,16 +206,16 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 		goto out;
 	}
 
-	ext_csd_struct = ext_csd[EXT_CSD_REV];
-	if (ext_csd_struct > 3) {
+	card->ext_csd.rev = ext_csd[EXT_CSD_REV];
+	if (card->ext_csd.rev > 3) {
 		printk(KERN_ERR "%s: unrecognised EXT_CSD structure "
 			"version %d\n", mmc_hostname(card->host),
-			ext_csd_struct);
+			card->ext_csd.rev);
 		err = -EINVAL;
 		goto out;
 	}
 
-	if (ext_csd_struct >= 2) {
+	if (card->ext_csd.rev >= 2) {
 		card->ext_csd.sectors =
 			ext_csd[EXT_CSD_SEC_CNT + 0] << 0 |
 			ext_csd[EXT_CSD_SEC_CNT + 1] << 8 |
@@ -241,6 +240,15 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 		goto out;
 	}
 
+	if (card->ext_csd.rev >= 3) {
+		u8 sa_shift = ext_csd[EXT_CSD_S_A_TIMEOUT];
+
+		/* Sleep / awake timeout in 100ns units */
+		if (sa_shift > 0 && sa_shift <= 0x17)
+			card->ext_csd.sa_timeout =
+					1 << ext_csd[EXT_CSD_S_A_TIMEOUT];
+	}
+
 out:
 	kfree(ext_csd);
 
@@ -557,9 +565,41 @@ static void mmc_power_restore(struct mmc_host *host)
 	mmc_release_host(host);
 }
 
+static int mmc_sleep(struct mmc_host *host)
+{
+	struct mmc_card *card = host->card;
+	int err = -ENOSYS;
+
+	if (card && card->ext_csd.rev >= 3) {
+		err = mmc_card_sleepawake(host, 1);
+		if (err < 0)
+			pr_debug("%s: Error %d while putting card into sleep",
+				 mmc_hostname(host), err);
+	}
+
+	return err;
+}
+
+static int mmc_awake(struct mmc_host *host)
+{
+	struct mmc_card *card = host->card;
+	int err = -ENOSYS;
+
+	if (card && card->ext_csd.rev >= 3) {
+		err = mmc_card_sleepawake(host, 0);
+		if (err < 0)
+			pr_debug("%s: Error %d while awaking sleeping card",
+				 mmc_hostname(host), err);
+	}
+
+	return err;
+}
+
 #ifdef CONFIG_MMC_UNSAFE_RESUME
 
 static const struct mmc_bus_ops mmc_ops = {
+	.awake = mmc_awake,
+	.sleep = mmc_sleep,
 	.remove = mmc_remove,
 	.detect = mmc_detect,
 	.suspend = mmc_suspend,
@@ -575,6 +615,8 @@ static void mmc_attach_bus_ops(struct mmc_host *host)
 #else
 
 static const struct mmc_bus_ops mmc_ops = {
+	.awake = mmc_awake,
+	.sleep = mmc_sleep,
 	.remove = mmc_remove,
 	.detect = mmc_detect,
 	.suspend = NULL,
@@ -583,6 +625,8 @@ static const struct mmc_bus_ops mmc_ops = {
 };
 
 static const struct mmc_bus_ops mmc_ops_unsafe = {
+	.awake = mmc_awake,
+	.sleep = mmc_sleep,
 	.remove = mmc_remove,
 	.detect = mmc_detect,
 	.suspend = mmc_suspend,
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 34ce270..355c604 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -57,6 +57,42 @@ int mmc_deselect_cards(struct mmc_host *host)
 	return _mmc_select_card(host, NULL);
 }
 
+int mmc_card_sleepawake(struct mmc_host *host, int sleep)
+{
+	struct mmc_command cmd;
+	struct mmc_card *card = host->card;
+	int err;
+
+	if (sleep)
+		mmc_deselect_cards(host);
+
+	memset(&cmd, 0, sizeof(struct mmc_command));
+
+	cmd.opcode = MMC_SLEEP_AWAKE;
+	cmd.arg = card->rca << 16;
+	if (sleep)
+		cmd.arg |= 1 << 15;
+
+	cmd.flags = MMC_RSP_R1B | MMC_CMD_AC;
+	err = mmc_wait_for_cmd(host, &cmd, 0);
+	if (err)
+		return err;
+
+	/*
+	 * If the host does not wait while the card signals busy, then we will
+	 * will have to wait the sleep/awake timeout.  Note, we cannot use the
+	 * SEND_STATUS command to poll the status because that command (and most
+	 * others) is invalid while the card sleeps.
+	 */
+	if (!(host->caps & MMC_CAP_WAIT_WHILE_BUSY))
+		mmc_delay(DIV_ROUND_UP(card->ext_csd.sa_timeout, 10000));
+
+	if (!sleep)
+		err = mmc_select_card(card);
+
+	return err;
+}
+
 int mmc_go_idle(struct mmc_host *host)
 {
 	int err;
diff --git a/drivers/mmc/core/mmc_ops.h b/drivers/mmc/core/mmc_ops.h
index 17854bf..653eb8e 100644
--- a/drivers/mmc/core/mmc_ops.h
+++ b/drivers/mmc/core/mmc_ops.h
@@ -25,6 +25,7 @@ int mmc_send_status(struct mmc_card *card, u32 *status);
 int mmc_send_cid(struct mmc_host *host, u32 *cid);
 int mmc_spi_read_ocr(struct mmc_host *host, int highcap, u32 *ocrp);
 int mmc_spi_set_crc(struct mmc_host *host, int use_crc);
+int mmc_card_sleepawake(struct mmc_host *host, int sleep);
 
 #endif
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 403aa50..58f5917 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -40,6 +40,8 @@ struct mmc_csd {
 };
 
 struct mmc_ext_csd {
+	u8			rev;
+	unsigned int		sa_timeout;		/* Units: 100ns */
 	unsigned int		hs_max_dtr;
 	unsigned int		sectors;
 };
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index e24d992..0a60b02 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -149,6 +149,7 @@ struct mmc_host {
 #define MMC_CAP_8_BIT_DATA	(1 << 6)	/* Can the host do 8 bit transfers */
 #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
 #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
+#define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
@@ -240,6 +241,10 @@ struct regulator;
 int mmc_regulator_get_ocrmask(struct regulator *supply);
 int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit);
 
+int mmc_card_awake(struct mmc_host *host);
+int mmc_card_sleep(struct mmc_host *host);
+int mmc_card_can_sleep(struct mmc_host *host);
+
 int mmc_host_enable(struct mmc_host *host);
 int mmc_host_disable(struct mmc_host *host);
 int mmc_host_lazy_disable(struct mmc_host *host);
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 14b81f3..b2b4095 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -31,6 +31,7 @@
 #define MMC_ALL_SEND_CID          2   /* bcr                     R2  */
 #define MMC_SET_RELATIVE_ADDR     3   /* ac   [31:16] RCA        R1  */
 #define MMC_SET_DSR               4   /* bc   [31:16] RCA            */
+#define MMC_SLEEP_AWAKE		  5   /* ac   [31:16] RCA 15:flg R1b */
 #define MMC_SWITCH                6   /* ac   [31:0] See below   R1b */
 #define MMC_SELECT_CARD           7   /* ac   [31:16] RCA        R1  */
 #define MMC_SEND_EXT_CSD          8   /* adtc                    R1  */
@@ -254,6 +255,7 @@ struct _mmc_csd {
 #define EXT_CSD_CARD_TYPE	196	/* RO */
 #define EXT_CSD_REV		192	/* RO */
 #define EXT_CSD_SEC_CNT		212	/* RO, 4 bytes */
+#define EXT_CSD_S_A_TIMEOUT	217
 
 /*
  * EXT_CSD field definitions
-- 
1.5.6.3

