Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbXKZQrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbXKZQrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbXKZQpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:44 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52791 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbXKZQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:34 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 08/16] Unionfs: release lower resources on successful rmdir
Date: Mon, 26 Nov 2007 11:44:05 -0500
Message-Id: <1196095456701-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents those resources from lingering around until memory
pressure would have forced them out.  The patch also properly handles
directories that have been rmdir'ed which are still some process's cwd.

CC: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c  |    3 ++-
 fs/unionfs/mmap.c   |    5 ++++-
 fs/unionfs/unlink.c |   33 ++++++++++++++++++++++++++++-----
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 9c144be..ef61d9c 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -944,7 +944,8 @@ static int unionfs_permission(struct inode *inode, int mask,
 		 * dentry+inode.  This should be equivalent to issuing
 		 * __unionfs_d_revalidate_chain on nd.dentry here.
 		 */
-		err = -ESTALE;	/* force revalidate */
+		if (is_file)	/* dirs can be unlinked but chdir'ed to */
+			err = -ESTALE;	/* force revalidate */
 		goto out;
 	}
 
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 1e10280..3f65e52 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -123,8 +123,11 @@ static int unionfs_writepages(struct address_space *mapping,
 	struct inode *inode;
 
 	inode = mapping->host;
+	if (ibstart(inode) < 0 && ibend(inode) < 0)
+		goto out;
 	lower_inode = unionfs_lower_inode(inode);
-	BUG_ON(!lower_inode);
+	if (!lower_inode)
+		goto out;
 
 	if (!mapping_cap_writeback_dirty(lower_inode->i_mapping))
 		goto out;
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index a8de672..f65245d 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -148,6 +148,7 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int err = 0;
 	struct unionfs_dir_state *namelist = NULL;
+	int dstart, dend;
 
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
@@ -164,28 +165,50 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 		goto out;
 
 	err = unionfs_rmdir_first(dir, dentry, namelist);
+	dstart = dbstart(dentry);
+	dend = dbend(dentry);
 	/* create whiteout */
 	if (!err) {
-		err = create_whiteout(dentry, dbstart(dentry));
+		err = create_whiteout(dentry, dstart);
 	} else {
 		int new_err;
 
-		if (dbstart(dentry) == 0)
+		if (dstart == 0)
 			goto out;
 
 		/* exit if the error returned was NOT -EROFS */
 		if (!IS_COPYUP_ERR(err))
 			goto out;
 
-		new_err = create_whiteout(dentry, dbstart(dentry) - 1);
+		new_err = create_whiteout(dentry, dstart - 1);
 		if (new_err != -EEXIST)
 			err = new_err;
 	}
 
 out:
-	/* call d_drop so the system "forgets" about us */
-	if (!err)
+	/*
+	 * Drop references to lower dentry/inode so storage space for them
+	 * can be reclaimed.  Then, call d_drop so the system "forgets"
+	 * about us.
+	 */
+	if (!err) {
+		struct inode *inode = dentry->d_inode;
+		BUG_ON(!inode);
+		iput(unionfs_lower_inode_idx(inode, dstart));
+		unionfs_set_lower_inode_idx(inode, dstart, NULL);
+		dput(unionfs_lower_dentry_idx(dentry, dstart));
+		unionfs_set_lower_dentry_idx(dentry, dstart, NULL);
+		/*
+		 * If the last directory is unlinked, then mark istart/end
+		 * as -1, (to maintain the invariant that if there are no
+		 * lower objects, then branch index start and end are set to
+		 * -1).
+		 */
+		if (!unionfs_lower_inode_idx(inode, dstart) &&
+		    !unionfs_lower_inode_idx(inode, dend))
+			ibstart(inode) = ibend(inode) = -1;
 		d_drop(dentry);
+	}
 
 	if (namelist)
 		free_rdstate(namelist);
-- 
1.5.2.2

