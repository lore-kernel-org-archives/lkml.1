Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbZJTFWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbZJTFWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZJTFWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:22:31 -0400
Received: from thunk.org ([69.25.196.29]:45842 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZJTFWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:22:30 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext2: Avoid WARN() messages when failing to write to the superblock
Date: Tue, 20 Oct 2009 01:22:26 -0400
Message-Id: <1256016146-2677-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.5.104.g2567b.dirty
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a common warning reported by kerneloops.org

[Kernel summit hacking hour]
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext2/super.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1a9ffee..7b3b6cd 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1089,9 +1089,30 @@ failed_sbi:
 	return ret;
 }
 
+static void ext2_clear_super_error(struct super_block * sb)
+{
+	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
+
+	if (buffer_write_io_error(sbh)) {
+		/*
+		 * Oh, dear.  A previous attempt to write the
+		 * superblock failed.  This could happen because the
+		 * USB device was yanked out.  Or it could happen to
+		 * be a transient write error and maybe the block will
+		 * be remapped.  Nothing we can do but to retry the
+		 * write and hope for the best.
+		 */
+		printk(KERN_ERR "EXT2-fs: %s previous I/O error to "
+		       "superblock detected", sb->s_id);
+		clear_buffer_write_io_error(sbh);
+		set_buffer_uptodate(sbh);
+	}
+}
+
 static void ext2_commit_super (struct super_block * sb,
 			       struct ext2_super_block * es)
 {
+	ext2_clear_super_error(sb);
 	es->s_wtime = cpu_to_le32(get_seconds());
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	sb->s_dirt = 0;
@@ -1099,6 +1120,7 @@ static void ext2_commit_super (struct super_block * sb,
 
 static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
 {
+	ext2_clear_super_error(sb);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 	es->s_wtime = cpu_to_le32(get_seconds());
-- 
1.6.5.104.g2567b.dirty

