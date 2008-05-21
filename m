Return-Path: <linux-kernel-owner+w=401wt.eu-S935989AbYEUDtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935989AbYEUDtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbYEUDe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:34:58 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44121 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762396AbYEUDdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:33:01 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 06/39] aufs branch directory/filesystem
Date: Wed, 21 May 2008 12:22:36 +0900
Message-Id: <1211340189-11813-7-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

branch management

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/branch.c |  912 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/branch.h |  352 +++++++++++++++++++++
 2 files changed, 1264 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/branch.c
 create mode 100644 fs/aufs/branch.h

diff --git a/fs/aufs/branch.c b/fs/aufs/branch.c
new file mode 100644
index 0000000..88b6258
--- /dev/null
+++ b/fs/aufs/branch.c
@@ -0,0 +1,912 @@
+/*
+ * Copyright (C) 2005-2008 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * branch management
+ */
+
+#include <linux/iso_fs.h>
+#include <linux/loop.h>
+#include <linux/romfs_fs.h>
+#include <linux/smp_lock.h>
+#include "aufs.h"
+
+static void free_branch(struct au_branch *br)
+{
+	AuTraceEnter();
+
+	if (br->br_xino)
+		fput(br->br_xino);
+	dput(br->br_wh);
+	dput(br->br_plink);
+	if (!au_test_nfs(br->br_mnt->mnt_sb))
+		mntput(br->br_mnt);
+	else {
+		lockdep_off();
+		mntput(br->br_mnt);
+		lockdep_on();
+	}
+	AuDebugOn(au_br_count(br) || atomic_read(&br->br_wh_running));
+	kfree(br);
+}
+
+/*
+ * frees all branches
+ */
+void au_br_free(struct au_sbinfo *sbinfo)
+{
+	aufs_bindex_t bmax;
+	struct au_branch **br;
+
+	AuTraceEnter();
+	bmax = sbinfo->si_bend + 1;
+	br = sbinfo->si_branch;
+	while (bmax--)
+		free_branch(*br++);
+}
+
+/*
+ * find the index of a branch which is specified by @br_id.
+ */
+int au_br_index(struct super_block *sb, aufs_bindex_t br_id)
+{
+	aufs_bindex_t bindex, bend;
+
+	AuTraceEnter();
+
+	bend = au_sbend(sb);
+	for (bindex = 0; bindex <= bend; bindex++)
+		if (au_sbr_id(sb, bindex) == br_id)
+			return bindex;
+	return -1;
+}
+
+/*
+ * test if the @h_sb is real-readonly.
+ */
+int au_test_def_rr(struct super_block *h_sb)
+{
+	switch (h_sb->s_magic) {
+#if defined(CONFIG_ISO9660_FS) || defined(CONFIG_ISO9660_FS_MODULE)
+	case ISOFS_SUPER_MAGIC:
+		return 1;
+#endif
+
+#if defined(CONFIG_CRAMFS) || defined(CONFIG_CRAMFS_MODULE)
+	case CRAMFS_MAGIC:
+		return 1;
+#endif
+
+#if defined(CONFIG_ROMFS_FS) || defined(CONFIG_ROMFS_FS_MODULE)
+	case ROMFS_MAGIC:
+		return 1;
+#endif
+
+	default:
+		return 0;
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * test if two hidden_dentries have overlapping branches.
+ */
+static int do_test_overlap(struct super_block *sb, struct dentry *h_d1,
+			   struct dentry *h_d2)
+{
+	int err;
+
+	LKTRTrace("%.*s, %.*s\n", AuDLNPair(h_d1), AuDLNPair(h_d2));
+
+	err = au_test_subdir(h_d1, h_d2);
+	AuTraceErr(err);
+	return err;
+}
+
+static int test_overlap_loopback(struct super_block *sb, struct dentry *h_d1,
+				 struct dentry *h_d2)
+{
+#if defined(CONFIG_BLK_DEV_LOOP) || defined(CONFIG_BLK_DEV_LOOP_MODULE)
+	struct inode *h_inode;
+	struct loop_device *l;
+
+	h_inode = h_d1->d_inode;
+	if (MAJOR(h_inode->i_sb->s_dev) != LOOP_MAJOR)
+		return 0;
+
+	l = h_inode->i_sb->s_bdev->bd_disk->private_data;
+	h_d1 = l->lo_backing_file->f_dentry;
+	if (unlikely(h_d1->d_sb == sb))
+		return 1;
+	return do_test_overlap(sb, h_d1, h_d2);
+#else
+	return 0;
+#endif
+}
+
+static int test_overlap(struct super_block *sb, struct dentry *h_d1,
+			struct dentry *h_d2)
+{
+	LKTRTrace("d1 %.*s, d2 %.*s\n", AuDLNPair(h_d1), AuDLNPair(h_d2));
+
+	if (unlikely(h_d1 == h_d2))
+		return 1;
+	return do_test_overlap(sb, h_d1, h_d2)
+		|| do_test_overlap(sb, h_d2, h_d1)
+		|| test_overlap_loopback(sb, h_d1, h_d2)
+		|| test_overlap_loopback(sb, h_d2, h_d1);
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int init_br_wh(struct super_block *sb, aufs_bindex_t bindex,
+		      struct au_branch *br, int new_perm,
+		      struct dentry *h_root, struct vfsmount *h_mnt)
+{
+	int err, old_perm;
+	struct inode *dir, *h_dir;
+	const int new = (bindex < 0);
+
+	LKTRTrace("b%d, new_perm %d\n", bindex, new_perm);
+
+	dir = sb->s_root->d_inode;
+	h_dir = h_root->d_inode;
+	if (new)
+		mutex_lock_nested(&h_dir->i_mutex, AuLsc_I_PARENT);
+	else
+		au_hdir_lock(h_dir, dir, bindex);
+
+	br_wh_write_lock(br);
+	old_perm = br->br_perm;
+	br->br_perm = new_perm;
+	err = au_wh_init(h_root, br, au_do_nfsmnt(h_mnt), sb);
+	br->br_perm = old_perm;
+	br_wh_write_unlock(br);
+
+	if (new)
+		mutex_unlock(&h_dir->i_mutex);
+	else
+		au_hdir_unlock(h_dir, dir, bindex);
+
+	AuTraceErr(err);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * returns a newly allocated branch. @new_nbranch is a number of branches
+ * after adding a branch.
+ */
+static struct au_branch *alloc_addbr(struct super_block *sb, int new_nbranch)
+{
+	struct au_branch **branchp, *add_branch;
+	int sz;
+	void *p;
+	struct dentry *root;
+	struct inode *inode;
+	struct au_hinode *hinodep;
+	struct au_hdentry *hdentryp;
+
+	LKTRTrace("new_nbranch %d\n", new_nbranch);
+	SiMustWriteLock(sb);
+	root = sb->s_root;
+	DiMustWriteLock(root);
+	inode = root->d_inode;
+	IiMustWriteLock(inode);
+
+	add_branch = kmalloc(sizeof(*add_branch), GFP_KERNEL);
+	if (unlikely(!add_branch))
+		goto out;
+
+	sz = sizeof(*branchp) * (new_nbranch - 1);
+	if (unlikely(!sz))
+		sz = sizeof(*branchp);
+	p = au_sbi(sb)->si_branch;
+	branchp = au_kzrealloc(p, sz, sizeof(*branchp) * new_nbranch,
+			       GFP_KERNEL);
+	if (unlikely(!branchp))
+		goto out_br;
+	au_sbi(sb)->si_branch = branchp;
+
+	sz = sizeof(*hdentryp) * (new_nbranch - 1);
+	if (unlikely(!sz))
+		sz = sizeof(*hdentryp);
+	p = au_di(root)->di_hdentry;
+	hdentryp = au_kzrealloc(p, sz, sizeof(*hdentryp) * new_nbranch,
+				GFP_KERNEL);
+	if (unlikely(!hdentryp))
+		goto out_br;
+	au_di(root)->di_hdentry = hdentryp;
+
+	sz = sizeof(*hinodep) * (new_nbranch - 1);
+	if (unlikely(!sz))
+		sz = sizeof(*hinodep);
+	p = au_ii(inode)->ii_hinode;
+	hinodep = au_kzrealloc(p, sz, sizeof(*hinodep) * new_nbranch,
+			       GFP_KERNEL);
+	if (unlikely(!hinodep))
+		goto out_br;
+	au_ii(inode)->ii_hinode = hinodep;
+	return add_branch; /* success */
+
+ out_br:
+	kfree(add_branch);
+ out:
+	AuTraceErr(-ENOMEM);
+	return ERR_PTR(-ENOMEM);
+}
+
+/*
+ * test if the branch permission is legal or not.
+ */
+static int test_br(struct super_block *sb, struct inode *inode, int brperm,
+		   char *path)
+{
+	int err;
+
+	err = 0;
+	if (unlikely(au_br_writable(brperm) && IS_RDONLY(inode))) {
+		AuErr("write permission for readonly fs or inode, %s\n", path);
+		err = -EINVAL;
+	}
+
+	AuTraceErr(err);
+	return err;
+}
+
+/*
+ * returns:
+ * 0: success, the caller will add it
+ * plus: success, it is already unified, the caller should ignore it
+ * minus: error
+ */
+static int test_add(struct super_block *sb, struct au_opt_add *add, int remount)
+{
+	int err;
+	struct dentry *root;
+	struct inode *inode, *h_inode;
+	aufs_bindex_t bend, bindex;
+
+	LKTRTrace("%s, remo%d\n", add->path, remount);
+
+	root = sb->s_root;
+	bend = au_sbend(sb);
+	if (unlikely(bend >= 0
+		     && au_find_dbindex(root, add->nd.path.dentry) >= 0)) {
+		err = 1;
+		if (!remount) {
+			err = -EINVAL;
+			AuErr("%s duplicated\n", add->path);
+		}
+		goto out;
+	}
+
+	err = -ENOSPC; /* -E2BIG; */
+	if (unlikely(AUFS_BRANCH_MAX <= add->bindex
+		     || AUFS_BRANCH_MAX - 1 <= bend)) {
+		AuErr("number of branches exceeded %s\n", add->path);
+		goto out;
+	}
+
+	err = -EDOM;
+	if (unlikely(add->bindex < 0 || bend + 1 < add->bindex)) {
+		AuErr("bad index %d\n", add->bindex);
+		goto out;
+	}
+
+	inode = add->nd.path.dentry->d_inode;
+	AuDebugOn(!inode || !S_ISDIR(inode->i_mode));
+	err = -ENOENT;
+	if (unlikely(!inode->i_nlink)) {
+		AuErr("no existence %s\n", add->path);
+		goto out;
+	}
+
+	err = -EINVAL;
+	if (unlikely(inode->i_sb == sb)) {
+		AuErr("%s must be outside\n", add->path);
+		goto out;
+	}
+
+	if (unlikely(au_test_nested(inode->i_sb))) {
+		AuErr("nested " AUFS_NAME " %s\n", add->path);
+		goto out;
+	}
+
+	if (unlikely(!strcmp(au_sbtype(inode->i_sb), "unionfs"))) {
+		AuErr("unsupported filesystem, %s\n", add->path);
+		goto out;
+	}
+
+	if (unlikely(au_test_unsupported_nfs(inode->i_sb))) {
+		AuErr(AuNoNfsBranchMsg " %s\n", add->path);
+		goto out;
+	}
+
+	err = test_br(sb, add->nd.path.dentry->d_inode, add->perm, add->path);
+	if (unlikely(err))
+		goto out;
+
+	if (bend < 0)
+		return 0; /* success */
+
+	h_inode = au_h_dptr(root, 0)->d_inode;
+	if (unlikely(au_opt_test(au_mntflags(sb), WARN_PERM)
+		     && ((h_inode->i_mode & S_IALLUGO)
+			 != (inode->i_mode & S_IALLUGO)
+			 || h_inode->i_uid != inode->i_uid
+			 || h_inode->i_gid != inode->i_gid)))
+		AuWarn("uid/gid/perm %s %u/%u/0%o, %u/%u/0%o\n",
+		       add->path,
+		       inode->i_uid, inode->i_gid, (inode->i_mode & S_IALLUGO),
+		       h_inode->i_uid, h_inode->i_gid,
+		       (h_inode->i_mode & S_IALLUGO));
+
+	err = -EINVAL;
+	for (bindex = 0; bindex <= bend; bindex++)
+		if (unlikely(test_overlap(sb, add->nd.path.dentry,
+					  au_h_dptr(root, bindex)))) {
+			AuErr("%s is overlapped\n", add->path);
+			goto out;
+		}
+	err = 0;
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+static int au_br_init(struct au_branch *br, struct super_block *sb,
+		      struct au_opt_add *add)
+{
+	int err;
+
+	AuTraceEnter();
+
+	err = 0;
+	au_rw_init_nolock(&br->br_wh_rwsem);
+	br->br_plink = NULL;
+	br->br_wh = NULL;
+	if (unlikely(au_br_writable(add->perm))) {
+		err = init_br_wh(sb, /*bindex*/-1, br, add->perm,
+				 add->nd.path.dentry, add->nd.path.mnt);
+		if (unlikely(err))
+			goto out;
+	}
+
+	br->br_xino = NULL;
+	br->br_mnt = mntget(add->nd.path.mnt);
+	if (au_opt_test(au_mntflags(sb), XINO)) {
+		err = au_xino_br(sb, br, add->nd.path.dentry->d_inode->i_ino,
+				 au_sbr(sb, 0)->br_xino, /*do_test*/1);
+		if (unlikely(err)) {
+			AuDebugOn(br->br_xino);
+			goto out;
+		}
+	}
+
+	atomic_set(&br->br_wh_running, 0);
+	br->br_id = au_new_br_id(sb);
+	br->br_perm = add->perm;
+	atomic_set(&br->br_count, 0);
+	br->br_bytes = 0;
+	br->br_xino_upper = AUFS_XINO_TRUNC_INIT;
+	atomic_set(&br->br_xino_running, 0);
+	sysaufs_br_init(br);
+	br->br_generation = au_sigen(sb);
+	/* smp_mb(); */ /* atomic_set */
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+int au_br_add(struct super_block *sb, struct au_opt_add *add, int remount)
+{
+	int err, amount;
+	aufs_bindex_t bend, add_bindex;
+	struct dentry *root, *dentry;
+	struct au_iinfo *iinfo;
+	struct au_sbinfo *sbinfo;
+	struct au_dinfo *dinfo;
+	struct inode *root_inode, *inode;
+	unsigned long long maxb;
+	struct au_branch **branchp, *add_branch;
+	struct au_hdentry *hdentryp;
+	struct au_hinode *hinodep;
+
+	dentry = add->nd.path.dentry;
+	LKTRTrace("b%d, %s, 0x%x, %.*s\n",
+		  add->bindex, add->path, add->perm, AuDLNPair(dentry));
+	SiMustWriteLock(sb);
+	root = sb->s_root;
+	DiMustWriteLock(root);
+	root_inode = root->d_inode;
+	IMustLock(root_inode);
+	IiMustWriteLock(root_inode);
+
+	err = test_add(sb, add, remount);
+	if (unlikely(err < 0))
+		goto out;
+	if (err)
+		return 0; /* success */
+
+	bend = au_sbend(sb);
+	add_branch = alloc_addbr(sb, bend + 2);
+	err = PTR_ERR(add_branch);
+	if (IS_ERR(add_branch))
+		goto out;
+	err = au_br_init(add_branch, sb, add);
+	if (unlikely(err)) {
+		kfree(add_branch);
+		goto out;
+	}
+
+	add_bindex = add->bindex;
+	if (remount)
+		sysaufs_brs_del(sb, add_bindex);
+
+	sbinfo = au_sbi(sb);
+	dinfo = au_di(root);
+	iinfo = au_ii(root_inode);
+
+	amount = bend + 1 - add_bindex;
+	branchp = sbinfo->si_branch + add_bindex;
+	memmove(branchp + 1, branchp, sizeof(*branchp) * amount);
+	*branchp = add_branch;
+	hdentryp = dinfo->di_hdentry + add_bindex;
+	memmove(hdentryp + 1, hdentryp, sizeof(*hdentryp) * amount);
+	au_h_dentry_init(hdentryp);
+	hinodep = iinfo->ii_hinode + add_bindex;
+	memmove(hinodep + 1, hinodep, sizeof(*hinodep) * amount);
+	hinodep->hi_inode = NULL;
+	au_hin_init(hinodep, NULL);
+
+	sbinfo->si_bend++;
+	dinfo->di_bend++;
+	iinfo->ii_bend++;
+	if (unlikely(bend < 0)) {
+		sbinfo->si_bend = 0;
+		dinfo->di_bstart = 0;
+		iinfo->ii_bstart = 0;
+	}
+	inode = dentry->d_inode;
+	au_set_h_dptr(root, add_bindex, dget(dentry));
+	au_set_h_iptr(root_inode, add_bindex, igrab(inode), 0);
+	if (remount)
+		sysaufs_brs_add(sb, add_bindex);
+
+	if (!add_bindex)
+		au_cpup_attr_all(root_inode);
+	else
+		au_add_nlink(root_inode, inode);
+	maxb = dentry->d_sb->s_maxbytes;
+	if (sb->s_maxbytes < maxb)
+		sb->s_maxbytes = maxb;
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+#define AuVerbose(do_info, fmt, args...) do { \
+	if (!do_info) \
+		LKTRTrace(fmt, ##args); \
+	else \
+		AuInfo(fmt, ##args); \
+} while (0)
+
+/*
+ * test if the branch is deletable or not.
+ */
+static int test_dentry_busy(struct dentry *root, aufs_bindex_t bindex,
+			    au_gen_t sigen)
+{
+	int err, i, j, ndentry, verbose;
+	struct au_dcsub_pages dpages;
+	struct au_dpage *dpage;
+	struct dentry *d;
+	aufs_bindex_t bstart, bend;
+	struct inode *inode;
+
+	LKTRTrace("b%d, gen%d\n", bindex, sigen);
+	SiMustWriteLock(root->d_sb);
+
+	err = au_dpages_init(&dpages, GFP_TEMPORARY);
+	if (unlikely(err))
+		goto out;
+	err = au_dcsub_pages(&dpages, root, NULL, NULL);
+	if (unlikely(err))
+		goto out_dpages;
+
+	verbose = !!au_opt_test(au_mntflags(root->d_sb), VERBOSE);
+	for (i = 0; !err && i < dpages.ndpage; i++) {
+		dpage = dpages.dpages + i;
+		ndentry = dpage->ndentry;
+		for (j = 0; !err && j < ndentry; j++) {
+			d = dpage->dentries[j];
+			AuDebugOn(!atomic_read(&d->d_count));
+			inode = d->d_inode;
+			AuDebugOn(!inode);
+			if (au_digen(d) == sigen
+			    && au_iigen(inode) == sigen)
+				di_read_lock_child(d, AuLock_IR);
+			else {
+				di_write_lock_child(d);
+				err = au_reval_dpath(d, sigen);
+				if (!err)
+					di_downgrade_lock(d, AuLock_IR);
+				else {
+					di_write_unlock(d);
+					break;
+				}
+			}
+
+			bstart = au_dbstart(d);
+			bend = au_dbend(d);
+			if (bstart <= bindex
+			    && bindex <= bend
+			    && au_h_dptr(d, bindex)
+			    && (!S_ISDIR(d->d_inode->i_mode)
+				|| bstart == bend)) {
+				err = -EBUSY;
+				AuVerbose(verbose, "busy %.*s\n", AuDLNPair(d));
+			}
+			di_read_unlock(d, AuLock_IR);
+		}
+	}
+
+ out_dpages:
+	au_dpages_free(&dpages);
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+static int test_inode_busy(struct super_block *sb, aufs_bindex_t bindex,
+			   au_gen_t sigen)
+{
+	int err, verbose;
+	struct inode *i;
+	aufs_bindex_t bstart, bend;
+
+	LKTRTrace("b%d, gen%d\n", bindex, sigen);
+	SiMustWriteLock(sb);
+
+	err = 0;
+	verbose = !!au_opt_test(au_mntflags(sb), VERBOSE);
+	list_for_each_entry(i, &sb->s_inodes, i_sb_list) {
+		AuDebugOn(!atomic_read(&i->i_count));
+		if (!list_empty(&i->i_dentry))
+			continue;
+
+		if (au_iigen(i) == sigen)
+			ii_read_lock_child(i);
+		else {
+			ii_write_lock_child(i);
+			err = au_refresh_hinode_self(i);
+			if (!err)
+				ii_downgrade_lock(i);
+			else {
+				ii_write_unlock(i);
+				break;
+			}
+		}
+
+		bstart = au_ibstart(i);
+		bend = au_ibend(i);
+		if (bstart <= bindex
+		    && bindex <= bend
+		    && au_h_iptr(i, bindex)
+		    && (!S_ISDIR(i->i_mode) || bstart == bend)) {
+			err = -EBUSY;
+			AuVerbose(verbose, "busy i%lu\n", i->i_ino);
+			ii_read_unlock(i);
+			break;
+		}
+		ii_read_unlock(i);
+	}
+
+	AuTraceErr(err);
+	return err;
+}
+
+static int test_children_busy(struct dentry *root, aufs_bindex_t bindex)
+{
+	int err;
+	au_gen_t sigen;
+
+	LKTRTrace("b%d\n", bindex);
+	SiMustWriteLock(root->d_sb);
+	DiMustWriteLock(root);
+	/* dont trust BKL */
+	AuDebugOn(!kernel_locked());
+
+	sigen = au_sigen(root->d_sb);
+	DiMustNoWaiters(root);
+	IiMustNoWaiters(root->d_inode);
+	di_write_unlock(root);
+	err = test_dentry_busy(root, bindex, sigen);
+	if (!err)
+		err = test_inode_busy(root->d_sb, bindex, sigen);
+	di_write_lock_child(root); /* aufs_write_lock() calls ..._child() */
+
+	AuTraceErr(err);
+	return err;
+}
+
+int au_br_del(struct super_block *sb, struct au_opt_del *del, int remount)
+{
+	int err, do_wh, rerr, verbose;
+	struct dentry *root;
+	struct inode *inode, *hidden_dir;
+	aufs_bindex_t bindex, bend, br_id;
+	struct au_sbinfo *sbinfo;
+	struct au_dinfo *dinfo;
+	struct au_iinfo *iinfo;
+	struct au_branch *br;
+	unsigned int mnt_flags;
+
+	LKTRTrace("%s, %.*s\n", del->path, AuDLNPair(del->h_root));
+	SiMustWriteLock(sb);
+	root = sb->s_root;
+	DiMustWriteLock(root);
+	inode = root->d_inode;
+	IiMustWriteLock(inode);
+
+	err = 0;
+	bindex = au_find_dbindex(root, del->h_root);
+	if (bindex < 0) {
+		if (remount)
+			goto out; /* success */
+		err = -ENOENT;
+		AuErr("%s no such branch\n", del->path);
+		goto out;
+	}
+	LKTRTrace("bindex b%d\n", bindex);
+
+	err = -EBUSY;
+	mnt_flags = au_mntflags(sb);
+	verbose = au_opt_test(mnt_flags, VERBOSE);
+	bend = au_sbend(sb);
+	if (unlikely(!bend)) {
+		AuVerbose(verbose, "no more branches left\n");
+		goto out;
+	}
+	br = au_sbr(sb, bindex);
+	if (unlikely(au_br_count(br))) {
+		AuVerbose(verbose, "%d file(s) opened\n", au_br_count(br));
+		goto out;
+	}
+
+	do_wh = 0;
+	hidden_dir = del->h_root->d_inode;
+	if (br->br_wh || br->br_plink) {
+#if 0 /* reserved for future use */
+		/* remove whiteout base */
+		err = init_br_wh(sb, bindex, br, AuBr_RO, del->h_root,
+				 br->br_mnt);
+		if (unlikely(err))
+			goto out;
+#else
+		dput(br->br_wh);
+		dput(br->br_plink);
+		br->br_plink = NULL;
+		br->br_wh = NULL;
+#endif
+		do_wh = 1;
+	}
+
+	err = test_children_busy(root, bindex);
+	if (unlikely(err)) {
+		if (unlikely(do_wh))
+			goto out_wh;
+		goto out;
+	}
+
+	err = 0;
+	if (remount)
+		sysaufs_brs_del(sb, bindex);
+	sbinfo = au_sbi(sb);
+	dinfo = au_di(root);
+	iinfo = au_ii(inode);
+
+	dput(au_h_dptr(root, bindex));
+	au_hiput(iinfo->ii_hinode + bindex);
+	br_id = br->br_id;
+	free_branch(br);
+
+	/* todo: realloc and shrink memory? */
+	if (bindex < bend) {
+		const aufs_bindex_t n = bend - bindex;
+		struct au_branch **brp;
+		struct au_hdentry *hdp;
+		struct au_hinode *hip;
+
+		brp = sbinfo->si_branch + bindex;
+		memmove(brp, brp + 1, sizeof(*brp) * n);
+		hdp = dinfo->di_hdentry + bindex;
+		memmove(hdp, hdp + 1, sizeof(*hdp) * n);
+		hip = iinfo->ii_hinode + bindex;
+		memmove(hip, hip + 1, sizeof(*hip) * n);
+	}
+	sbinfo->si_branch[0 + bend] = NULL;
+	dinfo->di_hdentry[0 + bend].hd_dentry = NULL;
+	iinfo->ii_hinode[0 + bend].hi_inode = NULL;
+	au_hin_init(iinfo->ii_hinode + bend, NULL);
+
+	sbinfo->si_bend--;
+	dinfo->di_bend--;
+	iinfo->ii_bend--;
+	if (remount)
+		sysaufs_brs_add(sb, bindex);
+
+	if (!bindex)
+		au_cpup_attr_all(inode);
+	else
+		au_sub_nlink(inode, del->h_root->d_inode);
+	if (au_opt_test(mnt_flags, PLINK))
+		au_plink_half_refresh(sb, br_id);
+
+	if (sb->s_maxbytes == del->h_root->d_sb->s_maxbytes) {
+		bend--;
+		sb->s_maxbytes = 0;
+		for (bindex = 0; bindex <= bend; bindex++) {
+			unsigned long long maxb;
+			maxb = au_sbr_sb(sb, bindex)->s_maxbytes;
+			if (sb->s_maxbytes < maxb)
+				sb->s_maxbytes = maxb;
+		}
+	}
+	goto out; /* success */
+
+ out_wh:
+	/* revert */
+	rerr = init_br_wh(sb, bindex, br, br->br_perm, del->h_root, br->br_mnt);
+	if (rerr)
+		AuWarn("failed re-creating base whiteout, %s. (%d)\n",
+		       del->path, rerr);
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+static int do_need_sigen_inc(int a, int b)
+{
+	return (au_br_whable(a) && !au_br_whable(b));
+}
+
+static int need_sigen_inc(int old, int new)
+{
+	return (do_need_sigen_inc(old, new)
+		|| do_need_sigen_inc(new, old));
+}
+
+int au_br_mod(struct super_block *sb, struct au_opt_mod *mod, int remount,
+	      int *do_update)
+{
+	int err;
+	struct dentry *root;
+	aufs_bindex_t bindex;
+	struct au_branch *br;
+	struct inode *hidden_dir;
+
+	LKTRTrace("%s, %.*s, 0x%x\n",
+		  mod->path, AuDLNPair(mod->h_root), mod->perm);
+	SiMustWriteLock(sb);
+	root = sb->s_root;
+	DiMustWriteLock(root);
+	IiMustWriteLock(root->d_inode);
+
+	bindex = au_find_dbindex(root, mod->h_root);
+	if (bindex < 0) {
+		if (remount)
+			return 0; /* success */
+		err = -ENOENT;
+		AuErr("%s no such branch\n", mod->path);
+		goto out;
+	}
+	LKTRTrace("bindex b%d\n", bindex);
+
+	hidden_dir = mod->h_root->d_inode;
+	err = test_br(sb, hidden_dir, mod->perm, mod->path);
+	if (unlikely(err))
+		goto out;
+
+	br = au_sbr(sb, bindex);
+	if (br->br_perm == mod->perm)
+		return 0; /* success */
+
+	if (au_br_writable(br->br_perm)) {
+#if 1
+		/* remove whiteout base */
+		/* todo: mod->perm? */
+		err = init_br_wh(sb, bindex, br, AuBr_RO, mod->h_root,
+				 br->br_mnt);
+		if (unlikely(err))
+			goto out;
+#else /* reserved for future use */
+		dput(br->br_wh);
+		dput(br->br_plink);
+		br->br_plink = NULL;
+		br->br_wh = NULL;
+#endif
+
+		if (!au_br_writable(mod->perm)) {
+			/* rw --> ro, file might be mmapped */
+			struct file *file, *hf;
+
+#if 1 /* todo: test more? */
+			DiMustNoWaiters(root);
+			IiMustNoWaiters(root->d_inode);
+			di_write_unlock(root);
+
+			/*
+			 * no need file_list_lock()
+			 * since BKL (and sbinfo) is locked
+			 */
+			AuDebugOn(!kernel_locked());
+			list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
+				LKTRTrace("%.*s\n", AuDLNPair(file->f_dentry));
+				if (!au_test_aufs_file(file))
+					continue;
+
+				fi_read_lock(file);
+				if (!S_ISREG(file->f_dentry->d_inode->i_mode)
+				    || !(file->f_mode & FMODE_WRITE)
+				    || au_fbstart(file) != bindex) {
+					FiMustNoWaiters(file);
+					fi_read_unlock(file);
+					continue;
+				}
+
+				if (unlikely(au_test_mmapped(file))) {
+					err = -EBUSY;
+					FiMustNoWaiters(file);
+					fi_read_unlock(file);
+					break;
+				}
+
+				/* todo: already flushed? */
+				hf = au_h_fptr(file, au_fbstart(file));
+				hf->f_flags = au_file_roflags(hf->f_flags);
+				hf->f_mode &= ~FMODE_WRITE;
+				put_write_access(hf->f_dentry->d_inode);
+				FiMustNoWaiters(file);
+				fi_read_unlock(file);
+			}
+
+			/* aufs_write_lock() calls ..._child() */
+			di_write_lock_child(root);
+#endif
+		}
+	}
+
+	if (!err) {
+		*do_update |= need_sigen_inc(br->br_perm, mod->perm);
+		br->br_perm = mod->perm;
+	}
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
diff --git a/fs/aufs/branch.h b/fs/aufs/branch.h
new file mode 100644
index 0000000..6e4a9aa
--- /dev/null
+++ b/fs/aufs/branch.h
@@ -0,0 +1,352 @@
+/*
+ * Copyright (C) 2005-2008 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * branch filesystems and xino for them
+ */
+
+#ifndef __AUFS_BRANCH_H__
+#define __AUFS_BRANCH_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/sysfs.h>
+#include <linux/aufs_type.h>
+#include "misc.h"
+#include "super.h"
+
+/* ---------------------------------------------------------------------- */
+
+/* an entry in a xino file */
+struct au_xino_entry {
+	ino_t ino;
+	/* __u32 h_gen; */ /* reserved for future use */
+} __packed;
+
+/* reserved for future use */
+/* #define AuXino_INVALID_HGEN	(-1) */
+
+/* a xino file */
+struct au_xino_file {
+	struct file		*xi_file;
+
+	/* reserved for future use */
+#if 0
+	struct file		**xi_file;
+
+	/* array management */
+	unsigned long long	xi_limit;	/* Max xino file size */
+	unsigned long long	xi_size;	 /* s_maxbytes */
+
+	/* truncation */
+	u64			xi_upper;	/* watermark in bytes */
+	u64			xi_step;	/* to next watermark in bytes */
+#endif
+
+	/* truncation */
+	blkcnt_t		xi_upper;	/* watermark in blocks */
+	atomic_t 		xi_running;
+};
+
+/* protected by superblock rwsem */
+struct au_branch {
+	struct file		*br_xino;
+#if 0 /* reserved for future use */
+	struct au_xino_file		*br_xino;
+#endif
+
+	aufs_bindex_t		br_id;
+
+	int			br_perm;
+	struct vfsmount		*br_mnt;
+	atomic_t		br_count;
+
+	/* whiteout base */
+	struct au_rwsem		br_wh_rwsem;
+	struct dentry		*br_wh;
+	atomic_t 		br_wh_running;
+
+	/* pseudo-link dir */
+	struct dentry		*br_plink;
+
+#if 1 /* reserved for future use */
+	/* xino truncation */
+	blkcnt_t		br_xino_upper;	/* watermark in blocks */
+	atomic_t		br_xino_running;
+#endif
+
+	/* mfs mode */
+	u64			br_bytes;
+
+#ifdef CONFIG_SYSFS
+	/* an entry under sysfs per mount-point */
+	char			br_name[8];
+	struct attribute	br_attr;
+#endif
+
+	au_gen_t		br_generation;
+};
+
+/* ---------------------------------------------------------------------- */
+
+/* branch permission and attribute */
+enum {
+	AuBr_RW,		/* writable, linkable wh */
+	AuBr_RO,		/* readonly, no wh */
+	AuBr_RR,		/* natively readonly, no wh */
+
+	AuBr_RWNoLinkWH,	/* un-linkable whiteouts */
+
+	AuBr_ROWH,
+	AuBr_RRWH,		/* whiteout-able */
+
+	AuBr_Last
+};
+
+static inline int au_br_writable(int brperm)
+{
+	return (brperm == AuBr_RW || brperm == AuBr_RWNoLinkWH);
+}
+
+static inline int au_br_whable(int brperm)
+{
+	return (brperm == AuBr_RW
+		|| brperm == AuBr_ROWH
+		|| brperm == AuBr_RRWH);
+}
+
+#if 0 /* reserved for future use */
+static inline int au_br_linkable_wh(int brperm)
+{
+	return (brperm == AuBr_RW);
+}
+#endif
+
+static inline int au_br_hinotifyable(int brperm)
+{
+#ifdef CONFIG_AUFS_HINOTIFY
+	return (brperm != AuBr_RR && brperm != AuBr_RRWH);
+#else
+	return 0;
+#endif
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* branch.c */
+struct au_sbinfo;
+void au_br_free(struct au_sbinfo *sinfo);
+int au_test_def_rr(struct super_block *h_sb);
+int au_br_index(struct super_block *sb, aufs_bindex_t br_id);
+struct au_opt_add;
+int au_br_add(struct super_block *sb, struct au_opt_add *add, int remount);
+struct au_opt_del;
+int au_br_del(struct super_block *sb, struct au_opt_del *del, int remount);
+struct au_opt_mod;
+int au_br_mod(struct super_block *sb, struct au_opt_mod *mod, int remount,
+	      int *do_update);
+
+/* xino.c */
+int au_xib_trunc(struct super_block *sb);
+
+struct file *au_xino_create(struct super_block *sb, char *fname, int silent,
+			    struct dentry *parent);
+ino_t au_xino_new_ino(struct super_block *sb);
+int au_xino_write0(struct super_block *sb, aufs_bindex_t bindex, ino_t h_ino,
+		   ino_t ino);
+int au_xino_write(struct super_block *sb, aufs_bindex_t bindex, ino_t h_ino,
+		  struct au_xino_entry *xinoe);
+int au_xino_read(struct super_block *sb, aufs_bindex_t bindex, ino_t h_ino,
+		 struct au_xino_entry *xinoe);
+int au_xino_br(struct super_block *sb, struct au_branch *br, ino_t hino,
+	       struct file *base_file, int do_test);
+int au_xino_trunc(struct super_block *sb, aufs_bindex_t bindex);
+
+struct au_opt_xino;
+int au_xino_set(struct super_block *sb, struct au_opt_xino *xino, int remount);
+void au_xino_clr(struct super_block *sb);
+struct file *au_xino_def(struct super_block *sb);
+
+/* ---------------------------------------------------------------------- */
+
+/* todo: memory barrier? */
+static inline int au_br_count(struct au_branch *br)
+{
+	return atomic_read(&br->br_count);
+}
+
+static inline int au_br_get(struct au_branch *br)
+{
+	return atomic_inc_return(&br->br_count);
+}
+
+static inline int au_br_put(struct au_branch *br)
+{
+	return atomic_dec_return(&br->br_count);
+}
+
+static inline au_gen_t au_br_gen(struct au_branch *br)
+{
+	return br->br_generation;
+}
+
+/*
+ * test if the @br is readonly or not.
+ */
+static inline int au_br_rdonly(struct au_branch *br)
+{
+	return ((br->br_mnt->mnt_sb->s_flags & MS_RDONLY)
+		|| !au_br_writable(br->br_perm))
+		? -EROFS : 0;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* Superblock to branch */
+static inline
+aufs_bindex_t au_sbr_id(struct super_block *sb, aufs_bindex_t bindex)
+{
+	return au_sbr(sb, bindex)->br_id;
+}
+
+static inline
+struct vfsmount *au_sbr_mnt(struct super_block *sb, aufs_bindex_t bindex)
+{
+	return au_sbr(sb, bindex)->br_mnt;
+}
+
+static inline
+struct super_block *au_sbr_sb(struct super_block *sb, aufs_bindex_t bindex)
+{
+	return au_sbr_mnt(sb, bindex)->mnt_sb;
+}
+
+#if 0 /* reserved for future use */
+static inline int au_sbr_count(struct super_block *sb, aufs_bindex_t bindex)
+{
+	return au_br_count(au_sbr(sb, bindex));
+}
+
+static inline void au_sbr_get(struct super_block *sb, aufs_bindex_t bindex)
+{
+	au_br_get(au_sbr(sb, bindex));
+}
+#endif
+
+static inline void au_sbr_put(struct super_block *sb, aufs_bindex_t bindex)
+{
+	au_br_put(au_sbr(sb, bindex));
+}
+
+static inline int au_sbr_perm(struct super_block *sb, aufs_bindex_t bindex)
+{
+	return au_sbr(sb, bindex)->br_perm;
+}
+
+static inline int au_sbr_whable(struct super_block *sb, aufs_bindex_t bindex)
+{
+	return au_br_whable(au_sbr_perm(sb, bindex));
+}
+
+static inline int au_test_trunc_xino(struct super_block *sb)
+{
+	return au_test_tmpfs(sb);
+}
+
+/* temporary support for i#1 in cramfs */
+static inline int au_test_unique_ino(struct dentry *h_dentry, ino_t h_ino)
+{
+#if defined(CONFIG_CRAMFS) || defined(CONFIG_CRAMFS_MODULE)
+	if (unlikely(h_dentry->d_sb->s_magic == CRAMFS_MAGIC))
+		return (h_ino != 1);
+#endif
+	return 1;
+}
+
+#ifdef CONFIG_AUFS_BR_NFS
+static inline int au_test_unsupported_nfs(struct super_block *h_sb)
+{
+	return 0;
+}
+
+static inline struct vfsmount *au_do_nfsmnt(struct vfsmount *h_mnt)
+{
+	if (!au_test_nfs(h_mnt->mnt_sb))
+		return NULL;
+	return h_mnt;
+}
+
+/* it doesn't mntget() */
+static inline
+struct vfsmount *au_nfsmnt(struct super_block *sb, aufs_bindex_t bindex)
+{
+	return au_do_nfsmnt(au_sbr_mnt(sb, bindex));
+}
+
+#define AuNoNfsBranchMsg "dummy"
+
+#else
+static inline int au_test_unsupported_nfs(struct super_block *h_sb)
+{
+	return au_test_nfs(h_sb);
+}
+
+static inline struct vfsmount *au_do_nfsmnt(struct vfsmount *h_mnt)
+{
+	return NULL;
+}
+
+static inline
+struct vfsmount *au_nfsmnt(struct super_block *sb, aufs_bindex_t bindex)
+{
+	return NULL;
+}
+
+#define AuNoNfsBranchMsg "NFS branch is not supported" \
+	", try some configurations and patches included in aufs source CVS."
+
+#endif /* CONFIG_AUFS_BR_NFS */
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * br_wh_read_lock, br_wh_write_lock
+ * br_wh_read_unlock, br_wh_write_unlock, br_wh_downgrade_lock
+ */
+AuSimpleRwsemFuncs(br_wh, struct au_branch *br, br->br_wh_rwsem);
+
+/* to debug easier, do not make them inlined functions */
+#define BrWhMustReadLock(br) do { \
+	/* SiMustAnyLock(sb); */ \
+	AuRwMustReadLock(&(br)->br_wh_rwsem); \
+} while (0)
+
+#define BrWhMustWriteLock(br) do { \
+	/* SiMustAnyLock(sb); */ \
+	AuRwMustWriteLock(&(br)->br_wh_rwsem); \
+} while (0)
+
+#define BrWhMustAnyLock(br) do { \
+	/* SiMustAnyLock(sb); */ \
+	AuRwMustAnyLock(&(br)->br_wh_rwsem); \
+} while (0)
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_BRANCH_H__ */
-- 
1.5.5.1.308.g1fbb5.dirty

