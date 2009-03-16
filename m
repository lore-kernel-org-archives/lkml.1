Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbZCPHbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbZCPHbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbZCPHYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:24:11 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:35687 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309AbZCPHXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:23:04 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #2 25/28] aufs debug
Date: Mon, 16 Mar 2009 16:20:37 +0900
Message-Id: <1237188040-11404-26-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
debug print

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/debug.c |  406 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/debug.h |  245 +++++++++++++++++++++++++++++++++
 fs/aufs/sysrq.c |  106 +++++++++++++++
 3 files changed, 757 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/debug.c
 create mode 100644 fs/aufs/debug.h
 create mode 100644 fs/aufs/sysrq.c

diff --git a/fs/aufs/debug.c b/fs/aufs/debug.c
new file mode 100644
index 0000000..e8bc59c
--- /dev/null
+++ b/fs/aufs/debug.c
@@ -0,0 +1,406 @@
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
+ * debug print functions
+ */
+
+#include "aufs.h"
+
+atomic_t au_cond = ATOMIC_INIT(0);
+
+char *au_plevel = KERN_DEBUG;
+#define dpri(fmt, arg...) do { \
+	if (au_debug_test()) \
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
+	int l = 0;
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
+	dpri("i%d: i%lu, %s, cnt %d, nl %u, 0%o, sz %llu, blk %llu,"
+	     " ct %lld, np %lu, st 0x%lx, f 0x%x, g %x%s%.*s\n",
+	     bindex,
+	     inode->i_ino, inode->i_sb ? au_sbtype(inode->i_sb) : "??",
+	     atomic_read(&inode->i_count), inode->i_nlink, inode->i_mode,
+	     i_size_read(inode), (unsigned long long)inode->i_blocks,
+	     (long long)timespec_to_ns(&inode->i_ctime) & 0x0ffff,
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
+static int do_pri_dentry(aufs_bindex_t bindex, struct dentry *dentry)
+{
+	struct dentry *wh = NULL;
+
+	if (!dentry || IS_ERR(dentry)) {
+		dpri("d%d: err %ld\n", bindex, PTR_ERR(dentry));
+		return -1;
+	}
+	/* do not call dget_parent() here */
+	dpri("d%d: %.*s?/%.*s, %s, cnt %d, flags 0x%x\n",
+	     bindex,
+	     AuDLNPair(dentry->d_parent), AuDLNPair(dentry),
+	     dentry->d_sb ? au_sbtype(dentry->d_sb) : "??",
+	     atomic_read(&dentry->d_count), dentry->d_flags);
+	if (bindex >= 0 && dentry->d_inode && au_test_aufs(dentry->d_sb)) {
+		struct au_iinfo *iinfo = au_ii(dentry->d_inode);
+		if (iinfo)
+			wh = iinfo->ii_hinode[0 + bindex].hi_whdentry;
+	}
+	do_pri_inode(bindex, dentry->d_inode, wh);
+	return 0;
+}
+
+void au_dpri_dentry(struct dentry *dentry)
+{
+	struct au_dinfo *dinfo;
+	aufs_bindex_t bindex;
+	int err;
+
+	err = do_pri_dentry(-1, dentry);
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
+		do_pri_dentry(bindex, dinfo->di_hdentry[0 + bindex].hd_dentry);
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
+	dpri("f%d: mode 0x%x, flags 0%o, cnt %ld, pos %llu%s\n",
+	     bindex, file->f_mode, file->f_flags, (long)file_count(file),
+	     file->f_pos, a);
+	if (file->f_dentry)
+		do_pri_dentry(bindex, file->f_dentry);
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
+
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
+	dpri("s%d: {perm 0x%x, cnt %d, wbr %p}, "
+	     "%s, dev 0x%02x%02x, flags 0x%lx, cnt(BIAS) %d, active %d, "
+	     "xino %d\n",
+	     bindex, br->br_perm, atomic_read(&br->br_count), br->br_wbr,
+	     au_sbtype(sb), MAJOR(sb->s_dev), MINOR(sb->s_dev),
+	     sb->s_flags, sb->s_count - S_BIAS,
+	     atomic_read(&sb->s_active), !!br->br_xino.xi_file);
+	return 0;
+}
+
+void au_dpri_sb(struct super_block *sb)
+{
+	struct au_sbinfo *sbinfo;
+	aufs_bindex_t bindex;
+	int err;
+	/* to reuduce stack size */
+	struct {
+		struct vfsmount mnt;
+		struct au_branch fake;
+	} *a;
+
+	/* this function can be called from magic sysrq */
+	a = kzalloc(sizeof(*a), GFP_ATOMIC);
+	if (unlikely(!a)) {
+		dpri("no memory\n");
+		return;
+	}
+
+	a->mnt.mnt_sb = sb;
+	a->fake.br_perm = 0;
+	a->fake.br_mnt = &a->mnt;
+	a->fake.br_xino.xi_file = NULL;
+	atomic_set(&a->fake.br_count, 0);
+	smp_mb(); /* atomic_set */
+	err = do_pri_br(-1, &a->fake);
+	kfree(a);
+	dpri("dev 0x%x\n", sb->s_dev);
+	if (err || !au_test_aufs(sb))
+		return;
+
+	sbinfo = au_sbi(sb);
+	if (!sbinfo)
+		return;
+	dpri("nw %d, gen %u, kobj %d\n",
+	     atomic_read(&sbinfo->si_nowait.nw_len), sbinfo->si_generation,
+	     atomic_read(&sbinfo->si_kobj.kref.refcount));
+	for (bindex = 0; bindex <= sbinfo->si_bend; bindex++)
+		do_pri_br(bindex, sbinfo->si_branch[0 + bindex]);
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_dbg_sleep_jiffy(int jiffy)
+{
+	while (jiffy)
+		jiffy = schedule_timeout_uninterruptible(jiffy);
+}
+
+void au_dbg_iattr(struct iattr *ia)
+{
+#define AuBit(name)	if (ia->ia_valid & ATTR_ ## name) \
+				dpri(#name "\n")
+	AuBit(MODE);
+	AuBit(UID);
+	AuBit(GID);
+	AuBit(SIZE);
+	AuBit(ATIME);
+	AuBit(MTIME);
+	AuBit(CTIME);
+	AuBit(ATIME_SET);
+	AuBit(MTIME_SET);
+	AuBit(FORCE);
+	AuBit(ATTR_FLAG);
+	AuBit(KILL_SUID);
+	AuBit(KILL_SGID);
+	AuBit(FILE);
+	AuBit(KILL_PRIV);
+	AuBit(OPEN);
+	AuBit(TIMES_SET);
+#undef	AuBit
+	dpri("ia_file %p\n", ia->ia_file);
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_dbg_verify_dir_parent(struct dentry *dentry, unsigned int sigen)
+{
+	struct dentry *parent;
+
+	parent = dget_parent(dentry);
+	AuDebugOn(!S_ISDIR(dentry->d_inode->i_mode)
+		  || IS_ROOT(dentry)
+		  || au_digen(parent) != sigen);
+	dput(parent);
+}
+
+void au_dbg_verify_nondir_parent(struct dentry *dentry, unsigned int sigen)
+{
+	struct dentry *parent;
+
+	parent = dget_parent(dentry);
+	AuDebugOn(S_ISDIR(dentry->d_inode->i_mode)
+		  || au_digen(parent) != sigen);
+	dput(parent);
+}
+
+void au_dbg_verify_gen(struct dentry *parent, unsigned int sigen)
+{
+	int err, i, j;
+	struct au_dcsub_pages dpages;
+	struct au_dpage *dpage;
+	struct dentry **dentries;
+
+	err = au_dpages_init(&dpages, GFP_NOFS);
+	AuDebugOn(err);
+	err = au_dcsub_pages_rev(&dpages, parent, /*do_include*/1, NULL, NULL);
+	AuDebugOn(err);
+	for (i = dpages.ndpage - 1; !err && i >= 0; i--) {
+		dpage = dpages.dpages + i;
+		dentries = dpage->dentries;
+		for (j = dpage->ndentry - 1; !err && j >= 0; j--)
+			AuDebugOn(au_digen(dentries[j]) != sigen);
+	}
+	au_dpages_free(&dpages);
+}
+
+void au_dbg_verify_hf(struct au_finfo *finfo)
+{
+	struct au_hfile *hf;
+	aufs_bindex_t bend, bindex;
+
+	if (finfo->fi_bstart >= 0) {
+		bend = finfo->fi_bend;
+		for (bindex = finfo->fi_bstart; bindex <= bend; bindex++) {
+			hf = finfo->fi_hfile + bindex;
+			AuDebugOn(hf->hf_file || hf->hf_br);
+		}
+	}
+}
+
+void au_dbg_verify_kthread(void)
+{
+	if (au_test_wkq(current)) {
+		au_dbg_blocked();
+		BUG();
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_debug_sbinfo_init(struct au_sbinfo *sbinfo __maybe_unused)
+{
+#ifdef AuForceNoPlink
+	au_opt_clr(sbinfo->si_mntflags, PLINK);
+#endif
+#ifdef AuForceNoXino
+	au_opt_clr(sbinfo->si_mntflags, XINO);
+#endif
+#ifdef AuForceNoRefrof
+	au_opt_clr(sbinfo->si_mntflags, REFROF);
+#endif
+#ifdef AuForceHinotify
+	au_opt_set_udba(sbinfo->si_mntflags, UDBA_HINOTIFY);
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
+#ifdef AuForceNoBrs
+	sysaufs_brs = 0;
+#endif
+
+	return 0;
+}
diff --git a/fs/aufs/debug.h b/fs/aufs/debug.h
new file mode 100644
index 0000000..0b377a8
--- /dev/null
+++ b/fs/aufs/debug.h
@@ -0,0 +1,245 @@
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
+ * debug print functions
+ */
+
+#ifndef __AUFS_DEBUG_H__
+#define __AUFS_DEBUG_H__
+
+#ifdef __KERNEL__
+
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/kd.h>
+#include <linux/vt_kern.h>
+#include <linux/sysrq.h>
+#include <linux/aufs_type.h>
+
+#ifdef CONFIG_AUFS_DEBUG
+#define AuDebugOn(a)		BUG_ON(a)
+extern atomic_t au_cond;
+static inline void au_debug(int n)
+{
+	atomic_set(&au_cond, n);
+	smp_mb();
+}
+
+static inline int au_debug_test(void)
+{
+	int ret;
+
+	ret = atomic_read(&au_cond);
+	smp_mb();
+	return ret;
+}
+#else
+#define AuDebugOn(a)		do {} while (0)
+#define au_debug()		do {} while (0)
+static inline int au_debug_test(void)
+{
+	return 0;
+}
+#endif /* CONFIG_AUFS_DEBUG */
+
+/* ---------------------------------------------------------------------- */
+
+/* debug print */
+
+#define AuDpri(lvl, fmt, arg...) \
+	printk(lvl AUFS_NAME " %s:%d:%s[%d]: " fmt, \
+	       __func__, __LINE__, current->comm, current->pid, ##arg)
+#define AuDbg(fmt, arg...) do { \
+	if (au_debug_test()) \
+		AuDpri(KERN_DEBUG, fmt, ##arg); \
+} while (0)
+#define AuLabel(l) 		AuDbg(#l "\n")
+#define AuInfo(fmt, arg...)	AuDpri(KERN_INFO, fmt, ##arg)
+#define AuWarn(fmt, arg...)	AuDpri(KERN_WARNING, fmt, ##arg)
+#define AuErr(fmt, arg...)	AuDpri(KERN_ERR, fmt, ##arg)
+#define AuIOErr(fmt, arg...)	AuErr("I/O Error, " fmt, ##arg)
+#define AuWarn1(fmt, arg...) do { \
+	static unsigned char _c; \
+	if (!_c++) \
+		AuWarn(fmt, ##arg); \
+} while (0)
+
+#define AuErr1(fmt, arg...) do { \
+	static unsigned char _c; \
+	if (!_c++) \
+		AuErr(fmt, ##arg); \
+} while (0)
+
+#define AuIOErr1(fmt, arg...) do { \
+	static unsigned char _c; \
+	if (!_c++) \
+		AuIOErr(fmt, ##arg); \
+} while (0)
+
+#define AuUnsupportMsg	"This operation is not supported." \
+			" Please report this application to aufs-users ML."
+#define AuUnsupport(fmt, args...) do { \
+	AuErr(AuUnsupportMsg "\n" fmt, ##args); \
+	dump_stack(); \
+} while (0)
+
+#define AuTraceErr(e) do { \
+	if (unlikely((e) < 0)) \
+		AuDbg("err %d\n", (int)(e)); \
+} while (0)
+
+#define AuTraceErrPtr(p) do { \
+	if (IS_ERR(p)) \
+		AuDbg("err %ld\n", PTR_ERR(p)); \
+} while (0)
+
+/* dirty macros for debug print, use with "%.*s" and caution */
+#define AuLNPair(qstr)		(qstr)->len, (qstr)->name
+#define AuDLNPair(d)		AuLNPair(&(d)->d_name)
+
+/* ---------------------------------------------------------------------- */
+
+struct au_sbinfo;
+struct au_finfo;
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
+
+void au_dbg_sleep_jiffy(int jiffy);
+void au_dbg_iattr(struct iattr *ia);
+
+void au_dbg_verify_dir_parent(struct dentry *dentry, unsigned int sigen);
+void au_dbg_verify_nondir_parent(struct dentry *dentry, unsigned int sigen);
+void au_dbg_verify_gen(struct dentry *parent, unsigned int sigen);
+void au_dbg_verify_hf(struct au_finfo *finfo);
+void au_dbg_verify_kthread(void);
+
+int __init au_debug_init(void);
+void au_debug_sbinfo_init(struct au_sbinfo *sbinfo);
+#define AuDbgWhlist(w) do { \
+	AuDbg(#w "\n"); \
+	au_dpri_whlist(w); \
+} while (0)
+
+#define AuDbgVdir(v) do { \
+	AuDbg(#v "\n"); \
+	au_dpri_vdir(v); \
+} while (0)
+
+#define AuDbgInode(i) do { \
+	AuDbg(#i "\n"); \
+	au_dpri_inode(i); \
+} while (0)
+
+#define AuDbgDentry(d) do { \
+	AuDbg(#d "\n"); \
+	au_dpri_dentry(d); \
+} while (0)
+
+#define AuDbgFile(f) do { \
+	AuDbg(#f "\n"); \
+	au_dpri_file(f); \
+} while (0)
+
+#define AuDbgSb(sb) do { \
+	AuDbg(#sb "\n"); \
+	au_dpri_sb(sb); \
+} while (0)
+
+#define AuDbgSleep(sec) do { \
+	AuDbg("sleep %d sec\n", sec); \
+	ssleep(sec); \
+} while (0)
+
+#define AuDbgSleepJiffy(jiffy) do { \
+	AuDbg("sleep %d jiffies\n", jiffy); \
+	au_dbg_sleep_jiffy(jiffy); \
+} while (0)
+
+#define AuDbgIAttr(ia) do { \
+	AuDbg("ia_valid 0x%x\n", (ia)->ia_valid); \
+	au_dbg_iattr(ia); \
+} while (0)
+#else
+static inline void au_dbg_verify_dir_parent(struct dentry *dentry,
+					    unsigned int sigen)
+{
+	/* empty */
+}
+static inline void au_dbg_verify_nondir_parent(struct dentry *dentry,
+					   unsigned int sigen)
+{
+	/* empty */
+}
+static inline void au_dbg_verify_gen(struct dentry *parent, unsigned int sigen)
+{
+	/* empty */
+}
+static inline void au_dbg_verify_hf(struct au_finfo *finfo)
+{
+	/* empty */
+}
+static inline void au_dbg_verify_kthread(void)
+{
+	/* empty */
+}
+
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
+#define AuDbgSleepJiffy(jiffy)	do {} while (0)
+#define AuDbgIAttr(ia)		do {} while (0)
+#endif /* CONFIG_AUFS_DEBUG */
+
+/* ---------------------------------------------------------------------- */
+
+#ifdef CONFIG_AUFS_MAGIC_SYSRQ
+int __init au_sysrq_init(void);
+void au_sysrq_fin(void);
+
+#ifdef CONFIG_HW_CONSOLE
+#define au_dbg_blocked() do { \
+	WARN_ON(1); \
+	handle_sysrq('w', vc_cons[fg_console].d->vc_tty); \
+} while (0)
+#else
+#define au_dbg_blocked()	do {} while (0)
+#endif
+
+#else
+static inline int au_sysrq_init(void)
+{
+	return 0;
+}
+#define au_sysrq_fin()		do {} while (0)
+#define au_dbg_blocked()	do {} while (0)
+#endif /* CONFIG_AUFS_MAGIC_SYSRQ */
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_DEBUG_H__ */
diff --git a/fs/aufs/sysrq.c b/fs/aufs/sysrq.c
new file mode 100644
index 0000000..419ff2c
--- /dev/null
+++ b/fs/aufs/sysrq.c
@@ -0,0 +1,106 @@
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
+ * magic sysrq hanlder
+ */
+
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+/* #include <linux/sysrq.h> */
+#include "aufs.h"
+
+/* ---------------------------------------------------------------------- */
+
+static void sysrq_sb(struct super_block *sb)
+{
+	char *plevel;
+	struct au_sbinfo *sbinfo;
+	struct file *file;
+
+	plevel = au_plevel;
+	au_plevel = KERN_WARNING;
+	au_debug(1);
+
+	sbinfo = au_sbi(sb);
+	pr_warning("si=%lx\n", sysaufs_si_id(sbinfo));
+	pr_warning(AUFS_NAME ": superblock\n");
+	au_dpri_sb(sb);
+	pr_warning(AUFS_NAME ": root dentry\n");
+	au_dpri_dentry(sb->s_root);
+	pr_warning(AUFS_NAME ": root inode\n");
+	au_dpri_inode(sb->s_root->d_inode);
+#if 0
+	struct inode *i;
+	pr_warning(AUFS_NAME ": isolated inode\n");
+	list_for_each_entry(i, &sb->s_inodes, i_sb_list)
+		if (list_empty(&i->i_dentry))
+			au_dpri_inode(i);
+#endif
+	pr_warning(AUFS_NAME ": files\n");
+	list_for_each_entry(file, &sb->s_files, f_u.fu_list)
+		if (!special_file(file->f_dentry->d_inode->i_mode))
+			au_dpri_file(file);
+
+	au_plevel = plevel;
+	au_debug(0);
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* module parameter */
+static char *aufs_sysrq_key = "a";
+module_param_named(sysrq, aufs_sysrq_key, charp, S_IRUGO);
+MODULE_PARM_DESC(sysrq, "MagicSysRq key for " AUFS_NAME);
+
+static void au_sysrq(int key __maybe_unused,
+		     struct tty_struct *tty __maybe_unused)
+{
+	struct kobject *kobj;
+	struct au_sbinfo *sbinfo;
+
+	/* spin_lock(&sysaufs_ket->list_lock); */
+	list_for_each_entry(kobj, &sysaufs_ket->list, entry) {
+		sbinfo = container_of(kobj, struct au_sbinfo, si_kobj);
+		sysrq_sb(sbinfo->si_sb);
+	}
+	/* spin_unlock(&sysaufs_ket->list_lock); */
+}
+
+static struct sysrq_key_op au_sysrq_op = {
+	.handler	= au_sysrq,
+	.help_msg	= "Aufs",
+	.action_msg	= "Aufs",
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
1.6.1.284.g5dc13

