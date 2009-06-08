Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZFHTY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZFHTY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbZFHTXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:19 -0400
Received: from thunk.org ([69.25.196.29]:39531 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbZFHTXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 04/49] ext4: Fallback to vmalloc if kmalloc can't allocate s_flex_groups array
Date: Mon,  8 Jun 2009 15:22:22 -0400
Message-Id: <1244488987-32564-5-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-4-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For very large filesystems, the s_flex_groups array can get quite big.
For example, a filesystem that can be resized up to 16TB will have
8192 flex groups (assuming the default flex_bg size of 16), so the
array is 96k, which is *very* marginal for kmalloc().  On the other
hand, a 160GB filesystem without the resize_inode feature will only
require 960 bytes.  So we try to allocate the array first using
kmalloc(), and if that fails, we'll try to use vmalloc() instead.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2958f4e..3f4475d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/time.h>
+#include <linux/vmalloc.h>
 #include <linux/jbd2.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -586,7 +587,10 @@ static void ext4_put_super(struct super_block *sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kfree(sbi->s_group_desc);
-	kfree(sbi->s_flex_groups);
+	if (is_vmalloc_addr(sbi->s_flex_groups))
+		vfree(sbi->s_flex_groups);
+	else
+		kfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -1620,6 +1624,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	ext4_group_t flex_group_count;
 	ext4_group_t flex_group;
 	int groups_per_flex = 0;
+	size_t size;
 	int i;
 
 	if (!sbi->s_es->s_log_groups_per_flex) {
@@ -1634,8 +1639,13 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
 			((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
 			      EXT4_DESC_PER_BLOCK_BITS(sb))) / groups_per_flex;
-	sbi->s_flex_groups = kzalloc(flex_group_count *
-				     sizeof(struct flex_groups), GFP_KERNEL);
+	size = flex_group_count * sizeof(struct flex_groups);
+	sbi->s_flex_groups = kzalloc(size, GFP_KERNEL);
+	if (sbi->s_flex_groups == NULL) {
+		sbi->s_flex_groups = vmalloc(size);
+		if (sbi->s_flex_groups)
+			memset(sbi->s_flex_groups, 0, size);
+	}
 	if (sbi->s_flex_groups == NULL) {
 		printk(KERN_ERR "EXT4-fs: not enough memory for "
 				"%u flex groups\n", flex_group_count);
@@ -2842,6 +2852,12 @@ failed_mount4:
 		sbi->s_journal = NULL;
 	}
 failed_mount3:
+	if (sbi->s_flex_groups) {
+		if (is_vmalloc_addr(sbi->s_flex_groups))
+			vfree(sbi->s_flex_groups);
+		else
+			kfree(sbi->s_flex_groups);
+	}
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
-- 
1.6.3.2.1.gb9f7d.dirty

