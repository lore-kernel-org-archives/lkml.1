Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbYAUKEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbYAUKEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759285AbYAUKCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759237AbYAUKCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:02 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/58] [GFS2] Introduce gfs2_set_aops()
Date: Mon, 21 Jan 2008 09:21:25 +0000
Message-Id: <12009073542596-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073531216-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
Message-Id: <3efb2aab4ef70fd3c5062d3cae1fdc7201943193.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Just like ext3 we now have three sets of address space operations
to cover the cases of writeback, ordered and journalled data
writes. This means that the individual operations can now become
less complicated as we are able to remove some of the tests for
file data mode from the code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index af493fc..532784e 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -136,7 +136,6 @@ void gfs2_set_iop(struct inode *inode)
 	if (S_ISREG(mode)) {
 		inode->i_op = &gfs2_file_iops;
 		inode->i_fop = &gfs2_file_fops;
-		inode->i_mapping->a_ops = &gfs2_file_aops;
 	} else if (S_ISDIR(mode)) {
 		inode->i_op = &gfs2_dir_iops;
 		inode->i_fop = &gfs2_dir_fops;
@@ -290,6 +289,9 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	di->di_entries = be32_to_cpu(str->di_entries);
 
 	di->di_eattr = be64_to_cpu(str->di_eattr);
+	if (S_ISREG(ip->i_inode.i_mode))
+		gfs2_set_aops(&ip->i_inode);
+
 	return 0;
 }
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index bed3dc2..d446506 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -26,6 +26,12 @@ static inline int gfs2_is_writeback(const struct gfs2_inode *ip)
 	return (sdp->sd_args.ar_data == GFS2_DATA_WRITEBACK) && !gfs2_is_jdata(ip);
 }
 
+static inline int gfs2_is_ordered(const struct gfs2_inode *ip)
+{
+	const struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	return (sdp->sd_args.ar_data == GFS2_DATA_ORDERED) && !gfs2_is_jdata(ip);
+}
+
 static inline int gfs2_is_dir(const struct gfs2_inode *ip)
 {
 	return S_ISDIR(ip->i_inode.i_mode);
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index ed154af..207014f 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -162,28 +162,18 @@ out_ignore:
 }
 
 /**
- * gfs2_writepages - Write a bunch of dirty pages back to disk
+ * gfs2_writeback_writepages - Write a bunch of dirty pages back to disk
  * @mapping: The mapping to write
  * @wbc: Write-back control
  *
- * For journaled files and/or ordered writes this just falls back to the
- * kernel's default writepages path for now. We will probably want to change
- * that eventually (i.e. when we look at allocate on flush).
- *
- * For the data=writeback case though we can already ignore buffer heads
+ * For the data=writeback case we can already ignore buffer heads
  * and write whole extents at once. This is a big reduction in the
  * number of I/O requests we send and the bmap calls we make in this case.
  */
-static int gfs2_writepages(struct address_space *mapping,
-			   struct writeback_control *wbc)
+static int gfs2_writeback_writepages(struct address_space *mapping,
+				     struct writeback_control *wbc)
 {
-	struct inode *inode = mapping->host;
-	struct gfs2_inode *ip = GFS2_I(inode);
-
-	if (gfs2_is_writeback(ip))
-		return mpage_writepages(mapping, wbc, gfs2_get_block_noalloc);
-
-	return generic_writepages(mapping, wbc);
+	return mpage_writepages(mapping, wbc, gfs2_get_block_noalloc);
 }
 
 /**
@@ -644,11 +634,7 @@ failed:
  
 static int gfs2_set_page_dirty(struct page *page)
 {
-	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
-	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
-
-	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
-		SetPageChecked(page);
+	SetPageChecked(page);
 	return __set_page_dirty_buffers(page);
 }
 
@@ -738,13 +724,9 @@ static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
 {
 	/*
 	 * Should we return an error here? I can't see that O_DIRECT for
-	 * a journaled file makes any sense. For now we'll silently fall
-	 * back to buffered I/O, likewise we do the same for stuffed
-	 * files since they are (a) small and (b) unaligned.
+	 * a stuffed file makes any sense. For now we'll silently fall
+	 * back to buffered I/O
 	 */
-	if (gfs2_is_jdata(ip))
-		return 0;
-
 	if (gfs2_is_stuffed(ip))
 		return 0;
 
@@ -855,9 +837,22 @@ cannot_release:
 	return 0;
 }
 
-const struct address_space_operations gfs2_file_aops = {
+static const struct address_space_operations gfs2_writeback_aops = {
+	.writepage = gfs2_writepage,
+	.writepages = gfs2_writeback_writepages,
+	.readpage = gfs2_readpage,
+	.readpages = gfs2_readpages,
+	.sync_page = block_sync_page,
+	.write_begin = gfs2_write_begin,
+	.write_end = gfs2_write_end,
+	.bmap = gfs2_bmap,
+	.invalidatepage = gfs2_invalidatepage,
+	.releasepage = gfs2_releasepage,
+	.direct_IO = gfs2_direct_IO,
+};
+
+static const struct address_space_operations gfs2_ordered_aops = {
 	.writepage = gfs2_writepage,
-	.writepages = gfs2_writepages,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
 	.sync_page = block_sync_page,
@@ -870,3 +865,30 @@ const struct address_space_operations gfs2_file_aops = {
 	.direct_IO = gfs2_direct_IO,
 };
 
+static const struct address_space_operations gfs2_jdata_aops = {
+	.writepage = gfs2_writepage,
+	.readpage = gfs2_readpage,
+	.readpages = gfs2_readpages,
+	.sync_page = block_sync_page,
+	.write_begin = gfs2_write_begin,
+	.write_end = gfs2_write_end,
+	.set_page_dirty = gfs2_set_page_dirty,
+	.bmap = gfs2_bmap,
+	.invalidatepage = gfs2_invalidatepage,
+	.releasepage = gfs2_releasepage,
+};
+
+void gfs2_set_aops(struct inode *inode)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+
+	if (gfs2_is_writeback(ip))
+		inode->i_mapping->a_ops = &gfs2_writeback_aops;
+	else if (gfs2_is_ordered(ip))
+		inode->i_mapping->a_ops = &gfs2_ordered_aops;
+	else if (gfs2_is_jdata(ip))
+		inode->i_mapping->a_ops = &gfs2_jdata_aops;
+	else
+		BUG();
+}
+
diff --git a/fs/gfs2/ops_address.h b/fs/gfs2/ops_address.h
index e8fe83f..d3b76d0 100644
--- a/fs/gfs2/ops_address.h
+++ b/fs/gfs2/ops_address.h
@@ -14,12 +14,12 @@
 #include <linux/buffer_head.h>
 #include <linux/mm.h>
 
-extern const struct address_space_operations gfs2_file_aops;
 extern int gfs2_get_block(struct inode *inode, sector_t lblock,
 			  struct buffer_head *bh_result, int create);
 extern int gfs2_releasepage(struct page *page, gfp_t gfp_mask);
 extern int gfs2_internal_read(struct gfs2_inode *ip,
 			      struct file_ra_state *ra_state,
 			      char *buf, loff_t *pos, unsigned size);
+extern void gfs2_set_aops(struct inode *inode);
 
 #endif /* __OPS_ADDRESS_DOT_H__ */
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 6f3aeb0..ad5daaa 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -38,6 +38,7 @@
 #include "trans.h"
 #include "util.h"
 #include "eaops.h"
+#include "ops_address.h"
 
 /**
  * gfs2_llseek - seek to a location in a file
@@ -245,7 +246,16 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 		if (error)
 			goto out;
 	}
-
+	if ((flags ^ new_flags) & GFS2_DIF_JDATA) {
+		if (flags & GFS2_DIF_JDATA)
+			gfs2_log_flush(sdp, ip->i_gl);
+		error = filemap_fdatawrite(inode->i_mapping);
+		if (error)
+			goto out;
+		error = filemap_fdatawait(inode->i_mapping);
+		if (error)
+			goto out;
+	}
 	error = gfs2_trans_begin(sdp, RES_DINODE, 0);
 	if (error)
 		goto out;
@@ -257,6 +267,7 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	gfs2_dinode_out(ip, bh->b_data);
 	brelse(bh);
 	gfs2_set_inode_flags(inode);
+	gfs2_set_aops(inode);
 out_trans_end:
 	gfs2_trans_end(sdp);
 out:
-- 
1.5.1.2

