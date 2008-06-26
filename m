Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbYFZLJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbYFZLJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYFZLJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:09:40 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:57506 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbYFZLJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:09:39 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 2/3] mmc: Export ios settings for a host through debugfs
Date: Thu, 26 Jun 2008 13:09:48 +0200
Message-Id: <1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 26 Jun 2008 11:09:32.0526 (UTC) FILETIME=[1C4580E0:01C8D77D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Export all the fields in struct mmc_ios under /sys/kernel/debug/<host>/ios

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/mmc/core/host.c  |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h |   13 +++++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 93da502..2977f26 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -25,6 +25,54 @@
 #ifdef CONFIG_MMC_DEBUG_FS
 #include <linux/debugfs.h>
 
+static void mmc_remove_ios_debugfs(struct mmc_ios *ios)
+{
+	if (ios->dbg_root) {
+		debugfs_remove(ios->dbg_clock);
+		debugfs_remove(ios->dbg_vdd);
+		debugfs_remove(ios->dbg_bus_mode);
+		debugfs_remove(ios->dbg_chip_select);
+		debugfs_remove(ios->dbg_power_mode);
+		debugfs_remove(ios->dbg_bus_width);
+		debugfs_remove(ios->dbg_timing);
+		debugfs_remove(ios->dbg_root);
+		ios->dbg_root = NULL;
+	}
+}
+
+static int mmc_add_ios_debugfs(struct mmc_ios *ios, struct dentry *parent)
+{
+	struct dentry *dir;
+
+	dir = debugfs_create_dir("ios", parent);
+	if (!dir)
+		return -EBUSY;	/* or whatever */
+	ios->dbg_root = dir;
+
+	ios->dbg_clock = debugfs_create_u32("clock", 0400, dir, &ios->clock);
+	ios->dbg_vdd = debugfs_create_u16("vdd", 0400, dir, &ios->vdd);
+	ios->dbg_bus_mode = debugfs_create_u8("bus_mode", 0400, dir,
+					      &ios->bus_mode);
+	ios->dbg_chip_select = debugfs_create_u8("chip_select", 0400, dir,
+						 &ios->chip_select);
+	ios->dbg_power_mode = debugfs_create_u8("power_mode", 0400, dir,
+						&ios->power_mode);
+	ios->dbg_bus_width = debugfs_create_u8("bus_width", 0400, dir,
+					       &ios->bus_width);
+	ios->dbg_timing = debugfs_create_u8("timing", 0400, dir, &ios->timing);
+
+	if (!ios->dbg_clock || !ios->dbg_vdd || !ios->dbg_bus_mode
+			|| !ios->dbg_chip_select || !ios->dbg_power_mode
+			|| !ios->dbg_bus_width || !ios->dbg_timing)
+		goto err;
+
+	return 0;
+
+err:
+	mmc_remove_ios_debugfs(ios);
+	return -EBUSY;
+}
+
 static void mmc_add_host_debugfs(struct mmc_host *host)
 {
 	struct dentry *root;
@@ -34,14 +82,21 @@ static void mmc_add_host_debugfs(struct mmc_host *host)
 		goto err_root;
 	host->debugfs_root = root;
 
+	if (mmc_add_ios_debugfs(&host->ios, root))
+		goto err_ios;
+
 	return;
 
+err_ios:
+	debugfs_remove(root);
+	host->debugfs_root = NULL;
 err_root:
 	dev_err(&host->class_dev, "failed to initialize debugfs\n");
 }
 
 static void mmc_remove_host_debugfs(struct mmc_host *host)
 {
+	mmc_remove_ios_debugfs(&host->ios);
 	debugfs_remove(host->debugfs_root);
 }
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 31002e7..1ba2723 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -47,6 +47,17 @@ struct mmc_ios {
 #define MMC_TIMING_LEGACY	0
 #define MMC_TIMING_MMC_HS	1
 #define MMC_TIMING_SD_HS	2
+
+#ifdef CONFIG_MMC_DEBUG_FS
+	struct dentry		*dbg_root;
+	struct dentry		*dbg_clock;
+	struct dentry		*dbg_vdd;
+	struct dentry		*dbg_bus_mode;
+	struct dentry		*dbg_chip_select;
+	struct dentry		*dbg_power_mode;
+	struct dentry		*dbg_bus_width;
+	struct dentry		*dbg_timing;
+#endif
 };
 
 struct mmc_host_ops {
@@ -136,6 +147,8 @@ struct mmc_host {
 #endif
 #ifdef CONFIG_MMC_DEBUG_FS
 	struct dentry		*debugfs_root;
+	struct dentry		*debugfs_ios;
+	struct dentry		*debugfs_ios_clock;
 #endif
 
 	unsigned long		private[0] ____cacheline_aligned;
-- 
1.5.5.4

