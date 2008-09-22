Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYIVK7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYIVK7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYIVK6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:58:09 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50001 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYIVK6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:58:00 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATHC 2/10] ext3: Fix error handling in write_super_lockfs/unlockfs
Message-Id: <20080922195548t-sato@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:1K0086
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 22 Sep 2008 19:55:48 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've changed write_super_lockfs/unlockfs so that they return an error
in case of an I/O failure.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 super.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-xfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-xfs/fs/ext3/super.c linux-2.6.2
7-rc7-lockfs-ext3/fs/ext3/super.c
--- linux-2.6.27-rc7-lockfs-xfs/fs/ext3/super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-ext3/fs/ext3/super.c	2008-09-22 10:31:56.000000000 +0900
@@ -48,8 +48,8 @@ static int ext3_load_journal(struct supe
 			     unsigned long journal_devnum);
 static int ext3_create_journal(struct super_block *, struct ext3_super_block *,
 			       unsigned int);
-static void ext3_commit_super (struct super_block * sb,
-			       struct ext3_super_block * es,
+static int ext3_commit_super(struct super_block *sb,
+			       struct ext3_super_block *es,
 			       int sync);
 static void ext3_mark_recovery_complete(struct super_block * sb,
 					struct ext3_super_block * es);
@@ -60,9 +60,9 @@ static const char *ext3_decode_error(str
 				     char nbuf[16]);
 static int ext3_remount (struct super_block * sb, int * flags, char * data);
 static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf);
-static void ext3_unlockfs(struct super_block *sb);
+static int ext3_unlockfs(struct super_block *sb);
 static void ext3_write_super (struct super_block * sb);
-static void ext3_write_super_lockfs(struct super_block *sb);
+static int ext3_write_super_lockfs(struct super_block *sb);
 
 /*
  * Wrappers for journal_start/end.
@@ -2251,21 +2251,23 @@ static int ext3_create_journal(struct su
 	return 0;
 }
 
-static void ext3_commit_super (struct super_block * sb,
-			       struct ext3_super_block * es,
+static int ext3_commit_super(struct super_block *sb,
+			       struct ext3_super_block *es,
 			       int sync)
 {
 	struct buffer_head *sbh = EXT3_SB(sb)->s_sbh;
+	int error = 0;
 
 	if (!sbh)
-		return;
+		return error;
 	es->s_wtime = cpu_to_le32(get_seconds());
 	es->s_free_blocks_count = cpu_to_le32(ext3_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext3_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync)
-		sync_dirty_buffer(sbh);
+		error = sync_dirty_buffer(sbh);
+	return error;
 }
 
 
@@ -2379,37 +2381,50 @@ static int ext3_sync_fs(struct super_blo
  * LVM calls this function before a (read-only) snapshot is created.  This
  * gives us a chance to flush the journal completely and mark the fs clean.
  */
-static void ext3_write_super_lockfs(struct super_block *sb)
+static int ext3_write_super_lockfs(struct super_block *sb)
 {
+	int error = 0;
+	journal_t *journal;
 	sb->s_dirt = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		journal_t *journal = EXT3_SB(sb)->s_journal;
+		journal = EXT3_SB(sb)->s_journal;
 
 		/* Now we set up the journal barrier. */
 		journal_lock_updates(journal);
-		journal_flush(journal);
+		error = journal_flush(journal);
+		if (error)
+			goto out;
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
-		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
+		error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
+		if (error)
+			goto out;
 	}
+	return 0;
+
+out:
+	journal_unlock_updates(journal);
+	return error;
 }
 
 /*
  * Called by LVM after the snapshot is done.  We need to reset the RECOVER
  * flag here, even though the filesystem is not technically dirty yet.
  */
-static void ext3_unlockfs(struct super_block *sb)
+static int ext3_unlockfs(struct super_block *sb)
 {
+	int error = 0;
 	if (!(sb->s_flags & MS_RDONLY)) {
 		lock_super(sb);
 		/* Reser the needs_recovery flag before the fs is unlocked. */
 		EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
-		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
+		error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
 		unlock_super(sb);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 	}
+	return error;
 }
 
 static int ext3_remount (struct super_block * sb, int * flags, char * data)
