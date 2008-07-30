Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbYG3Cqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbYG3Cqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbYG3Co1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46260 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbYG3CoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:21 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 17/19] Unionfs: permission no longer takes a nameidata parameter
Date: Tue, 29 Jul 2008 22:43:47 -0400
Message-Id: <12173858441041-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c    |   11 ++---------
 fs/unionfs/whiteout.c |    4 ++--
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 1a95e3b..0bd9fab 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -750,8 +750,7 @@ static void unionfs_put_link(struct dentry *dentry, struct nameidata *nd,
  * unionfs_permission, or anything it calls, will use stale branch
  * information.
  */
-static int unionfs_permission(struct inode *inode, int mask,
-			      struct nameidata *nd)
+static int unionfs_permission(struct inode *inode, int mask)
 {
 	struct inode *lower_inode = NULL;
 	int err = 0;
@@ -759,9 +758,6 @@ static int unionfs_permission(struct inode *inode, int mask,
 	const int is_file = !S_ISDIR(inode->i_mode);
 	const int write_mask = (mask & MAY_WRITE) && !(mask & MAY_READ);
 
-	if (nd)
-		unionfs_lock_dentry(nd->path.dentry, UNIONFS_DMUTEX_CHILD);
-
 	if (!UNIONFS_I(inode)->lower_inodes) {
 		if (is_file)	/* dirs can be unlinked but chdir'ed to */
 			err = -ESTALE;	/* force revalidate */
@@ -801,7 +797,7 @@ static int unionfs_permission(struct inode *inode, int mask,
 		 * readonly, because those conditions should lead to a
 		 * copyup taking place later on.
 		 */
-		err = permission(lower_inode, mask, nd);
+		err = inode_permission(lower_inode, mask);
 		if (err && bindex > 0) {
 			umode_t mode = lower_inode->i_mode;
 			if (is_robranch_super(inode->i_sb, bindex) &&
@@ -833,9 +829,6 @@ static int unionfs_permission(struct inode *inode, int mask,
 
 out:
 	unionfs_check_inode(inode);
-	unionfs_check_nd(nd);
-	if (nd)
-		unionfs_unlock_dentry(nd->path.dentry);
 	return err;
 }
 
diff --git a/fs/unionfs/whiteout.c b/fs/unionfs/whiteout.c
index 94b5241..db7a21e 100644
--- a/fs/unionfs/whiteout.c
+++ b/fs/unionfs/whiteout.c
@@ -455,7 +455,7 @@ int delete_whiteouts(struct dentry *dentry, int bindex,
 	lower_dir = lower_dir_dentry->d_inode;
 	BUG_ON(!S_ISDIR(lower_dir->i_mode));
 
-	if (!permission(lower_dir, MAY_WRITE | MAY_EXEC, NULL)) {
+	if (!inode_permission(lower_dir, MAY_WRITE | MAY_EXEC)) {
 		err = do_delete_whiteouts(dentry, bindex, namelist);
 	} else {
 		args.deletewh.namelist = namelist;
@@ -492,7 +492,7 @@ int is_opaque_dir(struct dentry *dentry, int bindex)
 
 	mutex_lock(&lower_inode->i_mutex);
 
-	if (!permission(lower_inode, MAY_EXEC, NULL)) {
+	if (!inode_permission(lower_inode, MAY_EXEC)) {
 		wh_lower_dentry =
 			lookup_one_len(UNIONFS_DIR_OPAQUE, lower_dentry,
 				       sizeof(UNIONFS_DIR_OPAQUE) - 1);
-- 
1.5.2.2

