Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYFZLKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYFZLKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbYFZLJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:09:43 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:57508 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbYFZLJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:09:42 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 3/3] mmc: Add per-card debugfs support
Date: Thu, 26 Jun 2008 13:09:49 +0200
Message-Id: <1214478589-21291-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 26 Jun 2008 11:09:32.0588 (UTC) FILETIME=[1C4EF6C0:01C8D77D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each card successfully added to the bus, create a subdirectory under
the host's debugfs root with information about the card.

At the moment, only a single file is added to the card directory:
"status". Reading this file will ask the card about its current status
and return it. This can be useful if the card just refuses to respond to
any commands, which might indicate that the card state is not what the
MMC core thinks it is (due to a missing stop command, for example.)

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/core/bus.c   |   71 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/card.h |    4 ++
 2 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index fd95b18..04978c5 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -24,6 +24,73 @@
 #define dev_to_mmc_card(d)	container_of(d, struct mmc_card, dev)
 #define to_mmc_driver(d)	container_of(d, struct mmc_driver, drv)
 
+#ifdef CONFIG_MMC_DEBUG_FS
+#include <linux/debugfs.h>
+#include "mmc_ops.h"
+
+static int mmc_dbg_card_status_get(void *data, u64 *val)
+{
+	struct mmc_card	*card = data;
+	u32		status;
+	int		ret;
+
+	mmc_claim_host(card->host);
+
+	ret = mmc_send_status(data, &status);
+	if (!ret)
+		*val = status;
+
+	mmc_release_host(card->host);
+
+	return ret;
+}
+DEFINE_SIMPLE_ATTRIBUTE(mmc_dbg_card_status_fops, mmc_dbg_card_status_get,
+		NULL, "%08llx\n");
+
+static void mmc_add_card_debugfs(struct mmc_card *card)
+{
+	struct mmc_host	*host = card->host;
+	struct dentry	*root;
+
+	if (!host->debugfs_root)
+		return;
+
+	root = debugfs_create_dir(mmc_card_id(card), host->debugfs_root);
+	if (IS_ERR(root) || !root)
+		goto err_root;
+	card->dbg_root = root;
+
+	card->dbg_status = debugfs_create_file("status", 0400, root, card,
+				&mmc_dbg_card_status_fops);
+	if (!card->dbg_status)
+		goto err_status;
+
+	return;
+
+err_status:
+	debugfs_remove(root);
+	card->dbg_root = root;
+err_root:
+	dev_err(&card->dev, "failed to initialize debugfs\n");
+}
+
+static void mmc_remove_card_debugfs(struct mmc_card *card)
+{
+	debugfs_remove(card->dbg_status);
+	debugfs_remove(card->dbg_root);
+}
+#else
+static inline void mmc_add_card_debugfs(struct mmc_card *card)
+{
+
+}
+
+static inline void mmc_remove_card_debugfs(struct mmc_card *card)
+{
+
+}
+#endif
+
 static ssize_t mmc_type_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
@@ -252,6 +319,8 @@ int mmc_add_card(struct mmc_card *card)
 	if (ret)
 		return ret;
 
+	mmc_add_card_debugfs(card);
+
 	mmc_card_set_present(card);
 
 	return 0;
@@ -263,6 +332,8 @@ int mmc_add_card(struct mmc_card *card)
  */
 void mmc_remove_card(struct mmc_card *card)
 {
+	mmc_remove_card_debugfs(card);
+
 	if (mmc_card_present(card)) {
 		if (mmc_host_is_spi(card->host)) {
 			printk(KERN_INFO "%s: SPI card removed\n",
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 0d508ac..3d2bff8 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -111,6 +111,10 @@ struct mmc_card {
 	unsigned		num_info;	/* number of info strings */
 	const char		**info;		/* info strings */
 	struct sdio_func_tuple	*tuples;	/* unknown common tuples */
+#ifdef CONFIG_MMC_DEBUG_FS
+	struct dentry		*dbg_root;
+	struct dentry		*dbg_status;
+#endif
 };
 
 #define mmc_card_mmc(c)		((c)->type == MMC_TYPE_MMC)
-- 
1.5.5.4

