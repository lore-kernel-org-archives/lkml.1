Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbZDJFfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbZDJFfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762010AbZDJFdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:33:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:58967 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759165AbZDJFdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:33:16 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 8/8] nilfs2: fix possible mismatch of sufile counters on recovery
Date: Fri, 10 Apr 2009 14:28:01 +0900
Message-Id: <1239341281-20249-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 14:33:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On-disk counters ndirtysegs and ncleansegs of sufile, can go wrong
after roll-forward recovery because
nilfs_prepare_segment_for_recovery() function marks segments dirty
without adjusting value of these counters.

This fixes the problem by adding a function to sufile which does the
operation adjusting the counters, and by letting the recovery function
use it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/recovery.c |   20 ++++----------------
 fs/nilfs2/sufile.c   |   29 +++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h   |   12 ++++++++++++
 3 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 6ade096..4fc081e 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -413,7 +413,6 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 	struct nilfs_segment_entry *ent, *n;
 	struct inode *sufile = nilfs->ns_sufile;
 	__u64 segnum[4];
-	time_t mtime;
 	int err;
 	int i;
 
@@ -442,24 +441,13 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 	 * Collecting segments written after the latest super root.
 	 * These are marked dirty to avoid being reallocated in the next write.
 	 */
-	mtime = get_seconds();
 	list_for_each_entry_safe(ent, n, head, list) {
-		if (ent->segnum == segnum[0]) {
-			list_del(&ent->list);
-			nilfs_free_segment_entry(ent);
-			continue;
-		}
-		err = nilfs_open_segment_entry(ent, sufile);
-		if (unlikely(err))
-			goto failed;
-		if (!nilfs_segment_usage_dirty(ent->raw_su)) {
-			/* make the segment garbage */
-			ent->raw_su->su_nblocks = cpu_to_le32(0);
-			ent->raw_su->su_lastmod = cpu_to_le32(mtime);
-			nilfs_segment_usage_set_dirty(ent->raw_su);
+		if (ent->segnum != segnum[0]) {
+			err = nilfs_sufile_scrap(sufile, ent->segnum);
+			if (unlikely(err))
+				goto failed;
 		}
 		list_del(&ent->list);
-		nilfs_close_segment_entry(ent, sufile);
 		nilfs_free_segment_entry(ent);
 	}
 
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 07013f5..98e6867 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -258,6 +258,35 @@ void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 segnum,
 	nilfs_mdt_mark_dirty(sufile);
 }
 
+void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
+			   struct buffer_head *header_bh,
+			   struct buffer_head *su_bh)
+{
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	int clean, dirty;
+
+	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
+	if (su->su_flags == cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY) &&
+	    su->su_nblocks == cpu_to_le32(0)) {
+		kunmap_atomic(kaddr, KM_USER0);
+		return;
+	}
+	clean = nilfs_segment_usage_clean(su);
+	dirty = nilfs_segment_usage_dirty(su);
+
+	/* make the segment garbage */
+	su->su_lastmod = cpu_to_le64(0);
+	su->su_nblocks = cpu_to_le32(0);
+	su->su_flags = cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nilfs_sufile_mod_counter(header_bh, clean ? (u64)-1 : 0, dirty ? 0 : 1);
+	nilfs_mdt_mark_buffer_dirty(su_bh);
+	nilfs_mdt_mark_dirty(sufile);
+}
+
 void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 			  struct buffer_head *header_bh,
 			  struct buffer_head *su_bh)
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 449a6e2..a2e2efd 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -52,6 +52,8 @@ int nilfs_sufile_update(struct inode *, __u64, int,
 				       struct buffer_head *));
 void nilfs_sufile_do_cancel_free(struct inode *, __u64, struct buffer_head *,
 				 struct buffer_head *);
+void nilfs_sufile_do_scrap(struct inode *, __u64, struct buffer_head *,
+			   struct buffer_head *);
 void nilfs_sufile_do_free(struct inode *, __u64, struct buffer_head *,
 			  struct buffer_head *);
 void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
@@ -78,6 +80,16 @@ static inline int nilfs_sufile_cancel_free(struct inode *sufile, __u64 segnum)
 }
 
 /**
+ * nilfs_sufile_scrap - make a segment garbage
+ * @sufile: inode of segment usage file
+ * @segnum: segment number to be freed
+ */
+static inline int nilfs_sufile_scrap(struct inode *sufile, __u64 segnum)
+{
+	return nilfs_sufile_update(sufile, segnum, 1, nilfs_sufile_do_scrap);
+}
+
+/**
  * nilfs_sufile_free - free segment
  * @sufile: inode of segment usage file
  * @segnum: segment number to be freed
-- 
1.5.6.5

