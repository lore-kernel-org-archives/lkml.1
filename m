Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYLSWIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYLSWIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYLSVz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:55:27 -0500
Received: from ns.suse.de ([195.135.220.2]:58082 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010AbYLSVzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:55:23 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 41/45] ocfs2: Wrap virtual block reads in ocfs2_read_virt_blocks()
Date: Fri, 19 Dec 2008 13:54:00 -0800
Message-Id: <1229723644-13630-42-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

The ocfs2_read_dir_block() function really maps an inode's virtual
blocks to physical ones before calling ocfs2_read_blocks().  Let's
extract that to common code, because other places might want to do that.

Other than the block number being virtual, ocfs2_read_virt_blocks()
takes the same arguments as ocfs2_read_blocks().  It converts those
virtual block numbers to physical before calling ocfs2_read_blocks()
directly.  If the blocks asked for are discontiguous, this can mean
multiple calls to ocfs2_read_blocks(), but this is mostly hidden from
the caller.

Like ocfs2_read_blocks(), the caller can pass in an existing
buffer_head.  This is usually done to pick up some readahead I/O.
ocfs2_read_virt_blocks() checks the buffer_head's block number
against the extent map - it must match.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/extent_map.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/extent_map.h |   24 ++++++++++++++++
 2 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 0bd9d96..f2bb1a0 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -806,3 +806,74 @@ out:
 
 	return ret;
 }
+
+int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
+			   struct buffer_head *bhs[], int flags,
+			   int (*validate)(struct super_block *sb,
+					   struct buffer_head *bh))
+{
+	int rc = 0;
+	u64 p_block, p_count;
+	int i, count, done = 0;
+
+	mlog_entry("(inode = %p, v_block = %llu, nr = %d, bhs = %p, "
+		   "flags = %x, validate = %p)\n",
+		   inode, (unsigned long long)v_block, nr, bhs, flags,
+		   validate);
+
+	if (((v_block + nr - 1) << inode->i_sb->s_blocksize_bits) >=
+	    i_size_read(inode)) {
+		BUG_ON(!(flags & OCFS2_BH_READAHEAD));
+		goto out;
+	}
+
+	while (done < nr) {
+		down_read(&OCFS2_I(inode)->ip_alloc_sem);
+		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
+						 &p_block, &p_count, NULL);
+		up_read(&OCFS2_I(inode)->ip_alloc_sem);
+		if (rc) {
+			mlog_errno(rc);
+			break;
+		}
+
+		if (!p_block) {
+			rc = -EIO;
+			mlog(ML_ERROR,
+			     "Inode #%llu contains a hole at offset %llu\n",
+			     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			     (unsigned long long)(v_block + done) <<
+			     inode->i_sb->s_blocksize_bits);
+			break;
+		}
+
+		count = nr - done;
+		if (p_count < count)
+			count = p_count;
+
+		/*
+		 * If the caller passed us bhs, they should have come
+		 * from a previous readahead call to this function.  Thus,
+		 * they should have the right b_blocknr.
+		 */
+		for (i = 0; i < count; i++) {
+			if (!bhs[done + i])
+				continue;
+			BUG_ON(bhs[done + i]->b_blocknr != (p_block + i));
+		}
+
+		rc = ocfs2_read_blocks(inode, p_block, count, bhs + done,
+				       flags, validate);
+		if (rc) {
+			mlog_errno(rc);
+			break;
+		}
+		done += count;
+	}
+
+out:
+	mlog_exit(rc);
+	return rc;
+}
+
+
diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
index 1c4aa8b..b7dd973 100644
--- a/fs/ocfs2/extent_map.h
+++ b/fs/ocfs2/extent_map.h
@@ -57,4 +57,28 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 			     u32 *p_cluster, u32 *num_clusters,
 			     struct ocfs2_extent_list *el);
 
+int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
+			   struct buffer_head *bhs[], int flags,
+			   int (*validate)(struct super_block *sb,
+					   struct buffer_head *bh));
+static inline int ocfs2_read_virt_block(struct inode *inode, u64 v_block,
+					struct buffer_head **bh,
+					int (*validate)(struct super_block *sb,
+							struct buffer_head *bh))
+{
+	int status = 0;
+
+	if (bh == NULL) {
+		printk("ocfs2: bh == NULL\n");
+		status = -EINVAL;
+		goto bail;
+	}
+
+	status = ocfs2_read_virt_blocks(inode, v_block, 1, bh, 0, validate);
+
+bail:
+	return status;
+}
+
+
 #endif  /* _EXTENT_MAP_H */
-- 
1.5.6

