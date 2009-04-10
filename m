Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbZDJFgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbZDJFgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbZDJFd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:33:27 -0400
Received: from sh.osrg.net ([192.16.179.4]:58976 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760974AbZDJFdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:33:19 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 7/8] nilfs2: segment usage file cleanups
Date: Fri, 10 Apr 2009 14:28:00 +0900
Message-Id: <1239341281-20249-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 14:33:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will simplify sufile.c by sharing common code which repeatedly
appears in routines updating a segment usage entry; a wrapper function
nilfs_sufile_update() is introduced for the purpose, and counter
modifications are integrated to a new function
nilfs_sufile_mod_counter().

This is a preparation for the successive bugfix patch ("nilfs2: fix
possible mismatch of sufile counters on recovery").

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/sufile.c |  268 +++++++++++++++-------------------------------------
 fs/nilfs2/sufile.h |   67 ++++++++++++-
 2 files changed, 140 insertions(+), 195 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 8b2f93c..07013f5 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -93,6 +93,52 @@ nilfs_sufile_get_segment_usage_block(struct inode *sufile, __u64 segnum,
 				   create, NULL, bhp);
 }
 
+static void nilfs_sufile_mod_counter(struct buffer_head *header_bh,
+				     u64 ncleanadd, u64 ndirtyadd)
+{
+	struct nilfs_sufile_header *header;
+	void *kaddr;
+
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = kaddr + bh_offset(header_bh);
+	le64_add_cpu(&header->sh_ncleansegs, ncleanadd);
+	le64_add_cpu(&header->sh_ndirtysegs, ndirtyadd);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nilfs_mdt_mark_buffer_dirty(header_bh);
+}
+
+int nilfs_sufile_update(struct inode *sufile, __u64 segnum, int create,
+			void (*dofunc)(struct inode *, __u64,
+				       struct buffer_head *,
+				       struct buffer_head *))
+{
+	struct buffer_head *header_bh, *bh;
+	int ret;
+
+	if (unlikely(segnum >= nilfs_sufile_get_nsegments(sufile))) {
+		printk(KERN_WARNING "%s: invalid segment number: %llu\n",
+		       __func__, (unsigned long long)segnum);
+		return -EINVAL;
+	}
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (ret < 0)
+		goto out_sem;
+
+	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, create, &bh);
+	if (!ret) {
+		dofunc(sufile, segnum, header_bh, bh);
+		brelse(bh);
+	}
+	brelse(header_bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
 /**
  * nilfs_sufile_alloc - allocate a segment
  * @sufile: inode of segment usage file
@@ -113,7 +159,6 @@ nilfs_sufile_get_segment_usage_block(struct inode *sufile, __u64 segnum,
 int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 {
 	struct buffer_head *header_bh, *su_bh;
-	struct the_nilfs *nilfs;
 	struct nilfs_sufile_header *header;
 	struct nilfs_segment_usage *su;
 	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
@@ -124,8 +169,6 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 
-	nilfs = NILFS_MDT(sufile)->mi_nilfs;
-
 	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
 	if (ret < 0)
 		goto out_sem;
@@ -192,165 +235,55 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 	return ret;
 }
 
-/**
- * nilfs_sufile_cancel_free -
- * @sufile: inode of segment usage file
- * @segnum: segment number
- *
- * Description:
- *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- */
-int nilfs_sufile_cancel_free(struct inode *sufile, __u64 segnum)
+void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 segnum,
+				 struct buffer_head *header_bh,
+				 struct buffer_head *su_bh)
 {
-	struct buffer_head *header_bh, *su_bh;
-	struct the_nilfs *nilfs;
-	struct nilfs_sufile_header *header;
 	struct nilfs_segment_usage *su;
 	void *kaddr;
-	int ret;
-
-	down_write(&NILFS_MDT(sufile)->mi_sem);
-
-	nilfs = NILFS_MDT(sufile)->mi_nilfs;
-
-	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
-	if (ret < 0)
-		goto out_sem;
-
-	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &su_bh);
-	if (ret < 0)
-		goto out_header;
 
 	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
-	su = nilfs_sufile_block_get_segment_usage(
-		sufile, segnum, su_bh, kaddr);
+	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (unlikely(!nilfs_segment_usage_clean(su))) {
 		printk(KERN_WARNING "%s: segment %llu must be clean\n",
 		       __func__, (unsigned long long)segnum);
 		kunmap_atomic(kaddr, KM_USER0);
-		goto out_su_bh;
+		return;
 	}
 	nilfs_segment_usage_set_dirty(su);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
-	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
-	le64_add_cpu(&header->sh_ncleansegs, -1);
-	le64_add_cpu(&header->sh_ndirtysegs, 1);
-	kunmap_atomic(kaddr, KM_USER0);
-
-	nilfs_mdt_mark_buffer_dirty(header_bh);
+	nilfs_sufile_mod_counter(header_bh, -1, 1);
 	nilfs_mdt_mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);
-
- out_su_bh:
-	brelse(su_bh);
- out_header:
-	brelse(header_bh);
- out_sem:
-	up_write(&NILFS_MDT(sufile)->mi_sem);
-	return ret;
 }
 
-/**
- * nilfs_sufile_freev - free segments
- * @sufile: inode of segment usage file
- * @segnum: array of segment numbers
- * @nsegs: number of segments
- *
- * Description: nilfs_sufile_freev() frees segments specified by @segnum and
- * @nsegs, which must have been returned by a previous call to
- * nilfs_sufile_alloc().
- *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- */
-#define NILFS_SUFILE_FREEV_PREALLOC	16
-int nilfs_sufile_freev(struct inode *sufile, __u64 *segnum, size_t nsegs)
+void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
+			  struct buffer_head *header_bh,
+			  struct buffer_head *su_bh)
 {
-	struct buffer_head *header_bh, **su_bh,
-		*su_bh_prealloc[NILFS_SUFILE_FREEV_PREALLOC];
-	struct the_nilfs *nilfs;
-	struct nilfs_sufile_header *header;
 	struct nilfs_segment_usage *su;
 	void *kaddr;
-	int ret, i;
+	int sudirty;
 
-	down_write(&NILFS_MDT(sufile)->mi_sem);
-
-	nilfs = NILFS_MDT(sufile)->mi_nilfs;
-
-	/* prepare resources */
-	if (nsegs <= NILFS_SUFILE_FREEV_PREALLOC)
-		su_bh = su_bh_prealloc;
-	else {
-		su_bh = kmalloc(sizeof(*su_bh) * nsegs, GFP_NOFS);
-		if (su_bh == NULL) {
-			ret = -ENOMEM;
-			goto out_sem;
-		}
-	}
-
-	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
-	if (ret < 0)
-		goto out_su_bh;
-	for (i = 0; i < nsegs; i++) {
-		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum[i],
-							   0, &su_bh[i]);
-		if (ret < 0)
-			goto out_bh;
-	}
-
-	/* free segments */
-	for (i = 0; i < nsegs; i++) {
-		kaddr = kmap_atomic(su_bh[i]->b_page, KM_USER0);
-		su = nilfs_sufile_block_get_segment_usage(
-			sufile, segnum[i], su_bh[i], kaddr);
-		WARN_ON(nilfs_segment_usage_error(su));
-		nilfs_segment_usage_set_clean(su);
+	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
+	if (nilfs_segment_usage_clean(su)) {
+		printk(KERN_WARNING "%s: segment %llu is already clean\n",
+		       __func__, (unsigned long long)segnum);
 		kunmap_atomic(kaddr, KM_USER0);
-		nilfs_mdt_mark_buffer_dirty(su_bh[i]);
+		return;
 	}
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
-	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
-	le64_add_cpu(&header->sh_ncleansegs, nsegs);
-	le64_add_cpu(&header->sh_ndirtysegs, -(u64)nsegs);
-	kunmap_atomic(kaddr, KM_USER0);
-	nilfs_mdt_mark_buffer_dirty(header_bh);
-	nilfs_mdt_mark_dirty(sufile);
-
- out_bh:
-	for (i--; i >= 0; i--)
-		brelse(su_bh[i]);
-	brelse(header_bh);
+	WARN_ON(nilfs_segment_usage_error(su));
+	WARN_ON(!nilfs_segment_usage_dirty(su));
 
- out_su_bh:
-	if (su_bh != su_bh_prealloc)
-		kfree(su_bh);
-
- out_sem:
-	up_write(&NILFS_MDT(sufile)->mi_sem);
-	return ret;
-}
+	sudirty = nilfs_segment_usage_dirty(su);
+	nilfs_segment_usage_set_clean(su);
+	kunmap_atomic(kaddr, KM_USER0);
+	nilfs_mdt_mark_buffer_dirty(su_bh);
 
-/**
- * nilfs_sufile_free -
- * @sufile:
- * @segnum:
- */
-int nilfs_sufile_free(struct inode *sufile, __u64 segnum)
-{
-	return nilfs_sufile_freev(sufile, &segnum, 1);
+	nilfs_sufile_mod_counter(header_bh, 1, sudirty ? (u64)-1 : 0);
+	nilfs_mdt_mark_dirty(sufile);
 }
 
 /**
@@ -500,75 +433,28 @@ int nilfs_sufile_get_ncleansegs(struct inode *sufile, unsigned long *nsegsp)
 	return ret;
 }
 
-/**
- * nilfs_sufile_set_error - mark a segment as erroneous
- * @sufile: inode of segment usage file
- * @segnum: segment number
- *
- * Description: nilfs_sufile_set_error() marks the segment specified by
- * @segnum as erroneous. The error segment will never be used again.
- *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - Invalid segment usage number.
- */
-int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
+void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
+			       struct buffer_head *header_bh,
+			       struct buffer_head *su_bh)
 {
-	struct buffer_head *header_bh, *su_bh;
 	struct nilfs_segment_usage *su;
-	struct nilfs_sufile_header *header;
 	void *kaddr;
-	int suclean, ret;
-
-	if (unlikely(segnum >= nilfs_sufile_get_nsegments(sufile))) {
-		printk(KERN_WARNING "%s: invalid segment number: %llu\n",
-		       __func__, (unsigned long long)segnum);
-		return -EINVAL;
-	}
-	down_write(&NILFS_MDT(sufile)->mi_sem);
-
-	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
-	if (ret < 0)
-		goto out_sem;
-	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &su_bh);
-	if (ret < 0)
-		goto out_header;
+	int suclean;
 
 	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_error(su)) {
 		kunmap_atomic(kaddr, KM_USER0);
-		brelse(su_bh);
-		goto out_header;
+		return;
 	}
 	suclean = nilfs_segment_usage_clean(su);
-
 	nilfs_segment_usage_set_error(su);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	if (suclean) {
-		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
-		header = nilfs_sufile_block_get_header(sufile, header_bh,
-						       kaddr);
-		le64_add_cpu(&header->sh_ncleansegs, -1);
-		kunmap_atomic(kaddr, KM_USER0);
-		nilfs_mdt_mark_buffer_dirty(header_bh);
-	}
+	if (suclean)
+		nilfs_sufile_mod_counter(header_bh, -1, 0);
 	nilfs_mdt_mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);
-	brelse(su_bh);
-
- out_header:
-	brelse(header_bh);
-
- out_sem:
-	up_write(&NILFS_MDT(sufile)->mi_sem);
-	return ret;
 }
 
 /**
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index d595f33..449a6e2 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -36,9 +36,6 @@ static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
 }
 
 int nilfs_sufile_alloc(struct inode *, __u64 *);
-int nilfs_sufile_cancel_free(struct inode *, __u64);
-int nilfs_sufile_freev(struct inode *, __u64 *, size_t);
-int nilfs_sufile_free(struct inode *, __u64);
 int nilfs_sufile_get_segment_usage(struct inode *, __u64,
 				   struct nilfs_segment_usage **,
 				   struct buffer_head **);
@@ -46,9 +43,71 @@ void nilfs_sufile_put_segment_usage(struct inode *, __u64,
 				    struct buffer_head *);
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
 int nilfs_sufile_get_ncleansegs(struct inode *, unsigned long *);
-int nilfs_sufile_set_error(struct inode *, __u64);
 ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, struct nilfs_suinfo *,
 				size_t);
 
+int nilfs_sufile_update(struct inode *, __u64, int,
+			void (*dofunc)(struct inode *, __u64,
+				       struct buffer_head *,
+				       struct buffer_head *));
+void nilfs_sufile_do_cancel_free(struct inode *, __u64, struct buffer_head *,
+				 struct buffer_head *);
+void nilfs_sufile_do_free(struct inode *, __u64, struct buffer_head *,
+			  struct buffer_head *);
+void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
+			       struct buffer_head *);
+
+/**
+ * nilfs_sufile_cancel_free -
+ * @sufile: inode of segment usage file
+ * @segnum: segment number
+ *
+ * Description:
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+static inline int nilfs_sufile_cancel_free(struct inode *sufile, __u64 segnum)
+{
+	return nilfs_sufile_update(sufile, segnum, 0,
+				   nilfs_sufile_do_cancel_free);
+}
+
+/**
+ * nilfs_sufile_free - free segment
+ * @sufile: inode of segment usage file
+ * @segnum: segment number to be freed
+ */
+static inline int nilfs_sufile_free(struct inode *sufile, __u64 segnum)
+{
+	return nilfs_sufile_update(sufile, segnum, 0, nilfs_sufile_do_free);
+}
+
+/**
+ * nilfs_sufile_set_error - mark a segment as erroneous
+ * @sufile: inode of segment usage file
+ * @segnum: segment number
+ *
+ * Description: nilfs_sufile_set_error() marks the segment specified by
+ * @segnum as erroneous. The error segment will never be used again.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EINVAL - Invalid segment usage number.
+ */
+static inline int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
+{
+	return nilfs_sufile_update(sufile, segnum, 0,
+				   nilfs_sufile_do_set_error);
+}
 
 #endif	/* _NILFS_SUFILE_H */
-- 
1.5.6.5

