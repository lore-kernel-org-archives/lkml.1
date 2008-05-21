Return-Path: <linux-kernel-owner+w=401wt.eu-S935693AbYEUDpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935693AbYEUDpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbYEUDeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:34:18 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44154 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765795AbYEUDdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:33:12 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 19/39] aufs dentry (except lookup)
Date: Wed, 21 May 2008 12:22:49 +0900
Message-Id: <1211340189-11813-20-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
dentry operations and private data

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/dentry.h |  381 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/dinfo.c  |  409 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 790 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/dentry.h
 create mode 100644 fs/aufs/dinfo.c

diff --git a/fs/aufs/dentry.h b/fs/aufs/dentry.h
new file mode 100644
index 0000000..87afc1b
--- /dev/null
+++ b/fs/aufs/dentry.h
@@ -0,0 +1,381 @@
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
+ * lookup and dentry operations
+ */
+
+#ifndef __AUFS_DENTRY_H__
+#define __AUFS_DENTRY_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/aufs_type.h>
+#include "misc.h"
+#include "super.h"
+#include "vfsub.h"
+
+/* nameidata open_intent */
+enum {
+	AuIntent_AUFS,
+	AuIntent_BRANCH,
+	AuIntent_Last
+};
+
+struct au_hdintent {
+	struct list_head	hdi_list;
+	struct file		*hdi_file[AuIntent_Last];
+};
+
+struct au_hdentry {
+	struct dentry		*hd_dentry;
+
+#ifdef CONFIG_AUFS_BR_NFS
+	spinlock_t		hd_lock; /* intest_list */
+	struct list_head	*hd_intent_list;
+#endif
+};
+
+struct au_dinfo {
+	atomic_t		di_generation;
+
+	struct au_rwsem		di_rwsem;
+	aufs_bindex_t		di_bstart, di_bend, di_bwh, di_bdiropq;
+	struct au_hdentry	*di_hdentry;
+};
+
+/* nameidata extension flags */
+#define AuNdx_DLGT	1
+#define AuNdx_DIRPERM1	(1 << 1)
+#define au_ftest_ndx(flags, name)	((flags) & AuNdx_##name)
+#define au_fset_ndx(flags, name)	{ (flags) |= AuNdx_##name; }
+#define au_fclr_ndx(flags, name)	{ (flags) &= ~AuNdx_##name; }
+#ifndef CONFIG_AUFS_DLGT
+#undef AuNdx_DLGT
+#define AuNdx_DLGT	0
+#undef AuNdx_DIRPERM1
+#define AuNdx_DIRPERM1	0
+#endif
+
+struct au_ndx {
+	struct vfsmount *nfsmnt;
+	unsigned int flags;
+	struct nameidata *nd;
+	struct au_branch *br;
+	struct file *nd_file;
+};
+
+/* ---------------------------------------------------------------------- */
+
+static inline void au_do_h_dentry_init(struct au_hdentry *hdentry)
+{
+	hdentry->hd_dentry = NULL;
+}
+
+#ifdef CONFIG_AUFS_BR_NFS
+static inline void au_h_dentry_init(struct au_hdentry *hdentry)
+{
+	au_do_h_dentry_init(hdentry);
+	spin_lock_init(&hdentry->hd_lock);
+}
+
+static inline void au_h_dentry_init_all(struct au_hdentry *hdentry, int n)
+{
+	while (n--)
+		spin_lock_init(&hdentry[n].hd_lock);
+}
+
+/* br_nfs.c */
+struct file *au_h_intent(struct dentry *dentry, aufs_bindex_t bindex,
+			 struct file *file);
+int au_br_nfs_h_intent(struct file *nd_file, struct dentry *dentry,
+		       aufs_bindex_t bindex, struct nameidata *nd);
+void au_hintent_put(struct au_hdentry *hd, int do_free);
+int au_fake_intent(struct nameidata *nd, int perm);
+int au_hin_after_reval(struct nameidata *nd, struct dentry *dentry,
+		       aufs_bindex_t bindex, struct file *file);
+struct dentry *au_lkup_hash(const char *name, struct dentry *parent, int len,
+			    struct au_ndx *ndx);
+#else
+
+static inline void au_h_dentry_init(struct au_hdentry *hdentry)
+{
+	au_do_h_dentry_init(hdentry);
+}
+
+static inline void au_h_dentry_init_all(struct au_hdentry *hdentry, int n)
+{
+	/* nothing */
+}
+
+static inline
+struct file *au_h_intent(struct dentry *dentry, aufs_bindex_t bindex,
+			 struct file *file)
+{
+	/* return ERR_PTR(-ENOSYS); */
+	return NULL;
+}
+
+static inline
+int au_br_nfs_h_intent(struct file *nd_file, struct dentry *dentry,
+		       aufs_bindex_t bindex, struct nameidata *nd)
+{
+	return 0;
+}
+
+static inline void au_hintent_put(struct au_hdentry *hd, int do_free)
+{
+	/* empty */
+}
+
+static inline int au_fake_intent(struct nameidata *nd, int perm)
+{
+	return 0;
+}
+
+static inline
+int au_hin_after_reval(struct nameidata *nd, struct dentry *dentry,
+		       aufs_bindex_t bindex, struct file *file)
+{
+	return 0;
+}
+
+#ifdef CONFIG_AUFS_DLGT
+static inline
+struct dentry *au_lkup_hash(const char *name, struct dentry *parent, int len,
+			    struct au_ndx *ndx)
+{
+	/* return ERR_PTR(-ENOSYS); */
+	return vfsub_lookup_one_len(name, parent, len);
+}
+#endif
+#endif /* CONFIG_AUFS_BR_NFS */
+
+#ifdef CONFIG_AUFS_DLGT
+/* dlgt.c */
+struct dentry *au_lkup_one_dlgt(const char *name, struct dentry *parent,
+				int len, unsigned int flags);
+#elif defined(CONFIG_AUFS_BR_NFS)
+/* regardelss kernel version */
+static inline
+struct dentry *au_lkup_one_dlgt(const char *name, struct dentry *parent,
+				int len, unsigned int flags)
+{
+	return vfsub_lookup_one_len(name, parent, len);
+}
+#endif
+
+/* dentry.c */
+extern struct dentry_operations aufs_dop;
+#if defined(CONFIG_AUFS_BR_NFS) || defined(CONFIG_AUFS_DLGT)
+struct dentry *au_lkup_one(const char *name, struct dentry *parent, int len,
+			   struct au_ndx *ndx);
+#else
+static inline
+struct dentry *au_lkup_one(const char *name, struct dentry *parent, int len,
+			   struct au_ndx *ndx)
+{
+	/* todo? ndx->nd_file = NULL; */
+	return vfsub_lookup_one_len(name, parent, len);
+}
+#endif
+struct dentry *au_sio_lkup_one(const char *name, struct dentry *parent, int len,
+			       struct au_ndx *ndx);
+int au_lkup_dentry(struct dentry *dentry, aufs_bindex_t bstart, mode_t type,
+		   struct nameidata *nd);
+int au_lkup_neg(struct dentry *dentry, aufs_bindex_t bindex);
+int au_refresh_hdentry(struct dentry *dentry, mode_t type);
+int au_reval_dpath(struct dentry *dentry, au_gen_t sgen);
+
+/* dinfo.c */
+int au_alloc_dinfo(struct dentry *dentry);
+struct au_dinfo *au_di(struct dentry *dentry);
+
+void di_read_lock(struct dentry *d, int flags, unsigned int lsc);
+void di_read_unlock(struct dentry *d, int flags);
+void di_downgrade_lock(struct dentry *d, int flags);
+void di_write_lock(struct dentry *d, unsigned int lsc);
+void di_write_unlock(struct dentry *d);
+void di_write_lock2_child(struct dentry *d1, struct dentry *d2, int isdir);
+void di_write_lock2_parent(struct dentry *d1, struct dentry *d2, int isdir);
+void di_write_unlock2(struct dentry *d1, struct dentry *d2);
+
+struct dentry *au_h_dptr(struct dentry *dentry, aufs_bindex_t bindex);
+
+aufs_bindex_t au_dbtail(struct dentry *dentry);
+aufs_bindex_t au_dbtaildir(struct dentry *dentry);
+#if 0 /* reserved for future use */
+aufs_bindex_t au_dbtail_generic(struct dentry *dentry);
+#endif
+
+void au_set_dbdiropq(struct dentry *dentry, aufs_bindex_t bindex);
+void au_set_h_dptr(struct dentry *dentry, aufs_bindex_t bindex,
+		   struct dentry *h_dentry);
+
+void au_update_dbrange(struct dentry *dentry, int do_put_zero);
+void au_update_dbstart(struct dentry *dentry);
+void au_update_dbend(struct dentry *dentry);
+int au_find_dbindex(struct dentry *dentry, struct dentry *h_dentry);
+
+/* ---------------------------------------------------------------------- */
+
+/* todo: memory barrier? */
+static inline au_gen_t au_digen(struct dentry *d)
+{
+	return atomic_read(&au_di(d)->di_generation);
+}
+
+#ifdef CONFIG_AUFS_HINOTIFY
+static inline au_gen_t au_digen_dec(struct dentry *d)
+{
+	return atomic_dec_return(&au_di(d)->di_generation);
+}
+#endif /* CONFIG_AUFS_HINOTIFY */
+
+/* ---------------------------------------------------------------------- */
+
+/* lock subclass for dinfo */
+enum {
+	AuLsc_DI_CHILD,		/* child first */
+	AuLsc_DI_CHILD2,	/* rename(2), link(2), and cpup at hinotify */
+	AuLsc_DI_CHILD3,	/* copyup dirs */
+	AuLsc_DI_PARENT,
+	AuLsc_DI_PARENT2,
+	AuLsc_DI_PARENT3
+};
+
+/*
+ * di_read_lock_child, di_write_lock_child,
+ * di_read_lock_child2, di_write_lock_child2,
+ * di_read_lock_child3, di_write_lock_child3,
+ * di_read_lock_parent, di_write_lock_parent,
+ * di_read_lock_parent2, di_write_lock_parent2,
+ * di_read_lock_parent3, di_write_lock_parent3,
+ */
+#define AuReadLockFunc(name, lsc) \
+static inline void di_read_lock_##name(struct dentry *d, int flags) \
+{ di_read_lock(d, flags, AuLsc_DI_##lsc); }
+
+#define AuWriteLockFunc(name, lsc) \
+static inline void di_write_lock_##name(struct dentry *d) \
+{ di_write_lock(d, AuLsc_DI_##lsc); }
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
+
+#undef AuReadLockFunc
+#undef AuWriteLockFunc
+#undef AuRWLockFuncs
+
+/* to debug easier, do not make them inlined functions */
+#define DiMustReadLock(d) do { \
+	SiMustAnyLock((d)->d_sb); \
+	AuRwMustReadLock(&au_di(d)->di_rwsem); \
+} while (0)
+
+#define DiMustWriteLock(d) do { \
+	SiMustAnyLock((d)->d_sb); \
+	AuRwMustWriteLock(&au_di(d)->di_rwsem); \
+} while (0)
+
+#define DiMustAnyLock(d) do { \
+	SiMustAnyLock((d)->d_sb); \
+	AuRwMustAnyLock(&au_di(d)->di_rwsem); \
+} while (0)
+
+#define DiMustNoWaiters(d)	AuRwMustNoWaiters(&au_di(d)->di_rwsem)
+
+/* ---------------------------------------------------------------------- */
+
+static inline aufs_bindex_t au_dbstart(struct dentry *dentry)
+{
+	DiMustAnyLock(dentry);
+	return au_di(dentry)->di_bstart;
+}
+
+static inline aufs_bindex_t au_dbend(struct dentry *dentry)
+{
+	DiMustAnyLock(dentry);
+	return au_di(dentry)->di_bend;
+}
+
+static inline aufs_bindex_t au_dbwh(struct dentry *dentry)
+{
+	DiMustAnyLock(dentry);
+	return au_di(dentry)->di_bwh;
+}
+
+static inline aufs_bindex_t au_dbdiropq(struct dentry *dentry)
+{
+	DiMustAnyLock(dentry);
+	AuDebugOn(dentry->d_inode
+		  && dentry->d_inode->i_mode
+		  && !S_ISDIR(dentry->d_inode->i_mode));
+	return au_di(dentry)->di_bdiropq;
+}
+
+/* todo: hard/soft set? */
+static inline void au_set_dbstart(struct dentry *dentry, aufs_bindex_t bindex)
+{
+	DiMustWriteLock(dentry);
+	AuDebugOn(au_sbend(dentry->d_sb) < bindex);
+	/* */
+	au_di(dentry)->di_bstart = bindex;
+}
+
+static inline void au_set_dbend(struct dentry *dentry, aufs_bindex_t bindex)
+{
+	DiMustWriteLock(dentry);
+	AuDebugOn(au_sbend(dentry->d_sb) < bindex
+		  || bindex < au_dbstart(dentry));
+	au_di(dentry)->di_bend = bindex;
+}
+
+static inline void au_set_dbwh(struct dentry *dentry, aufs_bindex_t bindex)
+{
+	DiMustWriteLock(dentry);
+	AuDebugOn(au_sbend(dentry->d_sb) < bindex);
+	/* dbwh can be outside of bstart - bend range */
+	au_di(dentry)->di_bwh = bindex;
+}
+
+static inline void au_hdput(struct au_hdentry *hd, int do_free)
+{
+	au_hintent_put(hd, do_free);
+	dput(hd->hd_dentry);
+}
+
+static inline void au_update_digen(struct dentry *dentry)
+{
+	AuDebugOn(!dentry->d_sb);
+	atomic_set(&au_di(dentry)->di_generation, au_sigen(dentry->d_sb));
+	/* smp_mb(); */ /* atomic_set */
+}
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_DENTRY_H__ */
diff --git a/fs/aufs/dinfo.c b/fs/aufs/dinfo.c
new file mode 100644
index 0000000..183efe7
--- /dev/null
+++ b/fs/aufs/dinfo.c
@@ -0,0 +1,409 @@
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
+ * dentry private data
+ */
+
+#include "aufs.h"
+
+int au_alloc_dinfo(struct dentry *dentry)
+{
+	struct au_dinfo *dinfo;
+	struct super_block *sb;
+	int nbr;
+
+	LKTRTrace("%.*s\n", AuDLNPair(dentry));
+	AuDebugOn(dentry->d_fsdata);
+
+	dinfo = au_cache_alloc_dinfo();
+	if (dinfo) {
+		sb = dentry->d_sb;
+		nbr = au_sbend(sb) + 1;
+		if (unlikely(nbr <= 0))
+			nbr = 1;
+		dinfo->di_hdentry = kcalloc(nbr, sizeof(*dinfo->di_hdentry),
+					    GFP_KERNEL);
+		if (dinfo->di_hdentry) {
+			au_h_dentry_init_all(dinfo->di_hdentry, nbr);
+			atomic_set(&dinfo->di_generation, au_sigen(sb));
+			/* smp_mb(); */ /* atomic_set */
+			au_rw_init_wlock_nested(&dinfo->di_rwsem,
+						AuLsc_DI_PARENT);
+			dinfo->di_bstart = -1;
+			dinfo->di_bend = -1;
+			dinfo->di_bwh = -1;
+			dinfo->di_bdiropq = -1;
+
+			dentry->d_fsdata = dinfo;
+			dentry->d_op = &aufs_dop;
+			return 0; /* success */
+		}
+		au_cache_free_dinfo(dinfo);
+	}
+	AuTraceErr(-ENOMEM);
+	return -ENOMEM;
+}
+
+struct au_dinfo *au_di(struct dentry *dentry)
+{
+	struct au_dinfo *dinfo = dentry->d_fsdata;
+	AuDebugOn(!dinfo
+		 || !dinfo->di_hdentry
+		 /* || au_sbi(dentry->d_sb)->si_bend < dinfo->di_bend */
+		 || dinfo->di_bend < dinfo->di_bstart
+		 /* dbwh can be outside of this range */
+		 || (0 <= dinfo->di_bdiropq
+		     && (dinfo->di_bdiropq < dinfo->di_bstart
+			 /* || dinfo->di_bend < dinfo->di_bdiropq */))
+		);
+	return dinfo;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static void do_ii_write_lock(struct inode *inode, unsigned int lsc)
+{
+	switch (lsc) {
+	case AuLsc_DI_CHILD:
+		ii_write_lock_child(inode);
+		break;
+	case AuLsc_DI_CHILD2:
+		ii_write_lock_child2(inode);
+		break;
+	case AuLsc_DI_CHILD3:
+		ii_write_lock_child3(inode);
+		break;
+	case AuLsc_DI_PARENT:
+		ii_write_lock_parent(inode);
+		break;
+	case AuLsc_DI_PARENT2:
+		ii_write_lock_parent2(inode);
+		break;
+	case AuLsc_DI_PARENT3:
+		ii_write_lock_parent3(inode);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static void do_ii_read_lock(struct inode *inode, unsigned int lsc)
+{
+	switch (lsc) {
+	case AuLsc_DI_CHILD:
+		ii_read_lock_child(inode);
+		break;
+	case AuLsc_DI_CHILD2:
+		ii_read_lock_child2(inode);
+		break;
+	case AuLsc_DI_CHILD3:
+		ii_read_lock_child3(inode);
+		break;
+	case AuLsc_DI_PARENT:
+		ii_read_lock_parent(inode);
+		break;
+	case AuLsc_DI_PARENT2:
+		ii_read_lock_parent2(inode);
+		break;
+	case AuLsc_DI_PARENT3:
+		ii_read_lock_parent3(inode);
+		break;
+	default:
+		BUG();
+	}
+}
+
+void di_read_lock(struct dentry *d, int flags, unsigned int lsc)
+{
+	SiMustAnyLock(d->d_sb);
+	/* todo: always nested? */
+	au_rw_read_lock_nested(&au_di(d)->di_rwsem, lsc);
+	if (d->d_inode) {
+		if (au_ftest_lock(flags, IW))
+			do_ii_write_lock(d->d_inode, lsc);
+		else if (au_ftest_lock(flags, IR))
+			do_ii_read_lock(d->d_inode, lsc);
+	}
+}
+
+void di_read_unlock(struct dentry *d, int flags)
+{
+	SiMustAnyLock(d->d_sb);
+	if (d->d_inode) {
+		if (au_ftest_lock(flags, IW))
+			ii_write_unlock(d->d_inode);
+		else if (au_ftest_lock(flags, IR))
+			ii_read_unlock(d->d_inode);
+	}
+	au_rw_read_unlock(&au_di(d)->di_rwsem);
+}
+
+void di_downgrade_lock(struct dentry *d, int flags)
+{
+	SiMustAnyLock(d->d_sb);
+	au_rw_dgrade_lock(&au_di(d)->di_rwsem);
+	if (d->d_inode && au_ftest_lock(flags, IR))
+		ii_downgrade_lock(d->d_inode);
+}
+
+void di_write_lock(struct dentry *d, unsigned int lsc)
+{
+	SiMustAnyLock(d->d_sb);
+	/* todo: always nested? */
+	au_rw_write_lock_nested(&au_di(d)->di_rwsem, lsc);
+	if (d->d_inode)
+		do_ii_write_lock(d->d_inode, lsc);
+}
+
+void di_write_unlock(struct dentry *d)
+{
+	SiMustAnyLock(d->d_sb);
+	if (d->d_inode)
+		ii_write_unlock(d->d_inode);
+	au_rw_write_unlock(&au_di(d)->di_rwsem);
+}
+
+void di_write_lock2_child(struct dentry *d1, struct dentry *d2, int isdir)
+{
+	AuTraceEnter();
+	AuDebugOn(d1 == d2
+		  || d1->d_inode == d2->d_inode
+		  || d1->d_sb != d2->d_sb);
+
+	if (isdir && au_test_subdir(d1, d2)) {
+		di_write_lock_child(d1);
+		di_write_lock_child2(d2);
+	} else {
+		/* there should be no races */
+		di_write_lock_child(d2);
+		di_write_lock_child2(d1);
+	}
+}
+
+void di_write_lock2_parent(struct dentry *d1, struct dentry *d2, int isdir)
+{
+	AuTraceEnter();
+	AuDebugOn(d1 == d2
+		  || d1->d_inode == d2->d_inode
+		  || d1->d_sb != d2->d_sb);
+
+	if (isdir && au_test_subdir(d1, d2)) {
+		di_write_lock_parent(d1);
+		di_write_lock_parent2(d2);
+	} else {
+		/* there should be no races */
+		di_write_lock_parent(d2);
+		di_write_lock_parent2(d1);
+	}
+}
+
+void di_write_unlock2(struct dentry *d1, struct dentry *d2)
+{
+	di_write_unlock(d1);
+	if (d1->d_inode == d2->d_inode)
+		au_rw_write_unlock(&au_di(d2)->di_rwsem);
+	else
+		di_write_unlock(d2);
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct dentry *au_h_dptr(struct dentry *dentry, aufs_bindex_t bindex)
+{
+	struct dentry *d;
+
+	DiMustAnyLock(dentry);
+	if (au_dbstart(dentry) < 0 || bindex < au_dbstart(dentry))
+		return NULL;
+	AuDebugOn(bindex < 0
+		  /* || bindex > au_sbend(dentry->d_sb) */);
+	d = au_di(dentry)->di_hdentry[0 + bindex].hd_dentry;
+	AuDebugOn(d && (atomic_read(&d->d_count) <= 0));
+	return d;
+}
+
+aufs_bindex_t au_dbtail(struct dentry *dentry)
+{
+	aufs_bindex_t bend, bwh;
+
+	bend = au_dbend(dentry);
+	if (0 <= bend) {
+		bwh = au_dbwh(dentry);
+		if (!bwh)
+			return bwh;
+		if (0 < bwh && bwh < bend)
+			return bwh - 1;
+	}
+	return bend;
+}
+
+aufs_bindex_t au_dbtaildir(struct dentry *dentry)
+{
+	aufs_bindex_t bend, bopq;
+
+	AuDebugOn(dentry->d_inode
+		  && dentry->d_inode->i_mode
+		  && !S_ISDIR(dentry->d_inode->i_mode));
+
+	bend = au_dbtail(dentry);
+	if (0 <= bend) {
+		bopq = au_dbdiropq(dentry);
+		AuDebugOn(bend < bopq);
+		if (0 <= bopq && bopq < bend)
+			bend = bopq;
+	}
+	return bend;
+}
+
+#if 0 /* reserved for future use */
+aufs_bindex_t au_dbtail_generic(struct dentry *dentry)
+{
+	struct inode *inode;
+
+	inode = dentry->d_inode;
+	if (inode && S_ISDIR(inode->i_mode))
+		return au_dbtaildir(dentry);
+	else
+		return au_dbtail(dentry);
+}
+#endif
+
+/* ---------------------------------------------------------------------- */
+
+void au_set_dbdiropq(struct dentry *dentry, aufs_bindex_t bindex)
+{
+	DiMustWriteLock(dentry);
+	AuDebugOn(au_sbend(dentry->d_sb) < bindex);
+	AuDebugOn((bindex >= 0
+		   && (bindex < au_dbstart(dentry)
+		       || au_dbend(dentry) < bindex))
+		  || (dentry->d_inode
+		      && dentry->d_inode->i_mode
+		      && !S_ISDIR(dentry->d_inode->i_mode)));
+	au_di(dentry)->di_bdiropq = bindex;
+}
+
+void au_set_h_dptr(struct dentry *dentry, aufs_bindex_t bindex,
+		   struct dentry *h_dentry)
+{
+	struct au_hdentry *hd = au_di(dentry)->di_hdentry + bindex;
+	DiMustWriteLock(dentry);
+	AuDebugOn(bindex < au_di(dentry)->di_bstart
+		  || bindex > au_di(dentry)->di_bend
+		  || (h_dentry && atomic_read(&h_dentry->d_count) <= 0)
+		  || (h_dentry && hd->hd_dentry)
+		);
+	if (hd->hd_dentry)
+		au_hdput(hd, /*do_free*/0);
+	hd->hd_dentry = h_dentry;
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_update_dbrange(struct dentry *dentry, int do_put_zero)
+{
+	struct au_dinfo *dinfo;
+	aufs_bindex_t bindex;
+	struct dentry *h_d;
+
+	LKTRTrace("%.*s, %d\n", AuDLNPair(dentry), do_put_zero);
+	DiMustWriteLock(dentry);
+
+	dinfo = au_di(dentry);
+	if (unlikely(!dinfo) || dinfo->di_bstart < 0)
+		return;
+
+	if (do_put_zero) {
+		for (bindex = dinfo->di_bstart; bindex <= dinfo->di_bend;
+		     bindex++) {
+			h_d = dinfo->di_hdentry[0 + bindex].hd_dentry;
+			if (h_d && !h_d->d_inode)
+				au_set_h_dptr(dentry, bindex, NULL);
+		}
+	}
+
+	dinfo->di_bstart = -1;
+	while (++dinfo->di_bstart <= dinfo->di_bend)
+		if (dinfo->di_hdentry[0 + dinfo->di_bstart].hd_dentry)
+			break;
+	if (dinfo->di_bstart > dinfo->di_bend) {
+		dinfo->di_bstart = -1;
+		dinfo->di_bend = -1;
+		return;
+	}
+
+	dinfo->di_bend++;
+	while (0 <= --dinfo->di_bend)
+		if (dinfo->di_hdentry[0 + dinfo->di_bend].hd_dentry)
+			break;
+	AuDebugOn(dinfo->di_bstart > dinfo->di_bend || dinfo->di_bend < 0);
+}
+
+void au_update_dbstart(struct dentry *dentry)
+{
+	aufs_bindex_t bindex,
+		bstart = au_dbstart(dentry),
+		bend = au_dbend(dentry);
+	struct dentry *h_dentry;
+
+	LKTRTrace("%.*s\n", AuDLNPair(dentry));
+	DiMustWriteLock(dentry);
+
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		h_dentry = au_h_dptr(dentry, bindex);
+		if (!h_dentry)
+			continue;
+		if (h_dentry->d_inode) {
+			au_set_dbstart(dentry, bindex);
+			return;
+		}
+		au_set_h_dptr(dentry, bindex, NULL);
+	}
+}
+
+void au_update_dbend(struct dentry *dentry)
+{
+	aufs_bindex_t bindex,
+		bstart = au_dbstart(dentry),
+		bend = au_dbend(dentry);
+	struct dentry *h_dentry;
+
+	DiMustWriteLock(dentry);
+	for (bindex = bend; bindex <= bstart; bindex--) {
+		h_dentry = au_h_dptr(dentry, bindex);
+		if (!h_dentry)
+			continue;
+		if (h_dentry->d_inode) {
+			au_set_dbend(dentry, bindex);
+			return;
+		}
+		au_set_h_dptr(dentry, bindex, NULL);
+	}
+}
+
+int au_find_dbindex(struct dentry *dentry, struct dentry *h_dentry)
+{
+	aufs_bindex_t bindex, bend;
+
+	bend = au_dbend(dentry);
+	for (bindex = au_dbstart(dentry); bindex <= bend; bindex++)
+		if (au_h_dptr(dentry, bindex) == h_dentry)
+			return bindex;
+	return -1;
+}
-- 
1.5.5.1.308.g1fbb5.dirty

