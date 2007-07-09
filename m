Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbXGIQls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbXGIQls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758585AbXGIQYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579AbXGIQYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:52 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Wendy Cheng <wcheng@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Obtaining no_formal_ino from directory entry
Date: Mon,  9 Jul 2007 17:02:59 +0100
Message-Id: <11839970941232-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970921764-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
 <11839970591207-git-send-email-swhiteho@redhat.com>
 <11839970611456-git-send-email-swhiteho@redhat.com>
 <11839970633982-git-send-email-swhiteho@redhat.com>
 <11839970653759-git-send-email-swhiteho@redhat.com>
 <1183997067333-git-send-email-swhiteho@redhat.com>
 <11839970691406-git-send-email-swhiteho@redhat.com>
 <11839970711372-git-send-email-swhiteho@redhat.com>
 <1183997073435-git-send-email-swhiteho@redhat.com>
 <11839970752058-git-send-email-swhiteho@redhat.com>
 <11839970773694-git-send-email-swhiteho@redhat.com>
 <11839970793713-git-send-email-swhiteho@redhat.com>
 <11839970813260-git-send-email-swhiteho@redhat.com>
 <11839970832750-git-send-email-swhiteho@redhat.com>
 <11839970852076-git-send-email-swhiteho@redhat.com>
 <11839970871671-git-send-email-swhiteho@redhat.com>
 <1183997089710-git-send-email-swhiteho@redhat.com>
 <11839970914023-git-send-email-swhiteho@redhat.com>
 <11839970921764-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wendy Cheng <wcheng@redhat.com>

GFS2 lookup code doesn't ask for inode shared glock. This implies during
in-memory inode creation for existing file, GFS2 will not disk-read in
the inode contents. This leaves no_formal_ino un-initialized during
lookup time. The un-initialized no_formal_ino is subsequently encoded
into file handle. Clients will get ESTALE error whenever it tries to
access these files.

Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index f793e31..2beb2f4 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1498,9 +1498,10 @@ struct inode *gfs2_dir_search(struct inode *dir, const struct qstr *name)
 	if (dent) {
 		if (IS_ERR(dent))
 			return ERR_PTR(PTR_ERR(dent));
-		inode = gfs2_inode_lookup(dir->i_sb,
-					  be64_to_cpu(dent->de_inum.no_addr),
-					  be16_to_cpu(dent->de_type));
+		inode = gfs2_inode_lookup(dir->i_sb, 
+				be16_to_cpu(dent->de_type),
+				be64_to_cpu(dent->de_inum.no_addr),
+				be64_to_cpu(dent->de_inum.no_formal_ino));
 		brelse(bh);
 		return inode;
 	}
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 792d64f..26aaf54 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -86,7 +86,10 @@ static struct inode *gfs2_iget(struct super_block *sb, u64 no_addr)
  * Returns: A VFS inode, or an error
  */
 
-struct inode *gfs2_inode_lookup(struct super_block *sb, u64 no_addr, unsigned int type)
+struct inode *gfs2_inode_lookup(struct super_block *sb, 
+				unsigned int type,
+				u64 no_addr,
+				u64 no_formal_ino)
 {
 	struct inode *inode = gfs2_iget(sb, no_addr);
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -100,6 +103,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, u64 no_addr, unsigned in
 		struct gfs2_sbd *sdp = GFS2_SB(inode);
 		umode_t mode;
 		inode->i_private = ip;
+		ip->i_no_formal_ino = no_formal_ino;
 
 		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
 		if (unlikely(error))
@@ -915,7 +919,9 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	if (error)
 		goto fail_gunlock2;
 
-	inode = gfs2_inode_lookup(dir->i_sb, inum.no_addr, IF2DT(mode));
+	inode = gfs2_inode_lookup(dir->i_sb, IF2DT(mode),
+					inum.no_addr,
+					inum.no_formal_ino);
 	if (IS_ERR(inode))
 		goto fail_gunlock2;
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 35375fc..3268a2f 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -47,7 +47,8 @@ static inline void gfs2_inum_out(const struct gfs2_inode *ip,
 
 
 void gfs2_inode_attr_in(struct gfs2_inode *ip);
-struct inode *gfs2_inode_lookup(struct super_block *sb, u64 no_addr, unsigned type);
+struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
+				u64 no_addr, u64 no_formal_ino);
 struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr);
 
 int gfs2_inode_refresh(struct gfs2_inode *ip);
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index d07230e..0fe1447 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -245,7 +245,9 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb, void *inum_obj)
 	gfs2_glock_dq_uninit(&rgd_gh);
 	gfs2_glock_dq_uninit(&ri_gh);
 
-	inode = gfs2_inode_lookup(sb, inum->no_addr, fh_obj->imode);
+	inode = gfs2_inode_lookup(sb, fh_obj->imode,
+					inum->no_addr,
+					inum->no_formal_ino);
 	if (!inode)
 		goto fail;
 	if (IS_ERR(inode)) {
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index dae1d71..cf5aa50 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -236,7 +236,7 @@ fail:
 static inline struct inode *gfs2_lookup_root(struct super_block *sb,
 					     u64 no_addr)
 {
-	return gfs2_inode_lookup(sb, no_addr, DT_DIR);
+	return gfs2_inode_lookup(sb, DT_DIR, no_addr, 0);
 }
 
 static int init_sb(struct gfs2_sbd *sdp, int silent, int undo)
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 36c523d..7fb7448 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -860,18 +860,19 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 {
 	struct inode *inode;
 	u32 goal = 0;
-	u64 ino;
+	u64 no_addr;
 
 	for(;;) {
 		goal = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED,
 				    GFS2_BLKST_UNLINKED);
 		if (goal == 0)
 			return 0;
-		ino = goal + rgd->rd_data0;
-		if (ino <= *last_unlinked)
+		no_addr = goal + rgd->rd_data0;
+		if (no_addr <= *last_unlinked)
 			continue;
-		*last_unlinked = ino;
-		inode = gfs2_inode_lookup(rgd->rd_sbd->sd_vfs, ino, DT_UNKNOWN);
+		*last_unlinked = no_addr;
+		inode = gfs2_inode_lookup(rgd->rd_sbd->sd_vfs, DT_UNKNOWN,
+					no_addr, 0);
 		if (!IS_ERR(inode))
 			return inode;
 	}
-- 
1.5.1.2

