Return-Path: <linux-kernel-owner+w=401wt.eu-S1762407AbYETKBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762407AbYETKBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765298AbYETKAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:00:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765578AbYETKAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:00:15 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/3] [GFS2] filesystem consistency error from do_strip
Date: Tue, 20 May 2008 10:12:42 +0100
Message-Id: <12112747723560-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1211274764371-git-send-email-swhiteho@redhat.com>
References: <1211274764371-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a GFS2 filesystem consistency error reported from
function do_strip.  The problem was caused by a timing window
that allowed two vfs inodes to be created in memory that point
to the same file.  The problem is fixed by making the vfs's
iget_test, iget_set mechanism check and set a new bit in the
in-core gfs2_inode structure while the vfs inode spin_lock is held.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index d31bada..07d84d1 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -249,7 +249,7 @@ static int inode_go_lock(struct gfs2_holder *gh)
 	struct gfs2_inode *ip = gl->gl_object;
 	int error = 0;
 
-	if (!ip)
+	if (!ip || (gh->gh_flags & GL_SKIP))
 		return 0;
 
 	if (test_bit(GIF_INVALID, &ip->i_flags)) {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 9c2c0b9..eabe5ea 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -236,6 +236,7 @@ enum {
 	GIF_INVALID		= 0,
 	GIF_QD_LOCKED		= 1,
 	GIF_SW_PAGED		= 3,
+	GIF_USER                = 4, /* user inode, not metadata addr space */
 };
 
 struct gfs2_dinode_host {
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 3a9ef52..09453d0 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -47,8 +47,7 @@ static int iget_test(struct inode *inode, void *opaque)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	u64 *no_addr = opaque;
 
-	if (ip->i_no_addr == *no_addr &&
-	    inode->i_private != NULL)
+	if (ip->i_no_addr == *no_addr && test_bit(GIF_USER, &ip->i_flags))
 		return 1;
 
 	return 0;
@@ -61,6 +60,7 @@ static int iget_set(struct inode *inode, void *opaque)
 
 	inode->i_ino = (unsigned long)*no_addr;
 	ip->i_no_addr = *no_addr;
+	set_bit(GIF_USER, &ip->i_flags);
 	return 0;
 }
 
@@ -86,7 +86,7 @@ static int iget_skip_test(struct inode *inode, void *opaque)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_skip_data *data = opaque;
 
-	if (ip->i_no_addr == data->no_addr && inode->i_private != NULL){
+	if (ip->i_no_addr == data->no_addr && test_bit(GIF_USER, &ip->i_flags)){
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)){
 			data->skipped = 1;
 			return 0;
@@ -105,6 +105,7 @@ static int iget_skip_set(struct inode *inode, void *opaque)
 		return 1;
 	inode->i_ino = (unsigned long)(data->no_addr);
 	ip->i_no_addr = data->no_addr;
+	set_bit(GIF_USER, &ip->i_flags);
 	return 0;
 }
 
@@ -166,7 +167,7 @@ void gfs2_set_iop(struct inode *inode)
  * Returns: A VFS inode, or an error
  */
 
-struct inode *gfs2_inode_lookup(struct super_block *sb, 
+struct inode *gfs2_inode_lookup(struct super_block *sb,
 				unsigned int type,
 				u64 no_addr,
 				u64 no_formal_ino, int skip_freeing)
@@ -187,7 +188,6 @@ struct inode *gfs2_inode_lookup(struct super_block *sb,
 
 	if (inode->i_state & I_NEW) {
 		struct gfs2_sbd *sdp = GFS2_SB(inode);
-		inode->i_private = ip;
 		ip->i_no_formal_ino = no_formal_ino;
 
 		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 85aea27..78d75f8 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -69,13 +69,15 @@ static const struct address_space_operations aspace_aops = {
 struct inode *gfs2_aspace_get(struct gfs2_sbd *sdp)
 {
 	struct inode *aspace;
+	struct gfs2_inode *ip;
 
 	aspace = new_inode(sdp->sd_vfs);
 	if (aspace) {
 		mapping_set_gfp_mask(aspace->i_mapping, GFP_NOFS);
 		aspace->i_mapping->a_ops = &aspace_aops;
 		aspace->i_size = ~0ULL;
-		aspace->i_private = NULL;
+		ip = GFS2_I(aspace);
+		clear_bit(GIF_USER, &ip->i_flags);
 		insert_inode_hash(aspace);
 	}
 	return aspace;
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 2278c68..0b7cc92 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -52,7 +52,7 @@ static int gfs2_write_inode(struct inode *inode, int sync)
 	struct gfs2_inode *ip = GFS2_I(inode);
 
 	/* Check this is a "normal" inode */
-	if (inode->i_private) {
+	if (test_bit(GIF_USER, &ip->i_flags)) {
 		if (current->flags & PF_MEMALLOC)
 			return 0;
 		if (sync)
@@ -297,8 +297,9 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
  */
 static void gfs2_drop_inode(struct inode *inode)
 {
-	if (inode->i_private && inode->i_nlink) {
-		struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_inode *ip = GFS2_I(inode);
+
+	if (test_bit(GIF_USER, &ip->i_flags) && inode->i_nlink) {
 		struct gfs2_glock *gl = ip->i_iopen_gh.gh_gl;
 		if (gl && test_bit(GLF_DEMOTE, &gl->gl_flags))
 			clear_nlink(inode);
@@ -314,12 +315,13 @@ static void gfs2_drop_inode(struct inode *inode)
 
 static void gfs2_clear_inode(struct inode *inode)
 {
+	struct gfs2_inode *ip = GFS2_I(inode);
+
 	/* This tells us its a "real" inode and not one which only
 	 * serves to contain an address space (see rgrp.c, meta_io.c)
 	 * which therefore doesn't have its own glocks.
 	 */
-	if (inode->i_private) {
-		struct gfs2_inode *ip = GFS2_I(inode);
+	if (test_bit(GIF_USER, &ip->i_flags)) {
 		ip->i_gl->gl_object = NULL;
 		gfs2_glock_schedule_for_reclaim(ip->i_gl);
 		gfs2_glock_put(ip->i_gl);
@@ -419,7 +421,7 @@ static void gfs2_delete_inode(struct inode *inode)
 	struct gfs2_holder gh;
 	int error;
 
-	if (!inode->i_private)
+	if (!test_bit(GIF_USER, &ip->i_flags))
 		goto out;
 
 	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
-- 
1.5.1.2

