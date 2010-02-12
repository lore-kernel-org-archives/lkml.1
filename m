Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0BLMCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 07:02:53 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55595 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab0BLMBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:01:05 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 07/12] Add /sys trigger for per-node memory compaction
Date: Fri, 12 Feb 2010 12:00:54 +0000
Message-Id: <1265976059-7459-8-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a per-node sysfs file called compact. When the file is
written to, each zone in that node is compacted. The intention that this
would be used by something like a job scheduler in a batch system before
a job starts so that the job can allocate the maximum number of
hugepages without significant start-up cost.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 drivers/base/node.c        |    3 +++
 include/linux/compaction.h |   16 ++++++++++++++++
 mm/compaction.c            |   23 +++++++++++++++++++++++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 7012279..2333c9d 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/swap.h>
+#include <linux/compaction.h>
 
 static struct sysdev_class node_class = {
 	.name = "node",
@@ -239,6 +240,8 @@ int register_node(struct node *node, int num, struct node *parent)
 		scan_unevictable_register_node(node);
 
 		hugetlb_register_node(node);
+
+		compaction_register_node(node);
 	}
 	return error;
 }
diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index facaa3d..6a2eefd 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -10,4 +10,20 @@ extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
 #endif /* CONFIG_COMPACTION */
 
+#if defined(CONFIG_COMPACTION) && defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
+extern int compaction_register_node(struct node *node);
+extern void compaction_unregister_node(struct node *node);
+
+#else
+
+static inline int compaction_register_node(struct node *node)
+{
+	return 0;
+}
+
+static inline void compaction_unregister_node(struct node *node)
+{
+}
+#endif /* CONFIG_COMPACTION && CONFIG_SYSFS && CONFIG_NUMA */
+
 #endif /* _LINUX_COMPACTION_H */
diff --git a/mm/compaction.c b/mm/compaction.c
index c0b9dc9..f5bd5ed 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -12,6 +12,7 @@
 #include <linux/compaction.h>
 #include <linux/mm_inline.h>
 #include <linux/sysctl.h>
+#include <linux/sysfs.h>
 #include "internal.h"
 
 /*
@@ -399,3 +400,25 @@ int sysctl_compaction_handler(struct ctl_table *table, int write,
 
 	return 0;
 }
+
+#if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
+ssize_t sysfs_compact_node(struct sys_device *dev,
+			struct sysdev_attribute *attr,
+			const char *buf, size_t count)
+{
+	compact_node(dev->id);
+
+	return count;
+}
+static SYSDEV_ATTR(compact, S_IWUSR, NULL, sysfs_compact_node);
+
+int compaction_register_node(struct node *node)
+{
+	return sysdev_create_file(&node->sysdev, &attr_compact);
+}
+
+void compaction_unregister_node(struct node *node)
+{
+	return sysdev_remove_file(&node->sysdev, &attr_compact);
+}
+#endif /* CONFIG_SYSFS && CONFIG_NUMA */
-- 
1.6.5

