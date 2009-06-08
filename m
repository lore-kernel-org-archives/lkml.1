Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZFHT1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZFHT1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZFHTXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:30 -0400
Received: from thunk.org ([69.25.196.29]:39544 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbZFHTXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 42/49] ext4: Clean up calls to ext4_get_group_desc()
Date: Mon,  8 Jun 2009 15:23:00 -0400
Message-Id: <1244488987-32564-43-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-42-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
 <1244488987-32564-29-git-send-email-tytso@mit.edu>
 <1244488987-32564-30-git-send-email-tytso@mit.edu>
 <1244488987-32564-31-git-send-email-tytso@mit.edu>
 <1244488987-32564-32-git-send-email-tytso@mit.edu>
 <1244488987-32564-33-git-send-email-tytso@mit.edu>
 <1244488987-32564-34-git-send-email-tytso@mit.edu>
 <1244488987-32564-35-git-send-email-tytso@mit.edu>
 <1244488987-32564-36-git-send-email-tytso@mit.edu>
 <1244488987-32564-37-git-send-email-tytso@mit.edu>
 <1244488987-32564-38-git-send-email-tytso@mit.edu>
 <1244488987-32564-39-git-send-email-tytso@mit.edu>
 <1244488987-32564-40-git-send-email-tytso@mit.edu>
 <1244488987-32564-41-git-send-email-tytso@mit.edu>
 <1244488987-32564-42-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the caller isn't planning on modifying the block group descriptors,
there's no need to pass in a pointer to a struct buffer_head.  Nuking
this saves a tiny amount of CPU time and stack space usage.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ialloc.c |    3 +--
 fs/ext4/super.c  |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 82f7d1d..3743bd8 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -347,7 +347,6 @@ static int find_group_flex(struct super_block *sb, struct inode *parent,
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_desc *desc;
-	struct buffer_head *bh;
 	struct flex_groups *flex_group = sbi->s_flex_groups;
 	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
 	ext4_group_t parent_fbg_group = ext4_flex_group(sbi, parent_group);
@@ -402,7 +401,7 @@ find_close_to_parent:
 found_flexbg:
 	for (i = best_flex * flex_size; i < ngroups &&
 		     i < (best_flex + 1) * flex_size; i++) {
-		desc = ext4_get_group_desc(sb, i, &bh);
+		desc = ext4_get_group_desc(sb, i, NULL);
 		if (ext4_free_inodes_count(sb, desc)) {
 			*best_group = i;
 			goto out;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eca6c05..91b98b5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1660,7 +1660,6 @@ static int ext4_fill_flex_info(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_desc *gdp = NULL;
-	struct buffer_head *bh;
 	ext4_group_t flex_group_count;
 	ext4_group_t flex_group;
 	int groups_per_flex = 0;
@@ -1693,7 +1692,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	}
 
 	for (i = 0; i < sbi->s_groups_count; i++) {
-		gdp = ext4_get_group_desc(sb, i, &bh);
+		gdp = ext4_get_group_desc(sb, i, NULL);
 
 		flex_group = ext4_flex_group(sbi, i);
 		atomic_set(&sbi->s_flex_groups[flex_group].free_inodes,
-- 
1.6.3.2.1.gb9f7d.dirty

