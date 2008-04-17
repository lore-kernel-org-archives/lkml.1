Return-Path: <linux-kernel-owner+w=401wt.eu-S935067AbYDQJqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935067AbYDQJqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933578AbYDQJ01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933700AbYDQJ0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:09 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 27/48] [GFS2] Add a function to interate over an extent
Date: Thu, 17 Apr 2008 09:39:03 +0100
Message-Id: <12084216241802-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216222853-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This adds a function (currently the only use is during mapping
of already allocated blocks, but watch this space) which iterates
over a number of pointers in a block and returns the extent length.

If the initial pointer is 0 (i.e. unallocated) it will return the
number of unallocated blocks in the extent. If the initial pointer
is allocated, then it returns the number of contiguously allocated
blocks in the extent.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 7f72564..6780aa5 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -422,6 +422,42 @@ static void release_metapath(struct metapath *mp)
 			brelse(mp->mp_bh[i]);
 }
 
+/**
+ * gfs2_extent_length - Returns length of an extent of blocks
+ * @start: Start of the buffer
+ * @len: Length of the buffer in bytes
+ * @ptr: Current position in the buffer
+ * @limit: Max extent length to return (0 = unlimited)
+ * @eob: Set to 1 if we hit "end of block"
+ *
+ * If the first block is zero (unallocated) it will return the number of
+ * unallocated blocks in the extent, otherwise it will return the number
+ * of contiguous blocks in the extent.
+ *
+ * Returns: The length of the extent (minimum of one block)
+ */
+
+static inline unsigned int gfs2_extent_length(void *start, unsigned int len, __be64 *ptr, unsigned limit, int *eob)
+{
+	const __be64 *end = (start + len);
+	const __be64 *first = ptr;
+	u64 d = be64_to_cpu(*ptr);
+
+	*eob = 0;
+	do {
+		ptr++;
+		if (ptr >= end)
+			break;
+		if (limit && --limit == 0)
+			break;
+		if (d)
+			d++;
+	} while(be64_to_cpu(*ptr) == d);
+	if (ptr >= end)
+		*eob = 1;
+	return (ptr - first);
+}
+
 static inline void bmap_lock(struct inode *inode, int create)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -499,26 +535,26 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 		goto out_fail;
 	boundary = error;
 
+	if (new) {
+		map_bh(bh_map, inode->i_sb, dblock);
+		if (boundary)
+			set_buffer_boundary(bh_map);
+		gfs2_trans_add_bh(ip->i_gl, mp.mp_bh[0], 1);
+		gfs2_dinode_out(ip, mp.mp_bh[0]->b_data);
+		set_buffer_new(bh_map);
+		goto out_ok;
+	}
+
 	if (dblock) {
+		unsigned int len;
+		struct buffer_head *bh = mp.mp_bh[ip->i_height - 1];
+		__be64 *ptr = metapointer(&boundary, ip->i_height - 1, &mp);
 		map_bh(bh_map, inode->i_sb, dblock);
+		len = gfs2_extent_length(bh->b_data, bh->b_size, ptr, maxlen,
+					 &boundary);
+		bh_map->b_size = (len << inode->i_blkbits);
 		if (boundary)
 			set_buffer_boundary(bh_map);
-		if (new) {
-			gfs2_trans_add_bh(ip->i_gl, mp.mp_bh[0], 1);
-			gfs2_dinode_out(ip, mp.mp_bh[0]->b_data);
-			set_buffer_new(bh_map);
-			goto out_ok;
-		}
-		while(--maxlen && !buffer_boundary(bh_map)) {
-			u64 eblock;
-			mp.mp_list[ip->i_height - 1]++;
-			boundary = lookup_block(ip, ip->i_height - 1, &mp, 0, &new, &eblock);
-			if (eblock != ++dblock)
-				break;
-			bh_map->b_size += (1 << inode->i_blkbits);
-			if (boundary)
-				set_buffer_boundary(bh_map);
-		}
 	}
 out_ok:
 	error = 0;
-- 
1.5.1.2

