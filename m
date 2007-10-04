Return-Path: <linux-kernel-owner+w=401wt.eu-S1762019AbXJDJff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762019AbXJDJff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759735AbXJDJSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759661AbXJDJSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:39 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 47/51] [GFS2] Alternate gfs2_iget to avoid looking up inodes being freed
Date: Thu,  4 Oct 2007 09:49:40 +0100
Message-Id: <11914878753861-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <119148787317-git-send-email-swhiteho@redhat.com>
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
 <11914878472056-git-send-email-swhiteho@redhat.com>
 <11914878492645-git-send-email-swhiteho@redhat.com>
 <11914878513555-git-send-email-swhiteho@redhat.com>
 <11914878521254-git-send-email-swhiteho@redhat.com>
 <119148785427-git-send-email-swhiteho@redhat.com>
 <11914878551328-git-send-email-swhiteho@redhat.com>
 <11914878571888-git-send-email-swhiteho@redhat.com>
 <11914878592314-git-send-email-swhiteho@redhat.com>
 <1191487861683-git-send-email-swhiteho@redhat.com>
 <11914878632211-git-send-email-swhiteho@redhat.com>
 <1191487864951-git-send-email-swhiteho@redhat.com>
 <11914878661743-git-send-email-swhiteho@redhat.com>
 <11914878683674-git-send-email-swhiteho@redhat.com>
 <1191487870444-git-send-email-swhiteho@redhat.com>
 <1191487872941-git-send-email-swhiteho@redhat.com>
 <119148787317-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

There is a possible deadlock between two processes on the same node, where one
process is deleting an inode, and another process is looking for allocated but
unused inodes to delete in order to create more space.

process A does an iput() on inode X, and it's i_count drops to 0. This causes
iput_final() to be called, which puts an inode into state I_FREEING at
generic_delete_inode(). There no point between when iput_final() is called, and
when I_FREEING is set where GFS2 could acquire any glocks. Once I_FREEING is
set, no other process on that node can successfully look up that inode until
the delete finishes.

process B locks the the resource group for the same inode in get_local_rgrp(),
which is called by gfs2_inplace_reserve_i()

process A tries to lock the resource group for the inode in
gfs2_dinode_dealloc(), but it's already locked by process B

process B waits in find_inode for the inode to have the I_FREEING state cleared.

Deadlock.

This patch solves the problem by adding an alternative to gfs2_iget(),
gfs2_iget_skip(), that simply skips any inodes that are in the I_FREEING
state.o The alternate test function is just like the original one, except that
it fails if the inode is being freed, and sets a skipped flag. The alternate
set function is just like the original, except that it fails if the skipped
flag is set. Only try_rgrp_unlink() calls gfs2_iget_skip() instead of
gfs2_iget().

Signed-off-by: Benjamin E. Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 08c6dd0..9949bb7 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1502,7 +1502,7 @@ struct inode *gfs2_dir_search(struct inode *dir, const struct qstr *name)
 		inode = gfs2_inode_lookup(dir->i_sb, 
 				be16_to_cpu(dent->de_type),
 				be64_to_cpu(dent->de_inum.no_addr),
-				be64_to_cpu(dent->de_inum.no_formal_ino));
+				be64_to_cpu(dent->de_inum.no_formal_ino), 0);
 		brelse(bh);
 		return inode;
 	}
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 013f00b..5f6dc32 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -77,6 +77,49 @@ static struct inode *gfs2_iget(struct super_block *sb, u64 no_addr)
 	return iget5_locked(sb, hash, iget_test, iget_set, &no_addr);
 }
 
+struct gfs2_skip_data {
+	u64	no_addr;
+	int	skipped;
+};
+
+static int iget_skip_test(struct inode *inode, void *opaque)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_skip_data *data = opaque;
+
+	if (ip->i_no_addr == data->no_addr && inode->i_private != NULL){
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)){
+			data->skipped = 1;
+			return 0;
+		}
+		return 1;
+	}
+	return 0;
+}
+
+static int iget_skip_set(struct inode *inode, void *opaque)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_skip_data *data = opaque;
+
+	if (data->skipped)
+		return 1;
+	inode->i_ino = (unsigned long)(data->no_addr);
+	ip->i_no_addr = data->no_addr;
+	return 0;
+}
+
+static struct inode *gfs2_iget_skip(struct super_block *sb,
+				    u64 no_addr)
+{
+	struct gfs2_skip_data data;
+	unsigned long hash = (unsigned long)no_addr;
+
+	data.no_addr = no_addr;
+	data.skipped = 0;
+	return iget5_locked(sb, hash, iget_skip_test, iget_skip_set, &data);
+}
+
 /**
  * GFS2 lookup code fills in vfs inode contents based on info obtained
  * from directory entry inside gfs2_inode_lookup(). This has caused issues
@@ -112,6 +155,7 @@ void gfs2_set_iop(struct inode *inode)
  * @sb: The super block
  * @no_addr: The inode number
  * @type: The type of the inode
+ * @skip_freeing: set this not return an inode if it is currently being freed.
  *
  * Returns: A VFS inode, or an error
  */
@@ -119,13 +163,19 @@ void gfs2_set_iop(struct inode *inode)
 struct inode *gfs2_inode_lookup(struct super_block *sb, 
 				unsigned int type,
 				u64 no_addr,
-				u64 no_formal_ino)
+				u64 no_formal_ino, int skip_freeing)
 {
-	struct inode *inode = gfs2_iget(sb, no_addr);
-	struct gfs2_inode *ip = GFS2_I(inode);
+	struct inode *inode;
+	struct gfs2_inode *ip;
 	struct gfs2_glock *io_gl;
 	int error;
 
+	if (skip_freeing)
+		inode = gfs2_iget_skip(sb, no_addr);
+	else
+		inode = gfs2_iget(sb, no_addr);
+	ip = GFS2_I(inode);
+
 	if (!inode)
 		return ERR_PTR(-ENOBUFS);
 
@@ -949,7 +999,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 
 	inode = gfs2_inode_lookup(dir->i_sb, IF2DT(mode),
 					inum.no_addr,
-					inum.no_formal_ino);
+					inum.no_formal_ino, 0);
 	if (IS_ERR(inode))
 		goto fail_gunlock2;
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 4517ac8..351ac87 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -49,7 +49,8 @@ static inline void gfs2_inum_out(const struct gfs2_inode *ip,
 void gfs2_inode_attr_in(struct gfs2_inode *ip);
 void gfs2_set_iop(struct inode *inode);
 struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
-				u64 no_addr, u64 no_formal_ino);
+				u64 no_addr, u64 no_formal_ino,
+				int skip_freeing);
 struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr);
 
 int gfs2_inode_refresh(struct gfs2_inode *ip);
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index b8312ed..e2d1347 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -237,7 +237,7 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb, void *inum_obj)
 
 	inode = gfs2_inode_lookup(sb, DT_UNKNOWN,
 					inum->no_addr,
-					0);
+					0, 0);
 	if (!inode)
 		goto fail;
 	if (IS_ERR(inode)) {
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 1ac9afa..17de58e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -230,7 +230,7 @@ fail:
 static inline struct inode *gfs2_lookup_root(struct super_block *sb,
 					     u64 no_addr)
 {
-	return gfs2_inode_lookup(sb, DT_DIR, no_addr, 0);
+	return gfs2_inode_lookup(sb, DT_DIR, no_addr, 0, 0);
 }
 
 static int init_sb(struct gfs2_sbd *sdp, int silent, int undo)
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 2d7f7ea..708c287 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -884,7 +884,7 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 			continue;
 		*last_unlinked = no_addr;
 		inode = gfs2_inode_lookup(rgd->rd_sbd->sd_vfs, DT_UNKNOWN,
-					  no_addr, -1);
+					  no_addr, -1, 1);
 		if (!IS_ERR(inode))
 			return inode;
 	}
-- 
1.5.1.2

