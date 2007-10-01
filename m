Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbXJAFz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbXJAFz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXJAFwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:52:01 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40828 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbXJAFvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:42 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 02/19] Unionfs: add un/likely on conditionals
Date: Mon,  1 Oct 2007 01:50:39 -0400
Message-Id: <11912178572735-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   34 +++++++-------
 fs/unionfs/copyup.c     |   18 ++++----
 fs/unionfs/debug.c      |  108 +++++++++++++++++++++++++----------------------
 fs/unionfs/dentry.c     |   25 ++++++-----
 fs/unionfs/dirfops.c    |    6 +-
 fs/unionfs/dirhelper.c  |    6 +-
 fs/unionfs/fanout.h     |    6 +-
 fs/unionfs/file.c       |   16 ++++----
 fs/unionfs/inode.c      |   42 +++++++++---------
 fs/unionfs/lookup.c     |   12 +++---
 fs/unionfs/main.c       |   26 ++++++------
 fs/unionfs/mmap.c       |    4 +-
 fs/unionfs/rdstate.c    |    8 ++--
 fs/unionfs/rename.c     |   14 +++---
 fs/unionfs/subr.c       |    8 ++--
 fs/unionfs/super.c      |   24 +++++-----
 fs/unionfs/unlink.c     |    4 +-
 fs/unionfs/xattr.c      |   10 ++--
 18 files changed, 189 insertions(+), 182 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index e69ccf6..8550a34 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -74,7 +74,7 @@ retry:
 	err = copyup_named_file(dentry->d_parent->d_inode, file, name, bstart,
 				bindex, file->f_path.dentry->d_inode->i_size);
 	if (err) {
-		if (err == -EEXIST)
+		if (unlikely(err == -EEXIST))
 			goto retry;
 		goto out;
 	}
@@ -126,7 +126,7 @@ static void cleanup_file(struct file *file)
 		 */
 		old_bid = UNIONFS_F(file)->saved_branch_ids[bindex];
 		i = branch_id_to_idx(sb, old_bid);
-		if (i < 0) {
+		if (unlikely(i < 0)) {
 			printk(KERN_ERR "unionfs: no superblock for "
 			       "file %p\n", file);
 			continue;
@@ -317,8 +317,8 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
 	 * First revalidate the dentry inside struct file,
 	 * but not unhashed dentries.
 	 */
-	if (!d_deleted(dentry) &&
-	    !__unionfs_d_revalidate_chain(dentry, NULL, willwrite)) {
+	if (unlikely(!d_deleted(dentry) &&
+		     !__unionfs_d_revalidate_chain(dentry, NULL, willwrite))) {
 		err = -ESTALE;
 		goto out_nofree;
 	}
@@ -335,8 +335,8 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
 	 * someone has copied up this file from underneath us, we also need
 	 * to refresh things.
 	 */
-	if (!d_deleted(dentry) &&
-	    (sbgen > fgen || dbstart(dentry) != fbstart(file))) {
+	if (unlikely(!d_deleted(dentry) &&
+		     (sbgen > fgen || dbstart(dentry) != fbstart(file)))) {
 		/* save orig branch ID */
 		int orig_brid =	UNIONFS_F(file)->saved_branch_ids[fbstart(file)];
 
@@ -349,13 +349,13 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
 
 		size = sizeof(struct file *) * sbmax(sb);
 		UNIONFS_F(file)->lower_files = kzalloc(size, GFP_KERNEL);
-		if (!UNIONFS_F(file)->lower_files) {
+		if (unlikely(!UNIONFS_F(file)->lower_files)) {
 			err = -ENOMEM;
 			goto out;
 		}
 		size = sizeof(int) * sbmax(sb);
 		UNIONFS_F(file)->saved_branch_ids = kzalloc(size, GFP_KERNEL);
-		if (!UNIONFS_F(file)->saved_branch_ids) {
+		if (unlikely(!UNIONFS_F(file)->saved_branch_ids)) {
 			err = -ENOMEM;
 			goto out;
 		}
@@ -373,7 +373,7 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
 				goto out;
 			new_brid = UNIONFS_F(file)->
 			  saved_branch_ids[fbstart(file)];
-			if (new_brid != orig_brid && sbgen > fgen) {
+			if (unlikely(new_brid != orig_brid && sbgen > fgen)) {
 				/*
 				 * If we re-opened the file on a different
 				 * branch than the original one, and this
@@ -520,7 +520,7 @@ int unionfs_open(struct inode *inode, struct file *file)
 
 	file->private_data =
 		kzalloc(sizeof(struct unionfs_file_info), GFP_KERNEL);
-	if (!UNIONFS_F(file)) {
+	if (unlikely(!UNIONFS_F(file))) {
 		err = -ENOMEM;
 		goto out_nofree;
 	}
@@ -531,13 +531,13 @@ int unionfs_open(struct inode *inode, struct file *file)
 
 	size = sizeof(struct file *) * sbmax(inode->i_sb);
 	UNIONFS_F(file)->lower_files = kzalloc(size, GFP_KERNEL);
-	if (!UNIONFS_F(file)->lower_files) {
+	if (unlikely(!UNIONFS_F(file)->lower_files)) {
 		err = -ENOMEM;
 		goto out;
 	}
 	size = sizeof(int) * sbmax(inode->i_sb);
 	UNIONFS_F(file)->saved_branch_ids = kzalloc(size, GFP_KERNEL);
-	if (!UNIONFS_F(file)->saved_branch_ids) {
+	if (unlikely(!UNIONFS_F(file)->saved_branch_ids)) {
 		err = -ENOMEM;
 		goto out;
 	}
@@ -612,7 +612,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 	 * This is important for open-but-unlinked files, as well as mmap
 	 * support.
 	 */
-	if ((err = unionfs_file_revalidate(file, true)))
+	if (unlikely((err = unionfs_file_revalidate(file, true))))
 		goto out;
 	unionfs_check_file(file);
 	fileinfo = UNIONFS_F(file);
@@ -716,7 +716,7 @@ static int unionfs_ioctl_queryfile(struct file *file, unsigned int cmd,
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
 		if (!lower_dentry)
 			continue;
-		if (lower_dentry->d_inode)
+		if (likely(lower_dentry->d_inode))
 			FD_SET(bindex, &branchlist);
 		/* purge any lower objects after partial_lookup */
 		if (bindex < orig_bstart || bindex > orig_bend) {
@@ -739,7 +739,7 @@ static int unionfs_ioctl_queryfile(struct file *file, unsigned int cmd,
 	ibend(dentry->d_inode) = orig_bend;
 
 	err = copy_to_user((void __user *)arg, &branchlist, sizeof(fd_set));
-	if (err)
+	if (unlikely(err))
 		err = -EFAULT;
 
 out:
@@ -753,7 +753,7 @@ long unionfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 
-	if ((err = unionfs_file_revalidate(file, true)))
+	if (unlikely((err = unionfs_file_revalidate(file, true))))
 		goto out;
 
 	/* check if asked for local commands */
@@ -791,7 +791,7 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 
 	unionfs_read_lock(dentry->d_sb);
 
-	if ((err = unionfs_file_revalidate(file, true)))
+	if (unlikely((err = unionfs_file_revalidate(file, true))))
 		goto out;
 	unionfs_check_file(file);
 
diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 23ac4c8..4eb5f82 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -43,7 +43,7 @@ static int copyup_xattrs(struct dentry *old_lower_dentry,
 
 	/* allocate space for the actual list */
 	name_list = unionfs_xattr_alloc(list_size + 1, XATTR_LIST_MAX);
-	if (!name_list || IS_ERR(name_list)) {
+	if (unlikely(!name_list || IS_ERR(name_list))) {
 		err = PTR_ERR(name_list);
 		goto out;
 	}
@@ -59,7 +59,7 @@ static int copyup_xattrs(struct dentry *old_lower_dentry,
 
 	/* allocate space to hold each xattr's value */
 	attr_value = unionfs_xattr_alloc(XATTR_SIZE_MAX, XATTR_SIZE_MAX);
-	if (!attr_value || IS_ERR(attr_value)) {
+	if (unlikely(!attr_value || IS_ERR(attr_value))) {
 		err = PTR_ERR(name_list);
 		goto out;
 	}
@@ -198,7 +198,7 @@ static int __copyup_ndentry(struct dentry *old_lower_dentry,
 	} else if (S_ISREG(old_mode)) {
 		struct nameidata nd;
 		err = init_lower_nd(&nd, LOOKUP_CREATE);
-		if (err < 0)
+		if (unlikely(err < 0))
 			goto out;
 		args.create.nd = &nd;
 		args.create.parent = new_lower_parent_dentry->d_inode;
@@ -245,7 +245,7 @@ static int __copyup_reg_data(struct dentry *dentry,
 		err = PTR_ERR(input_file);
 		goto out;
 	}
-	if (!input_file->f_op || !input_file->f_op->read) {
+	if (unlikely(!input_file->f_op || !input_file->f_op->read)) {
 		err = -EINVAL;
 		goto out_close_in;
 	}
@@ -260,14 +260,14 @@ static int __copyup_reg_data(struct dentry *dentry,
 		err = PTR_ERR(output_file);
 		goto out_close_in2;
 	}
-	if (!output_file->f_op || !output_file->f_op->write) {
+	if (unlikely(!output_file->f_op || !output_file->f_op->write)) {
 		err = -EINVAL;
 		goto out_close_out;
 	}
 
 	/* allocating a buffer */
 	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!buf) {
+	if (unlikely(!buf)) {
 		err = -ENOMEM;
 		goto out_close_out;
 	}
@@ -412,7 +412,7 @@ int copyup_dentry(struct inode *dir, struct dentry *dentry, int bstart,
 	if (S_ISLNK(old_lower_dentry->d_inode->i_mode)) {
 
 		symbuf = kmalloc(PATH_MAX, GFP_KERNEL);
-		if (!symbuf) {
+		if (unlikely(!symbuf)) {
 			__clear(dentry, old_lower_dentry,
 				old_bstart, old_bend,
 				new_lower_dentry, new_bindex);
@@ -692,7 +692,7 @@ struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
 	/* There is no sense allocating any less than the minimum. */
 	nr_dentry = 1;
 	path = kmalloc(nr_dentry * sizeof(struct dentry *), GFP_KERNEL);
-	if (!path)
+	if (unlikely(!path))
 		goto out;
 
 	/* assume the negative dentry of unionfs as the parent dentry */
@@ -725,7 +725,7 @@ struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
 			nr_dentry *= 2;
 			p = krealloc(path, nr_dentry * sizeof(struct dentry *),
 				     GFP_KERNEL);
-			if (!p) {
+			if (unlikely(!p)) {
 				lower_dentry = ERR_PTR(-ENOMEM);
 				goto out;
 			}
diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index 224773e..b103eb9 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -49,19 +49,19 @@ void __unionfs_check_inode(const struct inode *inode,
 	sb = inode->i_sb;
 	istart = ibstart(inode);
 	iend = ibend(inode);
-	if (istart > iend) {
+	if (unlikely(istart > iend)) {
 		PRINT_CALLER(fname, fxn, line);
 		printk(" Ci0: inode=%p istart/end=%d:%d\n",
 		       inode, istart, iend);
 	}
-	if ((istart == -1 && iend != -1) ||
-	    (istart != -1 && iend == -1)) {
+	if (unlikely((istart == -1 && iend != -1) ||
+		     (istart != -1 && iend == -1))) {
 		PRINT_CALLER(fname, fxn, line);
 		printk(" Ci1: inode=%p istart/end=%d:%d\n",
 		       inode, istart, iend);
 	}
 	if (!S_ISDIR(inode->i_mode)) {
-		if (iend != istart) {
+		if (unlikely(iend != istart)) {
 			PRINT_CALLER(fname, fxn, line);
 			printk(" Ci2: inode=%p istart=%d iend=%d\n",
 			       inode, istart, iend);
@@ -69,12 +69,12 @@ void __unionfs_check_inode(const struct inode *inode,
 	}
 
 	for (bindex = sbstart(sb); bindex < sbmax(sb); bindex++) {
-		if (!UNIONFS_I(inode)) {
+		if (unlikely(!UNIONFS_I(inode))) {
 			PRINT_CALLER(fname, fxn, line);
 			printk(" Ci3: no inode_info %p\n", inode);
 			return;
 		}
-		if (!UNIONFS_I(inode)->lower_inodes) {
+		if (unlikely(!UNIONFS_I(inode)->lower_inodes)) {
 			PRINT_CALLER(fname, fxn, line);
 			printk(" Ci4: no lower_inodes %p\n", inode);
 			return;
@@ -82,12 +82,12 @@ void __unionfs_check_inode(const struct inode *inode,
 		lower_inode = unionfs_lower_inode_idx(inode, bindex);
 		if (lower_inode) {
 			memset(&poison_ptr, POISON_INUSE, sizeof(void *));
-			if (bindex < istart || bindex > iend) {
+			if (unlikely(bindex < istart || bindex > iend)) {
 				PRINT_CALLER(fname, fxn, line);
 				printk(" Ci5: inode/linode=%p:%p bindex=%d "
 				       "istart/end=%d:%d\n", inode,
 				       lower_inode, bindex, istart, iend);
-			} else if (lower_inode == poison_ptr) {
+			} else if (unlikely(lower_inode == poison_ptr)) {
 				/* freed inode! */
 				PRINT_CALLER(fname, fxn, line);
 				printk(" Ci6: inode/linode=%p:%p bindex=%d "
@@ -101,8 +101,9 @@ void __unionfs_check_inode(const struct inode *inode,
 				 * b/t start/end, but NOT if at the
 				 * start/end range.
 				 */
-				if (!(S_ISDIR(inode->i_mode) &&
-				      bindex > istart && bindex < iend)) {
+				if (unlikely(!(S_ISDIR(inode->i_mode) &&
+					       bindex > istart &&
+					       bindex < iend))) {
 					PRINT_CALLER(fname, fxn, line);
 					printk(" Ci7: inode/linode=%p:%p "
 					       "bindex=%d istart/end=%d:%d\n",
@@ -133,8 +134,8 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 	dend = dbend(dentry);
 	BUG_ON(dstart > dend);
 
-	if ((dstart == -1 && dend != -1) ||
-	    (dstart != -1 && dend == -1)) {
+	if (unlikely((dstart == -1 && dend != -1) ||
+		     (dstart != -1 && dend == -1))) {
 		PRINT_CALLER(fname, fxn, line);
 		printk(" CD0: dentry=%p dstart/end=%d:%d\n",
 		       dentry, dstart, dend);
@@ -146,7 +147,7 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 	for (bindex = sbstart(sb); bindex < sbmax(sb); bindex++) {
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
 		if (lower_dentry) {
-			if (bindex < dstart || bindex > dend) {
+			if (unlikely(bindex < dstart || bindex > dend)) {
 				PRINT_CALLER(fname, fxn, line);
 				printk(" CD1: dentry/lower=%p:%p(%p) "
 				       "bindex=%d dstart/end=%d:%d\n",
@@ -164,10 +165,10 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 				 * however, if this is a NULL dentry or a
 				 * deleted dentry.
 				 */
-				if (!d_deleted((struct dentry *) dentry) &&
-				    inode &&
-				    !(inode && S_ISDIR(inode->i_mode) &&
-				      bindex > dstart && bindex < dend)) {
+				if (unlikely(!d_deleted((struct dentry *) dentry) &&
+					     inode &&
+					     !(inode && S_ISDIR(inode->i_mode) &&
+					       bindex > dstart && bindex < dend))) {
 					PRINT_CALLER(fname, fxn, line);
 					printk(" CD2: dentry/lower=%p:%p(%p) "
 					       "bindex=%d dstart/end=%d:%d\n",
@@ -185,7 +186,7 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 	for (bindex = sbstart(sb); bindex < sbmax(sb); bindex++) {
 		lower_mnt = unionfs_lower_mnt_idx(dentry, bindex);
 		if (lower_mnt) {
-			if (bindex < dstart || bindex > dend) {
+			if (unlikely(bindex < dstart || bindex > dend)) {
 				PRINT_CALLER(fname, fxn, line);
 				printk(" CM0: dentry/lmnt=%p:%p bindex=%d "
 				       "dstart/end=%d:%d\n", dentry,
@@ -199,9 +200,9 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 				 * start/end range.  Ignore this rule,
 				 * however, if this is a NULL dentry.
 				 */
-				if (inode &&
-				    !(inode && S_ISDIR(inode->i_mode) &&
-				      bindex > dstart && bindex < dend)) {
+				if (unlikely(inode &&
+					     !(inode && S_ISDIR(inode->i_mode) &&
+					       bindex > dstart && bindex < dend))) {
 					PRINT_CALLER(fname, fxn, line);
 					printk(" CM1: dentry/lmnt=%p:%p "
 					       "bindex=%d dstart/end=%d:%d\n",
@@ -218,30 +219,30 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 	istart = ibstart(inode);
 	iend = ibend(inode);
 	BUG_ON(istart > iend);
-	if ((istart == -1 && iend != -1) ||
-	    (istart != -1 && iend == -1)) {
+	if (unlikely((istart == -1 && iend != -1) ||
+		     (istart != -1 && iend == -1))) {
 		PRINT_CALLER(fname, fxn, line);
 		printk(" CI0: dentry/inode=%p:%p istart/end=%d:%d\n",
 		       dentry, inode, istart, iend);
 	}
-	if (istart != dstart) {
+	if (unlikely(istart != dstart)) {
 		PRINT_CALLER(fname, fxn, line);
 		printk(" CI1: dentry/inode=%p:%p istart=%d dstart=%d\n",
 		       dentry, inode, istart, dstart);
 	}
-	if (iend != dend) {
+	if (unlikely(iend != dend)) {
 		PRINT_CALLER(fname, fxn, line);
 		printk(" CI2: dentry/inode=%p:%p iend=%d dend=%d\n",
 		       dentry, inode, iend, dend);
 	}
 
 	if (!S_ISDIR(inode->i_mode)) {
-		if (dend != dstart) {
+		if (unlikely(dend != dstart)) {
 			PRINT_CALLER(fname, fxn, line);
 			printk(" CI3: dentry/inode=%p:%p dstart=%d dend=%d\n",
 			       dentry, inode, dstart, dend);
 		}
-		if (iend != istart) {
+		if (unlikely(iend != istart)) {
 			PRINT_CALLER(fname, fxn, line);
 			printk(" CI4: dentry/inode=%p:%p istart=%d iend=%d\n",
 			       dentry, inode, istart, iend);
@@ -252,12 +253,12 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 		lower_inode = unionfs_lower_inode_idx(inode, bindex);
 		if (lower_inode) {
 			memset(&poison_ptr, POISON_INUSE, sizeof(void *));
-			if (bindex < istart || bindex > iend) {
+			if (unlikely(bindex < istart || bindex > iend)) {
 				PRINT_CALLER(fname, fxn, line);
 				printk(" CI5: dentry/linode=%p:%p bindex=%d "
 				       "istart/end=%d:%d\n", dentry,
 				       lower_inode, bindex, istart, iend);
-			} else if (lower_inode == poison_ptr) {
+			} else if (unlikely(lower_inode == poison_ptr)) {
 				/* freed inode! */
 				PRINT_CALLER(fname, fxn, line);
 				printk(" CI6: dentry/linode=%p:%p bindex=%d "
@@ -271,8 +272,9 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 				 * b/t start/end, but NOT if at the
 				 * start/end range.
 				 */
-				if (!(S_ISDIR(inode->i_mode) &&
-				      bindex > istart && bindex < iend)) {
+				if (unlikely(!(S_ISDIR(inode->i_mode) &&
+					       bindex > istart &&
+					       bindex < iend))) {
 					PRINT_CALLER(fname, fxn, line);
 					printk(" CI7: dentry/linode=%p:%p "
 					       "bindex=%d istart/end=%d:%d\n",
@@ -294,8 +296,10 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 			lower_dentry = unionfs_lower_dentry_idx(dentry,
 								bindex);
 			lower_mnt = unionfs_lower_mnt_idx(dentry, bindex);
-			if (!((lower_inode && lower_dentry && lower_mnt) ||
-			      (!lower_inode && !lower_dentry && !lower_mnt))) {
+			if (unlikely(!((lower_inode && lower_dentry &&
+					lower_mnt) ||
+				       (!lower_inode &&
+					!lower_dentry && !lower_mnt)))) {
 				PRINT_CALLER(fname, fxn, line);
 				printk(" Cx: lmnt/ldentry/linode=%p:%p:%p "
 				       "bindex=%d dstart/end=%d:%d\n",
@@ -304,11 +308,11 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 			}
 		}
 	/* check if lower inode is newer than upper one (it shouldn't) */
-	if (is_newer_lower(dentry)) {
+	if (unlikely(is_newer_lower(dentry))) {
 		PRINT_CALLER(fname, fxn, line);
 		for (bindex=ibstart(inode); bindex <= ibend(inode); bindex++) {
 			lower_inode = unionfs_lower_inode_idx(inode, bindex);
-			if (!lower_inode)
+			if (unlikely(!lower_inode))
 				continue;
 			printk(" CI8: bindex=%d mtime/lmtime=%lu.%lu/%lu.%lu "
 			       "ctime/lctime=%lu.%lu/%lu.%lu\n",
@@ -346,30 +350,30 @@ void __unionfs_check_file(const struct file *file,
 	fend = fbend(file);
 	BUG_ON(fstart > fend);
 
-	if ((fstart == -1 && fend != -1) ||
-	    (fstart != -1 && fend == -1)) {
+	if (unlikely((fstart == -1 && fend != -1) ||
+		     (fstart != -1 && fend == -1))) {
 		PRINT_CALLER(fname, fxn, line);
 		printk(" CF0: file/dentry=%p:%p fstart/end=%d:%d\n",
 		       file, dentry, fstart, fend);
 	}
-	if (fstart != dstart) {
+	if (unlikely(fstart != dstart)) {
 		PRINT_CALLER(fname, fxn, line);
 		printk(" CF1: file/dentry=%p:%p fstart=%d dstart=%d\n",
 		       file, dentry, fstart, dstart);
 	}
-	if (fend != dend) {
+	if (unlikely(fend != dend)) {
 		PRINT_CALLER(fname, fxn, line);
 		printk(" CF2: file/dentry=%p:%p fend=%d dend=%d\n",
 		       file, dentry, fend, dend);
 	}
 	inode = dentry->d_inode;
 	if (!S_ISDIR(inode->i_mode)) {
-		if (fend != fstart) {
+		if (unlikely(fend != fstart)) {
 			PRINT_CALLER(fname, fxn, line);
 			printk(" CF3: file/inode=%p:%p fstart=%d fend=%d\n",
 			       file, inode, fstart, fend);
 		}
-		if (dend != dstart) {
+		if (unlikely(dend != dstart)) {
 			PRINT_CALLER(fname, fxn, line);
 			printk(" CF4: file/dentry=%p:%p dstart=%d dend=%d\n",
 			       file, dentry, dstart, dend);
@@ -383,7 +387,7 @@ void __unionfs_check_file(const struct file *file,
 	for (bindex = sbstart(sb); bindex < sbmax(sb); bindex++) {
 		lower_file = unionfs_lower_file_idx(file, bindex);
 		if (lower_file) {
-			if (bindex < fstart || bindex > fend) {
+			if (unlikely(bindex < fstart || bindex > fend)) {
 				PRINT_CALLER(fname, fxn, line);
 				printk(" CF5: file/lower=%p:%p bindex=%d "
 				       "fstart/end=%d:%d\n",
@@ -396,8 +400,9 @@ void __unionfs_check_file(const struct file *file,
 				 * b/t start/end, but NOT if at the
 				 * start/end range.
 				 */
-				if (!(S_ISDIR(inode->i_mode) &&
-				      bindex > fstart && bindex < fend)) {
+				if (unlikely(!(S_ISDIR(inode->i_mode) &&
+					       bindex > fstart &&
+					       bindex < fend))) {
 					PRINT_CALLER(fname, fxn, line);
 					printk(" CF6: file/lower=%p:%p "
 					       "bindex=%d fstart/end=%d:%d\n",
@@ -417,12 +422,13 @@ void __unionfs_check_nd(const struct nameidata *nd,
 	struct file *file;
 	int printed_caller = 0;
 
-	if (!nd)
+	if (unlikely(!nd))
 		return;
 	if (nd->flags & LOOKUP_OPEN) {
 		file = nd->intent.open.file;
-		if (file->f_path.dentry &&
-		    strcmp(file->f_dentry->d_sb->s_type->name, "unionfs")) {
+		if (unlikely(file->f_path.dentry &&
+			     strcmp(file->f_dentry->d_sb->s_type->name,
+				    "unionfs"))) {
 			PRINT_CALLER(fname, fxn, line);
 			printk(" CND1: lower_file of type %s\n",
 			       file->f_path.dentry->d_sb->s_type->name);
@@ -440,7 +446,7 @@ void __show_branch_counts(const struct super_block *sb,
 
 	printk("BC:");
 	for (i=0; i<sbmax(sb); i++) {
-		if (sb->s_root)
+		if (likely(sb->s_root))
 			mnt = UNIONFS_D(sb->s_root)->lower_paths[i].mnt;
 		else
 			mnt = NULL;
@@ -457,7 +463,7 @@ void __show_inode_times(const struct inode *inode,
 
 	for (bindex=ibstart(inode); bindex <= ibend(inode); bindex++) {
 		lower_inode = unionfs_lower_inode_idx(inode, bindex);
-		if (!lower_inode)
+		if (unlikely(!lower_inode))
 			continue;
 		printk("IT(%lu:%d): ", inode->i_ino, bindex);
 		printk("%s:%s:%d ",file,fxn,line);
@@ -503,14 +509,14 @@ void __show_inode_counts(const struct inode *inode,
 	struct inode *lower_inode;
 	int bindex;
 
-	if (!inode) {
+	if (unlikely(!inode)) {
 		printk("SiC: Null inode\n");
 		return;
 	}
 	for (bindex=sbstart(inode->i_sb); bindex <= sbend(inode->i_sb);
 	     bindex++) {
 		lower_inode = unionfs_lower_inode_idx(inode, bindex);
-		if (!lower_inode)
+		if (unlikely(!lower_inode))
 			continue;
 		printk("SIC(%lu:%d:%d): ", inode->i_ino, bindex,
 		       atomic_read(&(inode)->i_count));
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 52bcb18..89f6a91 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -62,7 +62,7 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 	 * revalidation to be done, because this file does not exist within
 	 * the namespace, and Unionfs operates on the namespace, not data.
 	 */
-	if (sbgen != dgen) {
+	if (unlikely(sbgen != dgen)) {
 		struct dentry *result;
 		int pdgen;
 
@@ -138,7 +138,7 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 			dentry = result;
 		}
 
-		if (positive && UNIONFS_I(dentry->d_inode)->stale) {
+		if (unlikely(positive && UNIONFS_I(dentry->d_inode)->stale)) {
 			make_bad_inode(dentry->d_inode);
 			d_drop(dentry);
 			valid = false;
@@ -216,16 +216,16 @@ bool is_newer_lower(const struct dentry *dentry)
 		 * lower inode's data has changed, but checking for changed
 		 * ctime and mtime on the lower inode should be enough.
 		 */
-		if (timespec_compare(&inode->i_mtime,
-				     &lower_inode->i_mtime) < 0) {
+		if (unlikely(timespec_compare(&inode->i_mtime,
+					      &lower_inode->i_mtime) < 0)) {
 			printk("unionfs: new lower inode mtime "
 			       "(bindex=%d, name=%s)\n", bindex,
 			       dentry->d_name.name);
 			show_dinode_times(dentry);
 			return true; /* mtime changed! */
 		}
-		if (timespec_compare(&inode->i_ctime,
-				     &lower_inode->i_ctime) < 0) {
+		if (unlikely(timespec_compare(&inode->i_ctime,
+					      &lower_inode->i_ctime) < 0)) {
 			printk("unionfs: new lower inode ctime "
 			       "(bindex=%d, name=%s)\n", bindex,
 			       dentry->d_name.name);
@@ -293,7 +293,7 @@ bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
 	dtmp = dentry->d_parent;
 	dgen = atomic_read(&UNIONFS_D(dtmp)->generation);
 	/* XXX: should we check if is_newer_lower all the way up? */
-	if (is_newer_lower(dtmp)) {
+	if (unlikely(is_newer_lower(dtmp))) {
 		/*
 		 * Special case: the root dentry's generation number must
 		 * always be valid, but its lower inode times don't have to
@@ -327,7 +327,7 @@ bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
 	 * and short lived, so locality will be better.
 	 */
 	chain = kzalloc(chain_len * sizeof(struct dentry *), GFP_KERNEL);
-	if (!chain) {
+	if (unlikely(!chain)) {
 		printk("unionfs: no more memory in %s\n", __FUNCTION__);
 		goto out;
 	}
@@ -364,7 +364,7 @@ bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
 		}
 		unionfs_unlock_dentry(chain[i]);
 
-		if (!valid)
+		if (unlikely(!valid))
 			goto out_free;
 	}
 
@@ -373,7 +373,8 @@ out_this:
 	/* finally, lock this dentry and revalidate it */
 	verify_locked(dentry);
 	dgen = atomic_read(&UNIONFS_D(dentry)->generation);
-	if (is_newer_lower(dentry)) {
+
+	if (unlikely(is_newer_lower(dentry))) {
 		/* root dentry special case as aforementioned */
 		if (IS_ROOT(dentry))
 			unionfs_copy_attr_times(dentry->d_inode);
@@ -425,7 +426,7 @@ static int unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 	unionfs_lock_dentry(dentry);
 	err = __unionfs_d_revalidate_chain(dentry, nd, false);
 	unionfs_unlock_dentry(dentry);
-	if (err > 0) { /* true==1: dentry is valid */
+	if (likely(err > 0)) { /* true==1: dentry is valid */
 		unionfs_check_dentry(dentry);
 		unionfs_check_nd(nd);
 	}
@@ -447,7 +448,7 @@ static void unionfs_d_release(struct dentry *dentry)
 
 	unionfs_check_dentry(dentry);
 	/* this could be a negative dentry, so check first */
-	if (!UNIONFS_D(dentry)) {
+	if (unlikely(!UNIONFS_D(dentry))) {
 		printk(KERN_DEBUG "unionfs: dentry without private data: %.*s\n",
 		       dentry->d_name.len, dentry->d_name.name);
 		goto out;
diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index c923e58..200fb55 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -99,7 +99,7 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 
-	if ((err = unionfs_file_revalidate(file, false)))
+	if (unlikely((err = unionfs_file_revalidate(file, false))))
 		goto out;
 
 	inode = file->f_path.dentry->d_inode;
@@ -110,7 +110,7 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 			goto out;
 		} else if (file->f_pos > 0) {
 			uds = find_rdstate(inode, file->f_pos);
-			if (!uds) {
+			if (unlikely(!uds)) {
 				err = -ESTALE;
 				goto out;
 			}
@@ -201,7 +201,7 @@ static loff_t unionfs_dir_llseek(struct file *file, loff_t offset, int origin)
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 
-	if ((err = unionfs_file_revalidate(file, false)))
+	if (unlikely((err = unionfs_file_revalidate(file, false))))
 		goto out;
 
 	rdstate = UNIONFS_F(file)->rdstate;
diff --git a/fs/unionfs/dirhelper.c b/fs/unionfs/dirhelper.c
index a72f711..f0e1fee 100644
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -43,7 +43,7 @@ int do_delete_whiteouts(struct dentry *dentry, int bindex,
 
 	err = -ENOMEM;
 	name = __getname();
-	if (!name)
+	if (unlikely(!name))
 		goto out;
 	strcpy(name, UNIONFS_WHPFX);
 	p = name + UNIONFS_WHLEN;
@@ -204,14 +204,14 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
 		bend = bopaque;
 
 	buf = kmalloc(sizeof(struct unionfs_rdutil_callback), GFP_KERNEL);
-	if (!buf) {
+	if (unlikely(!buf)) {
 		err = -ENOMEM;
 		goto out;
 	}
 	buf->err = 0;
 	buf->mode = RD_CHECK_EMPTY;
 	buf->rdstate = alloc_rdstate(dentry->d_inode, bstart);
-	if (!buf->rdstate) {
+	if (unlikely(!buf->rdstate)) {
 		err = -ENOMEM;
 		goto out;
 	}
diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index 51aa0de..536a51f 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -314,11 +314,11 @@ static inline void unionfs_copy_attr_times(struct inode *upper)
 		lower = unionfs_lower_inode_idx(upper, bindex);
 		if (!lower)
 			continue; /* not all lower dir objects may exist */
-		if (timespec_compare(&upper->i_mtime, &lower->i_mtime) < 0)
+		if (unlikely(timespec_compare(&upper->i_mtime, &lower->i_mtime) < 0))
 			upper->i_mtime = lower->i_mtime;
-		if (timespec_compare(&upper->i_ctime, &lower->i_ctime) < 0)
+		if (unlikely(timespec_compare(&upper->i_ctime, &lower->i_ctime) < 0))
 			upper->i_ctime = lower->i_ctime;
-		if (timespec_compare(&upper->i_atime, &lower->i_atime) < 0)
+		if (unlikely(timespec_compare(&upper->i_atime, &lower->i_atime) < 0))
 			upper->i_atime = lower->i_atime;
 	}
 }
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index d8eaaa5..82959d1 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -24,7 +24,7 @@ static ssize_t unionfs_read(struct file *file, char __user *buf,
 	int err;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, false)))
+	if (unlikely((err = unionfs_file_revalidate(file, false))))
 		goto out;
 	unionfs_check_file(file);
 
@@ -47,7 +47,7 @@ static ssize_t unionfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	struct file *file = iocb->ki_filp;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, false)))
+	if (unlikely((err = unionfs_file_revalidate(file, false))))
 		goto out;
 	unionfs_check_file(file);
 
@@ -72,7 +72,7 @@ static ssize_t unionfs_write(struct file *file, const char __user *buf,
 	int err = 0;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, true)))
+	if (unlikely((err = unionfs_file_revalidate(file, true))))
 		goto out;
 	unionfs_check_file(file);
 
@@ -104,7 +104,7 @@ static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
 
 	/* This might be deferred to mmap's writepage */
 	willwrite = ((vma->vm_flags | VM_SHARED | VM_WRITE) == vma->vm_flags);
-	if ((err = unionfs_file_revalidate(file, willwrite)))
+	if (unlikely((err = unionfs_file_revalidate(file, willwrite))))
 		goto out;
 	unionfs_check_file(file);
 
@@ -149,7 +149,7 @@ int unionfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 	int err = -EINVAL;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, true)))
+	if (unlikely((err = unionfs_file_revalidate(file, true))))
 		goto out;
 	unionfs_check_file(file);
 
@@ -159,7 +159,7 @@ int unionfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 		goto out;
 
 	inode = dentry->d_inode;
-	if (!inode) {
+	if (unlikely(!inode)) {
 		printk(KERN_ERR
 		       "unionfs: null lower inode in unionfs_fsync\n");
 		goto out;
@@ -196,7 +196,7 @@ int unionfs_fasync(int fd, struct file *file, int flag)
 	int err = 0;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, true)))
+	if (unlikely((err = unionfs_file_revalidate(file, true))))
 		goto out;
 	unionfs_check_file(file);
 
@@ -207,7 +207,7 @@ int unionfs_fasync(int fd, struct file *file, int flag)
 
 	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
-	if (!inode) {
+	if (unlikely(!inode)) {
 		printk(KERN_ERR
 		       "unionfs: null lower inode in unionfs_fasync\n");
 		goto out;
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 7ee4760..021e206 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -35,7 +35,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	unionfs_lock_dentry(dentry->d_parent);
 	valid = __unionfs_d_revalidate_chain(dentry->d_parent, nd, false);
 	unionfs_unlock_dentry(dentry->d_parent);
-	if (!valid) {
+	if (unlikely(!valid)) {
 		err = -ESTALE;	/* same as what real_lookup does */
 		goto out;
 	}
@@ -66,7 +66,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 		 * first.
 		 */
 		name = alloc_whname(dentry->d_name.name, dentry->d_name.len);
-		if (IS_ERR(name)) {
+		if (unlikely(IS_ERR(name))) {
 			err = PTR_ERR(name);
 			goto out;
 		}
@@ -115,7 +115,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	}
 
 	err = init_lower_nd(&lower_nd, LOOKUP_CREATE);
-	if (err < 0)
+	if (unlikely(err < 0))
 		goto out;
 	err = vfs_create(lower_parent_dentry->d_inode, lower_dentry, mode,
 			 &lower_nd);
@@ -213,12 +213,12 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 	unionfs_read_lock(old_dentry->d_sb);
 	unionfs_double_lock_dentry(new_dentry, old_dentry);
 
-	if (!__unionfs_d_revalidate_chain(old_dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(old_dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
-	if (new_dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(new_dentry, NULL, false)) {
+	if (unlikely(new_dentry->d_inode &&
+		     !__unionfs_d_revalidate_chain(new_dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -230,7 +230,7 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 	 * .wh.foo first. If present, delete it
 	 */
 	name = alloc_whname(new_dentry->d_name.name, new_dentry->d_name.len);
-	if (IS_ERR(name)) {
+	if (unlikely(IS_ERR(name))) {
 		err = PTR_ERR(name);
 		goto out;
 	}
@@ -362,8 +362,8 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(dentry->d_inode &&
+		     !__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -378,7 +378,7 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 	 * first. If present, delete it
 	 */
 	name = alloc_whname(dentry->d_name.name, dentry->d_name.len);
-	if (IS_ERR(name)) {
+	if (unlikely(IS_ERR(name))) {
 		err = PTR_ERR(name);
 		goto out;
 	}
@@ -522,8 +522,8 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(dentry->d_inode &&
+		     !__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -537,7 +537,7 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 	 * first.
 	 */
 	name = alloc_whname(dentry->d_name.name, dentry->d_name.len);
-	if (IS_ERR(name)) {
+	if (unlikely(IS_ERR(name))) {
 		err = PTR_ERR(name);
 		goto out;
 	}
@@ -672,8 +672,8 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(dentry->d_inode &&
+		     !__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -687,7 +687,7 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	 * first.
 	 */
 	name = alloc_whname(dentry->d_name.name, dentry->d_name.len);
-	if (IS_ERR(name)) {
+	if (unlikely(IS_ERR(name))) {
 		err = PTR_ERR(name);
 		goto out;
 	}
@@ -797,7 +797,7 @@ static int unionfs_readlink(struct dentry *dentry, char __user *buf,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -844,7 +844,7 @@ static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 
 	/* This is freed by the put_link method assuming a successful call. */
 	buf = kmalloc(len, GFP_KERNEL);
-	if (!buf) {
+	if (unlikely(!buf)) {
 		err = -ENOMEM;
 		goto out;
 	}
@@ -877,7 +877,7 @@ static void unionfs_put_link(struct dentry *dentry, struct nameidata *nd,
 	unionfs_read_lock(dentry->d_sb);
 
 	unionfs_lock_dentry(dentry);
-	if (!__unionfs_d_revalidate_chain(dentry, nd, false))
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, nd, false)))
 		printk("unionfs: put_link failed to revalidate dentry\n");
 	unionfs_unlock_dentry(dentry);
 
@@ -959,7 +959,7 @@ static int unionfs_permission(struct inode *inode, int mask,
 
 	bstart = ibstart(inode);
 	bend = ibend(inode);
-	if (bstart < 0 || bend < 0) {
+	if (unlikely(bstart < 0 || bend < 0)) {
 		/*
 		 * With branch-management, we can get a stale inode here.
 		 * If so, we return ESTALE back to link_path_walk, which
@@ -1030,7 +1030,7 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 2109714..94e4c8e 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -119,12 +119,12 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	case INTERPOSE_PARTIAL:
 		break;
 	case INTERPOSE_LOOKUP:
-		if ((err = new_dentry_private_data(dentry)))
+		if (unlikely((err = new_dentry_private_data(dentry))))
 			goto out;
 		break;
 	default:
 		/* default: can only be INTERPOSE_REVAL/REVAL_NEG */
-		if ((err = realloc_dentry_private_data(dentry)))
+		if (unlikely((err = realloc_dentry_private_data(dentry))))
 			goto out;
 		break;
 	}
@@ -189,7 +189,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		/* Reuse the whiteout name because its value doesn't change. */
 		if (!whname) {
 			whname = alloc_whname(name, namelen);
-			if (IS_ERR(whname)) {
+			if (unlikely(IS_ERR(whname))) {
 				err = PTR_ERR(whname);
 				goto out_free;
 			}
@@ -498,7 +498,7 @@ static inline int __realloc_dentry_private_data(struct dentry *dentry)
 
 	size = sizeof(struct path) * sbmax(dentry->d_sb);
 	p = krealloc(info->lower_paths, size, GFP_ATOMIC);
-	if (!p)
+	if (unlikely(!p))
 		return -ENOMEM;
 
 	info->lower_paths = p;
@@ -534,7 +534,7 @@ int new_dentry_private_data(struct dentry *dentry)
 	BUG_ON(info);
 
 	info = kmem_cache_alloc(unionfs_dentry_cachep, GFP_ATOMIC);
-	if (!info)
+	if (unlikely(!info))
 		return -ENOMEM;
 
 	mutex_init(&info->lock);
@@ -614,7 +614,7 @@ int init_lower_nd(struct nameidata *nd, unsigned int flags)
 		nd->intent.open.flags |= (FMODE_READ | FMODE_WRITE);
 #ifdef ALLOC_LOWER_ND_FILE
 		file = kzalloc(sizeof(struct file), GFP_KERNEL);
-		if (!file) {
+		if (unlikely(!file)) {
 			err = -ENOMEM;
 			break; /* exit switch statement and thus return */
 		}
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 8595750..72438fb 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -122,7 +122,7 @@ struct dentry *unionfs_interpose(struct dentry *dentry, struct super_block *sb,
 
 		UNIONFS_I(inode)->lower_inodes =
 			kcalloc(sbmax(sb), sizeof(struct inode *), GFP_KERNEL);
-		if (!UNIONFS_I(inode)->lower_inodes) {
+		if (unlikely(!UNIONFS_I(inode)->lower_inodes)) {
 			err = -ENOMEM;
 			goto out;
 		}
@@ -319,14 +319,14 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 	/* allocate space for underlying pointers to lower dentry */
 	UNIONFS_SB(sb)->data =
 		kcalloc(branches, sizeof(struct unionfs_data), GFP_KERNEL);
-	if (!UNIONFS_SB(sb)->data) {
+	if (unlikely(!UNIONFS_SB(sb)->data)) {
 		err = -ENOMEM;
 		goto out;
 	}
 
 	lower_root_info->lower_paths =
 		kcalloc(branches, sizeof(struct path), GFP_KERNEL);
-	if (!lower_root_info->lower_paths) {
+	if (unlikely(!lower_root_info->lower_paths)) {
 		err = -ENOMEM;
 		goto out;
 	}
@@ -462,7 +462,7 @@ static struct unionfs_dentry_info *unionfs_parse_options(
 	err = -ENOMEM;
 	lower_root_info =
 		kzalloc(sizeof(struct unionfs_dentry_info), GFP_KERNEL);
-	if (!lower_root_info)
+	if (unlikely(!lower_root_info))
 		goto out_error;
 	lower_root_info->bstart = -1;
 	lower_root_info->bend = -1;
@@ -567,7 +567,7 @@ static struct dentry *unionfs_d_alloc_root(struct super_block *sb)
 		static const struct qstr name = {.name = "/",.len = 1 };
 
 		ret = d_alloc(NULL, &name);
-		if (ret) {
+		if (likely(ret)) {
 			ret->d_op = &unionfs_dops;
 			ret->d_sb = sb;
 			ret->d_parent = ret;
@@ -596,7 +596,7 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 
 	/* Allocate superblock private data */
 	sb->s_fs_info = kzalloc(sizeof(struct unionfs_sb_info), GFP_KERNEL);
-	if (!UNIONFS_SB(sb)) {
+	if (unlikely(!UNIONFS_SB(sb))) {
 		printk(KERN_WARNING "unionfs: read_super: out of memory\n");
 		err = -ENOMEM;
 		goto out;
@@ -637,14 +637,14 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 
 	/* See comment next to the definition of unionfs_d_alloc_root */
 	sb->s_root = unionfs_d_alloc_root(sb);
-	if (!sb->s_root) {
+	if (unlikely(!sb->s_root)) {
 		err = -ENOMEM;
 		goto out_dput;
 	}
 
 	/* link the upper and lower dentries */
 	sb->s_root->d_fsdata = NULL;
-	if ((err = new_dentry_private_data(sb->s_root)))
+	if (unlikely((err = new_dentry_private_data(sb->s_root))))
 		goto out_freedpd;
 
 	/* Set the lower dentries for s_root */
@@ -734,17 +734,17 @@ static int __init init_unionfs_fs(void)
 
 	printk("Registering unionfs " UNIONFS_VERSION "\n");
 
-	if ((err = unionfs_init_filldir_cache()))
+	if (unlikely((err = unionfs_init_filldir_cache())))
 		goto out;
-	if ((err = unionfs_init_inode_cache()))
+	if (unlikely((err = unionfs_init_inode_cache())))
 		goto out;
-	if ((err = unionfs_init_dentry_cache()))
+	if (unlikely((err = unionfs_init_dentry_cache())))
 		goto out;
-	if ((err = init_sioq()))
+	if (unlikely((err = init_sioq())))
 		goto out;
 	err = register_filesystem(&unionfs_fs_type);
 out:
-	if (err) {
+	if (unlikely(err)) {
 		stop_sioq();
 		unionfs_destroy_filldir_cache();
 		unionfs_destroy_inode_cache();
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 37af979..bcd4267 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -212,7 +212,7 @@ static int unionfs_readpage(struct file *file, struct page *page)
 	int err;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, false)))
+	if (unlikely((err = unionfs_file_revalidate(file, false))))
 		goto out;
 	unionfs_check_file(file);
 
@@ -276,7 +276,7 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	BUG_ON(file == NULL);
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, true)))
+	if (unlikely((err = unionfs_file_revalidate(file, true))))
 		goto out;
 	unionfs_check_file(file);
 
diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index 0a18d5c..0fdd364 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -136,7 +136,7 @@ struct unionfs_dir_state *alloc_rdstate(struct inode *inode, int bindex)
 		sizeof(struct list_head);
 
 	rdstate = kmalloc(mallocsize, GFP_KERNEL);
-	if (!rdstate)
+	if (unlikely(!rdstate))
 		return NULL;
 
 	spin_lock(&UNIONFS_I(inode)->rdlock);
@@ -217,7 +217,7 @@ struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
 			 * if the duplicate is in this branch, then the file
 			 * system is corrupted.
 			 */
-			if (cursor->bindex == rdstate->bindex) {
+			if (unlikely(cursor->bindex == rdstate->bindex)) {
 				printk(KERN_DEBUG "unionfs: filldir: possible "
 				       "I/O error: a file is duplicated "
 				       "in the same branch %d: %s\n",
@@ -249,7 +249,7 @@ int add_filldir_node(struct unionfs_dir_state *rdstate, const char *name,
 	head = &(rdstate->list[index]);
 
 	new = kmem_cache_alloc(unionfs_filldir_cachep, GFP_KERNEL);
-	if (!new) {
+	if (unlikely(!new)) {
 		err = -ENOMEM;
 		goto out;
 	}
@@ -264,7 +264,7 @@ int add_filldir_node(struct unionfs_dir_state *rdstate, const char *name,
 		new->name = new->iname;
 	else {
 		new->name = kmalloc(namelen + 1, GFP_KERNEL);
-		if (!new->name) {
+		if (unlikely(!new->name)) {
 			kmem_cache_free(unionfs_filldir_cachep, new);
 			new = NULL;
 			goto out;
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 7b8fe39..226bcea 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -50,7 +50,7 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	wh_name = alloc_whname(new_dentry->d_name.name,
 			       new_dentry->d_name.len);
-	if (IS_ERR(wh_name)) {
+	if (unlikely(IS_ERR(wh_name))) {
 		err = PTR_ERR(wh_name);
 		goto out;
 	}
@@ -105,7 +105,7 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		whname = alloc_whname(old_dentry->d_name.name,
 				      old_dentry->d_name.len);
 		err = PTR_ERR(whname);
-		if (IS_ERR(whname))
+		if (unlikely(IS_ERR(whname)))
 			goto out_unlock;
 		*wh_old = lookup_one_len(whname, lower_old_dir_dentry,
 					 old_dentry->d_name.len +
@@ -265,7 +265,7 @@ static int do_unionfs_rename(struct inode *old_dir,
 			goto out;
 		}
 		err = init_lower_nd(&nd, LOOKUP_CREATE);
-		if (err < 0)
+		if (unlikely(err < 0))
 			goto out;
 		lower_parent = lock_parent(wh_old);
 		local_err = vfs_create(lower_parent->d_inode, wh_old, S_IRUGO,
@@ -351,7 +351,7 @@ static struct dentry *lookup_whiteout(struct dentry *dentry)
 	struct dentry *parent, *lower_parent, *wh_dentry;
 
 	whname = alloc_whname(dentry->d_name.name, dentry->d_name.len);
-	if (IS_ERR(whname))
+	if (unlikely(IS_ERR(whname)))
 		return (void *)whname;
 
 	parent = dget_parent(dentry);
@@ -416,12 +416,12 @@ int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	unionfs_read_lock(old_dentry->d_sb);
 	unionfs_double_lock_dentry(old_dentry, new_dentry);
 
-	if (!__unionfs_d_revalidate_chain(old_dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(old_dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
-	if (!d_deleted(new_dentry) && new_dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(new_dentry, NULL, false)) {
+	if (unlikely(!d_deleted(new_dentry) && new_dentry->d_inode &&
+		     !__unionfs_d_revalidate_chain(new_dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index 6b93b64..3183678 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -40,7 +40,7 @@ int create_whiteout(struct dentry *dentry, int start)
 
 	/* create dentry's whiteout equivalent */
 	name = alloc_whname(dentry->d_name.name, dentry->d_name.len);
-	if (IS_ERR(name)) {
+	if (unlikely(IS_ERR(name))) {
 		err = PTR_ERR(name);
 		goto out;
 	}
@@ -84,7 +84,7 @@ int create_whiteout(struct dentry *dentry, int start)
 		}
 
 		err = init_lower_nd(&nd, LOOKUP_CREATE);
-		if (err < 0)
+		if (unlikely(err < 0))
 			goto out;
 		lower_dir_dentry = lock_parent(lower_wh_dentry);
 		if (!(err = is_robranch_super(dentry->d_sb, bindex)))
@@ -172,7 +172,7 @@ int make_dir_opaque(struct dentry *dentry, int bindex)
 	}
 
 	err = init_lower_nd(&nd, LOOKUP_CREATE);
-	if (err < 0)
+	if (unlikely(err < 0))
 		goto out;
 	if (!diropq->d_inode)
 		err = vfs_create(lower_dir, diropq, S_IRUGO, &nd);
@@ -213,7 +213,7 @@ char *alloc_whname(const char *name, int len)
 	char *buf;
 
 	buf = kmalloc(len + UNIONFS_WHLEN + 1, GFP_KERNEL);
-	if (!buf)
+	if (unlikely(!buf))
 		return ERR_PTR(-ENOMEM);
 
 	strcpy(buf, UNIONFS_WHPFX);
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 4e0fe7c..1279df6 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -44,7 +44,7 @@ static void unionfs_read_inode(struct inode *inode)
 
 	size = sbmax(inode->i_sb) * sizeof(struct inode *);
 	info->lower_inodes = kzalloc(size, GFP_KERNEL);
-	if (!info->lower_inodes) {
+	if (unlikely(!info->lower_inodes)) {
 		printk(KERN_ERR "unionfs: no kernel memory when allocating "
 		       "lower-pointer array!\n");
 		BUG();
@@ -98,7 +98,7 @@ static void unionfs_put_super(struct super_block *sb)
 
 	/* Make sure we have no leaks of branchget/branchput. */
 	for (bindex = bstart; bindex <= bend; bindex++)
-		if (branch_count(sb, bindex) != 0) {
+		if (unlikely(branch_count(sb, bindex) != 0)) {
 			printk("unionfs: branch %d has %d references left!\n",
 			       bindex, branch_count(sb, bindex));
 			leaks = 1;
@@ -126,7 +126,7 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	unionfs_read_lock(sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -474,7 +474,7 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 	 * strsep modifies the string and we need it later.
 	 */
 	optionstmp = tmp_to_free = kstrdup(options, GFP_KERNEL);
-	if (!optionstmp) {
+	if (unlikely(!optionstmp)) {
 		err = -ENOMEM;
 		goto out_free;
 	}
@@ -521,14 +521,14 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 	/* allocate space for new pointers to lower dentry */
 	tmp_data = kcalloc(max_branches,
 			   sizeof(struct unionfs_data), GFP_KERNEL);
-	if (!tmp_data) {
+	if (unlikely(!tmp_data)) {
 		err = -ENOMEM;
 		goto out_free;
 	}
 	/* allocate space for new pointers to lower paths */
 	tmp_lower_paths = kcalloc(max_branches,
 				  sizeof(struct path), GFP_KERNEL);
-	if (!tmp_lower_paths) {
+	if (unlikely(!tmp_lower_paths)) {
 		err = -ENOMEM;
 		goto out_free;
 	}
@@ -662,7 +662,7 @@ out_no_change:
 	/* (re)allocate space for new pointers to lower dentry */
 	size = new_branches * sizeof(struct unionfs_data);
 	new_data = krealloc(tmp_data, size, GFP_KERNEL);
-	if (!new_data) {
+	if (unlikely(!new_data)) {
 		err = -ENOMEM;
 		goto out_release;
 	}
@@ -670,7 +670,7 @@ out_no_change:
 	/* allocate space for new pointers to lower paths */
 	size = new_branches * sizeof(struct path);
 	new_lower_paths = krealloc(tmp_lower_paths, size, GFP_KERNEL);
-	if (!new_lower_paths) {
+	if (unlikely(!new_lower_paths)) {
 		err = -ENOMEM;
 		goto out_release;
 	}
@@ -678,7 +678,7 @@ out_no_change:
 	/* allocate space for new pointers to lower inodes */
 	new_lower_inodes = kcalloc(new_branches,
 				   sizeof(struct inode *), GFP_KERNEL);
-	if (!new_lower_inodes) {
+	if (unlikely(!new_lower_inodes)) {
 		err = -ENOMEM;
 		goto out_release;
 	}
@@ -841,7 +841,7 @@ static struct inode *unionfs_alloc_inode(struct super_block *sb)
 	struct unionfs_inode_info *i;
 
 	i = kmem_cache_alloc(unionfs_inode_cachep, GFP_KERNEL);
-	if (!i)
+	if (unlikely(!i))
 		return NULL;
 
 	/* memset everything up to the inode to 0 */
@@ -872,7 +872,7 @@ int unionfs_init_inode_cache(void)
 		kmem_cache_create("unionfs_inode_cache",
 				  sizeof(struct unionfs_inode_info), 0,
 				  SLAB_RECLAIM_ACCOUNT, init_once);
-	if (!unionfs_inode_cachep)
+	if (unlikely(!unionfs_inode_cachep))
 		err = -ENOMEM;
 	return err;
 }
@@ -959,7 +959,7 @@ static int unionfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 	unionfs_lock_dentry(sb->s_root);
 
 	tmp_page = (char*) __get_free_page(GFP_KERNEL);
-	if (!tmp_page) {
+	if (unlikely(!tmp_page)) {
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 3924f7f..c5f6ed5 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -79,7 +79,7 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -148,7 +148,7 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 7f77d7d..71ff7d0 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -30,7 +30,7 @@ void *unionfs_xattr_alloc(size_t size, size_t limit)
 		return NULL;
 
 	ptr = kmalloc(size, GFP_KERNEL);
-	if (!ptr)
+	if (unlikely(!ptr))
 		return ERR_PTR(-ENOMEM);
 	return ptr;
 }
@@ -48,7 +48,7 @@ ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -77,7 +77,7 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -106,7 +106,7 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -135,7 +135,7 @@ ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
-- 
1.5.2.2

