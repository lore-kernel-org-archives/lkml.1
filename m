Return-Path: <linux-kernel-owner+w=401wt.eu-S938124AbZDJHdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938124AbZDJHdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938416AbZDJHXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:23:52 -0400
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:62081 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938366AbZDJHXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:23:41 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 18/29] aufs inode
Date: Fri, 10 Apr 2009 16:02:32 +0900
Message-Id: <1239346963-30953-19-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
inode operations and private data

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/i_op.c     |  859 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/i_op_add.c |  625 +++++++++++++++++++++++++++++++++++
 fs/aufs/i_op_del.c |  471 ++++++++++++++++++++++++++
 fs/aufs/i_op_ren.c |  929 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/iinfo.c    |  257 +++++++++++++++
 fs/aufs/inode.c    |  356 ++++++++++++++++++++
 fs/aufs/inode.h    |  471 ++++++++++++++++++++++++++
 7 files changed, 3968 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/i_op.c
 create mode 100644 fs/aufs/i_op_add.c
 create mode 100644 fs/aufs/i_op_del.c
 create mode 100644 fs/aufs/i_op_ren.c
 create mode 100644 fs/aufs/iinfo.c
 create mode 100644 fs/aufs/inode.c
 create mode 100644 fs/aufs/inode.h

diff --git a/fs/aufs/i_op.c b/fs/aufs/i_op.c
new file mode 100644
index 0000000..8abf047
--- /dev/null
+++ b/fs/aufs/i_op.c
@@ -0,0 +1,859 @@
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
+ * inode operations (except add/del/rename)
+ */
+
+#include <linux/device_cgroup.h>
+#include <linux/fs_stack.h>
+#include <linux/uaccess.h>
+#include "aufs.h"
+
+static int h_permission(struct inode *h_inode, int mask,
+			struct vfsmount *h_mnt, int brperm)
+{
+	int err;
+	const unsigned char write_mask = !!(mask & (MAY_WRITE | MAY_APPEND));
+
+	err = -EACCES;
+	if ((write_mask && IS_IMMUTABLE(h_inode))
+	    || ((mask & MAY_EXEC)
+		&& S_ISREG(h_inode->i_mode)
+		&& ((h_mnt->mnt_flags & MNT_NOEXEC)
+		    || !(h_inode->i_mode & S_IXUGO))))
+		goto out;
+
+	/*
+	 * - skip the lower fs test in the case of write to ro branch.
+	 * - nfs dir permission write check is optimized, but a policy for
+	 *   link/rename requires a real check.
+	 */
+	if ((write_mask && !au_br_writable(brperm))
+	    || (au_test_nfs(h_inode->i_sb) && S_ISDIR(h_inode->i_mode)
+		&& write_mask && !(mask & MAY_READ))
+	    || !h_inode->i_op->permission) {
+		/* AuLabel(generic_permission); */
+		err = generic_permission(h_inode, mask, NULL);
+	} else {
+		/* AuLabel(h_inode->permission); */
+		err = h_inode->i_op->permission(h_inode, mask);
+		AuTraceErr(err);
+	}
+
+	if (!err)
+		err = devcgroup_inode_permission(h_inode, mask);
+	if (!err)
+		err = security_inode_permission
+			(h_inode, mask & (MAY_READ | MAY_WRITE | MAY_EXEC
+					  | MAY_APPEND));
+
+	/* todo: do we need to call ima_path_check()? */
+
+ out:
+	return err;
+}
+
+static int aufs_permission(struct inode *inode, int mask)
+{
+	int err;
+	aufs_bindex_t bindex, bend;
+	const unsigned char isdir = !!S_ISDIR(inode->i_mode);
+	const unsigned char write_mask = !!(mask & (MAY_WRITE | MAY_APPEND));
+	struct inode *h_inode;
+	struct super_block *sb;
+	struct au_branch *br;
+
+	sb = inode->i_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+	ii_read_lock_child(inode);
+
+	if (!isdir || write_mask) {
+		h_inode = au_h_iptr(inode, au_ibstart(inode));
+		AuDebugOn(!h_inode
+			  || ((h_inode->i_mode & S_IFMT)
+			      != (inode->i_mode & S_IFMT)));
+		err = 0;
+		bindex = au_ibstart(inode);
+		br = au_sbr(sb, bindex);
+		err = h_permission(h_inode, mask, br->br_mnt, br->br_perm);
+
+		if (write_mask && !err) {
+			/* test whether the upper writable branch exists */
+			err = -EROFS;
+			for (; bindex >= 0; bindex--)
+				if (!au_br_rdonly(au_sbr(sb, bindex))) {
+					err = 0;
+					break;
+				}
+		}
+		goto out;
+	}
+
+	/* non-write to dir */
+	err = 0;
+	bend = au_ibend(inode);
+	for (bindex = au_ibstart(inode); !err && bindex <= bend; bindex++) {
+		h_inode = au_h_iptr(inode, bindex);
+		if (h_inode) {
+			AuDebugOn(!S_ISDIR(h_inode->i_mode));
+			br = au_sbr(sb, bindex);
+			err = h_permission(h_inode, mask, br->br_mnt,
+					   br->br_perm);
+		}
+	}
+
+ out:
+	ii_read_unlock(inode);
+	si_read_unlock(sb);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static struct dentry *aufs_lookup(struct inode *dir, struct dentry *dentry,
+				  struct nameidata *nd)
+{
+	struct dentry *ret, *parent;
+	struct inode *inode, *h_inode;
+	struct mutex *mtx;
+	struct super_block *sb;
+	int err, npositive;
+	aufs_bindex_t bstart;
+
+	IMustLock(dir);
+
+	sb = dir->i_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+	err = au_alloc_dinfo(dentry);
+	ret = ERR_PTR(err);
+	if (unlikely(err))
+		goto out;
+
+	parent = dentry->d_parent; /* dir inode is locked */
+	di_read_lock_parent(parent, AuLock_IR);
+	npositive = au_lkup_dentry(dentry, au_dbstart(parent), /*type*/0, nd);
+	di_read_unlock(parent, AuLock_IR);
+	err = npositive;
+	ret = ERR_PTR(err);
+	if (unlikely(err < 0))
+		goto out_unlock;
+
+	inode = NULL;
+	if (npositive) {
+		bstart = au_dbstart(dentry);
+		h_inode = au_h_dptr(dentry, bstart)->d_inode;
+		if (!S_ISDIR(h_inode->i_mode)) {
+			/*
+			 * stop 'race'-ing between hardlinks under different
+			 * parents.
+			 */
+			mtx = &au_sbr(sb, bstart)->br_xino.xi_nondir_mtx;
+			mutex_lock(mtx);
+			inode = au_new_inode(dentry, /*must_new*/0);
+			mutex_unlock(mtx);
+		} else
+			inode = au_new_inode(dentry, /*must_new*/0);
+		ret = (void *)inode;
+	}
+	if (IS_ERR(inode))
+		goto out_unlock;
+
+	ret = d_splice_alias(inode, dentry);
+	if (unlikely(IS_ERR(ret) && inode))
+		ii_write_unlock(inode);
+	au_store_oflag(nd, inode);
+
+ out_unlock:
+	di_write_unlock(dentry);
+ out:
+	si_read_unlock(sb);
+	return ret;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int au_wr_dir_cpup(struct dentry *dentry, struct dentry *parent,
+			  const unsigned char add_entry, aufs_bindex_t bcpup,
+			  aufs_bindex_t bstart)
+{
+	int err;
+	struct dentry *h_parent;
+	struct inode *h_dir;
+
+	if (add_entry) {
+		au_update_dbstart(dentry);
+		IMustLock(parent->d_inode);
+	} else
+		di_write_lock_parent(parent);
+
+	err = 0;
+	if (!au_h_dptr(parent, bcpup)) {
+		if (bstart < bcpup)
+			err = au_cpdown_dirs(dentry, bcpup);
+		else
+			err = au_cpup_dirs(dentry, bcpup);
+	}
+	if (!err && add_entry) {
+		h_parent = au_h_dptr(parent, bcpup);
+		h_dir = h_parent->d_inode;
+		mutex_lock_nested(&h_dir->i_mutex, AuLsc_I_PARENT);
+		err = au_lkup_neg(dentry, bcpup);
+		/* todo: no unlock here */
+		mutex_unlock(&h_dir->i_mutex);
+		if (bstart < bcpup && au_dbstart(dentry) < 0) {
+			au_set_dbstart(dentry, 0);
+			au_update_dbrange(dentry, /*do_put_zero*/0);
+		}
+	}
+
+	if (!add_entry)
+		di_write_unlock(parent);
+	if (!err)
+		err = bcpup; /* success */
+
+	return err;
+}
+
+/*
+ * decide the branch and the parent dir where we will create a new entry.
+ * returns new bindex or an error.
+ * copyup the parent dir if needed.
+ */
+int au_wr_dir(struct dentry *dentry, struct dentry *src_dentry,
+	      struct au_wr_dir_args *args)
+{
+	int err;
+	aufs_bindex_t bcpup, bstart, src_bstart;
+	const unsigned char add_entry = !!au_ftest_wrdir(args->flags,
+							 ADD_ENTRY);
+	struct super_block *sb;
+	struct dentry *parent;
+	struct au_sbinfo *sbinfo;
+
+	sb = dentry->d_sb;
+	sbinfo = au_sbi(sb);
+	parent = dget_parent(dentry);
+	bstart = au_dbstart(dentry);
+	bcpup = bstart;
+	if (args->force_btgt < 0) {
+		if (src_dentry) {
+			src_bstart = au_dbstart(src_dentry);
+			if (src_bstart < bstart)
+				bcpup = src_bstart;
+		} else if (add_entry) {
+			err = AuWbrCreate(sbinfo, dentry,
+					  au_ftest_wrdir(args->flags, ISDIR));
+			bcpup = err;
+		}
+
+		if (bcpup < 0 || au_test_ro(sb, bcpup, dentry->d_inode)) {
+			if (add_entry)
+				err = AuWbrCopyup(sbinfo, dentry);
+			else {
+				if (!IS_ROOT(dentry)) {
+					di_read_lock_parent(parent, !AuLock_IR);
+					err = AuWbrCopyup(sbinfo, dentry);
+					di_read_unlock(parent, !AuLock_IR);
+				} else
+					err = AuWbrCopyup(sbinfo, dentry);
+			}
+			bcpup = err;
+			if (unlikely(err < 0))
+				goto out;
+		}
+	} else {
+		bcpup = args->force_btgt;
+		AuDebugOn(au_test_ro(sb, bcpup, dentry->d_inode));
+	}
+	AuDbg("bstart %d, bcpup %d\n", bstart, bcpup);
+	if (bstart < bcpup)
+		au_update_dbrange(dentry, /*do_put_zero*/1);
+
+	err = bcpup;
+	if (bcpup == bstart)
+		goto out; /* success */
+
+	/* copyup the new parent into the branch we process */
+	err = au_wr_dir_cpup(dentry, parent, add_entry, bcpup, bstart);
+
+ out:
+	dput(parent);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct dentry *au_pinned_h_parent(struct au_pin *pin)
+{
+	if (pin && pin->parent)
+		return au_h_dptr(pin->parent, pin->bindex);
+	return NULL;
+}
+
+void au_unpin(struct au_pin *p)
+{
+	if (au_ftest_pin(p->flags, MNT_WRITE))
+		mnt_drop_write(p->h_mnt);
+	if (!p->hdir)
+		return;
+
+	au_hin_imtx_unlock(p->hdir);
+	if (!au_ftest_pin(p->flags, DI_LOCKED))
+		di_read_unlock(p->parent, AuLock_IR);
+	iput(p->hdir->hi_inode);
+	dput(p->parent);
+	p->parent = NULL;
+	p->hdir = NULL;
+	p->h_mnt = NULL;
+}
+
+int au_do_pin(struct au_pin *p)
+{
+	int err;
+	struct super_block *sb;
+	struct dentry *h_dentry, *h_parent;
+	struct au_branch *br;
+	struct inode *h_dir;
+
+	err = 0;
+	sb = p->dentry->d_sb;
+	br = au_sbr(sb, p->bindex);
+	if (IS_ROOT(p->dentry)) {
+		if (au_ftest_pin(p->flags, MNT_WRITE)) {
+			p->h_mnt = br->br_mnt;
+			err = mnt_want_write(p->h_mnt);
+			if (unlikely(err)) {
+				au_fclr_pin(p->flags, MNT_WRITE);
+				goto out_err;
+			}
+		}
+		goto out;
+	}
+
+	h_dentry = NULL;
+	if (p->bindex <= au_dbend(p->dentry))
+		h_dentry = au_h_dptr(p->dentry, p->bindex);
+
+	p->parent = dget_parent(p->dentry);
+	if (!au_ftest_pin(p->flags, DI_LOCKED))
+		di_read_lock(p->parent, AuLock_IR, p->lsc_di);
+
+	h_dir = NULL;
+	h_parent = au_h_dptr(p->parent, p->bindex);
+	p->hdir = au_hi(p->parent->d_inode, p->bindex);
+	if (p->hdir)
+		h_dir = p->hdir->hi_inode;
+
+	/* udba case */
+	if (unlikely(!p->hdir || !h_dir)) {
+		err = -EBUSY;
+		if (!au_ftest_pin(p->flags, DI_LOCKED))
+			di_read_unlock(p->parent, AuLock_IR);
+		dput(p->parent);
+		p->parent = NULL;
+		goto out_err;
+	}
+
+	au_igrab(h_dir);
+	au_hin_imtx_lock_nested(p->hdir, p->lsc_hi);
+
+	if (h_dentry) {
+		err = au_h_verify(h_dentry, p->udba, h_dir, h_parent, br);
+		if (unlikely(err)) {
+			au_fclr_pin(p->flags, MNT_WRITE);
+			goto out_unpin;
+		}
+	}
+
+	if (au_ftest_pin(p->flags, MNT_WRITE)) {
+		p->h_mnt = br->br_mnt;
+		err = mnt_want_write(p->h_mnt);
+		if (unlikely(err)) {
+			au_fclr_pin(p->flags, MNT_WRITE);
+			goto out_unpin;
+		}
+	}
+	goto out; /* success */
+
+ out_unpin:
+	au_unpin(p);
+ out_err:
+	AuErr("err %d\n", err);
+	err = -EBUSY;
+ out:
+	return err;
+}
+
+void au_pin_init(struct au_pin *p, struct dentry *dentry,
+		 aufs_bindex_t bindex, int lsc_di, int lsc_hi,
+		 unsigned int udba, unsigned char flags)
+{
+	p->dentry = dentry;
+	p->udba = udba;
+	p->lsc_di = lsc_di;
+	p->lsc_hi = lsc_hi;
+	p->flags = flags;
+	p->bindex = bindex;
+
+	p->parent = NULL;
+	p->hdir = NULL;
+	p->h_mnt = NULL;
+}
+
+int au_pin(struct au_pin *pin, struct dentry *dentry, aufs_bindex_t bindex,
+	   unsigned int udba, unsigned char flags)
+{
+	au_pin_init(pin, dentry, bindex, AuLsc_DI_PARENT, AuLsc_I_PARENT2,
+		    udba, flags);
+	return au_do_pin(pin);
+}
+
+/* ---------------------------------------------------------------------- */
+
+#define AuIcpup_DID_CPUP	1
+#define au_ftest_icpup(flags, name)	((flags) & AuIcpup_##name)
+#define au_fset_icpup(flags, name)	{ (flags) |= AuIcpup_##name; }
+#define au_fclr_icpup(flags, name)	{ (flags) &= ~AuIcpup_##name; }
+
+struct au_icpup_args {
+	unsigned char flags;
+	unsigned char pin_flags;
+	aufs_bindex_t btgt;
+	struct au_pin pin;
+	struct path h_path;
+	struct inode *h_inode;
+};
+
+static int au_lock_and_icpup(struct dentry *dentry, struct iattr *ia,
+			     struct au_icpup_args *a)
+{
+	int err;
+	unsigned int udba;
+	loff_t sz;
+	aufs_bindex_t bstart;
+	struct dentry *hi_wh, *parent;
+	struct inode *inode;
+	struct au_wr_dir_args wr_dir_args = {
+		.force_btgt	= -1,
+		.flags		= 0
+	};
+
+	di_write_lock_child(dentry);
+	bstart = au_dbstart(dentry);
+	inode = dentry->d_inode;
+	if (S_ISDIR(inode->i_mode))
+		au_fset_wrdir(wr_dir_args.flags, ISDIR);
+	/* plink or hi_wh() case */
+	if (bstart != au_ibstart(inode))
+		wr_dir_args.force_btgt = au_ibstart(inode);
+	err = au_wr_dir(dentry, /*src_dentry*/NULL, &wr_dir_args);
+	if (unlikely(err < 0))
+		goto out_dentry;
+	a->btgt = err;
+	if (err != bstart)
+		au_fset_icpup(a->flags, DID_CPUP);
+
+	err = 0;
+	a->pin_flags = AuPin_MNT_WRITE;
+	parent = NULL;
+	if (!IS_ROOT(dentry)) {
+		au_fset_pin(a->pin_flags, DI_LOCKED);
+		parent = dget_parent(dentry);
+		di_write_lock_parent(parent);
+	}
+
+	udba = au_opt_udba(dentry->d_sb);
+	if (d_unhashed(dentry) || (ia->ia_valid & ATTR_FILE))
+		udba = AuOpt_UDBA_NONE;
+	err = au_pin(&a->pin, dentry, a->btgt, udba, a->pin_flags);
+	if (unlikely(err)) {
+		if (parent) {
+			di_write_unlock(parent);
+			dput(parent);
+		}
+		goto out_dentry;
+	}
+	a->h_path.dentry = au_h_dptr(dentry, bstart);
+	a->h_inode = a->h_path.dentry->d_inode;
+	mutex_lock_nested(&a->h_inode->i_mutex, AuLsc_I_CHILD);
+	sz = -1;
+	if ((ia->ia_valid & ATTR_SIZE) && ia->ia_size < i_size_read(a->h_inode))
+		sz = ia->ia_size;
+
+	hi_wh = NULL;
+	if (au_ftest_icpup(a->flags, DID_CPUP) && d_unhashed(dentry)) {
+		hi_wh = au_hi_wh(inode, a->btgt);
+		if (!hi_wh) {
+			err = au_sio_cpup_wh(dentry, a->btgt, sz, /*file*/NULL);
+			if (unlikely(err))
+				goto out_unlock;
+			hi_wh = au_hi_wh(inode, a->btgt);
+			/* todo: revalidate hi_wh? */
+		}
+	}
+
+	if (parent) {
+		au_pin_set_parent_lflag(&a->pin, /*lflag*/0);
+		di_downgrade_lock(parent, AuLock_IR);
+		dput(parent);
+	}
+	if (!au_ftest_icpup(a->flags, DID_CPUP))
+		goto out; /* success */
+
+	if (!d_unhashed(dentry)) {
+		err = au_sio_cpup_simple(dentry, a->btgt, sz, AuCpup_DTIME);
+		if (!err)
+			a->h_path.dentry = au_h_dptr(dentry, a->btgt);
+	} else if (!hi_wh)
+		a->h_path.dentry = au_h_dptr(dentry, a->btgt);
+	else
+		a->h_path.dentry = hi_wh; /* do not dget here */
+
+ out_unlock:
+	mutex_unlock(&a->h_inode->i_mutex);
+	a->h_inode = a->h_path.dentry->d_inode;
+	if (!err) {
+		mutex_lock_nested(&a->h_inode->i_mutex, AuLsc_I_CHILD);
+		goto out; /* success */
+	}
+
+	au_unpin(&a->pin);
+
+ out_dentry:
+	di_write_unlock(dentry);
+ out:
+	return err;
+}
+
+static int aufs_setattr(struct dentry *dentry, struct iattr *ia)
+{
+	int err;
+	struct inode *inode;
+	struct super_block *sb;
+	struct file *file;
+	struct au_icpup_args *a;
+
+	err = -ENOMEM;
+	a = kzalloc(sizeof(*a), GFP_NOFS);
+	if (unlikely(!a))
+		goto out;
+
+	inode = dentry->d_inode;
+	IMustLock(inode);
+	sb = dentry->d_sb;
+	si_read_lock(sb, AuLock_FLUSH);
+
+	file = NULL;
+	if (ia->ia_valid & ATTR_FILE) {
+		/* currently ftruncate(2) only */
+		file = ia->ia_file;
+		fi_write_lock(file);
+		ia->ia_file = au_h_fptr(file, au_fbstart(file));
+	}
+
+	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		ia->ia_valid &= ~ATTR_MODE;
+
+	err = au_lock_and_icpup(dentry, ia, a);
+	if (unlikely(err < 0))
+		goto out_si;
+	if (au_ftest_icpup(a->flags, DID_CPUP)) {
+		ia->ia_file = NULL;
+		ia->ia_valid &= ~ATTR_FILE;
+	}
+
+	a->h_path.mnt = au_sbr_mnt(sb, a->btgt);
+	if (ia->ia_valid & ATTR_SIZE) {
+		struct file *f;
+
+		if (ia->ia_size < i_size_read(inode)) {
+			/* unmap only */
+			err = vmtruncate(inode, ia->ia_size);
+			if (unlikely(err))
+				goto out_unlock;
+		}
+
+		f = NULL;
+		if (ia->ia_valid & ATTR_FILE)
+			f = ia->ia_file;
+		mutex_unlock(&a->h_inode->i_mutex);
+		err = vfsub_trunc(&a->h_path, ia->ia_size, ia->ia_valid, f);
+		mutex_lock_nested(&a->h_inode->i_mutex, AuLsc_I_CHILD);
+	} else
+		err = vfsub_notify_change(&a->h_path, ia);
+	if (!err)
+		au_cpup_attr_changeable(inode);
+
+ out_unlock:
+	mutex_unlock(&a->h_inode->i_mutex);
+	au_unpin(&a->pin);
+	di_write_unlock(dentry);
+ out_si:
+	if (file) {
+		fi_write_unlock(file);
+		ia->ia_file = file;
+		ia->ia_valid |= ATTR_FILE;
+	}
+	si_read_unlock(sb);
+	kfree(a);
+ out:
+	return err;
+}
+
+static int au_getattr_lock_reval(struct dentry *dentry, unsigned int sigen)
+{
+	int err;
+	struct inode *inode;
+	struct dentry *parent;
+
+	err = 0;
+	inode = dentry->d_inode;
+	di_write_lock_child(dentry);
+	if (au_digen(dentry) != sigen || au_iigen(inode) != sigen) {
+		parent = dget_parent(dentry);
+		di_read_lock_parent(parent, AuLock_IR);
+		/* returns a number of positive dentries */
+		err = au_refresh_hdentry(dentry, inode->i_mode & S_IFMT);
+		if (err > 0)
+			err = au_refresh_hinode(inode, dentry);
+		di_read_unlock(parent, AuLock_IR);
+		dput(parent);
+		if (unlikely(!err))
+			err = -EIO;
+	}
+	di_downgrade_lock(dentry, AuLock_IR);
+
+	return err;
+}
+
+static void au_refresh_iattr(struct inode *inode, struct kstat *st,
+			     unsigned int nlink)
+{
+	inode->i_mode = st->mode;
+	inode->i_uid = st->uid;
+	inode->i_gid = st->gid;
+	inode->i_atime = st->atime;
+	inode->i_mtime = st->mtime;
+	inode->i_ctime = st->ctime;
+
+	au_cpup_attr_nlink(inode, /*force*/0);
+	if (S_ISDIR(inode->i_mode)) {
+		inode->i_nlink -= nlink;
+		inode->i_nlink += st->nlink;
+	}
+
+	spin_lock(&inode->i_lock);
+	inode->i_blocks = st->blocks;
+	i_size_write(inode, st->size);
+	spin_unlock(&inode->i_lock);
+}
+
+static int aufs_getattr(struct vfsmount *mnt __maybe_unused,
+			struct dentry *dentry, struct kstat *st)
+{
+	int err;
+	unsigned int mnt_flags;
+	aufs_bindex_t bindex;
+	unsigned char udba_none, positive, did_lock;
+	struct super_block *sb, *h_sb;
+	struct inode *inode;
+	struct vfsmount *h_mnt;
+	struct dentry *h_dentry;
+
+	err = 0;
+	did_lock = 0;
+	sb = dentry->d_sb;
+	inode = dentry->d_inode;
+	si_read_lock(sb, AuLock_FLUSH);
+	if (IS_ROOT(dentry)) {
+		/* lock free root dinfo */
+		h_dentry = dget(au_di(dentry)->di_hdentry->hd_dentry);
+		h_mnt = au_sbr_mnt(sb, 0);
+		goto getattr;
+	}
+
+	did_lock = 1;
+	mnt_flags = au_mntflags(sb);
+	udba_none = !!au_opt_test(mnt_flags, UDBA_NONE);
+
+	/* support fstat(2) */
+	if (!d_unhashed(dentry) && !udba_none) {
+		unsigned int sigen = au_sigen(sb);
+		if (au_digen(dentry) == sigen && au_iigen(inode) == sigen)
+			di_read_lock_child(dentry, AuLock_IR);
+		else {
+			err = au_getattr_lock_reval(dentry, sigen);
+			if (unlikely(err))
+				goto out;
+		}
+	} else
+		di_read_lock_child(dentry, AuLock_IR);
+
+	bindex = au_ibstart(inode);
+	h_mnt = au_sbr_mnt(sb, bindex);
+	h_sb = h_mnt->mnt_sb;
+	if (!au_test_fs_bad_iattr(h_sb) && udba_none)
+		goto out_fill; /* success */
+
+	if (au_dbstart(dentry) == bindex)
+		h_dentry = dget(au_h_dptr(dentry, bindex));
+	else if (au_opt_test(mnt_flags, PLINK) && au_plink_test(inode)) {
+		h_dentry = au_plink_lkup(inode, bindex);
+		if (IS_ERR(h_dentry))
+			goto out_fill; /* pretending success */
+	} else
+		/* illegally overlapped or something */
+		goto out_fill; /* pretending success */
+
+ getattr:
+	positive = !!h_dentry->d_inode;
+	if (positive)
+		err = vfs_getattr(h_mnt, h_dentry, st);
+	dput(h_dentry);
+	if (!err) {
+		if (positive)
+			au_refresh_iattr(inode, st, h_dentry->d_inode->i_nlink);
+		goto out_fill; /* success */
+	}
+	goto out;
+
+ out_fill:
+	generic_fillattr(inode, st);
+ out:
+	if (did_lock)
+		di_read_unlock(dentry, AuLock_IR);
+	si_read_unlock(sb);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int h_readlink(struct dentry *dentry, int bindex, char __user *buf,
+		      int bufsiz)
+{
+	int err;
+	struct super_block *sb;
+	struct dentry *h_dentry;
+
+	err = -EINVAL;
+	h_dentry = au_h_dptr(dentry, bindex);
+	if (unlikely(/* !h_dentry
+		     || !h_dentry->d_inode
+		     || !h_dentry->d_inode->i_op
+		     || */ !h_dentry->d_inode->i_op->readlink))
+		goto out;
+
+	err = security_inode_readlink(h_dentry);
+	if (unlikely(err))
+		goto out;
+
+	sb = dentry->d_sb;
+	if (!au_test_ro(sb, bindex, dentry->d_inode)) {
+		vfsub_touch_atime(au_sbr_mnt(sb, bindex), h_dentry);
+		fsstack_copy_attr_atime(dentry->d_inode, h_dentry->d_inode);
+	}
+	err = h_dentry->d_inode->i_op->readlink(h_dentry, buf, bufsiz);
+
+ out:
+	return err;
+}
+
+static int aufs_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
+{
+	int err;
+
+	aufs_read_lock(dentry, AuLock_IR);
+	err = h_readlink(dentry, au_dbstart(dentry), buf, bufsiz);
+	aufs_read_unlock(dentry, AuLock_IR);
+
+	return err;
+}
+
+static void *aufs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	int err;
+	char *buf;
+	mm_segment_t old_fs;
+
+	err = -ENOMEM;
+	buf = __getname();
+	if (unlikely(!buf))
+		goto out;
+
+	aufs_read_lock(dentry, AuLock_IR);
+	old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	err = h_readlink(dentry, au_dbstart(dentry), (char __user *)buf,
+			 PATH_MAX);
+	set_fs(old_fs);
+	aufs_read_unlock(dentry, AuLock_IR);
+
+	if (err >= 0) {
+		buf[err] = 0;
+		/* will be freed by put_link */
+		nd_set_link(nd, buf);
+		return NULL; /* success */
+	}
+	__putname(buf);
+
+ out:
+	path_put(&nd->path);
+	AuTraceErr(err);
+	return ERR_PTR(err);
+}
+
+static void aufs_put_link(struct dentry *dentry __maybe_unused,
+			  struct nameidata *nd, void *cookie __maybe_unused)
+{
+	__putname(nd_get_link(nd));
+}
+
+/* ---------------------------------------------------------------------- */
+
+static void aufs_truncate_range(struct inode *inode __maybe_unused,
+				loff_t start __maybe_unused,
+				loff_t end __maybe_unused)
+{
+	AuUnsupport();
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct inode_operations aufs_symlink_iop = {
+	.permission	= aufs_permission,
+	.setattr	= aufs_setattr,
+	.getattr	= aufs_getattr,
+	.readlink	= aufs_readlink,
+	.follow_link	= aufs_follow_link,
+	.put_link	= aufs_put_link
+};
+
+struct inode_operations aufs_dir_iop = {
+	.create		= aufs_create,
+	.lookup		= aufs_lookup,
+	.link		= aufs_link,
+	.unlink		= aufs_unlink,
+	.symlink	= aufs_symlink,
+	.mkdir		= aufs_mkdir,
+	.rmdir		= aufs_rmdir,
+	.mknod		= aufs_mknod,
+	.rename		= aufs_rename,
+
+	.permission	= aufs_permission,
+	.setattr	= aufs_setattr,
+	.getattr	= aufs_getattr
+};
+
+struct inode_operations aufs_iop = {
+	.permission	= aufs_permission,
+	.setattr	= aufs_setattr,
+	.getattr	= aufs_getattr,
+	.truncate_range	= aufs_truncate_range
+};
diff --git a/fs/aufs/i_op_add.c b/fs/aufs/i_op_add.c
new file mode 100644
index 0000000..516120d
--- /dev/null
+++ b/fs/aufs/i_op_add.c
@@ -0,0 +1,625 @@
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
+ * inode operations (add entry)
+ */
+
+#include "aufs.h"
+
+/*
+ * final procedure of adding a new entry, except link(2).
+ * remove whiteout, instantiate, copyup the parent dir's times and size
+ * and update version.
+ * if it failed, re-create the removed whiteout.
+ */
+static int epilog(struct inode *dir, aufs_bindex_t bindex,
+		  struct dentry *wh_dentry, struct dentry *dentry)
+{
+	int err, rerr;
+	aufs_bindex_t bwh;
+	struct path h_path;
+	struct inode *inode, *h_dir;
+	struct dentry *wh;
+
+	bwh = -1;
+	if (wh_dentry) {
+		h_dir = wh_dentry->d_parent->d_inode; /* dir inode is locked */
+		IMustLock(h_dir);
+		AuDebugOn(au_h_iptr(dir, bindex) != h_dir);
+		bwh = au_dbwh(dentry);
+		h_path.dentry = wh_dentry;
+		h_path.mnt = au_sbr_mnt(dir->i_sb, bindex);
+		err = au_wh_unlink_dentry(au_h_iptr(dir, bindex), &h_path,
+					  dentry);
+		if (unlikely(err))
+			goto out;
+	}
+
+	inode = au_new_inode(dentry, /*must_new*/1);
+	if (!IS_ERR(inode)) {
+		d_instantiate(dentry, inode);
+		dir = dentry->d_parent->d_inode; /* dir inode is locked */
+		IMustLock(dir);
+		if (au_ibstart(dir) == au_dbstart(dentry))
+			au_cpup_attr_timesizes(dir);
+		dir->i_version++;
+		return 0; /* success */
+	}
+
+	err = PTR_ERR(inode);
+	if (!wh_dentry)
+		goto out;
+
+	/* revert */
+	/* dir inode is locked */
+	wh = au_wh_create(dentry, bwh, wh_dentry->d_parent);
+	rerr = PTR_ERR(wh);
+	if (IS_ERR(wh)) {
+		AuIOErr("%.*s reverting whiteout failed(%d, %d)\n",
+			AuDLNPair(dentry), err, rerr);
+		err = -EIO;
+	} else
+		dput(wh);
+
+ out:
+	return err;
+}
+
+/*
+ * simple tests for the adding inode operations.
+ * following the checks in vfs, plus the parent-child relationship.
+ */
+int au_may_add(struct dentry *dentry, aufs_bindex_t bindex,
+	       struct dentry *h_parent, int isdir)
+{
+	int err;
+	umode_t h_mode;
+	struct dentry *h_dentry;
+	struct inode *h_inode;
+
+	h_dentry = au_h_dptr(dentry, bindex);
+	h_inode = h_dentry->d_inode;
+	if (!dentry->d_inode) {
+		err = -EEXIST;
+		if (unlikely(h_inode))
+			goto out;
+	} else {
+		/* rename(2) case */
+		err = -EIO;
+		if (unlikely(!h_inode || !h_inode->i_nlink))
+			goto out;
+
+		h_mode = h_inode->i_mode;
+		if (!isdir) {
+			err = -EISDIR;
+			if (unlikely(S_ISDIR(h_mode)))
+				goto out;
+		} else if (unlikely(!S_ISDIR(h_mode))) {
+			err = -ENOTDIR;
+			goto out;
+		}
+	}
+
+	err = -EIO;
+	/* expected parent dir is locked */
+	if (unlikely(h_parent != h_dentry->d_parent))
+		goto out;
+	err = 0;
+
+ out:
+	return err;
+}
+
+/*
+ * initial procedure of adding a new entry.
+ * prepare writable branch and the parent dir, lock it,
+ * and lookup whiteout for the new entry.
+ */
+static struct dentry*
+lock_hdir_lkup_wh(struct dentry *dentry, struct au_dtime *dt,
+		  struct dentry *src_dentry, struct au_pin *pin,
+		  struct au_wr_dir_args *wr_dir_args)
+{
+	struct dentry *wh_dentry, *h_parent;
+	struct super_block *sb;
+	struct au_branch *br;
+	int err;
+	unsigned int udba;
+	aufs_bindex_t bcpup;
+
+	err = au_wr_dir(dentry, src_dentry, wr_dir_args);
+	bcpup = err;
+	wh_dentry = ERR_PTR(err);
+	if (unlikely(err < 0))
+		goto out;
+
+	sb = dentry->d_sb;
+	udba = au_opt_udba(sb);
+	err = au_pin(pin, dentry, bcpup, udba,
+		     AuPin_DI_LOCKED | AuPin_MNT_WRITE);
+	wh_dentry = ERR_PTR(err);
+	if (unlikely(err))
+		goto out;
+
+	h_parent = au_pinned_h_parent(pin);
+	if (udba != AuOpt_UDBA_NONE
+	    && au_dbstart(dentry) == bcpup) {
+		err = au_may_add(dentry, bcpup, h_parent,
+				 au_ftest_wrdir(wr_dir_args->flags, ISDIR));
+		wh_dentry = ERR_PTR(err);
+		if (unlikely(err))
+			goto out_unpin;
+	}
+
+	br = au_sbr(sb, bcpup);
+	if (dt) {
+		struct path tmp = {
+			.dentry	= h_parent,
+			.mnt	= br->br_mnt
+		};
+		au_dtime_store(dt, au_pinned_parent(pin), &tmp);
+	}
+
+	wh_dentry = NULL;
+	if (bcpup != au_dbwh(dentry))
+		goto out; /* success */
+
+	wh_dentry = au_wh_lkup(h_parent, &dentry->d_name, br);
+
+ out_unpin:
+	if (IS_ERR(wh_dentry))
+		au_unpin(pin);
+ out:
+	return wh_dentry;
+}
+
+/* ---------------------------------------------------------------------- */
+
+enum { Mknod, Symlink, Creat };
+struct simple_arg {
+	int type;
+	union {
+		struct {
+			int mode;
+			struct nameidata *nd;
+		} c;
+		struct {
+			const char *symname;
+		} s;
+		struct {
+			int mode;
+			dev_t dev;
+		} m;
+	} u;
+};
+
+static int add_simple(struct inode *dir, struct dentry *dentry,
+		      struct simple_arg *arg)
+{
+	int err;
+	aufs_bindex_t bstart;
+	unsigned char created;
+	struct au_dtime dt;
+	struct au_pin pin;
+	struct path h_path;
+	struct dentry *wh_dentry, *parent;
+	struct inode *h_dir;
+	struct au_wr_dir_args wr_dir_args = {
+		.force_btgt	= -1,
+		.flags		= AuWrDir_ADD_ENTRY
+	};
+
+	IMustLock(dir);
+
+	parent = dentry->d_parent; /* dir inode is locked */
+	aufs_read_lock(dentry, AuLock_DW);
+	di_write_lock_parent(parent);
+	wh_dentry = lock_hdir_lkup_wh(dentry, &dt, /*src_dentry*/NULL, &pin,
+				      &wr_dir_args);
+	err = PTR_ERR(wh_dentry);
+	if (IS_ERR(wh_dentry))
+		goto out;
+
+	bstart = au_dbstart(dentry);
+	h_path.dentry = au_h_dptr(dentry, bstart);
+	h_path.mnt = au_sbr_mnt(dentry->d_sb, bstart);
+	h_dir = au_pinned_h_dir(&pin);
+	switch (arg->type) {
+	case Creat:
+		err = vfsub_create(h_dir, &h_path, arg->u.c.mode);
+		break;
+	case Symlink:
+		err = vfsub_symlink(h_dir, &h_path, arg->u.s.symname);
+		break;
+	case Mknod:
+		err = vfsub_mknod(h_dir, &h_path, arg->u.m.mode, arg->u.m.dev);
+		break;
+	default:
+		BUG();
+	}
+	created = !err;
+	if (!err)
+		err = epilog(dir, bstart, wh_dentry, dentry);
+
+	/* revert */
+	if (unlikely(created && err && h_path.dentry->d_inode)) {
+		int rerr;
+		rerr = vfsub_unlink(h_dir, &h_path, /*force*/0);
+		if (rerr) {
+			AuIOErr("%.*s revert failure(%d, %d)\n",
+				AuDLNPair(dentry), err, rerr);
+			err = -EIO;
+		}
+		au_dtime_revert(&dt);
+		d_drop(dentry);
+	}
+
+	au_unpin(&pin);
+	dput(wh_dentry);
+
+ out:
+	if (unlikely(err)) {
+		au_update_dbstart(dentry);
+		d_drop(dentry);
+	}
+	di_write_unlock(parent);
+	aufs_read_unlock(dentry, AuLock_DW);
+	return err;
+}
+
+int aufs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+{
+	struct simple_arg arg = {
+		.type = Mknod,
+		.u.m = {
+			.mode	= mode,
+			.dev	= dev
+		}
+	};
+	return add_simple(dir, dentry, &arg);
+}
+
+int aufs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
+{
+	struct simple_arg arg = {
+		.type = Symlink,
+		.u.s.symname = symname
+	};
+	return add_simple(dir, dentry, &arg);
+}
+
+int aufs_create(struct inode *dir, struct dentry *dentry, int mode,
+		struct nameidata *nd)
+{
+	struct simple_arg arg = {
+		.type = Creat,
+		.u.c = {
+			.mode	= mode,
+			.nd	= nd
+		}
+	};
+	return add_simple(dir, dentry, &arg);
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct au_link_args {
+	aufs_bindex_t bdst, bsrc;
+	struct au_pin pin;
+	struct path h_path;
+	struct dentry *src_parent, *parent;
+};
+
+static int au_cpup_before_link(struct dentry *src_dentry,
+			       struct au_link_args *a)
+{
+	int err;
+	struct dentry *h_src_dentry;
+	struct mutex *h_mtx;
+
+	di_read_lock_parent(a->src_parent, AuLock_IR);
+	err = au_test_and_cpup_dirs(src_dentry, a->bdst);
+	if (unlikely(err))
+		goto out;
+
+	h_src_dentry = au_h_dptr(src_dentry, a->bsrc);
+	h_mtx = &h_src_dentry->d_inode->i_mutex;
+	err = au_pin(&a->pin, src_dentry, a->bdst,
+		     au_opt_udba(src_dentry->d_sb),
+		     AuPin_DI_LOCKED | AuPin_MNT_WRITE);
+	if (unlikely(err))
+		goto out;
+	mutex_lock_nested(h_mtx, AuLsc_I_CHILD);
+	err = au_sio_cpup_simple(src_dentry, a->bdst, -1,
+				 AuCpup_DTIME /* | AuCpup_KEEPLINO */);
+	mutex_unlock(h_mtx);
+	au_unpin(&a->pin);
+
+ out:
+	di_read_unlock(a->src_parent, AuLock_IR);
+	return err;
+}
+
+static int au_cpup_or_link(struct dentry *src_dentry, struct au_link_args *a)
+{
+	int err;
+	unsigned char plink;
+	struct inode *h_inode, *inode;
+	struct dentry *h_src_dentry;
+	struct super_block *sb;
+
+	plink = 0;
+	h_inode = NULL;
+	sb = src_dentry->d_sb;
+	inode = src_dentry->d_inode;
+	if (au_ibstart(inode) <= a->bdst)
+		h_inode = au_h_iptr(inode, a->bdst);
+	if (!h_inode || !h_inode->i_nlink) {
+		/* copyup src_dentry as the name of dentry. */
+		au_set_dbstart(src_dentry, a->bdst);
+		au_set_h_dptr(src_dentry, a->bdst, dget(a->h_path.dentry));
+		h_inode = au_h_dptr(src_dentry, a->bsrc)->d_inode;
+		mutex_lock_nested(&h_inode->i_mutex, AuLsc_I_CHILD);
+		err = au_sio_cpup_single(src_dentry, a->bdst, a->bsrc, -1,
+					 AuCpup_KEEPLINO, a->parent);
+		mutex_unlock(&h_inode->i_mutex);
+		au_set_h_dptr(src_dentry, a->bdst, NULL);
+		au_set_dbstart(src_dentry, a->bsrc);
+	} else {
+		/* the inode of src_dentry already exists on a.bdst branch */
+		h_src_dentry = d_find_alias(h_inode);
+		if (!h_src_dentry && au_plink_test(inode)) {
+			plink = 1;
+			h_src_dentry = au_plink_lkup(inode, a->bdst);
+			err = PTR_ERR(h_src_dentry);
+			if (IS_ERR(h_src_dentry))
+				goto out;
+
+			if (unlikely(!h_src_dentry->d_inode)) {
+				dput(h_src_dentry);
+				h_src_dentry = NULL;
+			}
+
+		}
+		if (h_src_dentry) {
+			err = vfsub_link(h_src_dentry, au_pinned_h_dir(&a->pin),
+					 &a->h_path);
+			dput(h_src_dentry);
+		} else {
+			AuIOErr("no dentry found for hi%lu on b%d\n",
+				h_inode->i_ino, a->bdst);
+			err = -EIO;
+		}
+	}
+
+	if (!err && !plink)
+		au_plink_append(inode, a->bdst, a->h_path.dentry);
+
+out:
+	return err;
+}
+
+int aufs_link(struct dentry *src_dentry, struct inode *dir,
+	      struct dentry *dentry)
+{
+	int err, rerr;
+	struct au_dtime dt;
+	struct au_link_args *a;
+	struct dentry *wh_dentry, *h_src_dentry;
+	struct inode *inode;
+	struct super_block *sb;
+	struct au_wr_dir_args wr_dir_args = {
+		/* .force_btgt	= -1, */
+		.flags		= AuWrDir_ADD_ENTRY
+	};
+
+	IMustLock(dir);
+	inode = src_dentry->d_inode;
+	IMustLock(inode);
+
+	err = -ENOMEM;
+	a = kzalloc(sizeof(*a), GFP_NOFS);
+	if (unlikely(!a))
+		goto out;
+
+	a->parent = dentry->d_parent; /* dir inode is locked */
+	aufs_read_and_write_lock2(dentry, src_dentry, /*AuLock_FLUSH*/0);
+	a->src_parent = dget_parent(src_dentry);
+	wr_dir_args.force_btgt = au_dbstart(src_dentry);
+
+	di_write_lock_parent(a->parent);
+	wr_dir_args.force_btgt = au_wbr(dentry, wr_dir_args.force_btgt);
+	wh_dentry = lock_hdir_lkup_wh(dentry, &dt, src_dentry, &a->pin,
+				      &wr_dir_args);
+	err = PTR_ERR(wh_dentry);
+	if (IS_ERR(wh_dentry))
+		goto out_unlock;
+
+	err = 0;
+	sb = dentry->d_sb;
+	a->bdst = au_dbstart(dentry);
+	a->h_path.dentry = au_h_dptr(dentry, a->bdst);
+	a->h_path.mnt = au_sbr_mnt(sb, a->bdst);
+	a->bsrc = au_dbstart(src_dentry);
+	if (au_opt_test(au_mntflags(sb), PLINK)) {
+		if (a->bdst < a->bsrc
+		    /* && h_src_dentry->d_sb != a->h_path.dentry->d_sb */)
+			err = au_cpup_or_link(src_dentry, a);
+		else {
+			h_src_dentry = au_h_dptr(src_dentry, a->bdst);
+			err = vfsub_link(h_src_dentry, au_pinned_h_dir(&a->pin),
+					 &a->h_path);
+		}
+	} else {
+		/*
+		 * copyup src_dentry to the branch we process,
+		 * and then link(2) to it.
+		 */
+		if (a->bdst < a->bsrc
+		    /* && h_src_dentry->d_sb != a->h_path.dentry->d_sb */) {
+			au_unpin(&a->pin);
+			di_write_unlock(a->parent);
+			err = au_cpup_before_link(src_dentry, a);
+			if (!err) {
+				di_write_lock_parent(a->parent);
+				err = au_pin(&a->pin, dentry, a->bdst,
+					     au_opt_udba(sb),
+					     AuPin_DI_LOCKED | AuPin_MNT_WRITE);
+				if (unlikely(err))
+					goto out_wh;
+			}
+		}
+		if (!err) {
+			h_src_dentry = au_h_dptr(src_dentry, a->bdst);
+			err = vfsub_link(h_src_dentry, au_pinned_h_dir(&a->pin),
+					 &a->h_path);
+		}
+	}
+	if (unlikely(err))
+		goto out_unpin;
+
+	if (wh_dentry) {
+		a->h_path.dentry = wh_dentry;
+		err = au_wh_unlink_dentry(au_pinned_h_dir(&a->pin), &a->h_path,
+					  dentry);
+		if (unlikely(err))
+			goto out_revert;
+	}
+
+	dir->i_version++;
+	if (au_ibstart(dir) == au_dbstart(dentry))
+		au_cpup_attr_timesizes(dir);
+	inc_nlink(inode);
+	inode->i_ctime = dir->i_ctime;
+	if (!d_unhashed(a->h_path.dentry))
+		d_instantiate(dentry, au_igrab(inode));
+	else
+		/* some filesystem calls d_drop() */
+		d_drop(dentry);
+	goto out_unpin; /* success */
+
+ out_revert:
+	rerr = vfsub_unlink(au_pinned_h_dir(&a->pin), &a->h_path, /*force*/0);
+	if (!rerr)
+		goto out_dt;
+	AuIOErr("%.*s reverting failed(%d, %d)\n",
+		AuDLNPair(dentry), err, rerr);
+	err = -EIO;
+ out_dt:
+	d_drop(dentry);
+	au_dtime_revert(&dt);
+ out_unpin:
+	au_unpin(&a->pin);
+ out_wh:
+	dput(wh_dentry);
+ out_unlock:
+	if (unlikely(err)) {
+		au_update_dbstart(dentry);
+		d_drop(dentry);
+	}
+	di_write_unlock(a->parent);
+	dput(a->src_parent);
+	aufs_read_and_write_unlock2(dentry, src_dentry);
+	kfree(a);
+ out:
+	return err;
+}
+
+int aufs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	int err, rerr;
+	aufs_bindex_t bindex;
+	unsigned char diropq;
+	struct au_pin pin;
+	struct path h_path;
+	struct dentry *wh_dentry, *parent, *opq_dentry;
+	struct mutex *h_mtx;
+	struct super_block *sb;
+	struct au_dtime dt;
+	struct au_wr_dir_args wr_dir_args = {
+		.force_btgt	= -1,
+		.flags		= AuWrDir_ADD_ENTRY | AuWrDir_ISDIR
+	};
+
+	IMustLock(dir);
+
+	aufs_read_lock(dentry, AuLock_DW);
+	parent = dentry->d_parent; /* dir inode is locked */
+	di_write_lock_parent(parent);
+	wh_dentry = lock_hdir_lkup_wh(dentry, &dt, /*src_dentry*/NULL, &pin,
+				      &wr_dir_args);
+	err = PTR_ERR(wh_dentry);
+	if (IS_ERR(wh_dentry))
+		goto out;
+
+	sb = dentry->d_sb;
+	bindex = au_dbstart(dentry);
+	h_path.dentry = au_h_dptr(dentry, bindex);
+	h_path.mnt = au_sbr_mnt(sb, bindex);
+	err = vfsub_mkdir(au_pinned_h_dir(&pin), &h_path, mode);
+	if (unlikely(err))
+		goto out_unlock;
+
+	/* make the dir opaque */
+	diropq = 0;
+	h_mtx = &h_path.dentry->d_inode->i_mutex;
+	if (wh_dentry
+	    || au_opt_test(au_mntflags(sb), ALWAYS_DIROPQ)) {
+		mutex_lock_nested(h_mtx, AuLsc_I_CHILD);
+		opq_dentry = au_diropq_create(dentry, bindex);
+		mutex_unlock(h_mtx);
+		err = PTR_ERR(opq_dentry);
+		if (IS_ERR(opq_dentry))
+			goto out_dir;
+		dput(opq_dentry);
+		diropq = 1;
+	}
+
+	err = epilog(dir, bindex, wh_dentry, dentry);
+	if (!err) {
+		inc_nlink(dir);
+		goto out_unlock; /* success */
+	}
+
+	/* revert */
+	if (diropq) {
+		AuLabel(revert opq);
+		mutex_lock_nested(h_mtx, AuLsc_I_CHILD);
+		rerr = au_diropq_remove(dentry, bindex);
+		mutex_unlock(h_mtx);
+		if (rerr) {
+			AuIOErr("%.*s reverting diropq failed(%d, %d)\n",
+				AuDLNPair(dentry), err, rerr);
+			err = -EIO;
+		}
+	}
+
+ out_dir:
+	AuLabel(revert dir);
+	rerr = vfsub_rmdir(au_pinned_h_dir(&pin), &h_path);
+	if (rerr) {
+		AuIOErr("%.*s reverting dir failed(%d, %d)\n",
+			AuDLNPair(dentry), err, rerr);
+		err = -EIO;
+	}
+	d_drop(dentry);
+	au_dtime_revert(&dt);
+ out_unlock:
+	au_unpin(&pin);
+	dput(wh_dentry);
+ out:
+	if (unlikely(err)) {
+		au_update_dbstart(dentry);
+		d_drop(dentry);
+	}
+	di_write_unlock(parent);
+	aufs_read_unlock(dentry, AuLock_DW);
+	return err;
+}
diff --git a/fs/aufs/i_op_del.c b/fs/aufs/i_op_del.c
new file mode 100644
index 0000000..681edb4
--- /dev/null
+++ b/fs/aufs/i_op_del.c
@@ -0,0 +1,471 @@
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
+ * inode operations (del entry)
+ */
+
+#include "aufs.h"
+
+/*
+ * decide if a new whiteout for @dentry is necessary or not.
+ * when it is necessary, prepare the parent dir for the upper branch whose
+ * branch index is @bcpup for creation. the actual creation of the whiteout will
+ * be done by caller.
+ * return value:
+ * 0: wh is unnecessary
+ * plus: wh is necessary
+ * minus: error
+ */
+int au_wr_dir_need_wh(struct dentry *dentry, int isdir, aufs_bindex_t *bcpup)
+{
+	int need_wh, err;
+	aufs_bindex_t bstart;
+	struct super_block *sb;
+
+	sb = dentry->d_sb;
+	bstart = au_dbstart(dentry);
+	if (*bcpup < 0) {
+		*bcpup = bstart;
+		if (au_test_ro(sb, bstart, dentry->d_inode)) {
+			err = AuWbrCopyup(au_sbi(sb), dentry);
+			*bcpup = err;
+			if (unlikely(err < 0))
+				goto out;
+		}
+	} else
+		AuDebugOn(bstart < *bcpup
+			  || au_test_ro(sb, *bcpup, dentry->d_inode));
+	AuDbg("bcpup %d, bstart %d\n", *bcpup, bstart);
+
+	if (*bcpup != bstart) {
+		err = au_cpup_dirs(dentry, *bcpup);
+		if (unlikely(err))
+			goto out;
+		need_wh = 1;
+	} else {
+		aufs_bindex_t old_bend, new_bend, bdiropq = -1;
+
+		old_bend = au_dbend(dentry);
+		if (isdir) {
+			bdiropq = au_dbdiropq(dentry);
+			au_set_dbdiropq(dentry, -1);
+		}
+		need_wh = au_lkup_dentry(dentry, bstart + 1, /*type*/0,
+					 /*nd*/NULL);
+		err = need_wh;
+		if (isdir)
+			au_set_dbdiropq(dentry, bdiropq);
+		if (unlikely(err < 0))
+			goto out;
+		new_bend = au_dbend(dentry);
+		if (!need_wh && old_bend != new_bend) {
+			au_set_h_dptr(dentry, new_bend, NULL);
+			au_set_dbend(dentry, old_bend);
+		}
+	}
+	AuDbg("need_wh %d\n", need_wh);
+	err = need_wh;
+
+ out:
+	return err;
+}
+
+/*
+ * simple tests for the del-entry operations.
+ * following the checks in vfs, plus the parent-child relationship.
+ */
+int au_may_del(struct dentry *dentry, aufs_bindex_t bindex,
+	       struct dentry *h_parent, int isdir)
+{
+	int err;
+	umode_t h_mode;
+	struct dentry *h_dentry, *h_latest;
+	struct inode *h_inode;
+
+	h_dentry = au_h_dptr(dentry, bindex);
+	h_inode = h_dentry->d_inode;
+	if (dentry->d_inode) {
+		err = -ENOENT;
+		if (unlikely(!h_inode || !h_inode->i_nlink))
+			goto out;
+
+		h_mode = h_inode->i_mode;
+		if (!isdir) {
+			err = -EISDIR;
+			if (unlikely(S_ISDIR(h_mode)))
+				goto out;
+		} else if (unlikely(!S_ISDIR(h_mode))) {
+			err = -ENOTDIR;
+			goto out;
+		}
+	} else {
+		/* rename(2) case */
+		err = -EIO;
+		if (unlikely(h_inode))
+			goto out;
+	}
+
+	err = -ENOENT;
+	/* expected parent dir is locked */
+	if (unlikely(h_parent != h_dentry->d_parent))
+		goto out;
+	err = 0;
+
+	/*
+	 * rmdir a dir may break the consistency on some filesystem.
+	 * let's try heavy test.
+	 */
+	err = -EACCES;
+	if (unlikely(au_test_h_perm(h_parent->d_inode, MAY_EXEC | MAY_WRITE)))
+		goto out;
+
+	h_latest = au_sio_lkup_one(&dentry->d_name, h_parent,
+				   au_sbr(dentry->d_sb, bindex));
+	err = -EIO;
+	if (IS_ERR(h_latest))
+		goto out;
+	if (h_latest == h_dentry)
+		err = 0;
+	dput(h_latest);
+
+ out:
+	return err;
+}
+
+/*
+ * decide the branch where we operate for @dentry. the branch index will be set
+ * @rbcpup. after diciding it, 'pin' it and store the timestamps of the parent
+ * dir for reverting.
+ * when a new whiteout is necessary, create it.
+ */
+static struct dentry*
+lock_hdir_create_wh(struct dentry *dentry, int isdir, aufs_bindex_t *rbcpup,
+		    struct au_dtime *dt, struct au_pin *pin)
+{
+	struct dentry *wh_dentry;
+	struct super_block *sb;
+	struct path h_path;
+	int err, need_wh;
+	unsigned int udba;
+	aufs_bindex_t bcpup;
+
+	need_wh = au_wr_dir_need_wh(dentry, isdir, rbcpup);
+	wh_dentry = ERR_PTR(need_wh);
+	if (unlikely(need_wh < 0))
+		goto out;
+
+	sb = dentry->d_sb;
+	udba = au_opt_udba(sb);
+	bcpup = *rbcpup;
+	err = au_pin(pin, dentry, bcpup, udba,
+		     AuPin_DI_LOCKED | AuPin_MNT_WRITE);
+	wh_dentry = ERR_PTR(err);
+	if (unlikely(err))
+		goto out;
+
+	h_path.dentry = au_pinned_h_parent(pin);
+	if (udba != AuOpt_UDBA_NONE
+	    && au_dbstart(dentry) == bcpup) {
+		err = au_may_del(dentry, bcpup, h_path.dentry, isdir);
+		wh_dentry = ERR_PTR(err);
+		if (unlikely(err))
+			goto out_unpin;
+	}
+
+	h_path.mnt = au_sbr_mnt(sb, bcpup);
+	au_dtime_store(dt, au_pinned_parent(pin), &h_path);
+	wh_dentry = NULL;
+	if (!need_wh)
+		goto out; /* success, no need to create whiteout */
+
+	wh_dentry = au_wh_create(dentry, bcpup, h_path.dentry);
+	if (!IS_ERR(wh_dentry))
+		goto out; /* success */
+	/* returns with the parent is locked and wh_dentry is dget-ed */
+
+ out_unpin:
+	au_unpin(pin);
+ out:
+	return wh_dentry;
+}
+
+/*
+ * when removing a dir, rename it to a unique temporary whiteout-ed name first
+ * in order to be revertible and save time for removing many child whiteouts
+ * under the dir.
+ * returns 1 when there are too many child whiteout and caller should remove
+ * them asynchronously. returns 0 when the number of children is enough small to
+ * remove now or the branch fs is a remote fs.
+ * otherwise return an error.
+ */
+static int renwh_and_rmdir(struct dentry *dentry, aufs_bindex_t bindex,
+			   struct au_nhash *whlist, struct inode *dir)
+{
+	int rmdir_later, err, dirwh;
+	struct dentry *h_dentry;
+	struct super_block *sb;
+
+	sb = dentry->d_sb;
+	h_dentry = au_h_dptr(dentry, bindex);
+	err = au_whtmp_ren(h_dentry, au_sbr(sb, bindex));
+	if (unlikely(err))
+		goto out;
+
+	/* stop monitoring */
+	au_hin_free(au_hi(dentry->d_inode, bindex));
+
+	if (!au_test_fs_remote(h_dentry->d_sb)) {
+		dirwh = au_sbi(sb)->si_dirwh;
+		rmdir_later = (dirwh <= 1);
+		if (!rmdir_later)
+			rmdir_later = au_nhash_test_longer_wh(whlist, bindex,
+							      dirwh);
+		if (rmdir_later)
+			return rmdir_later;
+	}
+
+	err = au_whtmp_rmdir(dir, bindex, h_dentry, whlist);
+	if (unlikely(err)) {
+		AuIOErr("rmdir %.*s, b%d failed, %d. ignored\n",
+			AuDLNPair(h_dentry), bindex, err);
+		err = 0;
+	}
+
+ out:
+	return err;
+}
+
+/*
+ * final procedure for deleting a entry.
+ * maintain dentry and iattr.
+ */
+static void epilog(struct inode *dir, struct dentry *dentry,
+		   aufs_bindex_t bindex)
+{
+	struct inode *inode;
+
+	/*
+	 * even if this is not a dir,
+	 * set S_DEAD here since we need to detect the dead inode.
+	 */
+	inode = dentry->d_inode;
+	if (!inode->i_nlink)
+		inode->i_flags |= S_DEAD;
+	d_drop(dentry);
+	inode->i_ctime = dir->i_ctime;
+
+	if (atomic_read(&dentry->d_count) == 1) {
+		au_set_h_dptr(dentry, au_dbstart(dentry), NULL);
+		au_update_dbstart(dentry);
+	}
+	if (au_ibstart(dir) == bindex)
+		au_cpup_attr_timesizes(dir);
+	dir->i_version++;
+}
+
+/*
+ * when an error happened, remove the created whiteout and revert everything.
+ */
+static int do_revert(int err, struct inode *dir, aufs_bindex_t bwh,
+		     struct dentry *wh_dentry, struct dentry *dentry,
+		     struct au_dtime *dt)
+{
+	int rerr;
+	struct path h_path = {
+		.dentry	= wh_dentry,
+		.mnt	= au_sbr_mnt(dir->i_sb, bwh)
+	};
+
+	rerr = au_wh_unlink_dentry(au_h_iptr(dir, bwh), &h_path, dentry);
+	if (!rerr) {
+		au_set_dbwh(dentry, bwh);
+		au_dtime_revert(dt);
+		return 0;
+	}
+
+	AuIOErr("%.*s reverting whiteout failed(%d, %d)\n",
+		AuDLNPair(dentry), err, rerr);
+	return -EIO;
+}
+
+/* ---------------------------------------------------------------------- */
+
+int aufs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	int err;
+	aufs_bindex_t bwh, bindex, bstart;
+	struct au_dtime dt;
+	struct au_pin pin;
+	struct path h_path;
+	struct inode *inode, *h_dir;
+	struct dentry *parent, *wh_dentry;
+
+	IMustLock(dir);
+	inode = dentry->d_inode;
+	if (unlikely(!inode))
+		return -ENOENT; /* possible? */
+	IMustLock(inode);
+
+	aufs_read_lock(dentry, AuLock_DW);
+	parent = dentry->d_parent; /* dir inode is locked */
+	di_write_lock_parent(parent);
+
+	bstart = au_dbstart(dentry);
+	bwh = au_dbwh(dentry);
+	bindex = -1;
+	wh_dentry = lock_hdir_create_wh(dentry, /*isdir*/0, &bindex, &dt, &pin);
+	err = PTR_ERR(wh_dentry);
+	if (IS_ERR(wh_dentry))
+		goto out;
+
+	h_path.mnt = au_sbr_mnt(dentry->d_sb, bstart);
+	h_path.dentry = au_h_dptr(dentry, bstart);
+	dget(h_path.dentry);
+	if (bindex == bstart) {
+		h_dir = au_pinned_h_dir(&pin);
+		err = vfsub_unlink(h_dir, &h_path, /*force*/0);
+	} else {
+		/* dir inode is locked */
+		h_dir = wh_dentry->d_parent->d_inode;
+		IMustLock(h_dir);
+		err = 0;
+	}
+
+	if (!err) {
+		drop_nlink(inode);
+		epilog(dir, dentry, bindex);
+
+		/* update target timestamps */
+		if (bindex == bstart) {
+			vfsub_update_h_iattr(&h_path, /*did*/NULL); /*ignore*/
+			inode->i_ctime = h_path.dentry->d_inode->i_ctime;
+		} else
+			/* todo: this timestamp may be reverted later */
+			inode->i_ctime = h_dir->i_ctime;
+		goto out_unlock; /* success */
+	}
+
+	/* revert */
+	if (wh_dentry) {
+		int rerr;
+
+		rerr = do_revert(err, dir, bwh, wh_dentry, dentry, &dt);
+		if (rerr)
+			err = rerr;
+	}
+
+ out_unlock:
+	au_unpin(&pin);
+	dput(wh_dentry);
+	dput(h_path.dentry);
+ out:
+	di_write_unlock(parent);
+	aufs_read_unlock(dentry, AuLock_DW);
+	return err;
+}
+
+int aufs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	int err, rmdir_later;
+	aufs_bindex_t bwh, bindex, bstart;
+	struct au_dtime dt;
+	struct au_pin pin;
+	struct inode *inode;
+	struct dentry *parent, *wh_dentry, *h_dentry;
+	struct au_whtmp_rmdir_args *args;
+	struct au_nhash *whlist;
+
+	IMustLock(dir);
+	inode = dentry->d_inode;
+	err = -ENOENT; /* possible? */
+	if (unlikely(!inode))
+		goto out;
+	IMustLock(inode);
+
+	whlist = au_nhash_new(GFP_NOFS);
+	err = PTR_ERR(whlist);
+	if (IS_ERR(whlist))
+		goto out;
+
+	err = -ENOMEM;
+	args = kmalloc(sizeof(*args), GFP_NOFS);
+	if (unlikely(!args))
+		goto out_whlist;
+
+	aufs_read_lock(dentry, AuLock_DW | AuLock_FLUSH);
+	parent = dentry->d_parent; /* dir inode is locked */
+	di_write_lock_parent(parent);
+	err = au_test_empty(dentry, whlist);
+	if (unlikely(err))
+		goto out_args;
+
+	bstart = au_dbstart(dentry);
+	bwh = au_dbwh(dentry);
+	bindex = -1;
+	wh_dentry = lock_hdir_create_wh(dentry, /*isdir*/1, &bindex, &dt, &pin);
+	err = PTR_ERR(wh_dentry);
+	if (IS_ERR(wh_dentry))
+		goto out_args;
+
+	h_dentry = au_h_dptr(dentry, bstart);
+	dget(h_dentry);
+	rmdir_later = 0;
+	if (bindex == bstart) {
+		err = renwh_and_rmdir(dentry, bstart, whlist, dir);
+		if (err > 0) {
+			rmdir_later = err;
+			err = 0;
+		}
+	} else {
+		/* stop monitoring */
+		au_hin_free(au_hi(inode, bstart));
+
+		/* dir inode is locked */
+		IMustLock(wh_dentry->d_parent->d_inode);
+		err = 0;
+	}
+
+	if (!err) {
+		clear_nlink(inode);
+		au_set_dbdiropq(dentry, -1);
+		epilog(dir, dentry, bindex);
+
+		if (rmdir_later) {
+			au_whtmp_kick_rmdir(dir, bstart, h_dentry, whlist,
+					    args);
+			args = NULL;
+		}
+
+		goto out_unlock; /* success */
+	}
+
+	/* revert */
+	AuLabel(revert);
+	if (wh_dentry) {
+		int rerr;
+
+		rerr = do_revert(err, dir, bwh, wh_dentry, dentry, &dt);
+		if (rerr)
+			err = rerr;
+	}
+
+ out_unlock:
+	au_unpin(&pin);
+	dput(wh_dentry);
+	dput(h_dentry);
+ out_args:
+	di_write_unlock(parent);
+	aufs_read_unlock(dentry, AuLock_DW);
+	kfree(args);
+ out_whlist:
+	au_nhash_del(whlist);
+ out:
+	return err;
+}
diff --git a/fs/aufs/i_op_ren.c b/fs/aufs/i_op_ren.c
new file mode 100644
index 0000000..e0dd048
--- /dev/null
+++ b/fs/aufs/i_op_ren.c
@@ -0,0 +1,929 @@
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
+ * inode operation (rename entry)
+ * todo: this is crazy monster
+ */
+
+#include "aufs.h"
+
+enum { AuSRC, AuDST, AuSrcDst };
+enum { AuPARENT, AuCHILD, AuParentChild };
+
+#define AuRen_ISDIR	1
+#define AuRen_ISSAMEDIR	(1 << 1)
+#define AuRen_WHSRC	(1 << 2)
+#define AuRen_WHDST	(1 << 3)
+#define AuRen_MNT_WRITE	(1 << 4)
+#define AuRen_DT_DSTDIR	(1 << 5)
+#define AuRen_DIROPQ	(1 << 6)
+#define AuRen_CPUP	(1 << 7)
+#define au_ftest_ren(flags, name)	((flags) & AuRen_##name)
+#define au_fset_ren(flags, name)	{ (flags) |= AuRen_##name; }
+#define au_fclr_ren(flags, name)	{ (flags) &= ~AuRen_##name; }
+
+struct au_ren_args {
+	struct {
+		struct dentry *dentry, *h_dentry, *parent, *h_parent,
+			*wh_dentry;
+		struct inode *dir, *inode;
+		struct au_hinode *hdir;
+		struct au_dtime dt[AuParentChild];
+		aufs_bindex_t bstart;
+	} sd[AuSrcDst];
+
+#define src_dentry	sd[AuSRC].dentry
+#define src_dir		sd[AuSRC].dir
+#define src_inode	sd[AuSRC].inode
+#define src_h_dentry	sd[AuSRC].h_dentry
+#define src_parent	sd[AuSRC].parent
+#define src_h_parent	sd[AuSRC].h_parent
+#define src_wh_dentry	sd[AuSRC].wh_dentry
+#define src_hdir	sd[AuSRC].hdir
+#define src_h_dir	sd[AuSRC].hdir->hi_inode
+#define src_dt		sd[AuSRC].dt
+#define src_bstart	sd[AuSRC].bstart
+
+#define dst_dentry	sd[AuDST].dentry
+#define dst_dir		sd[AuDST].dir
+#define dst_inode	sd[AuDST].inode
+#define dst_h_dentry	sd[AuDST].h_dentry
+#define dst_parent	sd[AuDST].parent
+#define dst_h_parent	sd[AuDST].h_parent
+#define dst_wh_dentry	sd[AuDST].wh_dentry
+#define dst_hdir	sd[AuDST].hdir
+#define dst_h_dir	sd[AuDST].hdir->hi_inode
+#define dst_dt		sd[AuDST].dt
+#define dst_bstart	sd[AuDST].bstart
+
+	struct dentry *h_trap;
+	struct au_branch *br;
+	struct au_hinode *src_hinode;
+	struct path h_path;
+	struct au_nhash whlist;
+	aufs_bindex_t btgt;
+
+	unsigned int flags;
+
+	struct au_whtmp_rmdir_args *thargs;
+	struct dentry *h_dst;
+};
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * functions for reverting.
+ * when an error happened in a single rename systemcall, we should revert
+ * everything as if nothing happend.
+ * we don't need to revert the copied-up/down the parent dir since they are
+ * harmless.
+ */
+
+#define RevertFailure(fmt, args...) do { \
+	AuIOErr("revert failure: " fmt " (%d, %d)\n", \
+		##args, err, rerr); \
+	err = -EIO; \
+} while (0)
+
+static void au_ren_rev_diropq(int err, struct au_ren_args *a)
+{
+	int rerr;
+
+	au_hin_imtx_lock_nested(a->src_hinode, AuLsc_I_CHILD);
+	rerr = au_diropq_remove(a->src_dentry, a->btgt);
+	au_hin_imtx_unlock(a->src_hinode);
+	if (rerr)
+		RevertFailure("remove diropq %.*s", AuDLNPair(a->src_dentry));
+}
+
+
+static void au_ren_rev_rename(int err, struct au_ren_args *a)
+{
+	int rerr;
+
+	a->h_path.dentry = au_lkup_one(&a->src_dentry->d_name, a->src_h_parent,
+				       a->br, /*nd*/NULL);
+	rerr = PTR_ERR(a->h_path.dentry);
+	if (IS_ERR(a->h_path.dentry)) {
+		RevertFailure("au_lkup_one %.*s", AuDLNPair(a->src_dentry));
+		return;
+	}
+
+	rerr = vfsub_rename(a->dst_h_dir,
+			    au_h_dptr(a->src_dentry, a->btgt),
+			    a->src_h_dir, &a->h_path);
+	d_drop(a->h_path.dentry);
+	dput(a->h_path.dentry);
+	/* au_set_h_dptr(a->src_dentry, a->btgt, NULL); */
+	if (rerr)
+		RevertFailure("rename %.*s", AuDLNPair(a->src_dentry));
+}
+
+static void au_ren_rev_cpup(int err, struct au_ren_args *a)
+{
+	int rerr;
+
+	a->h_path.dentry = a->dst_h_dentry;
+	rerr = vfsub_unlink(a->dst_h_dir, &a->h_path, /*force*/0);
+	au_set_h_dptr(a->src_dentry, a->btgt, NULL);
+	au_set_dbstart(a->src_dentry, a->src_bstart);
+	if (rerr)
+		RevertFailure("unlink %.*s", AuDLNPair(a->dst_h_dentry));
+}
+
+
+static void au_ren_rev_whtmp(int err, struct au_ren_args *a)
+{
+	int rerr;
+
+	a->h_path.dentry = au_lkup_one(&a->dst_dentry->d_name, a->dst_h_parent,
+				       a->br, /*nd*/NULL);
+	rerr = PTR_ERR(a->h_path.dentry);
+	if (IS_ERR(a->h_path.dentry)) {
+		RevertFailure("lookup %.*s", AuDLNPair(a->dst_dentry));
+		return;
+	}
+	if (a->h_path.dentry->d_inode) {
+		d_drop(a->h_path.dentry);
+		dput(a->h_path.dentry);
+		return;
+	}
+
+	rerr = vfsub_rename(a->dst_h_dir, a->h_dst, a->dst_h_dir, &a->h_path);
+	d_drop(a->h_path.dentry);
+	dput(a->h_path.dentry);
+	if (!rerr) {
+		au_set_h_dptr(a->dst_dentry, a->btgt, NULL);
+		au_set_h_dptr(a->dst_dentry, a->btgt, dget(a->h_dst));
+	} else
+		RevertFailure("rename %.*s", AuDLNPair(a->h_dst));
+}
+
+static void au_ren_rev_whsrc(int err, struct au_ren_args *a)
+{
+	int rerr;
+
+	a->h_path.dentry = a->src_wh_dentry;
+	rerr = au_wh_unlink_dentry(a->src_h_dir, &a->h_path, a->src_dentry);
+	if (rerr)
+		RevertFailure("unlink %.*s", AuDLNPair(a->src_wh_dentry));
+}
+
+static void au_ren_rev_drop(struct au_ren_args *a)
+{
+	struct dentry *d, *h_d;
+	int i;
+	aufs_bindex_t bend, bindex;
+
+	for (i = 0; i < AuSrcDst; i++) {
+		d = a->sd[i].dentry;
+		d_drop(d);
+		bend = au_dbend(d);
+		for (bindex = au_dbstart(d); bindex <= bend; bindex++) {
+			h_d = au_h_dptr(d, bindex);
+			if (h_d)
+				d_drop(h_d);
+		}
+	}
+
+	au_update_dbstart(a->dst_dentry);
+	if (a->thargs)
+		d_drop(a->h_dst);
+}
+#undef RevertFailure
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * when we have to copyup the renaming entry, do it with the rename-target name
+ * in order to minimize the cost (the later actual rename is unnecessary).
+ * otherwise rename it on the target branch.
+ */
+static int au_ren_or_cpup(struct au_ren_args *a)
+{
+	int err;
+	struct dentry *d;
+
+	d = a->src_dentry;
+	if (au_dbstart(d) == a->btgt) {
+		a->h_path.dentry = a->dst_h_dentry;
+		if (au_ftest_ren(a->flags, DIROPQ)
+		    && au_dbdiropq(d) == a->btgt)
+			au_fclr_ren(a->flags, DIROPQ);
+		AuDebugOn(au_dbstart(d) != a->btgt);
+		err = vfsub_rename(a->src_h_dir, au_h_dptr(d, a->btgt),
+				   a->dst_h_dir, &a->h_path);
+	} else {
+		struct mutex *h_mtx = &a->src_h_dentry->d_inode->i_mutex;
+
+		au_fset_ren(a->flags, CPUP);
+		mutex_lock_nested(h_mtx, AuLsc_I_CHILD);
+		au_set_dbstart(d, a->btgt);
+		au_set_h_dptr(d, a->btgt, dget(a->dst_h_dentry));
+		err = au_sio_cpup_single(d, a->btgt, a->src_bstart, -1,
+					 !AuCpup_DTIME, a->dst_parent);
+		if (unlikely(err)) {
+			au_set_h_dptr(d, a->btgt, NULL);
+			au_set_dbstart(d, a->src_bstart);
+		}
+		mutex_unlock(h_mtx);
+	}
+
+	return err;
+}
+
+/* cf. aufs_rmdir() */
+static int au_ren_del_whtmp(struct au_ren_args *a)
+{
+	int err;
+	struct inode *dir;
+
+	dir = a->dst_dir;
+	if (!au_nhash_test_longer_wh(&a->whlist, a->btgt,
+				     au_sbi(dir->i_sb)->si_dirwh)
+	    || au_test_fs_remote(a->h_dst->d_sb)) {
+		err = au_whtmp_rmdir(dir, a->btgt, a->h_dst, &a->whlist);
+		if (unlikely(err))
+			AuWarn("failed removing whtmp dir %.*s (%d), "
+			       "ignored.\n", AuDLNPair(a->h_dst), err);
+	} else {
+		au_whtmp_kick_rmdir(dir, a->btgt, a->h_dst, &a->whlist,
+				    a->thargs);
+		dput(a->h_dst);
+		a->thargs = NULL;
+	}
+
+	return 0;
+}
+
+/* make it 'opaque' dir. */
+static int au_ren_diropq(struct au_ren_args *a)
+{
+	int err;
+	struct dentry *diropq;
+
+	err = 0;
+	a->src_hinode = au_hi(a->src_inode, a->btgt);
+	au_hin_imtx_lock_nested(a->src_hinode, AuLsc_I_CHILD);
+	diropq = au_diropq_create(a->src_dentry, a->btgt);
+	au_hin_imtx_unlock(a->src_hinode);
+	if (IS_ERR(diropq))
+		err = PTR_ERR(diropq);
+	dput(diropq);
+
+	return err;
+}
+
+static int do_rename(struct au_ren_args *a)
+{
+	int err;
+	struct dentry *d, *h_d;
+
+	/* prepare workqueue args for asynchronous rmdir */
+	h_d = a->dst_h_dentry;
+	if (au_ftest_ren(a->flags, ISDIR) && h_d->d_inode) {
+		err = -ENOMEM;
+		a->thargs = kmalloc(sizeof(*a->thargs), GFP_NOFS);
+		if (unlikely(!a->thargs))
+			goto out;
+		a->h_dst = dget(h_d);
+	}
+
+	/* create whiteout for src_dentry */
+	if (au_ftest_ren(a->flags, WHSRC)) {
+		a->src_wh_dentry
+			= au_wh_create(a->src_dentry, a->btgt, a->src_h_parent);
+		err = PTR_ERR(a->src_wh_dentry);
+		if (IS_ERR(a->src_wh_dentry))
+			goto out_thargs;
+	}
+
+	/* lookup whiteout for dentry */
+	if (au_ftest_ren(a->flags, WHDST)) {
+		h_d = au_wh_lkup(a->dst_h_parent, &a->dst_dentry->d_name,
+				 a->br);
+		err = PTR_ERR(h_d);
+		if (IS_ERR(h_d))
+			goto out_whsrc;
+		if (!h_d->d_inode)
+			dput(h_d);
+		else
+			a->dst_wh_dentry = h_d;
+	}
+
+	/* rename dentry to tmpwh */
+	if (a->thargs) {
+		err = au_whtmp_ren(a->dst_h_dentry, a->br);
+		if (unlikely(err))
+			goto out_whdst;
+
+		d = a->dst_dentry;
+		au_set_h_dptr(d, a->btgt, NULL);
+		err = au_lkup_neg(d, a->btgt);
+		if (unlikely(err))
+			goto out_whtmp;
+		a->dst_h_dentry = au_h_dptr(d, a->btgt);
+	}
+
+	/* cpup src */
+	if (a->dst_h_dentry->d_inode && a->src_bstart != a->btgt) {
+		struct mutex *h_mtx = &a->src_h_dentry->d_inode->i_mutex;
+
+		mutex_lock_nested(h_mtx, AuLsc_I_CHILD);
+		err = au_sio_cpup_simple(a->src_dentry, a->btgt, -1,
+					 !AuCpup_DTIME);
+		mutex_unlock(h_mtx);
+		if (unlikely(err))
+			goto out_whtmp;
+	}
+
+	/* rename by vfs_rename or cpup */
+	d = a->dst_dentry;
+	if (au_ftest_ren(a->flags, ISDIR)
+	    && (a->dst_wh_dentry
+		|| au_dbdiropq(d) == a->btgt
+		/* hide the lower to keep xino */
+		|| a->btgt < au_dbend(d)
+		|| au_opt_test(au_mntflags(d->d_sb), ALWAYS_DIROPQ)))
+		au_fset_ren(a->flags, DIROPQ);
+	err = au_ren_or_cpup(a);
+	if (unlikely(err))
+		/* leave the copied-up one */
+		goto out_whtmp;
+
+	/* make dir opaque */
+	if (au_ftest_ren(a->flags, DIROPQ)) {
+		err = au_ren_diropq(a);
+		if (unlikely(err))
+			goto out_rename;
+	}
+
+	/* update target timestamps */
+	AuDebugOn(au_dbstart(a->src_dentry) != a->btgt);
+	a->h_path.dentry = au_h_dptr(a->src_dentry, a->btgt);
+	vfsub_update_h_iattr(&a->h_path, /*did*/NULL); /*ignore*/
+	a->src_inode->i_ctime = a->h_path.dentry->d_inode->i_ctime;
+
+	/* remove whiteout for dentry */
+	if (a->dst_wh_dentry) {
+		a->h_path.dentry = a->dst_wh_dentry;
+		err = au_wh_unlink_dentry(a->dst_h_dir, &a->h_path,
+					  a->dst_dentry);
+		if (unlikely(err))
+			goto out_diropq;
+	}
+
+	/* remove whtmp */
+	if (a->thargs)
+		au_ren_del_whtmp(a); /* ignore this error */
+
+	err = 0;
+	goto out_success;
+
+ out_diropq:
+	if (au_ftest_ren(a->flags, DIROPQ))
+		au_ren_rev_diropq(err, a);
+ out_rename:
+	if (!au_ftest_ren(a->flags, CPUP))
+		au_ren_rev_rename(err, a);
+	else
+		au_ren_rev_cpup(err, a);
+ out_whtmp:
+	if (a->thargs)
+		au_ren_rev_whtmp(err, a);
+ out_whdst:
+	dput(a->dst_wh_dentry);
+	a->dst_wh_dentry = NULL;
+ out_whsrc:
+	if (a->src_wh_dentry)
+		au_ren_rev_whsrc(err, a);
+	au_ren_rev_drop(a);
+ out_success:
+	dput(a->src_wh_dentry);
+	dput(a->dst_wh_dentry);
+ out_thargs:
+	if (a->thargs) {
+		dput(a->h_dst);
+		kfree(a->thargs);
+	}
+ out:
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * test if @dentry dir can be rename destination or not.
+ * success means, it is a logically empty dir.
+ */
+static int may_rename_dstdir(struct dentry *dentry, struct au_nhash *whlist)
+{
+	return au_test_empty(dentry, whlist);
+}
+
+/*
+ * test if @dentry dir can be rename source or not.
+ * if it can, return 0 and @children is filled.
+ * success means,
+ * - it is a logically empty dir.
+ * - or, it exists on writable branch and has no children including whiteouts
+ *       on the lower branch.
+ */
+static int may_rename_srcdir(struct dentry *dentry, aufs_bindex_t btgt)
+{
+	int err;
+	aufs_bindex_t bstart;
+
+	bstart = au_dbstart(dentry);
+	if (bstart != btgt) {
+		struct au_nhash *whlist;
+
+		whlist = au_nhash_new(GFP_NOFS);
+		err = PTR_ERR(whlist);
+		if (IS_ERR(whlist))
+			goto out;
+		err = au_test_empty(dentry, whlist);
+		au_nhash_del(whlist);
+		goto out;
+	}
+
+	if (bstart == au_dbtaildir(dentry))
+		return 0; /* success */
+
+	err = au_test_empty_lower(dentry);
+
+ out:
+	if (err == -ENOTEMPTY) {
+		AuWarn1("renaming dir who has child(ren) on multiple branches,"
+			" is not supported\n");
+		err = -EXDEV;
+	}
+	return err;
+}
+
+/* side effect: sets whlist and h_dentry */
+static int au_ren_may_dir(struct au_ren_args *a)
+{
+	int err;
+	struct dentry *d;
+
+	err = 0;
+	au_nhash_init(&a->whlist);
+	d = a->dst_dentry;
+	if (au_ftest_ren(a->flags, ISDIR) && a->dst_inode) {
+		au_set_dbstart(d, a->dst_bstart);
+		err = may_rename_dstdir(d, &a->whlist);
+		au_set_dbstart(d, a->btgt);
+	}
+	a->dst_h_dentry = au_h_dptr(d, au_dbstart(d));
+	if (unlikely(err))
+		goto out;
+
+	d = a->src_dentry;
+	a->src_h_dentry = au_h_dptr(d, au_dbstart(d));
+	if (au_ftest_ren(a->flags, ISDIR)) {
+		err = may_rename_srcdir(d, a->btgt);
+		if (unlikely(err))
+			au_nhash_fin(&a->whlist);
+	}
+
+ out:
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * simple tests for rename.
+ * following the checks in vfs, plus the parent-child relationship.
+ */
+static int au_may_ren(struct au_ren_args *a)
+{
+	int err, isdir;
+	struct inode *h_inode;
+
+	if (a->src_bstart == a->btgt) {
+		err = au_may_del(a->src_dentry, a->btgt, a->src_h_parent,
+				 au_ftest_ren(a->flags, ISDIR));
+		if (unlikely(err))
+			goto out;
+		err = -EINVAL;
+		if (unlikely(a->src_h_dentry == a->h_trap))
+			goto out;
+	}
+
+	err = 0;
+	if (a->dst_bstart != a->btgt)
+		goto out;
+
+	err = -EIO;
+	h_inode = a->dst_h_dentry->d_inode;
+	isdir = !!au_ftest_ren(a->flags, ISDIR);
+	if (!a->dst_dentry->d_inode) {
+		if (unlikely(h_inode))
+			goto out;
+		err = au_may_add(a->dst_dentry, a->btgt, a->dst_h_parent,
+				 isdir);
+	} else {
+		if (unlikely(!h_inode || !h_inode->i_nlink))
+			goto out;
+		err = au_may_del(a->dst_dentry, a->btgt, a->dst_h_parent,
+				 isdir);
+		if (unlikely(err))
+			goto out;
+		err = -ENOTEMPTY;
+		if (unlikely(a->dst_h_dentry == a->h_trap))
+			goto out;
+		err = 0;
+	}
+
+ out:
+	if (unlikely(err == -ENOENT || err == -EEXIST))
+		err = -EIO;
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+/*
+ * locking order
+ * (VFS)
+ * - src_dir and dir by lock_rename()
+ * - inode if exitsts
+ * (aufs)
+ * - lock all
+ *   + src_dentry and dentry by aufs_read_and_write_lock2() which calls,
+ *     + si_read_lock
+ *     + di_write_lock2_child()
+ *       + di_write_lock_child()
+ *	   + ii_write_lock_child()
+ *       + di_write_lock_child2()
+ *	   + ii_write_lock_child2()
+ *     + src_parent and parent
+ *       + di_write_lock_parent()
+ *	   + ii_write_lock_parent()
+ *       + di_write_lock_parent2()
+ *	   + ii_write_lock_parent2()
+ *   + lower src_dir and dir by vfsub_lock_rename()
+ *   + verify the every relationships between child and parent. if any
+ *     of them failed, unlock all and return -EBUSY.
+ */
+static void au_ren_unlock(struct au_ren_args *a)
+{
+	struct super_block *sb;
+
+	sb = a->dst_dentry->d_sb;
+	if (au_ftest_ren(a->flags, MNT_WRITE))
+		mnt_drop_write(a->br->br_mnt);
+	vfsub_unlock_rename(a->src_h_parent, a->src_hdir,
+			    a->dst_h_parent, a->dst_hdir);
+}
+
+static int au_ren_lock(struct au_ren_args *a)
+{
+	int err;
+	unsigned int udba;
+
+	err = 0;
+	a->src_h_parent = au_h_dptr(a->src_parent, a->btgt);
+	a->src_hdir = au_hi(a->src_dir, a->btgt);
+	a->dst_h_parent = au_h_dptr(a->dst_parent, a->btgt);
+	a->dst_hdir = au_hi(a->dst_dir, a->btgt);
+	a->h_trap = vfsub_lock_rename(a->src_h_parent, a->src_hdir,
+				      a->dst_h_parent, a->dst_hdir);
+	udba = au_opt_udba(a->src_dentry->d_sb);
+	if (au_dbstart(a->src_dentry) == a->btgt)
+		err = au_h_verify(a->src_h_dentry, udba,
+				  a->src_h_parent->d_inode, a->src_h_parent,
+				  a->br);
+	if (!err && au_dbstart(a->dst_dentry) == a->btgt)
+		err = au_h_verify(a->dst_h_dentry, udba,
+				  a->dst_h_parent->d_inode, a->dst_h_parent,
+				  a->br);
+	if (!err) {
+		err = mnt_want_write(a->br->br_mnt);
+		if (unlikely(err))
+			goto out_unlock;
+		au_fset_ren(a->flags, MNT_WRITE);
+		goto out; /* success */
+	}
+
+	err = -EBUSY;
+
+ out_unlock:
+	au_ren_unlock(a);
+ out:
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static void au_ren_refresh_dir(struct au_ren_args *a)
+{
+	struct inode *dir;
+
+	dir = a->dst_dir;
+	dir->i_version++;
+	if (au_ftest_ren(a->flags, ISDIR)) {
+		/* is this updating defined in POSIX? */
+		au_cpup_attr_timesizes(a->src_inode);
+		au_cpup_attr_nlink(dir, /*force*/1);
+		if (a->dst_inode) {
+			clear_nlink(a->dst_inode);
+			au_cpup_attr_timesizes(a->dst_inode);
+		}
+	}
+	if (au_ibstart(dir) == a->btgt)
+		au_cpup_attr_timesizes(dir);
+
+	if (au_ftest_ren(a->flags, ISSAMEDIR))
+		return;
+
+	dir = a->src_dir;
+	dir->i_version++;
+	if (au_ftest_ren(a->flags, ISDIR))
+		au_cpup_attr_nlink(dir, /*force*/1);
+	if (au_ibstart(dir) == a->btgt)
+		au_cpup_attr_timesizes(dir);
+}
+
+static void au_ren_refresh(struct au_ren_args *a)
+{
+	aufs_bindex_t bend, bindex;
+	struct dentry *d, *h_d;
+	struct inode *i, *h_i;
+	struct super_block *sb;
+
+	d = a->src_dentry;
+	au_set_dbwh(d, -1);
+	bend = au_dbend(d);
+	for (bindex = a->btgt + 1; bindex <= bend; bindex++) {
+		h_d = au_h_dptr(d, bindex);
+		if (h_d)
+			au_set_h_dptr(d, bindex, NULL);
+	}
+	au_set_dbend(d, a->btgt);
+
+	sb = d->d_sb;
+	i = a->src_inode;
+	if (au_opt_test(au_mntflags(sb), PLINK) && au_plink_test(i))
+		return; /* success */
+
+	bend = au_ibend(i);
+	for (bindex = a->btgt + 1; bindex <= bend; bindex++) {
+		h_i = au_h_iptr(i, bindex);
+		if (h_i) {
+			au_xino_write0(sb, bindex, h_i->i_ino, 0);
+			/* ignore this error */
+			au_set_h_iptr(i, bindex, NULL, 0);
+		}
+	}
+	au_set_ibend(i, a->btgt);
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* mainly for link(2) and rename(2) */
+int au_wbr(struct dentry *dentry, aufs_bindex_t btgt)
+{
+	aufs_bindex_t bdiropq, bwh;
+	struct dentry *parent;
+	struct au_branch *br;
+
+	parent = dentry->d_parent;
+	IMustLock(parent->d_inode); /* dir is locked */
+
+	bdiropq = au_dbdiropq(parent);
+	bwh = au_dbwh(dentry);
+	br = au_sbr(dentry->d_sb, btgt);
+	if (au_br_rdonly(br)
+	    || (0 <= bdiropq && bdiropq < btgt)
+	    || (0 <= bwh && bwh < btgt))
+		btgt = -1;
+
+	AuDbg("btgt %d\n", btgt);
+	return btgt;
+}
+
+/* sets src_bstart, dst_bstart and btgt */
+static int au_ren_wbr(struct au_ren_args *a)
+{
+	int err;
+	struct au_wr_dir_args wr_dir_args = {
+		/* .force_btgt	= -1, */
+		.flags		= AuWrDir_ADD_ENTRY
+	};
+
+	a->src_bstart = au_dbstart(a->src_dentry);
+	a->dst_bstart = au_dbstart(a->dst_dentry);
+	if (au_ftest_ren(a->flags, ISDIR))
+		au_fset_wrdir(wr_dir_args.flags, ISDIR);
+	wr_dir_args.force_btgt = a->src_bstart;
+	if (a->dst_inode && a->dst_bstart < a->src_bstart)
+		wr_dir_args.force_btgt = a->dst_bstart;
+	wr_dir_args.force_btgt = au_wbr(a->dst_dentry, wr_dir_args.force_btgt);
+	err = au_wr_dir(a->dst_dentry, a->src_dentry, &wr_dir_args);
+	a->btgt = err;
+
+	return err;
+}
+
+static void au_ren_dt(struct au_ren_args *a)
+{
+	a->h_path.dentry = a->src_h_parent;
+	au_dtime_store(a->src_dt + AuPARENT, a->src_parent, &a->h_path);
+	if (!au_ftest_ren(a->flags, ISSAMEDIR)) {
+		a->h_path.dentry = a->dst_h_parent;
+		au_dtime_store(a->dst_dt + AuPARENT, a->dst_parent, &a->h_path);
+	}
+
+	au_fclr_ren(a->flags, DT_DSTDIR);
+	if (!au_ftest_ren(a->flags, ISDIR))
+		return;
+
+	a->h_path.dentry = a->src_h_dentry;
+	au_dtime_store(a->src_dt + AuCHILD, a->src_dentry, &a->h_path);
+	if (a->dst_h_dentry->d_inode) {
+		au_fset_ren(a->flags, DT_DSTDIR);
+		a->h_path.dentry = a->dst_h_dentry;
+		au_dtime_store(a->dst_dt + AuCHILD, a->dst_dentry, &a->h_path);
+	}
+}
+
+static void au_ren_rev_dt(int err, struct au_ren_args *a)
+{
+	struct dentry *h_d;
+	struct mutex *h_mtx;
+
+	au_dtime_revert(a->src_dt + AuPARENT);
+	if (!au_ftest_ren(a->flags, ISSAMEDIR))
+		au_dtime_revert(a->dst_dt + AuPARENT);
+
+	if (au_ftest_ren(a->flags, ISDIR) && err != -EIO) {
+		h_d = a->src_dt[AuCHILD].dt_h_path.dentry;
+		h_mtx = &h_d->d_inode->i_mutex;
+		mutex_lock_nested(h_mtx, AuLsc_I_CHILD);
+		au_dtime_revert(a->src_dt + AuCHILD);
+		mutex_unlock(h_mtx);
+
+		if (au_ftest_ren(a->flags, DT_DSTDIR)) {
+			h_d = a->dst_dt[AuCHILD].dt_h_path.dentry;
+			h_mtx = &h_d->d_inode->i_mutex;
+			mutex_lock_nested(h_mtx, AuLsc_I_CHILD);
+			au_dtime_revert(a->dst_dt + AuCHILD);
+			mutex_unlock(h_mtx);
+		}
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+int aufs_rename(struct inode *_src_dir, struct dentry *_src_dentry,
+		struct inode *_dst_dir, struct dentry *_dst_dentry)
+{
+	int err;
+	/* reduce stack space */
+	struct au_ren_args *a;
+
+	IMustLock(_src_dir);
+	IMustLock(_dst_dir);
+
+	err = -ENOMEM;
+	BUILD_BUG_ON(sizeof(*a) > PAGE_SIZE);
+	a = kzalloc(sizeof(*a), GFP_NOFS);
+	if (unlikely(!a))
+		goto out;
+
+	a->src_dir = _src_dir;
+	a->src_dentry = _src_dentry;
+	a->src_inode = a->src_dentry->d_inode;
+	a->src_parent = a->src_dentry->d_parent; /* dir inode is locked */
+	a->dst_dir = _dst_dir;
+	a->dst_dentry = _dst_dentry;
+	a->dst_inode = a->dst_dentry->d_inode;
+	a->dst_parent = a->dst_dentry->d_parent; /* dir inode is locked */
+	if (a->dst_inode) {
+		IMustLock(a->dst_inode);
+		au_igrab(a->dst_inode);
+	}
+
+	err = -ENOTDIR;
+	if (S_ISDIR(a->src_inode->i_mode)) {
+		au_fset_ren(a->flags, ISDIR);
+		if (unlikely(a->dst_inode && !S_ISDIR(a->dst_inode->i_mode)))
+			goto out_free;
+		aufs_read_and_write_lock2(a->dst_dentry, a->src_dentry,
+					  AuLock_DIR | AuLock_FLUSH);
+	} else
+		aufs_read_and_write_lock2(a->dst_dentry, a->src_dentry,
+					  AuLock_FLUSH);
+
+	au_fset_ren(a->flags, ISSAMEDIR); /* temporary */
+	di_write_lock_parent(a->dst_parent);
+
+	/* which branch we process */
+	err = au_ren_wbr(a);
+	if (unlikely(err < 0))
+		goto out_unlock;
+	a->br = au_sbr(a->dst_dentry->d_sb, a->btgt);
+	a->h_path.mnt = a->br->br_mnt;
+
+	/* are they available to be renamed */
+	err = au_ren_may_dir(a);
+	if (unlikely(err))
+		goto out_unlock;
+
+	/* prepare the writable parent dir on the same branch */
+	if (a->dst_bstart == a->btgt) {
+		au_fset_ren(a->flags, WHDST);
+	} else {
+		err = au_cpup_dirs(a->dst_dentry, a->btgt);
+		if (unlikely(err))
+			goto out_children;
+	}
+
+	if (a->src_dir != a->dst_dir) {
+		/*
+		 * this temporary unlock is safe,
+		 * because both dir->i_mutex are locked.
+		 */
+		di_write_unlock(a->dst_parent);
+		di_write_lock_parent(a->src_parent);
+		err = au_wr_dir_need_wh(a->src_dentry,
+					au_ftest_ren(a->flags, ISDIR),
+					&a->btgt);
+		di_write_unlock(a->src_parent);
+		di_write_lock2_parent(a->src_parent, a->dst_parent, /*isdir*/1);
+		au_fclr_ren(a->flags, ISSAMEDIR);
+	} else
+		err = au_wr_dir_need_wh(a->src_dentry,
+					au_ftest_ren(a->flags, ISDIR),
+					&a->btgt);
+	if (unlikely(err < 0))
+		goto out_children;
+	if (err)
+		au_fset_ren(a->flags, WHSRC);
+
+	/* lock them all */
+	err = au_ren_lock(a);
+	if (unlikely(err))
+		goto out_children;
+
+	if (!au_opt_test(au_mntflags(a->dst_dir->i_sb), UDBA_NONE)) {
+		err = au_may_ren(a);
+		if (unlikely(err))
+			goto out_hdir;
+	}
+
+	/* store timestamps to be revertible */
+	au_ren_dt(a);
+
+	/* here we go */
+	err = do_rename(a);
+	if (unlikely(err))
+		goto out_dt;
+
+	/* update dir attributes */
+	au_ren_refresh_dir(a);
+
+	/* dput/iput all lower dentries */
+	au_ren_refresh(a);
+
+	goto out_hdir; /* success */
+
+ out_dt:
+	au_ren_rev_dt(err, a);
+ out_hdir:
+	au_ren_unlock(a);
+ out_children:
+	au_nhash_fin(&a->whlist);
+ out_unlock:
+	if (unlikely(err && au_ftest_ren(a->flags, ISDIR))) {
+		au_update_dbstart(a->dst_dentry);
+		d_drop(a->dst_dentry);
+	}
+	if (!err) {
+		d_move(a->src_dentry, a->dst_dentry);
+		if (a->dst_inode
+		    && (a->dst_inode->i_nlink <= 1
+			|| au_ftest_ren(a->flags, ISDIR)))
+			a->dst_inode->i_flags |= S_DEAD;
+	}
+	if (au_ftest_ren(a->flags, ISSAMEDIR))
+		di_write_unlock(a->dst_parent);
+	else
+		di_write_unlock2(a->src_parent, a->dst_parent);
+	aufs_read_and_write_unlock2(a->dst_dentry, a->src_dentry);
+ out_free:
+	iput(a->dst_inode);
+	kfree(a);
+ out:
+	return err;
+}
diff --git a/fs/aufs/iinfo.c b/fs/aufs/iinfo.c
new file mode 100644
index 0000000..ed9c55c
--- /dev/null
+++ b/fs/aufs/iinfo.c
@@ -0,0 +1,257 @@
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
+ * inode private data
+ */
+
+#include "aufs.h"
+
+struct inode *au_h_iptr(struct inode *inode, aufs_bindex_t bindex)
+{
+	struct inode *h_inode;
+
+	h_inode = au_ii(inode)->ii_hinode[0 + bindex].hi_inode;
+	AuDebugOn(h_inode && atomic_read(&h_inode->i_count) <= 0);
+	return h_inode;
+}
+
+/* todo: hard/soft set? */
+void au_set_ibstart(struct inode *inode, aufs_bindex_t bindex)
+{
+	struct au_iinfo *iinfo = au_ii(inode);
+	struct inode *h_inode;
+
+	iinfo->ii_bstart = bindex;
+	h_inode = iinfo->ii_hinode[bindex + 0].hi_inode;
+	if (h_inode)
+		au_cpup_igen(inode, h_inode);
+}
+
+void au_hiput(struct au_hinode *hinode)
+{
+	au_hin_free(hinode);
+	dput(hinode->hi_whdentry);
+	iput(hinode->hi_inode);
+}
+
+unsigned int au_hi_flags(struct inode *inode, int isdir)
+{
+	unsigned int flags;
+	const unsigned int mnt_flags = au_mntflags(inode->i_sb);
+
+	flags = 0;
+	if (au_opt_test(mnt_flags, XINO))
+		au_fset_hi(flags, XINO);
+	if (isdir && au_opt_test(mnt_flags, UDBA_HINOTIFY))
+		au_fset_hi(flags, HINOTIFY);
+	return flags;
+}
+
+void au_set_h_iptr(struct inode *inode, aufs_bindex_t bindex,
+		   struct inode *h_inode, unsigned int flags)
+{
+	struct au_hinode *hinode;
+	struct inode *hi;
+	struct au_iinfo *iinfo = au_ii(inode);
+
+	hinode = iinfo->ii_hinode + bindex;
+	hi = hinode->hi_inode;
+	AuDebugOn(h_inode && atomic_read(&h_inode->i_count) <= 0);
+	AuDebugOn(h_inode && hi);
+
+	if (hi)
+		au_hiput(hinode);
+	hinode->hi_inode = h_inode;
+	if (h_inode) {
+		int err;
+		struct super_block *sb = inode->i_sb;
+		struct au_branch *br;
+
+		if (bindex == iinfo->ii_bstart)
+			au_cpup_igen(inode, h_inode);
+		br = au_sbr(sb, bindex);
+		hinode->hi_id = br->br_id;
+		if (au_ftest_hi(flags, XINO)) {
+			err = au_xino_write(sb, bindex, h_inode->i_ino,
+					    inode->i_ino);
+			if (unlikely(err))
+				AuIOErr1("failed au_xino_write() %d\n", err);
+		}
+
+		if (au_ftest_hi(flags, HINOTIFY)
+		    && au_br_hinotifyable(br->br_perm)) {
+			err = au_hin_alloc(hinode, inode, h_inode);
+			if (unlikely(err))
+				AuIOErr1("au_hin_alloc() %d\n", err);
+		}
+	}
+}
+
+void au_set_hi_wh(struct inode *inode, aufs_bindex_t bindex,
+		  struct dentry *h_wh)
+{
+	struct au_hinode *hinode;
+
+	hinode = au_ii(inode)->ii_hinode + bindex;
+	AuDebugOn(hinode->hi_whdentry);
+	hinode->hi_whdentry = h_wh;
+}
+
+void au_update_iigen(struct inode *inode)
+{
+	atomic_set(&au_ii(inode)->ii_generation, au_sigen(inode->i_sb));
+	/* smp_mb(); */ /* atomic_set */
+}
+
+/* it may be called at remount time, too */
+void au_update_brange(struct inode *inode, int do_put_zero)
+{
+	struct au_iinfo *iinfo;
+
+	iinfo = au_ii(inode);
+	if (!iinfo || iinfo->ii_bstart < 0)
+		return;
+
+	if (do_put_zero) {
+		aufs_bindex_t bindex;
+
+		for (bindex = iinfo->ii_bstart; bindex <= iinfo->ii_bend;
+		     bindex++) {
+			struct inode *h_i;
+
+			h_i = iinfo->ii_hinode[0 + bindex].hi_inode;
+			if (h_i && !h_i->i_nlink)
+				au_set_h_iptr(inode, bindex, NULL, 0);
+		}
+	}
+
+	iinfo->ii_bstart = -1;
+	while (++iinfo->ii_bstart <= iinfo->ii_bend)
+		if (iinfo->ii_hinode[0 + iinfo->ii_bstart].hi_inode)
+			break;
+	if (iinfo->ii_bstart > iinfo->ii_bend) {
+		iinfo->ii_bstart = -1;
+		iinfo->ii_bend = -1;
+		return;
+	}
+
+	iinfo->ii_bend++;
+	while (0 <= --iinfo->ii_bend)
+		if (iinfo->ii_hinode[0 + iinfo->ii_bend].hi_inode)
+			break;
+	AuDebugOn(iinfo->ii_bstart > iinfo->ii_bend || iinfo->ii_bend < 0);
+}
+
+/* ---------------------------------------------------------------------- */
+
+int au_iinfo_init(struct inode *inode)
+{
+	struct au_iinfo *iinfo;
+	struct super_block *sb;
+	int nbr, i;
+
+	sb = inode->i_sb;
+	iinfo = &(container_of(inode, struct au_icntnr, vfs_inode)->iinfo);
+	nbr = au_sbend(sb) + 1;
+	if (unlikely(nbr <= 0))
+		nbr = 1;
+	iinfo->ii_hinode = kcalloc(nbr, sizeof(*iinfo->ii_hinode), GFP_NOFS);
+	if (iinfo->ii_hinode) {
+		for (i = 0; i < nbr; i++)
+			iinfo->ii_hinode[i].hi_id = -1;
+
+		atomic_set(&iinfo->ii_generation, au_sigen(sb));
+		/* smp_mb(); */ /* atomic_set */
+		init_rwsem(&iinfo->ii_rwsem);
+		iinfo->ii_bstart = -1;
+		iinfo->ii_bend = -1;
+		iinfo->ii_vdir = NULL;
+		return 0;
+	}
+	return -ENOMEM;
+}
+
+int au_ii_realloc(struct au_iinfo *iinfo, int nbr)
+{
+	int err, sz;
+	struct au_hinode *hip;
+
+	err = -ENOMEM;
+	sz = sizeof(*hip) * (iinfo->ii_bend + 1);
+	if (!sz)
+		sz = sizeof(*hip);
+	hip = au_kzrealloc(iinfo->ii_hinode, sz, sizeof(*hip) * nbr, GFP_NOFS);
+	if (hip) {
+		iinfo->ii_hinode = hip;
+		err = 0;
+	}
+
+	return err;
+}
+
+static int au_iinfo_write0(struct super_block *sb, struct au_hinode *hinode,
+			   ino_t ino)
+{
+	int err;
+	aufs_bindex_t bindex;
+	unsigned char locked;
+
+	err = 0;
+	locked = !!si_noflush_read_trylock(sb);
+	bindex = au_br_index(sb, hinode->hi_id);
+	if (bindex >= 0)
+		err = au_xino_write0(sb, bindex, hinode->hi_inode->i_ino, ino);
+	/* error action? */
+	if (locked)
+		si_read_unlock(sb);
+	return err;
+}
+
+void au_iinfo_fin(struct inode *inode)
+{
+	ino_t ino;
+	aufs_bindex_t bend;
+	unsigned char unlinked;
+	struct au_iinfo *iinfo;
+	struct au_hinode *hi;
+	struct super_block *sb;
+
+	iinfo = au_ii(inode);
+	/* bad_inode case */
+	if (!iinfo)
+		return;
+
+	if (iinfo->ii_vdir)
+		au_vdir_free(iinfo->ii_vdir);
+
+	if (iinfo->ii_bstart >= 0) {
+		sb = inode->i_sb;
+		unlinked = !inode->i_nlink;
+		ino = 0;
+		if (unlinked)
+			ino = inode->i_ino;
+		hi = iinfo->ii_hinode + iinfo->ii_bstart;
+		bend = iinfo->ii_bend;
+		while (iinfo->ii_bstart++ <= bend) {
+			if (hi->hi_inode) {
+				if (unlinked || !hi->hi_inode->i_nlink) {
+					au_iinfo_write0(sb, hi, ino);
+					/* ignore this error */
+					ino = 0;
+				}
+				au_hiput(hi);
+			}
+			hi++;
+		}
+	}
+
+	kfree(iinfo->ii_hinode);
+	au_rwsem_destroy(&iinfo->ii_rwsem);
+}
diff --git a/fs/aufs/inode.c b/fs/aufs/inode.c
new file mode 100644
index 0000000..c4a962b
--- /dev/null
+++ b/fs/aufs/inode.c
@@ -0,0 +1,356 @@
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
+ * inode functions
+ */
+
+#include "aufs.h"
+
+static void au_refresh_hinode_attr(struct inode *inode, int do_version)
+{
+	au_cpup_attr_all(inode, /*force*/0);
+	au_update_iigen(inode);
+	if (do_version)
+		inode->i_version++;
+}
+
+int au_refresh_hinode_self(struct inode *inode, int do_attr)
+{
+	int err;
+	aufs_bindex_t bindex, new_bindex;
+	unsigned char update;
+	struct inode *first;
+	struct au_hinode *p, *q, tmp;
+	struct super_block *sb;
+	struct au_iinfo *iinfo;
+
+	update = 0;
+	sb = inode->i_sb;
+	iinfo = au_ii(inode);
+	err = au_ii_realloc(iinfo, au_sbend(sb) + 1);
+	if (unlikely(err))
+		goto out;
+
+	p = iinfo->ii_hinode + iinfo->ii_bstart;
+	first = p->hi_inode;
+	err = 0;
+	for (bindex = iinfo->ii_bstart; bindex <= iinfo->ii_bend;
+	     bindex++, p++) {
+		if (!p->hi_inode)
+			continue;
+
+		new_bindex = au_br_index(sb, p->hi_id);
+		if (new_bindex == bindex)
+			continue;
+
+		if (new_bindex < 0) {
+			update++;
+			au_hiput(p);
+			p->hi_inode = NULL;
+			continue;
+		}
+
+		if (new_bindex < iinfo->ii_bstart)
+			iinfo->ii_bstart = new_bindex;
+		if (iinfo->ii_bend < new_bindex)
+			iinfo->ii_bend = new_bindex;
+		/* swap two lower inode, and loop again */
+		q = iinfo->ii_hinode + new_bindex;
+		tmp = *q;
+		*q = *p;
+		*p = tmp;
+		if (tmp.hi_inode) {
+			bindex--;
+			p--;
+		}
+	}
+	au_update_brange(inode, /*do_put_zero*/0);
+	if (do_attr)
+		au_refresh_hinode_attr(inode, update && S_ISDIR(inode->i_mode));
+
+ out:
+	return err;
+}
+
+int au_refresh_hinode(struct inode *inode, struct dentry *dentry)
+{
+	int err, update;
+	unsigned int flags;
+	aufs_bindex_t bindex, bend;
+	unsigned char isdir;
+	struct inode *first;
+	struct au_hinode *p;
+	struct au_iinfo *iinfo;
+
+	err = au_refresh_hinode_self(inode, /*do_attr*/0);
+	if (unlikely(err))
+		goto out;
+
+	update = 0;
+	iinfo = au_ii(inode);
+	p = iinfo->ii_hinode + iinfo->ii_bstart;
+	first = p->hi_inode;
+	isdir = S_ISDIR(inode->i_mode);
+	flags = au_hi_flags(inode, isdir);
+	bend = au_dbend(dentry);
+	for (bindex = au_dbstart(dentry); bindex <= bend; bindex++) {
+		struct inode *h_i;
+		struct dentry *h_d;
+
+		h_d = au_h_dptr(dentry, bindex);
+		if (!h_d || !h_d->d_inode)
+			continue;
+
+		if (iinfo->ii_bstart <= bindex && bindex <= iinfo->ii_bend) {
+			h_i = au_h_iptr(inode, bindex);
+			if (h_i) {
+				if (h_i == h_d->d_inode)
+					continue;
+				err = -EIO;
+				break;
+			}
+		}
+		if (bindex < iinfo->ii_bstart)
+			iinfo->ii_bstart = bindex;
+		if (iinfo->ii_bend < bindex)
+			iinfo->ii_bend = bindex;
+		au_set_h_iptr(inode, bindex, au_igrab(h_d->d_inode), flags);
+		update = 1;
+	}
+	au_update_brange(inode, /*do_put_zero*/0);
+
+	if (unlikely(err))
+		goto out;
+
+	au_refresh_hinode_attr(inode, update && isdir);
+
+ out:
+	return err;
+}
+
+static int set_inode(struct inode *inode, struct dentry *dentry)
+{
+	int err;
+	unsigned int flags;
+	umode_t mode;
+	aufs_bindex_t bindex, bstart, btail;
+	unsigned char isdir;
+	struct dentry *h_dentry;
+	struct inode *h_inode;
+	struct au_iinfo *iinfo;
+
+	err = 0;
+	isdir = 0;
+	bstart = au_dbstart(dentry);
+	h_inode = au_h_dptr(dentry, bstart)->d_inode;
+	mode = h_inode->i_mode;
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+		btail = au_dbtail(dentry);
+		inode->i_op = &aufs_iop;
+		inode->i_fop = &aufs_file_fop;
+		inode->i_mapping->a_ops = &aufs_aop;
+		break;
+	case S_IFDIR:
+		isdir = 1;
+		btail = au_dbtaildir(dentry);
+		inode->i_op = &aufs_dir_iop;
+		inode->i_fop = &aufs_dir_fop;
+		break;
+	case S_IFLNK:
+		btail = au_dbtail(dentry);
+		inode->i_op = &aufs_symlink_iop;
+		break;
+	case S_IFBLK:
+	case S_IFCHR:
+	case S_IFIFO:
+	case S_IFSOCK:
+		btail = au_dbtail(dentry);
+		inode->i_op = &aufs_iop;
+		init_special_inode(inode, mode, h_inode->i_rdev);
+		break;
+	default:
+		AuIOErr("Unknown file type 0%o\n", mode);
+		err = -EIO;
+		goto out;
+	}
+
+	flags = au_hi_flags(inode, isdir);
+	iinfo = au_ii(inode);
+	iinfo->ii_bstart = bstart;
+	iinfo->ii_bend = btail;
+	for (bindex = bstart; bindex <= btail; bindex++) {
+		h_dentry = au_h_dptr(dentry, bindex);
+		if (h_dentry)
+			au_set_h_iptr(inode, bindex,
+				      au_igrab(h_dentry->d_inode), flags);
+	}
+	au_cpup_attr_all(inode, /*force*/1);
+
+ out:
+	return err;
+}
+
+/* successful returns with iinfo write_locked */
+static int reval_inode(struct inode *inode, struct dentry *dentry, int *matched)
+{
+	int err;
+	aufs_bindex_t bindex, bend;
+	struct inode *h_inode, *h_dinode;
+
+	*matched = 0;
+
+	/*
+	 * before this function, if aufs got any iinfo lock, it must be only
+	 * one, the parent dir.
+	 * it can happen by UDBA and the obsoleted inode number.
+	 */
+	err = -EIO;
+	if (unlikely(inode->i_ino == parent_ino(dentry)))
+		goto out;
+
+	ii_write_lock_new_child(inode);
+	if (unlikely(IS_DEADDIR(inode)))
+		goto out_unlock;
+
+	err = 0;
+	h_dinode = au_h_dptr(dentry, au_dbstart(dentry))->d_inode;
+	bend = au_ibend(inode);
+	for (bindex = au_ibstart(inode); bindex <= bend; bindex++) {
+		h_inode = au_h_iptr(inode, bindex);
+		if (h_inode && h_inode == h_dinode) {
+			*matched = 1;
+			err = 0;
+			if (au_iigen(inode) != au_digen(dentry))
+				err = au_refresh_hinode(inode, dentry);
+			break;
+		}
+	}
+
+ out_unlock:
+	if (unlikely(err))
+		ii_write_unlock(inode);
+ out:
+	return err;
+}
+
+/* successful returns with iinfo write_locked */
+/* todo: return with unlocked? */
+struct inode *au_new_inode(struct dentry *dentry, int must_new)
+{
+	struct inode *inode;
+	struct dentry *h_dentry;
+	struct super_block *sb;
+	ino_t h_ino, ino;
+	int err, match;
+	aufs_bindex_t bstart;
+
+	sb = dentry->d_sb;
+	bstart = au_dbstart(dentry);
+	h_dentry = au_h_dptr(dentry, bstart);
+	h_ino = h_dentry->d_inode->i_ino;
+	err = au_xino_read(sb, bstart, h_ino, &ino);
+	inode = ERR_PTR(err);
+	if (unlikely(err))
+		goto out;
+ new_ino:
+	if (!ino) {
+		ino = au_xino_new_ino(sb);
+		if (unlikely(!ino)) {
+			inode = ERR_PTR(-EIO);
+			goto out;
+		}
+	}
+
+	AuDbg("i%lu\n", (unsigned long)ino);
+	inode = au_iget_locked(sb, ino);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out;
+
+	AuDbg("%lx, new %d\n", inode->i_state, !!(inode->i_state & I_NEW));
+	if (inode->i_state & I_NEW) {
+		ii_write_lock_new_child(inode);
+		err = set_inode(inode, dentry);
+		unlock_new_inode(inode);
+		if (!err)
+			goto out; /* success */
+
+		iget_failed(inode);
+		ii_write_unlock(inode);
+		goto out_iput;
+	} else if (!must_new) {
+		err = reval_inode(inode, dentry, &match);
+		if (!err)
+			goto out; /* success */
+		else if (match)
+			goto out_iput;
+	}
+
+	if (unlikely(au_test_fs_unique_ino(h_dentry->d_inode)))
+		AuWarn1("Un-notified UDBA or repeatedly renamed dir,"
+			" b%d, %s, %.*s, hi%lu, i%lu.\n",
+			bstart, au_sbtype(h_dentry->d_sb), AuDLNPair(dentry),
+			(unsigned long)h_ino, (unsigned long)ino);
+	ino = 0;
+	err = au_xino_write0(sb, bstart, h_ino, 0);
+	if (!err) {
+		iput(inode);
+		goto new_ino;
+	}
+
+ out_iput:
+	iput(inode);
+	inode = ERR_PTR(err);
+ out:
+	return inode;
+}
+
+/* ---------------------------------------------------------------------- */
+
+int au_test_ro(struct super_block *sb, aufs_bindex_t bindex,
+	       struct inode *inode)
+{
+	int err;
+
+	err = au_br_rdonly(au_sbr(sb, bindex));
+
+	/* pseudo-link after flushed may happen out of bounds */
+	if (!err
+	    && inode
+	    && au_ibstart(inode) <= bindex
+	    && bindex <= au_ibend(inode)) {
+		/*
+		 * permission check is unnecessary since vfsub routine
+		 * will be called later
+		 */
+		struct inode *hi = au_h_iptr(inode, bindex);
+		if (hi)
+			err = IS_IMMUTABLE(hi) ? -EROFS : 0;
+	}
+
+	return err;
+}
+
+int au_test_h_perm(struct inode *h_inode, int mask)
+{
+	if (!current_fsuid())
+		return 0;
+	return inode_permission(h_inode, mask);
+}
+
+int au_test_h_perm_sio(struct inode *h_inode, int mask)
+{
+	if (au_test_nfs(h_inode->i_sb)
+	    && (mask & MAY_WRITE)
+	    && S_ISDIR(h_inode->i_mode))
+		mask |= MAY_READ; /* force permission check */
+	return au_test_h_perm(h_inode, mask);
+}
diff --git a/fs/aufs/inode.h b/fs/aufs/inode.h
new file mode 100644
index 0000000..ffda951
--- /dev/null
+++ b/fs/aufs/inode.h
@@ -0,0 +1,471 @@
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
+ * inode operations
+ */
+
+#ifndef __AUFS_INODE_H__
+#define __AUFS_INODE_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/inotify.h>
+#include <linux/namei.h>
+#include <linux/aufs_type.h>
+#include "rwsem.h"
+
+struct au_hinotify {
+#ifdef CONFIG_AUFS_HINOTIFY
+	struct inotify_watch	hin_watch;
+	struct inode		*hin_aufs_inode;	/* no get/put */
+#endif
+};
+
+struct au_hinode {
+	struct inode		*hi_inode;
+	aufs_bindex_t		hi_id;
+#ifdef CONFIG_AUFS_HINOTIFY
+	struct au_hinotify	*hi_notify;
+#endif
+
+	/* reference to the copied-up whiteout with get/put */
+	struct dentry		*hi_whdentry;
+};
+
+struct au_vdir;
+struct au_iinfo {
+	atomic_t		ii_generation;
+	struct super_block	*ii_hsb1;	/* no get/put */
+
+	struct rw_semaphore	ii_rwsem;
+	aufs_bindex_t		ii_bstart, ii_bend;
+	__u32			ii_higen;
+	struct au_hinode	*ii_hinode;
+	struct au_vdir		*ii_vdir;
+};
+
+struct au_icntnr {
+	struct au_iinfo iinfo;
+	struct inode vfs_inode;
+};
+
+/* au_pin flags */
+#define AuPin_DI_LOCKED		1
+#define AuPin_MNT_WRITE		(1 << 1)
+#define au_ftest_pin(flags, name)	((flags) & AuPin_##name)
+#define au_fset_pin(flags, name)	{ (flags) |= AuPin_##name; }
+#define au_fclr_pin(flags, name)	{ (flags) &= ~AuPin_##name; }
+
+struct au_pin {
+	/* input */
+	struct dentry *dentry;
+	unsigned int udba;
+	unsigned char lsc_di, lsc_hi, flags;
+	aufs_bindex_t bindex;
+
+	/* output */
+	struct dentry *parent;
+	struct au_hinode *hdir;
+	struct vfsmount *h_mnt;
+};
+
+/* ---------------------------------------------------------------------- */
+
+static inline struct au_iinfo *au_ii(struct inode *inode)
+{
+	struct au_iinfo *iinfo;
+
+	iinfo = &(container_of(inode, struct au_icntnr, vfs_inode)->iinfo);
+	if (iinfo->ii_hinode)
+		return iinfo;
+	return NULL; /* debugging bad_inode case */
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* inode.c */
+int au_refresh_hinode_self(struct inode *inode, int do_attr);
+int au_refresh_hinode(struct inode *inode, struct dentry *dentry);
+struct inode *au_new_inode(struct dentry *dentry, int must_new);
+int au_test_ro(struct super_block *sb, aufs_bindex_t bindex,
+	       struct inode *inode);
+int au_test_h_perm(struct inode *h_inode, int mask);
+int au_test_h_perm_sio(struct inode *h_inode, int mask);
+
+/* i_op.c */
+extern struct inode_operations aufs_iop, aufs_symlink_iop, aufs_dir_iop;
+
+/* au_wr_dir flags */
+#define AuWrDir_ADD_ENTRY	1
+#define AuWrDir_ISDIR		(1 << 1)
+#define au_ftest_wrdir(flags, name)	((flags) & AuWrDir_##name)
+#define au_fset_wrdir(flags, name)	{ (flags) |= AuWrDir_##name; }
+#define au_fclr_wrdir(flags, name)	{ (flags) &= ~AuWrDir_##name; }
+
+struct au_wr_dir_args {
+	aufs_bindex_t force_btgt;
+	unsigned char flags;
+};
+int au_wr_dir(struct dentry *dentry, struct dentry *src_dentry,
+	      struct au_wr_dir_args *args);
+
+struct dentry *au_pinned_h_parent(struct au_pin *pin);
+void au_pin_init(struct au_pin *pin, struct dentry *dentry,
+		 aufs_bindex_t bindex, int lsc_di, int lsc_hi,
+		 unsigned int udba, unsigned char flags);
+int au_pin(struct au_pin *pin, struct dentry *dentry, aufs_bindex_t bindex,
+	   unsigned int udba, unsigned char flags) __must_check;
+int au_do_pin(struct au_pin *pin) __must_check;
+void au_unpin(struct au_pin *pin);
+
+/* i_op_add.c */
+int au_may_add(struct dentry *dentry, aufs_bindex_t bindex,
+	       struct dentry *h_parent, int isdir);
+int aufs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
+int aufs_symlink(struct inode *dir, struct dentry *dentry, const char *symname);
+int aufs_create(struct inode *dir, struct dentry *dentry, int mode,
+		struct nameidata *nd);
+int aufs_link(struct dentry *src_dentry, struct inode *dir,
+	      struct dentry *dentry);
+int aufs_mkdir(struct inode *dir, struct dentry *dentry, int mode);
+
+/* i_op_del.c */
+int au_wr_dir_need_wh(struct dentry *dentry, int isdir, aufs_bindex_t *bcpup);
+int au_may_del(struct dentry *dentry, aufs_bindex_t bindex,
+	       struct dentry *h_parent, int isdir);
+int aufs_unlink(struct inode *dir, struct dentry *dentry);
+int aufs_rmdir(struct inode *dir, struct dentry *dentry);
+
+/* i_op_ren.c */
+int au_wbr(struct dentry *dentry, aufs_bindex_t btgt);
+int aufs_rename(struct inode *src_dir, struct dentry *src_dentry,
+		struct inode *dir, struct dentry *dentry);
+
+/* iinfo.c */
+struct inode *au_h_iptr(struct inode *inode, aufs_bindex_t bindex);
+void au_hiput(struct au_hinode *hinode);
+void au_set_ibstart(struct inode *inode, aufs_bindex_t bindex);
+void au_set_hi_wh(struct inode *inode, aufs_bindex_t bindex,
+		  struct dentry *h_wh);
+unsigned int au_hi_flags(struct inode *inode, int isdir);
+
+/* hinode flags */
+#define AuHi_XINO	1
+#define AuHi_HINOTIFY	(1 << 1)
+#define au_ftest_hi(flags, name)	((flags) & AuHi_##name)
+#define au_fset_hi(flags, name)		{ (flags) |= AuHi_##name; }
+#define au_fclr_hi(flags, name)		{ (flags) &= ~AuHi_##name; }
+
+#ifndef CONFIG_AUFS_HINOTIFY
+#undef AuHi_HINOTIFY
+#define AuHi_HINOTIFY	0
+#endif
+
+void au_set_h_iptr(struct inode *inode, aufs_bindex_t bindex,
+		   struct inode *h_inode, unsigned int flags);
+
+void au_update_iigen(struct inode *inode);
+void au_update_brange(struct inode *inode, int do_put_zero);
+
+int au_iinfo_init(struct inode *inode);
+void au_iinfo_fin(struct inode *inode);
+int au_ii_realloc(struct au_iinfo *iinfo, int nbr);
+
+/* plink.c */
+void au_plink_block_maintain(struct super_block *sb);
+#ifdef CONFIG_AUFS_DEBUG
+void au_plink_list(struct super_block *sb);
+#else
+static inline void au_plink_list(struct super_block *sb)
+{
+	/* nothing */
+}
+#endif
+int au_plink_test(struct inode *inode);
+struct dentry *au_plink_lkup(struct inode *inode, aufs_bindex_t bindex);
+void au_plink_append(struct inode *inode, aufs_bindex_t bindex,
+		     struct dentry *h_dentry);
+void au_plink_put(struct super_block *sb);
+void au_plink_half_refresh(struct super_block *sb, aufs_bindex_t br_id);
+
+/* ---------------------------------------------------------------------- */
+
+/* lock subclass for iinfo */
+enum {
+	AuLsc_II_CHILD,		/* child first */
+	AuLsc_II_CHILD2,	/* rename(2), link(2), and cpup at hinotify */
+	AuLsc_II_CHILD3,	/* copyup dirs */
+	AuLsc_II_PARENT,	/* see AuLsc_I_PARENT in vfsub.h */
+	AuLsc_II_PARENT2,
+	AuLsc_II_PARENT3,	/* copyup dirs */
+	AuLsc_II_NEW_CHILD
+};
+
+/*
+ * ii_read_lock_child, ii_write_lock_child,
+ * ii_read_lock_child2, ii_write_lock_child2,
+ * ii_read_lock_child3, ii_write_lock_child3,
+ * ii_read_lock_parent, ii_write_lock_parent,
+ * ii_read_lock_parent2, ii_write_lock_parent2,
+ * ii_read_lock_parent3, ii_write_lock_parent3,
+ * ii_read_lock_new_child, ii_write_lock_new_child,
+ */
+#define AuReadLockFunc(name, lsc) \
+static inline void ii_read_lock_##name(struct inode *i) \
+{ \
+	down_read_nested(&au_ii(i)->ii_rwsem, AuLsc_II_##lsc); \
+}
+
+#define AuWriteLockFunc(name, lsc) \
+static inline void ii_write_lock_##name(struct inode *i) \
+{ \
+	down_write_nested(&au_ii(i)->ii_rwsem, AuLsc_II_##lsc); \
+}
+
+#define AuRWLockFuncs(name, lsc) \
+	AuReadLockFunc(name, lsc) \
+	AuWriteLockFunc(name, lsc)
+
+AuRWLockFuncs(child, CHILD);
+AuRWLockFuncs(child2, CHILD2);
+AuRWLockFuncs(child3, CHILD3);
+AuRWLockFuncs(parent, PARENT);
+AuRWLockFuncs(parent2, PARENT2);
+AuRWLockFuncs(parent3, PARENT3);
+AuRWLockFuncs(new_child, NEW_CHILD);
+
+#undef AuReadLockFunc
+#undef AuWriteLockFunc
+#undef AuRWLockFuncs
+
+/*
+ * ii_read_unlock, ii_write_unlock, ii_downgrade_lock
+ */
+AuSimpleUnlockRwsemFuncs(ii, struct inode *i, &au_ii(i)->ii_rwsem);
+
+#define IiMustNoWaiters(i)	AuRwMustNoWaiters(&au_ii(i)->ii_rwsem)
+
+/* ---------------------------------------------------------------------- */
+
+static inline unsigned int au_iigen(struct inode *inode)
+{
+	return atomic_read(&au_ii(inode)->ii_generation);
+}
+
+/* tiny test for inode number */
+/* tmpfs generation is too rough */
+static inline int au_test_higen(struct inode *inode, struct inode *h_inode)
+{
+	struct au_iinfo *iinfo;
+
+	iinfo = au_ii(inode);
+	return !(iinfo->ii_hsb1 == h_inode->i_sb
+		 && iinfo->ii_higen == h_inode->i_generation);
+}
+
+static inline struct inode *au_igrab(struct inode *inode)
+{
+	if (inode) {
+		AuDebugOn(!atomic_read(&inode->i_count));
+		atomic_inc(&inode->i_count);
+	}
+	return inode;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static inline aufs_bindex_t au_ii_br_id(struct inode *inode,
+					aufs_bindex_t bindex)
+{
+	return au_ii(inode)->ii_hinode[0 + bindex].hi_id;
+}
+
+static inline aufs_bindex_t au_ibstart(struct inode *inode)
+{
+	return au_ii(inode)->ii_bstart;
+}
+
+static inline aufs_bindex_t au_ibend(struct inode *inode)
+{
+	return au_ii(inode)->ii_bend;
+}
+
+static inline struct au_vdir *au_ivdir(struct inode *inode)
+{
+	return au_ii(inode)->ii_vdir;
+}
+
+static inline struct dentry *au_hi_wh(struct inode *inode, aufs_bindex_t bindex)
+{
+	return au_ii(inode)->ii_hinode[0 + bindex].hi_whdentry;
+}
+
+static inline void au_set_ibend(struct inode *inode, aufs_bindex_t bindex)
+{
+	au_ii(inode)->ii_bend = bindex;
+}
+
+static inline void au_set_ivdir(struct inode *inode, struct au_vdir *vdir)
+{
+	au_ii(inode)->ii_vdir = vdir;
+}
+
+static inline struct au_hinode *au_hi(struct inode *inode, aufs_bindex_t bindex)
+{
+	return au_ii(inode)->ii_hinode + bindex;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static inline struct dentry *au_pinned_parent(struct au_pin *pin)
+{
+	if (pin)
+		return pin->parent;
+	return NULL;
+}
+
+static inline struct inode *au_pinned_h_dir(struct au_pin *pin)
+{
+	if (pin && pin->hdir)
+		return pin->hdir->hi_inode;
+	return NULL;
+}
+
+static inline struct au_hinode *au_pinned_hdir(struct au_pin *pin)
+{
+	if (pin)
+		return pin->hdir;
+	return NULL;
+}
+
+static inline void au_pin_set_dentry(struct au_pin *pin, struct dentry *dentry)
+{
+	if (pin)
+		pin->dentry = dentry;
+}
+
+static inline void au_pin_set_parent_lflag(struct au_pin *pin,
+					   unsigned char lflag)
+{
+	if (pin) {
+		/* dirty macros require brackets */
+		if (lflag) {
+			au_fset_pin(pin->flags, DI_LOCKED);
+		} else {
+			au_fclr_pin(pin->flags, DI_LOCKED);
+		}
+	}
+}
+
+static inline void au_pin_set_parent(struct au_pin *pin, struct dentry *parent)
+{
+	if (pin) {
+		dput(pin->parent);
+		pin->parent = dget(parent);
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+#ifdef CONFIG_AUFS_HINOTIFY
+/* hinotify.c */
+int au_hin_alloc(struct au_hinode *hinode, struct inode *inode,
+		 struct inode *h_inode);
+void au_hin_free(struct au_hinode *hinode);
+void au_hin_ctl(struct au_hinode *hinode, int do_set);
+void au_reset_hinotify(struct inode *inode, unsigned int flags);
+
+int __init au_hinotify_init(void);
+void au_hinotify_fin(void);
+
+static inline
+void au_hin_init(struct au_hinode *hinode, struct au_hinotify *val)
+{
+	hinode->hi_notify = val;
+}
+
+static inline void au_iigen_dec(struct inode *inode)
+{
+	atomic_dec(&au_ii(inode)->ii_generation);
+}
+
+#else
+static inline
+int au_hin_alloc(struct au_hinode *hinode __maybe_unused,
+		 struct inode *inode __maybe_unused,
+		 struct inode *h_inode __maybe_unused)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void au_hin_free(struct au_hinode *hinode __maybe_unused)
+{
+	/* nothing */
+}
+
+static inline void au_hin_ctl(struct au_hinode *hinode __maybe_unused,
+			      int do_set __maybe_unused)
+{
+	/* nothing */
+}
+
+static inline void au_reset_hinotify(struct inode *inode __maybe_unused,
+				     unsigned int flags __maybe_unused)
+{
+	/* nothing */
+}
+
+static inline int au_hinotify_init(void)
+{
+	return 0;
+}
+
+#define au_hinotify_fin()	do {} while (0)
+
+static inline
+void au_hin_init(struct au_hinode *hinode __maybe_unused,
+		 struct au_hinotify *val __maybe_unused)
+{
+	/* empty */
+}
+#endif /* CONFIG_AUFS_HINOTIFY */
+
+static inline void au_hin_suspend(struct au_hinode *hdir)
+{
+	au_hin_ctl(hdir, /*do_set*/0);
+}
+
+static inline void au_hin_resume(struct au_hinode *hdir)
+{
+	au_hin_ctl(hdir, /*do_set*/1);
+}
+
+static inline void au_hin_imtx_lock(struct au_hinode *hdir)
+{
+	mutex_lock(&hdir->hi_inode->i_mutex);
+	au_hin_suspend(hdir);
+}
+
+static inline void au_hin_imtx_lock_nested(struct au_hinode *hdir,
+					   unsigned int sc __maybe_unused)
+{
+	mutex_lock_nested(&hdir->hi_inode->i_mutex, sc);
+	au_hin_suspend(hdir);
+}
+
+static inline void au_hin_imtx_unlock(struct au_hinode *hdir)
+{
+	au_hin_resume(hdir);
+	mutex_unlock(&hdir->hi_inode->i_mutex);
+}
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_INODE_H__ */
-- 
1.6.1.284.g5dc13

