Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbXIZDaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbXIZDaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbXIZD3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:29:53 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35213 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163AbXIZD3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:29:51 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 08/25] Unionfs: lower nameidata support for nfsv4
Date: Tue, 25 Sep 2007 23:09:47 -0400
Message-Id: <11907762081789-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass nameidata structures as needed to the lower file system, support
LOOKUP_ACCESS/OPEN intents.  This makes unionfs work on top of nfsv4.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   11 +++++++++--
 fs/unionfs/inode.c  |    8 +++++++-
 fs/unionfs/lookup.c |   20 +++++++++++++++++---
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index b21f1e3..52bcb18 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -156,8 +156,15 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 		if (!lower_dentry || !lower_dentry->d_op
 		    || !lower_dentry->d_op->d_revalidate)
 			continue;
-		if (!lower_dentry->d_op->d_revalidate(lower_dentry,
-						      &lowernd))
+		/*
+		 * Don't pass nameidata to lower file system, because we
+		 * don't want an arbitrary lower file being opened or
+		 * returned to us: it may be useless to us because of the
+		 * fanout nature of unionfs (cf. file/directory open-file
+		 * invariants).  We will open lower files as and when needed
+		 * later on.
+		 */
+		if (!lower_dentry->d_op->d_revalidate(lower_dentry, NULL))
 			valid = false;
 	}
 
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index f8b2c88..7ee4760 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -27,6 +27,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	struct dentry *lower_parent_dentry = NULL;
 	char *name = NULL;
 	int valid = 0;
+	struct nameidata lower_nd;
 
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
@@ -113,7 +114,12 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 		goto out;
 	}
 
-	err = vfs_create(lower_parent_dentry->d_inode, lower_dentry, mode, nd);
+	err = init_lower_nd(&lower_nd, LOOKUP_CREATE);
+	if (err < 0)
+		goto out;
+	err = vfs_create(lower_parent_dentry->d_inode, lower_dentry, mode,
+			 &lower_nd);
+	release_lower_nd(&lower_nd, err);
 
 	if (!err) {
 		err = PTR_ERR(unionfs_interpose(dentry, parent->i_sb, 0));
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 963d622..2109714 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -583,6 +583,11 @@ void update_bstart(struct dentry *dentry)
  * Inside that nd structure, this function may also return an allocated
  * struct file (for open intents).  The caller, when done with this nd, must
  * kfree the intent file (using release_lower_nd).
+ *
+ * XXX: this code, and the callers of this code, should be redone using
+ * vfs_path_lookup() when (1) the nameidata structure is refactored into a
+ * separate intent-structure, and (2) open_namei() is broken into a VFS-only
+ * function and a method that other file systems can call.
  */
 int init_lower_nd(struct nameidata *nd, unsigned int flags)
 {
@@ -597,11 +602,16 @@ int init_lower_nd(struct nameidata *nd, unsigned int flags)
 #endif /* ALLOC_LOWER_ND_FILE */
 
 	memset(nd, 0, sizeof(struct nameidata));
+	if (!flags)
+		return err;
 
 	switch (flags) {
 	case LOOKUP_CREATE:
-		nd->flags = LOOKUP_CREATE;
-		nd->intent.open.flags = FMODE_READ | FMODE_WRITE | O_CREAT;
+		nd->intent.open.flags |= O_CREAT;
+		/* fall through: shared code for create/open cases */
+	case LOOKUP_OPEN:
+		nd->flags = flags;
+		nd->intent.open.flags |= (FMODE_READ | FMODE_WRITE);
 #ifdef ALLOC_LOWER_ND_FILE
 		file = kzalloc(sizeof(struct file), GFP_KERNEL);
 		if (!file) {
@@ -611,11 +621,15 @@ int init_lower_nd(struct nameidata *nd, unsigned int flags)
 		nd->intent.open.file = file;
 #endif /* ALLOC_LOWER_ND_FILE */
 		break;
+	case LOOKUP_ACCESS:
+		nd->flags = flags;
+		break;
 	default:
 		/*
 		 * We should never get here, for now.
 		 * We can add new cases here later on.
 		 */
+		dprintk("unionfs: unknown nameidata flag 0x%x\n", flags);
 		BUG();
 		break;
 	}
@@ -627,7 +641,7 @@ void release_lower_nd(struct nameidata *nd, int err)
 {
 	if (!nd->intent.open.file)
 		return;
-	if (!err)
+	else if (!err)
 		release_open_intent(nd);
 #ifdef ALLOC_LOWER_ND_FILE
 	kfree(nd->intent.open.file);
-- 
1.5.2.2

