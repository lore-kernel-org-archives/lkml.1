Return-Path: <linux-kernel-owner+w=401wt.eu-S934989AbYEUDia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934989AbYEUDia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbYEUDdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:33:22 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44094 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830AbYEUDc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:32:57 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 24/39] aufs inode
Date: Wed, 21 May 2008 12:22:54 +0900
Message-Id: <1211340189-11813-25-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
inode functions and private data

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/iinfo.c |  275 ++++++++++++++++++++++++++++++++++++++
 fs/aufs/inode.c |  400 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/inode.h |  334 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1009 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/iinfo.c
 create mode 100644 fs/aufs/inode.c
 create mode 100644 fs/aufs/inode.h

diff --git a/fs/aufs/iinfo.c b/fs/aufs/iinfo.c
new file mode 100644
index 0000000..f9230a9
--- /dev/null
+++ b/fs/aufs/iinfo.c
@@ -0,0 +1,275 @@
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
+ * inode private data
+ */
+
+#include "aufs.h"
+
+struct au_iinfo *au_ii(struct inode *inode)
+{
+	struct au_iinfo *iinfo;
+
+	iinfo = &(container_of(inode, struct aufs_icntnr, vfs_inode)->iinfo);
+	/* bad_inode case */
+	if (unlikely(!iinfo->ii_hinode))
+		return NULL;
+	AuDebugOn(!iinfo->ii_hinode
+		  /* || au_sbi(inode->i_sb)->si_bend < iinfo->ii_bend */
+		  || iinfo->ii_bend < iinfo->ii_bstart);
+	return iinfo;
+}
+
+struct inode *au_h_iptr(struct inode *inode, aufs_bindex_t bindex)
+{
+	struct inode *hidden_inode;
+
+	IiMustAnyLock(inode);
+	AuDebugOn(bindex < 0 || au_ibend(inode) < bindex);
+	hidden_inode = au_ii(inode)->ii_hinode[0 + bindex].hi_inode;
+	AuDebugOn(hidden_inode && atomic_read(&hidden_inode->i_count) <= 0);
+	return hidden_inode;
+}
+
+aufs_bindex_t au_ii_br_id(struct inode *inode, aufs_bindex_t bindex)
+{
+	IiMustAnyLock(inode);
+	AuDebugOn(bindex < 0
+		  || au_ibend(inode) < bindex
+		  || !au_ii(inode)->ii_hinode[0 + bindex].hi_inode);
+	return au_ii(inode)->ii_hinode[0 + bindex].hi_id;
+}
+
+/* todo: hard/soft set? */
+void au_set_ibstart(struct inode *inode, aufs_bindex_t bindex)
+{
+	struct au_iinfo *iinfo = au_ii(inode);
+	struct inode *h_inode;
+
+	IiMustWriteLock(inode);
+	AuDebugOn(au_sbend(inode->i_sb) < bindex);
+	iinfo->ii_bstart = bindex;
+	h_inode = iinfo->ii_hinode[bindex + 0].hi_inode;
+	if (h_inode)
+		au_cpup_igen(inode, h_inode);
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
+	if (unlikely(isdir && au_opt_test(mnt_flags, UDBA_INOTIFY)))
+		au_fset_hi(flags, NOTIFY);
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
+	LKTRTrace("i%lu, b%d, hi%lu, flags 0x%x\n",
+		  inode->i_ino, bindex, h_inode ? h_inode->i_ino : 0, flags);
+	IiMustWriteLock(inode);
+	hinode = iinfo->ii_hinode + bindex;
+	hi = hinode->hi_inode;
+	AuDebugOn(bindex < au_ibstart(inode) || au_ibend(inode) < bindex
+		  || (h_inode && atomic_read(&h_inode->i_count) <= 0)
+		  || (h_inode && hi));
+
+	if (hi)
+		au_hiput(hinode);
+	hinode->hi_inode = h_inode;
+	if (h_inode) {
+		int err;
+		struct super_block *sb = inode->i_sb;
+
+		if (bindex == iinfo->ii_bstart)
+			au_cpup_igen(inode, h_inode);
+		hinode->hi_id = au_sbr_id(sb, bindex);
+		if (au_ftest_hi(flags, XINO)) {
+			struct au_xino_entry xinoe = {
+				.ino	= inode->i_ino,
+				/* .h_gen	= h_inode->i_generation */
+			};
+			err = au_xino_write(sb, bindex, h_inode->i_ino, &xinoe);
+			if (unlikely(err))
+				AuIOErr1("failed au_xino_write() %d\n", err);
+		}
+
+		if (unlikely(au_ftest_hi(flags, NOTIFY)
+			     && au_br_hinotifyable(au_sbr_perm(sb, bindex)))) {
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
+	IiMustWriteLock(inode);
+	hinode = au_ii(inode)->ii_hinode + bindex;
+	AuDebugOn(hinode->hi_whdentry);
+	hinode->hi_whdentry = h_wh;
+}
+
+void au_update_iigen(struct inode *inode)
+{
+	AuDebugOn(!inode->i_sb);
+	atomic_set(&au_ii(inode)->ii_generation, au_sigen(inode->i_sb));
+	/* smp_mb(); */ /* atomic_set */
+}
+
+/* it may be called at remount time, too */
+void au_update_brange(struct inode *inode, int do_put_zero)
+{
+	struct au_iinfo *iinfo;
+
+	LKTRTrace("i%lu, %d\n", inode->i_ino, do_put_zero);
+	IiMustWriteLock(inode);
+
+	iinfo = au_ii(inode);
+	if (unlikely(!iinfo) || iinfo->ii_bstart < 0)
+		return;
+
+	if (do_put_zero) {
+		aufs_bindex_t bindex;
+		for (bindex = iinfo->ii_bstart; bindex <= iinfo->ii_bend;
+		     bindex++) {
+			struct inode *h_i;
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
+	AuDebugOn(!sb);
+	iinfo = &(container_of(inode, struct aufs_icntnr, vfs_inode)->iinfo);
+	AuDebugOn(iinfo->ii_hinode);
+	nbr = au_sbend(sb) + 1;
+	if (unlikely(nbr <= 0))
+		nbr = 1;
+	iinfo->ii_hinode = kcalloc(nbr, sizeof(*iinfo->ii_hinode), GFP_KERNEL);
+	if (iinfo->ii_hinode) {
+		for (i = 0; i < nbr; i++)
+			iinfo->ii_hinode[i].hi_id = -1;
+		atomic_set(&iinfo->ii_generation, au_sigen(sb));
+		/* smp_mb(); */ /* atomic_set */
+		au_rw_init_nolock(&iinfo->ii_rwsem);
+		iinfo->ii_bstart = -1;
+		iinfo->ii_bend = -1;
+		iinfo->ii_vdir = NULL;
+		return 0;
+	}
+	return -ENOMEM;
+}
+
+static int au_iinfo_write0(struct super_block *sb, struct au_hinode *hinode,
+			   ino_t ino)
+{
+	int err, locked;
+	aufs_bindex_t bindex;
+
+	err = 0;
+	locked = si_read_trylock(sb, !AuLock_FLUSH); /* crucio! */
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
+	struct au_iinfo *iinfo;
+	aufs_bindex_t bend;
+	struct au_hinode *hi;
+	struct super_block *sb;
+	int unlinked;
+	ino_t ino;
+
+	iinfo = au_ii(inode);
+	/* bad_inode case */
+	if (unlikely(!iinfo))
+		return;
+
+	if (unlikely(iinfo->ii_vdir))
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
+}
diff --git a/fs/aufs/inode.c b/fs/aufs/inode.c
new file mode 100644
index 0000000..f7f9150
--- /dev/null
+++ b/fs/aufs/inode.c
@@ -0,0 +1,400 @@
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
+ * inode functions
+ */
+
+#include "aufs.h"
+
+int au_refresh_hinode_self(struct inode *inode)
+{
+	int err, new_sz, update;
+	struct inode *first;
+	struct au_hinode *p, *q, tmp;
+	struct super_block *sb;
+	struct au_iinfo *iinfo;
+	aufs_bindex_t bindex, bend, new_bindex;
+
+	LKTRTrace("i%lu\n", inode->i_ino);
+	IiMustWriteLock(inode);
+
+	err = -ENOMEM;
+	update = 0;
+	sb = inode->i_sb;
+	bend = au_sbend(sb);
+	new_sz = sizeof(*iinfo->ii_hinode) * (bend + 1);
+	iinfo = au_ii(inode);
+	p = au_kzrealloc(iinfo->ii_hinode, sizeof(*p) * (iinfo->ii_bend + 1),
+			 new_sz, GFP_KERNEL);
+	if (unlikely(!p))
+		goto out;
+
+	iinfo->ii_hinode = p;
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
+		/* swap two hidden inode, and loop again */
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
+
+	if (unlikely(err))
+		goto out;
+
+	if (1 || first != au_h_iptr(inode, iinfo->ii_bstart))
+		au_cpup_attr_all(inode);
+	if (update && S_ISDIR(inode->i_mode))
+		inode->i_version++;
+	au_update_iigen(inode);
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+int au_refresh_hinode(struct inode *inode, struct dentry *dentry)
+{
+	int err, update, isdir;
+	struct inode *first;
+	struct au_hinode *p;
+	struct super_block *sb;
+	struct au_iinfo *iinfo;
+	aufs_bindex_t bindex, bend;
+	unsigned int flags;
+
+	LKTRTrace("%.*s\n", AuDLNPair(dentry));
+	IiMustWriteLock(inode);
+
+	err = au_refresh_hinode_self(inode);
+	if (unlikely(err))
+		goto out;
+
+	sb = dentry->d_sb;
+	bend = au_sbend(sb);
+	iinfo = au_ii(inode);
+	update = 0;
+	p = iinfo->ii_hinode + iinfo->ii_bstart;
+	first = p->hi_inode;
+	isdir = S_ISDIR(inode->i_mode);
+	flags = au_hi_flags(inode, isdir);
+	bend = au_dbend(dentry);
+	for (bindex = au_dbstart(dentry); bindex <= bend; bindex++) {
+		struct inode *hi;
+		struct dentry *hd;
+
+		hd = au_h_dptr(dentry, bindex);
+		if (!hd || !hd->d_inode)
+			continue;
+
+		if (iinfo->ii_bstart <= bindex && bindex <= iinfo->ii_bend) {
+			hi = au_h_iptr(inode, bindex);
+			if (hi) {
+				if (hi == hd->d_inode)
+					continue;
+				err = -ESTALE;
+				break;
+			}
+		}
+		if (bindex < iinfo->ii_bstart)
+			iinfo->ii_bstart = bindex;
+		if (iinfo->ii_bend < bindex)
+			iinfo->ii_bend = bindex;
+		au_set_h_iptr(inode, bindex, igrab(hd->d_inode), flags);
+		update++;
+	}
+	au_update_brange(inode, /*do_put_zero*/0);
+
+	if (unlikely(err))
+		goto out;
+
+	if (1 || first != au_h_iptr(inode, iinfo->ii_bstart))
+		au_cpup_attr_all(inode);
+	if (update && isdir)
+		inode->i_version++;
+	au_update_iigen(inode);
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+static int set_inode(struct inode *inode, struct dentry *dentry)
+{
+	int err, isdir;
+	struct dentry *h_dentry;
+	struct inode *h_inode;
+	umode_t mode;
+	aufs_bindex_t bindex, bstart, btail;
+	struct au_iinfo *iinfo;
+	unsigned int flags;
+
+	LKTRTrace("i%lu, %.*s\n", inode->i_ino, AuDLNPair(dentry));
+	AuDebugOn(!(inode->i_state & I_NEW));
+	IiMustWriteLock(inode);
+	bstart = au_dbstart(dentry);
+	h_dentry = au_h_dptr(dentry, bstart);
+	AuDebugOn(!h_dentry);
+	h_inode = h_dentry->d_inode;
+	AuDebugOn(!h_inode);
+
+	err = 0;
+	isdir = 0;
+	mode = h_inode->i_mode;
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+		btail = au_dbtail(dentry);
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
+		init_special_inode(inode, mode,
+				   au_h_rdev(h_inode, /*h_mnt*/NULL, h_dentry));
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
+		if (!h_dentry)
+			continue;
+		AuDebugOn(!h_dentry->d_inode);
+		au_set_h_iptr(inode, bindex, igrab(h_dentry->d_inode), flags);
+	}
+	au_cpup_attr_all(inode);
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+/* successful returns with iinfo write_locked */
+/* todo: return with unlocked? */
+static int reval_inode(struct inode *inode, struct dentry *dentry, int *matched)
+{
+	int err;
+	struct inode *h_inode, *h_dinode;
+	aufs_bindex_t bindex, bend;
+
+	LKTRTrace("i%lu, %.*s\n", inode->i_ino, AuDLNPair(dentry));
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
+	err = 0;
+	h_dinode = au_h_dptr(dentry, au_dbstart(dentry))->d_inode;
+	mutex_lock_nested(&inode->i_mutex, AuLsc_I_CHILD);
+	ii_write_lock_new(inode);
+	bend = au_ibend(inode);
+	for (bindex = au_ibstart(inode); bindex <= bend; bindex++) {
+		h_inode = au_h_iptr(inode, bindex);
+		if (h_inode && h_inode == h_dinode) {
+			/* && (ibs != bstart
+			   || !au_test_higen(inode, h_inode))); */
+			*matched = 1;
+			err = 0;
+			if (unlikely(au_iigen(inode) != au_digen(dentry)))
+				err = au_refresh_hinode(inode, dentry);
+			break;
+		}
+	}
+	if (unlikely(err))
+		ii_write_unlock(inode);
+	mutex_unlock(&inode->i_mutex);
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+/* successful returns with iinfo write_locked */
+/* todo: return with unlocked? */
+struct inode *au_new_inode(struct dentry *dentry)
+{
+	struct inode *inode, *h_inode;
+	struct dentry *h_dentry;
+	ino_t h_ino;
+	struct super_block *sb;
+	int err, match;
+	aufs_bindex_t bstart;
+	struct au_xino_entry xinoe;
+
+	LKTRTrace("%.*s\n", AuDLNPair(dentry));
+	sb = dentry->d_sb;
+	bstart = au_dbstart(dentry);
+	h_dentry = au_h_dptr(dentry, bstart);
+	AuDebugOn(!h_dentry);
+	h_inode = h_dentry->d_inode;
+	AuDebugOn(!h_inode);
+
+	h_ino = h_inode->i_ino;
+	err = au_xino_read(sb, bstart, h_ino, &xinoe);
+	inode = ERR_PTR(err);
+	if (unlikely(err))
+		goto out;
+ new_ino:
+	if (!xinoe.ino) {
+		xinoe.ino = au_xino_new_ino(sb);
+		if (!xinoe.ino) {
+			inode = ERR_PTR(-EIO);
+			goto out;
+		}
+	}
+
+	LKTRTrace("i%lu\n", xinoe.ino);
+	inode = au_iget_locked(sb, xinoe.ino);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out;
+
+	LKTRTrace("%lx, new %d\n", inode->i_state, !!(inode->i_state & I_NEW));
+	if (inode->i_state & I_NEW) {
+		ii_write_lock_new(inode);
+		err = set_inode(inode, dentry);
+		unlock_new_inode(inode);
+		if (!err)
+			goto out; /* success */
+		iget_failed(inode);
+		ii_write_unlock(inode);
+		goto out_iput;
+	} else {
+		AuDebugOn(inode->i_state & I_LOCK);
+		err = reval_inode(inode, dentry, &match);
+		if (!err)
+			goto out; /* success */
+		else if (match)
+			goto out_iput;
+	}
+
+	if (unlikely(au_test_unique_ino(h_dentry, h_ino)))
+		AuWarn1("Un-notified UDBA or repeatedly renamed dir,"
+			" b%d, %s, %.*s, hi%lu, i%lu.\n",
+			bstart, au_sbtype(h_dentry->d_sb), AuDLNPair(dentry),
+			h_ino, xinoe.ino);
+	xinoe.ino = 0;
+	err = au_xino_write0(sb, bstart, h_ino, 0);
+	if (!err) {
+		iput(inode);
+		goto new_ino;
+	}
+	/* force noxino? */
+
+ out_iput:
+	iput(inode);
+	inode = ERR_PTR(err);
+ out:
+	AuTraceErrPtr(inode);
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
+	/* pseudo-link after flushed may out of bounds */
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
+	AuTraceErr(err);
+	return err;
+}
+
+int au_test_h_perm(struct inode *h_inode, int mask, int dlgt)
+{
+	if (!current->fsuid)
+		return 0;
+	/* todo: fake nameidata? */
+	return vfsub_permission(h_inode, mask, NULL, dlgt);
+}
+
+int au_test_h_perm_sio(struct inode *h_inode, int mask, int dlgt)
+{
+	if (unlikely(au_test_nfs(h_inode->i_sb)
+		     && (mask & MAY_WRITE)
+		     && S_ISDIR(h_inode->i_mode)))
+		mask |= MAY_READ; /* force permission check */
+	return au_test_h_perm(h_inode, mask, dlgt);
+}
diff --git a/fs/aufs/inode.h b/fs/aufs/inode.h
new file mode 100644
index 0000000..ce061d5
--- /dev/null
+++ b/fs/aufs/inode.h
@@ -0,0 +1,334 @@
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
+ * inode operations
+ */
+
+#ifndef __AUFS_INODE_H__
+#define __AUFS_INODE_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/security.h>
+#include <linux/aufs_type.h>
+#include "hinode.h"
+#include "misc.h"
+#include "super.h"
+
+struct au_hinode;
+struct au_vdir;
+struct au_iinfo {
+	atomic_t		ii_generation;
+	struct super_block	*ii_hsb1;	/* no get/put */
+
+	struct au_rwsem		ii_rwsem;
+	aufs_bindex_t		ii_bstart, ii_bend;
+	struct au_hinode	*ii_hinode;
+	struct au_vdir		*ii_vdir;
+};
+
+struct aufs_icntnr {
+	struct au_iinfo iinfo;
+	struct inode vfs_inode;
+};
+
+/* ---------------------------------------------------------------------- */
+
+/* inode.c */
+int au_refresh_hinode_self(struct inode *inode);
+int au_refresh_hinode(struct inode *inode, struct dentry *dentry);
+struct inode *au_new_inode(struct dentry *dentry);
+int au_test_ro(struct super_block *sb, aufs_bindex_t bindex,
+	       struct inode *inode);
+int au_test_h_perm(struct inode *h_inode, int mask, int dlgt);
+int au_test_h_perm_sio(struct inode *h_inode, int mask, int dlgt);
+
+/* i_op.c */
+extern struct inode_operations aufs_iop, aufs_symlink_iop, aufs_dir_iop;
+
+/* au_wr_dir flags */
+#define AuWrDir_ADD_ENTRY	1
+#define AuWrDir_LOCK_SRCDIR	(1 << 1)
+#define AuWrDir_ISDIR		(1 << 2)
+#define au_ftest_wrdir(flags, name)	((flags) & AuWrDir_##name)
+#define au_fset_wrdir(flags, name)	{ (flags) |= AuWrDir_##name; }
+#define au_fclr_wrdir(flags, name)	{ (flags) &= ~AuWrDir_##name; }
+
+struct au_wr_dir_args {
+	aufs_bindex_t force_btgt;
+	unsigned int flags;
+};
+int au_wr_dir(struct dentry *dentry, struct dentry *src_dentry,
+	      struct au_wr_dir_args *args);
+
+/* i_op_add.c */
+struct au_ndx;
+int au_may_add(struct dentry *dentry, aufs_bindex_t bindex,
+	       struct dentry *h_parent, int isdir, struct au_ndx *ndx);
+int aufs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
+int aufs_symlink(struct inode *dir, struct dentry *dentry, const char *symname);
+int aufs_create(struct inode *dir, struct dentry *dentry, int mode,
+		struct nameidata *nd);
+int aufs_link(struct dentry *src_dentry, struct inode *dir,
+	      struct dentry *dentry);
+int aufs_mkdir(struct inode *dir, struct dentry *dentry, int mode);
+
+/* i_op_del.c */
+int au_wr_dir_need_wh(struct dentry *dentry, int isdir, aufs_bindex_t *bcpup,
+		      struct dentry *locked);
+int au_may_del(struct dentry *dentry, aufs_bindex_t bindex,
+	       struct dentry *h_parent, int isdir, struct au_ndx *ndx);
+int aufs_unlink(struct inode *dir, struct dentry *dentry);
+int aufs_rmdir(struct inode *dir, struct dentry *dentry);
+
+/* i_op_ren.c */
+int au_wbr(struct dentry *dentry, aufs_bindex_t btgt);
+int aufs_rename(struct inode *src_dir, struct dentry *src_dentry,
+		struct inode *dir, struct dentry *dentry);
+
+#ifdef CONFIG_AUFS_DLGT
+/* dlgt.c */
+int au_security_inode_permission(struct inode *h_inode, int mask,
+				 struct nameidata *fake_nd, int dlgt);
+#else
+static inline
+int au_security_inode_permission(struct inode *h_inode, int mask,
+				 struct nameidata *fake_nd, int dlgt)
+{
+	return security_inode_permission(h_inode, mask, fake_nd);
+}
+#endif /* CONFIG_AUFS_DLGT */
+
+#ifdef CONFIG_AUFS_WORKAROUND_FUSE
+/* br_fuse.c */
+int aufs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *st);
+#endif
+
+#if 0 /* reserved for future use */
+/* xattr.c */
+int aufs_setxattr(struct dentry *dentry, const char *name, const void *value,
+		  size_t sz, int flags);
+ssize_t aufs_getxattr(struct dentry *dentry, const char *name, void *value,
+		      size_t sz);
+ssize_t aufs_listxattr(struct dentry *dentry, char *list, size_t sz);
+int aufs_removexattr(struct dentry *dentry, const char *name);
+#endif
+
+/* iinfo.c */
+struct au_iinfo *au_ii(struct inode *inode);
+struct inode *au_h_iptr(struct inode *inode, aufs_bindex_t bindex);
+aufs_bindex_t au_ii_br_id(struct inode *inode, aufs_bindex_t bindex);
+
+void au_set_ibstart(struct inode *inode, aufs_bindex_t bindex);
+void au_set_hi_wh(struct inode *inode, aufs_bindex_t bindex,
+		  struct dentry *h_wh);
+unsigned int au_hi_flags(struct inode *inode, int isdir);
+
+/* hinode flags */
+#define AuHi_XINO	1
+#define AuHi_NOTIFY	(1 << 1)
+#define au_ftest_hi(flags, name)	((flags) & AuHi_##name)
+#define au_fset_hi(flags, name)		{ (flags) |= AuHi_##name; }
+#define au_fclr_hi(flags, name)		{ (flags) &= ~AuHi_##name; }
+#ifndef CONFIG_AUFS_HINOTIFY
+#undef AuHi_NOTIFY
+#define AuHi_NOTIFY	0
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
+
+/* plink.c */
+#ifdef CONFIG_AUFS_DEBUG
+void au_plink_list(struct super_block *sb);
+#else
+static inline void au_plink_list(struct super_block *sb)
+{
+	/* nothing */
+}
+#endif
+int au_plink_test(struct super_block *sb, struct inode *inode);
+struct dentry *au_plink_lkup(struct super_block *sb, aufs_bindex_t bindex,
+			     struct inode *inode);
+void au_plink_append(struct super_block *sb, struct inode *inode,
+		     struct dentry *h_dentry, aufs_bindex_t bindex);
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
+	AuLsc_II_PARENT,
+	AuLsc_II_PARENT2,
+	AuLsc_II_PARENT3,
+	AuLsc_II_PARENT4,
+	AuLsc_II_NEW		/* new inode */
+};
+
+/*
+ * ii_read_lock_child, ii_write_lock_child,
+ * ii_read_lock_child2, ii_write_lock_child2,
+ * ii_read_lock_child3, ii_write_lock_child3,
+ * ii_read_lock_parent, ii_write_lock_parent,
+ * ii_read_lock_parent2, ii_write_lock_parent2,
+ * ii_read_lock_parent3, ii_write_lock_parent3,
+ * ii_read_lock_parent4, ii_write_lock_parent4,
+ * ii_read_lock_new, ii_write_lock_new
+ */
+#define AuReadLockFunc(name, lsc) \
+static inline void ii_read_lock_##name(struct inode *i) \
+{ au_rw_read_lock_nested(&au_ii(i)->ii_rwsem, AuLsc_II_##lsc); }
+
+#define AuWriteLockFunc(name, lsc) \
+static inline void ii_write_lock_##name(struct inode *i) \
+{ au_rw_write_lock_nested(&au_ii(i)->ii_rwsem, AuLsc_II_##lsc); }
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
+AuRWLockFuncs(parent4, PARENT4);
+AuRWLockFuncs(new, NEW);
+
+#undef AuReadLockFunc
+#undef AuWriteLockFunc
+#undef AuRWLockFuncs
+
+/*
+ * ii_read_unlock, ii_write_unlock, ii_downgrade_lock
+ */
+AuSimpleUnlockRwsemFuncs(ii, struct inode *i, au_ii(i)->ii_rwsem);
+
+/* to debug easier, do not make them inlined functions */
+#define IiMustReadLock(i) do { \
+	SiMustAnyLock((i)->i_sb); \
+	AuRwMustReadLock(&au_ii(i)->ii_rwsem); \
+} while (0)
+
+#define IiMustWriteLock(i) do { \
+	SiMustAnyLock((i)->i_sb); \
+	AuRwMustWriteLock(&au_ii(i)->ii_rwsem); \
+} while (0)
+
+#define IiMustAnyLock(i) do { \
+	SiMustAnyLock((i)->i_sb); \
+	AuRwMustAnyLock(&au_ii(i)->ii_rwsem); \
+} while (0)
+
+#define IiMustNoWaiters(i)	AuRwMustNoWaiters(&au_ii(i)->ii_rwsem)
+
+/* ---------------------------------------------------------------------- */
+
+static inline aufs_bindex_t au_ibstart(struct inode *inode)
+{
+	IiMustAnyLock(inode);
+	return au_ii(inode)->ii_bstart;
+}
+
+static inline aufs_bindex_t au_ibend(struct inode *inode)
+{
+	IiMustAnyLock(inode);
+	return au_ii(inode)->ii_bend;
+}
+
+static inline struct au_vdir *au_ivdir(struct inode *inode)
+{
+	IiMustAnyLock(inode);
+	AuDebugOn(!S_ISDIR(inode->i_mode));
+	return au_ii(inode)->ii_vdir;
+}
+
+static inline struct dentry *au_hi_wh(struct inode *inode, aufs_bindex_t bindex)
+{
+	struct au_hinode *hinode;
+	IiMustAnyLock(inode);
+	hinode = au_ii(inode)->ii_hinode + bindex;
+	return hinode->hi_whdentry;
+}
+
+static inline void au_set_ibend(struct inode *inode, aufs_bindex_t bindex)
+{
+	IiMustWriteLock(inode);
+	AuDebugOn(au_sbend(inode->i_sb) < bindex || bindex < au_ibstart(inode));
+	au_ii(inode)->ii_bend = bindex;
+}
+
+static inline void au_set_ivdir(struct inode *inode, struct au_vdir *vdir)
+{
+	IiMustWriteLock(inode);
+	AuDebugOn(!S_ISDIR(inode->i_mode) || (au_ii(inode)->ii_vdir && vdir));
+	au_ii(inode)->ii_vdir = vdir;
+}
+
+static inline void au_hiput(struct au_hinode *hinode)
+{
+	au_hin_free(hinode);
+	dput(hinode->hi_whdentry);
+	iput(hinode->hi_inode);
+}
+
+static inline struct au_hinode *au_hi(struct inode *inode, aufs_bindex_t bindex)
+{
+	/* todo: this lock check causes some unnecessary locks in callers. */
+	IiMustAnyLock(inode);
+	return au_ii(inode)->ii_hinode + bindex;
+}
+
+/* tiny test for inode number */
+/* tmpfs generation is too rough */
+static inline int au_test_higen(struct inode *inode, struct inode *h_inode)
+{
+	IiMustAnyLock(inode);
+	return !(au_ii(inode)->ii_hsb1 == h_inode->i_sb
+		 && inode->i_generation == h_inode->i_generation);
+}
+
+static inline au_gen_t au_iigen(struct inode *inode)
+{
+	return atomic_read(&au_ii(inode)->ii_generation);
+}
+
+#ifdef CONFIG_AUFS_HINOTIFY
+static inline au_gen_t au_iigen_dec(struct inode *inode)
+{
+	/* AuDbg("i%lu\n", inode->i_ino); */
+	return atomic_dec_return(&au_ii(inode)->ii_generation);
+}
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_INODE_H__ */
-- 
1.5.5.1.308.g1fbb5.dirty

