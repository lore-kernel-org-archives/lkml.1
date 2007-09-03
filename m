Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbXICC3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbXICC3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbXICCZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:28 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57631 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbXICCY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:29 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 20/32] Unionfs: lower nameidata support
Date: Sun,  2 Sep 2007 22:20:43 -0400
Message-Id: <11887860582413-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Create and free custom nameidata structures, and pass them to lower file
systems when needed via vfs_create.  (This code will get updated when/if
nameidata is split into an intent structure and a VFS-level only structure.)

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |    8 ++++++-
 fs/unionfs/lookup.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/unionfs/rename.c |   15 +++++++++++-
 fs/unionfs/subr.c   |   14 ++++++++++-
 fs/unionfs/union.h  |    2 +
 5 files changed, 92 insertions(+), 5 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 9c476cd..4c45790 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -177,19 +177,25 @@ static int __copyup_ndentry(struct dentry *old_lower_dentry,
 		run_sioq(__unionfs_mknod, &args);
 		err = args.err;
 	} else if (S_ISREG(old_mode)) {
+		struct nameidata nd;
+		err = init_lower_nd(&nd, LOOKUP_CREATE);
+		if (err < 0)
+			goto out;
+		args.create.nd = &nd;
 		args.create.parent = new_lower_parent_dentry->d_inode;
 		args.create.dentry = new_lower_dentry;
 		args.create.mode = old_mode;
-		args.create.nd = NULL;
 
 		run_sioq(__unionfs_create, &args);
 		err = args.err;
+		release_lower_nd(&nd, err);
 	} else {
 		printk(KERN_ERR "unionfs: unknown inode type %d\n",
 		       old_mode);
 		BUG();
 	}
 
+out:
 	return err;
 }
 
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index d05daa5..152d421 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -564,3 +564,61 @@ void update_bstart(struct dentry *dentry)
 		unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
 	}
 }
+
+
+/*
+ * Initialize a nameidata structure (the intent part) we can pass to a lower
+ * file system.  Returns 0 on success or -error (only -ENOMEM possible).
+ * Inside that nd structure, this function may also return an allocated
+ * struct file (for open intents).  The caller, when done with this nd, must
+ * kfree the intent file (using release_lower_nd).
+ */
+int init_lower_nd(struct nameidata *nd, unsigned int flags)
+{
+	int err = 0;
+#ifdef ALLOC_LOWER_ND_FILE
+	/*
+	 * XXX: one day we may need to have the lower return an open file
+	 * for us.  It is not needed in 2.6.23-rc1 for nfs2/nfs3, but may
+	 * very well be needed for nfs4.
+	 */
+	struct file *file;
+#endif /* ALLOC_LOWER_ND_FILE */
+
+	memset(nd, 0, sizeof(struct nameidata));
+
+	switch (flags) {
+	case LOOKUP_CREATE:
+		nd->flags = LOOKUP_CREATE;
+		nd->intent.open.flags = FMODE_READ | FMODE_WRITE | O_CREAT;
+#ifdef ALLOC_LOWER_ND_FILE
+		file = kzalloc(sizeof(struct file), GFP_KERNEL);
+		if (!file) {
+			err = -ENOMEM;
+			break; /* exit switch statement and thus return */
+		}
+		nd->intent.open.file = file;
+#endif /* ALLOC_LOWER_ND_FILE */
+		break;
+	default:
+		/*
+		 * We should never get here, for now.
+		 * We can add new cases here later on.
+		 */
+		BUG();
+		break;
+	}
+
+	return err;
+}
+
+void release_lower_nd(struct nameidata *nd, int err)
+{
+	if (!nd->intent.open.file)
+		return;
+	if (!err)
+		release_open_intent(nd);
+#ifdef ALLOC_LOWER_ND_FILE
+	kfree(nd->intent.open.file);
+#endif /* ALLOC_LOWER_ND_FILE */
+}
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index acf829a..a02d678 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -256,10 +256,20 @@ static int do_unionfs_rename(struct inode *old_dir,
 	 */
 	if ((old_bstart != old_bend) || (do_copyup != -1)) {
 		struct dentry *lower_parent;
-		BUG_ON(!wh_old || wh_old->d_inode || bwh_old < 0);
+		struct nameidata nd;
+		if (!wh_old || wh_old->d_inode || bwh_old < 0) {
+			printk(KERN_ERR "unionfs: rename error "
+			       "(wh_old=%p/%p bwh_old=%d)\n", wh_old,
+			       (wh_old ? wh_old->d_inode : NULL), bwh_old);
+			err = -EIO;
+			goto out;
+		}
+		err = init_lower_nd(&nd, LOOKUP_CREATE);
+		if (err < 0)
+			goto out;
 		lower_parent = lock_parent(wh_old);
 		local_err = vfs_create(lower_parent->d_inode, wh_old, S_IRUGO,
-				       NULL);
+				       &nd);
 		unlock_dir(lower_parent);
 		if (!local_err)
 			set_dbopaque(old_dentry, bwh_old);
@@ -272,6 +282,7 @@ static int do_unionfs_rename(struct inode *old_dir,
 			       "the source in rename!\n");
 			err = -EIO;
 		}
+		release_lower_nd(&nd, local_err);
 	}
 
 out:
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index 5db9e62..b7e7904 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -29,6 +29,7 @@ int create_whiteout(struct dentry *dentry, int start)
 	struct dentry *lower_dir_dentry;
 	struct dentry *lower_dentry;
 	struct dentry *lower_wh_dentry;
+	struct nameidata nd;
 	char *name = NULL;
 	int err = -EINVAL;
 
@@ -82,14 +83,18 @@ int create_whiteout(struct dentry *dentry, int start)
 			goto out;
 		}
 
+		err = init_lower_nd(&nd, LOOKUP_CREATE);
+		if (err < 0)
+			goto out;
 		lower_dir_dentry = lock_parent(lower_wh_dentry);
 		if (!(err = is_robranch_super(dentry->d_sb, bindex)))
 			err = vfs_create(lower_dir_dentry->d_inode,
 					 lower_wh_dentry,
 					 ~current->fs->umask & S_IRWXUGO,
-					 NULL);
+					 &nd);
 		unlock_dir(lower_dir_dentry);
 		dput(lower_wh_dentry);
+		release_lower_nd(&nd, err);
 
 		if (!err || !IS_COPYUP_ERR(err))
 			break;
@@ -151,6 +156,7 @@ int make_dir_opaque(struct dentry *dentry, int bindex)
 	int err = 0;
 	struct dentry *lower_dentry, *diropq;
 	struct inode *lower_dir;
+	struct nameidata nd;
 
 	lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
 	lower_dir = lower_dentry->d_inode;
@@ -165,10 +171,14 @@ int make_dir_opaque(struct dentry *dentry, int bindex)
 		goto out;
 	}
 
+	err = init_lower_nd(&nd, LOOKUP_CREATE);
+	if (err < 0)
+		goto out;
 	if (!diropq->d_inode)
-		err = vfs_create(lower_dir, diropq, S_IRUGO, NULL);
+		err = vfs_create(lower_dir, diropq, S_IRUGO, &nd);
 	if (!err)
 		set_dbopaque(dentry, bindex);
+	release_lower_nd(&nd, err);
 
 	dput(diropq);
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 0fa8ae0..9f3e68a 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -248,6 +248,8 @@ static inline void unionfs_double_lock_dentry(struct dentry *d1,
 extern int new_dentry_private_data(struct dentry *dentry);
 extern void free_dentry_private_data(struct dentry *dentry);
 extern void update_bstart(struct dentry *dentry);
+extern int init_lower_nd(struct nameidata *nd, unsigned int flags);
+extern void release_lower_nd(struct nameidata *nd, int err);
 
 /*
  * EXTERNALS:
-- 
1.5.2.2.238.g7cbf2f2

