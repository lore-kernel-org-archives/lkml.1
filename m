Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZCPHcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZCPHcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZCPHYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:24:21 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:35641 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZCPHWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:22:53 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #2 18/28] aufs direcotry
Date: Mon, 16 Mar 2009 16:20:30 +0900
Message-Id: <1237188040-11404-19-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
directory operations
virtual or vertical(stacked) directory

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/dir.c  |  493 +++++++++++++++++++++++++++++++++++
 fs/aufs/dir.h  |  104 ++++++++
 fs/aufs/vdir.c |  776 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1373 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/dir.c
 create mode 100644 fs/aufs/dir.h
 create mode 100644 fs/aufs/vdir.c

diff --git a/fs/aufs/dir.c b/fs/aufs/dir.c
new file mode 100644
index 0000000..44c78c9
--- /dev/null
+++ b/fs/aufs/dir.c
@@ -0,0 +1,493 @@
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
+ * directory operations
+ */
+
+#include <linux/fs_stack.h>
+#include "aufs.h"
+
+void au_add_nlink(struct inode *dir, struct inode *h_dir)
+{
+	AuDebugOn(!S_ISDIR(dir->i_mode) || !S_ISDIR(h_dir->i_mode));
+
+	dir->i_nlink += h_dir->i_nlink - 2;
+	if (h_dir->i_nlink < 2)
+		dir->i_nlink += 2;
+}
+
+void au_sub_nlink(struct inode *dir, struct inode *h_dir)
+{
+	AuDebugOn(!S_ISDIR(dir->i_mode) || !S_ISDIR(h_dir->i_mode));
+
+	dir->i_nlink -= h_dir->i_nlink - 2;
+	if (h_dir->i_nlink < 2)
+		dir->i_nlink -= 2;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int reopen_dir(struct file *file)
+{
+	int err;
+	unsigned int flags;
+	aufs_bindex_t bindex, btail, bstart;
+	struct dentry *dentry, *h_dentry;
+	struct file *h_file;
+
+	/* open all lower dirs */
+	dentry = file->f_dentry;
+	bstart = au_dbstart(dentry);
+	for (bindex = au_fbstart(file); bindex < bstart; bindex++)
+		au_set_h_fptr(file, bindex, NULL);
+	au_set_fbstart(file, bstart);
+
+	btail = au_dbtaildir(dentry);
+	for (bindex = au_fbend(file); btail < bindex; bindex--)
+		au_set_h_fptr(file, bindex, NULL);
+	au_set_fbend(file, btail);
+
+	flags = file->f_flags;
+	for (bindex = bstart; bindex <= btail; bindex++) {
+		h_dentry = au_h_dptr(dentry, bindex);
+		if (!h_dentry)
+			continue;
+		h_file = au_h_fptr(file, bindex);
+		if (h_file)
+			continue;
+
+		h_file = au_h_open(dentry, bindex, flags, file);
+		err = PTR_ERR(h_file);
+		if (IS_ERR(h_file))
+			goto out; /* close all? */
+		au_set_h_fptr(file, bindex, h_file);
+	}
+	au_update_figen(file);
+	/* todo: necessary? */
+	/* file->f_ra = h_file->f_ra; */
+	err = 0;
+
+ out:
+	return err;
+}
+
+static int do_open_dir(struct file *file, int flags)
+{
+	int err;
+	aufs_bindex_t bindex, btail;
+	struct dentry *dentry, *h_dentry;
+	struct file *h_file;
+
+	err = 0;
+	dentry = file->f_dentry;
+	au_set_fvdir_cache(file, NULL);
+	au_fi(file)->fi_maintain_plink = 0;
+	file->f_version = dentry->d_inode->i_version;
+	bindex = au_dbstart(dentry);
+	au_set_fbstart(file, bindex);
+	btail = au_dbtaildir(dentry);
+	au_set_fbend(file, btail);
+	for (; !err && bindex <= btail; bindex++) {
+		h_dentry = au_h_dptr(dentry, bindex);
+		if (!h_dentry)
+			continue;
+
+		h_file = au_h_open(dentry, bindex, flags, file);
+		if (IS_ERR(h_file)) {
+			err = PTR_ERR(h_file);
+			break;
+		}
+		au_set_h_fptr(file, bindex, h_file);
+	}
+	au_update_figen(file);
+	/* todo: necessary? */
+	/* file->f_ra = h_file->f_ra; */
+	if (!err)
+		return 0; /* success */
+
+	/* close all */
+	for (bindex = au_fbstart(file); bindex <= btail; bindex++)
+		au_set_h_fptr(file, bindex, NULL);
+	au_set_fbstart(file, -1);
+	au_set_fbend(file, -1);
+	return err;
+}
+
+static int aufs_open_dir(struct inode *inode __maybe_unused,
+			 struct file *file)
+{
+	return au_do_open(file, do_open_dir);
+}
+
+static int aufs_release_dir(struct inode *inode __maybe_unused,
+			    struct file *file)
+{
+	struct au_vdir *vdir_cache;
+	struct super_block *sb;
+	struct au_sbinfo *sbinfo;
+
+	sb = file->f_dentry->d_sb;
+	si_noflush_read_lock(sb);
+	fi_write_lock(file);
+	vdir_cache = au_fvdir_cache(file);
+	if (vdir_cache)
+		au_vdir_free(vdir_cache);
+	if (au_fi(file)->fi_maintain_plink) {
+		sbinfo = au_sbi(sb);
+		au_fclr_si(sbinfo, MAINTAIN_PLINK);
+		wake_up_all(&sbinfo->si_plink_wq);
+	}
+	fi_write_unlock(file);
+	au_finfo_fin(file);
+	si_read_unlock(sb);
+	return 0;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int au_do_fsync_dir_no_file(struct dentry *dentry, int datasync)
+{
+	int err;
+	aufs_bindex_t bend, bindex;
+	struct inode *inode;
+	struct super_block *sb;
+
+	err = 0;
+	sb = dentry->d_sb;
+	inode = dentry->d_inode;
+	IMustLock(inode);
+	bend = au_dbend(dentry);
+	for (bindex = au_dbstart(dentry); !err && bindex <= bend; bindex++) {
+		struct path h_path;
+		struct inode *h_inode;
+		struct file_operations *fop;
+
+		if (au_test_ro(sb, bindex, inode))
+			continue;
+		h_path.dentry = au_h_dptr(dentry, bindex);
+		if (!h_path.dentry)
+			continue;
+		h_inode = h_path.dentry->d_inode;
+		if (!h_inode)
+			continue;
+
+		/* no mnt_want_write() */
+		/* cf. fs/nsfd/vfs.c and fs/nfsd/nfs4recover.c */
+		/* todo: inotiry fired? */
+		h_path.mnt = au_sbr_mnt(sb, bindex);
+		mutex_lock(&h_inode->i_mutex);
+		fop = (void *)h_inode->i_fop;
+		err = filemap_fdatawrite(h_inode->i_mapping);
+		if (!err && fop && fop->fsync)
+			err = fop->fsync(NULL, h_path.dentry, datasync);
+		if (!err)
+			err = filemap_fdatawrite(h_inode->i_mapping);
+		if (!err)
+			vfsub_update_h_iattr(&h_path, /*did*/NULL); /*ignore*/
+		mutex_unlock(&h_inode->i_mutex);
+	}
+
+	return err;
+}
+
+static int au_do_fsync_dir(struct file *file, int datasync)
+{
+	int err;
+	aufs_bindex_t bend, bindex;
+	struct file *h_file;
+	struct super_block *sb;
+	struct inode *inode;
+	struct mutex *h_mtx;
+
+	err = au_reval_and_lock_fdi(file, reopen_dir, /*wlock*/1);
+	if (unlikely(err))
+		goto out;
+
+	sb = file->f_dentry->d_sb;
+	inode = file->f_dentry->d_inode;
+	bend = au_fbend(file);
+	for (bindex = au_fbstart(file); !err && bindex <= bend; bindex++) {
+		h_file = au_h_fptr(file, bindex);
+		if (!h_file || au_test_ro(sb, bindex, inode))
+			continue;
+
+		err = vfs_fsync(h_file, h_file->f_dentry, datasync);
+		if (!err) {
+			h_mtx = &h_file->f_dentry->d_inode->i_mutex;
+			mutex_lock(h_mtx);
+			vfsub_update_h_iattr(&h_file->f_path, /*did*/NULL);
+			/*ignore*/
+			mutex_unlock(h_mtx);
+		}
+	}
+
+ out:
+	return err;
+}
+
+/*
+ * @file may be NULL
+ */
+static int aufs_fsync_dir(struct file *file, struct dentry *dentry,
+			  int datasync)
+{
+	int err;
+	struct super_block *sb;
+
+	IMustLock(dentry->d_inode);
+
+	err = 0;
+	sb = dentry->d_sb;
+	si_noflush_read_lock(sb);
+	if (file)
+		err = au_do_fsync_dir(file, datasync);
+	else {
+		di_write_lock_child(dentry);
+		err = au_do_fsync_dir_no_file(dentry, datasync);
+	}
+	au_cpup_attr_timesizes(dentry->d_inode);
+	di_write_unlock(dentry);
+	if (file)
+		fi_write_unlock(file);
+
+	si_read_unlock(sb);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int aufs_readdir(struct file *file, void *dirent, filldir_t filldir)
+{
+	int err;
+	struct dentry *dentry;
+	struct inode *inode;
+	struct super_block *sb;
+
+	dentry = file->f_dentry;
+	inode = dentry->d_inode;
+	IMustLock(inode);
+
+	sb = dentry->d_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+	err = au_reval_and_lock_fdi(file, reopen_dir, /*wlock*/1);
+	if (unlikely(err))
+		goto out;
+	err = au_vdir_init(file);
+	di_downgrade_lock(dentry, AuLock_IR);
+	if (unlikely(err))
+		goto out_unlock;
+
+	err = au_vdir_fill_de(file, dirent, filldir);
+	fsstack_copy_attr_atime(inode, au_h_iptr(inode, au_ibstart(inode)));
+
+ out_unlock:
+	di_read_unlock(dentry, AuLock_IR);
+	fi_write_unlock(file);
+ out:
+	si_read_unlock(sb);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+#define AuTestEmpty_WHONLY	1
+#define AuTestEmpty_CALLED	(1 << 2)
+#define au_ftest_testempty(flags, name)	((flags) & AuTestEmpty_##name)
+#define au_fset_testempty(flags, name)	{ (flags) |= AuTestEmpty_##name; }
+#define au_fclr_testempty(flags, name)	{ (flags) &= ~AuTestEmpty_##name; }
+
+struct test_empty_arg {
+	struct au_nhash *whlist;
+	unsigned int flags;
+	int err;
+	aufs_bindex_t bindex;
+};
+
+static int test_empty_cb(void *__arg, const char *__name, int namelen,
+			 loff_t offset __maybe_unused, u64 ino __maybe_unused,
+			 unsigned int d_type __maybe_unused)
+{
+	struct test_empty_arg *arg = __arg;
+	char *name = (void *)__name;
+
+	arg->err = 0;
+	au_fset_testempty(arg->flags, CALLED);
+	/* smp_mb(); */
+	if (name[0] == '.'
+	    && (namelen == 1 || (name[1] == '.' && namelen == 2)))
+		goto out; /* success */
+
+	if (namelen <= AUFS_WH_PFX_LEN
+	    || memcmp(name, AUFS_WH_PFX, AUFS_WH_PFX_LEN)) {
+		if (au_ftest_testempty(arg->flags, WHONLY)
+		    && !au_nhash_test_known_wh(arg->whlist, name, namelen))
+			arg->err = -ENOTEMPTY;
+		goto out;
+	}
+
+	name += AUFS_WH_PFX_LEN;
+	namelen -= AUFS_WH_PFX_LEN;
+	if (!au_nhash_test_known_wh(arg->whlist, name, namelen))
+		arg->err = au_nhash_append_wh
+			(arg->whlist, name, namelen, arg->bindex);
+
+ out:
+	/* smp_mb(); */
+	AuTraceErr(arg->err);
+	return arg->err;
+}
+
+static int do_test_empty(struct dentry *dentry, struct test_empty_arg *arg)
+{
+	int err;
+	struct file *h_file;
+
+	h_file = au_h_open(dentry, arg->bindex,
+			   O_RDONLY | O_NONBLOCK | O_DIRECTORY | O_LARGEFILE,
+			   /*file*/NULL);
+	err = PTR_ERR(h_file);
+	if (IS_ERR(h_file))
+		goto out;
+
+	err = 0;
+	if (!au_opt_test(au_mntflags(dentry->d_sb), UDBA_NONE)
+	    && !h_file->f_dentry->d_inode->i_nlink)
+		goto out_put;
+
+	do {
+		arg->err = 0;
+		au_fclr_testempty(arg->flags, CALLED);
+		/* smp_mb(); */
+		err = vfsub_readdir(h_file, test_empty_cb, arg);
+		if (err >= 0)
+			err = arg->err;
+	} while (!err && au_ftest_testempty(arg->flags, CALLED));
+
+ out_put:
+	fput(h_file);
+	au_sbr_put(dentry->d_sb, arg->bindex);
+ out:
+	return err;
+}
+
+struct do_test_empty_args {
+	int *errp;
+	struct dentry *dentry;
+	struct test_empty_arg *arg;
+};
+
+static void call_do_test_empty(void *args)
+{
+	struct do_test_empty_args *a = args;
+	*a->errp = do_test_empty(a->dentry, a->arg);
+}
+
+static int sio_test_empty(struct dentry *dentry, struct test_empty_arg *arg)
+{
+	int err, wkq_err;
+	struct dentry *h_dentry;
+	struct inode *h_inode;
+
+	h_dentry = au_h_dptr(dentry, arg->bindex);
+	h_inode = h_dentry->d_inode;
+	mutex_lock_nested(&h_inode->i_mutex, AuLsc_I_CHILD);
+	err = au_test_h_perm_sio(h_inode, MAY_EXEC | MAY_READ);
+	mutex_unlock(&h_inode->i_mutex);
+	if (!err)
+		err = do_test_empty(dentry, arg);
+	else {
+		struct do_test_empty_args args = {
+			.errp	= &err,
+			.dentry	= dentry,
+			.arg	= arg
+		};
+		unsigned int flags = arg->flags;
+
+		wkq_err = au_wkq_wait(call_do_test_empty, &args);
+		if (unlikely(wkq_err))
+			err = wkq_err;
+		arg->flags = flags;
+	}
+
+	return err;
+}
+
+int au_test_empty_lower(struct dentry *dentry)
+{
+	int err;
+	aufs_bindex_t bindex, bstart, btail;
+	struct test_empty_arg arg;
+	struct au_nhash *whlist;
+
+	whlist = au_nhash_new(GFP_NOFS);
+	err = PTR_ERR(whlist);
+	if (IS_ERR(whlist))
+		goto out;
+
+	bstart = au_dbstart(dentry);
+	arg.whlist = whlist;
+	arg.flags = 0;
+	arg.bindex = bstart;
+	err = do_test_empty(dentry, &arg);
+	if (unlikely(err))
+		goto out_whlist;
+
+	au_fset_testempty(arg.flags, WHONLY);
+	btail = au_dbtaildir(dentry);
+	for (bindex = bstart + 1; !err && bindex <= btail; bindex++) {
+		struct dentry *h_dentry;
+
+		h_dentry = au_h_dptr(dentry, bindex);
+		if (h_dentry && h_dentry->d_inode) {
+			arg.bindex = bindex;
+			err = do_test_empty(dentry, &arg);
+		}
+	}
+
+ out_whlist:
+	au_nhash_del(whlist);
+ out:
+	return err;
+}
+
+int au_test_empty(struct dentry *dentry, struct au_nhash *whlist)
+{
+	int err;
+	struct test_empty_arg arg;
+	aufs_bindex_t bindex, btail;
+
+	err = 0;
+	arg.whlist = whlist;
+	arg.flags = AuTestEmpty_WHONLY;
+	btail = au_dbtaildir(dentry);
+	for (bindex = au_dbstart(dentry); !err && bindex <= btail; bindex++) {
+		struct dentry *h_dentry;
+
+		h_dentry = au_h_dptr(dentry, bindex);
+		if (h_dentry && h_dentry->d_inode) {
+			arg.bindex = bindex;
+			err = sio_test_empty(dentry, &arg);
+		}
+	}
+
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct file_operations aufs_dir_fop = {
+	.read		= generic_read_dir,
+	.readdir	= aufs_readdir,
+	.unlocked_ioctl	= aufs_ioctl_dir,
+	.open		= aufs_open_dir,
+	.release	= aufs_release_dir,
+	.flush		= aufs_flush,
+	.fsync		= aufs_fsync_dir
+};
diff --git a/fs/aufs/dir.h b/fs/aufs/dir.h
new file mode 100644
index 0000000..1e20ca3
--- /dev/null
+++ b/fs/aufs/dir.h
@@ -0,0 +1,104 @@
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
+ * directory operations
+ */
+
+#ifndef __AUFS_DIR_H__
+#define __AUFS_DIR_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/aufs_type.h>
+
+/* ---------------------------------------------------------------------- */
+
+/* need to be faster and smaller */
+
+#define AuSize_DEBLK	512
+#define AuSize_NHASH	32
+
+typedef char au_vdir_deblk_t[AuSize_DEBLK];
+
+struct au_nhash {
+	struct hlist_head heads[AuSize_NHASH];
+};
+
+struct au_vdir_destr {
+	unsigned char	len;
+	char		name[0];
+} __packed;
+
+struct au_vdir_dehstr {
+	struct hlist_node	hash;
+	struct au_vdir_destr	*str;
+};
+
+struct au_vdir_de {
+	ino_t			de_ino;
+	unsigned char		de_type;
+	/* caution: packed */
+	struct au_vdir_destr	de_str;
+} __packed;
+
+struct au_vdir_wh {
+	struct hlist_node	wh_hash;
+	aufs_bindex_t		wh_bindex;
+	struct au_vdir_destr	wh_str;
+} __packed;
+
+union au_vdir_deblk_p {
+	unsigned char		*p;
+	au_vdir_deblk_t		*deblk;
+	struct au_vdir_de	*de;
+};
+
+struct au_vdir {
+	au_vdir_deblk_t	**vd_deblk;
+	int		vd_nblk;
+	struct {
+		int			i;
+		union au_vdir_deblk_p	p;
+	} vd_last;
+
+	unsigned long	vd_version;
+	unsigned long	vd_jiffy;
+};
+
+/* ---------------------------------------------------------------------- */
+
+/* dir.c */
+extern struct file_operations aufs_dir_fop;
+void au_add_nlink(struct inode *dir, struct inode *h_dir);
+void au_sub_nlink(struct inode *dir, struct inode *h_dir);
+int au_test_empty_lower(struct dentry *dentry);
+int au_test_empty(struct dentry *dentry, struct au_nhash *whlist);
+
+/* vdir.c */
+struct au_nhash *au_nhash_new(gfp_t gfp);
+void au_nhash_del(struct au_nhash *nhash);
+void au_nhash_init(struct au_nhash *nhash);
+void au_nhash_move(struct au_nhash *dst, struct au_nhash *src);
+void au_nhash_fin(struct au_nhash *nhash);
+int au_nhash_test_longer_wh(struct au_nhash *whlist, aufs_bindex_t btgt,
+			    int limit);
+int au_nhash_test_known_wh(struct au_nhash *whlist, char *name, int namelen);
+int au_nhash_append_wh(struct au_nhash *whlist, char *name, int namelen,
+		       aufs_bindex_t bindex);
+void au_vdir_free(struct au_vdir *vdir);
+int au_vdir_init(struct file *file);
+int au_vdir_fill_de(struct file *file, void *dirent, filldir_t filldir);
+
+/* ioctl.c */
+long aufs_ioctl_dir(struct file *file, unsigned int cmd, unsigned long arg);
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_DIR_H__ */
diff --git a/fs/aufs/vdir.c b/fs/aufs/vdir.c
new file mode 100644
index 0000000..b0580c2
--- /dev/null
+++ b/fs/aufs/vdir.c
@@ -0,0 +1,776 @@
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
+ * virtual or vertical directory
+ */
+
+#include "aufs.h"
+
+static int calc_size(int namelen)
+{
+	int sz;
+	const int mask = sizeof(ino_t) - 1;
+
+	BUILD_BUG_ON(sizeof(ino_t) != sizeof(long));
+
+	sz = sizeof(struct au_vdir_de) + namelen;
+	if (sz & mask) {
+		sz += sizeof(ino_t);
+		sz &= ~mask;
+	}
+
+	AuDebugOn(sz % sizeof(ino_t));
+	return sz;
+}
+
+static int set_deblk_end(union au_vdir_deblk_p *p,
+			 union au_vdir_deblk_p *deblk_end)
+{
+	if (calc_size(0) <= deblk_end->p - p->p) {
+		p->de->de_str.len = 0;
+		/* smp_mb(); */
+		return 0;
+	}
+	return -1; /* error */
+}
+
+/* returns true or false */
+static int is_deblk_end(union au_vdir_deblk_p *p,
+			union au_vdir_deblk_p *deblk_end)
+{
+	if (calc_size(0) <= deblk_end->p - p->p)
+		return !p->de->de_str.len;
+	return 1;
+}
+
+static au_vdir_deblk_t *last_deblk(struct au_vdir *vdir)
+{
+	return vdir->vd_deblk[vdir->vd_nblk - 1];
+}
+
+void au_nhash_init(struct au_nhash *nhash)
+{
+	int i;
+	struct hlist_head *heads;
+
+	heads = nhash->heads;
+	for (i = 0; i < AuSize_NHASH; i++)
+		INIT_HLIST_HEAD(heads++);
+}
+
+struct au_nhash *au_nhash_new(gfp_t gfp)
+{
+	struct au_nhash *nhash;
+
+	nhash = kmalloc(sizeof(*nhash), gfp);
+	if (nhash) {
+		au_nhash_init(nhash);
+		return nhash;
+	}
+	return ERR_PTR(-ENOMEM);
+}
+
+void au_nhash_del(struct au_nhash *nhash)
+{
+	au_nhash_fin(nhash);
+	kfree(nhash);
+}
+
+void au_nhash_move(struct au_nhash *dst, struct au_nhash *src)
+{
+	int i;
+	struct hlist_head *dsth, *srch;
+
+	*dst = *src;
+	srch = src->heads;
+	dsth = dst->heads;
+	for (i = 0; i < AuSize_NHASH; i++) {
+		if (dsth->first)
+			dsth->first->pprev = &dsth->first;
+		dsth++;
+		INIT_HLIST_HEAD(srch++);
+	}
+	/* smp_mb(); */
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_nhash_fin(struct au_nhash *whlist)
+{
+	int i;
+	struct hlist_head *head;
+	struct au_vdir_wh *tpos;
+	struct hlist_node *pos, *n;
+
+	head = whlist->heads;
+	for (i = 0; i < AuSize_NHASH; i++) {
+		hlist_for_each_entry_safe(tpos, pos, n, head, wh_hash) {
+			/* hlist_del(pos); */
+			kfree(tpos);
+		}
+		head++;
+	}
+}
+
+int au_nhash_test_longer_wh(struct au_nhash *whlist, aufs_bindex_t btgt,
+			    int limit)
+{
+	int n, i;
+	struct hlist_head *head;
+	struct au_vdir_wh *tpos;
+	struct hlist_node *pos;
+
+	n = 0;
+	head = whlist->heads;
+	for (i = 0; i < AuSize_NHASH; i++) {
+		hlist_for_each_entry(tpos, pos, head, wh_hash)
+			if (tpos->wh_bindex == btgt && ++n > limit)
+				return 1;
+		head++;
+	}
+	return 0;
+}
+
+static unsigned int au_name_hash(const unsigned char *name, unsigned int len)
+{
+	return full_name_hash(name, len) % AuSize_NHASH;
+}
+
+/* returns found or not */
+int au_nhash_test_known_wh(struct au_nhash *whlist, char *name, int namelen)
+{
+	struct hlist_head *head;
+	struct au_vdir_wh *tpos;
+	struct hlist_node *pos;
+	struct au_vdir_destr *str;
+
+	head = whlist->heads + au_name_hash(name, namelen);
+	hlist_for_each_entry(tpos, pos, head, wh_hash) {
+		str = &tpos->wh_str;
+		AuDbg("%.*s\n", str->len, str->name);
+		if (str->len == namelen && !memcmp(str->name, name, namelen))
+			return 1;
+	}
+	return 0;
+}
+
+int au_nhash_append_wh(struct au_nhash *whlist, char *name, int namelen,
+		       aufs_bindex_t bindex)
+{
+	int err;
+	struct au_vdir_destr *str;
+	struct au_vdir_wh *wh;
+
+	err = -ENOMEM;
+	wh = kmalloc(sizeof(*wh) + namelen, GFP_NOFS);
+	if (unlikely(!wh))
+		goto out;
+
+	err = 0;
+	wh->wh_bindex = bindex;
+	str = &wh->wh_str;
+	str->len = namelen;
+	memcpy(str->name, name, namelen);
+	hlist_add_head(&wh->wh_hash,
+		       whlist->heads + au_name_hash(name, namelen));
+	/* smp_mb(); */
+
+ out:
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_vdir_free(struct au_vdir *vdir)
+{
+	au_vdir_deblk_t **deblk;
+
+	deblk = vdir->vd_deblk;
+	while (vdir->vd_nblk--)
+		kfree(*deblk++);
+	kfree(vdir->vd_deblk);
+	au_cache_free_vdir(vdir);
+}
+
+static int append_deblk(struct au_vdir *vdir)
+{
+	int err, sz, i;
+	au_vdir_deblk_t **o;
+	union au_vdir_deblk_p p, deblk_end;
+
+	err = -ENOMEM;
+	sz = sizeof(*o) * vdir->vd_nblk;
+	o = au_kzrealloc(vdir->vd_deblk, sz, sz + sizeof(*o), GFP_NOFS);
+	if (unlikely(!o))
+		goto out;
+
+	vdir->vd_deblk = o;
+	p.deblk = kmalloc(sizeof(*p.deblk), GFP_NOFS);
+	if (p.deblk) {
+		i = vdir->vd_nblk++;
+		vdir->vd_deblk[i] = p.deblk;
+		vdir->vd_last.i = i;
+		vdir->vd_last.p.p = p.p;
+		deblk_end.deblk = p.deblk + 1;
+		err = set_deblk_end(&p, &deblk_end);
+	}
+
+ out:
+	return err;
+}
+
+static struct au_vdir *alloc_vdir(void)
+{
+	struct au_vdir *vdir;
+	int err;
+
+	err = -ENOMEM;
+	vdir = au_cache_alloc_vdir();
+	if (unlikely(!vdir))
+		goto out;
+
+	vdir->vd_deblk = kzalloc(sizeof(*vdir->vd_deblk), GFP_NOFS);
+	if (unlikely(!vdir->vd_deblk))
+		goto out_free;
+
+	vdir->vd_nblk = 0;
+	vdir->vd_version = 0;
+	vdir->vd_jiffy = 0;
+	err = append_deblk(vdir);
+	if (!err)
+		return vdir; /* success */
+
+	kfree(vdir->vd_deblk);
+
+ out_free:
+	au_cache_free_vdir(vdir);
+ out:
+	vdir = ERR_PTR(err);
+	return vdir;
+}
+
+static int reinit_vdir(struct au_vdir *vdir)
+{
+	int err;
+	union au_vdir_deblk_p p, deblk_end;
+
+	while (vdir->vd_nblk > 1) {
+		kfree(vdir->vd_deblk[vdir->vd_nblk - 1]);
+		vdir->vd_deblk[vdir->vd_nblk - 1] = NULL;
+		vdir->vd_nblk--;
+	}
+	p.deblk = vdir->vd_deblk[0];
+	deblk_end.deblk = p.deblk + 1;
+	err = set_deblk_end(&p, &deblk_end);
+	vdir->vd_version = 0;
+	vdir->vd_jiffy = 0;
+	vdir->vd_last.i = 0;
+	vdir->vd_last.p.deblk = vdir->vd_deblk[0];
+	/* smp_mb(); */
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static void free_dehlist(struct au_nhash *dehlist)
+{
+	int i;
+	struct hlist_head *head;
+	struct au_vdir_dehstr *tpos;
+	struct hlist_node *pos, *n;
+
+	head = dehlist->heads;
+	for (i = 0; i < AuSize_NHASH; i++) {
+		hlist_for_each_entry_safe(tpos, pos, n, head, hash) {
+			/* hlist_del(pos); */
+			au_cache_free_dehstr(tpos);
+		}
+		head++;
+	}
+}
+
+/* returns found(true) or not */
+static int test_known(struct au_nhash *delist, char *name, int namelen)
+{
+	struct hlist_head *head;
+	struct au_vdir_dehstr *tpos;
+	struct hlist_node *pos;
+	struct au_vdir_destr *str;
+
+	head = delist->heads + au_name_hash(name, namelen);
+	hlist_for_each_entry(tpos, pos, head, hash) {
+		str = tpos->str;
+		AuDbg("%.*s\n", str->len, str->name);
+		if (str->len == namelen && !memcmp(str->name, name, namelen))
+			return 1;
+	}
+	return 0;
+
+}
+
+static int append_de(struct au_vdir *vdir, char *name, int namelen, ino_t ino,
+		     unsigned int d_type, struct au_nhash *delist)
+{
+	int err, sz;
+	union au_vdir_deblk_p p, *room, deblk_end;
+	struct au_vdir_dehstr *dehstr;
+
+	p.deblk = last_deblk(vdir);
+	deblk_end.deblk = p.deblk + 1;
+	room = &vdir->vd_last.p;
+	AuDebugOn(room->p < p.p || deblk_end.p <= room->p
+		  || !is_deblk_end(room, &deblk_end));
+
+	sz = calc_size(namelen);
+	if (unlikely(sz > deblk_end.p - room->p)) {
+		err = append_deblk(vdir);
+		if (unlikely(err))
+			goto out;
+
+		p.deblk = last_deblk(vdir);
+		deblk_end.deblk = p.deblk + 1;
+		/* smp_mb(); */
+		AuDebugOn(room->p != p.p);
+	}
+
+	err = -ENOMEM;
+	dehstr = au_cache_alloc_dehstr();
+	if (unlikely(!dehstr))
+		goto out;
+
+	dehstr->str = &room->de->de_str;
+	hlist_add_head(&dehstr->hash,
+		       delist->heads + au_name_hash(name, namelen));
+	room->de->de_ino = ino;
+	room->de->de_type = d_type;
+	room->de->de_str.len = namelen;
+	memcpy(room->de->de_str.name, name, namelen);
+
+	err = 0;
+	room->p += sz;
+	if (unlikely(set_deblk_end(room, &deblk_end)))
+		err = append_deblk(vdir);
+	/* smp_mb(); */
+
+ out:
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int au_ino(struct super_block *sb, aufs_bindex_t bindex, ino_t h_ino,
+		  unsigned int d_type, ino_t *ino)
+{
+	int err;
+	struct mutex *mtx;
+	const int isdir = (d_type == DT_DIR);
+
+	/* prevent hardlinks from race condition */
+	mtx = NULL;
+	if (!isdir) {
+		mtx = &au_sbr(sb, bindex)->br_xino.xi_nondir_mtx;
+		mutex_lock(mtx);
+	}
+	err = au_xino_read(sb, bindex, h_ino, ino);
+	if (unlikely(err))
+		goto out;
+
+	if (!*ino) {
+		err = -EIO;
+		*ino = au_xino_new_ino(sb);
+		if (unlikely(!*ino))
+			goto out;
+		err = au_xino_write(sb, bindex, h_ino, *ino);
+		if (unlikely(err))
+			goto out;
+	}
+
+ out:
+	if (!isdir)
+		mutex_unlock(mtx);
+	return err;
+}
+
+#define AuFillVdir_CALLED	1
+#define au_ftest_fillvdir(flags, name)	((flags) & AuFillVdir_##name)
+#define au_fset_fillvdir(flags, name)	{ (flags) |= AuFillVdir_##name; }
+#define au_fclr_fillvdir(flags, name)	{ (flags) &= ~AuFillVdir_##name; }
+
+struct fillvdir_arg {
+	struct file		*file;
+	struct au_vdir		*vdir;
+	struct au_nhash		*delist;
+	struct au_nhash		*whlist;
+	aufs_bindex_t		bindex;
+	unsigned int		flags;
+	int			err;
+};
+
+static int fillvdir(void *__arg, const char *__name, int namelen,
+		    loff_t offset __maybe_unused, u64 h_ino,
+		    unsigned int d_type)
+{
+	struct fillvdir_arg *arg = __arg;
+	char *name = (void *)__name;
+	struct super_block *sb;
+	struct au_nhash *delist, *whlist;
+	ino_t ino;
+	aufs_bindex_t bindex, bend;
+
+	bend = arg->bindex;
+	arg->err = 0;
+	au_fset_fillvdir(arg->flags, CALLED);
+	/* smp_mb(); */
+	if (namelen <= AUFS_WH_PFX_LEN
+	    || memcmp(name, AUFS_WH_PFX, AUFS_WH_PFX_LEN)) {
+		delist = arg->delist;
+		for (bindex = 0; bindex < bend; bindex++)
+			if (test_known(delist++, name, namelen)
+			    || au_nhash_test_known_wh(arg->whlist + bindex,
+						      name, namelen))
+				goto out; /* already exists or whiteouted */
+
+		ino = 1; /* why does gcc warn? */
+		sb = arg->file->f_dentry->d_sb;
+		arg->err = au_ino(sb, bend, h_ino, d_type, &ino);
+		if (!arg->err)
+			arg->err = append_de(arg->vdir, name, namelen, ino,
+					     d_type, arg->delist + bend);
+	} else {
+		name += AUFS_WH_PFX_LEN;
+		namelen -= AUFS_WH_PFX_LEN;
+		whlist = arg->whlist;
+		for (bindex = 0; bindex < bend; bindex++)
+			if (au_nhash_test_known_wh(whlist++, name, namelen))
+				goto out; /* already whiteouted */
+
+		ino = 1; /* dummy */
+		if (!arg->err)
+			arg->err = au_nhash_append_wh
+				(arg->whlist + bend, name, namelen, bend);
+	}
+
+ out:
+	if (!arg->err)
+		arg->vdir->vd_jiffy = jiffies;
+	/* smp_mb(); */
+	AuTraceErr(arg->err);
+	return arg->err;
+}
+
+static int au_do_read_vdir(struct fillvdir_arg *arg)
+{
+	int err;
+	loff_t offset;
+	aufs_bindex_t bend, bindex, bstart;
+	struct file *hf, *file;
+	struct au_nhash *delist, *whlist;
+
+	err = -ENOMEM;
+	bend = au_fbend(arg->file);
+	arg->delist = kmalloc(sizeof(*arg->delist) * (bend + 1), GFP_NOFS);
+	if (unlikely(!arg->delist))
+		goto out;
+	arg->whlist = kmalloc(sizeof(*arg->whlist) * (bend + 1), GFP_NOFS);
+	if (unlikely(!arg->whlist))
+		goto out_delist;
+
+	err = 0;
+	delist = arg->delist;
+	whlist = arg->whlist;
+	for (bindex = 0; bindex <= bend; bindex++) {
+		au_nhash_init(delist++);
+		au_nhash_init(whlist++);
+	}
+
+	arg->flags = 0;
+	file = arg->file;
+	bstart = au_fbstart(file);
+	for (bindex = bstart; !err && bindex <= bend; bindex++) {
+		hf = au_h_fptr(file, bindex);
+		if (!hf)
+			continue;
+
+		offset = vfsub_llseek(hf, 0, SEEK_SET);
+		err = offset;
+		if (unlikely(offset))
+			break;
+
+		arg->bindex = bindex;
+		do {
+			arg->err = 0;
+			au_fclr_fillvdir(arg->flags, CALLED);
+			/* smp_mb(); */
+			err = vfsub_readdir(hf, fillvdir, arg);
+			if (err >= 0)
+				err = arg->err;
+		} while (!err && au_ftest_fillvdir(arg->flags, CALLED));
+	}
+
+	delist = arg->delist + bstart;
+	whlist = arg->whlist + bstart;
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		free_dehlist(delist++);
+		au_nhash_fin(whlist++);
+	}
+	kfree(arg->whlist);
+
+ out_delist:
+	kfree(arg->delist);
+ out:
+	return err;
+}
+
+static int read_vdir(struct file *file, int may_read)
+{
+	int err;
+	unsigned long expire;
+	unsigned char do_read;
+	struct fillvdir_arg arg;
+	struct inode *inode;
+	struct au_vdir *vdir, *allocated;
+
+	err = 0;
+	inode = file->f_dentry->d_inode;
+	IMustLock(inode);
+	allocated = NULL;
+	do_read = 0;
+	expire = au_sbi(inode->i_sb)->si_rdcache;
+	vdir = au_ivdir(inode);
+	if (!vdir) {
+		do_read = 1;
+		vdir = alloc_vdir();
+		err = PTR_ERR(vdir);
+		if (IS_ERR(vdir))
+			goto out;
+		err = 0;
+		allocated = vdir;
+	} else if (may_read
+		   && (inode->i_version != vdir->vd_version
+		       || time_after(jiffies, vdir->vd_jiffy + expire))) {
+		do_read = 1;
+		err = reinit_vdir(vdir);
+		if (unlikely(err))
+			goto out;
+	}
+
+	if (!do_read)
+		return 0; /* success */
+
+	arg.file = file;
+	arg.vdir = vdir;
+	err = au_do_read_vdir(&arg);
+	if (!err) {
+		/* file->f_pos = 0; */
+		vdir->vd_version = inode->i_version;
+		vdir->vd_last.i = 0;
+		vdir->vd_last.p.deblk = vdir->vd_deblk[0];
+		if (allocated)
+			au_set_ivdir(inode, allocated);
+	} else if (allocated)
+		au_vdir_free(allocated);
+
+ out:
+	return err;
+}
+
+static int copy_vdir(struct au_vdir *tgt, struct au_vdir *src)
+{
+	int err, i, rerr, n;
+
+	AuDebugOn(tgt->vd_nblk != 1);
+
+	err = -ENOMEM;
+	if (tgt->vd_nblk < src->vd_nblk) {
+		au_vdir_deblk_t **p;
+
+		p = au_kzrealloc(tgt->vd_deblk, sizeof(*p) * tgt->vd_nblk,
+				 sizeof(*p) * src->vd_nblk, GFP_NOFS);
+		if (unlikely(!p))
+			goto out;
+		tgt->vd_deblk = p;
+	}
+
+	tgt->vd_nblk = src->vd_nblk;
+	n = src->vd_nblk;
+	memcpy(tgt->vd_deblk[0], src->vd_deblk[0], AuSize_DEBLK);
+	/* tgt->vd_last.i = 0; */
+	/* tgt->vd_last.p.deblk = tgt->vd_deblk[0]; */
+	tgt->vd_version = src->vd_version;
+	tgt->vd_jiffy = src->vd_jiffy;
+
+	for (i = 1; i < n; i++) {
+		tgt->vd_deblk[i] = kmalloc(AuSize_DEBLK, GFP_NOFS);
+		if (tgt->vd_deblk[i])
+			memcpy(tgt->vd_deblk[i], src->vd_deblk[i],
+			       AuSize_DEBLK);
+		else
+			goto out;
+	}
+	/* smp_mb(); */
+	return 0; /* success */
+
+ out:
+	rerr = reinit_vdir(tgt);
+	BUG_ON(rerr);
+	return err;
+}
+
+int au_vdir_init(struct file *file)
+{
+	int err;
+	struct inode *inode;
+	struct au_vdir *vdir_cache, *allocated;
+
+	err = read_vdir(file, !file->f_pos);
+	if (unlikely(err))
+		goto out;
+
+	allocated = NULL;
+	vdir_cache = au_fvdir_cache(file);
+	if (!vdir_cache) {
+		vdir_cache = alloc_vdir();
+		err = PTR_ERR(vdir_cache);
+		if (IS_ERR(vdir_cache))
+			goto out;
+		allocated = vdir_cache;
+	} else if (!file->f_pos && vdir_cache->vd_version != file->f_version) {
+		err = reinit_vdir(vdir_cache);
+		if (unlikely(err))
+			goto out;
+	} else
+		return 0; /* success */
+
+	inode = file->f_dentry->d_inode;
+	err = copy_vdir(vdir_cache, au_ivdir(inode));
+	if (!err) {
+		file->f_version = inode->i_version;
+		if (allocated)
+			au_set_fvdir_cache(file, allocated);
+	} else if (allocated)
+		au_vdir_free(allocated);
+
+ out:
+	return err;
+}
+
+static loff_t calc_offset(struct au_vdir *vdir)
+{
+	loff_t offset;
+	union au_vdir_deblk_p p;
+
+	p.deblk = vdir->vd_deblk[vdir->vd_last.i];
+	offset = vdir->vd_last.p.p - p.p;
+	offset += sizeof(*p.deblk) * vdir->vd_last.i;
+	return offset;
+}
+
+/* returns true or false */
+static int seek_vdir(struct file *file)
+{
+	int valid, i, n;
+	loff_t offset;
+	union au_vdir_deblk_p p, deblk_end;
+	struct au_vdir *vdir_cache;
+
+	valid = 1;
+	vdir_cache = au_fvdir_cache(file);
+	offset = calc_offset(vdir_cache);
+	AuDbg("offset %lld\n", offset);
+	if (file->f_pos == offset)
+		goto out;
+
+	vdir_cache->vd_last.i = 0;
+	vdir_cache->vd_last.p.deblk = vdir_cache->vd_deblk[0];
+	if (!file->f_pos)
+		goto out;
+
+	valid = 0;
+	i = file->f_pos / AuSize_DEBLK;
+	AuDbg("i %d\n", i);
+	if (i >= vdir_cache->vd_nblk)
+		goto out;
+
+	n = vdir_cache->vd_nblk;
+	for (; i < n; i++) {
+		p.deblk = vdir_cache->vd_deblk[i];
+		deblk_end.deblk = p.deblk + 1;
+		offset = i;
+		offset *= AuSize_DEBLK;
+		while (!is_deblk_end(&p, &deblk_end) && offset < file->f_pos) {
+			int l;
+
+			l = calc_size(p.de->de_str.len);
+			offset += l;
+			p.p += l;
+		}
+		if (!is_deblk_end(&p, &deblk_end)) {
+			valid = 1;
+			vdir_cache->vd_last.i = i;
+			vdir_cache->vd_last.p = p;
+			break;
+		}
+	}
+
+ out:
+	/* smp_mb(); */
+	AuTraceErr(!valid);
+	return valid;
+}
+
+int au_vdir_fill_de(struct file *file, void *dirent, filldir_t filldir)
+{
+	int err, l;
+	union au_vdir_deblk_p deblk_end;
+	struct au_vdir *vdir_cache;
+	struct au_vdir_de *de;
+
+	BUILD_BUG_ON(AuSize_DEBLK < NAME_MAX || PAGE_SIZE < AuSize_DEBLK);
+
+	vdir_cache = au_fvdir_cache(file);
+	if (!seek_vdir(file))
+		return 0;
+
+	while (1) {
+		deblk_end.deblk
+			= vdir_cache->vd_deblk[vdir_cache->vd_last.i] + 1;
+		while (!is_deblk_end(&vdir_cache->vd_last.p, &deblk_end)) {
+			de = vdir_cache->vd_last.p.de;
+			AuDbg("%.*s, off%lld, i%lu, dt%d\n",
+			      de->de_str.len, de->de_str.name,
+			      file->f_pos, (unsigned long)de->de_ino,
+			      de->de_type);
+			err = filldir(dirent, de->de_str.name, de->de_str.len,
+				      file->f_pos, de->de_ino, de->de_type);
+			if (unlikely(err)) {
+				AuTraceErr(err);
+				/* todo: ignore the error caused by udba? */
+				/* return err; */
+				return 0;
+			}
+
+			l = calc_size(de->de_str.len);
+			vdir_cache->vd_last.p.p += l;
+			file->f_pos += l;
+		}
+		if (vdir_cache->vd_last.i < vdir_cache->vd_nblk - 1) {
+			vdir_cache->vd_last.i++;
+			vdir_cache->vd_last.p.deblk
+				= vdir_cache->vd_deblk[vdir_cache->vd_last.i];
+			file->f_pos = sizeof(*vdir_cache->vd_last.p.deblk)
+				* vdir_cache->vd_last.i;
+			continue;
+		}
+		break;
+	}
+
+	/* smp_mb(); */
+	return 0;
+}
-- 
1.6.1.284.g5dc13

