Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYGXMUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYGXMUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYGXMT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:19:56 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:48137 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYGXMTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:19:54 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v3 2/3] mmc: Add per-card debugfs support
Date: Thu, 24 Jul 2008 14:18:58 +0200
Message-Id: <1216901939-4187-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1216901939-4187-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1216901939-4187-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 24 Jul 2008 12:19:41.0651 (UTC) FILETIME=[8CAC0230:01C8ED87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each card successfully added to the bus, create a subdirectory under
the host's debugfs root with information about the card.

At the moment, only a single file is added to the card directory for
all cards: "state". It reflects the "state" field in struct mmc_card,
indicating whether the card is present, readonly, etc.

For MMC and SD cards (not SDIO), another file is added: "status".
Reading this file will ask the card about its current status and
return it. This can be useful if the card just refuses to respond to
any commands, which might indicate that the card state is not what the
MMC core thinks it is (due to a missing stop command, for example.)

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Changes since v2:
  * Don't rely on the compiler to optimize out unused code

Changes since v1:
  * move card debugfs stuff into debugfs.c
  * add "state" file corresponding to the "state" field in struct
    mmc_card.
  * only create the "status" file if the card is an MMC or SD memory
    card since SDIO doesn't support the SEND_STATUS command.
---
 drivers/mmc/core/bus.c     |    8 ++++++
 drivers/mmc/core/core.h    |    3 ++
 drivers/mmc/core/debugfs.c |   61 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/card.h   |    2 +
 4 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index fd95b18..0d9b2d6 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -252,6 +252,10 @@ int mmc_add_card(struct mmc_card *card)
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_DEBUG_FS
+	mmc_add_card_debugfs(card);
+#endif
+
 	mmc_card_set_present(card);
 
 	return 0;
@@ -263,6 +267,10 @@ int mmc_add_card(struct mmc_card *card)
  */
 void mmc_remove_card(struct mmc_card *card)
 {
+#ifdef CONFIG_DEBUG_FS
+	mmc_remove_card_debugfs(card);
+#endif
+
 	if (mmc_card_present(card)) {
 		if (mmc_host_is_spi(card->host)) {
 			printk(KERN_INFO "%s: SPI card removed\n",
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 745da98..c819eff 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -56,5 +56,8 @@ extern int use_spi_crc;
 void mmc_add_host_debugfs(struct mmc_host *host);
 void mmc_remove_host_debugfs(struct mmc_host *host);
 
+void mmc_add_card_debugfs(struct mmc_card *card);
+void mmc_remove_card_debugfs(struct mmc_card *card);
+
 #endif
 
diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 133c6e5..1237bb4 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -12,9 +12,11 @@
 #include <linux/seq_file.h>
 #include <linux/stat.h>
 
+#include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 
 #include "core.h"
+#include "mmc_ops.h"
 
 /* The debugfs functions are optimized away when CONFIG_DEBUG_FS isn't set. */
 static int mmc_ios_show(struct seq_file *s, void *data)
@@ -162,3 +164,62 @@ void mmc_remove_host_debugfs(struct mmc_host *host)
 {
 	debugfs_remove_recursive(host->debugfs_root);
 }
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
+void mmc_add_card_debugfs(struct mmc_card *card)
+{
+	struct mmc_host	*host = card->host;
+	struct dentry	*root;
+
+	if (!host->debugfs_root)
+		return;
+
+	root = debugfs_create_dir(mmc_card_id(card), host->debugfs_root);
+	if (IS_ERR(root))
+		/* Don't complain -- debugfs just isn't enabled */
+		return;
+	if (!root)
+		/* Complain -- debugfs is enabled, but it failed to
+		 * create the directory. */
+		goto err;
+
+	card->debugfs_root = root;
+
+	if (!debugfs_create_x32("state", S_IRUSR, root, &card->state))
+		goto err;
+
+	if (mmc_card_mmc(card) || mmc_card_sd(card))
+		if (!debugfs_create_file("status", S_IRUSR, root, card,
+					&mmc_dbg_card_status_fops))
+			goto err;
+
+	return;
+
+err:
+	debugfs_remove_recursive(root);
+	card->debugfs_root = NULL;
+	dev_err(&card->dev, "failed to initialize debugfs\n");
+}
+
+void mmc_remove_card_debugfs(struct mmc_card *card)
+{
+	debugfs_remove_recursive(card->debugfs_root);
+}
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 0d508ac..ee6e822 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -111,6 +111,8 @@ struct mmc_card {
 	unsigned		num_info;	/* number of info strings */
 	const char		**info;		/* info strings */
 	struct sdio_func_tuple	*tuples;	/* unknown common tuples */
+
+	struct dentry		*debugfs_root;
 };
 
 #define mmc_card_mmc(c)		((c)->type == MMC_TYPE_MMC)
-- 
1.5.6.2

