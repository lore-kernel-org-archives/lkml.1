Return-Path: <linux-kernel-owner+w=401wt.eu-S935972AbYEUDt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935972AbYEUDt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934436AbYEUDfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:35:06 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44115 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760466AbYEUDdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:33:01 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 08/39] aufs branch filesystem type specific
Date: Wed, 21 May 2008 12:22:38 +0900
Message-Id: <1211340189-11813-9-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
br_fuse.c	special handling for inode attributes on FUSE branch
br_nfs.c	lookup functions for NFS branch
br_xfs.c	special handling inode attributes on XFS branch

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/br_fuse.c |  107 ++++++++++++++++
 fs/aufs/br_nfs.c  |  347 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/br_xfs.c  |   67 ++++++++++
 3 files changed, 521 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/br_fuse.c
 create mode 100644 fs/aufs/br_nfs.c
 create mode 100644 fs/aufs/br_xfs.c

diff --git a/fs/aufs/br_fuse.c b/fs/aufs/br_fuse.c
new file mode 100644
index 0000000..1c0182b
--- /dev/null
+++ b/fs/aufs/br_fuse.c
@@ -0,0 +1,107 @@
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
+ * special handling for inode attributes on FUSE branch
+ */
+
+#include "aufs.h"
+
+/* h_mnt can be NULL, is it safe? */
+int au_update_fuse_h_inode(struct vfsmount *h_mnt, struct dentry *h_dentry)
+{
+	int err;
+	struct kstat st;
+
+	LKTRTrace("%.*s\n", AuDLNPair(h_dentry));
+
+	err = 0;
+	if (unlikely(h_dentry->d_inode
+		     /* && atomic_read(&h_dentry->d_inode->i_count) */
+		     && au_test_fuse(h_dentry->d_sb))) {
+		err = vfsub_getattr(h_mnt, h_dentry, &st, /*dlgt*/0);
+		if (unlikely(err)) {
+			AuDbg("err %d\n", err);
+			au_debug_on();
+			AuDbgDentry(h_dentry);
+			au_debug_off();
+			WARN_ON(err);
+		}
+	}
+	return err;
+}
+
+/* currently, for fuse only */
+int aufs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *st)
+{
+	int err;
+	struct inode *inode, *h_inode;
+	struct dentry *h_dentry;
+
+	LKTRTrace("%.*s\n", AuDLNPair(dentry));
+
+	err = 0;
+	aufs_read_lock(dentry, AuLock_IR);
+	inode = dentry->d_inode;
+	h_inode = au_h_iptr(inode, au_ibstart(inode));
+	if (unlikely(au_test_fuse(h_inode->i_sb))) {
+		h_dentry = d_find_alias(h_inode);
+		/* simply gave up updating fuse inode */
+		if (h_dentry) {
+			/*ignore*/
+			if (!au_update_fuse_h_inode(NULL, h_dentry))
+				au_cpup_attr_all(inode);
+			dput(h_dentry);
+		}
+	}
+	generic_fillattr(inode, st);
+
+	aufs_read_unlock(dentry, AuLock_IR);
+	return err;
+}
+
+#if 0 /* temp */
+/*
+ * This function was born after a discussion with the FUSE developer.
+ * The inode attributes on a filesystem who defines i_op->getattr()
+ * is unreliable since such fs may not maintain the attributes at lookup.
+ * This function doesn't want the result of stat, instead wants the side-effect
+ * which refreshes the attributes.
+ * Hmm, there seems to be no such filesystem except fuse.
+ */
+int vfsub_i_attr(struct vfsmount *mnt, struct dentry *dentry, int dlgt)
+{
+	int err;
+	struct inode *inode;
+	struct inode_operations *op;
+	struct kstat st;
+
+	inode = dentry->d_inode;
+	AuDebugOn(!inode);
+
+	err = 0;
+	op = inode->i_op;
+	if (unlikely(op && op->getattr && !au_test_aufs(dentry->d_sb))) {
+		err = security_inode_getattr(mnt, dentry);
+		if (!err)
+			err = op->getattr(mnt, dentry, &st);
+	}
+	AuTraceErr(err);
+	return err;
+}
+#endif
diff --git a/fs/aufs/br_nfs.c b/fs/aufs/br_nfs.c
new file mode 100644
index 0000000..7fe71a8
--- /dev/null
+++ b/fs/aufs/br_nfs.c
@@ -0,0 +1,347 @@
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
+ * lookup functions for NFS branch in linux-2.6.19 and later
+ */
+
+#include "aufs.h"
+
+static struct file *au_find_h_intent(struct au_hdentry *hd, struct file *file)
+{
+	struct file *h_file, *hf;
+	struct au_hdintent *hdi, *tmp, *do_free;
+
+	LKTRTrace("%.*s\n", AuDLNPair(hd->hd_dentry));
+
+	h_file = NULL;
+	do_free = NULL;
+	spin_lock(&hd->hd_lock);
+	list_for_each_entry_safe(hdi, tmp, hd->hd_intent_list, hdi_list) {
+		hf = hdi->hdi_file[AuIntent_BRANCH];
+		if (hdi->hdi_file[AuIntent_AUFS] == file
+		    && hf->f_dentry == hd->hd_dentry) {
+			h_file = hf;
+			do_free = hdi;
+			list_del(&hdi->hdi_list);
+			break;
+		}
+	}
+	spin_unlock(&hd->hd_lock);
+	kfree(do_free);
+
+	return h_file;
+}
+
+struct file *au_h_intent(struct dentry *dentry, aufs_bindex_t bindex,
+			 struct file *file)
+{
+	struct file *h_file;
+	struct au_hdentry *hd = au_di(dentry)->di_hdentry + bindex;
+
+	LKTRTrace("%.*s, b%d, f %p\n", AuDLNPair(dentry), bindex, file);
+	DiMustAnyLock(dentry);
+	AuDebugOn(bindex < au_di(dentry)->di_bstart
+		  || bindex > au_di(dentry)->di_bend);
+
+	h_file = NULL;
+	if (!hd->hd_intent_list || !file)
+		return h_file; /* success */
+
+	/* AuDebugOn(au_test_wkq(current)); */
+	h_file = au_find_h_intent(hd, file);
+	return h_file;
+}
+
+static int au_set_h_intent(struct dentry *dentry, aufs_bindex_t bindex,
+			   struct file *file, struct file *h_file)
+{
+	int err;
+	struct au_hdentry *hd = au_di(dentry)->di_hdentry + bindex;
+	struct au_hdintent *hdi;
+	struct file *hf;
+
+	LKTRTrace("%.*s, b%d, f %p\n", AuDLNPair(dentry), bindex, file);
+	/* d_revalidate() holds read_lock */
+	/* DiMustWriteLock(dentry); */
+	AuDebugOn(bindex < au_di(dentry)->di_bstart
+		  || bindex > au_di(dentry)->di_bend
+		  || !file
+		  || !h_file
+		  /* || au_test_wkq(current) */);
+
+	err = -ENOMEM;
+	if (hd->hd_intent_list) {
+		while (1) {
+			hf = au_find_h_intent(hd, file);
+			if (!hf)
+				break;
+			fput(hf);
+			AuWarn("freed hfile %.*s b%d left\n",
+			       AuDLNPair(dentry), bindex);
+		}
+	} else {
+		spin_lock(&hd->hd_lock);
+		if (!hd->hd_intent_list) {
+			hd->hd_intent_list
+				= kmalloc(sizeof(*hd->hd_intent_list),
+					  GFP_ATOMIC);
+			if (unlikely(!hd->hd_intent_list)) {
+				spin_unlock(&hd->hd_lock);
+				goto out;
+			}
+			INIT_LIST_HEAD(hd->hd_intent_list);
+		}
+		spin_unlock(&hd->hd_lock);
+	}
+
+	hdi = kmalloc(sizeof(*hdi), GFP_TEMPORARY);
+	if (unlikely(!hdi))
+		goto out;
+
+	err = 0;
+	/* hdi->hdi_pid = current->pid; */
+	hdi->hdi_file[AuIntent_AUFS] = file;
+	hdi->hdi_file[AuIntent_BRANCH] = h_file;
+	spin_lock(&hd->hd_lock);
+	list_add(&hdi->hdi_list, hd->hd_intent_list);
+	spin_unlock(&hd->hd_lock);
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+int au_br_nfs_h_intent(struct file *nd_file, struct dentry *dentry,
+		       aufs_bindex_t bindex, struct nameidata *nd)
+{
+	int err;
+
+	AuTraceEnter();
+
+	err = 0;
+	if (!nd_file)
+		goto out;
+
+	AuDebugOn(!nd);
+	err = au_set_h_intent(dentry, bindex, nd->intent.open.file, nd_file);
+	if (unlikely(err)) {
+		fput(nd_file);
+		au_set_h_dptr(dentry, bindex, NULL);
+		/* todo: update bstart and bend? */
+	}
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+void au_hintent_put(struct au_hdentry *hd, int do_free)
+{
+	struct au_hdintent *hdi, *tmp;
+	struct file *hf;
+
+	if (unlikely(hd->hd_intent_list)) {
+		/* no spin lock */
+		list_for_each_entry_safe(hdi, tmp, hd->hd_intent_list,
+					 hdi_list) {
+			LKTRTrace("hdi %p\n", hdi);
+			hf = hdi->hdi_file[AuIntent_BRANCH];
+			if (unlikely(hf))
+				fput(hf);
+			/* list_del(&hdi->hdi_list); */
+			kfree(hdi);
+		}
+		if (do_free)
+			kfree(hd->hd_intent_list);
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+int au_fake_intent(/* struct au_ndsub *save,  */struct nameidata *nd,
+		   int perm)
+{
+	int err;
+
+	LKTRTrace("perm %d\n", perm);
+
+	err = 0;
+	nd->intent.open.file = NULL;
+	if (nd->flags & LOOKUP_OPEN) {
+		err = -ENFILE;
+		nd->intent.open.file = get_empty_filp();
+		if (unlikely(!nd->intent.open.file))
+			goto out;
+
+		err = 0;
+		if (!au_br_writable(perm)) {
+			nd->intent.open.flags = FMODE_READ
+				| au_file_roflags(nd->intent.open.flags);
+			nd->flags &= ~LOOKUP_CREATE;
+		}
+	}
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
+
+int au_hin_after_reval(struct nameidata *nd, struct dentry *dentry,
+		       aufs_bindex_t bindex, struct file *file)
+{
+	int err;
+
+	LKTRTrace("nd %p, %.*s, b%d, f %d\n",
+		  nd, AuDLNPair(dentry), bindex, !!file);
+
+	err = 0;
+	if ((nd->flags & LOOKUP_OPEN)
+	    && nd->intent.open.file
+	    && !IS_ERR(nd->intent.open.file)) {
+		if (nd->intent.open.file->f_dentry) {
+			err = au_set_h_intent(dentry, bindex, file,
+					      nd->intent.open.file);
+			if (!err)
+				nd->intent.open.file = NULL;
+		}
+		if (unlikely(nd->intent.open.file))
+			put_filp(nd->intent.open.file);
+	}
+
+	return err;
+}
+
+#ifdef CONFIG_AUFS_DLGT
+struct au_lookup_hash_args {
+	struct dentry **errp;
+	struct qstr *name;
+	struct dentry *base;
+	struct nameidata *nd;
+};
+
+static void au_call_lookup_hash(void *args)
+{
+	struct au_lookup_hash_args *a = args;
+	*a->errp = vfsub__lookup_hash(a->name, a->base, a->nd);
+}
+
+static struct dentry *
+au_lkup_hash_dlgt(struct qstr *this, struct dentry *parent,
+		  struct nameidata *nd, unsigned int flags)
+{
+	struct dentry *dentry;
+	int dirperm1;
+
+	dirperm1 = au_ftest_ndx(flags, DIRPERM1);
+	if (!dirperm1 && !au_ftest_ndx(flags, DLGT))
+		dentry = vfsub__lookup_hash(this, parent, nd);
+	else {
+		int wkq_err;
+		struct au_lookup_hash_args args = {
+			.errp	= &dentry,
+			.name	= this,
+			.base	= parent,
+			.nd	= nd
+		};
+		wkq_err = au_wkq_wait(au_call_lookup_hash, &args,
+				      /*dlgt*/!dirperm1);
+		if (unlikely(wkq_err))
+			dentry = ERR_PTR(wkq_err);
+	}
+
+	AuTraceErrPtr(dentry);
+	return dentry;
+}
+#else
+static struct dentry *
+au_lkup_hash_dlgt(struct qstr *this, struct dentry *parent,
+		  struct nameidata *nd, unsigned int flags)
+{
+	return vfsub__lookup_hash(this, parent, nd);
+}
+#endif /* CONFIG_AUFS_DLGT */
+
+struct dentry *au_lkup_hash(const char *name, struct dentry *parent,
+			    int len, struct au_ndx *ndx)
+{
+	struct dentry *dentry;
+	char *p;
+	unsigned long hash;
+	struct qstr this;
+	unsigned int c;
+	struct nameidata tmp_nd, *ndo;
+	int err;
+
+	LKTRTrace("%.*s/%.*s\n", AuDLNPair(parent), len, name);
+
+	/* todo: export and call __lookup_one_len() in fs/namei.c? */
+	dentry = ERR_PTR(-EACCES);
+	this.name = name;
+	this.len = len;
+	if (unlikely(!len))
+		goto out;
+
+	p = (void *)name;
+	hash = init_name_hash();
+	while (len--) {
+		c = *p++;
+		if (unlikely(c == '/' || c == '\0'))
+			goto out;
+		hash = partial_name_hash(c, hash);
+	}
+	this.hash = end_name_hash(hash);
+
+	ndo = ndx->nd;
+	if (ndo) {
+		tmp_nd = *ndo;
+		err = au_fake_intent(&tmp_nd, ndx->br->br_perm);
+		dentry = ERR_PTR(err);
+		if (unlikely(err))
+			goto out_intent;
+	} else
+		memset(&tmp_nd, 0, sizeof(tmp_nd));
+
+	tmp_nd.path.dentry = parent;
+	tmp_nd.path.mnt = ndx->nfsmnt;
+	path_get(&tmp_nd.path);
+	dentry = au_lkup_hash_dlgt(&this, parent, &tmp_nd, ndx->flags);
+	if (0 && !IS_ERR(dentry))
+		AuDbgDentry(dentry);
+	if (!IS_ERR(dentry)) {
+		/* why negative dentry for a new dir was unhashed? */
+		if (unlikely(d_unhashed(dentry)))
+			d_rehash(dentry);
+		if (tmp_nd.intent.open.file
+		    && tmp_nd.intent.open.file->f_dentry) {
+			ndx->nd_file = tmp_nd.intent.open.file;
+			tmp_nd.intent.open.file = NULL;
+			/* au_br_get(ndx->br); */
+		}
+	}
+	path_put(&tmp_nd.path);
+
+ out_intent:
+	if (tmp_nd.intent.open.file)
+		put_filp(tmp_nd.intent.open.file);
+ out:
+	AuTraceErrPtr(dentry);
+	return dentry;
+}
diff --git a/fs/aufs/br_xfs.c b/fs/aufs/br_xfs.c
new file mode 100644
index 0000000..2a3ef5f
--- /dev/null
+++ b/fs/aufs/br_xfs.c
@@ -0,0 +1,67 @@
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
+ * special handling inode attributes on XFS branch in linux-2.6.24 and later
+ */
+
+#include "aufs.h"
+
+/* h_mnt can be NULL, is it safe? */
+dev_t au_h_rdev(struct inode *h_inode, struct vfsmount *h_mnt,
+		struct dentry *h_dentry)
+{
+	dev_t rdev;
+	int err;
+	struct kstat st;
+
+	LKTRTrace("hi%lu\n", h_inode->i_ino);
+	if (h_dentry)
+		LKTRTrace("%.*s\n", AuDLNPair(h_dentry));
+
+	rdev = h_inode->i_rdev;
+	if (!rdev || !au_test_xfs(h_inode->i_sb))
+		goto out;
+
+	rdev = 0;
+	if (!h_dentry) {
+		err = 0;
+		h_dentry = d_find_alias(h_inode);
+		if (unlikely(!h_dentry))
+			goto failure;
+		err = PTR_ERR(h_dentry);
+		if (IS_ERR(h_dentry)) {
+			h_dentry = NULL;
+			goto failure;
+		}
+		LKTRTrace("%.*s\n", AuDLNPair(h_dentry));
+	} else
+		dget(h_dentry);
+
+	err = vfsub_getattr(h_mnt, h_dentry, &st, /*dlgt*/0);
+	dput(h_dentry);
+	if (!err) {
+		rdev = st.rdev;
+		goto out; /* success */
+	}
+
+ failure:
+	AuIOErr("failed rdev for XFS inode, hi%lu, %d\n", h_inode->i_ino, err);
+ out:
+	return rdev;
+}
-- 
1.5.5.1.308.g1fbb5.dirty

