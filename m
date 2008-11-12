Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbYKLXlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbYKLXlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYKLXiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:38:55 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58636 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254AbYKLXiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:38:54 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: unify mtd partition/device registration
Date: Wed, 12 Nov 2008 18:38:53 -0500
Message-Id: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than having every map/mtd driver doing the same sequence of
registering partitions and/or devices, implement common parse_mtd().

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/mtd/mtdcore.c   |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/mtd/mtd.h |    3 +++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index a9d2469..654ec1b 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -292,6 +292,43 @@ void put_mtd_device(struct mtd_info *mtd)
 	module_put(mtd->owner);
 }
 
+#include <linux/mtd/partitions.h>
+
+/**
+ *	parse_mtd - add partitions / devices
+ *
+ *	If partitioning support is enabled, attempt to call parse_mtd_partitions()
+ *	and add_mtd_partitions() with all available parsers.  Otherwise just add
+ *	the MTD device.
+ */
+
+int parse_mtd(struct mtd_info *mtd, const char **probe_types,
+              struct mtd_partition *parts, int nr_parts)
+{
+#ifdef CONFIG_MTD_PARTITIONS
+	const char *default_part_probe_types[] = {
+		"cmdlinepart",
+		"RedBoot",
+		NULL
+	};
+	int ret;
+
+	if (!probe_types)
+		probe_types = default_part_probe_types;
+
+	ret = parse_mtd_partitions(mtd, probe_types, &parts, 0);
+	if (ret > 0) {
+		ret = add_mtd_partitions(mtd, parts, ret);
+		kfree(parts);
+		return ret;
+	} else if (nr_parts)
+		return add_mtd_partitions(mtd, parts, nr_parts);
+#endif
+
+	return add_mtd_device(mtd);
+}
+EXPORT_SYMBOL(parse_mtd);
+
 /* default_mtd_writev - default mtd writev method for MTD devices that
  *			don't implement their own
  */
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index eae26bb..dec3456 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -232,6 +232,9 @@ extern struct mtd_info *get_mtd_device_nm(const char *name);
 
 extern void put_mtd_device(struct mtd_info *mtd);
 
+struct mtd_partition;
+int parse_mtd(struct mtd_info *mtd, const char **probe_types,
+              struct mtd_partition *parts, int nr_parts);
 
 struct mtd_notifier {
 	void (*add)(struct mtd_info *mtd);
-- 
1.6.0.3

