Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYFZLKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYFZLKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYFZLJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:09:41 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:57505 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbYFZLJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:09:39 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 1/3] mmc: Export internal host state through debugfs
Date: Thu, 26 Jun 2008 13:09:47 +0200
Message-Id: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 26 Jun 2008 11:09:32.0463 (UTC) FILETIME=[1C3BE3F0:01C8D77D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

This adds a new config option, MMC_DEBUG_FS which will, when enabled,
create a few files under /sys/kernel/debug containing information
about an mmc host's internal state.

Host drivers can add additional files and directories under the host's
root directory by passing the debugfs_root field in struct mmc_host as
the 'parent' parameter to debugfs_create_*.

Unfinished: No files are actually created yet.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/mmc/Kconfig      |   12 ++++++++++++
 drivers/mmc/core/host.c  |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h |    3 +++
 3 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/Kconfig b/drivers/mmc/Kconfig
index c0b41e8..434ee2d 100644
--- a/drivers/mmc/Kconfig
+++ b/drivers/mmc/Kconfig
@@ -18,6 +18,18 @@ config MMC_DEBUG
 	  This is an option for use by developers; most people should
 	  say N here.  This enables MMC core and driver debugging.
 
+config MMC_DEBUG_FS
+	bool "Debugging information files in debugfs"
+	depends on MMC && DEBUG_FS
+	help
+	  Enable this option to export some of the internal MMC state
+	  through files under /sys/kernel/debug/. This may help
+	  troubleshooting a buggy driver or when you're bringing up a
+	  driver on a new board.
+
+	  This debug option is relatively unintrusive, but most people
+	  don't need this. If in doubt, say N.
+
 if MMC
 
 source "drivers/mmc/core/Kconfig"
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 1d795c5..93da502 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -22,6 +22,41 @@
 #include "core.h"
 #include "host.h"
 
+#ifdef CONFIG_MMC_DEBUG_FS
+#include <linux/debugfs.h>
+
+static void mmc_add_host_debugfs(struct mmc_host *host)
+{
+	struct dentry *root;
+
+	root = debugfs_create_dir(mmc_hostname(host), NULL);
+	if (IS_ERR(root) || !root)
+		goto err_root;
+	host->debugfs_root = root;
+
+	return;
+
+err_root:
+	dev_err(&host->class_dev, "failed to initialize debugfs\n");
+}
+
+static void mmc_remove_host_debugfs(struct mmc_host *host)
+{
+	debugfs_remove(host->debugfs_root);
+}
+
+#else
+static inline void mmc_add_host_debugfs(struct mmc_host *host)
+{
+
+}
+
+static inline void mmc_remove_host_debugfs(struct mmc_host *host)
+{
+
+}
+#endif
+
 #define cls_dev_to_mmc_host(d)	container_of(d, struct mmc_host, class_dev)
 
 static void mmc_host_classdev_release(struct device *dev)
@@ -127,6 +162,8 @@ int mmc_add_host(struct mmc_host *host)
 	if (err)
 		return err;
 
+	mmc_add_host_debugfs(host);
+
 	mmc_start_host(host);
 
 	return 0;
@@ -146,6 +183,8 @@ void mmc_remove_host(struct mmc_host *host)
 {
 	mmc_stop_host(host);
 
+	mmc_remove_host_debugfs(host);
+
 	device_del(&host->class_dev);
 
 	led_trigger_unregister_simple(host->led);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7ab962f..31002e7 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -134,6 +134,9 @@ struct mmc_host {
 #ifdef CONFIG_LEDS_TRIGGERS
 	struct led_trigger	*led;		/* activity led */
 #endif
+#ifdef CONFIG_MMC_DEBUG_FS
+	struct dentry		*debugfs_root;
+#endif
 
 	unsigned long		private[0] ____cacheline_aligned;
 };
-- 
1.5.5.4

