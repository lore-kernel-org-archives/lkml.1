Return-Path: <linux-kernel-owner+w=401wt.eu-S1761378AbYEPOyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378AbYEPOyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbYEPOnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:43:37 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49327 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587AbYEPOma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:30 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 52/67] aufs inotify handler
Date: Fri, 16 May 2008 23:33:06 +0900
Message-Id: <12109484021958-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484024169-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs inotify handler

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/hinotify.c | 1114 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 1114 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/hinotify.c b/fs/aufs/hinotify.c
new file mode 100644
index 0000000..28176f6
--- /dev/null
+++ b/fs/aufs/hinotify.c
@@ -0,0 +1,1114 @@
+/*
+ * Copyright (C) 2006-2008 Junjiro Okajima
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
+ * inotify handler
+ *
+ * $Id: hinotify.c,v 1.4 2008/05/04 23:52:19 sfjro Exp $
+ */
+
+#include "aufs.h"
+
+/* inotify events */
+static const __u32 AuInMask = (IN_MOVE | IN_DELETE | IN_CREATE
+			       /* | IN_ACCESS */
+			       | IN_MODIFY | IN_ATTRIB
+			       /* | IN_DELETE_SELF | IN_MOVE_SELF */
+	);
+static struct inotify_handle *in_handle;
+
+/* the size of an array for ignore counter */
+static int au_hin_nignore;
+
+AuCacheFuncs(hinotify, AuCache_HINOTIFY);
+
+int au_hin_alloc(struct au_hinode *hinode, struct inode *inode,
+		 struct inode *hidden_inode)
+{
+	int err, i;
+	struct au_hinotify *hin;
+	s32 wd;
+
+	LKTRTrace("i%lu, hi%lu\n", inode->i_ino, hidden_inode->i_ino);
+
+	err = -ENOMEM;
+	hin = au_cache_alloc_hinotify();
+	if (hin) {
+		AuDebugOn(hinode->hi_notify);
+		hinode->hi_notify = hin;
+		hin->hin_aufs_inode = inode;
+		for (i = 0; i < au_hin_nignore; i++)
+			atomic_set(hin->hin_ignore + i, 0);
+
+		inotify_init_watch(&hin->hin_watch);
+		wd = inotify_add_watch(in_handle, &hin->hin_watch, hidden_inode,
+				       AuInMask);
+		if (wd >= 0)
+			return 0; /* success */
+
+		err = wd;
+		put_inotify_watch(&hin->hin_watch);
+		au_cache_free_hinotify(hin);
+		hinode->hi_notify = NULL;
+	}
+
+	AuTraceErr(err);
+	return err;
+}
+
+void au_hin_free(struct au_hinode *hinode)
+{
+	int err;
+	struct au_hinotify *hin;
+
+	AuTraceEnter();
+
+	hin = hinode->hi_notify;
+	if (unlikely(hin)) {
+		err = 0;
+		if (atomic_read(&hin->hin_watch.count))
+			err = inotify_rm_watch(in_handle, &hin->hin_watch);
+
+		if (!err) {
+			au_cache_free_hinotify(hin);
+			hinode->hi_notify = NULL;
+		} else
+			AuIOErr1("failed inotify_rm_watch() %d\n", err);
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+static void ctl_hinotify(struct au_hinode *hinode, const __u32 mask)
+{
+	struct inode *h_inode;
+	struct inotify_watch *watch;
+
+	h_inode = hinode->hi_inode;
+	LKTRTrace("hi%lu, sb %p, 0x%x\n", h_inode->i_ino, h_inode->i_sb, mask);
+	IMustLock(h_inode);
+	if (!hinode->hi_notify)
+		return;
+
+	watch = &hinode->hi_notify->hin_watch;
+#if 0 // temp
+	{
+		u32 wd;
+		wd = inotify_find_update_watch(in_handle, h_inode, mask);
+		AuTraceErr(wd);
+		/* ignore an err; */
+	}
+#else
+	/* struct inotify_handle is hidden */
+	mutex_lock(&h_inode->inotify_mutex);
+	//mutex_lock(&watch->ih->mutex);
+	watch->mask = mask;
+	//mutex_unlock(&watch->ih->mutex);
+	mutex_unlock(&h_inode->inotify_mutex);
+#endif
+	LKTRTrace("watch %p, mask %u\n", watch, watch->mask);
+}
+
+#define suspend_hinotify(hi)	ctl_hinotify(hi, 0)
+#define resume_hinotify(hi)	ctl_hinotify(hi, AuInMask)
+
+void au_do_hdir_lock(struct inode *h_dir, struct inode *dir,
+		     aufs_bindex_t bindex, unsigned int lsc)
+{
+	struct au_hinode *hinode;
+
+	LKTRTrace("i%lu, b%d, lsc %d\n", dir->i_ino, bindex, lsc);
+	AuDebugOn(!S_ISDIR(dir->i_mode));
+	hinode = au_ii(dir)->ii_hinode + bindex;
+	AuDebugOn(h_dir != hinode->hi_inode);
+
+	mutex_lock_nested(&h_dir->i_mutex, lsc);
+	suspend_hinotify(hinode);
+}
+
+void au_hdir_unlock(struct inode *h_dir, struct inode *dir,
+		    aufs_bindex_t bindex)
+{
+	struct au_hinode *hinode;
+
+	LKTRTrace("i%lu, b%d\n", dir->i_ino, bindex);
+	AuDebugOn(!S_ISDIR(dir->i_mode));
+	hinode = au_ii(dir)->ii_hinode + bindex;
+	AuDebugOn(h_dir != hinode->hi_inode);
+
+	resume_hinotify(hinode);
+	mutex_unlock(&h_dir->i_mutex);
+}
+
+struct dentry *au_hdir_lock_rename(struct dentry **h_parents,
+				   struct inode **dirs, aufs_bindex_t bindex,
+				   int issamedir)
+{
+	struct dentry *h_trap;
+	struct au_hinode *hinode;
+
+	LKTRTrace("%.*s, %.*s\n",
+		  AuDLNPair(h_parents[0]), AuDLNPair(h_parents[1]));
+
+	h_trap = vfsub_lock_rename(h_parents[0], h_parents[1]);
+	hinode = au_ii(dirs[0])->ii_hinode + bindex;
+	AuDebugOn(h_parents[0]->d_inode != hinode->hi_inode);
+	suspend_hinotify(hinode);
+	if (!issamedir) {
+		hinode = au_ii(dirs[1])->ii_hinode + bindex;
+		AuDebugOn(h_parents[1]->d_inode != hinode->hi_inode);
+		suspend_hinotify(hinode);
+	}
+
+	return h_trap;
+}
+
+void au_hdir_unlock_rename(struct dentry **h_parents, struct inode **dirs,
+			   aufs_bindex_t bindex, int issamedir)
+{
+	struct au_hinode *hinode;
+
+	LKTRTrace("%.*s, %.*s\n",
+		  AuDLNPair(h_parents[0]), AuDLNPair(h_parents[1]));
+
+	hinode = au_ii(dirs[0])->ii_hinode + bindex;
+	AuDebugOn(h_parents[0]->d_inode != hinode->hi_inode);
+	resume_hinotify(hinode);
+	if (!issamedir) {
+		hinode = au_ii(dirs[1])->ii_hinode + bindex;
+		AuDebugOn(h_parents[1]->d_inode != hinode->hi_inode);
+		resume_hinotify(hinode);
+	}
+	vfsub_unlock_rename(h_parents[0], h_parents[1]);
+}
+
+void au_reset_hinotify(struct inode *inode, unsigned int flags)
+{
+	aufs_bindex_t bindex, bend;
+	struct inode *hi;
+	struct dentry *iwhdentry;
+
+	LKTRTrace("i%lu, 0x%x\n", inode->i_ino, flags);
+
+	bend = au_ibend(inode);
+	for (bindex = au_ibstart(inode); bindex <= bend; bindex++) {
+		hi = au_h_iptr(inode, bindex);
+		if (hi) {
+			//mutex_lock_nested(&hi->i_mutex, AuLsc_I_CHILD);
+			iwhdentry = au_hi_wh(inode, bindex);
+			if (unlikely(iwhdentry))
+				dget(iwhdentry);
+			igrab(hi);
+			au_set_h_iptr(inode, bindex, NULL, 0);
+			au_set_h_iptr(inode, bindex, igrab(hi),
+				      flags & ~AuHi_XINO);
+			iput(hi);
+			dput(iwhdentry);
+			//mutex_unlock(&hi->i_mutex);
+		}
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* cf. fsnotify_change() */
+__u32 vfsub_events_notify_change(struct iattr *ia)
+{
+	__u32 events;
+	const unsigned int amtime = (ATTR_ATIME | ATTR_MTIME);
+
+	events = 0;
+	if ((ia->ia_valid & (ATTR_UID | ATTR_GID | ATTR_MODE))
+	    || (ia->ia_valid & amtime) == amtime)
+		events |= IN_ATTRIB;
+	if ((ia->ia_valid & ATTR_SIZE)
+	    || (ia->ia_valid & amtime) == ATTR_MTIME)
+		events |= IN_MODIFY;
+	return events;
+}
+
+void vfsub_ign_hinode(struct vfsub_args *vargs, __u32 events,
+		      struct au_hinode *hinode)
+{
+	struct au_hin_ignore *ign;
+
+	AuDebugOn(!hinode);
+
+	ign = vargs->ignore + vargs->nignore++;
+	ign->ign_events = events;
+	ign->ign_hinode = hinode;
+}
+
+void vfsub_ignore(struct vfsub_args *vargs)
+{
+	int n;
+	struct au_hin_ignore *ign;
+
+	n = vargs->nignore;
+	ign = vargs->ignore;
+	while (n-- > 0) {
+		au_hin_ignore(ign->ign_hinode, ign->ign_events);
+		ign++;
+	}
+}
+
+void vfsub_unignore(struct vfsub_args *vargs)
+{
+	int n;
+	struct au_hin_ignore *ign;
+
+	n = vargs->nignore;
+	ign = vargs->ignore;
+	while (n-- > 0) {
+		au_hin_unignore(ign->ign_hinode, ign->ign_events);
+		ign++;
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_hin_ignore(struct au_hinode *hinode, __u32 events)
+{
+	int i;
+	atomic_t *ign;
+
+	LKTRTrace("0x%x\n", events);
+	AuDebugOn(!hinode || !events);
+	if (unlikely(!hinode->hi_inode || !hinode->hi_notify)) {
+		/*
+		 * it may happen by this scenario.
+		 * - a file and its parent dir exist on two branches
+		 * - a file on the upper branch is opened
+		 * - the parent dir and the file are removed by udba
+		 * - the parent is re-accessed, and new dentry/inode in
+		 *   aufs is generated for it, based upon the one on the lower
+		 *   branch
+		 * - the opened file is re-accessed, re-validated, and it may be
+		 *   re-connected to the new parent dentry
+		 * it means the file in aufs cannot get the actual removed
+		 * parent dir on the branch.
+		 */
+		return;
+	}
+	LKTRTrace("hi%lu\n", hinode->hi_inode->i_ino);
+#ifdef DbgInotify
+	AuDbg("hi%lu, 0x%x\n", hinode->hi_inode->i_ino, events);
+#endif
+	AuDebugOn(!hinode->hi_notify);
+
+	ign = hinode->hi_notify->hin_ignore;
+	for (i = 0; i < au_hin_nignore; i++)
+		if (1U << i & events)
+			atomic_inc_return(ign + i);
+}
+
+void au_hin_unignore(struct au_hinode *hinode, __u32 events)
+{
+	int i;
+	atomic_t *ign;
+
+	LKTRTrace("0x%x\n", events);
+	AuDebugOn(!hinode || !events);
+	if (unlikely(!hinode->hi_inode || !hinode->hi_notify))
+		return;
+	LKTRTrace("hi%lu\n", hinode->hi_inode->i_ino);
+#ifdef DbgInotify
+	AuDbg("hi%lu, 0x%x\n", hinode->hi_inode->i_ino, events);
+#endif
+	AuDebugOn(!hinode->hi_notify);
+
+	ign = hinode->hi_notify->hin_ignore;
+	for (i = 0; i < au_hin_nignore; i++)
+		if (1U << i & events)
+			atomic_dec_return(ign + i);
+}
+
+/* ---------------------------------------------------------------------- */
+
+static char *in_name(u32 mask)
+{
+#ifdef CONFIG_AUFS_DEBUG
+#define test_ret(flag)	if (mask & flag) return #flag;
+	test_ret(IN_ACCESS);
+	test_ret(IN_MODIFY);
+	test_ret(IN_ATTRIB);
+	test_ret(IN_CLOSE_WRITE);
+	test_ret(IN_CLOSE_NOWRITE);
+	test_ret(IN_OPEN);
+	test_ret(IN_MOVED_FROM);
+	test_ret(IN_MOVED_TO);
+	test_ret(IN_CREATE);
+	test_ret(IN_DELETE);
+	test_ret(IN_DELETE_SELF);
+	test_ret(IN_MOVE_SELF);
+	test_ret(IN_UNMOUNT);
+	test_ret(IN_Q_OVERFLOW);
+	test_ret(IN_IGNORED);
+	return "";
+#undef test_ret
+#else
+	return "??";
+#endif
+}
+
+/* ---------------------------------------------------------------------- */
+
+static struct dentry *lookup_wlock_by_name(char *name, unsigned int nlen,
+					   struct inode *dir)
+{
+	struct dentry *dentry, *d, *parent;
+	struct qstr *dname;
+
+	LKTRTrace("%.*s, dir%lu\n", nlen, name, dir->i_ino);
+
+	parent = d_find_alias(dir);
+	if (!parent)
+		return NULL;
+
+	dentry = NULL;
+	spin_lock(&dcache_lock);
+	list_for_each_entry(d, &parent->d_subdirs, d_u.d_child) {
+		LKTRTrace("%.*s\n", AuDLNPair(d));
+		dname = &d->d_name;
+		if (dname->len != nlen || memcmp(dname->name, name, nlen))
+			continue;
+		if (!atomic_read(&d->d_count)) {
+			spin_lock(&d->d_lock);
+			__d_drop(d);
+			spin_unlock(&d->d_lock);
+			continue;
+		}
+
+		dentry = dget(d);
+		break;
+	}
+	spin_unlock(&dcache_lock);
+	dput(parent);
+
+	if (dentry)
+		di_write_lock_child(dentry);
+	return dentry;
+}
+
+static struct inode *lookup_wlock_by_ino(struct super_block *sb,
+					 aufs_bindex_t bindex, ino_t h_ino)
+{
+	struct inode *inode;
+	struct au_xino_entry xinoe;
+	int err;
+
+	LKTRTrace("b%d, hi%lu\n", bindex, h_ino);
+	AuDebugOn(!au_opt_test(au_mntflags(sb), XINO));
+
+	inode = NULL;
+	err = au_xino_read(sb, bindex, h_ino, &xinoe);
+	if (!err && xinoe.ino)
+		inode = ilookup(sb, xinoe.ino);
+	if (!inode)
+		goto out;
+	if (unlikely(inode->i_ino == AUFS_ROOT_INO)) {
+		AuWarn("wrong root branch\n");
+		iput(inode);
+		inode = NULL;
+		goto out;
+	}
+
+	ii_write_lock_child(inode);
+#if 0 // debug
+	if (au_iigen(inode) == au_sigen(sb))
+		goto out; /* success */
+
+	err = au_refresh_hinode_self(inode);
+	if (!err)
+		goto out; /* success */
+
+	AuIOErr1("err %d ignored, but ino will be broken\n", err);
+	ii_write_unlock(inode);
+	iput(inode);
+	inode = NULL;
+#endif
+
+ out:
+	return inode;
+}
+
+static int hin_xino(struct inode *inode, struct inode *h_inode)
+{
+	int err;
+	aufs_bindex_t bindex, bend, bfound, bstart;
+	struct inode *h_i;
+
+	LKTRTrace("i%lu, hi%lu\n", inode->i_ino, h_inode->i_ino);
+
+	err = 0;
+	if (unlikely(inode->i_ino == AUFS_ROOT_INO)) {
+		AuWarn("branch root dir was changed\n");
+		goto out;
+	}
+
+	bfound = -1;
+	bend = au_ibend(inode);
+	bstart = au_ibstart(inode);
+#if 0
+	if (bindex == bend) {
+		/* keep this ino in rename case */
+		goto out;
+	}
+#endif
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		if (au_h_iptr(inode, bindex) == h_inode) {
+			bfound = bindex;
+			break;
+		}
+	}
+	if (bfound < 0)
+		goto out;
+
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		h_i = au_h_iptr(inode, bindex);
+		if (h_i)
+			err = au_xino_write0(inode->i_sb, bindex, h_i->i_ino,
+					     0);
+		/* ignore this error */
+		/* bad action? */
+	}
+
+	/* children inode number will be broken */
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+static int hin_gen_tree(struct dentry *dentry)
+{
+	int err, i, j, ndentry;
+	struct au_dcsub_pages dpages;
+	struct au_dpage *dpage;
+	struct dentry **dentries;
+
+	LKTRTrace("%.*s\n", AuDLNPair(dentry));
+
+	err = au_dpages_init(&dpages, GFP_TEMPORARY);
+	if (unlikely(err))
+		goto out;
+	err = au_dcsub_pages(&dpages, dentry, NULL, NULL);
+	if (unlikely(err))
+		goto out_dpages;
+
+	for (i = 0; i < dpages.ndpage; i++) {
+		dpage = dpages.dpages + i;
+		dentries = dpage->dentries;
+		ndentry = dpage->ndentry;
+		for (j = 0; j < ndentry; j++) {
+			struct dentry *d;
+			d = dentries[j];
+			LKTRTrace("%.*s\n", AuDLNPair(d));
+			if (IS_ROOT(d))
+				continue;
+
+			d_drop(d);
+			au_digen_dec(d);
+			if (d->d_inode)
+				//reset children xino? cached children only?
+				au_iigen_dec(d->d_inode);
+		}
+	}
+
+ out_dpages:
+	au_dpages_free(&dpages);
+
+	/* discard children */
+	dentry_unhash(dentry);
+	dput(dentry);
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+/*
+ * return 0 if processed.
+ */
+static int hin_gen_by_inode(char *name, unsigned int nlen, struct inode *inode,
+			    const unsigned int isdir)
+{
+	int err;
+	struct dentry *d;
+	struct qstr *dname;
+
+	LKTRTrace("%.*s, i%lu\n", nlen, name, inode->i_ino);
+
+	err = 1;
+	if (unlikely(inode->i_ino == AUFS_ROOT_INO)) {
+		AuWarn("branch root dir was changed\n");
+		err = 0;
+		goto out;
+	}
+
+	if (!isdir) {
+		AuDebugOn(!name);
+		au_iigen_dec(inode);
+		spin_lock(&dcache_lock);
+		list_for_each_entry(d, &inode->i_dentry, d_alias) {
+			dname = &d->d_name;
+			if (dname->len != nlen
+			    && memcmp(dname->name, name, nlen))
+				continue;
+			err = 0;
+			spin_lock(&d->d_lock);
+			__d_drop(d);
+			au_digen_dec(d);
+			spin_unlock(&d->d_lock);
+			break;
+		}
+		spin_unlock(&dcache_lock);
+	} else {
+		au_fset_si(au_sbi(inode->i_sb), FAILED_REFRESH_DIRS);
+		d = d_find_alias(inode);
+		if (!d) {
+			au_iigen_dec(inode);
+			goto out;
+		}
+
+		dname = &d->d_name;
+		if (dname->len == nlen && !memcmp(dname->name, name, nlen))
+			err = hin_gen_tree(d);
+		dput(d);
+	}
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+static int hin_gen_by_name(struct dentry *dentry, const unsigned int isdir)
+{
+	int err;
+	struct inode *inode;
+
+	LKTRTrace("%.*s\n", AuDLNPair(dentry));
+
+	inode = dentry->d_inode;
+	if (IS_ROOT(dentry)
+	    //|| (inode && inode->i_ino == AUFS_ROOT_INO)
+		) {
+		AuWarn("branch root dir was changed\n");
+		return 0;
+	}
+
+	err = 0;
+	if (!isdir) {
+		d_drop(dentry);
+		au_digen_dec(dentry);
+		if (inode)
+			au_iigen_dec(inode);
+	} else {
+		au_fset_si(au_sbi(dentry->d_sb), FAILED_REFRESH_DIRS);
+		if (inode)
+			err = hin_gen_tree(dentry);
+	}
+
+	AuTraceErr(err);
+	return err;
+}
+
+static void hin_attr(struct inode *inode, struct inode *h_inode)
+{
+	struct dentry *h_dentry;
+
+	LKTRTrace("i%lu, hi%lu\n", inode->i_ino, h_inode->i_ino);
+
+	if (au_h_iptr(inode, au_ibstart(inode)) != h_inode)
+		return;
+
+	h_dentry = d_find_alias(h_inode);
+	if (h_dentry) {
+		au_update_fuse_h_inode(NULL, h_dentry);
+		/* ignore an error*/
+		dput(h_dentry);
+	}
+
+	au_cpup_attr_all(inode);
+}
+
+/* ---------------------------------------------------------------------- */
+
+/* hinotify job flags */
+#define AuHinJob_XINO0	1
+#define AuHinJob_GEN	(1 << 1)
+#define AuHinJob_DIRENT	(1 << 2)
+#define AuHinJob_ATTR	(1 << 3)
+#define AuHinJob_ISDIR	(1 << 4)
+#define AuHinJob_TRYXINO0 (1 << 5)
+#define AuHinJob_MNTPNT	(1 << 6)
+#define au_ftest_hinjob(flags, name)	((flags) & AuHinJob_##name)
+#define au_fset_hinjob(flags, name)	{ (flags) |= AuHinJob_##name; }
+#define au_fclr_hinjob(flags, name)	{ (flags) &= ~AuHinJob_##name; }
+
+struct hin_job_args {
+	unsigned int flags;
+	struct inode *inode, *h_inode, *dir, *h_dir;
+	struct dentry *dentry;
+	char *h_name;
+	int h_nlen;
+};
+
+static int hin_job(struct hin_job_args *a)
+{
+	const unsigned int isdir = au_ftest_hinjob(a->flags, ISDIR);
+
+	/* reset xino */
+	if (au_ftest_hinjob(a->flags, XINO0) && a->inode)
+		hin_xino(a->inode, a->h_inode);
+	/* ignore this error */
+
+	if (au_ftest_hinjob(a->flags, TRYXINO0)
+	    && a->inode
+	    && a->h_inode) {
+		mutex_lock_nested(&a->h_inode->i_mutex, AuLsc_I_CHILD);
+#if 0
+		au_debug_on();
+		AuDbgInode(a->inode);
+		AuDbgInode(a->h_inode);
+		au_debug_off();
+#endif
+		if (!a->h_inode->i_nlink)
+			hin_xino(a->inode, a->h_inode);
+		/* ignore this error */
+		mutex_unlock(&a->h_inode->i_mutex);
+	}
+
+	/* make the generation obsolete */
+	if (au_ftest_hinjob(a->flags, GEN)) {
+		int err = -1;
+		if (a->inode)
+			err = hin_gen_by_inode(a->h_name, a->h_nlen, a->inode,
+					       isdir);
+		if (err && a->dentry)
+			hin_gen_by_name(a->dentry, isdir);
+		/* ignore this error */
+	}
+
+	/* make dir entries obsolete */
+	if (au_ftest_hinjob(a->flags, DIRENT) && a->inode) {
+		struct au_vdir *vdir;
+		IiMustWriteLock(a->inode);
+		vdir = au_ivdir(a->inode);
+		if (vdir)
+			vdir->vd_jiffy = 0;
+		//IMustLock(a->inode);
+		//a->inode->i_version++;
+	}
+
+	/* update the attr */
+	if (au_ftest_hinjob(a->flags, ATTR) && a->inode && a->h_inode)
+		hin_attr(a->inode, a->h_inode);
+
+	/* can do nothing but warn */
+	if (au_ftest_hinjob(a->flags, MNTPNT)
+	    && a->dentry
+	    && d_mountpoint(a->dentry))
+		AuWarn("mount-point %.*s is removed or renamed\n",
+		       AuDLNPair(a->dentry));
+
+	return 0;
+}
+
+/* ---------------------------------------------------------------------- */
+
+enum { CHILD, PARENT };
+struct postproc_args {
+	struct inode *h_dir, *dir, *h_child_inode;
+	u32 mask;
+	unsigned int flags[2];
+	unsigned int h_child_nlen;
+	char h_child_name[];
+};
+
+static void postproc(void *_args)
+{
+	struct postproc_args *a = _args;
+	struct super_block *sb;
+	aufs_bindex_t bindex, bend, bfound;
+	int xino, err;
+	struct inode *inode;
+	ino_t h_ino;
+	struct hin_job_args args;
+	struct dentry *dentry;
+	struct au_sbinfo *sbinfo;
+
+	AuDebugOn(!_args);
+	AuDebugOn(!a->h_dir);
+	AuDebugOn(!a->dir);
+	AuDebugOn(!a->mask);
+	//au_debug_on();
+	LKTRTrace("mask 0x%x %s, i%lu, hi%lu, hci%lu\n",
+		  a->mask, in_name(a->mask), a->dir->i_ino, a->h_dir->i_ino,
+		  a->h_child_inode ? a->h_child_inode->i_ino : 0);
+
+	inode = NULL;
+	dentry = NULL;
+	// do not lock here because of d_revalidate() may cause a deadlock.
+	//mutex_lock(&a->dir->i_mutex);
+	sb = a->dir->i_sb;
+	AuDebugOn(!sb);
+	sbinfo = au_sbi(sb);
+	AuDebugOn(!sbinfo);
+	/* big aufs lock */
+	si_noflush_write_lock(sb);
+
+	ii_read_lock_parent(a->dir);
+	bfound = -1;
+	bend = au_ibend(a->dir);
+	for (bindex = au_ibstart(a->dir); bindex <= bend; bindex++)
+		if (au_h_iptr(a->dir, bindex) == a->h_dir) {
+			bfound = bindex;
+			break;
+		}
+	ii_read_unlock(a->dir);
+	if (unlikely(bfound < 0))
+		goto out;
+
+	xino = !!au_opt_test(au_mntflags(sb), XINO);
+	h_ino = 0;
+	if (a->h_child_inode)
+		h_ino = a->h_child_inode->i_ino;
+	//AuDbg("here\n");
+
+	if (a->h_child_nlen
+	    && (au_ftest_hinjob(a->flags[CHILD], GEN)
+		|| au_ftest_hinjob(a->flags[CHILD], MNTPNT)))
+		dentry = lookup_wlock_by_name(a->h_child_name, a->h_child_nlen,
+					      a->dir);
+	//AuDbg("here\n");
+	if (dentry)
+		inode = dentry->d_inode;
+	if (xino && !inode && h_ino
+	    && (au_ftest_hinjob(a->flags[CHILD], XINO0)
+		|| au_ftest_hinjob(a->flags[CHILD], TRYXINO0)
+		|| au_ftest_hinjob(a->flags[CHILD], GEN)
+		|| au_ftest_hinjob(a->flags[CHILD], ATTR)))
+		inode = lookup_wlock_by_ino(sb, bfound, h_ino);
+	//AuDbg("here\n");
+
+	args.flags = a->flags[CHILD];
+	args.dentry = dentry;
+	args.inode = inode;
+	args.h_inode = a->h_child_inode;
+	args.dir = a->dir;
+	args.h_dir = a->h_dir;
+	args.h_name = a->h_child_name;
+	args.h_nlen = a->h_child_nlen;
+	err = hin_job(&args);
+	if (dentry) {
+		di_write_unlock(dentry);
+		dput(dentry);
+	} else if (inode) {
+		ii_write_unlock(inode);
+		iput(inode);
+	}
+	//AuDbg("here\n");
+
+	ii_write_lock_parent(a->dir);
+	args.flags = a->flags[PARENT];
+	args.dentry = NULL;
+	args.inode = a->dir;
+	args.h_inode = a->h_dir;
+	args.dir = NULL;
+	args.h_dir = NULL;
+	args.h_name = NULL;
+	args.h_nlen = 0;
+	err = hin_job(&args);
+	ii_write_unlock(a->dir);
+	//AuDbg("here\n");
+
+ out:
+	si_write_unlock(sb);
+	//mutex_unlock(&a->dir->i_mutex);
+	au_nwt_dec(&sbinfo->si_nowait);
+
+	iput(a->h_child_inode);
+	iput(a->h_dir);
+	iput(a->dir);
+	kfree(a);
+	//au_debug_off();
+}
+
+//todo: endian?
+#ifndef ilog2
+#define ilog2(n) ffz(~(n))
+#endif
+
+static void aufs_inotify(struct inotify_watch *watch, u32 wd, u32 mask,
+			 u32 cookie, const char *h_child_name,
+			 struct inode *h_child_inode)
+{
+	struct au_hinotify *hinotify;
+	struct postproc_args *args;
+	int len, wkq_err, isdir, isroot, wh, idx;
+	char *p;
+	struct inode *dir;
+	unsigned int flags[2];
+	struct super_block *sb;
+	atomic_t *cnt;
+
+	LKTRTrace("i%lu, wd %d, mask 0x%x %s, cookie 0x%x, hcname %s, hi%lu\n",
+		  watch->inode->i_ino, wd, mask, in_name(mask), cookie,
+		  h_child_name ? h_child_name : "",
+		  h_child_inode ? h_child_inode->i_ino : 0);
+#if 0 //defined(ForceInotify) || defined(DbgInotify)
+	AuDbg("i%lu, wd %d, mask 0x%x %s, cookie 0x%x, hcname %s, hi%lu\n",
+	      watch->inode->i_ino, wd, mask, in_name(mask), cookie,
+	      h_child_name ? h_child_name : "",
+	      h_child_inode ? h_child_inode->i_ino : 0);
+#endif
+	/* if IN_UNMOUNT happens, there must be another bug */
+	if (mask & (IN_IGNORED | IN_UNMOUNT)) {
+		//WARN_ON(watch->inode->i_ino == 15);
+		put_inotify_watch(watch);
+		return;
+	}
+
+#ifdef DbgInotify
+	if (!h_child_name || strcmp(h_child_name, AUFS_XINO_FNAME))
+		AuDbg("i%lu, wd %d, mask 0x%x %s, cookie 0x%x, hcname %s,"
+		      " hi%lu\n",
+		      watch->inode->i_ino, wd, mask, in_name(mask), cookie,
+		      h_child_name ? h_child_name : "",
+		      h_child_inode ? h_child_inode->i_ino : 0);
+	//WARN_ON(1);
+#endif
+
+	hinotify = container_of(watch, struct au_hinotify, hin_watch);
+	AuDebugOn(!hinotify || !hinotify->hin_aufs_inode);
+	idx = ilog2(mask & IN_ALL_EVENTS);
+	AuDebugOn(au_hin_nignore <= idx);
+	cnt = hinotify->hin_ignore + idx;
+	if (0 <= atomic_dec_return(cnt))
+		return;
+	atomic_inc_return(cnt);
+#ifdef DbgInotify
+#if 0
+	AuDbg("i%lu, wd %d, mask 0x%x %s, cookie 0x%x, hcname %s, hi%lu\n",
+	      watch->inode->i_ino, wd, mask, in_name(mask), cookie,
+	      h_child_name ? h_child_name : "",
+	      h_child_inode ? h_child_inode->i_ino : 0);
+#endif
+#if 0
+	if (!h_child_name || strcmp(h_child_name, AUFS_XINO_FNAME))
+		WARN_ON(1);
+#endif
+#endif
+
+	dir = igrab(hinotify->hin_aufs_inode);
+	if (!dir)
+		return;
+	isroot = (dir->i_ino == AUFS_ROOT_INO);
+	len = 0;
+	wh = 0;
+	if (h_child_name) {
+		len = strlen(h_child_name);
+		if (!memcmp(h_child_name, AUFS_WH_PFX, AUFS_WH_PFX_LEN)) {
+			h_child_name += AUFS_WH_PFX_LEN;
+			len -= AUFS_WH_PFX_LEN;
+			wh = 1;
+		}
+	}
+
+	isdir = 0;
+	if (h_child_inode)
+		isdir = !!S_ISDIR(h_child_inode->i_mode);
+	flags[PARENT] = AuHinJob_ISDIR;
+	flags[CHILD] = 0;
+	if (isdir)
+		flags[CHILD] = AuHinJob_ISDIR;
+	switch (mask & IN_ALL_EVENTS) {
+	case IN_MODIFY:
+		/*FALLTHROUGH*/
+	case IN_ATTRIB:
+		if (h_child_inode) {
+			if (!wh)
+				au_fset_hinjob(flags[CHILD], ATTR);
+		} else
+			au_fset_hinjob(flags[PARENT], ATTR);
+		break;
+
+		/* IN_MOVED_FROM is the first event in rename(2) */
+	case IN_MOVED_FROM:
+	case IN_MOVED_TO:
+		AuDebugOn(!h_child_name || !h_child_inode);
+		au_fset_hinjob(flags[CHILD], GEN);
+		au_fset_hinjob(flags[CHILD], ATTR);
+		if (1 || isdir)
+			au_fset_hinjob(flags[CHILD], XINO0);
+		au_fset_hinjob(flags[CHILD], MNTPNT);
+
+		au_fset_hinjob(flags[PARENT], ATTR);
+		au_fset_hinjob(flags[PARENT], DIRENT);
+		break;
+
+	case IN_CREATE:
+		AuDebugOn(!h_child_name || !h_child_inode);
+		au_fset_hinjob(flags[PARENT], ATTR);
+		au_fset_hinjob(flags[PARENT], DIRENT);
+		au_fset_hinjob(flags[CHILD], GEN);
+		/* hard link */
+		if (!isdir && h_child_inode->i_nlink > 1)
+			au_fset_hinjob(flags[CHILD], ATTR);
+		break;
+
+	case IN_DELETE:
+		/*
+		 * aufs never be able to get this child inode.
+		 * revalidation should be in d_revalidate()
+		 * by checking i_nlink, i_generation or d_unhashed().
+		 */
+		AuDebugOn(!h_child_name);
+		au_fset_hinjob(flags[PARENT], ATTR);
+		au_fset_hinjob(flags[PARENT], DIRENT);
+		au_fset_hinjob(flags[CHILD], GEN);
+		au_fset_hinjob(flags[CHILD], TRYXINO0);
+		au_fset_hinjob(flags[CHILD], MNTPNT);
+		break;
+
+	case IN_DELETE_SELF:
+		if (!isroot)
+			au_fset_hinjob(flags[PARENT], GEN);
+		/*FALLTHROUGH*/
+
+	case IN_MOVE_SELF:
+		/*
+		 * when an inotify is set to an aufs inode,
+		 * such inode can be isolated and this event can be fired
+		 * solely.
+		 */
+		AuDebugOn(h_child_name || h_child_inode);
+		if (unlikely(isroot)) {
+			AuWarn("root branch was moved\n");
+			iput(dir);
+			return;
+		}
+#if 0
+		return;
+#else
+		au_fset_hinjob(flags[PARENT], XINO0);
+		au_fset_hinjob(flags[PARENT], GEN);
+		au_fset_hinjob(flags[PARENT], ATTR);
+		au_fset_hinjob(flags[PARENT], DIRENT);
+		//au_fset_hinjob(flags[PARENT], MNTPNT);
+		break;
+#endif
+	case IN_ACCESS:
+	default:
+		AuDebugOn(1);
+	}
+
+#if 0 //def DbgInotify
+	WARN_ON(1);
+#endif
+
+	if (wh)
+		h_child_inode = NULL;
+
+	/* iput() and kfree() will be called in postproc() */
+	/*
+	 * inotify_mutex is already acquired and kmalloc/prune_icache may lock
+	 * iprune_mutex. strange.
+	 */
+	lockdep_off();
+	args = kmalloc(sizeof(*args) + len + 1, GFP_TEMPORARY);
+	lockdep_on();
+	if (unlikely(!args)) {
+		AuErr1("no memory\n");
+		iput(dir);
+		return;
+	}
+	args->flags[PARENT] = flags[PARENT];
+	args->flags[CHILD] = flags[CHILD];
+	args->mask = mask;
+	args->dir = dir;
+	args->h_dir = igrab(watch->inode);
+	if (h_child_inode)
+		igrab(h_child_inode);
+	args->h_child_inode = h_child_inode;
+	args->h_child_nlen = len;
+	if (len) {
+		p = (void *)args;
+		p += sizeof(*args);
+		memcpy(p, h_child_name, len + 1);
+	}
+
+	sb = dir->i_sb;
+	au_nwt_inc(&au_sbi(sb)->si_nowait);
+	lockdep_off();
+	wkq_err = au_wkq_nowait(postproc, args, sb, /*dlgt*/0);
+	lockdep_on();
+	if (unlikely(wkq_err)) {
+		AuErr("wkq %d\n", wkq_err);
+		au_nwt_dec(&au_sbi(sb)->si_nowait);
+	}
+}
+
+static void aufs_inotify_destroy(struct inotify_watch *watch)
+{
+	return;
+}
+
+static struct inotify_operations aufs_inotify_ops = {
+	.handle_event	= aufs_inotify,
+	.destroy_watch	= aufs_inotify_destroy
+};
+
+/* ---------------------------------------------------------------------- */
+
+static void au_hin_destroy_cache(void)
+{
+	kmem_cache_destroy(au_cachep[AuCache_HINOTIFY]);
+	au_cachep[AuCache_HINOTIFY] = NULL;
+}
+
+int __init au_inotify_init(void)
+{
+	au_hin_nignore = 6;
+	while (1U << au_hin_nignore < AuInMask)
+		au_hin_nignore++;
+	//AuDbg("au_hin_nignore %d\n", au_hin_nignore);
+	AuDebugOn(au_hin_nignore != 10);
+
+	in_handle = ERR_PTR(-ENOMEM);
+	au_cachep[AuCache_HINOTIFY]
+		= AuCacheX(au_hinotify, sizeof(atomic_t) * au_hin_nignore);
+	if (unlikely(!au_cachep[AuCache_HINOTIFY]))
+		goto out;
+
+	in_handle = inotify_init(&aufs_inotify_ops);
+	if (!IS_ERR(in_handle))
+		return 0;
+
+	au_hin_destroy_cache();
+ out:
+	AuTraceErrPtr(in_handle);
+	return PTR_ERR(in_handle);
+}
+
+void au_inotify_fin(void)
+{
+	inotify_destroy(in_handle);
+	if (au_cachep[AuCache_HINOTIFY])
+		au_hin_destroy_cache();
+}
-- 
1.4.4.4

