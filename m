Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbXICCbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbXICCbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbXICCZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:46 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57674 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbXICCY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:56 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 31/32] Unionfs: debugging and validation of fan-out invariants
Date: Sun,  2 Sep 2007 22:20:54 -0400
Message-Id: <11887860593138-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Introduce debugging functionality, Makefile support to turn it on at compile
time, and hooks in the main code to verify fan-out invariants.  This is very
similar to how other file systems provide debugging functionality.  This
code has been very useful in detecting and fixing problems, especially when
stacking on top of assorted file systems.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/Kconfig              |    6 +
 fs/unionfs/Makefile     |    2 +
 fs/unionfs/commonfops.c |   17 ++
 fs/unionfs/copyup.c     |    2 +
 fs/unionfs/debug.c      |  502 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/unionfs/dentry.c     |    4 +
 fs/unionfs/file.c       |   19 ++-
 fs/unionfs/inode.c      |   22 ++
 fs/unionfs/mmap.c       |    5 +
 fs/unionfs/rename.c     |    4 +
 fs/unionfs/super.c      |    3 +
 fs/unionfs/union.h      |  105 +++++++---
 fs/unionfs/unlink.c     |    6 +
 fs/unionfs/xattr.c      |    4 +
 14 files changed, 668 insertions(+), 33 deletions(-)
 create mode 100644 fs/unionfs/debug.c

diff --git a/fs/Kconfig b/fs/Kconfig
index d53d8ca..0c58d02 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1063,6 +1063,12 @@ config UNION_FS_XATTR
 
 	  If unsure, say N.
 
+config UNION_FS_DEBUG
+	bool "Debug Unionfs"
+	depends on UNION_FS
+	help
+	  If you say Y here, you can turn on debugging output from Unionfs.
+
 endmenu
 
 menu "Miscellaneous filesystems"
diff --git a/fs/unionfs/Makefile b/fs/unionfs/Makefile
index 78be3e7..38fed90 100644
--- a/fs/unionfs/Makefile
+++ b/fs/unionfs/Makefile
@@ -5,3 +5,5 @@ unionfs-y := subr.o dentry.o file.o inode.o main.o super.o \
 	lookup.o commonfops.o dirfops.o sioq.o mmap.o
 
 unionfs-$(CONFIG_UNION_FS_XATTR) += xattr.o
+
+unionfs-$(CONFIG_UNION_FS_DEBUG) += debug.o
diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 341b6f2..724128d 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -91,6 +91,8 @@ retry:
 	unlock_dir(lower_dir_dentry);
 
 out:
+	if (!err)
+		unionfs_check_dentry(dentry);
 	return err;
 }
 
@@ -247,6 +249,8 @@ static int do_delayed_copyup(struct file *file)
 
 	BUG_ON(!S_ISREG(dentry->d_inode->i_mode));
 
+	unionfs_check_file(file);
+	unionfs_check_dentry(dentry);
 	for (bindex = bstart - 1; bindex >= 0; bindex--) {
 		if (!d_deleted(dentry))
 			err = copyup_file(parent_inode, file, bstart,
@@ -286,6 +290,8 @@ static int do_delayed_copyup(struct file *file)
 	ibend(dentry->d_inode) = ibstart(dentry->d_inode);
 
 out:
+	unionfs_check_file(file);
+	unionfs_check_dentry(dentry);
 	return err;
 }
 
@@ -399,6 +405,8 @@ out:
 		kfree(UNIONFS_F(file)->saved_branch_ids);
 	}
 out_nofree:
+	if (!err)
+		unionfs_check_file(file);
 	unionfs_unlock_dentry(dentry);
 	return err;
 }
@@ -576,6 +584,11 @@ out:
 	}
 out_nofree:
 	unionfs_read_unlock(inode->i_sb);
+	unionfs_check_inode(inode);
+	if (!err) {
+		unionfs_check_file(file);
+		unionfs_check_dentry(file->f_path.dentry->d_parent);
+	}
 	return err;
 }
 
@@ -601,6 +614,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 	 */
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
+	unionfs_check_file(file);
 	fileinfo = UNIONFS_F(file);
 	BUG_ON(file->f_path.dentry->d_inode != inode);
 	inodeinfo = UNIONFS_I(inode);
@@ -764,6 +778,7 @@ long unionfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	unionfs_check_file(file);
 	return err;
 }
 
@@ -778,6 +793,7 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
+	unionfs_check_file(file);
 
 	if (!atomic_dec_and_test(&UNIONFS_I(dentry->d_inode)->totalopens))
 		goto out;
@@ -814,5 +830,6 @@ out_lock:
 	unionfs_unlock_dentry(dentry);
 out:
 	unionfs_read_unlock(dentry->d_sb);
+	unionfs_check_file(file);
 	return err;
 }
diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 36f751e..23ac4c8 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -532,6 +532,8 @@ out_free:
 	unionfs_postcopyup_setmnt(dentry);
 	/* sync inode times from copied-up inode to our inode */
 	unionfs_copy_attr_times(dentry->d_inode);
+	unionfs_check_inode(dir);
+	unionfs_check_dentry(dentry);
 out:
 	return err;
 }
diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
new file mode 100644
index 0000000..f678534
--- /dev/null
+++ b/fs/unionfs/debug.c
@@ -0,0 +1,502 @@
+/*
+ * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2003-2007 Stony Brook University
+ * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "union.h"
+
+/*
+ * Helper debugging functions for maintainers (and for users to report back
+ * useful information back to maintainers)
+ */
+
+/* it's always useful to know what part of the code called us */
+#define PRINT_CALLER(fname, fxn, line)					\
+	do {								\
+		if (!printed_caller) {					\
+			printk("PC:%s:%s:%d\n",(fname),(fxn),(line));	\
+			printed_caller = 1;				\
+		}							\
+	} while (0)
+
+#if BITS_PER_LONG == 32
+#define POISONED_PTR		((void*) 0x5a5a5a5a)
+#elif BITS_PER_LONG == 64
+#define POISONED_PTR		((void*) 0x5a5a5a5a5a5a5a5a)
+#else
+#error Unknown BITS_PER_LONG value
+#endif /* BITS_PER_LONG != known */
+
+/*
+ * __unionfs_check_{inode,dentry,file} perform exhaustive sanity checking on
+ * the fan-out of various Unionfs objects.  We check that no lower objects
+ * exist  outside the start/end branch range; that all objects within are
+ * non-NULL (with some allowed exceptions); that for every lower file
+ * there's a lower dentry+inode; that the start/end ranges match for all
+ * corresponding lower objects; that open files/symlinks have only one lower
+ * objects, but directories can have several; and more.
+ */
+void __unionfs_check_inode(const struct inode *inode,
+			   const char *fname, const char *fxn, int line)
+{
+	int bindex;
+	int istart, iend;
+	struct inode *lower_inode;
+	struct super_block *sb;
+	int printed_caller = 0;
+
+	/* for inodes now */
+	BUG_ON(!inode);
+	sb = inode->i_sb;
+	istart = ibstart(inode);
+	iend = ibend(inode);
+	if (istart > iend) {
+		PRINT_CALLER(fname, fxn, line);
+		printk(" Ci0: inode=%p istart/end=%d:%d\n",
+		       inode, istart, iend);
+	}
+	if ((istart == -1 && iend != -1) ||
+	    (istart != -1 && iend == -1)) {
+		PRINT_CALLER(fname, fxn, line);
+		printk(" Ci1: inode=%p istart/end=%d:%d\n",
+		       inode, istart, iend);
+	}
+	if (!S_ISDIR(inode->i_mode)) {
+		if (iend != istart) {
+			PRINT_CALLER(fname, fxn, line);
+			printk(" Ci2: inode=%p istart=%d iend=%d\n",
+			       inode, istart, iend);
+		}
+	}
+
+	for (bindex = sbstart(sb); bindex < sbmax(sb); bindex++) {
+		if (!UNIONFS_I(inode)) {
+			PRINT_CALLER(fname, fxn, line);
+			printk(" Ci3: no inode_info %p\n", inode);
+			return;
+		}
+		if (!UNIONFS_I(inode)->lower_inodes) {
+			PRINT_CALLER(fname, fxn, line);
+			printk(" Ci4: no lower_inodes %p\n", inode);
+			return;
+		}
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (lower_inode) {
+			if (bindex < istart || bindex > iend) {
+				PRINT_CALLER(fname, fxn, line);
+				printk(" Ci5: inode/linode=%p:%p bindex=%d "
+				       "istart/end=%d:%d\n", inode,
+				       lower_inode, bindex, istart, iend);
+			} else if (lower_inode == POISONED_PTR) {
+				/* freed inode! */
+				PRINT_CALLER(fname, fxn, line);
+				printk(" Ci6: inode/linode=%p:%p bindex=%d "
+				       "istart/end=%d:%d\n", inode,
+				       lower_inode, bindex, istart, iend);
+			}
+		} else {	/* lower_inode == NULL */
+			if (bindex >= istart && bindex <= iend) {
+				/*
+				 * directories can have NULL lower inodes in
+				 * b/t start/end, but NOT if at the
+				 * start/end range.
+				 */
+				if (!(S_ISDIR(inode->i_mode) &&
+				      bindex > istart && bindex < iend)) {
+					PRINT_CALLER(fname, fxn, line);
+					printk(" Ci7: inode/linode=%p:%p "
+					       "bindex=%d istart/end=%d:%d\n",
+					       inode, lower_inode, bindex,
+					       istart, iend);
+				}
+			}
+		}
+	}
+}
+
+void __unionfs_check_dentry(const struct dentry *dentry,
+			    const char *fname, const char *fxn, int line)
+{
+	int bindex;
+	int dstart, dend, istart, iend;
+	struct dentry *lower_dentry;
+	struct inode *inode, *lower_inode;
+	struct super_block *sb;
+	struct vfsmount *lower_mnt;
+	int printed_caller = 0;
+
+	BUG_ON(!dentry);
+	sb = dentry->d_sb;
+	inode = dentry->d_inode;
+	dstart = dbstart(dentry);
+	dend = dbend(dentry);
+	BUG_ON(dstart > dend);
+
+	if ((dstart == -1 && dend != -1) ||
+	    (dstart != -1 && dend == -1)) {
+		PRINT_CALLER(fname, fxn, line);
+		printk(" CD0: dentry=%p dstart/end=%d:%d\n",
+		       dentry, dstart, dend);
+	}
+	/*
+	 * check for NULL dentries inside the start/end range, or
+	 * non-NULL dentries outside the start/end range.
+	 */
+	for (bindex = sbstart(sb); bindex < sbmax(sb); bindex++) {
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (lower_dentry) {
+			if (bindex < dstart || bindex > dend) {
+				PRINT_CALLER(fname, fxn, line);
+				printk(" CD1: dentry/lower=%p:%p(%p) "
+				       "bindex=%d dstart/end=%d:%d\n",
+				       dentry, lower_dentry,
+				       (lower_dentry ? lower_dentry->d_inode :
+					(void *) -1L),
+				       bindex, dstart, dend);
+			}
+		} else {	/* lower_dentry == NULL */
+			if (bindex >= dstart && bindex <= dend) {
+				/*
+				 * Directories can have NULL lower inodes in
+				 * b/t start/end, but NOT if at the
+				 * start/end range.  Ignore this rule,
+				 * however, if this is a NULL dentry or a
+				 * deleted dentry.
+				 */
+				if (!d_deleted((struct dentry *) dentry) &&
+				    inode &&
+				    !(inode && S_ISDIR(inode->i_mode) &&
+				      bindex > dstart && bindex < dend)) {
+					PRINT_CALLER(fname, fxn, line);
+					printk(" CD2: dentry/lower=%p:%p(%p) "
+					       "bindex=%d dstart/end=%d:%d\n",
+					       dentry, lower_dentry,
+					       (lower_dentry ?
+						lower_dentry->d_inode :
+						(void *) -1L),
+					       bindex, dstart, dend);
+				}
+			}
+		}
+	}
+
+	/* check for vfsmounts same as for dentries */
+	for (bindex = sbstart(sb); bindex < sbmax(sb); bindex++) {
+		lower_mnt = unionfs_lower_mnt_idx(dentry, bindex);
+		if (lower_mnt) {
+			if (bindex < dstart || bindex > dend) {
+				PRINT_CALLER(fname, fxn, line);
+				printk(" CM0: dentry/lmnt=%p:%p bindex=%d "
+				       "dstart/end=%d:%d\n", dentry,
+				       lower_mnt, bindex, dstart, dend);
+			}
+		} else {	/* lower_mnt == NULL */
+			if (bindex >= dstart && bindex <= dend) {
+				/*
+				 * Directories can have NULL lower inodes in
+				 * b/t start/end, but NOT if at the
+				 * start/end range.  Ignore this rule,
+				 * however, if this is a NULL dentry.
+				 */
+				if (inode &&
+				    !(inode && S_ISDIR(inode->i_mode) &&
+				      bindex > dstart && bindex < dend)) {
+					PRINT_CALLER(fname, fxn, line);
+					printk(" CM1: dentry/lmnt=%p:%p "
+					       "bindex=%d dstart/end=%d:%d\n",
+					       dentry, lower_mnt, bindex,
+					       dstart, dend);
+				}
+			}
+		}
+	}
+
+	/* for inodes now */
+	if (!inode)
+		return;
+	istart = ibstart(inode);
+	iend = ibend(inode);
+	BUG_ON(istart > iend);
+	if ((istart == -1 && iend != -1) ||
+	    (istart != -1 && iend == -1)) {
+		PRINT_CALLER(fname, fxn, line);
+		printk(" CI0: dentry/inode=%p:%p istart/end=%d:%d\n",
+		       dentry, inode, istart, iend);
+	}
+	if (istart != dstart) {
+		PRINT_CALLER(fname, fxn, line);
+		printk(" CI1: dentry/inode=%p:%p istart=%d dstart=%d\n",
+		       dentry, inode, istart, dstart);
+	}
+	if (iend != dend) {
+		PRINT_CALLER(fname, fxn, line);
+		printk(" CI2: dentry/inode=%p:%p iend=%d dend=%d\n",
+		       dentry, inode, iend, dend);
+	}
+
+	if (!S_ISDIR(inode->i_mode)) {
+		if (dend != dstart) {
+			PRINT_CALLER(fname, fxn, line);
+			printk(" CI3: dentry/inode=%p:%p dstart=%d dend=%d\n",
+			       dentry, inode, dstart, dend);
+		}
+		if (iend != istart) {
+			PRINT_CALLER(fname, fxn, line);
+			printk(" CI4: dentry/inode=%p:%p istart=%d iend=%d\n",
+			       dentry, inode, istart, iend);
+		}
+	}
+
+	for (bindex = sbstart(sb); bindex < sbmax(sb); bindex++) {
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (lower_inode) {
+			if (bindex < istart || bindex > iend) {
+				PRINT_CALLER(fname, fxn, line);
+				printk(" CI5: dentry/linode=%p:%p bindex=%d "
+				       "istart/end=%d:%d\n", dentry,
+				       lower_inode, bindex, istart, iend);
+			} else if (lower_inode == POISONED_PTR) {
+				/* freed inode! */
+				PRINT_CALLER(fname, fxn, line);
+				printk(" CI6: dentry/linode=%p:%p bindex=%d "
+				       "istart/end=%d:%d\n", dentry,
+				       lower_inode, bindex, istart, iend);
+			}
+		} else {	/* lower_inode == NULL */
+			if (bindex >= istart && bindex <= iend) {
+				/*
+				 * directories can have NULL lower inodes in
+				 * b/t start/end, but NOT if at the
+				 * start/end range.
+				 */
+				if (!(S_ISDIR(inode->i_mode) &&
+				      bindex > istart && bindex < iend)) {
+					PRINT_CALLER(fname, fxn, line);
+					printk(" CI7: dentry/linode=%p:%p "
+					       "bindex=%d istart/end=%d:%d\n",
+					       dentry, lower_inode, bindex,
+					       istart, iend);
+				}
+			}
+		}
+	}
+
+	/*
+	 * If it's a directory, then intermediate objects b/t start/end can
+	 * be NULL.  But, check that all three are NULL: lower dentry, mnt,
+	 * and inode.
+	 */
+	if (S_ISDIR(inode->i_mode))
+		for (bindex = dstart+1; bindex < dend; bindex++) {
+			lower_inode = unionfs_lower_inode_idx(inode, bindex);
+			lower_dentry = unionfs_lower_dentry_idx(dentry,
+								bindex);
+			lower_mnt = unionfs_lower_mnt_idx(dentry, bindex);
+			if (!((lower_inode && lower_dentry && lower_mnt) ||
+			      (!lower_inode && !lower_dentry && !lower_mnt))) {
+				PRINT_CALLER(fname, fxn, line);
+				printk(" Cx: lmnt/ldentry/linode=%p:%p:%p "
+				       "bindex=%d dstart/end=%d:%d\n",
+				       lower_mnt, lower_dentry, lower_inode,
+				       bindex, dstart, dend);
+			}
+		}
+	/* check if lower inode is newer than upper one (it shouldn't) */
+	if (is_newer_lower(dentry)) {
+		PRINT_CALLER(fname, fxn, line);
+		for (bindex=ibstart(inode); bindex <= ibend(inode); bindex++) {
+			lower_inode = unionfs_lower_inode_idx(inode, bindex);
+			if (!lower_inode)
+				continue;
+			printk(" CI8: bindex=%d mtime/lmtime=%lu.%lu/%lu.%lu "
+			       "ctime/lctime=%lu.%lu/%lu.%lu\n",
+			       bindex,
+			       inode->i_mtime.tv_sec,
+			       inode->i_mtime.tv_nsec,
+			       lower_inode->i_mtime.tv_sec,
+			       lower_inode->i_mtime.tv_nsec,
+			       inode->i_ctime.tv_sec,
+			       inode->i_ctime.tv_nsec,
+			       lower_inode->i_ctime.tv_sec,
+			       lower_inode->i_ctime.tv_nsec);
+		}
+	}
+}
+
+void __unionfs_check_file(const struct file *file,
+			  const char *fname, const char *fxn, int line)
+{
+	int bindex;
+	int dstart, dend, fstart, fend;
+	struct dentry *dentry;
+	struct file *lower_file;
+	struct inode *inode;
+	struct super_block *sb;
+	int printed_caller = 0;
+
+	BUG_ON(!file);
+	dentry = file->f_path.dentry;
+	sb = dentry->d_sb;
+	dstart = dbstart(dentry);
+	dend = dbend(dentry);
+	BUG_ON(dstart > dend);
+	fstart = fbstart(file);
+	fend = fbend(file);
+	BUG_ON(fstart > fend);
+
+	if ((fstart == -1 && fend != -1) ||
+	    (fstart != -1 && fend == -1)) {
+		PRINT_CALLER(fname, fxn, line);
+		printk(" CF0: file/dentry=%p:%p fstart/end=%d:%d\n",
+		       file, dentry, fstart, fend);
+	}
+	if (fstart != dstart) {
+		PRINT_CALLER(fname, fxn, line);
+		printk(" CF1: file/dentry=%p:%p fstart=%d dstart=%d\n",
+		       file, dentry, fstart, dstart);
+	}
+	if (fend != dend) {
+		PRINT_CALLER(fname, fxn, line);
+		printk(" CF2: file/dentry=%p:%p fend=%d dend=%d\n",
+		       file, dentry, fend, dend);
+	}
+	inode = dentry->d_inode;
+	if (!S_ISDIR(inode->i_mode)) {
+		if (fend != fstart) {
+			PRINT_CALLER(fname, fxn, line);
+			printk(" CF3: file/inode=%p:%p fstart=%d fend=%d\n",
+			       file, inode, fstart, fend);
+		}
+		if (dend != dstart) {
+			PRINT_CALLER(fname, fxn, line);
+			printk(" CF4: file/dentry=%p:%p dstart=%d dend=%d\n",
+			       file, dentry, dstart, dend);
+		}
+	}
+
+	/*
+	 * check for NULL dentries inside the start/end range, or
+	 * non-NULL dentries outside the start/end range.
+	 */
+	for (bindex = sbstart(sb); bindex < sbmax(sb); bindex++) {
+		lower_file = unionfs_lower_file_idx(file, bindex);
+		if (lower_file) {
+			if (bindex < fstart || bindex > fend) {
+				PRINT_CALLER(fname, fxn, line);
+				printk(" CF5: file/lower=%p:%p bindex=%d "
+				       "fstart/end=%d:%d\n",
+				       file, lower_file, bindex, fstart, fend);
+			}
+		} else {	/* lower_file == NULL */
+			if (bindex >= fstart && bindex <= fend) {
+				/*
+				 * directories can have NULL lower inodes in
+				 * b/t start/end, but NOT if at the
+				 * start/end range.
+				 */
+				if (!(S_ISDIR(inode->i_mode) &&
+				      bindex > fstart && bindex < fend)) {
+					PRINT_CALLER(fname, fxn, line);
+					printk(" CF6: file/lower=%p:%p "
+					       "bindex=%d fstart/end=%d:%d\n",
+					       file, lower_file, bindex,
+					       fstart, fend);
+				}
+			}
+		}
+	}
+
+	__unionfs_check_dentry(dentry,fname,fxn,line);
+}
+
+/* useful to track vfsmount leaks that could cause EBUSY on unmount */
+void __show_branch_counts(const struct super_block *sb,
+			  const char *file, const char *fxn, int line)
+{
+	int i;
+	struct vfsmount *mnt;
+
+	printk("BC:");
+	for (i=0; i<sbmax(sb); i++) {
+		if (sb->s_root)
+			mnt = UNIONFS_D(sb->s_root)->lower_paths[i].mnt;
+		else
+			mnt = NULL;
+		printk("%d:", (mnt ? atomic_read(&mnt->mnt_count) : -99));
+	}
+	printk("%s:%s:%d\n",file,fxn,line);
+}
+
+void __show_inode_times(const struct inode *inode,
+			const char *file, const char *fxn, int line)
+{
+	struct inode *lower_inode;
+	int bindex;
+
+	for (bindex=ibstart(inode); bindex <= ibend(inode); bindex++) {
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (!lower_inode)
+			continue;
+		printk("IT(%lu:%d): ", inode->i_ino, bindex);
+		printk("%s:%s:%d ",file,fxn,line);
+		printk("um=%lu/%lu lm=%lu/%lu ",
+		       inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
+		       lower_inode->i_mtime.tv_sec,
+		       lower_inode->i_mtime.tv_nsec);
+		printk("uc=%lu/%lu lc=%lu/%lu\n",
+		       inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
+		       lower_inode->i_ctime.tv_sec,
+		       lower_inode->i_ctime.tv_nsec);
+	}
+}
+
+void __show_dinode_times(const struct dentry *dentry,
+			const char *file, const char *fxn, int line)
+{
+	struct inode *inode = dentry->d_inode;
+	struct inode *lower_inode;
+	int bindex;
+
+	for (bindex=ibstart(inode); bindex <= ibend(inode); bindex++) {
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (!lower_inode)
+			continue;
+		printk("DT(%s:%lu:%d): ", dentry->d_name.name, inode->i_ino, bindex);
+		printk("%s:%s:%d ",file,fxn,line);
+		printk("um=%lu/%lu lm=%lu/%lu ",
+		       inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
+		       lower_inode->i_mtime.tv_sec,
+		       lower_inode->i_mtime.tv_nsec);
+		printk("uc=%lu/%lu lc=%lu/%lu\n",
+		       inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
+		       lower_inode->i_ctime.tv_sec,
+		       lower_inode->i_ctime.tv_nsec);
+	}
+}
+
+void __show_inode_counts(const struct inode *inode,
+			const char *file, const char *fxn, int line)
+{
+	struct inode *lower_inode;
+	int bindex;
+
+	if (!inode) {
+		printk("SiC: Null inode\n");
+		return;
+	}
+	for (bindex=sbstart(inode->i_sb); bindex <= sbend(inode->i_sb); bindex++) {
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (!lower_inode)
+			continue;
+		printk("SIC(%lu:%d:%d): ", inode->i_ino, bindex,
+		       atomic_read(&(inode)->i_count));
+		printk("lc=%d ", atomic_read(&(lower_inode)->i_count));
+		printk("%s:%s:%d\n",file,fxn,line);
+	}
+}
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 0be958f..00b0bc2 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -214,6 +214,7 @@ int is_newer_lower(const struct dentry *dentry)
 			printk("unionfs: new lower inode mtime "
 			       "(bindex=%d, name=%s)\n", bindex,
 			       dentry->d_name.name);
+			show_dinode_times(dentry);
 			return 1; /* mtime changed! */
 		}
 		if (timespec_compare(&inode->i_ctime,
@@ -221,6 +222,7 @@ int is_newer_lower(const struct dentry *dentry)
 			printk("unionfs: new lower inode ctime "
 			       "(bindex=%d, name=%s)\n", bindex,
 			       dentry->d_name.name);
+			show_dinode_times(dentry);
 			return 1; /* ctime changed! */
 		}
 	}
@@ -416,6 +418,7 @@ static int unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 	unionfs_lock_dentry(dentry);
 	err = __unionfs_d_revalidate_chain(dentry, nd, 0);
 	unionfs_unlock_dentry(dentry);
+	unionfs_check_dentry(dentry);
 
 	unionfs_read_unlock(dentry->d_sb);
 
@@ -432,6 +435,7 @@ static void unionfs_d_release(struct dentry *dentry)
 
 	unionfs_read_lock(dentry->d_sb);
 
+	unionfs_check_dentry(dentry);
 	/* this could be a negative dentry, so check first */
 	if (!UNIONFS_D(dentry)) {
 		printk(KERN_DEBUG "unionfs: dentry without private data: %.*s",
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index b33f44f..e9e63b7 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -26,6 +26,7 @@ static ssize_t unionfs_read(struct file *file, char __user *buf,
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
+	unionfs_check_file(file);
 
 	err = do_sync_read(file, buf, count, ppos);
 
@@ -35,6 +36,7 @@ static ssize_t unionfs_read(struct file *file, char __user *buf,
 
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	unionfs_check_file(file);
 	return err;
 }
 
@@ -47,6 +49,7 @@ static ssize_t unionfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
+	unionfs_check_file(file);
 
 	err = generic_file_aio_read(iocb, iov, nr_segs, pos);
 
@@ -59,6 +62,7 @@ static ssize_t unionfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
 
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	unionfs_check_file(file);
 	return err;
 }
 
@@ -70,11 +74,14 @@ static ssize_t unionfs_write(struct file *file, const char __user *buf,
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
+	unionfs_check_file(file);
 
 	err = do_sync_write(file, buf, count, ppos);
 	/* update our inode times upon a successful lower write */
-	if (err >= 0)
+	if (err >= 0) {
 		unionfs_copy_attr_times(file->f_path.dentry->d_inode);
+		unionfs_check_file(file);
+	}
 
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
@@ -99,6 +106,7 @@ static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
 	willwrite = ((vma->vm_flags | VM_SHARED | VM_WRITE) == vma->vm_flags);
 	if ((err = unionfs_file_revalidate(file, willwrite)))
 		goto out;
+	unionfs_check_file(file);
 
 	/*
 	 * File systems which do not implement ->writepage may use
@@ -123,9 +131,12 @@ static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
 
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
-	if (!err)
+	if (!err) {
 		/* copyup could cause parent dir times to change */
 		unionfs_copy_attr_times(file->f_path.dentry->d_parent->d_inode);
+		unionfs_check_file(file);
+		unionfs_check_dentry(file->f_path.dentry->d_parent);
+	}
 	return err;
 }
 
@@ -140,6 +151,7 @@ int unionfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
+	unionfs_check_file(file);
 
 	bstart = fbstart(file);
 	bend = fbend(file);
@@ -171,6 +183,7 @@ int unionfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	unionfs_check_file(file);
 	return err;
 }
 
@@ -185,6 +198,7 @@ int unionfs_fasync(int fd, struct file *file, int flag)
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
+	unionfs_check_file(file);
 
 	bstart = fbstart(file);
 	bend = fbend(file);
@@ -214,6 +228,7 @@ int unionfs_fasync(int fd, struct file *file, int flag)
 
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	unionfs_check_file(file);
 	return err;
 }
 
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 218320e..9adf272 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -227,6 +227,10 @@ out:
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 
+	unionfs_check_inode(parent);
+	if (!err)
+		unionfs_check_dentry(dentry->d_parent);
+	unionfs_check_dentry(dentry);
 	return err;
 }
 
@@ -265,6 +269,9 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 		unionfs_copy_attr_times(dentry->d_parent->d_inode);
 	}
 
+	unionfs_check_inode(parent);
+	unionfs_check_dentry(dentry);
+	unionfs_check_dentry(dentry->d_parent);
 	unionfs_read_unlock(dentry->d_sb);
 
 	return ret;
@@ -410,6 +417,9 @@ out:
 	unionfs_unlock_dentry(new_dentry);
 	unionfs_unlock_dentry(old_dentry);
 
+	unionfs_check_inode(dir);
+	unionfs_check_dentry(new_dentry);
+	unionfs_check_dentry(old_dentry);
 	unionfs_read_unlock(old_dentry->d_sb);
 
 	return err;
@@ -570,6 +580,8 @@ out:
 		unionfs_postcopyup_setmnt(dentry);
 	unionfs_unlock_dentry(dentry);
 
+	unionfs_check_inode(dir);
+	unionfs_check_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 
 	return err;
@@ -718,6 +730,8 @@ out:
 	if (!err)
 		unionfs_copy_attr_times(dentry->d_inode);
 	unionfs_unlock_dentry(dentry);
+	unionfs_check_inode(parent);
+	unionfs_check_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 
 	return err;
@@ -845,6 +859,8 @@ out:
 		unionfs_postcopyup_setmnt(dentry);
 	unionfs_unlock_dentry(dentry);
 
+	unionfs_check_inode(dir);
+	unionfs_check_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 
 	return err;
@@ -880,6 +896,7 @@ static int unionfs_readlink(struct dentry *dentry, char __user *buf,
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_check_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 
 	return err;
@@ -925,6 +942,7 @@ static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	err = 0;
 
 out:
+	unionfs_check_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return ERR_PTR(err);
 }
@@ -940,6 +958,7 @@ static void unionfs_put_link(struct dentry *dentry, struct nameidata *nd,
 		printk("unionfs: put_link failed to revalidate dentry\n");
 	unionfs_unlock_dentry(dentry);
 
+	unionfs_check_dentry(dentry);
 	kfree(nd_get_link(nd));
 	unionfs_read_unlock(dentry->d_sb);
 }
@@ -1067,6 +1086,7 @@ static int unionfs_permission(struct inode *inode, int mask,
 	unionfs_copy_attr_times(inode);
 
 out:
+	unionfs_check_inode(inode);
 	return err;
 }
 
@@ -1153,6 +1173,8 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	unionfs_copy_attr_times(dentry->d_parent->d_inode);
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_check_dentry(dentry);
+	unionfs_check_dentry(dentry->d_parent);
 	unionfs_read_unlock(dentry->d_sb);
 
 	return err;
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index e05e6a2..6ef19af 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -213,6 +213,7 @@ static int unionfs_readpage(struct file *file, struct page *page)
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
+	unionfs_check_file(file);
 
 	err = unionfs_do_readpage(file, page);
 
@@ -229,6 +230,7 @@ static int unionfs_readpage(struct file *file, struct page *page)
 	 */
 out:
 	unlock_page(page);
+	unionfs_check_file(file);
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
 
 	return err;
@@ -253,6 +255,7 @@ static int unionfs_prepare_write(struct file *file, struct page *page,
 	 */
 	unionfs_copy_attr_times(file->f_path.dentry->d_inode);
 	err = unionfs_file_revalidate(file, 1);
+	unionfs_check_file(file);
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
 
 	return err;
@@ -274,6 +277,7 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
+	unionfs_check_file(file);
 
 	inode = page->mapping->host;
 	lower_inode = unionfs_lower_inode(inode);
@@ -319,6 +323,7 @@ out:
 		ClearPageUptodate(page);
 
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	unionfs_check_file(file);
 	return err;		/* assume all is ok */
 }
 
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 7aa7e57..b8d406c 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -513,6 +513,10 @@ out:
 		unionfs_copy_attr_times(new_dir);
 		unionfs_copy_attr_times(old_dentry->d_inode);
 		unionfs_copy_attr_times(new_dentry->d_inode);
+		unionfs_check_inode(old_dir);
+		unionfs_check_inode(new_dir);
+		unionfs_check_dentry(old_dentry);
+		unionfs_check_dentry(new_dentry);
 	}
 
 	unionfs_unlock_dentry(new_dentry);
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 3f972df..bfac7a4 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -130,6 +130,7 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		err = -ESTALE;
 		goto out;
 	}
+	unionfs_check_dentry(dentry);
 
 	lower_dentry = unionfs_lower_dentry(sb->s_root);
 	err = vfs_statfs(lower_dentry, buf);
@@ -153,6 +154,7 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_check_dentry(dentry);
 	unionfs_read_unlock(sb);
 	return err;
 }
@@ -790,6 +792,7 @@ out_free:
 	kfree(new_lower_inodes);
 out_error:
 	unionfs_write_unlock(sb);
+	unionfs_check_dentry(sb->s_root);
 	return err;
 }
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index ce43a50..adad6a5 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -472,22 +472,15 @@ static inline struct vfsmount *unionfs_mntget(struct dentry *dentry,
 {
 	struct vfsmount *mnt;
 
-	if (!dentry) {
-		if (bindex < 0)
-			return NULL;
-		if (!dentry && bindex >= 0) {
-			return NULL;
-		}
-	}
-	mnt = unionfs_lower_mnt_idx(dentry, bindex);
-	if (!mnt) {
-		if (bindex < 0)
-			return NULL;
-		if (!mnt && bindex >= 0) {
-			return NULL;
-		}
-	}
-	mnt = mntget(mnt);
+	BUG_ON(!dentry || bindex < 0);
+
+	mnt = mntget(unionfs_lower_mnt_idx(dentry, bindex));
+#ifdef CONFIG_UNION_FS_DEBUG
+	if (!mnt)
+		printk(KERN_DEBUG "unionfs_mntget: mnt=%p bindex=%d\n",
+		       mnt, bindex);
+#endif /* CONFIG_UNION_FS_DEBUG */
+
 	return mnt;
 }
 
@@ -495,24 +488,74 @@ static inline void unionfs_mntput(struct dentry *dentry, int bindex)
 {
 	struct vfsmount *mnt;
 
-	if (!dentry) {
-		if (bindex < 0)
-			return;
-		if (!dentry && bindex >= 0) {
-			return;
-		}
-	}
+	if (!dentry && bindex < 0)
+		return;
+	BUG_ON(!dentry || bindex < 0);
+
 	mnt = unionfs_lower_mnt_idx(dentry, bindex);
-	if (!mnt) {
-		if (bindex < 0)
-			return;
-		if (!mnt && bindex >= 0) {
-			return;
-		}
-	}
+#ifdef CONFIG_UNION_FS_DEBUG
+	/*
+	 * Directories can have NULL lower objects in between start/end, but
+	 * NOT if at the start/end range.  We cannot verify that this dentry
+	 * is a type=DIR, because it may already be a negative dentry.  But
+	 * if dbstart is greater than dbend, we know that this couldn't have
+	 * been a regular file: it had to have been a directory.
+	 */
+	if (!mnt && !(bindex > dbstart(dentry) && bindex < dbend(dentry)))
+		printk(KERN_WARNING
+		       "unionfs_mntput: mnt=%p bindex=%d\n",
+		       mnt, bindex);
+#endif /* CONFIG_UNION_FS_DEBUG */
 	mntput(mnt);
 }
 
-
+#ifdef CONFIG_UNION_FS_DEBUG
+
+/* useful for tracking code reachability */
+#define UDBG printk("DBG:%s:%s:%d\n",__FILE__,__FUNCTION__,__LINE__)
+
+#define unionfs_check_inode(i)	__unionfs_check_inode((i),	\
+	__FILE__,__FUNCTION__,__LINE__)
+#define unionfs_check_dentry(d)	__unionfs_check_dentry((d),	\
+	__FILE__,__FUNCTION__,__LINE__)
+#define unionfs_check_file(f)	__unionfs_check_file((f),	\
+	__FILE__,__FUNCTION__,__LINE__)
+#define show_branch_counts(sb)	__show_branch_counts((sb),	\
+	__FILE__,__FUNCTION__,__LINE__)
+#define show_inode_times(i)	__show_inode_times((i),		\
+	__FILE__,__FUNCTION__,__LINE__)
+#define show_dinode_times(d)	__show_dinode_times((d),	\
+	__FILE__,__FUNCTION__,__LINE__)
+#define show_inode_counts(i)	__show_inode_counts((i),	\
+	__FILE__,__FUNCTION__,__LINE__)
+
+extern void __unionfs_check_inode(const struct inode *inode, const char *fname,
+				  const char *fxn, int line);
+extern void __unionfs_check_dentry(const struct dentry *dentry,
+				   const char *fname, const char *fxn,
+				   int line);
+extern void __unionfs_check_file(const struct file *file,
+				 const char *fname, const char *fxn, int line);
+extern void __show_branch_counts(const struct super_block *sb,
+				 const char *file, const char *fxn, int line);
+extern void __show_inode_times(const struct inode *inode,
+			       const char *file, const char *fxn, int line);
+extern void __show_dinode_times(const struct dentry *dentry,
+				const char *file, const char *fxn, int line);
+extern void __show_inode_counts(const struct inode *inode,
+			        const char *file, const char *fxn, int line);
+
+#else /* not CONFIG_UNION_FS_DEBUG */
+
+/* we leave useful hooks for these check functions throughout the code */
+#define unionfs_check_inode(i)		do { } while(0)
+#define unionfs_check_dentry(d)	do { } while(0)
+#define unionfs_check_file(f)		do { } while(0)
+#define show_branch_counts(sb)		do { } while(0)
+#define show_inode_times(i)		do { } while(0)
+#define show_dinode_times(d)		do { } while(0)
+#define show_inode_counts(i)		do { } while(0)
+
+#endif /* not CONFIG_UNION_FS_DEBUG */
 
 #endif	/* not _UNION_H_ */
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 50ed351..4ea350a 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -83,6 +83,7 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 		err = -ESTALE;
 		goto out;
 	}
+	unionfs_check_dentry(dentry);
 
 	err = unionfs_unlink_whiteout(dir, dentry);
 	/* call d_drop so the system "forgets" about us */
@@ -98,6 +99,10 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 
 out:
+	if (!err) {
+		unionfs_check_dentry(dentry);
+		unionfs_check_inode(dir);
+	}
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return err;
@@ -147,6 +152,7 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 		err = -ESTALE;
 		goto out;
 	}
+	unionfs_check_dentry(dentry);
 
 	/* check if this unionfs directory is empty or not */
 	err = check_empty(dentry, &namelist);
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 6ab92f3..ee7da13 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -59,6 +59,7 @@ ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_check_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
@@ -88,6 +89,7 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_check_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
@@ -115,6 +117,7 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_check_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
@@ -144,6 +147,7 @@ ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_check_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
-- 
1.5.2.2.238.g7cbf2f2

