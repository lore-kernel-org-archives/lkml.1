Return-Path: <linux-kernel-owner+w=401wt.eu-S934881AbYEUDmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbYEUDmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933879AbYEUDdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:33:54 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44140 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765548AbYEUDdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:33:08 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 05/39] aufs super_block
Date: Wed, 21 May 2008 12:22:35 +0900
Message-Id: <1211340189-11813-6-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
super_block operations and private data

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/sbinfo.c |  261 +++++++++++++++++
 fs/aufs/super.c  |  835 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/super.h  |  405 ++++++++++++++++++++++++++
 3 files changed, 1501 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/sbinfo.c
 create mode 100644 fs/aufs/super.c
 create mode 100644 fs/aufs/super.h

diff --git a/fs/aufs/sbinfo.c b/fs/aufs/sbinfo.c
new file mode 100644
index 0000000..0609411
--- /dev/null
+++ b/fs/aufs/sbinfo.c
@@ -0,0 +1,261 @@
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
+ * superblock private data
+ */
+
+#include <linux/mnt_namespace.h>
+#include <linux/smp_lock.h>
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
+	LKTRTrace("kobj %p\n", kobj);
+	sbinfo = container_of(kobj, struct au_sbinfo, si_kobj);
+	LKTRTrace("sbinfo %p\n", sbinfo);
+	AuDebugOn(!list_empty(&sbinfo->si_plink));
+
+	sb = sbinfo->si_sb;
+	if (unlikely(!au_ftest_si(sbinfo, FAILED_INIT))) {
+		au_sbilist_lock();
+		au_sbilist_del(sbinfo);
+		au_sbilist_unlock();
+	}
+
+	si_write_lock(sb);
+	au_xino_clr(sb);
+	au_br_free(sbinfo);
+	kfree(sbinfo->si_branch);
+	si_write_unlock(sb);
+
+	kfree(sbinfo);
+}
+
+int au_si_alloc(struct super_block *sb)
+{
+	int err;
+	struct au_sbinfo *sbinfo;
+
+	AuTraceEnter();
+
+	err = -ENOMEM;
+	sbinfo = kmalloc(sizeof(*sbinfo), GFP_KERNEL);
+	if (unlikely(!sbinfo))
+		goto out;
+	sbinfo->si_branch = kzalloc(sizeof(*sbinfo->si_branch), GFP_KERNEL);
+	if (unlikely(!sbinfo->si_branch))
+		goto out_sbinfo;
+
+	memset(&sbinfo->si_kobj, 0, sizeof(sbinfo->si_kobj));
+	err = sysaufs_si_init(sbinfo);
+	if (unlikely(err))
+		goto out_br;
+
+	au_rw_init_wlock(&sbinfo->si_rwsem);
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
+	/* leave si_xib_last_pindex and si_xib_next_bit */
+
+	au_nwt_init(&sbinfo->si_nowait);
+
+	sbinfo->si_rdcache = AUFS_RDCACHE_DEF * HZ;
+	sbinfo->si_dirwh = AUFS_DIRWH_DEF;
+
+	spin_lock_init(&sbinfo->si_plink_lock);
+	INIT_LIST_HEAD(&sbinfo->si_plink);
+
+	au_robr_lvma_init(sbinfo);
+
+	/* leave other members for sysaufs and si_mnt. */
+	sbinfo->si_sb = sb;
+
+	sb->s_fs_info = sbinfo;
+
+	au_debug_sbinfo_init(sbinfo);
+	return 0; /* success */
+
+ out_br:
+	kfree(sbinfo->si_branch);
+ out_sbinfo:
+	kfree(sbinfo);
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct au_branch *au_sbr(struct super_block *sb, aufs_bindex_t bindex)
+{
+	struct au_branch *br;
+
+	SiMustAnyLock(sb);
+	AuDebugOn(bindex < 0 || au_sbend(sb) < bindex);
+	br = au_sbi(sb)->si_branch[0 + bindex];
+	AuDebugOn(!br);
+	return br;
+}
+
+au_gen_t au_sigen_inc(struct super_block *sb)
+{
+	au_gen_t gen;
+
+	SiMustWriteLock(sb);
+	gen = ++au_sbi(sb)->si_generation;
+	au_update_digen(sb->s_root);
+	au_update_iigen(sb->s_root->d_inode);
+	sb->s_root->d_inode->i_version++;
+	return gen;
+}
+
+int au_find_bindex(struct super_block *sb, struct au_branch *br)
+{
+	aufs_bindex_t bindex, bend;
+
+	bend = au_sbend(sb);
+	for (bindex = 0; bindex <= bend; bindex++)
+		if (au_sbr(sb, bindex) == br)
+			return bindex;
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
+	AuDebugOn(d1 == d2 || d1->d_sb != d2->d_sb);
+	si_read_lock(d1->d_sb, flags);
+	di_write_lock2_child(d1, d2, au_ftest_lock(flags, DIR));
+}
+
+void aufs_read_and_write_unlock2(struct dentry *d1, struct dentry *d2)
+{
+	AuDebugOn(d1 == d2 || d1->d_sb != d2->d_sb);
+	di_write_unlock2(d1, d2);
+	si_read_unlock(d1->d_sb);
+}
+
+/* ---------------------------------------------------------------------- */
+
+aufs_bindex_t au_new_br_id(struct super_block *sb)
+{
+	aufs_bindex_t br_id;
+	struct au_sbinfo *sbinfo;
+
+	AuTraceEnter();
+	SiMustWriteLock(sb);
+
+	sbinfo = au_sbi(sb);
+	while (1) {
+		br_id = ++sbinfo->si_last_br_id;
+		if (br_id && au_br_index(sb, br_id) < 0)
+			return br_id;
+	}
+}
+
+/* todo: dirty? */
+/*
+ * when you mntput() for the return value of this function,
+ * you have to store it to your local var.
+ * ie. never mntput si_mntcache directly.
+ */
+struct vfsmount *au_mntcache_get(struct super_block *sb)
+{
+	struct au_sbinfo *sbinfo;
+	struct mnt_namespace *ns;
+	struct vfsmount *pos, *mnt;
+
+	AuTraceEnter();
+
+	sbinfo = au_sbi(sb);
+
+	spin_lock(&sbinfo->si_mntcache_lock);
+	if (sbinfo->si_mntcache)
+		goto out;
+
+	/* vfsmount_lock is not exported */
+	/* root_mnt = current->fs->root.mnt; */
+	/* no get/put */
+	AuDebugOn(!current->nsproxy);
+	ns = current->nsproxy->mnt_ns;
+	AuDebugOn(!ns);
+	list_for_each_entry(pos, &ns->list, mnt_list)
+		if (pos->mnt_sb == sb) {
+			sbinfo->si_mntcache = pos;
+			break;
+		}
+	AuDebugOn(!sbinfo->si_mntcache);
+
+ out:
+	mnt = mntget(sbinfo->si_mntcache);
+	spin_unlock(&sbinfo->si_mntcache_lock);
+	return mnt;
+}
diff --git a/fs/aufs/super.c b/fs/aufs/super.c
new file mode 100644
index 0000000..0cdfa05
--- /dev/null
+++ b/fs/aufs/super.c
@@ -0,0 +1,835 @@
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
+ * mount and super_block operations
+ */
+
+#include <linux/module.h>
+#include <linux/buffer_head.h>
+#include <linux/seq_file.h>
+#include <linux/smp_lock.h>
+#include <linux/statfs.h>
+
+#include "aufs.h"
+
+/*
+ * super_operations
+ */
+static struct inode *aufs_alloc_inode(struct super_block *sb)
+{
+	struct aufs_icntnr *c;
+
+	AuTraceEnter();
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
+	LKTRTrace("i%lu\n", inode->i_ino);
+	au_iinfo_fin(inode);
+	au_cache_free_icntnr(container_of(inode, struct aufs_icntnr,
+					  vfs_inode));
+}
+
+struct inode *au_iget_locked(struct super_block *sb, ino_t ino)
+{
+	struct inode *inode;
+	int err;
+
+	LKTRTrace("i%lu\n", ino);
+
+	inode = iget_locked(sb, ino);
+	if (unlikely(!inode)) {
+		inode = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+	AuDebugOn(IS_ERR(inode));
+	if (unlikely(!(inode->i_state & I_NEW)))
+		goto out;
+
+	err = au_iinfo_init(inode);
+	if (!err) {
+		inode->i_version++;
+		inode->i_op = &aufs_iop;
+		inode->i_fop = &aufs_file_fop;
+		inode->i_mapping->a_ops = &aufs_aop;
+	} else {
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
+static int au_show_brs(struct seq_file *seq, struct super_block *sb)
+{
+	int err;
+	aufs_bindex_t bindex, bend;
+	struct dentry *root;
+	struct path path;
+
+	AuTraceEnter();
+
+	err = 0;
+	root = sb->s_root;
+	bend = au_sbend(sb);
+	for (bindex = 0; !err && bindex <= bend; bindex++) {
+		path.mnt = au_sbr_mnt(sb, bindex);
+		path.dentry = au_h_dptr(root, bindex);
+		err = seq_path(seq, &path, au_esc_chars);
+		if (err > 0)
+			err = seq_printf
+				(seq, "=%s",
+				 au_optstr_br_perm(au_sbr_perm(sb, bindex)));
+		if (!err && bindex != bend)
+			err = seq_putc(seq, ':');
+	}
+
+	AuTraceErr(err);
+	return err;
+}
+
+static void au_show_wbr_create(struct seq_file *m, int v,
+			       struct au_sbinfo *sbinfo)
+{
+	const char *pat;
+
+	AuDebugOn(v == AuWbrCreate_Def);
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
+		seq_printf(m, /*pat*/"mfsrr:%Lu",
+			   sbinfo->si_wbr_mfs.mfsrr_watermark);
+		break;
+	case AuWbrCreate_MFSRRV:
+		seq_printf(m, /*pat*/"mfsrr:%Lu:%lu",
+			   sbinfo->si_wbr_mfs.mfsrr_watermark,
+			   sbinfo->si_wbr_mfs.mfs_expire / HZ);
+		break;
+	}
+}
+
+/* seq_file will re-call me in case of too long string */
+static int aufs_show_options(struct seq_file *m, struct vfsmount *mnt)
+{
+	int err, n;
+	struct super_block *sb;
+	struct au_sbinfo *sbinfo;
+	struct dentry *root;
+	struct file *xino;
+	unsigned int mnt_flags, v;
+	struct path path;
+
+	AuTraceEnter();
+
+	sb = mnt->mnt_sb;
+	root = sb->s_root;
+	if (!sysaufs_brs)
+		aufs_read_lock(root, !AuLock_IR);
+	else
+		si_noflush_read_lock(sb);
+	sbinfo = au_sbi(sb);
+	seq_printf(m, ",si=%p", sbinfo);
+	mnt_flags = au_mntflags(sb);
+	if (au_opt_test(mnt_flags, XINO)) {
+		seq_puts(m, ",xino=");
+		xino = sbinfo->si_xib;
+		path.mnt = xino->f_vfsmnt;
+		path.dentry = xino->f_dentry;
+		err = seq_path(m, &path, au_esc_chars);
+		if (unlikely(err <= 0))
+			goto out;
+		err = 0;
+#define Deleted "\\040(deleted)"
+		m->count -= sizeof(Deleted) - 1;
+		AuDebugOn(memcmp(m->buf + m->count, Deleted,
+				 sizeof(Deleted) - 1));
+#undef Deleted
+	} else
+		seq_puts(m, ",noxino");
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
+#ifdef CONFIG_AUFS_COMPAT
+#define AuStr_BrOpt	"dirs="
+#else
+#define AuStr_BrOpt	"br:"
+#endif
+
+	AuBool(TRUNC_XINO, trunc_xino);
+	AuBool(DIRPERM1, dirperm1);
+	AuBool(SHWH, shwh);
+	AuBool(PLINK, plink);
+	AuStr(UDBA, udba);
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
+	AuBool(REFROF, refrof);
+	AuBool(DLGT, dlgt);
+	AuBool(WARN_PERM, warn_perm);
+	AuBool(VERBOSE, verbose);
+
+	n = sbinfo->si_dirwh;
+	if (n != AUFS_DIRWH_DEF)
+		seq_printf(m, ",dirwh=%d", n);
+	n = sbinfo->si_rdcache / HZ;
+	if (n != AUFS_RDCACHE_DEF)
+		seq_printf(m, ",rdcache=%d", n);
+
+	AuStr(COO, coo);
+
+ out:
+	if (!sysaufs_brs) {
+		seq_puts(m, "," AuStr_BrOpt);
+		au_show_brs(m, sb);
+		aufs_read_unlock(root, !AuLock_IR);
+	} else
+		si_read_unlock(sb);
+	return 0;
+
+#undef AuBool
+#undef AuStr
+#undef AuStr_BrOpt
+}
+
+static int aufs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	int err;
+
+	AuTraceEnter();
+
+	aufs_read_lock(dentry->d_sb->s_root, 0);
+	err = vfsub_statfs(au_h_dptr(dentry->d_sb->s_root, 0), buf,
+			   !!au_opt_test_dlgt(au_mntflags(dentry->d_sb)));
+	aufs_read_unlock(dentry->d_sb->s_root, 0);
+	if (!err) {
+		buf->f_type = AUFS_SUPER_MAGIC;
+		buf->f_namelen -= AUFS_WH_PFX_LEN;
+		memset(&buf->f_fsid, 0, sizeof(buf->f_fsid));
+	}
+	/* buf->f_bsize = buf->f_blocks = buf->f_bfree = buf->f_bavail = -1; */
+
+	AuTraceErr(err);
+	return err;
+}
+
+static void au_fsync_br(struct super_block *sb)
+{
+	aufs_bindex_t bend, bindex;
+	int brperm;
+	struct super_block *h_sb;
+
+	AuTraceEnter();
+
+	si_write_lock(sb);
+	bend = au_sbend(sb);
+	for (bindex = 0; bindex < bend; bindex++) {
+		brperm = au_sbr_perm(sb, bindex);
+		if (brperm == AuBr_RR || brperm == AuBr_RRWH)
+			continue;
+		h_sb = au_sbr_sb(sb, bindex);
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
+	si_write_unlock(sb);
+}
+
+static void aufs_umount_begin(struct super_block *sb)
+{
+	struct au_sbinfo *sbinfo;
+
+	AuTraceEnter();
+	/* dont trust BKL */
+	AuDebugOn(!kernel_locked());
+
+	sbinfo = au_sbi(sb);
+	if (unlikely(!sbinfo))
+		return;
+
+	au_fsync_br(sb);
+
+	si_write_lock(sb);
+	if (au_opt_test(au_mntflags(sb), PLINK))
+		au_plink_put(sb);
+	spin_lock(&sbinfo->si_mntcache_lock);
+	sbinfo->si_mntcache = NULL;
+	spin_unlock(&sbinfo->si_mntcache_lock);
+#if 0 /* reserved for future use */
+	if (sbinfo->si_wbr_create_ops->fin)
+		sbinfo->si_wbr_create_ops->fin(sb);
+#endif
+	si_write_unlock(sb);
+}
+
+/* final actions when unmounting a file system */
+static void aufs_put_super(struct super_block *sb)
+{
+	struct au_sbinfo *sbinfo;
+
+	AuTraceEnter();
+
+	sbinfo = au_sbi(sb);
+	if (unlikely(!sbinfo))
+		return;
+
+	/* temp call for v2.6.26-rc2-mm1 */
+	aufs_umount_begin(sb);
+
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
+	struct inode *inode;
+
+	LKTRTrace("%.*s, 0%o\n", AuDLNPair(dentry), type);
+	inode = dentry->d_inode;
+	AuDebugOn(!inode);
+
+	di_write_lock_child(dentry);
+	parent = dget_parent(dentry);
+	di_read_lock_parent(parent, AuLock_IR);
+	/* returns a number of positive dentries */
+	err = au_refresh_hdentry(dentry, type);
+	if (err >= 0) {
+		err = au_refresh_hinode(inode, dentry);
+		if (!err && type == S_IFDIR)
+			au_reset_hinotify(inode, dir_flags);
+	}
+	if (unlikely(err))
+		AuErr("unrecoverable error %d, %.*s\n", err, AuDLNPair(dentry));
+	di_read_unlock(parent, AuLock_IR);
+	dput(parent);
+	di_write_unlock(dentry);
+
+	AuTraceErr(err);
+	return err;
+}
+
+static int test_dir(struct dentry *dentry, void *arg)
+{
+	return S_ISDIR(dentry->d_inode->i_mode);
+}
+
+/* todo: merge with refresh_nondir()? */
+static int refresh_dir(struct dentry *root, au_gen_t sgen)
+{
+	int err, i, j, ndentry, e;
+	const unsigned int flags = au_hi_flags(root->d_inode, /*isdir*/1);
+	struct au_dcsub_pages dpages;
+	struct au_dpage *dpage;
+	struct dentry **dentries;
+	struct inode *inode;
+
+	LKTRTrace("sgen %d\n", sgen);
+	SiMustWriteLock(root->d_sb);
+	/* dont trust BKL */
+	AuDebugOn(au_digen(root) != sgen || !kernel_locked());
+
+	err = 0;
+	list_for_each_entry(inode, &root->d_sb->s_inodes, i_sb_list)
+		if (S_ISDIR(inode->i_mode) && au_iigen(inode) != sgen) {
+			ii_write_lock_child(inode);
+			e = au_refresh_hinode_self(inode);
+			ii_write_unlock(inode);
+			if (unlikely(e)) {
+				LKTRTrace("e %d, i%lu\n", e, inode->i_ino);
+				if (!err)
+					err = e;
+				/* go on even if err */
+			}
+		}
+
+	e = au_dpages_init(&dpages, GFP_TEMPORARY);
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
+			d = dentries[j];
+#ifdef CONFIG_AUFS_DEBUG
+			{
+				struct dentry *parent;
+				parent = dget_parent(d);
+				AuDebugOn(!S_ISDIR(d->d_inode->i_mode)
+					  || IS_ROOT(d)
+					  || au_digen(parent) != sgen);
+				dput(parent);
+			}
+#endif
+			if (au_digen(d) != sgen) {
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
+	AuTraceErr(err);
+	return err;
+}
+
+static int test_nondir(struct dentry *dentry, void *arg)
+{
+	return !S_ISDIR(dentry->d_inode->i_mode);
+}
+
+static int refresh_nondir(struct dentry *root, au_gen_t sgen, int do_dentry)
+{
+	int err, i, j, ndentry, e;
+	struct au_dcsub_pages dpages;
+	struct au_dpage *dpage;
+	struct dentry **dentries;
+	struct inode *inode;
+
+	LKTRTrace("sgen %d\n", sgen);
+	SiMustWriteLock(root->d_sb);
+	/* dont trust BKL */
+	AuDebugOn(au_digen(root) != sgen || !kernel_locked());
+
+	err = 0;
+	list_for_each_entry(inode, &root->d_sb->s_inodes, i_sb_list)
+		if (!S_ISDIR(inode->i_mode) && au_iigen(inode) != sgen) {
+			ii_write_lock_child(inode);
+			e = au_refresh_hinode_self(inode);
+			ii_write_unlock(inode);
+			if (unlikely(e)) {
+				LKTRTrace("e %d, i%lu\n", e, inode->i_ino);
+				if (!err)
+					err = e;
+				/* go on even if err */
+			}
+		}
+
+	if (!do_dentry)
+		goto out;
+
+	e = au_dpages_init(&dpages, GFP_TEMPORARY);
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
+			d = dentries[j];
+#ifdef CONFIG_AUFS_DEBUG
+			{
+				struct dentry *parent;
+				parent = dget_parent(d);
+				AuDebugOn(S_ISDIR(d->d_inode->i_mode)
+					  || au_digen(parent) != sgen);
+				dput(parent);
+			}
+#endif
+			inode = d->d_inode;
+			if (inode && au_digen(d) != sgen) {
+				e = do_refresh(d, inode->i_mode & S_IFMT, 0);
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
+	AuTraceErr(err);
+	return err;
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
+/* protected by s_umount */
+static int aufs_remount_fs(struct super_block *sb, int *flags, char *data)
+{
+	int err;
+	struct dentry *root;
+	struct inode *inode;
+	struct au_opts opts;
+	unsigned int dlgt;
+	struct au_sbinfo *sbinfo;
+
+	LKTRTrace("flags 0x%x, data %s, len %lu\n",
+		  *flags, data ? data : "NULL",
+		  (unsigned long)(data ? strlen(data) : 0));
+
+	au_fsync_br(sb);
+	err = 0;
+	if (!data || !*data)
+		goto out; /* success */
+
+	err = -ENOMEM;
+	memset(&opts, 0, sizeof(opts));
+	opts.opt = (void *)__get_free_page(GFP_TEMPORARY);
+	if (unlikely(!opts.opt))
+		goto out;
+	opts.max_opt = PAGE_SIZE / sizeof(*opts.opt);
+	opts.flags = AuOpts_REMOUNT;
+
+	/* parse it before aufs lock */
+	err = au_opts_parse(sb, *flags, data, &opts);
+	if (unlikely(err))
+		goto out_opts;
+
+	sbinfo = au_sbi(sb);
+	root = sb->s_root;
+	inode = root->d_inode;
+	mutex_lock(&inode->i_mutex);
+	aufs_write_lock(root);
+
+	/* au_do_opts() may return an error */
+	err = au_opts_remount(sb, &opts);
+	au_opts_free(&opts);
+
+	if (au_ftest_opts(opts.flags, REFRESH_DIR)
+	    || au_ftest_opts(opts.flags, REFRESH_NONDIR)) {
+		int rerr;
+		au_gen_t sigen;
+
+		dlgt = !!au_opt_test_dlgt(sbinfo->si_mntflags);
+		au_opt_clr(sbinfo->si_mntflags, DLGT);
+		au_sigen_inc(sb);
+		au_reset_hinotify(inode, au_hi_flags(inode, /*isdir*/1));
+		sigen = au_sigen(sb);
+		au_fclr_si(sbinfo, FAILED_REFRESH_DIRS);
+
+		DiMustNoWaiters(root);
+		IiMustNoWaiters(root->d_inode);
+		di_write_unlock(root);
+
+		rerr = refresh_dir(root, sigen);
+		if (unlikely(rerr)) {
+			au_fset_si(sbinfo, FAILED_REFRESH_DIRS);
+			AuWarn("Refreshing directories failed, ignores (%d)\n",
+			       rerr);
+		}
+
+		if (unlikely(au_ftest_opts(opts.flags, REFRESH_NONDIR))) {
+			rerr = refresh_nondir(root, sigen, !rerr);
+			if (unlikely(rerr))
+				AuWarn("Refreshing non-directories failed,"
+				       " ignores (%d)\n", rerr);
+		}
+
+		/* aufs_write_lock() calls ..._child() */
+		di_write_lock_child(root);
+
+		au_cpup_attr_all(inode);
+		if (unlikely(dlgt))
+			au_opt_set(sbinfo->si_mntflags, DLGT);
+	}
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
+
+	.show_options	= aufs_show_options,
+	.statfs		= aufs_statfs,
+
+	.put_super	= aufs_put_super,
+	.remount_fs	= aufs_remount_fs,
+	/* depends upon umount flags. also use put_super() (< 2.6.18) */
+	.umount_begin	= aufs_umount_begin
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
+	AuTraceEnter();
+
+	err = -ENOMEM;
+	inode = au_iget_locked(sb, AUFS_ROOT_INO);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out;
+	unlock_new_inode(inode);
+	inode->i_mode = S_IFDIR;
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
+	AuTraceErr(err);
+	return err;
+
+}
+
+static int aufs_fill_super(struct super_block *sb, void *raw_data, int silent)
+{
+	int err;
+	struct dentry *root;
+	struct inode *inode;
+	struct au_opts opts;
+	char *arg = raw_data;
+
+	if (unlikely(!arg || !*arg)) {
+		err = -EINVAL;
+		AuErr("no arg\n");
+		goto out;
+	}
+	LKTRTrace("%s, silent %d\n", arg, silent);
+
+	err = -ENOMEM;
+	memset(&opts, 0, sizeof(opts));
+	opts.opt = (void *)__get_free_page(GFP_TEMPORARY);
+	if (unlikely(!opts.opt))
+		goto out;
+	opts.max_opt = PAGE_SIZE / sizeof(*opts.opt);
+
+	err = au_si_alloc(sb);
+	if (unlikely(err))
+		goto out_opts;
+	SiMustWriteLock(sb);
+	/* all timestamps always follow the ones on the branch */
+	sb->s_flags |= MS_NOATIME | MS_NODIRATIME;
+	sb->s_op = &aufs_sop;
+	sb->s_magic = AUFS_SUPER_MAGIC;
+	au_init_export_op(sb);
+
+	err = alloc_root(sb);
+	if (unlikely(err)) {
+		AuDebugOn(sb->s_root);
+		si_write_unlock(sb);
+		goto out_info;
+	}
+	root = sb->s_root;
+	DiMustWriteLock(root);
+	inode = root->d_inode;
+	inode->i_nlink = 2;
+
+	/*
+	 * actually we can parse options regardless aufs lock here.
+	 * but at remount time, parsing must be done before aufs lock.
+	 * so we follow the same rule.
+	 */
+	ii_write_lock_parent(inode);
+	aufs_write_unlock(root);
+	err = au_opts_parse(sb, sb->s_flags, arg, &opts);
+	if (unlikely(err))
+		goto out_root;
+
+	/* lock vfs_inode first, then aufs. */
+	mutex_lock(&inode->i_mutex);
+	inode->i_op = &aufs_dir_iop;
+	inode->i_fop = &aufs_dir_fop;
+	aufs_write_lock(root);
+
+	sb->s_maxbytes = 0;
+	err = au_opts_mount(sb, &opts);
+	au_opts_free(&opts);
+	if (unlikely(err))
+		goto out_unlock;
+	AuDebugOn(!sb->s_maxbytes);
+
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
+	au_fset_si(au_sbi(sb), FAILED_INIT);
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
+		       const char *dev_name, void *raw_data,
+		       struct vfsmount *mnt)
+{
+	int err;
+
+	/* all timestamps always follow the ones on the branch */
+	/* mnt->mnt_flags |= MNT_NOATIME | MNT_NODIRATIME; */
+	err = get_sb_nodev(fs_type, flags, raw_data, aufs_fill_super, mnt);
+	if (!err) {
+		struct super_block *sb = mnt->mnt_sb;
+		struct au_sbinfo *sbinfo = au_sbi(sb);
+
+		/* no get/put */
+		spin_lock_init(&sbinfo->si_mntcache_lock);
+		sbinfo->si_mntcache = mnt;
+
+		au_sbilist_lock();
+		au_sbilist_add(sbinfo);
+		si_write_lock(sb);
+		sysaufs_brs_add(sb, 0);
+		si_write_unlock(sb);
+		au_sbilist_unlock();
+	}
+	return err;
+}
+
+struct file_system_type aufs_fs_type = {
+	.name		= AUFS_FSTYPE,
+	.fs_flags	= FS_REVAL_DOT, /* for UDBA and NFS branch */
+	.get_sb		= aufs_get_sb,
+	.kill_sb	= generic_shutdown_super,
+	/* no need to __module_get() and module_put(). */
+	.owner		= THIS_MODULE,
+};
diff --git a/fs/aufs/super.h b/fs/aufs/super.h
new file mode 100644
index 0000000..2d94134
--- /dev/null
+++ b/fs/aufs/super.h
@@ -0,0 +1,405 @@
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
+ * super_block operations
+ */
+
+#ifndef __AUFS_SUPER_H__
+#define __AUFS_SUPER_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/cramfs_fs.h>
+#include <linux/kobject.h>
+#include <linux/magic.h>
+#include <linux/aufs_type.h>
+#include "misc.h"
+#include "wkq.h"
+
+typedef ssize_t (*au_readf_t)(struct file *, char __user *, size_t, loff_t *);
+typedef ssize_t (*au_writef_t)(struct file *, const char __user *, size_t,
+			       loff_t *);
+
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
+	u64		mfsrr_bytes;
+	u64		mfsrr_watermark;
+};
+
+/* sbinfo status flags */
+/*
+ * set true when refresh_dirs() failed at remount time.
+ * then try refreshing dirs at access time again.
+ * if it is false, refreshing dirs at access time is unnecesary
+ */
+#define AuSi_FAILED_REFRESH_DIRS	1
+#define AuSi_FAILED_INIT		(1 << 1)
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
+	struct au_rwsem		si_rwsem;
+
+	/* branch management */
+	au_gen_t		si_generation;
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
+	/* pseudo_link list */ /* todo: dirty? */
+	spinlock_t		si_plink_lock;
+	struct list_head	si_plink;
+
+	/* dirty, for export, async ops, and sysfs */
+	spinlock_t		si_mntcache_lock;
+	struct vfsmount		*si_mntcache;	/* no get/put */
+
+	/*
+	 * sysfs and lifetime management.
+	 * this is not a small structure and it may be a waste of memory in case
+	 * of sysfs is disabled, particulary when many aufs-es are mounted.
+	 */
+	struct kobject		si_kobj;
+
+	/* todo: remove this list? */
+	/* super_blocks list is not exported */
+	struct list_head	si_list;
+
+#ifdef CONFIG_AUFS_ROBR
+	/* locked vma list for mmap() */ /* todo: dirty? */
+	spinlock_t		si_lvma_lock;
+	struct list_head	si_lvma;
+#endif
+
+	/* dirty, necessary for unmounting, sysfs and sysrq */
+	struct super_block	*si_sb;
+};
+
+/* ---------------------------------------------------------------------- */
+
+/* policy to select one among writable branches */
+#define AuWbrCopyup(sbinfo, args... ) \
+	(sbinfo)->si_wbr_copyup_ops->copyup(args)
+#define AuWbrCreate(sbinfo, args... ) \
+	(sbinfo)->si_wbr_create_ops->create(args)
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
+struct au_branch *au_sbr(struct super_block *sb, aufs_bindex_t bindex);
+au_gen_t au_sigen_inc(struct super_block *sb);
+int au_find_bindex(struct super_block *sb, struct au_branch *br);
+
+void aufs_read_lock(struct dentry *dentry, int flags);
+void aufs_read_unlock(struct dentry *dentry, int flags);
+void aufs_write_lock(struct dentry *dentry);
+void aufs_write_unlock(struct dentry *dentry);
+void aufs_read_and_write_lock2(struct dentry *d1, struct dentry *d2, int isdir);
+void aufs_read_and_write_unlock2(struct dentry *d1, struct dentry *d2);
+
+aufs_bindex_t au_new_br_id(struct super_block *sb);
+struct vfsmount *au_mntcache_get(struct super_block *sb);
+
+/* wbr_policy.c */
+extern struct au_wbr_copyup_operations au_wbr_copyup_ops[];
+extern struct au_wbr_create_operations au_wbr_create_ops[];
+int au_cpdown_dirs(struct dentry *dentry, aufs_bindex_t bdst,
+		   struct dentry *locked);
+
+/* ---------------------------------------------------------------------- */
+
+static inline struct au_sbinfo *au_sbi(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+static inline const char *au_sbtype(struct super_block *sb)
+{
+	return sb->s_type->name;
+}
+
+static inline int au_test_aufs(struct super_block *sb)
+{
+	return (sb->s_magic == AUFS_SUPER_MAGIC);
+}
+
+static inline int au_test_nfs(struct super_block *sb)
+{
+#ifdef CONFIG_AUFS_BR_NFS
+	return (sb->s_magic == NFS_SUPER_MAGIC);
+#else
+	return 0;
+#endif
+}
+
+static inline int au_test_fuse(struct super_block *sb)
+{
+#ifdef CONFIG_AUFS_WORKAROUND_FUSE
+#ifdef FUSE_SUPER_MAGIC
+	return (sb->s_magic == FUSE_SUPER_MAGIC);
+#else
+	return !strcmp(au_sbtype(sb), "fuse");
+#endif
+#endif
+	return 0;
+}
+
+static inline int au_test_xfs(struct super_block *sb)
+{
+#ifdef CONFIG_AUFS_BR_XFS
+#ifdef XFS_SB_MAGIC
+	return (sb->s_magic == XFS_SB_MAGIC);
+#else
+	return !strcmp(au_sbtype(sb), "xfs");
+#endif
+#endif
+	return 0;
+}
+
+static inline int au_test_tmpfs(struct super_block *sb)
+{
+#ifdef CONFIG_TMPFS
+#ifdef TMPFS_MAGIC
+	return (sb->s_magic == TMPFS_MAGIC);
+#else
+	return !strcmp(au_sbtype(sb), "tmpfs");
+#endif
+#endif
+	return 0;
+}
+
+/* ---------------------------------------------------------------------- */
+
+#ifdef CONFIG_AUFS_EXPORT
+extern struct export_operations aufs_export_op;
+static inline void au_init_export_op(struct super_block *sb)
+{
+	sb->s_export_op = &aufs_export_op;
+}
+
+static inline int au_test_nfsd(struct task_struct *tsk)
+{
+	return (!tsk->mm && !strcmp(tsk->comm, "nfsd"));
+}
+
+static inline void au_nfsd_lockdep_off(void)
+{
+	if (au_test_nfsd(current))
+		lockdep_off();
+}
+
+static inline void au_nfsd_lockdep_on(void)
+{
+	if (au_test_nfsd(current))
+		lockdep_on();
+}
+#else
+static inline int au_test_nfsd(struct task_struct *tsk)
+{
+	return 0;
+}
+
+static inline void au_init_export_op(struct super_block *sb)
+{
+	/* nothing */
+}
+
+#define au_nfsd_lockdep_off()	do {} while (0)
+#define au_nfsd_lockdep_on()	do {} while (0)
+#endif /* CONFIG_AUFS_EXPORT */
+
+#ifdef CONFIG_AUFS_ROBR
+static inline int au_test_nested(struct super_block *h_sb)
+{
+	return 0;
+}
+
+static inline void au_robr_lvma_init(struct au_sbinfo *sbinfo)
+{
+	spin_lock_init(&sbinfo->si_lvma_lock);
+	INIT_LIST_HEAD(&sbinfo->si_lvma);
+}
+#else
+static inline int au_test_nested(struct super_block *h_sb)
+{
+	int err = 0;
+	if (unlikely(au_test_aufs(h_sb))) {
+		err = -EINVAL;
+		AuTraceErr(err);
+	}
+	return err;
+}
+
+static inline void au_robr_lvma_init(struct au_sbinfo *sbinfo)
+{
+	/* empty */
+}
+#endif /* CONFIG_AUFS_ROBR */
+
+/* ---------------------------------------------------------------------- */
+
+/* lock superblock. mainly for entry point functions */
+/*
+ * si_noflush_read_lock, si_noflush_write_lock,
+ * si_read_unlock, si_write_unlock, si_downgrade_lock
+ */
+AuSimpleLockRwsemFuncs(si_noflush, struct super_block *sb,
+		       au_sbi(sb)->si_rwsem);
+AuSimpleUnlockRwsemFuncs(si, struct super_block *sb, au_sbi(sb)->si_rwsem);
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
+/* to debug easier, do not make them inlined functions */
+#define SiMustReadLock(sb)	AuRwMustReadLock(&au_sbi(sb)->si_rwsem)
+#define SiMustWriteLock(sb)	AuRwMustWriteLock(&au_sbi(sb)->si_rwsem)
+#define SiMustAnyLock(sb)	AuRwMustAnyLock(&au_sbi(sb)->si_rwsem)
+
+/* ---------------------------------------------------------------------- */
+
+static inline aufs_bindex_t au_sbend(struct super_block *sb)
+{
+	SiMustAnyLock(sb);
+	return au_sbi(sb)->si_bend;
+}
+
+static inline unsigned int au_mntflags(struct super_block *sb)
+{
+	SiMustAnyLock(sb);
+	return au_sbi(sb)->si_mntflags;
+}
+
+static inline au_gen_t au_sigen(struct super_block *sb)
+{
+	SiMustAnyLock(sb);
+	return au_sbi(sb)->si_generation;
+}
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_SUPER_H__ */
-- 
1.5.5.1.308.g1fbb5.dirty

