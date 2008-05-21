Return-Path: <linux-kernel-owner+w=401wt.eu-S933810AbYEUDeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbYEUDeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbYEUDc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:32:59 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44072 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbYEUDcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:32:53 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 36/39] aufs debug print and magic sysrq
Date: Wed, 21 May 2008 12:23:06 +0900
Message-Id: <1211340189-11813-37-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
debug print functions and magic sysrq handler

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/debug.c |  466 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/debug.h |  208 +++++++++++++++++++++++++
 fs/aufs/sysrq.c |  101 ++++++++++++
 3 files changed, 775 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/debug.c
 create mode 100644 fs/aufs/debug.h
 create mode 100644 fs/aufs/sysrq.c

diff --git a/fs/aufs/debug.c b/fs/aufs/debug.c
new file mode 100644
index 0000000..f2b2b01
--- /dev/null
+++ b/fs/aufs/debug.c
@@ -0,0 +1,466 @@
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
+ * debug print functions
+ */
+
+#include "aufs.h"
+
+atomic_t au_cond = ATOMIC_INIT(0);
+
+char *au_plevel = KERN_DEBUG;
+#define dpri(fmt, arg...) do { \
+	if (LktrCond) \
+		printk("%s" fmt, au_plevel, ##arg); \
+} while (0)
+
+/* ---------------------------------------------------------------------- */
+
+void au_dpri_whlist(struct au_nhash *whlist)
+{
+	int i;
+	struct hlist_head *head;
+	struct au_vdir_wh *tpos;
+	struct hlist_node *pos;
+
+	for (i = 0; i < AuSize_NHASH; i++) {
+		head = whlist->heads + i;
+		hlist_for_each_entry(tpos, pos, head, wh_hash)
+			dpri("b%d, %.*s, %d\n",
+			     tpos->wh_bindex,
+			     tpos->wh_str.len, tpos->wh_str.name,
+			     tpos->wh_str.len);
+	}
+}
+
+void au_dpri_vdir(struct au_vdir *vdir)
+{
+	int i;
+	union au_vdir_deblk_p p;
+	unsigned char *o;
+
+	if (!vdir || IS_ERR(vdir)) {
+		dpri("err %ld\n", PTR_ERR(vdir));
+		return;
+	}
+
+	dpri("nblk %d, deblk %p, last{%d, %p}, ver %lu\n",
+	     vdir->vd_nblk, vdir->vd_deblk,
+	     vdir->vd_last.i, vdir->vd_last.p.p, vdir->vd_version);
+	for (i = 0; i < vdir->vd_nblk; i++) {
+		p.deblk = vdir->vd_deblk[i];
+		o = p.p;
+		dpri("[%d]: %p\n", i, o);
+	}
+}
+
+static int do_pri_inode(aufs_bindex_t bindex, struct inode *inode,
+			struct dentry *wh)
+{
+	char *n = NULL;
+	int l = 0, ntfy = 0;
+
+	if (!inode || IS_ERR(inode)) {
+		dpri("i%d: err %ld\n", bindex, PTR_ERR(inode));
+		return -1;
+	}
+
+	/* the type of i_blocks depends upon CONFIG_LSF */
+	BUILD_BUG_ON(sizeof(inode->i_blocks) != sizeof(unsigned long)
+		     && sizeof(inode->i_blocks) != sizeof(u64));
+	if (wh) {
+		n = (void *)wh->d_name.name;
+		l = wh->d_name.len;
+	}
+
+	ntfy = au_test_inotify(inode);
+	dpri("i%d: i%lu, %s, cnt %d, nl %u, 0%o, ntfy %d, sz %Lu, blk %Lu,"
+	     " ct %Ld, np %lu, st 0x%lx, f 0x%x, g %x%s%.*s\n",
+	     bindex,
+	     inode->i_ino, inode->i_sb ? au_sbtype(inode->i_sb) : "??",
+	     atomic_read(&inode->i_count), inode->i_nlink, inode->i_mode,
+	     ntfy,
+	     i_size_read(inode), (u64)inode->i_blocks,
+	     timespec_to_ns(&inode->i_ctime) & 0x0ffff,
+	     inode->i_mapping ? inode->i_mapping->nrpages : 0,
+	     inode->i_state, inode->i_flags, inode->i_generation,
+	     l ? ", wh " : "", l, n);
+	return 0;
+}
+
+void au_dpri_inode(struct inode *inode)
+{
+	struct au_iinfo *iinfo;
+	aufs_bindex_t bindex;
+	int err;
+
+	err = do_pri_inode(-1, inode, NULL);
+	if (err || !au_test_aufs(inode->i_sb))
+		return;
+
+	iinfo = au_ii(inode);
+	if (!iinfo)
+		return;
+	dpri("i-1: bstart %d, bend %d, gen %d\n",
+	     iinfo->ii_bstart, iinfo->ii_bend, au_iigen(inode));
+	if (iinfo->ii_bstart < 0)
+		return;
+	for (bindex = iinfo->ii_bstart; bindex <= iinfo->ii_bend; bindex++)
+		do_pri_inode(bindex, iinfo->ii_hinode[0 + bindex].hi_inode,
+			     iinfo->ii_hinode[0 + bindex].hi_whdentry);
+}
+
+static int do_pri_dentry(aufs_bindex_t bindex, struct dentry *dentry,
+			 struct list_head *intent)
+{
+	struct dentry *wh = NULL;
+
+	if (!dentry || IS_ERR(dentry)) {
+		dpri("d%d: err %ld\n", bindex, PTR_ERR(dentry));
+		return -1;
+	}
+	/* do not call dget_parent() here */
+	dpri("d%d: %.*s/%.*s, %s, cnt %d, flags 0x%x, intent %d\n",
+	     bindex,
+	     AuDLNPair(dentry->d_parent), AuDLNPair(dentry),
+	     dentry->d_sb ? au_sbtype(dentry->d_sb) : "??",
+	     atomic_read(&dentry->d_count), dentry->d_flags, !!intent);
+	if (bindex >= 0 && dentry->d_inode && au_test_aufs(dentry->d_sb)) {
+		struct au_iinfo *iinfo = au_ii(dentry->d_inode);
+		if (iinfo)
+			wh = iinfo->ii_hinode[0 + bindex].hi_whdentry;
+	}
+	do_pri_inode(bindex, dentry->d_inode, wh);
+	return 0;
+}
+
+static struct list_head *au_dbg_h_intent(struct au_dinfo *dinfo,
+					 aufs_bindex_t bindex)
+{
+#ifdef CONFIG_AUFS_BR_NFS
+	return dinfo->di_hdentry[0 + bindex].hd_intent_list;
+#else
+	return NULL;
+#endif
+}
+
+void au_dpri_dentry(struct dentry *dentry)
+{
+	struct au_dinfo *dinfo;
+	aufs_bindex_t bindex;
+	int err;
+
+	err = do_pri_dentry(-1, dentry, NULL);
+	if (err || !au_test_aufs(dentry->d_sb))
+		return;
+
+	dinfo = au_di(dentry);
+	if (!dinfo)
+		return;
+	dpri("d-1: bstart %d, bend %d, bwh %d, bdiropq %d, gen %d\n",
+	     dinfo->di_bstart, dinfo->di_bend,
+	     dinfo->di_bwh, dinfo->di_bdiropq, au_digen(dentry));
+	if (dinfo->di_bstart < 0)
+		return;
+	for (bindex = dinfo->di_bstart; bindex <= dinfo->di_bend; bindex++)
+		do_pri_dentry(bindex, dinfo->di_hdentry[0 + bindex].hd_dentry,
+			      au_dbg_h_intent(dinfo, bindex));
+}
+
+static int do_pri_file(aufs_bindex_t bindex, struct file *file)
+{
+	char a[32];
+
+	if (!file || IS_ERR(file)) {
+		dpri("f%d: err %ld\n", bindex, PTR_ERR(file));
+		return -1;
+	}
+	a[0] = 0;
+	if (bindex < 0
+	    && file->f_dentry
+	    && au_test_aufs(file->f_dentry->d_sb)
+	    && au_fi(file))
+		snprintf(a, sizeof(a), ", mmapped %d", au_test_mmapped(file));
+	dpri("f%d: mode 0x%x, flags 0%o, cnt %d, pos %Lu%s\n",
+	     bindex, file->f_mode, file->f_flags, file_count(file),
+	     file->f_pos, a);
+	if (file->f_dentry)
+		do_pri_dentry(bindex, file->f_dentry, NULL);
+	return 0;
+}
+
+void au_dpri_file(struct file *file)
+{
+	struct au_finfo *finfo;
+	aufs_bindex_t bindex;
+	int err;
+
+	err = do_pri_file(-1, file);
+	if (err || !file->f_dentry || !au_test_aufs(file->f_dentry->d_sb))
+		return;
+
+	finfo = au_fi(file);
+	if (!finfo)
+		return;
+	if (finfo->fi_bstart < 0)
+		return;
+	for (bindex = finfo->fi_bstart; bindex <= finfo->fi_bend; bindex++) {
+		struct au_hfile *hf;
+		hf = finfo->fi_hfile + bindex;
+		do_pri_file(bindex, hf ? hf->hf_file : NULL);
+	}
+}
+
+static int do_pri_br(aufs_bindex_t bindex, struct au_branch *br)
+{
+	struct vfsmount *mnt;
+	struct super_block *sb;
+
+	if (!br || IS_ERR(br)
+	    || !(mnt = br->br_mnt) || IS_ERR(mnt)
+	    || !(sb = mnt->mnt_sb) || IS_ERR(sb)) {
+		dpri("s%d: err %ld\n", bindex, PTR_ERR(br));
+		return -1;
+	}
+
+	dpri("s%d: {perm 0x%x, cnt %d}, "
+	     "%s, flags 0x%lx, cnt(BIAS) %d, active %d, xino %d\n",
+	     bindex, br->br_perm, au_br_count(br),
+	     au_sbtype(sb), sb->s_flags, sb->s_count - S_BIAS,
+	     atomic_read(&sb->s_active), !!br->br_xino);
+	return 0;
+}
+
+void au_dpri_sb(struct super_block *sb)
+{
+	struct au_sbinfo *sbinfo;
+	aufs_bindex_t bindex;
+	int err;
+	struct vfsmount mnt = { .mnt_sb = sb };
+	struct au_branch fake = {
+		.br_perm = 0,
+		.br_mnt = &mnt,
+		.br_count = ATOMIC_INIT(0),
+		.br_xino = NULL
+	};
+
+	atomic_set(&fake.br_count, 0);
+	smp_mb(); /* atomic_set */
+	err = do_pri_br(-1, &fake);
+	dpri("dev 0x%x\n", sb->s_dev);
+	if (err || !au_test_aufs(sb))
+		return;
+
+	sbinfo = au_sbi(sb);
+	if (!sbinfo)
+		return;
+	for (bindex = 0; bindex <= sbinfo->si_bend; bindex++)
+		do_pri_br(bindex, sbinfo->si_branch[0 + bindex]);
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_dbg_sleep(int sec)
+{
+	static DECLARE_WAIT_QUEUE_HEAD(wq);
+	wait_event_timeout(wq, 0, sec * HZ);
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_debug_sbinfo_init(struct au_sbinfo *sbinfo)
+{
+#ifdef ForceInotify
+	au_opt_set_udba(sbinfo->si_mntflags, UDBA_INOTIFY);
+#endif
+#ifdef ForceDlgt
+	au_opt_set(sbinfo->si_mntflags, DLGT);
+#endif
+#ifdef ForceNoPlink
+	au_opt_clr(sbinfo->si_mntflags, PLINK);
+#endif
+#ifdef ForceNoXino
+	au_opt_clr(sbinfo->si_mntflags, XINO);
+#endif
+#ifdef ForceNoRefrof
+	au_opt_clr(sbinfo->si_mntflags, REFROF);
+#endif
+}
+
+int __init au_debug_init(void)
+{
+	aufs_bindex_t bindex;
+	struct au_vdir_destr destr;
+
+	bindex = -1;
+	AuDebugOn(bindex >= 0);
+
+	destr.len = -1;
+	AuDebugOn(destr.len < NAME_MAX);
+
+#ifdef CONFIG_4KSTACKS
+	AuWarn("CONFIG_4KSTACKS is defined.\n");
+#endif
+
+#if 0 /* verbose debug */
+	{
+		union {
+			struct au_branch *br;
+			struct au_dinfo *di;
+			struct au_finfo *fi;
+			struct au_iinfo *ii;
+			struct au_hinode *hi;
+			struct au_sbinfo *si;
+			struct au_vdir_destr *destr;
+			struct au_vdir_de *de;
+			struct au_vdir_wh *wh;
+			struct au_vdir *vd;
+		} u;
+
+		pr_info("br{"
+			"xino %d, "
+			"id %d, perm %d, mnt %d, count %d, "
+			"wh_sem %d, wh %d, run %d, plink %d, "
+			"xup %d, xrun %d, "
+			"by %d, "
+			"gen %d, "
+			"sa %d} %d\n",
+			offsetof(typeof(*u.br), br_xino),
+			offsetof(typeof(*u.br), br_id),
+			offsetof(typeof(*u.br), br_perm),
+			offsetof(typeof(*u.br), br_mnt),
+			offsetof(typeof(*u.br), br_count),
+			offsetof(typeof(*u.br), br_wh_rwsem),
+			offsetof(typeof(*u.br), br_wh),
+			offsetof(typeof(*u.br), br_wh_running),
+			offsetof(typeof(*u.br), br_plink),
+			offsetof(typeof(*u.br), br_xino_upper),
+			offsetof(typeof(*u.br), br_xino_running),
+			offsetof(typeof(*u.br), br_bytes),
+			offsetof(typeof(*u.br), br_generation),
+			offsetof(typeof(*u.br), br_sabr),
+			sizeof(*u.br));
+		pr_info("di{gen %d, rwsem %d, bstart %d, bend %d, bwh %d, "
+			"bdiropq %d, hdentry %d} %d\n",
+			offsetof(typeof(*u.di), di_generation),
+			offsetof(typeof(*u.di), di_rwsem),
+			offsetof(typeof(*u.di), di_bstart),
+			offsetof(typeof(*u.di), di_bend),
+			offsetof(typeof(*u.di), di_bwh),
+			offsetof(typeof(*u.di), di_bdiropq),
+			offsetof(typeof(*u.di), di_hdentry),
+			sizeof(*u.di));
+		pr_info("fi{gen %d, rwsem %d, hfile %d, bstart %d, bend %d, "
+			"h_vm_ops %d, vdir_cach %d} %d\n",
+			offsetof(typeof(*u.fi), fi_generation),
+			offsetof(typeof(*u.fi), fi_rwsem),
+			offsetof(typeof(*u.fi), fi_hfile),
+			offsetof(typeof(*u.fi), fi_bstart),
+			offsetof(typeof(*u.fi), fi_bend),
+			offsetof(typeof(*u.fi), fi_h_vm_ops),
+			offsetof(typeof(*u.fi), fi_vdir_cache),
+			sizeof(*u.fi));
+		pr_info("ii{gen %d, hsb %d, "
+			"rwsem %d, bstart %d, bend %d, hinode %d, vdir %d} "
+			"%d\n",
+			offsetof(typeof(*u.ii), ii_generation),
+			offsetof(typeof(*u.ii), ii_hsb1),
+			offsetof(typeof(*u.ii), ii_rwsem),
+			offsetof(typeof(*u.ii), ii_bstart),
+			offsetof(typeof(*u.ii), ii_bend),
+			offsetof(typeof(*u.ii), ii_hinode),
+			offsetof(typeof(*u.ii), ii_vdir),
+			sizeof(*u.ii));
+		pr_info("hi{inode %d, id %d, notify %d, wh %d} %d\n",
+			offsetof(typeof(*u.hi), hi_inode),
+			offsetof(typeof(*u.hi), hi_id),
+			offsetof(typeof(*u.hi), hi_notify),
+			offsetof(typeof(*u.hi), hi_whdentry),
+			sizeof(*u.hi));
+		pr_info("si{nwt %d, rwsem %d, gen %d, stat %d, "
+			"bend %d, last id %d, br %d, "
+			"cpup %d, creat %d, ops %d, ops %d, "
+			"rr %d, mfs %d, "
+			"mntflags %d, "
+			"xread %d, xwrite %d, xib %d, xmtx %d, buf %d, "
+			"xlast %d, xnext %d, "
+			"rdcache %d, "
+			"dirwh %d, "
+			"pl_lock %d, pl %d, "
+			"mnt %d, "
+			"l %d, sys %d, "
+			/* "lvma_l %d, lvma %d" */
+			"} %d\n",
+			offsetof(typeof(*u.si), si_nowait),
+			offsetof(typeof(*u.si), si_rwsem),
+			offsetof(typeof(*u.si), si_generation),
+			offsetof(typeof(*u.si), au_si_status),
+			offsetof(typeof(*u.si), si_bend),
+			offsetof(typeof(*u.si), si_last_br_id),
+			offsetof(typeof(*u.si), si_branch),
+			offsetof(typeof(*u.si), si_wbr_copyup),
+			offsetof(typeof(*u.si), si_wbr_create),
+			offsetof(typeof(*u.si), si_wbr_copyup_ops),
+			offsetof(typeof(*u.si), si_wbr_create_ops),
+			offsetof(typeof(*u.si), si_wbr_rr_next),
+			offsetof(typeof(*u.si), si_wbr_mfs),
+			offsetof(typeof(*u.si), si_mntflags),
+			offsetof(typeof(*u.si), si_xread),
+			offsetof(typeof(*u.si), si_xwrite),
+			offsetof(typeof(*u.si), si_xib),
+			offsetof(typeof(*u.si), si_xib_mtx),
+			offsetof(typeof(*u.si), si_xib_buf),
+			offsetof(typeof(*u.si), si_xib_last_pindex),
+			offsetof(typeof(*u.si), si_xib_next_bit),
+			offsetof(typeof(*u.si), si_rdcache),
+			offsetof(typeof(*u.si), si_dirwh),
+			offsetof(typeof(*u.si), si_plink_lock),
+			offsetof(typeof(*u.si), si_plink),
+			offsetof(typeof(*u.si), si_mnt),
+			offsetof(typeof(*u.si), si_list),
+			offsetof(typeof(*u.si), si_sa),
+			/*offsetof(typeof(*u.si), si_lvma_lock),
+			offsetof(typeof(*u.si), si_lvma),*/
+			sizeof(*u.si));
+		pr_info("destr{len %d, name %d} %d\n",
+			offsetof(typeof(*u.destr), len),
+			offsetof(typeof(*u.destr), name),
+			sizeof(*u.destr));
+		pr_info("de{ino %d, type %d, str %d} %d\n",
+			offsetof(typeof(*u.de), de_ino),
+			offsetof(typeof(*u.de), de_type),
+			offsetof(typeof(*u.de), de_str),
+			sizeof(*u.de));
+		pr_info("wh{hash %d, bindex %d, str %d} %d\n",
+			offsetof(typeof(*u.wh), wh_hash),
+			offsetof(typeof(*u.wh), wh_bindex),
+			offsetof(typeof(*u.wh), wh_str),
+			sizeof(*u.wh));
+		pr_info("vd{deblk %d, nblk %d, last %d, ver %d, jiffy %d} %d\n",
+			offsetof(typeof(*u.vd), vd_deblk),
+			offsetof(typeof(*u.vd), vd_nblk),
+			offsetof(typeof(*u.vd), vd_last),
+			offsetof(typeof(*u.vd), vd_version),
+			offsetof(typeof(*u.vd), vd_jiffy),
+			sizeof(*u.vd));
+	}
+#endif
+
+	return 0;
+}
diff --git a/fs/aufs/debug.h b/fs/aufs/debug.h
new file mode 100644
index 0000000..8aa5c6a
--- /dev/null
+++ b/fs/aufs/debug.h
@@ -0,0 +1,208 @@
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
+ * debug print functions
+ */
+
+#ifndef __AUFS_DEBUG_H__
+#define __AUFS_DEBUG_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+
+/* to debug easier, do not make it an inlined function */
+#define MtxMustLock(mtx)	AuDebugOn(!mutex_is_locked(mtx))
+
+#ifdef CONFIG_AUFS_DEBUG
+/* sparse warns about pointer */
+#define AuDebugOn(a)		BUG_ON(!!(a))
+extern atomic_t au_cond;
+#define au_debug_on()		atomic_inc_return(&au_cond)
+#define au_debug_off()		atomic_dec_return(&au_cond)
+static inline int au_debug_test(void)
+{
+	return atomic_read(&au_cond);
+}
+#else
+#define AuDebugOn(a)		do {} while (0)
+#define au_debug_on()		do {} while (0)
+#define au_debug_off()		do {} while (0)
+static inline int au_debug_test(void)
+{
+	return 0;
+}
+#endif /* CONFIG_AUFS_DEBUG */
+
+/* ---------------------------------------------------------------------- */
+
+/* debug print */
+#if defined(CONFIG_LKTR) || defined(CONFIG_LKTR_MODULE)
+#include <linux/lktr.h>
+#ifdef CONFIG_AUFS_DEBUG
+#undef LktrCond
+#define LktrCond	unlikely(au_debug_test() || (lktr_cond && lktr_cond()))
+#endif
+#else
+#define LktrCond			au_debug_test()
+#define LKTRDumpVma(pre, vma, suf)	do {} while (0)
+#define LKTRDumpStack()			do {} while (0)
+#define LKTRTrace(fmt, args...) do { \
+	if (LktrCond) \
+		AuDbg(fmt, ##args); \
+} while (0)
+#define LKTRLabel(label)		LKTRTrace("%s\n", #label)
+#endif /* CONFIG_LKTR */
+
+#define AuTraceErr(e) do { \
+	if (unlikely((e) < 0)) \
+		LKTRTrace("err %d\n", (int)(e)); \
+} while (0)
+
+#define AuTraceErrPtr(p) do { \
+	if (IS_ERR(p)) \
+		LKTRTrace("err %ld\n", PTR_ERR(p)); \
+} while (0)
+
+#define AuTraceEnter()	LKTRLabel(enter)
+
+/* dirty macros for debug print, use with "%.*s" and caution */
+#define AuLNPair(qstr)		(qstr)->len, (qstr)->name
+#define AuDLNPair(d)		AuLNPair(&(d)->d_name)
+
+/* ---------------------------------------------------------------------- */
+
+#define AuDpri(lvl, fmt, arg...) \
+	printk(lvl AUFS_NAME " %s:%d:%s[%d]: " fmt, \
+	       __func__, __LINE__, current->comm, current->pid, ##arg)
+#define AuDbg(fmt, arg...)	AuDpri(KERN_DEBUG, fmt, ##arg)
+#define AuInfo(fmt, arg...)	AuDpri(KERN_INFO, fmt, ##arg)
+#define AuWarn(fmt, arg...)	AuDpri(KERN_WARNING, fmt, ##arg)
+#define AuErr(fmt, arg...)	AuDpri(KERN_ERR, fmt, ##arg)
+#define AuIOErr(fmt, arg...)	AuErr("I/O Error, " fmt, ##arg)
+#define AuIOErrWhck(fmt, arg...) AuErr("I/O Error, try whck. " fmt, ##arg)
+#define AuWarn1(fmt, arg...) do { \
+	static unsigned char _c; \
+	if (!_c++) AuWarn(fmt, ##arg); \
+} while (0)
+
+#define AuErr1(fmt, arg...) do { \
+	static unsigned char _c; \
+	if (!_c++) AuErr(fmt, ##arg); \
+} while (0)
+
+#define AuIOErr1(fmt, arg...) do { \
+	static unsigned char _c; \
+	if (!_c++) AuIOErr(fmt, ##arg); \
+} while (0)
+
+#define AuUnsupportMsg	"This operation is not supported." \
+			" Please report this application to aufs-users ML."
+#define AuUnsupport(fmt, args...) do { \
+	AuErr(AuUnsupportMsg "\n" fmt, ##args); \
+	dump_stack(); \
+} while (0)
+
+/* ---------------------------------------------------------------------- */
+
+struct au_sbinfo;
+#ifdef CONFIG_AUFS_DEBUG
+extern char *au_plevel;
+struct au_nhash;
+void au_dpri_whlist(struct au_nhash *whlist);
+struct au_vdir;
+void au_dpri_vdir(struct au_vdir *vdir);
+void au_dpri_inode(struct inode *inode);
+void au_dpri_dentry(struct dentry *dentry);
+void au_dpri_file(struct file *filp);
+void au_dpri_sb(struct super_block *sb);
+void au_dbg_sleep(int sec);
+int __init au_debug_init(void);
+void au_debug_sbinfo_init(struct au_sbinfo *sbinfo);
+#define AuDbgWhlist(w) do { \
+	LKTRTrace(#w "\n"); \
+	au_dpri_whlist(w); \
+} while (0)
+
+#define AuDbgVdir(v) do { \
+	LKTRTrace(#v "\n"); \
+	au_dpri_vdir(v); \
+} while (0)
+
+#define AuDbgInode(i) do { \
+	LKTRTrace(#i "\n"); \
+	au_dpri_inode(i); \
+} while (0)
+
+#define AuDbgDentry(d) do { \
+	LKTRTrace(#d "\n"); \
+	au_dpri_dentry(d); \
+} while (0)
+
+#define AuDbgFile(f) do { \
+	LKTRTrace(#f "\n"); \
+	au_dpri_file(f); \
+} while (0)
+
+#define AuDbgSb(sb) do { \
+	LKTRTrace(#sb "\n"); \
+	au_dpri_sb(sb); \
+} while (0)
+
+#define AuDbgSleep(sec) do { \
+	AuDbg("sleep %d sec\n", sec); \
+	au_dbg_sleep(sec); \
+} while (0)
+#else
+static inline int au_debug_init(void)
+{
+	return 0;
+}
+static inline void au_debug_sbinfo_init(struct au_sbinfo *sbinfo)
+{
+	/* empty */
+}
+#define AuDbgWhlist(w)		do {} while (0)
+#define AuDbgVdir(v)		do {} while (0)
+#define AuDbgInode(i)		do {} while (0)
+#define AuDbgDentry(d)		do {} while (0)
+#define AuDbgFile(f)		do {} while (0)
+#define AuDbgSb(sb)		do {} while (0)
+#define AuDbgSleep(sec)		do {} while (0)
+#endif /* CONFIG_AUFS_DEBUG */
+
+#ifdef DbgUdbaRace
+#define AuDbgSleep_UdbaRace()	AuDbgSleep(DbgUdbaRace)
+#else
+#define AuDbgSleep_UdbaRace()	do {} while (0)
+#endif
+
+#ifdef CONFIG_AUFS_MAGIC_SYSRQ
+int __init au_sysrq_init(void);
+void au_sysrq_fin(void);
+#else
+static inline int au_sysrq_init(void)
+{
+	return 0;
+}
+#define au_sysrq_fin()		do {} while (0)
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_DEBUG_H__ */
diff --git a/fs/aufs/sysrq.c b/fs/aufs/sysrq.c
new file mode 100644
index 0000000..69c3ae0
--- /dev/null
+++ b/fs/aufs/sysrq.c
@@ -0,0 +1,101 @@
+/*
+ * Copyright (C) 2008 Junjiro Okajima
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
+ * magic sysrq hanlder
+ */
+
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/sysrq.h>
+#include "aufs.h"
+
+static void sysrq_sb(struct super_block *sb)
+{
+	char *plevel;
+	struct inode *i;
+
+	plevel = au_plevel;
+	au_plevel = KERN_WARNING;
+	au_debug_on();
+
+	pr_warning(AUFS_NAME ": superblock\n");
+	au_dpri_sb(sb);
+	pr_warning(AUFS_NAME ": root dentry\n");
+	au_dpri_dentry(sb->s_root);
+#if 0 /* debug */
+	pr_warning(AUFS_NAME ": root inode\n");
+	au_dpri_inode(sb->s_root->d_inode);
+#endif
+	pr_warning(AUFS_NAME ": isolated inode\n");
+	list_for_each_entry(i, &sb->s_inodes, i_sb_list)
+		if (list_empty(&i->i_dentry))
+			au_dpri_inode(i);
+
+	au_plevel = plevel;
+	au_debug_off();
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* module parameter */
+static char *aufs_sysrq_key = "a";
+module_param_named(sysrq, aufs_sysrq_key, charp, S_IRUGO);
+MODULE_PARM_DESC(sysrq, "MagicSysRq key for " AUFS_NAME);
+
+static void au_sysrq(int key, struct tty_struct *tty)
+{
+	struct au_sbinfo *sbinfo;
+
+	/* au_sbilist_mtx is unnecessary here */
+	list_for_each_entry(sbinfo, &au_sbilist, si_list)
+		sysrq_sb(sbinfo->si_sb);
+}
+
+static struct sysrq_key_op au_sysrq_op = {
+	.handler	= au_sysrq,
+	.help_msg	= "Aufs",
+	.action_msg	= "Aufs",
+	/* todo: test mask? */
+	.enable_mask	= SYSRQ_ENABLE_DUMP
+};
+
+/* ---------------------------------------------------------------------- */
+
+int __init au_sysrq_init(void)
+{
+	int err;
+	char key;
+
+	err = -1;
+	key = *aufs_sysrq_key;
+	if ('a' <= key && key <= 'z')
+		err = register_sysrq_key(key, &au_sysrq_op);
+	if (unlikely(err))
+		AuErr("err %d, sysrq=%c\n", err, key);
+	return err;
+}
+
+void au_sysrq_fin(void)
+{
+	int err;
+	err = unregister_sysrq_key(*aufs_sysrq_key, &au_sysrq_op);
+	if (unlikely(err))
+		AuErr("err %d (ignored)\n", err);
+}
-- 
1.5.5.1.308.g1fbb5.dirty

