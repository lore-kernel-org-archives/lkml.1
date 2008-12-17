Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759898AbYLQMbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbYLQMbh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYLQM3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53735 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbYLQM3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:12 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/24] GFS2: Move di_eattr into "proper" inode
Date: Wed, 17 Dec 2008 11:30:06 +0000
Message-Id: <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This moves the di_eattr field out of gfs2_inode_host and
into the inode proper.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 3e9bd46..e335dce 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -91,7 +91,7 @@ static int acl_get(struct gfs2_inode *ip, int access, struct posix_acl **acl,
 	struct gfs2_ea_location el_this;
 	int error;
 
-	if (!ip->i_di.di_eattr)
+	if (!ip->i_eattr)
 		return 0;
 
 	memset(&er, 0, sizeof(struct gfs2_ea_request));
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index e3f76f4..1c1e061 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -114,7 +114,7 @@ static int ea_foreach(struct gfs2_inode *ip, ea_call_t ea_call, void *data)
 	__be64 *eablk, *end;
 	int error;
 
-	error = gfs2_meta_read(ip->i_gl, ip->i_di.di_eattr, DIO_WAIT, &bh);
+	error = gfs2_meta_read(ip->i_gl, ip->i_eattr, DIO_WAIT, &bh);
 	if (error)
 		return error;
 
@@ -414,7 +414,7 @@ int gfs2_ea_list(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 	if (error)
 		return error;
 
-	if (ip->i_di.di_eattr) {
+	if (ip->i_eattr) {
 		struct ea_list ei = { .ei_er = er, .ei_size = 0 };
 
 		error = ea_foreach(ip, ea_list_i, &ei);
@@ -514,7 +514,7 @@ int gfs2_ea_get_i(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 	struct gfs2_ea_location el;
 	int error;
 
-	if (!ip->i_di.di_eattr)
+	if (!ip->i_eattr)
 		return -ENODATA;
 
 	error = gfs2_ea_find(ip, er, &el);
@@ -741,7 +741,7 @@ static int ea_init_i(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	if (error)
 		return error;
 
-	ip->i_di.di_eattr = bh->b_blocknr;
+	ip->i_eattr = bh->b_blocknr;
 	error = ea_write(ip, GFS2_EA_BH2FIRST(bh), er);
 
 	brelse(bh);
@@ -938,7 +938,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	if (ip->i_di.di_flags & GFS2_DIF_EA_INDIRECT) {
 		__be64 *end;
 
-		error = gfs2_meta_read(ip->i_gl, ip->i_di.di_eattr, DIO_WAIT,
+		error = gfs2_meta_read(ip->i_gl, ip->i_eattr, DIO_WAIT,
 				       &indbh);
 		if (error)
 			return error;
@@ -972,8 +972,8 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 		gfs2_buffer_clear_tail(indbh, mh_size);
 
 		eablk = (__be64 *)(indbh->b_data + mh_size);
-		*eablk = cpu_to_be64(ip->i_di.di_eattr);
-		ip->i_di.di_eattr = blk;
+		*eablk = cpu_to_be64(ip->i_eattr);
+		ip->i_eattr = blk;
 		ip->i_di.di_flags |= GFS2_DIF_EA_INDIRECT;
 		gfs2_add_inode_blocks(&ip->i_inode, 1);
 
@@ -1040,7 +1040,7 @@ int gfs2_ea_set_i(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 	struct gfs2_ea_location el;
 	int error;
 
-	if (!ip->i_di.di_eattr) {
+	if (!ip->i_eattr) {
 		if (er->er_flags & XATTR_REPLACE)
 			return -ENODATA;
 		return ea_init(ip, er);
@@ -1145,7 +1145,7 @@ int gfs2_ea_remove_i(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 	struct gfs2_ea_location el;
 	int error;
 
-	if (!ip->i_di.di_eattr)
+	if (!ip->i_eattr)
 		return -ENODATA;
 
 	error = gfs2_ea_find(ip, er, &el);
@@ -1309,7 +1309,7 @@ static int ea_dealloc_indirect(struct gfs2_inode *ip)
 
 	memset(&rlist, 0, sizeof(struct gfs2_rgrp_list));
 
-	error = gfs2_meta_read(ip->i_gl, ip->i_di.di_eattr, DIO_WAIT, &indbh);
+	error = gfs2_meta_read(ip->i_gl, ip->i_eattr, DIO_WAIT, &indbh);
 	if (error)
 		return error;
 
@@ -1416,7 +1416,7 @@ static int ea_dealloc_block(struct gfs2_inode *ip)
 	struct buffer_head *dibh;
 	int error;
 
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_di.di_eattr);
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_eattr);
 	if (!rgd) {
 		gfs2_consist_inode(ip);
 		return -EIO;
@@ -1432,9 +1432,9 @@ static int ea_dealloc_block(struct gfs2_inode *ip)
 	if (error)
 		goto out_gunlock;
 
-	gfs2_free_meta(ip, ip->i_di.di_eattr, 1);
+	gfs2_free_meta(ip, ip->i_eattr, 1);
 
-	ip->i_di.di_eattr = 0;
+	ip->i_eattr = 0;
 	gfs2_add_inode_blocks(&ip->i_inode, -1);
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 15ca3a7..fb2fd4a 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -236,7 +236,6 @@ enum {
 struct gfs2_dinode_host {
 	u64 di_size;		/* number of bytes in file */
 	u32 di_flags;		/* GFS2_DIF_... */
-	u64 di_eattr;		/* extended attribute block number */
 };
 
 struct gfs2_inode {
@@ -244,6 +243,7 @@ struct gfs2_inode {
 	u64 i_no_addr;
 	u64 i_no_formal_ino;
 	u64 i_generation;
+	u64 i_eattr;
 	unsigned long i_flags;		/* GIF_... */
 
 	struct gfs2_dinode_host i_di; /* To be replaced by ref to block */
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 30ffc88..7b1867e 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -301,7 +301,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-	di->di_eattr = be64_to_cpu(str->di_eattr);
+	ip->i_eattr = be64_to_cpu(str->di_eattr);
 	if (S_ISREG(ip->i_inode.i_mode))
 		gfs2_set_aops(&ip->i_inode);
 
@@ -1273,7 +1273,7 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_depth = cpu_to_be16(ip->i_depth);
 	str->di_entries = cpu_to_be32(ip->i_entries);
 
-	str->di_eattr = cpu_to_be64(di->di_eattr);
+	str->di_eattr = cpu_to_be64(ip->i_eattr);
 	str->di_atime_nsec = cpu_to_be32(ip->i_inode.i_atime.tv_nsec);
 	str->di_mtime_nsec = cpu_to_be32(ip->i_inode.i_mtime.tv_nsec);
 	str->di_ctime_nsec = cpu_to_be32(ip->i_inode.i_ctime.tv_nsec);
@@ -1296,7 +1296,7 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 	printk(KERN_INFO "  i_height = %u\n", ip->i_height);
 	printk(KERN_INFO "  i_depth = %u\n", ip->i_depth);
 	printk(KERN_INFO "  i_entries = %u\n", ip->i_entries);
-	printk(KERN_INFO "  di_eattr = %llu\n",
-	       (unsigned long long)di->di_eattr);
+	printk(KERN_INFO "  i_eattr = %llu\n",
+	       (unsigned long long)ip->i_eattr);
 }
 
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 2cb744b..aee6cba 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -502,7 +502,7 @@ static void gfs2_delete_inode(struct inode *inode)
 			goto out_unlock;
 	}
 
-	if (ip->i_di.di_eattr) {
+	if (ip->i_eattr) {
 		error = gfs2_ea_dealloc(ip);
 		if (error)
 			goto out_unlock;
-- 
1.6.0.3

