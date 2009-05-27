Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbZE0LQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbZE0LQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760680AbZE0LMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49463 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759648AbZE0LMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:33 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:06:14 +0300
Message-Id: <20090527130614.4913.16932.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/19] NILFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:12:16.0791 (UTC) FILETIME=[FE909A70:01C9DEBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] NILFS: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/nilfs2/segment.c   |    2 +-
 fs/nilfs2/super.c     |   18 +++++++++---------
 fs/nilfs2/the_nilfs.c |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index fb70ec3..0dcac79 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2069,7 +2069,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	if (update_sr) {
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
-		sbi->s_super->s_dirt = 1;
+		mark_sb_dirty(sbi->s_super);
 
 		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7262e84..6f3707b 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -307,7 +307,7 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 		nilfs->ns_sbwtime[1] = t;
 	}
-	sbi->s_super->s_dirt = 0;
+	mark_sb_clean(sbi->s_super);
 	return nilfs_sync_super(sbi, dupsb);
 }
 
@@ -318,7 +318,7 @@ static void nilfs_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		nilfs_write_super(sb);
 
 	nilfs_detach_segment_constructor(sbi);
@@ -344,17 +344,17 @@ static void nilfs_put_super(struct super_block *sb)
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
@@ -383,7 +383,7 @@ static void nilfs_write_super(struct super_block *sb)
 		dupsb = sbp[1] && t > nilfs->ns_sbwtime[1] + NILFS_ALTSB_FREQ;
 		nilfs_commit_super(sbi, dupsb);
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	up_write(&nilfs->ns_sem);
 }
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7f65b3b..5b02f50 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -278,7 +278,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 			goto failed;
 		}
 		if (ri.ri_need_recovery == NILFS_RECOVERY_SR_UPDATED)
-			sbi->s_super->s_dirt = 1;
+			mark_sb_dirty(sbi->s_super);
 	}
 
 	set_nilfs_loaded(nilfs);
-- 
1.6.0.6

