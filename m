Return-Path: <linux-kernel-owner+w=401wt.eu-S939109AbZDJHes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939109AbZDJHes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938513AbZDJHZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:25:38 -0400
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:62350 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938511AbZDJHZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:25:35 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 21/29] aufs debugfs entries
Date: Fri, 10 Apr 2009 16:02:35 +0900
Message-Id: <1239346963-30953-22-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
sysfs entries, compiled only when CONFIG_DEBUG_FS is enabled

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/ABI/testing/debugfs-aufs |   40 ++++
 fs/aufs/dbgaufs.c                      |  304 ++++++++++++++++++++++++++++++++
 fs/aufs/dbgaufs.h                      |   68 +++++++
 3 files changed, 412 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-aufs
 create mode 100644 fs/aufs/dbgaufs.c
 create mode 100644 fs/aufs/dbgaufs.h

diff --git a/Documentation/ABI/testing/debugfs-aufs b/Documentation/ABI/testing/debugfs-aufs
new file mode 100644
index 0000000..4110b94
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-aufs
@@ -0,0 +1,40 @@
+What:		/debug/aufs/si_<id>/
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		Under /debug/aufs, a directory named si_<id> is created
+		per aufs mount, where <id> is a unique id generated
+		internally.
+
+What:		/debug/aufs/si_<id>/xib
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the consumed blocks by xib (External Inode Number
+		Bitmap), its block size and file size.
+		When the aufs mount option 'noxino' is specified, it
+		will be empty. About XINO files, see
+		Documentation/filesystems/aufs/aufs.5 in detail.
+
+What:		/debug/aufs/si_<id>/xino0, xino1 ... xinoN
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the consumed blocks by xino (External Inode Number
+		Translation Table), its link count, block size and file
+		size.
+		When the aufs mount option 'noxino' is specified, it
+		will be empty. About XINO files, see
+		Documentation/filesystems/aufs/aufs.5 in detail.
+
+What:		/debug/aufs/si_<id>/xigen
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the consumed blocks by xigen (External Inode
+		Generation Table), its block size and file size.
+		If CONFIG_AUFS_EXPORT is disabled, this entry will not
+		be created.
+		When the aufs mount option 'noxino' is specified, it
+		will be empty. About XINO files, see
+		Documentation/filesystems/aufs/aufs.5 in detail.
diff --git a/fs/aufs/dbgaufs.c b/fs/aufs/dbgaufs.c
new file mode 100644
index 0000000..cb04b5d
--- /dev/null
+++ b/fs/aufs/dbgaufs.c
@@ -0,0 +1,304 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * debugfs interface
+ */
+
+#include <linux/debugfs.h>
+#include "aufs.h"
+
+#ifndef CONFIG_SYSFS
+#error DEBUG_FS depends upon SYSFS
+#endif
+
+static struct dentry *dbgaufs;
+static const mode_t dbgaufs_mode = S_IRUSR | S_IRGRP | S_IROTH;
+
+/* 20 is max digits length of ulong 64 */
+struct dbgaufs_arg {
+	int n;
+	char a[20 * 4];
+};
+
+/*
+ * common function for all XINO files
+ */
+static int dbgaufs_xi_release(struct inode *inode __maybe_unused,
+			      struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static int dbgaufs_xi_open(struct file *xf, struct file *file, int do_fcnt)
+{
+	int err;
+	struct kstat st;
+	struct dbgaufs_arg *p;
+
+	err = -ENOMEM;
+	p = kmalloc(sizeof(*p), GFP_NOFS);
+	if (unlikely(!p))
+		goto out;
+
+	err = 0;
+	p->n = 0;
+	file->private_data = p;
+	if (!xf)
+		goto out;
+
+	err = vfs_getattr(xf->f_vfsmnt, xf->f_dentry, &st);
+	if (!err) {
+		if (do_fcnt)
+			p->n = snprintf
+				(p->a, sizeof(p->a), "%ld, %llux%lu %lld\n",
+				 (long)file_count(xf), st.blocks, st.blksize,
+				 (long long)st.size);
+		else
+			p->n = snprintf(p->a, sizeof(p->a), "%llux%lu %lld\n",
+					st.blocks, st.blksize,
+					(long long)st.size);
+		AuDebugOn(p->n >= sizeof(p->a));
+	} else {
+		p->n = snprintf(p->a, sizeof(p->a), "err %d\n", err);
+		err = 0;
+	}
+
+ out:
+	return err;
+
+}
+
+static ssize_t dbgaufs_xi_read(struct file *file, char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	struct dbgaufs_arg *p;
+
+	p = file->private_data;
+	return simple_read_from_buffer(buf, count, ppos, p->a, p->n);
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int dbgaufs_xib_open(struct inode *inode, struct file *file)
+{
+	int err;
+	struct au_sbinfo *sbinfo;
+	struct super_block *sb;
+
+	sbinfo = inode->i_private;
+	sb = sbinfo->si_sb;
+	si_noflush_read_lock(sb);
+	err = dbgaufs_xi_open(sbinfo->si_xib, file, /*do_fcnt*/0);
+	si_read_unlock(sb);
+	return err;
+}
+
+static const struct file_operations dbgaufs_xib_fop = {
+	.open		= dbgaufs_xib_open,
+	.release	= dbgaufs_xi_release,
+	.read		= dbgaufs_xi_read
+};
+
+/* ---------------------------------------------------------------------- */
+
+#define DbgaufsXi_PREFIX "xi"
+
+static int dbgaufs_xino_open(struct inode *inode, struct file *file)
+{
+	int err;
+	long l;
+	struct au_sbinfo *sbinfo;
+	struct super_block *sb;
+	struct file *xf;
+	struct qstr *name;
+
+	err = -ENOENT;
+	xf = NULL;
+	name = &file->f_dentry->d_name;
+	if (unlikely(name->len < sizeof(DbgaufsXi_PREFIX)
+		     || memcmp(name->name, DbgaufsXi_PREFIX,
+			       sizeof(DbgaufsXi_PREFIX) - 1)))
+		goto out;
+	err = strict_strtol(name->name + sizeof(DbgaufsXi_PREFIX) - 1, 10, &l);
+	if (unlikely(err))
+		goto out;
+
+	sbinfo = inode->i_private;
+	sb = sbinfo->si_sb;
+	si_noflush_read_lock(sb);
+	if (l <= au_sbend(sb)) {
+		xf = au_sbr(sb, (aufs_bindex_t)l)->br_xino.xi_file;
+		err = dbgaufs_xi_open(xf, file, /*do_fcnt*/1);
+	} else
+		err = -ENOENT;
+	si_read_unlock(sb);
+
+ out:
+	return err;
+}
+
+static const struct file_operations dbgaufs_xino_fop = {
+	.open		= dbgaufs_xino_open,
+	.release	= dbgaufs_xi_release,
+	.read		= dbgaufs_xi_read
+};
+
+void dbgaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex)
+{
+	aufs_bindex_t bend;
+	struct au_branch *br;
+	struct au_xino_file *xi;
+
+	if (!au_sbi(sb)->si_dbgaufs)
+		return;
+
+	bend = au_sbend(sb);
+	for (; bindex <= bend; bindex++) {
+		br = au_sbr(sb, bindex);
+		xi = &br->br_xino;
+		if (xi->xi_dbgaufs) {
+			debugfs_remove(xi->xi_dbgaufs);
+			xi->xi_dbgaufs = NULL;
+		}
+	}
+}
+
+void dbgaufs_brs_add(struct super_block *sb, aufs_bindex_t bindex)
+{
+	struct au_sbinfo *sbinfo;
+	struct dentry *parent;
+	struct au_branch *br;
+	struct au_xino_file *xi;
+	aufs_bindex_t bend;
+	char name[sizeof(DbgaufsXi_PREFIX) + 5]; /* "xi" bindex NULL */
+
+	sbinfo = au_sbi(sb);
+	parent = sbinfo->si_dbgaufs;
+	if (!parent)
+		return;
+
+	bend = au_sbend(sb);
+	for (; bindex <= bend; bindex++) {
+		snprintf(name, sizeof(name), DbgaufsXi_PREFIX "%d", bindex);
+		br = au_sbr(sb, bindex);
+		xi = &br->br_xino;
+		AuDebugOn(xi->xi_dbgaufs);
+		xi->xi_dbgaufs = debugfs_create_file(name, dbgaufs_mode, parent,
+						     sbinfo, &dbgaufs_xino_fop);
+		/* ignore an error */
+		if (unlikely(!xi->xi_dbgaufs))
+			AuWarn1("failed %s under debugfs\n", name);
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+#ifdef CONFIG_AUFS_EXPORT
+static int dbgaufs_xigen_open(struct inode *inode, struct file *file)
+{
+	int err;
+	struct au_sbinfo *sbinfo;
+	struct super_block *sb;
+
+	sbinfo = inode->i_private;
+	sb = sbinfo->si_sb;
+	si_noflush_read_lock(sb);
+	err = dbgaufs_xi_open(sbinfo->si_xigen, file, /*do_fcnt*/0);
+	si_read_unlock(sb);
+	return err;
+}
+
+static const struct file_operations dbgaufs_xigen_fop = {
+	.open		= dbgaufs_xigen_open,
+	.release	= dbgaufs_xi_release,
+	.read		= dbgaufs_xi_read
+};
+
+static int dbgaufs_xigen_init(struct au_sbinfo *sbinfo)
+{
+	int err;
+
+	err = -EIO;
+	sbinfo->si_dbgaufs_xigen = debugfs_create_file
+		("xigen", dbgaufs_mode, sbinfo->si_dbgaufs, sbinfo,
+		 &dbgaufs_xigen_fop);
+	if (sbinfo->si_dbgaufs_xigen)
+		err = 0;
+
+	return err;
+}
+#else
+static int dbgaufs_xigen_init(struct au_sbinfo *sbinfo)
+{
+	return 0;
+}
+#endif /* CONFIG_AUFS_EXPORT */
+
+/* ---------------------------------------------------------------------- */
+
+void dbgaufs_si_fin(struct au_sbinfo *sbinfo)
+{
+	debugfs_remove_recursive(sbinfo->si_dbgaufs);
+	sbinfo->si_dbgaufs = NULL;
+	kobject_put(&sbinfo->si_kobj);
+}
+
+int dbgaufs_si_init(struct au_sbinfo *sbinfo)
+{
+	int err;
+	char name[SysaufsSiNameLen];
+
+	err = -ENOENT;
+	if (!dbgaufs) {
+		AuErr1("/debug/aufs is uninitialized\n");
+		goto out;
+	}
+
+	err = -EIO;
+	sysaufs_name(sbinfo, name);
+	sbinfo->si_dbgaufs = debugfs_create_dir(name, dbgaufs);
+	if (unlikely(!sbinfo->si_dbgaufs))
+		goto out;
+	kobject_get(&sbinfo->si_kobj);
+
+	sbinfo->si_dbgaufs_xib = debugfs_create_file
+		("xib", dbgaufs_mode, sbinfo->si_dbgaufs, sbinfo,
+		 &dbgaufs_xib_fop);
+	if (unlikely(!sbinfo->si_dbgaufs_xib))
+		goto out_dir;
+
+	err = dbgaufs_xigen_init(sbinfo);
+	if (!err)
+		goto out; /* success */
+
+ out_dir:
+	dbgaufs_si_fin(sbinfo);
+ out:
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+void dbgaufs_fin(void)
+{
+	debugfs_remove(dbgaufs);
+}
+
+int __init dbgaufs_init(void)
+{
+	int err;
+
+	err = -EIO;
+	dbgaufs = debugfs_create_dir(AUFS_NAME, NULL);
+	if (dbgaufs)
+		err = 0;
+	return err;
+}
diff --git a/fs/aufs/dbgaufs.h b/fs/aufs/dbgaufs.h
new file mode 100644
index 0000000..dfb0f0a
--- /dev/null
+++ b/fs/aufs/dbgaufs.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * debugfs interface
+ */
+
+#ifndef __DBGAUFS_H__
+#define __DBGAUFS_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/aufs_type.h>
+
+struct au_sbinfo;
+#ifdef CONFIG_DEBUG_FS
+/* dbgaufs.c */
+void dbgaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex);
+void dbgaufs_brs_add(struct super_block *sb, aufs_bindex_t bindex);
+void dbgaufs_si_fin(struct au_sbinfo *sbinfo);
+int dbgaufs_si_init(struct au_sbinfo *sbinfo);
+void dbgaufs_fin(void);
+int __init dbgaufs_init(void);
+
+#else
+
+static inline
+void dbgaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex)
+{
+	/* empty */
+}
+
+static inline
+void dbgaufs_brs_add(struct super_block *sb, aufs_bindex_t bindex)
+{
+	/* empty */
+}
+
+static inline
+void dbgaufs_si_fin(struct au_sbinfo *sbinfo)
+{
+	/* empty */
+}
+
+static inline
+int dbgaufs_si_init(struct au_sbinfo *sbinfo)
+{
+	return 0;
+}
+
+#define dbgaufs_fin()	do {} while (0)
+
+static inline
+int __init dbgaufs_init(void)
+{
+	return 0;
+}
+#endif /* CONFIG_DEBUG_FS */
+
+#endif /* __KERNEL__ */
+#endif /* __DBGAUFS_H__ */
-- 
1.6.1.284.g5dc13

