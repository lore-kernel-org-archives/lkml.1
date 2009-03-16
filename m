Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbZCPH1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbZCPH1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbZCPHXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:23:36 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:35669 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbZCPHW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:22:59 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #2 04/28] aufs super_block
Date: Mon, 16 Mar 2009 16:20:16 +0900
Message-Id: <1237188040-11404-5-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
super_block operations and private data

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/sbinfo.c |  192 ++++++++++++
 fs/aufs/super.c  |  846 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/super.h  |  266 +++++++++++++++++
 3 files changed, 1304 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/sbinfo.c
 create mode 100644 fs/aufs/super.c
 create mode 100644 fs/aufs/super.h

diff --git a/fs/aufs/sbinfo.c b/fs/aufs/sbinfo.c
new file mode 100644
index 0000000..12d07f5
--- /dev/null
+++ b/fs/aufs/sbinfo.c
@@ -0,0 +1,192 @@
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
+ * superblock private data
+ */
+
+#include "aufs.h"
+
+/*
+ * they are necessary regardless sysfs is disabled.
+ */
+void au_si_free(struct kobject *kobj)
+{
+	struct au_sbinfo *sbinfo;
+	struct super_block *sb;
+
+	sbinfo = container_of(kobj, struct au_sbinfo, si_kobj);
+	AuDebugOn(!list_empty(&sbinfo->si_plink.head));
+
+	sb = sbinfo->si_sb;
+	si_write_lock(sb);
+	au_xino_clr(sb);
+	au_br_free(sbinfo);
+	kfree(sbinfo->si_branch);
+	mutex_destroy(&sbinfo->si_xib_mtx);
+	si_write_unlock(sb);
+	au_rwsem_destroy(&sbinfo->si_rwsem);
+
+	kfree(sbinfo);
+}
+
+int au_si_alloc(struct super_block *sb)
+{
+	int err;
+	struct au_sbinfo *sbinfo;
+
+	err = -ENOMEM;
+	sbinfo = kmalloc(sizeof(*sbinfo), GFP_NOFS);
+	if (unlikely(!sbinfo))
+		goto out;
+
+	/* will be reallocated separately */
+	sbinfo->si_branch = kzalloc(sizeof(*sbinfo->si_branch), GFP_NOFS);
+	if (unlikely(!sbinfo->si_branch))
+		goto out_sbinfo;
+
+	memset(&sbinfo->si_kobj, 0, sizeof(sbinfo->si_kobj));
+	err = sysaufs_si_init(sbinfo);
+	if (unlikely(err))
+		goto out_br;
+
+	au_nwt_init(&sbinfo->si_nowait);
+	init_rwsem(&sbinfo->si_rwsem);
+	down_write(&sbinfo->si_rwsem);
+	sbinfo->si_generation = 0;
+	sbinfo->au_si_status = 0;
+	sbinfo->si_bend = -1;
+	sbinfo->si_last_br_id = 0;
+
+	sbinfo->si_wbr_copyup = AuWbrCopyup_Def;
+	sbinfo->si_wbr_create = AuWbrCreate_Def;
+	sbinfo->si_wbr_copyup_ops = au_wbr_copyup_ops + AuWbrCopyup_Def;
+	sbinfo->si_wbr_create_ops = au_wbr_create_ops + AuWbrCreate_Def;
+
+	sbinfo->si_mntflags = AuOpt_Def;
+
+	sbinfo->si_xread = NULL;
+	sbinfo->si_xwrite = NULL;
+	sbinfo->si_xib = NULL;
+	mutex_init(&sbinfo->si_xib_mtx);
+	sbinfo->si_xib_buf = NULL;
+	sbinfo->si_xino_brid = -1;
+	/* leave si_xib_last_pindex and si_xib_next_bit */
+
+	sbinfo->si_rdcache = AUFS_RDCACHE_DEF * HZ;
+	sbinfo->si_dirwh = AUFS_DIRWH_DEF;
+
+	au_spl_init(&sbinfo->si_plink);
+	init_waitqueue_head(&sbinfo->si_plink_wq);
+
+	/* leave other members for sysaufs and si_mnt. */
+	sbinfo->si_sb = sb;
+	sb->s_fs_info = sbinfo;
+	au_debug_sbinfo_init(sbinfo);
+	return 0; /* success */
+
+ out_br:
+	kfree(sbinfo->si_branch);
+ out_sbinfo:
+	kfree(sbinfo);
+ out:
+	return err;
+}
+
+int au_sbr_realloc(struct au_sbinfo *sbinfo, int nbr)
+{
+	int err, sz;
+	struct au_branch **brp;
+
+	err = -ENOMEM;
+	sz = sizeof(*brp) * (sbinfo->si_bend + 1);
+	if (unlikely(!sz))
+		sz = sizeof(*brp);
+	brp = au_kzrealloc(sbinfo->si_branch, sz, sizeof(*brp) * nbr, GFP_NOFS);
+	if (brp) {
+		sbinfo->si_branch = brp;
+		err = 0;
+	}
+
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+unsigned int au_sigen_inc(struct super_block *sb)
+{
+	unsigned int gen;
+
+	gen = ++au_sbi(sb)->si_generation;
+	au_update_digen(sb->s_root);
+	au_update_iigen(sb->s_root->d_inode);
+	sb->s_root->d_inode->i_version++;
+	return gen;
+}
+
+aufs_bindex_t au_new_br_id(struct super_block *sb)
+{
+	aufs_bindex_t br_id;
+	int i;
+	struct au_sbinfo *sbinfo;
+
+	sbinfo = au_sbi(sb);
+	for (i = 0; i <= AUFS_BRANCH_MAX; i++) {
+		br_id = ++sbinfo->si_last_br_id;
+		if (br_id && au_br_index(sb, br_id) < 0)
+			return br_id;
+	}
+
+	return -1;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* dentry and super_block lock. call at entry point */
+void aufs_read_lock(struct dentry *dentry, int flags)
+{
+	si_read_lock(dentry->d_sb, flags);
+	if (au_ftest_lock(flags, DW))
+		di_write_lock_child(dentry);
+	else
+		di_read_lock_child(dentry, flags);
+}
+
+void aufs_read_unlock(struct dentry *dentry, int flags)
+{
+	if (au_ftest_lock(flags, DW))
+		di_write_unlock(dentry);
+	else
+		di_read_unlock(dentry, flags);
+	si_read_unlock(dentry->d_sb);
+}
+
+void aufs_write_lock(struct dentry *dentry)
+{
+	si_write_lock(dentry->d_sb);
+	di_write_lock_child(dentry);
+}
+
+void aufs_write_unlock(struct dentry *dentry)
+{
+	di_write_unlock(dentry);
+	si_write_unlock(dentry->d_sb);
+}
+
+void aufs_read_and_write_lock2(struct dentry *d1, struct dentry *d2, int flags)
+{
+	si_read_lock(d1->d_sb, flags);
+	di_write_lock2_child(d1, d2, au_ftest_lock(flags, DIR));
+}
+
+void aufs_read_and_write_unlock2(struct dentry *d1, struct dentry *d2)
+{
+	di_write_unlock2(d1, d2);
+	si_read_unlock(d1->d_sb);
+}
diff --git a/fs/aufs/super.c b/fs/aufs/super.c
new file mode 100644
index 0000000..700f8c8
--- /dev/null
+++ b/fs/aufs/super.c
@@ -0,0 +1,846 @@
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
+ * mount and super_block operations
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/seq_file.h>
+#include <linux/statfs.h>
+#include "aufs.h"
+
+/*
+ * super_operations
+ */
+static struct inode *aufs_alloc_inode(struct super_block *sb __maybe_unused)
+{
+	struct au_icntnr *c;
+
+	c = au_cache_alloc_icntnr();
+	if (c) {
+		inode_init_once(&c->vfs_inode);
+		c->vfs_inode.i_version = 1; /* sigen(sb); */
+		c->iinfo.ii_hinode = NULL;
+		return &c->vfs_inode;
+	}
+	return NULL;
+}
+
+static void aufs_destroy_inode(struct inode *inode)
+{
+	au_iinfo_fin(inode);
+	au_cache_free_icntnr(container_of(inode, struct au_icntnr, vfs_inode));
+}
+
+struct inode *au_iget_locked(struct super_block *sb, ino_t ino)
+{
+	struct inode *inode;
+	int err;
+
+	inode = iget_locked(sb, ino);
+	if (unlikely(!inode)) {
+		inode = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+	if (!(inode->i_state & I_NEW))
+		goto out;
+
+	err = au_iinfo_init(inode);
+	if (!err)
+		inode->i_version++;
+	else {
+		iget_failed(inode);
+		inode = ERR_PTR(err);
+	}
+
+ out:
+	/* never return NULL */
+	AuDebugOn(!inode);
+	AuTraceErrPtr(inode);
+	return inode;
+}
+
+/* lock free root dinfo */
+static int au_show_brs(struct seq_file *seq, struct super_block *sb)
+{
+	int err;
+	aufs_bindex_t bindex, bend;
+	struct path path;
+	struct au_hdentry *hd;
+	struct au_branch *br;
+
+	err = 0;
+	bend = au_sbend(sb);
+	hd = au_di(sb->s_root)->di_hdentry;
+	for (bindex = 0; !err && bindex <= bend; bindex++) {
+		br = au_sbr(sb, bindex);
+		path.mnt = br->br_mnt;
+		path.dentry = hd[bindex].hd_dentry;
+		err = au_seq_path(seq, &path);
+		if (err > 0)
+			err = seq_printf(seq, "=%s",
+					 au_optstr_br_perm(br->br_perm));
+		if (!err && bindex != bend)
+			err = seq_putc(seq, ':');
+	}
+
+	return err;
+}
+
+static void au_show_wbr_create(struct seq_file *m, int v,
+			       struct au_sbinfo *sbinfo)
+{
+	const char *pat;
+
+	seq_printf(m, ",create=");
+	pat = au_optstr_wbr_create(v);
+	switch (v) {
+	case AuWbrCreate_TDP:
+	case AuWbrCreate_RR:
+	case AuWbrCreate_MFS:
+	case AuWbrCreate_PMFS:
+		seq_printf(m, pat);
+		break;
+	case AuWbrCreate_MFSV:
+		seq_printf(m, /*pat*/"mfs:%lu",
+			   sbinfo->si_wbr_mfs.mfs_expire / HZ);
+		break;
+	case AuWbrCreate_PMFSV:
+		seq_printf(m, /*pat*/"pmfs:%lu",
+			   sbinfo->si_wbr_mfs.mfs_expire / HZ);
+		break;
+	case AuWbrCreate_MFSRR:
+		seq_printf(m, /*pat*/"mfsrr:%llu",
+			   sbinfo->si_wbr_mfs.mfsrr_watermark);
+		break;
+	case AuWbrCreate_MFSRRV:
+		seq_printf(m, /*pat*/"mfsrr:%llu:%lu",
+			   sbinfo->si_wbr_mfs.mfsrr_watermark,
+			   sbinfo->si_wbr_mfs.mfs_expire / HZ);
+		break;
+	}
+}
+
+static int au_show_xino(struct seq_file *seq, struct vfsmount *mnt)
+{
+	int err;
+	const int len = sizeof(AUFS_XINO_FNAME) - 1;
+	aufs_bindex_t bindex, brid;
+	struct super_block *sb;
+	struct qstr *name;
+	struct file *f;
+	struct dentry *d, *h_root;
+
+	err = 0;
+	sb = mnt->mnt_sb;
+	f = au_sbi(sb)->si_xib;
+	if (!f)
+		goto out;
+
+	/* stop printing the default xino path on the first writable branch */
+	h_root = NULL;
+	brid = au_xino_brid(sb);
+	if (brid >= 0) {
+		bindex = au_br_index(sb, brid);
+		h_root = au_di(sb->s_root)->di_hdentry[0 + bindex].hd_dentry;
+	}
+	d = f->f_dentry;
+	name = &d->d_name;
+	/* safe ->d_parent because the file is unlinked */
+	if (d->d_parent == h_root
+	    && name->len == len
+	    && !memcmp(name->name, AUFS_XINO_FNAME, len))
+		goto out;
+
+	seq_puts(seq, ",xino=");
+	err = au_xino_path(seq, f);
+
+ out:
+	return err;
+}
+
+/* seq_file will re-call me in case of too long string */
+static int aufs_show_options(struct seq_file *m, struct vfsmount *mnt)
+{
+	int err, n;
+	unsigned int mnt_flags, v;
+	struct super_block *sb;
+	struct au_sbinfo *sbinfo;
+
+#define AuBool(name, str) do { \
+	v = au_opt_test(mnt_flags, name); \
+	if (v != au_opt_test(AuOpt_Def, name)) \
+		seq_printf(m, ",%s" #str, v ? "" : "no"); \
+} while (0)
+
+#define AuStr(name, str) do { \
+	v = mnt_flags & AuOptMask_##name; \
+	if (v != (AuOpt_Def & AuOptMask_##name)) \
+		seq_printf(m, "," #str "=%s", au_optstr_##str(v)); \
+} while (0)
+
+	/* lock free root dinfo */
+	sb = mnt->mnt_sb;
+	si_noflush_read_lock(sb);
+	sbinfo = au_sbi(sb);
+	seq_printf(m, ",si=%lx", sysaufs_si_id(sbinfo));
+
+	mnt_flags = au_mntflags(sb);
+	if (au_opt_test(mnt_flags, XINO)) {
+		err = au_show_xino(m, mnt);
+		if (unlikely(err))
+			goto out;
+	} else
+		seq_puts(m, ",noxino");
+
+	AuBool(TRUNC_XINO, trunc_xino);
+	AuStr(UDBA, udba);
+	AuBool(PLINK, plink);
+	/* AuBool(DIRPERM1, dirperm1); */
+	/* AuBool(REFROF, refrof); */
+
+	v = sbinfo->si_wbr_create;
+	if (v != AuWbrCreate_Def)
+		au_show_wbr_create(m, v, sbinfo);
+
+	v = sbinfo->si_wbr_copyup;
+	if (v != AuWbrCopyup_Def)
+		seq_printf(m, ",cpup=%s", au_optstr_wbr_copyup(v));
+
+	v = au_opt_test(mnt_flags, ALWAYS_DIROPQ);
+	if (v != au_opt_test(AuOpt_Def, ALWAYS_DIROPQ))
+		seq_printf(m, ",diropq=%c", v ? 'a' : 'w');
+
+	n = sbinfo->si_dirwh;
+	if (n != AUFS_DIRWH_DEF)
+		seq_printf(m, ",dirwh=%d", n);
+
+	n = sbinfo->si_rdcache / HZ;
+	if (n != AUFS_RDCACHE_DEF)
+		seq_printf(m, ",rdcache=%d", n);
+
+	AuBool(SUM, sum);
+	/* AuBool(SUM_W, wsum); */
+	AuBool(WARN_PERM, warn_perm);
+	AuBool(VERBOSE, verbose);
+
+ out:
+	/* be sure to print "br:" last */
+	if (!sysaufs_brs) {
+		seq_puts(m, ",br:");
+		au_show_brs(m, sb);
+	}
+	si_read_unlock(sb);
+	return 0;
+
+#undef Deleted
+#undef AuBool
+#undef AuStr
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* sum mode which returns the summation for statfs(2) */
+
+static u64 au_add_till_max(u64 a, u64 b)
+{
+	u64 old;
+
+	old = a;
+	a += b;
+	if (old < a)
+		return a;
+	return ULLONG_MAX;
+}
+
+static int au_statfs_sum(struct super_block *sb, struct kstatfs *buf)
+{
+	int err;
+	u64 blocks, bfree, bavail, files, ffree;
+	aufs_bindex_t bend, bindex, i;
+	unsigned char shared;
+	struct vfsmount *h_mnt;
+	struct super_block *h_sb;
+
+	blocks = 0;
+	bfree = 0;
+	bavail = 0;
+	files = 0;
+	ffree = 0;
+
+	err = 0;
+	bend = au_sbend(sb);
+	for (bindex = bend; bindex >= 0; bindex--) {
+		h_mnt = au_sbr_mnt(sb, bindex);
+		h_sb = h_mnt->mnt_sb;
+		shared = 0;
+		for (i = bindex + 1; !shared && i <= bend; i++)
+			shared = (au_sbr_sb(sb, i) == h_sb);
+		if (shared)
+			continue;
+
+		/* sb->s_root for NFS is unreliable */
+		err = vfs_statfs(h_mnt->mnt_root, buf);
+		if (unlikely(err))
+			goto out;
+
+		blocks = au_add_till_max(blocks, buf->f_blocks);
+		bfree = au_add_till_max(bfree, buf->f_bfree);
+		bavail = au_add_till_max(bavail, buf->f_bavail);
+		files = au_add_till_max(files, buf->f_files);
+		ffree = au_add_till_max(ffree, buf->f_ffree);
+	}
+
+	buf->f_blocks = blocks;
+	buf->f_bfree = bfree;
+	buf->f_bavail = bavail;
+	buf->f_files = files;
+	buf->f_ffree = ffree;
+
+ out:
+	return err;
+}
+
+static int aufs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	int err;
+	struct super_block *sb;
+
+	/* lock free root dinfo */
+	sb = dentry->d_sb;
+	si_noflush_read_lock(sb);
+	if (!au_opt_test(au_mntflags(sb), SUM))
+		/* sb->s_root for NFS is unreliable */
+		err = vfs_statfs(au_sbr_mnt(sb, 0)->mnt_root, buf);
+	else
+		err = au_statfs_sum(sb, buf);
+	si_read_unlock(sb);
+
+	if (!err) {
+		buf->f_type = AUFS_SUPER_MAGIC;
+		buf->f_namelen -= AUFS_WH_PFX_LEN;
+		memset(&buf->f_fsid, 0, sizeof(buf->f_fsid));
+	}
+	/* buf->f_bsize = buf->f_blocks = buf->f_bfree = buf->f_bavail = -1; */
+
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* try flushing the lower fs at aufs remount/unmount time */
+
+static void au_fsync_br(struct super_block *sb)
+{
+	aufs_bindex_t bend, bindex;
+	int brperm;
+	struct au_branch *br;
+	struct super_block *h_sb;
+
+	bend = au_sbend(sb);
+	for (bindex = 0; bindex < bend; bindex++) {
+		br = au_sbr(sb, bindex);
+		brperm = br->br_perm;
+		if (brperm == AuBrPerm_RR || brperm == AuBrPerm_RRWH)
+			continue;
+		h_sb = br->br_mnt->mnt_sb;
+		if (bdev_read_only(h_sb->s_bdev))
+			continue;
+
+		lockdep_off();
+		down_write(&h_sb->s_umount);
+		shrink_dcache_sb(h_sb);
+		fsync_super(h_sb);
+		up_write(&h_sb->s_umount);
+		lockdep_on();
+	}
+}
+
+/*
+ * this IS NOT for super_operations.
+ * I guess it will be reverted someday.
+ */
+static void aufs_umount_begin(struct super_block *sb)
+{
+	struct au_sbinfo *sbinfo;
+
+	sbinfo = au_sbi(sb);
+	if (!sbinfo)
+		return;
+
+	si_write_lock(sb);
+	au_fsync_br(sb);
+	if (au_opt_test(au_mntflags(sb), PLINK))
+		au_plink_put(sb);
+	if (sbinfo->si_wbr_create_ops->fin)
+		sbinfo->si_wbr_create_ops->fin(sb);
+	si_write_unlock(sb);
+}
+
+/* final actions when unmounting a file system */
+static void aufs_put_super(struct super_block *sb)
+{
+	struct au_sbinfo *sbinfo;
+
+	sbinfo = au_sbi(sb);
+	if (!sbinfo)
+		return;
+
+	aufs_umount_begin(sb);
+	kobject_put(&sbinfo->si_kobj);
+}
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * refresh dentry and inode at remount time.
+ */
+static int do_refresh(struct dentry *dentry, mode_t type,
+		      unsigned int dir_flags)
+{
+	int err;
+	struct dentry *parent;
+
+	di_write_lock_child(dentry);
+	parent = dget_parent(dentry);
+	di_read_lock_parent(parent, AuLock_IR);
+
+	/* returns the number of positive dentries */
+	err = au_refresh_hdentry(dentry, type);
+	if (err >= 0) {
+		struct inode *inode = dentry->d_inode;
+		err = au_refresh_hinode(inode, dentry);
+		if (!err && type == S_IFDIR)
+			au_reset_hinotify(inode, dir_flags);
+	}
+	if (unlikely(err))
+		AuErr("unrecoverable error %d, %.*s\n", err, AuDLNPair(dentry));
+
+	di_read_unlock(parent, AuLock_IR);
+	dput(parent);
+	di_write_unlock(dentry);
+
+	return err;
+}
+
+static int test_dir(struct dentry *dentry, void *arg __maybe_unused)
+{
+	return S_ISDIR(dentry->d_inode->i_mode);
+}
+
+/* gave up consolidating with refresh_nondir() */
+static int refresh_dir(struct dentry *root, unsigned int sigen)
+{
+	int err, i, j, ndentry, e;
+	struct au_dcsub_pages dpages;
+	struct au_dpage *dpage;
+	struct dentry **dentries;
+	struct inode *inode;
+	const unsigned int flags = au_hi_flags(root->d_inode, /*isdir*/1);
+
+	err = 0;
+	list_for_each_entry(inode, &root->d_sb->s_inodes, i_sb_list)
+		if (S_ISDIR(inode->i_mode) && au_iigen(inode) != sigen) {
+			ii_write_lock_child(inode);
+			e = au_refresh_hinode_self(inode, /*do_attr*/1);
+			ii_write_unlock(inode);
+			if (unlikely(e)) {
+				AuDbg("e %d, i%lu\n", e, inode->i_ino);
+				if (!err)
+					err = e;
+				/* go on even if err */
+			}
+		}
+
+	e = au_dpages_init(&dpages, GFP_NOFS);
+	if (unlikely(e)) {
+		if (!err)
+			err = e;
+		goto out;
+	}
+	e = au_dcsub_pages(&dpages, root, test_dir, NULL);
+	if (unlikely(e)) {
+		if (!err)
+			err = e;
+		goto out_dpages;
+	}
+
+	for (i = 0; !e && i < dpages.ndpage; i++) {
+		dpage = dpages.dpages + i;
+		dentries = dpage->dentries;
+		ndentry = dpage->ndentry;
+		for (j = 0; !e && j < ndentry; j++) {
+			struct dentry *d;
+
+			d = dentries[j];
+			au_dbg_verify_dir_parent(d, sigen);
+			if (au_digen(d) != sigen) {
+				e = do_refresh(d, S_IFDIR, flags);
+				if (unlikely(e && !err))
+					err = e;
+				/* break on err */
+			}
+		}
+	}
+
+ out_dpages:
+	au_dpages_free(&dpages);
+ out:
+	return err;
+}
+
+static int test_nondir(struct dentry *dentry, void *arg __maybe_unused)
+{
+	return !S_ISDIR(dentry->d_inode->i_mode);
+}
+
+static int refresh_nondir(struct dentry *root, unsigned int sigen,
+			  int do_dentry)
+{
+	int err, i, j, ndentry, e;
+	struct au_dcsub_pages dpages;
+	struct au_dpage *dpage;
+	struct dentry **dentries;
+	struct inode *inode;
+
+	err = 0;
+	list_for_each_entry(inode, &root->d_sb->s_inodes, i_sb_list)
+		if (!S_ISDIR(inode->i_mode) && au_iigen(inode) != sigen) {
+			ii_write_lock_child(inode);
+			e = au_refresh_hinode_self(inode, /*do_attr*/1);
+			ii_write_unlock(inode);
+			if (unlikely(e)) {
+				AuDbg("e %d, i%lu\n", e, inode->i_ino);
+				if (!err)
+					err = e;
+				/* go on even if err */
+			}
+		}
+
+	if (!do_dentry)
+		goto out;
+
+	e = au_dpages_init(&dpages, GFP_NOFS);
+	if (unlikely(e)) {
+		if (!err)
+			err = e;
+		goto out;
+	}
+	e = au_dcsub_pages(&dpages, root, test_nondir, NULL);
+	if (unlikely(e)) {
+		if (!err)
+			err = e;
+		goto out_dpages;
+	}
+
+	for (i = 0; i < dpages.ndpage; i++) {
+		dpage = dpages.dpages + i;
+		dentries = dpage->dentries;
+		ndentry = dpage->ndentry;
+		for (j = 0; j < ndentry; j++) {
+			struct dentry *d;
+
+			d = dentries[j];
+			au_dbg_verify_nondir_parent(d, sigen);
+			inode = d->d_inode;
+			if (inode && au_digen(d) != sigen) {
+				e = do_refresh(d, inode->i_mode & S_IFMT,
+					       /*dir_flags*/0);
+				if (unlikely(e && !err))
+					err = e;
+				/* go on even err */
+			}
+		}
+	}
+
+ out_dpages:
+	au_dpages_free(&dpages);
+ out:
+	return err;
+}
+
+static void au_remount_refresh(struct super_block *sb, unsigned int flags)
+{
+	int err;
+	unsigned int sigen;
+	struct au_sbinfo *sbinfo;
+	struct dentry *root;
+	struct inode *inode;
+
+	au_sigen_inc(sb);
+	sigen = au_sigen(sb);
+	sbinfo = au_sbi(sb);
+	au_fclr_si(sbinfo, FAILED_REFRESH_DIRS);
+
+	root = sb->s_root;
+	DiMustNoWaiters(root);
+	inode = root->d_inode;
+	IiMustNoWaiters(inode);
+	au_reset_hinotify(inode, au_hi_flags(inode, /*isdir*/1));
+	di_write_unlock(root);
+
+	err = refresh_dir(root, sigen);
+	if (unlikely(err)) {
+		au_fset_si(sbinfo, FAILED_REFRESH_DIRS);
+		AuWarn("Refreshing directories failed, ignored (%d)\n", err);
+	}
+
+	if (au_ftest_opts(flags, REFRESH_NONDIR)) {
+		err = refresh_nondir(root, sigen, !err);
+		if (unlikely(err))
+			AuWarn("Refreshing non-directories failed, ignored"
+			       "(%d)\n", err);
+	}
+
+	/* aufs_write_lock() calls ..._child() */
+	di_write_lock_child(root);
+	au_cpup_attr_all(root->d_inode, /*force*/1);
+}
+
+/* stop extra interpretation of errno in mount(8), and strange error messages */
+static int cvt_err(int err)
+{
+	AuTraceErr(err);
+
+	switch (err) {
+	case -ENOENT:
+	case -ENOTDIR:
+	case -EEXIST:
+	case -EIO:
+		err = -EINVAL;
+	}
+	return err;
+}
+
+static int aufs_remount_fs(struct super_block *sb, int *flags, char *data)
+{
+	int err;
+	struct au_opts opts;
+	struct dentry *root;
+	struct inode *inode;
+	struct au_sbinfo *sbinfo;
+
+	err = 0;
+	root = sb->s_root;
+	if (!data || !*data) {
+		aufs_write_lock(root);
+		err = au_opts_verify(sb, *flags, /*pending*/0);
+		if (!err)
+			au_fsync_br(sb);
+		aufs_write_unlock(root);
+		goto out;
+	}
+
+	err = -ENOMEM;
+	memset(&opts, 0, sizeof(opts));
+	opts.opt = (void *)__get_free_page(GFP_NOFS);
+	if (unlikely(!opts.opt))
+		goto out;
+	opts.max_opt = PAGE_SIZE / sizeof(*opts.opt);
+	opts.flags = AuOpts_REMOUNT;
+	opts.sb_flags = *flags;
+
+	/* parse it before aufs lock */
+	err = au_opts_parse(sb, data, &opts);
+	if (unlikely(err))
+		goto out_opts;
+
+	sbinfo = au_sbi(sb);
+	inode = root->d_inode;
+	mutex_lock(&inode->i_mutex);
+	aufs_write_lock(root);
+	au_fsync_br(sb);
+
+	/* au_opts_remount() may return an error */
+	err = au_opts_remount(sb, &opts);
+	au_opts_free(&opts);
+
+	if (au_ftest_opts(opts.flags, REFRESH_DIR)
+	    || au_ftest_opts(opts.flags, REFRESH_NONDIR))
+		au_remount_refresh(sb, opts.flags);
+
+	aufs_write_unlock(root);
+	mutex_unlock(&inode->i_mutex);
+
+ out_opts:
+	free_page((unsigned long)opts.opt);
+ out:
+	err = cvt_err(err);
+	AuTraceErr(err);
+	return err;
+}
+
+static struct super_operations aufs_sop = {
+	.alloc_inode	= aufs_alloc_inode,
+	.destroy_inode	= aufs_destroy_inode,
+	.drop_inode	= generic_delete_inode,
+	.show_options	= aufs_show_options,
+	.statfs		= aufs_statfs,
+	.put_super	= aufs_put_super,
+	.remount_fs	= aufs_remount_fs
+};
+
+/* ---------------------------------------------------------------------- */
+
+static int alloc_root(struct super_block *sb)
+{
+	int err;
+	struct inode *inode;
+	struct dentry *root;
+
+	err = -ENOMEM;
+	inode = au_iget_locked(sb, AUFS_ROOT_INO);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out;
+
+	inode->i_op = &aufs_dir_iop;
+	inode->i_fop = &aufs_dir_fop;
+	inode->i_mode = S_IFDIR;
+	inode->i_nlink = 2;
+	unlock_new_inode(inode);
+
+	root = d_alloc_root(inode);
+	if (unlikely(!root))
+		goto out_iput;
+	err = PTR_ERR(root);
+	if (IS_ERR(root))
+		goto out_iput;
+
+	err = au_alloc_dinfo(root);
+	if (!err) {
+		sb->s_root = root;
+		return 0; /* success */
+	}
+	dput(root);
+	goto out; /* do not iput */
+
+ out_iput:
+	iget_failed(inode);
+	iput(inode);
+ out:
+	return err;
+
+}
+
+static int aufs_fill_super(struct super_block *sb, void *raw_data,
+			   int silent __maybe_unused)
+{
+	int err;
+	struct au_opts opts;
+	struct dentry *root;
+	struct inode *inode;
+	char *arg = raw_data;
+
+	if (unlikely(!arg || !*arg)) {
+		err = -EINVAL;
+		AuErr("no arg\n");
+		goto out;
+	}
+
+	err = -ENOMEM;
+	memset(&opts, 0, sizeof(opts));
+	opts.opt = (void *)__get_free_page(GFP_NOFS);
+	if (unlikely(!opts.opt))
+		goto out;
+	opts.max_opt = PAGE_SIZE / sizeof(*opts.opt);
+	opts.sb_flags = sb->s_flags;
+
+	err = au_si_alloc(sb);
+	if (unlikely(err))
+		goto out_opts;
+
+	/* all timestamps always follow the ones on the branch */
+	sb->s_flags |= MS_NOATIME | MS_NODIRATIME;
+	sb->s_op = &aufs_sop;
+	sb->s_magic = AUFS_SUPER_MAGIC;
+	sb->s_maxbytes = 0;
+
+	err = alloc_root(sb);
+	if (unlikely(err)) {
+		si_write_unlock(sb);
+		goto out_info;
+	}
+	root = sb->s_root;
+	inode = root->d_inode;
+
+	/*
+	 * actually we can parse options regardless aufs lock here.
+	 * but at remount time, parsing must be done before aufs lock.
+	 * so we follow the same rule.
+	 */
+	ii_write_lock_parent(inode);
+	aufs_write_unlock(root);
+	err = au_opts_parse(sb, arg, &opts);
+	if (unlikely(err))
+		goto out_root;
+
+	/* lock vfs_inode first, then aufs. */
+	mutex_lock(&inode->i_mutex);
+	inode->i_op = &aufs_dir_iop;
+	inode->i_fop = &aufs_dir_fop;
+	aufs_write_lock(root);
+	err = au_opts_mount(sb, &opts);
+	au_opts_free(&opts);
+	if (unlikely(err))
+		goto out_unlock;
+	aufs_write_unlock(root);
+	mutex_unlock(&inode->i_mutex);
+	goto out_opts; /* success */
+
+ out_unlock:
+	aufs_write_unlock(root);
+	mutex_unlock(&inode->i_mutex);
+ out_root:
+	dput(root);
+	sb->s_root = NULL;
+ out_info:
+	kobject_put(&au_sbi(sb)->si_kobj);
+	sb->s_fs_info = NULL;
+ out_opts:
+	free_page((unsigned long)opts.opt);
+ out:
+	AuTraceErr(err);
+	err = cvt_err(err);
+	AuTraceErr(err);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int aufs_get_sb(struct file_system_type *fs_type, int flags,
+		       const char *dev_name __maybe_unused, void *raw_data,
+		       struct vfsmount *mnt)
+{
+	int err;
+	struct super_block *sb;
+
+	/* all timestamps always follow the ones on the branch */
+	/* mnt->mnt_flags |= MNT_NOATIME | MNT_NODIRATIME; */
+	err = get_sb_nodev(fs_type, flags, raw_data, aufs_fill_super, mnt);
+	if (!err) {
+		sb = mnt->mnt_sb;
+		si_write_lock(sb);
+		sysaufs_brs_add(sb, 0);
+		si_write_unlock(sb);
+	}
+	return err;
+}
+
+struct file_system_type aufs_fs_type = {
+	.name		= AUFS_FSTYPE,
+	.fs_flags	=
+		FS_RENAME_DOES_D_MOVE	/* a race between rename and others */
+		| FS_REVAL_DOT,		/* for NFS branch and udba */
+	.get_sb		= aufs_get_sb,
+	.kill_sb	= generic_shutdown_super,
+	/* no need to __module_get() and module_put(). */
+	.owner		= THIS_MODULE,
+};
diff --git a/fs/aufs/super.h b/fs/aufs/super.h
new file mode 100644
index 0000000..83721ef
--- /dev/null
+++ b/fs/aufs/super.h
@@ -0,0 +1,266 @@
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
+ * super_block operations
+ */
+
+#ifndef __AUFS_SUPER_H__
+#define __AUFS_SUPER_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/kobject.h>
+#include <linux/aufs_type.h>
+#include "rwsem.h"
+#include "spl.h"
+#include "wkq.h"
+
+typedef ssize_t (*au_readf_t)(struct file *, char __user *, size_t, loff_t *);
+typedef ssize_t (*au_writef_t)(struct file *, const char __user *, size_t,
+			       loff_t *);
+
+/* policies to select one among multiple writable branches */
+struct au_wbr_copyup_operations {
+	int (*copyup)(struct dentry *dentry);
+};
+
+struct au_wbr_create_operations {
+	int (*create)(struct dentry *dentry, int isdir);
+	int (*init)(struct super_block *sb);
+	int (*fin)(struct super_block *sb);
+};
+
+struct au_wbr_mfs {
+	struct mutex	mfs_lock; /* protect this structure */
+	unsigned long	mfs_jiffy;
+	unsigned long	mfs_expire;
+	aufs_bindex_t	mfs_bindex;
+
+	unsigned long long	mfsrr_bytes;
+	unsigned long long	mfsrr_watermark;
+};
+
+/* sbinfo status flags */
+/*
+ * set true when refresh_dirs() failed at remount time.
+ * then try refreshing dirs at access time again.
+ * if it is false, refreshing dirs at access time is unnecesary
+ */
+#define AuSi_FAILED_REFRESH_DIRS	1
+#define AuSi_MAINTAIN_PLINK		(1 << 1)	/* ioctl */
+#define au_ftest_si(sbinfo, name)	((sbinfo)->au_si_status & AuSi_##name)
+#define au_fset_si(sbinfo, name) \
+	{ (sbinfo)->au_si_status |= AuSi_##name; }
+#define au_fclr_si(sbinfo, name) \
+	{ (sbinfo)->au_si_status &= ~AuSi_##name; }
+
+struct au_branch;
+struct au_sbinfo {
+	/* nowait tasks in the system-wide workqueue */
+	struct au_nowait_tasks	si_nowait;
+
+	struct rw_semaphore	si_rwsem;
+
+	/* branch management */
+	unsigned int		si_generation;
+
+	/* see above flags */
+	unsigned char		au_si_status;
+
+	aufs_bindex_t		si_bend;
+	aufs_bindex_t		si_last_br_id;
+	struct au_branch	**si_branch;
+
+	/* policy to select a writable branch */
+	unsigned char		si_wbr_copyup;
+	unsigned char		si_wbr_create;
+	struct au_wbr_copyup_operations *si_wbr_copyup_ops;
+	struct au_wbr_create_operations *si_wbr_create_ops;
+
+	/* round robin */
+	atomic_t		si_wbr_rr_next;
+
+	/* most free space */
+	struct au_wbr_mfs	si_wbr_mfs;
+
+	/* mount flags */
+	/* include/asm-ia64/siginfo.h defines a macro named si_flags */
+	unsigned int		si_mntflags;
+
+	/* external inode number (bitmap and translation table) */
+	au_readf_t		si_xread;
+	au_writef_t		si_xwrite;
+	struct file		*si_xib;
+	struct mutex		si_xib_mtx; /* protect xib members */
+	unsigned long		*si_xib_buf;
+	unsigned long		si_xib_last_pindex;
+	int			si_xib_next_bit;
+	aufs_bindex_t		si_xino_brid;
+	/* reserved for future use */
+	/* unsigned long long	si_xib_limit; */	/* Max xib file size */
+
+	/* readdir cache time, max, in HZ */
+	unsigned long		si_rdcache;
+
+	/*
+	 * If the number of whiteouts are larger than si_dirwh, leave all of
+	 * them after au_whtmp_ren to reduce the cost of rmdir(2).
+	 * future fsck.aufs or kernel thread will remove them later.
+	 * Otherwise, remove all whiteouts and the dir in rmdir(2).
+	 */
+	unsigned int		si_dirwh;
+
+	/*
+	 * rename(2) a directory with all children.
+	 */
+	/* reserved for future use */
+	/* int			si_rendir; */
+
+	/* pseudo_link list */
+	struct au_splhead	si_plink;
+	wait_queue_head_t	si_plink_wq;
+
+	/*
+	 * sysfs and lifetime management.
+	 * this is not a small structure and it may be a waste of memory in case
+	 * of sysfs is disabled, particulary when many aufs-es are mounted.
+	 * but using sysfs is majority.
+	 */
+	struct kobject		si_kobj;
+
+	/* dirty, necessary for unmounting, sysfs and sysrq */
+	struct super_block	*si_sb;
+};
+
+/* ---------------------------------------------------------------------- */
+
+/* policy to select one among writable branches */
+#define AuWbrCopyup(sbinfo, args...) \
+	((sbinfo)->si_wbr_copyup_ops->copyup(args))
+#define AuWbrCreate(sbinfo, args...) \
+	((sbinfo)->si_wbr_create_ops->create(args))
+
+/* flags for si_read_lock()/aufs_read_lock()/di_read_lock() */
+#define AuLock_DW		1		/* write-lock dentry */
+#define AuLock_IR		(1 << 1)	/* read-lock inode */
+#define AuLock_IW		(1 << 2)	/* write-lock inode */
+#define AuLock_FLUSH		(1 << 3)	/* wait for 'nowait' tasks */
+#define AuLock_DIR		(1 << 4)	/* target is a dir */
+#define au_ftest_lock(flags, name)	((flags) & AuLock_##name)
+#define au_fset_lock(flags, name)	{ (flags) |= AuLock_##name; }
+#define au_fclr_lock(flags, name)	{ (flags) &= ~AuLock_##name; }
+
+/* ---------------------------------------------------------------------- */
+
+/* super.c */
+extern struct file_system_type aufs_fs_type;
+struct inode *au_iget_locked(struct super_block *sb, ino_t ino);
+
+/* sbinfo.c */
+void au_si_free(struct kobject *kobj);
+int au_si_alloc(struct super_block *sb);
+int au_sbr_realloc(struct au_sbinfo *sbinfo, int nbr);
+
+unsigned int au_sigen_inc(struct super_block *sb);
+aufs_bindex_t au_new_br_id(struct super_block *sb);
+
+void aufs_read_lock(struct dentry *dentry, int flags);
+void aufs_read_unlock(struct dentry *dentry, int flags);
+void aufs_write_lock(struct dentry *dentry);
+void aufs_write_unlock(struct dentry *dentry);
+void aufs_read_and_write_lock2(struct dentry *d1, struct dentry *d2, int isdir);
+void aufs_read_and_write_unlock2(struct dentry *d1, struct dentry *d2);
+
+/* wbr_policy.c */
+extern struct au_wbr_copyup_operations au_wbr_copyup_ops[];
+extern struct au_wbr_create_operations au_wbr_create_ops[];
+int au_cpdown_dirs(struct dentry *dentry, aufs_bindex_t bdst);
+
+/* ---------------------------------------------------------------------- */
+
+static inline struct au_sbinfo *au_sbi(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* lock superblock. mainly for entry point functions */
+/*
+ * si_noflush_read_lock, si_noflush_write_lock,
+ * si_read_unlock, si_write_unlock, si_downgrade_lock
+ */
+AuSimpleLockRwsemFuncs(si_noflush, struct super_block *sb,
+		       &au_sbi(sb)->si_rwsem);
+AuSimpleUnlockRwsemFuncs(si, struct super_block *sb, &au_sbi(sb)->si_rwsem);
+
+static inline void si_read_lock(struct super_block *sb, int flags)
+{
+	if (au_ftest_lock(flags, FLUSH))
+		au_nwt_flush(&au_sbi(sb)->si_nowait);
+	si_noflush_read_lock(sb);
+}
+
+static inline void si_write_lock(struct super_block *sb)
+{
+	au_nwt_flush(&au_sbi(sb)->si_nowait);
+	si_noflush_write_lock(sb);
+}
+
+static inline int si_read_trylock(struct super_block *sb, int flags)
+{
+	if (au_ftest_lock(flags, FLUSH))
+		au_nwt_flush(&au_sbi(sb)->si_nowait);
+	return si_noflush_read_trylock(sb);
+}
+
+static inline int si_write_trylock(struct super_block *sb, int flags)
+{
+	if (au_ftest_lock(flags, FLUSH))
+		au_nwt_flush(&au_sbi(sb)->si_nowait);
+	return si_noflush_write_trylock(sb);
+}
+
+/* ---------------------------------------------------------------------- */
+
+static inline aufs_bindex_t au_sbend(struct super_block *sb)
+{
+	return au_sbi(sb)->si_bend;
+}
+
+static inline unsigned int au_mntflags(struct super_block *sb)
+{
+	return au_sbi(sb)->si_mntflags;
+}
+
+static inline unsigned int au_sigen(struct super_block *sb)
+{
+	return au_sbi(sb)->si_generation;
+}
+
+static inline struct au_branch *au_sbr(struct super_block *sb,
+				       aufs_bindex_t bindex)
+{
+	return au_sbi(sb)->si_branch[0 + bindex];
+}
+
+static inline void au_xino_brid_set(struct super_block *sb, aufs_bindex_t brid)
+{
+	au_sbi(sb)->si_xino_brid = brid;
+}
+
+static inline aufs_bindex_t au_xino_brid(struct super_block *sb)
+{
+	return au_sbi(sb)->si_xino_brid;
+}
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_SUPER_H__ */
-- 
1.6.1.284.g5dc13

