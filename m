Return-Path: <linux-kernel-owner+w=401wt.eu-S940497AbXHJSoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940497AbXHJSoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXHJSoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:44:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61389 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbXHJSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:44:08 -0400
Date: Fri, 10 Aug 2007 11:43:54 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [git patches] ocfs2 fixes
Message-ID: <20070810184354.GM5260@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly fixes and two very small/obvious cleanups.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/alloc.c       |    4 --
 fs/ocfs2/cluster/tcp.c |   24 +++++++++++------
 fs/ocfs2/file.c        |   28 +++++++++++++++++--
 fs/ocfs2/namei.c       |   16 ++++++++++-
 fs/ocfs2/ocfs2.h       |    8 ++---
 fs/ocfs2/super.c       |   69 +++++++++++++++++++++++++++++--------------------
 fs/ocfs2/super.h       |    2 -
 7 files changed, 101 insertions(+), 50 deletions(-)

Adrian Bunk (1):
      [2.6 patch] ocfs2_insert_extent(): remove dead code

Mark Fasheh (6):
      ocfs2: Restrict inode changes in ocfs2_update_inode_atime()
      ocfs2: use s_maxbytes directly in ocfs2_change_file_space()
      ocfs2: Fix some casting errors related to file writes
      ocfs2: check ia_size limits in setattr
      ocfs2: Fix max offset calculations
      ocfs2: set non-default s_time_gran during mount

Sunil Mushran (2):
      ocfs2: Fix rename/extend race
      ocfs2: Retry sendpage() if it returns EAGAIN

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index f5e11f4..4f51766 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3731,7 +3731,6 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 {
 	int status;
 	struct buffer_head *last_eb_bh = NULL;
-	struct buffer_head *bh = NULL;
 	struct ocfs2_insert_type insert = {0, };
 	struct ocfs2_extent_rec rec;
 
@@ -3783,9 +3782,6 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 		ocfs2_extent_map_insert_rec(inode, &rec);
 
 bail:
-	if (bh)
-		brelse(bh);
-
 	if (last_eb_bh)
 		brelse(last_eb_bh);
 
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index f0bdfd9..685c180 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -854,17 +854,25 @@ static void o2net_sendpage(struct o2net_sock_container *sc,
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
 	ssize_t ret;
 
-
-	mutex_lock(&sc->sc_send_lock);
-	ret = sc->sc_sock->ops->sendpage(sc->sc_sock,
-					 virt_to_page(kmalloced_virt),
-					 (long)kmalloced_virt & ~PAGE_MASK,
-					 size, MSG_DONTWAIT);
-	mutex_unlock(&sc->sc_send_lock);
-	if (ret != size) {
+	while (1) {
+		mutex_lock(&sc->sc_send_lock);
+		ret = sc->sc_sock->ops->sendpage(sc->sc_sock,
+						 virt_to_page(kmalloced_virt),
+						 (long)kmalloced_virt & ~PAGE_MASK,
+						 size, MSG_DONTWAIT);
+		mutex_unlock(&sc->sc_send_lock);
+		if (ret == size)
+			break;
+		if (ret == (ssize_t)-EAGAIN) {
+			mlog(0, "sendpage of size %zu to " SC_NODEF_FMT
+			     " returned EAGAIN\n", size, SC_NODEF_ARGS(sc));
+			cond_resched();
+			continue;
+		}
 		mlog(ML_ERROR, "sendpage of size %zu to " SC_NODEF_FMT 
 		     " failed with %zd\n", size, SC_NODEF_ARGS(sc), ret);
 		o2net_ensure_shutdown(nn, sc, 0);
+		break;
 	}
 }
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c4034f6..4ffa715 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -187,6 +187,7 @@ int ocfs2_update_inode_atime(struct inode *inode,
 	int ret;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	handle_t *handle;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *) bh->b_data;
 
 	mlog_entry_void();
 
@@ -197,11 +198,27 @@ int ocfs2_update_inode_atime(struct inode *inode,
 		goto out;
 	}
 
+	ret = ocfs2_journal_access(handle, inode, bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	/*
+	 * Don't use ocfs2_mark_inode_dirty() here as we don't always
+	 * have i_mutex to guard against concurrent changes to other
+	 * inode fields.
+	 */
 	inode->i_atime = CURRENT_TIME;
-	ret = ocfs2_mark_inode_dirty(handle, inode, bh);
+	di->i_atime = cpu_to_le64(inode->i_atime.tv_sec);
+	di->i_atime_nsec = cpu_to_le32(inode->i_atime.tv_nsec);
+
+	ret = ocfs2_journal_dirty(handle, bh);
 	if (ret < 0)
 		mlog_errno(ret);
 
+out_commit:
 	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
 	mlog_exit(ret);
@@ -1011,6 +1028,11 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (size_change && attr->ia_size != i_size_read(inode)) {
+		if (attr->ia_size > sb->s_maxbytes) {
+			status = -EFBIG;
+			goto bail_unlock;
+		}
+
 		if (i_size_read(inode) > attr->ia_size)
 			status = ocfs2_truncate_file(inode, bh, attr->ia_size);
 		else
@@ -1516,7 +1538,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *di_bh = NULL;
 	handle_t *handle;
-	unsigned long long max_off = ocfs2_max_file_offset(inode->i_sb->s_blocksize_bits);
+	unsigned long long max_off = inode->i_sb->s_maxbytes;
 
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
 		return -EROFS;
@@ -1942,7 +1964,7 @@ static ssize_t ocfs2_file_buffered_write(struct file *file, loff_t *ppos,
 		}
 
 		dst = kmap_atomic(page, KM_USER0);
-		memcpy(dst + (pos & (PAGE_CACHE_SIZE - 1)), buf, bytes);
+		memcpy(dst + (pos & (loff_t)(PAGE_CACHE_SIZE - 1)), buf, bytes);
 		kunmap_atomic(dst, KM_USER0);
 		flush_dcache_page(page);
 		ocfs2_put_write_source(user_page);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d430fda..701e6d0 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1080,6 +1080,7 @@ static int ocfs2_rename(struct inode *old_dir,
 	struct buffer_head *old_inode_de_bh = NULL; // if old_dentry is a dir,
 						    // this is the 1st dirent bh
 	nlink_t old_dir_nlink = old_dir->i_nlink;
+	struct ocfs2_dinode *old_di;
 
 	/* At some point it might be nice to break this function up a
 	 * bit. */
@@ -1354,7 +1355,20 @@ static int ocfs2_rename(struct inode *old_dir,
 
 	old_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(old_inode);
-	ocfs2_mark_inode_dirty(handle, old_inode, old_inode_bh);
+
+	status = ocfs2_journal_access(handle, old_inode, old_inode_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status >= 0) {
+		old_di = (struct ocfs2_dinode *) old_inode_bh->b_data;
+
+		old_di->i_ctime = cpu_to_le64(old_inode->i_ctime.tv_sec);
+		old_di->i_ctime_nsec = cpu_to_le32(old_inode->i_ctime.tv_nsec);
+
+		status = ocfs2_journal_dirty(handle, old_inode_bh);
+		if (status < 0)
+			mlog_errno(status);
+	} else
+		mlog_errno(status);
 
 	/* now that the name has been added to new_dir, remove the old name */
 	status = ocfs2_delete_entry(handle, old_dir, old_de, old_de_bh);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 5cc90a4..5830785 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -494,16 +494,16 @@ static inline unsigned int ocfs2_page_index_to_clusters(struct super_block *sb,
 /*
  * Find the 1st page index which covers the given clusters.
  */
-static inline unsigned long ocfs2_align_clusters_to_page_index(struct super_block *sb,
+static inline pgoff_t ocfs2_align_clusters_to_page_index(struct super_block *sb,
 							u32 clusters)
 {
 	unsigned int cbits = OCFS2_SB(sb)->s_clustersize_bits;
-	unsigned long index = clusters;
+        pgoff_t index = clusters;
 
 	if (PAGE_CACHE_SHIFT > cbits) {
-		index = clusters >> (PAGE_CACHE_SHIFT - cbits);
+		index = (pgoff_t)clusters >> (PAGE_CACHE_SHIFT - cbits);
 	} else if (PAGE_CACHE_SHIFT < cbits) {
-		index = clusters << (cbits - PAGE_CACHE_SHIFT);
+		index = (pgoff_t)clusters << (cbits - PAGE_CACHE_SHIFT);
 	}
 
 	return index;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 200c7d4..f2fc9a7 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -316,39 +316,51 @@ static void ocfs2_destroy_inode(struct inode *inode)
 	kmem_cache_free(ocfs2_inode_cachep, OCFS2_I(inode));
 }
 
-/* From xfs_super.c:xfs_max_file_offset
- * Copyright (c) 2000-2004 Silicon Graphics, Inc.
- */
-unsigned long long ocfs2_max_file_offset(unsigned int blockshift)
+static unsigned long long ocfs2_max_file_offset(unsigned int bbits,
+						unsigned int cbits)
 {
-	unsigned int pagefactor = 1;
-	unsigned int bitshift = BITS_PER_LONG - 1;
-
-	/* Figure out maximum filesize, on Linux this can depend on
-	 * the filesystem blocksize (on 32 bit platforms).
-	 * __block_prepare_write does this in an [unsigned] long...
-	 *      page->index << (PAGE_CACHE_SHIFT - bbits)
-	 * So, for page sized blocks (4K on 32 bit platforms),
-	 * this wraps at around 8Tb (hence MAX_LFS_FILESIZE which is
-	 *      (((u64)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1)
-	 * but for smaller blocksizes it is less (bbits = log2 bsize).
-	 * Note1: get_block_t takes a long (implicit cast from above)
-	 * Note2: The Large Block Device (LBD and HAVE_SECTOR_T) patch
-	 * can optionally convert the [unsigned] long from above into
-	 * an [unsigned] long long.
+	unsigned int bytes = 1 << cbits;
+	unsigned int trim = bytes;
+	unsigned int bitshift = 32;
+
+	/*
+	 * i_size and all block offsets in ocfs2 are always 64 bits
+	 * wide. i_clusters is 32 bits, in cluster-sized units. So on
+	 * 64 bit platforms, cluster size will be the limiting factor.
 	 */
 
 #if BITS_PER_LONG == 32
 # if defined(CONFIG_LBD)
 	BUILD_BUG_ON(sizeof(sector_t) != 8);
-	pagefactor = PAGE_CACHE_SIZE;
-	bitshift = BITS_PER_LONG;
+	/*
+	 * We might be limited by page cache size.
+	 */
+	if (bytes > PAGE_CACHE_SIZE) {
+		bytes = PAGE_CACHE_SIZE;
+		trim = 1;
+		/*
+		 * Shift by 31 here so that we don't get larger than
+		 * MAX_LFS_FILESIZE
+		 */
+		bitshift = 31;
+	}
 # else
-	pagefactor = PAGE_CACHE_SIZE >> (PAGE_CACHE_SHIFT - blockshift);
+	/*
+	 * We are limited by the size of sector_t. Use block size, as
+	 * that's what we expose to the VFS.
+	 */
+	bytes = 1 << bbits;
+	trim = 1;
+	bitshift = 31;
 # endif
 #endif
 
-	return (((unsigned long long)pagefactor) << bitshift) - 1;
+	/*
+	 * Trim by a whole cluster when we can actually approach the
+	 * on-disk limits. Otherwise we can overflow i_clusters when
+	 * an extent start is at the max offset.
+	 */
+	return (((unsigned long long)bytes) << bitshift) - trim;
 }
 
 static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
@@ -1259,8 +1271,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 				  int sector_size)
 {
 	int status = 0;
-	int i;
-	struct ocfs2_dinode *di = NULL;
+	int i, cbits, bbits;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 	struct inode *inode = NULL;
 	struct buffer_head *bitmap_bh = NULL;
 	struct ocfs2_journal *journal;
@@ -1279,9 +1291,12 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
 	sb->s_export_op = &ocfs2_export_ops;
+	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
 	/* this is needed to support O_LARGEFILE */
-	sb->s_maxbytes = ocfs2_max_file_offset(sb->s_blocksize_bits);
+	cbits = le32_to_cpu(di->id2.i_super.s_clustersize_bits);
+	bbits = le32_to_cpu(di->id2.i_super.s_blocksize_bits);
+	sb->s_maxbytes = ocfs2_max_file_offset(bbits, cbits);
 
 	osb->sb = sb;
 	/* Save off for ocfs2_rw_direct */
@@ -1341,8 +1356,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
-	di = (struct ocfs2_dinode *)bh->b_data;
-
 	osb->max_slots = le16_to_cpu(di->id2.i_super.s_max_slots);
 	if (osb->max_slots > OCFS2_MAX_SLOTS || osb->max_slots == 0) {
 		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
diff --git a/fs/ocfs2/super.h b/fs/ocfs2/super.h
index 3b9cb3d..783f527 100644
--- a/fs/ocfs2/super.h
+++ b/fs/ocfs2/super.h
@@ -45,6 +45,4 @@ void __ocfs2_abort(struct super_block *sb,
 
 #define ocfs2_abort(sb, fmt, args...) __ocfs2_abort(sb, __PRETTY_FUNCTION__, fmt, ##args)
 
-unsigned long long ocfs2_max_file_offset(unsigned int blockshift);
-
 #endif /* OCFS2_SUPER_H */
