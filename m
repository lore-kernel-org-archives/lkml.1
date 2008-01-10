Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbYAJCR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbYAJCR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbYAJCRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:17:00 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37445 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513AbYAJCQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:16:58 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 3/4] Unionfs: branch-management related locking fixes
Date: Wed,  9 Jan 2008 21:16:31 -0500
Message-Id: <11999313944186-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1199931392670-git-send-email-ezk@cs.sunysb.edu>
References: <1199931392670-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add necessary locking to dentry/inode branch-configuration, so we get
consistent values during branch-management actions.  In d_revalidate_chain,
->permission, and ->create, also lock parent dentry.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    6 ++++++
 fs/unionfs/dentry.c     |    6 +++++-
 fs/unionfs/inode.c      |   17 +++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 2c32ada..f37192f 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -318,6 +318,7 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
 	 * First revalidate the dentry inside struct file,
 	 * but not unhashed dentries.
 	 */
+reval_dentry:
 	if (unlikely(!d_deleted(dentry) &&
 		     !__unionfs_d_revalidate_chain(dentry, NULL, willwrite))) {
 		err = -ESTALE;
@@ -328,6 +329,11 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
 	dgen = atomic_read(&UNIONFS_D(dentry)->generation);
 	fgen = atomic_read(&UNIONFS_F(file)->generation);
 
+	if (unlikely(sbgen > dgen)) {
+		pr_debug("unionfs: retry dentry revalidation\n");
+		schedule();
+		goto reval_dentry;
+	}
 	BUG_ON(sbgen > dgen);
 
 	/*
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 7646828..d969640 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -203,7 +203,7 @@ bool is_newer_lower(const struct dentry *dentry)
 	if (!dentry || !UNIONFS_D(dentry))
 		return false;
 	inode = dentry->d_inode;
-	if (!inode || !UNIONFS_I(inode) ||
+	if (!inode || !UNIONFS_I(inode)->lower_inodes ||
 	    ibstart(inode) < 0 || ibend(inode) < 0)
 		return false;
 
@@ -295,6 +295,8 @@ bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
 	chain_len = 0;
 	sbgen = atomic_read(&UNIONFS_SB(dentry->d_sb)->generation);
 	dtmp = dentry->d_parent;
+	if (dentry != dtmp)
+		unionfs_lock_dentry(dtmp, UNIONFS_DMUTEX_REVAL_PARENT);
 	dgen = atomic_read(&UNIONFS_D(dtmp)->generation);
 	/* XXX: should we check if is_newer_lower all the way up? */
 	if (unlikely(is_newer_lower(dtmp))) {
@@ -315,6 +317,8 @@ bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
 		}
 		purge_inode_data(dtmp->d_inode);
 	}
+	if (dentry != dtmp)
+		unionfs_unlock_dentry(dtmp);
 	while (sbgen != dgen) {
 		/* The root entry should always be valid */
 		BUG_ON(IS_ROOT(dtmp));
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 6095c4f..e15ddb9 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -30,6 +30,13 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	struct nameidata lower_nd;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
+	unionfs_lock_dentry(dentry->d_parent, UNIONFS_DMUTEX_PARENT);
+	valid = __unionfs_d_revalidate_chain(dentry->d_parent, nd, false);
+	unionfs_unlock_dentry(dentry->d_parent);
+	if (unlikely(!valid)) {
+		err = -ESTALE;	/* same as what real_lookup does */
+		goto out;
+	}
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
 
 	valid = __unionfs_d_revalidate_chain(dentry, nd, false);
@@ -936,6 +943,14 @@ static int unionfs_permission(struct inode *inode, int mask,
 	const int is_file = !S_ISDIR(inode->i_mode);
 	const int write_mask = (mask & MAY_WRITE) && !(mask & MAY_READ);
 
+	if (nd)
+		unionfs_lock_dentry(nd->dentry, UNIONFS_DMUTEX_CHILD);
+
+	if (!UNIONFS_I(inode)->lower_inodes) {
+		if (is_file)	/* dirs can be unlinked but chdir'ed to */
+			err = -ESTALE;	/* force revalidate */
+		goto out;
+	}
 	bstart = ibstart(inode);
 	bend = ibend(inode);
 	if (unlikely(bstart < 0 || bend < 0)) {
@@ -1003,6 +1018,8 @@ static int unionfs_permission(struct inode *inode, int mask,
 out:
 	unionfs_check_inode(inode);
 	unionfs_check_nd(nd);
+	if (nd)
+		unionfs_unlock_dentry(nd->dentry);
 	return err;
 }
 
-- 
1.5.2.2

