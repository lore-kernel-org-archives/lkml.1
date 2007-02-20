Return-Path: <linux-kernel-owner+w=401wt.eu-S964916AbXBTH6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916AbXBTH6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964920AbXBTH6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:58:36 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:37569 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964916AbXBTH6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:58:35 -0500
To: linux-kernel@vger.kernel.org
CC: hch@infradead.org
Subject: [patch] freevxfs: possible null pointer dereference fix
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Tue, 20 Feb 2007 10:58:08 +0300
Message-ID: <87r6slz2en.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

sb_read may return NULL, so let's explicitly check it.
Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
-------------

--=-=-=
Content-Disposition: inline; filename=diff-mm-freevxfs-sb_read-errh-fix

diff --git a/fs/freevxfs/vxfs_bmap.c b/fs/freevxfs/vxfs_bmap.c
index 2d71128..f86fd3c 100644
--- a/fs/freevxfs/vxfs_bmap.c
+++ b/fs/freevxfs/vxfs_bmap.c
@@ -137,7 +137,7 @@ vxfs_bmap_indir(struct inode *ip, long indir, int size, long block)
 
 		bp = sb_bread(ip->i_sb,
 				indir + (i / VXFS_TYPED_PER_BLOCK(ip->i_sb)));
-		if (!buffer_mapped(bp))
+		if (!bp || !buffer_mapped(bp))
 			return 0;
 
 		typ = ((struct vxfs_typed *)bp->b_data) +
diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index 098a915..d1f7c5b 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -99,7 +99,7 @@ vxfs_blkiget(struct super_block *sbp, u_long extent, ino_t ino)
 	offset = ((ino % (sbp->s_blocksize / VXFS_ISIZE)) * VXFS_ISIZE);
 	bp = sb_bread(sbp, block);
 
-	if (buffer_mapped(bp)) {
+	if (bp && buffer_mapped(bp)) {
 		struct vxfs_inode_info	*vip;
 		struct vxfs_dinode	*dip;
 

--=-=-=--

