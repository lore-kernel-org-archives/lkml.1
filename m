Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbXJDJ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbXJDJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759562AbXJDJSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759560AbXJDJSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:12 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Wendy Cheng <wcheng@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 31/51] [GFS2] fix inode meta data corruption
Date: Thu,  4 Oct 2007 09:49:24 +0100
Message-Id: <11914878472056-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1191487846406-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
 <11914878422398-git-send-email-swhiteho@redhat.com>
 <1191487844772-git-send-email-swhiteho@redhat.com>
 <1191487846406-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wendy Cheng <wcheng@redhat.com>

Fix a nasty inode meta data corruption issue by keeping the buffer head in
icache array. This buffer needs to stay in memory until journal flush occurs
Otherwise, gfs2_meta_inode_buffer could do a disk read before the inode hits
disk. It ends up with meta data corruptions. The buffer will be released as
part of the existing journal flush logic.

Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 34f7bcd..013f00b 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -244,6 +244,11 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	return 0;
 }
 
+static void gfs2_inode_bh(struct gfs2_inode *ip, struct buffer_head *bh)
+{
+	ip->i_cache[0] = bh;
+}
+
 /**
  * gfs2_inode_refresh - Refresh the incore copy of the dinode
  * @ip: The GFS2 inode
@@ -688,7 +693,7 @@ out:
 static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 			const struct gfs2_inum_host *inum, unsigned int mode,
 			unsigned int uid, unsigned int gid,
-			const u64 *generation, dev_t dev)
+			const u64 *generation, dev_t dev, struct buffer_head **bhp)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_dinode *di;
@@ -743,13 +748,15 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	di->di_mtime_nsec = cpu_to_be32(tv.tv_nsec);
 	di->di_ctime_nsec = cpu_to_be32(tv.tv_nsec);
 	memset(&di->di_reserved, 0, sizeof(di->di_reserved));
+	
+	set_buffer_uptodate(dibh);
 
-	brelse(dibh);
+	*bhp = dibh;
 }
 
 static int make_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 		       unsigned int mode, const struct gfs2_inum_host *inum,
-		       const u64 *generation, dev_t dev)
+		       const u64 *generation, dev_t dev, struct buffer_head **bhp)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	unsigned int uid, gid;
@@ -770,7 +777,7 @@ static int make_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	if (error)
 		goto out_quota;
 
-	init_dinode(dip, gl, inum, mode, uid, gid, generation, dev);
+	init_dinode(dip, gl, inum, mode, uid, gid, generation, dev, bhp);
 	gfs2_quota_change(dip, +1, uid, gid);
 	gfs2_trans_end(sdp);
 
@@ -909,6 +916,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	struct gfs2_inum_host inum = { .no_addr = 0, .no_formal_ino = 0 };
 	int error;
 	u64 generation;
+	struct buffer_head *bh=NULL;
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -935,7 +943,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	if (error)
 		goto fail_gunlock;
 
-	error = make_dinode(dip, ghs[1].gh_gl, mode, &inum, &generation, dev);
+	error = make_dinode(dip, ghs[1].gh_gl, mode, &inum, &generation, dev, &bh);
 	if (error)
 		goto fail_gunlock2;
 
@@ -945,6 +953,8 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	if (IS_ERR(inode))
 		goto fail_gunlock2;
 
+	gfs2_inode_bh(GFS2_I(inode), bh);
+
 	error = gfs2_inode_refresh(GFS2_I(inode));
 	if (error)
 		goto fail_gunlock2;
-- 
1.5.1.2

