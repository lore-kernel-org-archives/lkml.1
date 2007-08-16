Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbXHPImV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbXHPImV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759999AbXHPI32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:29:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759474AbXHPI3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:29:04 -0400
Message-Id: <20070816074624.963595000@chello.nl>
References: <20070816074525.065850000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 09:45:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 02/23] lib: percpu_counter_add
Content-Disposition: inline; filename=percpu_counter_add.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 s/percpu_counter_mod/percpu_counter_add/

Because its a better name, _mod implies modulo.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/ext2/balloc.c               |    6 +++---
 fs/ext2/ialloc.c               |    2 +-
 fs/ext3/balloc.c               |    4 ++--
 fs/ext3/resize.c               |    4 ++--
 fs/ext4/balloc.c               |    4 ++--
 fs/ext4/resize.c               |    4 ++--
 include/linux/percpu_counter.h |    8 ++++----
 lib/percpu_counter.c           |    4 ++--
 8 files changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6/fs/ext2/balloc.c
===================================================================
--- linux-2.6.orig/fs/ext2/balloc.c
+++ linux-2.6/fs/ext2/balloc.c
@@ -163,7 +163,7 @@ static int reserve_blocks(struct super_b
 			return 0;
 	}
 
-	percpu_counter_mod(&sbi->s_freeblocks_counter, -count);
+	percpu_counter_add(&sbi->s_freeblocks_counter, -count);
 	sb->s_dirt = 1;
 	return count;
 }
@@ -173,7 +173,7 @@ static void release_blocks(struct super_
 	if (count) {
 		struct ext2_sb_info *sbi = EXT2_SB(sb);
 
-		percpu_counter_mod(&sbi->s_freeblocks_counter, count);
+		percpu_counter_add(&sbi->s_freeblocks_counter, count);
 		sb->s_dirt = 1;
 	}
 }
@@ -1402,7 +1402,7 @@ allocated:
 	}
 
 	group_adjust_blocks(sb, group_no, gdp, gdp_bh, -num);
-	percpu_counter_mod(&sbi->s_freeblocks_counter, -num);
+	percpu_counter_add(&sbi->s_freeblocks_counter, -num);
 
 	mark_buffer_dirty(bitmap_bh);
 	if (sb->s_flags & MS_SYNCHRONOUS)
Index: linux-2.6/fs/ext2/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext2/ialloc.c
+++ linux-2.6/fs/ext2/ialloc.c
@@ -534,7 +534,7 @@ got:
 		goto fail;
 	}
 
-	percpu_counter_mod(&sbi->s_freeinodes_counter, -1);
+	percpu_counter_add(&sbi->s_freeinodes_counter, -1);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
 
Index: linux-2.6/fs/ext3/balloc.c
===================================================================
--- linux-2.6.orig/fs/ext3/balloc.c
+++ linux-2.6/fs/ext3/balloc.c
@@ -609,7 +609,7 @@ do_more:
 		cpu_to_le16(le16_to_cpu(desc->bg_free_blocks_count) +
 			group_freed);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
-	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
+	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
@@ -1672,7 +1672,7 @@ allocated:
 	gdp->bg_free_blocks_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_mod(&sbi->s_freeblocks_counter, -num);
+	percpu_counter_add(&sbi->s_freeblocks_counter, -num);
 
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext3_journal_dirty_metadata(handle, gdp_bh);
Index: linux-2.6/fs/ext3/resize.c
===================================================================
--- linux-2.6.orig/fs/ext3/resize.c
+++ linux-2.6/fs/ext3/resize.c
@@ -884,9 +884,9 @@ int ext3_group_add(struct super_block *s
 		input->reserved_blocks);
 
 	/* Update the free space counts */
-	percpu_counter_mod(&sbi->s_freeblocks_counter,
+	percpu_counter_add(&sbi->s_freeblocks_counter,
 			   input->free_blocks_count);
-	percpu_counter_mod(&sbi->s_freeinodes_counter,
+	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT3_INODES_PER_GROUP(sb));
 
 	ext3_journal_dirty_metadata(handle, sbi->s_sbh);
Index: linux-2.6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/balloc.c
+++ linux-2.6/fs/ext4/balloc.c
@@ -628,7 +628,7 @@ do_more:
 		cpu_to_le16(le16_to_cpu(desc->bg_free_blocks_count) +
 			group_freed);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
-	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
+	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
@@ -1697,7 +1697,7 @@ allocated:
 	gdp->bg_free_blocks_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_mod(&sbi->s_freeblocks_counter, -num);
+	percpu_counter_add(&sbi->s_freeblocks_counter, -num);
 
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext4_journal_dirty_metadata(handle, gdp_bh);
Index: linux-2.6/fs/ext4/resize.c
===================================================================
--- linux-2.6.orig/fs/ext4/resize.c
+++ linux-2.6/fs/ext4/resize.c
@@ -893,9 +893,9 @@ int ext4_group_add(struct super_block *s
 		input->reserved_blocks);
 
 	/* Update the free space counts */
-	percpu_counter_mod(&sbi->s_freeblocks_counter,
+	percpu_counter_add(&sbi->s_freeblocks_counter,
 			   input->free_blocks_count);
-	percpu_counter_mod(&sbi->s_freeinodes_counter,
+	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
 	ext4_journal_dirty_metadata(handle, sbi->s_sbh);
Index: linux-2.6/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.orig/include/linux/percpu_counter.h
+++ linux-2.6/include/linux/percpu_counter.h
@@ -32,7 +32,7 @@ struct percpu_counter {
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
-void percpu_counter_mod(struct percpu_counter *fbc, s32 amount);
+void percpu_counter_add(struct percpu_counter *fbc, s32 amount);
 s64 percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
@@ -71,7 +71,7 @@ static inline void percpu_counter_destro
 }
 
 static inline void
-percpu_counter_mod(struct percpu_counter *fbc, s32 amount)
+percpu_counter_add(struct percpu_counter *fbc, s32 amount)
 {
 	preempt_disable();
 	fbc->count += amount;
@@ -97,12 +97,12 @@ static inline s64 percpu_counter_sum(str
 
 static inline void percpu_counter_inc(struct percpu_counter *fbc)
 {
-	percpu_counter_mod(fbc, 1);
+	percpu_counter_add(fbc, 1);
 }
 
 static inline void percpu_counter_dec(struct percpu_counter *fbc)
 {
-	percpu_counter_mod(fbc, -1);
+	percpu_counter_add(fbc, -1);
 }
 
 #endif /* _LINUX_PERCPU_COUNTER_H */
Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c
+++ linux-2.6/lib/percpu_counter.c
@@ -14,7 +14,7 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 #endif
 
-void percpu_counter_mod(struct percpu_counter *fbc, s32 amount)
+void percpu_counter_add(struct percpu_counter *fbc, s32 amount)
 {
 	long count;
 	s32 *pcount;
@@ -32,7 +32,7 @@ void percpu_counter_mod(struct percpu_co
 	}
 	put_cpu();
 }
-EXPORT_SYMBOL(percpu_counter_mod);
+EXPORT_SYMBOL(percpu_counter_add);
 
 /*
  * Add up all the per-cpu counts, return the result.  This is a more accurate

--

