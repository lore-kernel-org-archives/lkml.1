Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbYJQMuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbYJQMuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbYJQMst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:48:49 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:33905 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbYJQMsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:48:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XLkxTVjG7IcmG+nAOdXeYfL/kndaCHmz8zoSqu/mUZxmq5182B9yfAhga/6GuVzDIC
         fL2CQ4E5LFbV5RdsjC4NiTsh3bSxR+skNCrObEW1mQTfvxnnUOzaD80FaMd71U+7w1sy
         LjlAXH/7dpt3SiECwdxCA08vz8We/l+yYz/rc=
Date: Fri, 17 Oct 2008 16:51:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com
Subject: [PATCH 25/31] proc: move /proc/diskstats boilerplate to
	block/genhd.c
Message-ID: <20081017125147.GZ22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 1c533e5be2858e5c494cd98dbcb4263d0803a1ae Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 12:55:38 +0400
Subject: [PATCH 25/31] proc: move /proc/diskstats boilerplate to block/genhd.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 block/genhd.c         |   15 ++++++++++++++-
 fs/proc/proc_misc.c   |   16 ----------------
 include/linux/genhd.h |    2 --
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7a7f823..4e8a737 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1006,15 +1006,28 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	return 0;
 }
 
-const struct seq_operations diskstats_op = {
+static const struct seq_operations diskstats_op = {
 	.start	= disk_seqf_start,
 	.next	= disk_seqf_next,
 	.stop	= disk_seqf_stop,
 	.show	= diskstats_show
 };
 
+static int diskstats_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &diskstats_op);
+}
+
+static const struct file_operations proc_diskstats_operations = {
+	.open		= diskstats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int __init proc_genhd_init(void)
 {
+	proc_create("diskstats", 0, NULL, &proc_diskstats_operations);
 	proc_create("partitions", 0, NULL, &proc_partitions_operations);
 	return 0;
 }
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 5ec0119..67b02ee 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -56,19 +56,6 @@
 #include <asm/div64.h>
 #include "internal.h"
 
-#ifdef CONFIG_BLOCK
-static int diskstats_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &diskstats_op);
-}
-static const struct file_operations proc_diskstats_operations = {
-	.open		= diskstats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-#endif
-
 #ifdef CONFIG_MODULES
 extern const struct seq_operations modules_op;
 static int modules_open(struct inode *inode, struct file *file)
@@ -221,9 +208,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-#ifdef CONFIG_BLOCK
-	proc_create("diskstats", 0, NULL, &proc_diskstats_operations);
-#endif
 #ifdef CONFIG_MODULES
 	proc_create("modules", 0, NULL, &proc_modules_operations);
 #endif
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 074a4fd..e439e6a 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -25,8 +25,6 @@ extern struct device_type part_type;
 extern struct kobject *block_depr;
 extern struct class block_class;
 
-extern const struct seq_operations diskstats_op;
-
 enum {
 /* These three have identical behaviour; use the second one if DOS FDISK gets
    confused about extended/logical partitions starting past cylinder 1023. */
-- 
1.5.6.5

