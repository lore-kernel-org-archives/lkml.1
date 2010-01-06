Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910Ab0AFQ07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab0AFQ07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836Ab0AFQ0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:26:48 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55729 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab0AFQ0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:26:14 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 5/7] Add /proc trigger for memory compaction
Date: Wed,  6 Jan 2010 16:26:07 +0000
Message-Id: <1262795169-9095-6-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proc file /proc/sys/vm/compact_node. When a NID is written
to the file, each zone in that node is compacted. This should be done with
debugfs but this was what was available to rebase quickly and I suspect
debugfs either did not exist or was in development during the first
implementation.

If this interface is to exist in the long term, it needs to be thought
about carefully. For the moment, it's handy to have to test compaction
under a controlled setting.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/compaction.h |    5 ++++
 kernel/sysctl.c            |   11 +++++++++
 mm/compaction.c            |   52 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 6201371..5965ef2 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -5,4 +5,9 @@
 #define COMPACT_INCOMPLETE	0
 #define COMPACT_COMPLETE	1
 
+#ifdef CONFIG_MIGRATION
+extern int sysctl_compaction_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos);
+#endif /* CONFIG_MIGRATION */
+
 #endif /* _LINUX_COMPACTION_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a68b24..6202e95 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -50,6 +50,7 @@
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
+#include <linux/compaction.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -80,6 +81,7 @@ extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
+extern int sysctl_compact_node;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int latencytop_enabled;
@@ -1109,6 +1111,15 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= drop_caches_sysctl_handler,
 	},
+#ifdef CONFIG_MIGRATION
+	{
+		.procname	= "compact_node",
+		.data		= &sysctl_compact_node,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_compaction_handler,
+	},
+#endif /* CONFIG_MIGRATION */
 	{
 		.procname	= "min_free_kbytes",
 		.data		= &min_free_kbytes,
diff --git a/mm/compaction.c b/mm/compaction.c
index d36760a..a8bcae2 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -11,6 +11,7 @@
 #include <linux/migrate.h>
 #include <linux/compaction.h>
 #include <linux/mm_inline.h>
+#include <linux/sysctl.h>
 #include "internal.h"
 
 /*
@@ -338,3 +339,54 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	return ret;
 }
 
+/* Compact all zones within a node */
+int compact_node(int nid)
+{
+	int zoneid;
+	pg_data_t *pgdat;
+	struct zone *zone;
+
+	if (nid < 0 || nid > nr_node_ids || !node_online(nid))
+		return -EINVAL;
+	pgdat = NODE_DATA(nid);
+
+	/* Flush pending updates to the LRU lists */
+	lru_add_drain_all();
+
+	printk(KERN_INFO "Compacting memory in node %d\n", nid);
+	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
+		struct compact_control cc;
+
+		zone = &pgdat->node_zones[zoneid];
+		if (!populated_zone(zone))
+			continue;
+
+		cc.nr_freepages = 0;
+		cc.nr_migratepages = 0;
+		cc.zone = zone;
+		INIT_LIST_HEAD(&cc.freepages);
+		INIT_LIST_HEAD(&cc.migratepages);
+
+		compact_zone(zone, &cc);
+
+		VM_BUG_ON(!list_empty(&cc.freepages));
+		VM_BUG_ON(!list_empty(&cc.migratepages));
+	}
+	printk(KERN_INFO "Compaction of node %d complete\n", nid);
+
+	return 0;
+}
+
+/* This is global and fierce ugly but it's straight-forward */
+int sysctl_compact_node;
+
+/* This is the entry point for compacting nodes via /proc/sys/vm */
+int sysctl_compaction_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos)
+{
+	proc_dointvec(table, write, buffer, length, ppos);
+	if (write)
+		return compact_node(sysctl_compact_node);
+
+	return 0;
+}
-- 
1.6.5

