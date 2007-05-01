Return-Path: <linux-kernel-owner+w=401wt.eu-S1161693AbXEAKYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161693AbXEAKYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161699AbXEAKYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:24:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161686AbXEAKX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:23:59 -0400
Subject: [GFS2] Patch to detect corrupt number of dir entries in leaf
	and/or inode blocks [25/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:19:26 +0100
Message-Id: <1178014766.5462.180.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From bdd19a22f85a7039e01accd8717eaec4addd9dfd Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 18 Apr 2007 09:38:42 +0100
Subject: [PATCH] [GFS2] Patch to detect corrupt number of dir entries in leaf and/or inode blocks

This patch detects when the number of entries in a leaf block or inode
block (in the case of stuffed directories) is corrupt and informs the
user. It prevents us from running off the end of the array thats been
allocated for the sorting in this case,

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 82a1ac7..6c3ed76 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1262,9 +1262,10 @@ static int gfs2_dir_read_leaf(struct inode *inode, u64 *offset, void *opaque,
 			      u64 leaf_no)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct buffer_head *bh;
 	struct gfs2_leaf *lf;
-	unsigned entries = 0;
+	unsigned entries = 0, entries2 = 0;
 	unsigned leaves = 0;
 	const struct gfs2_dirent **darr, *dent;
 	struct dirent_gather g;
@@ -1290,7 +1291,13 @@ static int gfs2_dir_read_leaf(struct inode *inode, u64 *offset, void *opaque,
 		return 0;
 
 	error = -ENOMEM;
-	larr = vmalloc((leaves + entries) * sizeof(void *));
+	/*
+	 * The extra 99 entries are not normally used, but are a buffer
+	 * zone in case the number of entries in the leaf is corrupt.
+	 * 99 is the maximum number of entries that can fit in a single
+	 * leaf block.
+	 */
+	larr = vmalloc((leaves + entries + 99) * sizeof(void *));
 	if (!larr)
 		goto out;
 	darr = (const struct gfs2_dirent **)(larr + leaves);
@@ -1305,10 +1312,18 @@ static int gfs2_dir_read_leaf(struct inode *inode, u64 *offset, void *opaque,
 		lf = (struct gfs2_leaf *)bh->b_data;
 		lfn = be64_to_cpu(lf->lf_next);
 		if (lf->lf_entries) {
+			entries2 += be16_to_cpu(lf->lf_entries);
 			dent = gfs2_dirent_scan(inode, bh->b_data, bh->b_size,
 						gfs2_dirent_gather, NULL, &g);
 			error = PTR_ERR(dent);
-			if (IS_ERR(dent)) {
+			if (IS_ERR(dent))
+				goto out_kfree;
+			if (entries2 != g.offset) {
+				fs_warn(sdp, "Number of entries corrupt in dir leaf %llu, "
+				        "entries2 (%u) != g.offset (%u)\n",
+					(u64)bh->b_blocknr, entries2, g.offset);
+					
+				error = -EIO;
 				goto out_kfree;
 			}
 			error = 0;
@@ -1318,6 +1333,7 @@ static int gfs2_dir_read_leaf(struct inode *inode, u64 *offset, void *opaque,
 		}
 	} while(lfn);
 
+	BUG_ON(entries2 != entries);
 	error = do_filldir_main(ip, offset, opaque, filldir, darr,
 				entries, copied);
 out_kfree:
@@ -1401,6 +1417,7 @@ int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 		  filldir_t filldir)
 {
 	struct gfs2_inode *dip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct dirent_gather g;
 	const struct gfs2_dirent **darr, *dent;
 	struct buffer_head *dibh;
@@ -1423,8 +1440,8 @@ int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 		return error;
 
 	error = -ENOMEM;
-	darr = kmalloc(dip->i_di.di_entries * sizeof(struct gfs2_dirent *),
-		       GFP_KERNEL);
+	/* 96 is max number of dirents which can be stuffed into an inode */
+	darr = kmalloc(96 * sizeof(struct gfs2_dirent *), GFP_KERNEL);
 	if (darr) {
 		g.pdent = darr;
 		g.offset = 0;
@@ -1434,6 +1451,14 @@ int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 			error = PTR_ERR(dent);
 			goto out;
 		}
+		if (dip->i_di.di_entries != g.offset) {
+			fs_warn(sdp, "Number of entries corrupt in dir %llu, "
+				"ip->i_di.di_entries (%u) != g.offset (%u)\n",
+				dip->i_num.no_addr, dip->i_di.di_entries,
+				g.offset);
+			error = -EIO;
+			goto out;
+		}
 		error = do_filldir_main(dip, offset, opaque, filldir, darr,
 					dip->i_di.di_entries, &copied);
 out:
-- 
1.5.1.2



