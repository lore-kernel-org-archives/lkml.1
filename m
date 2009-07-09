Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbZGIHBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbZGIHBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759811AbZGIG7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:59:31 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40080 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759798AbZGIG73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:59:29 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:49:39 +0300
Message-Id: <20090709084939.12122.64791.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 11/18] NILFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 09 Jul 2009 06:59:08.0528 (UTC) FILETIME=[C16AD700:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/segment.c   |    2 +-
 fs/nilfs2/super.c     |   18 +++++++++---------
 fs/nilfs2/the_nilfs.c |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index aa97754..f857eaa 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2052,7 +2052,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	if (update_sr) {
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
-		sbi->s_super->s_dirt = 1;
+		mark_sb_dirty(sbi->s_super);
 
 		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8e2ec43..4eb2576 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -300,7 +300,7 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 		nilfs->ns_sbwtime[1] = t;
 	}
-	sbi->s_super->s_dirt = 0;
+	mark_sb_clean(sbi->s_super);
 	return nilfs_sync_super(sbi, dupsb);
 }
 
@@ -311,7 +311,7 @@ static void nilfs_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		nilfs_write_super(sb);
 
 	nilfs_detach_segment_constructor(sbi);
@@ -341,17 +341,17 @@ static void nilfs_put_super(struct super_block *sb)
  * @sb: super_block
  *
  * nilfs_write_super() gets a fs-dependent lock, writes super block(s), and
- * clears s_dirt.  This function is called in the section protected by
- * lock_super().
+ * clears the superblock.  This function is called in the section protected
+ * by lock_super().
  *
- * The s_dirt flag is managed by each filesystem and we protect it by ns_sem
- * of the struct the_nilfs.  Lock order must be as follows:
+ * The super block s_dirt flag is managed by each filesystem and we protect
+ * it by ns_sem of the struct the_nilfs.  Lock order must be as follows:
  *
  *   1. lock_super()
  *   2.    down_write(&nilfs->ns_sem)
  *
- * Inside NILFS, locking ns_sem is enough to protect s_dirt and the buffer
- * of the super block (nilfs->ns_sbp[]).
+ * Inside NILFS, locking ns_sem is enough to protect the super block s_dirt
+ * and the buffer of the super block (nilfs->ns_sbp[]).
  *
  * In most cases, VFS functions call lock_super() before calling these
  * methods.  So we must be careful not to bring on deadlocks when using
@@ -380,7 +380,7 @@ static void nilfs_write_super(struct super_block *sb)
 		dupsb = sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
 		nilfs_commit_super(sbi, dupsb);
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	up_write(&nilfs->ns_sem);
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 8b88898..a275939 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -330,7 +330,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 			goto failed;
 		}
 		if (ri.ri_need_recovery == NILFS_RECOVERY_SR_UPDATED)
-			sbi->s_super->s_dirt = 1;
+			mark_sb_dirty(sbi->s_super);
 	}
 
 	set_nilfs_loaded(nilfs);
-- 
1.6.0.6

