Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYGXMUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYGXMUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYGXMTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:19:55 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:48136 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbYGXMTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:19:54 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v3 1/3] mmc: Export internal host state through debugfs
Date: Thu, 24 Jul 2008 14:18:57 +0200
Message-Id: <1216901939-4187-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 24 Jul 2008 12:19:41.0619 (UTC) FILETIME=[8CA72030:01C8ED87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_DEBUG_FS is set, create a few files under /sys/kernel/debug
containing information about an mmc host's internal state. Currently,
just a single file is created, "ios", which contains information about
the current operating parameters for the bus (clock speed, bus width,
etc.)

Host drivers can add additional files and directories under the host's
root directory by passing the debugfs_root field in struct mmc_host as
the 'parent' parameter to debugfs_create_*.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Changes since v2:
  * Don't rely on the compiler to optimize out unused code

Changes since v1:
  * Fold with the ios patch
  * Remove MMC_DEBUG_FS config option and inline dummy functions
  * Use debugfs_remove_recursive to clean up. This allows us to remove
    lots of struct dentry fields from struct mmc_host and struct
    mmc_ios.
  * Move debugfs functionality into a separate file, debugfs.c
  * Convert "ios" directory to a single file containing all the
    information.
---
 drivers/mmc/core/Makefile  |    1 +
 drivers/mmc/core/core.h    |    4 +
 drivers/mmc/core/debugfs.c |  164 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/host.c    |    8 ++
 include/linux/mmc/host.h   |    2 +
 5 files changed, 179 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mmc/core/debugfs.c

diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
index 19a1a25..889e5f8 100644
--- a/drivers/mmc/core/Makefile
+++ b/drivers/mmc/core/Makefile
@@ -12,3 +12,4 @@ mmc_core-y			:= core.o bus.o host.o \
 				   sdio.o sdio_ops.o sdio_bus.o \
 				   sdio_cis.o sdio_io.o sdio_irq.o
 
+mmc_core-$(CONFIG_DEBUG_FS)	+= debugfs.o
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index cdb332b..745da98 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -52,5 +52,9 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr);
 
 extern int use_spi_crc;
 
+/* Debugfs information for hosts and cards */
+void mmc_add_host_debugfs(struct mmc_host *host);
+void mmc_remove_host_debugfs(struct mmc_host *host);
+
 #endif
 
diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
new file mode 100644
index 0000000..133c6e5
--- /dev/null
+++ b/drivers/mmc/core/debugfs.c
@@ -0,0 +1,164 @@
+/*
+ * Debugfs support for hosts and cards
+ *
+ * Copyright (C) 2008 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/stat.h>
+
+#include <linux/mmc/host.h>
+
+#include "core.h"
+
+/* The debugfs functions are optimized away when CONFIG_DEBUG_FS isn't set. */
+static int mmc_ios_show(struct seq_file *s, void *data)
+{
+	static const char *vdd_str[] = {
+		[8]	= "2.0",
+		[9]	= "2.1",
+		[10]	= "2.2",
+		[11]	= "2.3",
+		[12]	= "2.4",
+		[13]	= "2.5",
+		[14]	= "2.6",
+		[15]	= "2.7",
+		[16]	= "2.8",
+		[17]	= "2.9",
+		[18]	= "3.0",
+		[19]	= "3.1",
+		[20]	= "3.2",
+		[21]	= "3.3",
+		[22]	= "3.4",
+		[23]	= "3.5",
+		[24]	= "3.6",
+	};
+	struct mmc_host	*host = s->private;
+	struct mmc_ios	*ios = &host->ios;
+	const char *str;
+
+	seq_printf(s, "clock:\t\t%u Hz\n", ios->clock);
+	seq_printf(s, "vdd:\t\t%u ", ios->vdd);
+	if ((1 << ios->vdd) & MMC_VDD_165_195)
+		seq_printf(s, "(1.65 - 1.95 V)\n");
+	else if (ios->vdd < (ARRAY_SIZE(vdd_str) - 1)
+			&& vdd_str[ios->vdd] && vdd_str[ios->vdd + 1])
+		seq_printf(s, "(%s ~ %s V)\n", vdd_str[ios->vdd],
+				vdd_str[ios->vdd + 1]);
+	else
+		seq_printf(s, "(invalid)\n");
+
+	switch (ios->bus_mode) {
+	case MMC_BUSMODE_OPENDRAIN:
+		str = "open drain";
+		break;
+	case MMC_BUSMODE_PUSHPULL:
+		str = "push-pull";
+		break;
+	default:
+		str = "invalid";
+		break;
+	}
+	seq_printf(s, "bus mode:\t%u (%s)\n", ios->bus_mode, str);
+
+	switch (ios->chip_select) {
+	case MMC_CS_DONTCARE:
+		str = "don't care";
+		break;
+	case MMC_CS_HIGH:
+		str = "active high";
+		break;
+	case MMC_CS_LOW:
+		str = "active low";
+		break;
+	default:
+		str = "invalid";
+		break;
+	}
+	seq_printf(s, "chip select:\t%u (%s)\n", ios->chip_select, str);
+
+	switch (ios->power_mode) {
+	case MMC_POWER_OFF:
+		str = "off";
+		break;
+	case MMC_POWER_UP:
+		str = "up";
+		break;
+	case MMC_POWER_ON:
+		str = "on";
+		break;
+	default:
+		str = "invalid";
+		break;
+	}
+	seq_printf(s, "power mode:\t%u (%s)\n", ios->power_mode, str);
+	seq_printf(s, "bus width:\t%u (%u bits)\n",
+			ios->bus_width, 1 << ios->bus_width);
+
+	switch (ios->timing) {
+	case MMC_TIMING_LEGACY:
+		str = "legacy";
+		break;
+	case MMC_TIMING_MMC_HS:
+		str = "mmc high-speed";
+		break;
+	case MMC_TIMING_SD_HS:
+		str = "sd high-speed";
+		break;
+	default:
+		str = "invalid";
+		break;
+	}
+	seq_printf(s, "timing spec:\t%u (%s)\n", ios->timing, str);
+
+	return 0;
+}
+
+static int mmc_ios_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mmc_ios_show, inode->i_private);
+}
+
+static const struct file_operations mmc_ios_fops = {
+	.open		= mmc_ios_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+void mmc_add_host_debugfs(struct mmc_host *host)
+{
+	struct dentry *root;
+
+	root = debugfs_create_dir(mmc_hostname(host), NULL);
+	if (IS_ERR(root))
+		/* Don't complain -- debugfs just isn't enabled */
+		return;
+	if (!root)
+		/* Complain -- debugfs is enabled, but it failed to
+		 * create the directory. */
+		goto err_root;
+
+	host->debugfs_root = root;
+
+	if (!debugfs_create_file("ios", S_IRUSR, root, host, &mmc_ios_fops))
+		goto err_ios;
+
+	return;
+
+err_ios:
+	debugfs_remove_recursive(root);
+	host->debugfs_root = NULL;
+err_root:
+	dev_err(&host->class_dev, "failed to initialize debugfs\n");
+}
+
+void mmc_remove_host_debugfs(struct mmc_host *host)
+{
+	debugfs_remove_recursive(host->debugfs_root);
+}
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 1d795c5..6da80fd 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -127,6 +127,10 @@ int mmc_add_host(struct mmc_host *host)
 	if (err)
 		return err;
 
+#ifdef CONFIG_DEBUG_FS
+	mmc_add_host_debugfs(host);
+#endif
+
 	mmc_start_host(host);
 
 	return 0;
@@ -146,6 +150,10 @@ void mmc_remove_host(struct mmc_host *host)
 {
 	mmc_stop_host(host);
 
+#ifdef CONFIG_DEBUG_FS
+	mmc_remove_host_debugfs(host);
+#endif
+
 	device_del(&host->class_dev);
 
 	led_trigger_unregister_simple(host->led);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 10a2080..9c288c9 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -157,6 +157,8 @@ struct mmc_host {
 	struct led_trigger	*led;		/* activity led */
 #endif
 
+	struct dentry		*debugfs_root;
+
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
-- 
1.5.6.2

