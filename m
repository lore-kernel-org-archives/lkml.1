Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYJQMoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYJQMoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYJQMoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:44:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:22421 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbYJQMoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=l7U5RjxNDSzVBHhWFkb/88moWo+vORIjPzM0Xhs9LHGXVSI6tRkOPeTMfWR8kW5xB/
         Ee3R11MJXGHavtmWYQtixGcN2AqEWBu1A66pnzWYy9TGRt2dpwipl0SOOZuJT9FKLJOr
         1dGXcow5cgz5Q0RdKB+9YcgcET+PDn3Ixa3qY=
Date: Fri, 17 Oct 2008 16:47:11 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com
Subject: [PATCH 15/31] proc: move rest of /proc/partitions code to
	block/genhd.c
Message-ID: <20081017124711.GP22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From de5824cba6d479dc525cb24810582e3606e3d166 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 4 Oct 2008 23:53:21 +0400
Subject: [PATCH 15/31] proc: move rest of /proc/partitions code to block/genhd.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 block/genhd.c         |   22 +++++++++++++++++++++-
 fs/proc/proc_misc.c   |   14 --------------
 include/linux/genhd.h |    1 -
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 4cd3433..7a7f823 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -10,6 +10,7 @@
 #include <linux/blkdev.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/kmod.h>
@@ -728,12 +729,24 @@ static int show_partition(struct seq_file *seqf, void *v)
 	return 0;
 }
 
-const struct seq_operations partitions_op = {
+static const struct seq_operations partitions_op = {
 	.start	= show_partition_start,
 	.next	= disk_seqf_next,
 	.stop	= disk_seqf_stop,
 	.show	= show_partition
 };
+
+static int partitions_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &partitions_op);
+}
+
+static const struct file_operations proc_partitions_operations = {
+	.open		= partitions_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 #endif
 
 
@@ -999,6 +1012,13 @@ const struct seq_operations diskstats_op = {
 	.stop	= disk_seqf_stop,
 	.show	= diskstats_show
 };
+
+static int __init proc_genhd_init(void)
+{
+	proc_create("partitions", 0, NULL, &proc_partitions_operations);
+	return 0;
+}
+module_init(proc_genhd_init);
 #endif /* CONFIG_PROC_FS */
 
 static void media_change_notify_thread(struct work_struct *work)
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 916ed4d..24c4f8d 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -105,17 +105,6 @@ static const struct file_operations proc_vmstat_file_operations = {
 };
 
 #ifdef CONFIG_BLOCK
-static int partitions_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &partitions_op);
-}
-static const struct file_operations proc_partitions_operations = {
-	.open		= partitions_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int diskstats_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &diskstats_op);
@@ -521,9 +510,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-#ifdef CONFIG_BLOCK
-	proc_create("partitions", 0, NULL, &proc_partitions_operations);
-#endif
 	proc_create("stat", 0, NULL, &proc_stat_operations);
 	proc_create("interrupts", 0, NULL, &proc_interrupts_operations);
 #ifdef CONFIG_SLABINFO
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 206cdf9..074a4fd 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -25,7 +25,6 @@ extern struct device_type part_type;
 extern struct kobject *block_depr;
 extern struct class block_class;
 
-extern const struct seq_operations partitions_op;
 extern const struct seq_operations diskstats_op;
 
 enum {
-- 
1.5.6.5

