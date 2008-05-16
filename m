Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbYEPOvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbYEPOvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYEPOnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:43:07 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49266 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYEPOmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:17 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 12/67] aufs branch filesystems and xino for them
Date: Fri, 16 May 2008 23:32:26 +0900
Message-Id: <12109484012658-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484013264-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs branch filesystems and xino for them

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/branch.h |  345 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 345 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/branch.h b/fs/aufs/branch.h
new file mode 100644
index 0000000..a9146eb
--- /dev/null
+++ b/fs/aufs/branch.h
@@ -0,0 +1,345 @@
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
+ *
+ * $Id: branch.h,v 1.3 2008/04/28 03:03:32 sfjro Exp $
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
+	//__u32 h_gen;
+} __packed;
+
+//#define AuXino_INVALID_HGEN	(-1)
+
+/* a xino file */
+struct au_xino_file {
+	//struct file		**xi_file;
+	struct file		*xi_file;
+
+	/* array management */
+	//unsigned long long	xi_limit;	/* Max xino file size */
+	//unsigned long long	xi_size; /* s_maxbytes */
+
+	/* truncation */
+	blkcnt_t		xi_upper;	/* watermark in blocks */
+	//u64			xi_upper;	/* watermark in bytes */
+	//u64			xi_step;	/* to next watermark in bytes */
+	atomic_t 		xi_running;
+};
+
+/* protected by superblock rwsem */
+struct au_branch {
+	struct file		*br_xino;
+	//struct au_xino_file		*br_xino;
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
+#if 1
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
+#if 0 // rfu
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
+//todo: memory barrier?
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
+#if 0 // rfu
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
1.4.4.4

