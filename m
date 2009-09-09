Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbZIIPTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbZIIPTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZIIPTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:19:47 -0400
Received: from bosmailout11.eigbox.net ([66.96.190.11]:35991 "EHLO
	bosmailout11.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbZIIPTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:19:46 -0400
X-Greylist: delayed 2401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 11:19:46 EDT
X-EN-OrigOutIP: 10.20.18.4
X-EN-IMPSID: eefm1c00F05GATN0000000
Message-ID: <4AA7BE77.9000208@jaysonking.com>
Date: Wed, 09 Sep 2009 09:40:55 -0500
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: gregkh@suse.de
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27.32
Content-Type: multipart/mixed;
 boundary="------------020809080507020903050607"
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 66.139.154.210
X-EN-OrigHost: adsl-66-139-154-210.dsl.okcyok.swbell.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020809080507020903050607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Greg KH wrote:
 >Yes, this was just reported :)
 >
 >Do you have a proposed fix that is also upstream?

Revert the incomplete version of "ocfs2: Initialize the..." patch which 
is in -stable now and apply this one instead.

Jayson R. King

(sorry if I am dropping anyone from CC. I am not subscribed to LKML)



--------------020809080507020903050607
Content-Type: text/plain;
 name="aops-new.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aops-new.patch"

From: Sunil Mushran <sunil.mushran@oracle.com>

commit e7432675f8ca868a4af365759a8d4c3779a3d922 upstream.

In a non-sparse extend, we correctly allocate (and zero) the clusters between
the old_i_size and pos, but we don't zero the portions of the cluster we're
writing to outside of pos<->len.

It handles clustersize > pagesize and blocksize < pagesize.

[Cleaned up by Joel Becker.]

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

---
 fs/ocfs2/aops.c |   66 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 19 deletions(-)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -908,18 +908,17 @@ struct ocfs2_write_cluster_desc {
 	 */
 	unsigned	c_new;
 	unsigned	c_unwritten;
+	unsigned	c_needs_zero;
 };
 
-static inline int ocfs2_should_zero_cluster(struct ocfs2_write_cluster_desc *d)
-{
-	return d->c_new || d->c_unwritten;
-}
-
 struct ocfs2_write_ctxt {
 	/* Logical cluster position / len of write */
 	u32				w_cpos;
 	u32				w_clen;
 
+	/* First cluster allocated in a nonsparse extend */
+	u32				w_first_new_cpos;
+
 	struct ocfs2_write_cluster_desc	w_desc[OCFS2_MAX_CLUSTERS_PER_PAGE];
 
 	/*
@@ -997,6 +996,7 @@ static int ocfs2_alloc_write_ctxt(struct
 		return -ENOMEM;
 
 	wc->w_cpos = pos >> osb->s_clustersize_bits;
+	wc->w_first_new_cpos = UINT_MAX;
 	cend = (pos + len - 1) >> osb->s_clustersize_bits;
 	wc->w_clen = cend - wc->w_cpos + 1;
 	get_bh(di_bh);
@@ -1234,19 +1234,17 @@ out:
  */
 static int ocfs2_write_cluster(struct address_space *mapping,
 			       u32 phys, unsigned int unwritten,
+			       unsigned int should_zero,
 			       struct ocfs2_alloc_context *data_ac,
 			       struct ocfs2_alloc_context *meta_ac,
 			       struct ocfs2_write_ctxt *wc, u32 cpos,
 			       loff_t user_pos, unsigned user_len)
 {
-	int ret, i, new, should_zero = 0;
+	int ret, i, new;
 	u64 v_blkno, p_blkno;
 	struct inode *inode = mapping->host;
 
 	new = phys == 0 ? 1 : 0;
-	if (new || unwritten)
-		should_zero = 1;
-
 	if (new) {
 		u32 tmp_pos;
 
@@ -1356,7 +1354,9 @@ static int ocfs2_write_cluster_by_desc(s
 			local_len = osb->s_clustersize - cluster_off;
 
 		ret = ocfs2_write_cluster(mapping, desc->c_phys,
-					  desc->c_unwritten, data_ac, meta_ac,
+					  desc->c_unwritten,
+					  desc->c_needs_zero,
+					  data_ac, meta_ac,
 					  wc, desc->c_cpos, pos, local_len);
 		if (ret) {
 			mlog_errno(ret);
@@ -1406,14 +1406,14 @@ static void ocfs2_set_target_boundaries(
 		 * newly allocated cluster.
 		 */
 		desc = &wc->w_desc[0];
-		if (ocfs2_should_zero_cluster(desc))
+		if (desc->c_needs_zero)
 			ocfs2_figure_cluster_boundaries(osb,
 							desc->c_cpos,
 							&wc->w_target_from,
 							NULL);
 
 		desc = &wc->w_desc[wc->w_clen - 1];
-		if (ocfs2_should_zero_cluster(desc))
+		if (desc->c_needs_zero)
 			ocfs2_figure_cluster_boundaries(osb,
 							desc->c_cpos,
 							NULL,
@@ -1481,13 +1481,28 @@ static int ocfs2_populate_write_desc(str
 			phys++;
 		}
 
+		/*
+		 * If w_first_new_cpos is < UINT_MAX, we have a non-sparse
+		 * file that got extended.  w_first_new_cpos tells us
+		 * where the newly allocated clusters are so we can
+		 * zero them.
+		 */
+		if (desc->c_cpos >= wc->w_first_new_cpos) {
+			BUG_ON(phys == 0);
+			desc->c_needs_zero = 1;
+		}
+
 		desc->c_phys = phys;
 		if (phys == 0) {
 			desc->c_new = 1;
+			desc->c_needs_zero = 1;
 			*clusters_to_alloc = *clusters_to_alloc + 1;
 		}
-		if (ext_flags & OCFS2_EXT_UNWRITTEN)
+
+		if (ext_flags & OCFS2_EXT_UNWRITTEN) {
 			desc->c_unwritten = 1;
+			desc->c_needs_zero = 1;
+		}
 
 		num_clusters--;
 	}
@@ -1644,10 +1659,13 @@ static int ocfs2_expand_nonsparse_inode(
 	if (newsize <= i_size_read(inode))
 		return 0;
 
-	ret = ocfs2_extend_no_holes(inode, newsize, newsize - len);
+	ret = ocfs2_extend_no_holes(inode, newsize, pos);
 	if (ret)
 		mlog_errno(ret);
 
+	wc->w_first_new_cpos =
+		ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode));
+
 	return ret;
 }
 
@@ -1656,7 +1674,7 @@ int ocfs2_write_begin_nolock(struct addr
 			     struct page **pagep, void **fsdata,
 			     struct buffer_head *di_bh, struct page *mmap_page)
 {
-	int ret, credits = OCFS2_INODE_UPDATE_CREDITS;
+	int ret, cluster_of_pages, credits = OCFS2_INODE_UPDATE_CREDITS;
 	unsigned int clusters_to_alloc, extents_to_split;
 	struct ocfs2_write_ctxt *wc;
 	struct inode *inode = mapping->host;
@@ -1724,8 +1742,19 @@ int ocfs2_write_begin_nolock(struct addr
 
 	}
 
-	ocfs2_set_target_boundaries(osb, wc, pos, len,
-				    clusters_to_alloc + extents_to_split);
+	/*
+	 * We have to zero sparse allocated clusters, unwritten extent clusters,
+	 * and non-sparse clusters we just extended.  For non-sparse writes,
+	 * we know zeros will only be needed in the first and/or last cluster.
+	 */
+	if (clusters_to_alloc || extents_to_split ||
+	    wc->w_desc[0].c_needs_zero ||
+	    wc->w_desc[wc->w_clen - 1].c_needs_zero)
+		cluster_of_pages = 1;
+	else
+		cluster_of_pages = 0;
+
+	ocfs2_set_target_boundaries(osb, wc, pos, len, cluster_of_pages);
 
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
@@ -1753,8 +1782,7 @@ int ocfs2_write_begin_nolock(struct addr
 	 * extent.
 	 */
 	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos,
-					 clusters_to_alloc + extents_to_split,
-					 mmap_page);
+					 cluster_of_pages, mmap_page);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;

--------------020809080507020903050607--
