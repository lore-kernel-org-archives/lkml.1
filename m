Return-Path: <linux-kernel-owner+w=401wt.eu-S935418AbYEUDnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935418AbYEUDnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934019AbYEUDeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:34:01 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44164 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765184AbYEUDdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:33:13 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 35/39] aufs misc functions
Date: Wed, 21 May 2008 12:23:05 +0900
Message-Id: <1211340189-11813-36-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
misc functions

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/misc.c |  266 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/misc.h |  201 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 467 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/misc.c
 create mode 100644 fs/aufs/misc.h

diff --git a/fs/aufs/misc.c b/fs/aufs/misc.c
new file mode 100644
index 0000000..9c5694c
--- /dev/null
+++ b/fs/aufs/misc.c
@@ -0,0 +1,266 @@
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
+ *
+ */
+
+#include "aufs.h"
+
+void *au_kzrealloc(void *p, unsigned int nused, unsigned int new_sz, gfp_t gfp)
+{
+	void *q;
+
+	LKTRTrace("p %p, nused %d, sz %d\n", p, nused, new_sz);
+	AuDebugOn(new_sz <= 0);
+	if (new_sz <= nused)
+		return p;
+
+	q = krealloc(p, new_sz, gfp);
+	if (q)
+		memset(q + nused, 0, new_sz - nused);
+	return q;
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct nameidata *au_dup_nd(struct au_sbinfo *sbinfo, struct nameidata *dst,
+			    struct nameidata *src)
+{
+	LKTRTrace("src %p\n", src);
+
+	if (src) {
+		*dst = *src;
+		dst->flags &= ~LOOKUP_PARENT;
+		if (sbinfo->si_wbr_create == AuWbrCreate_TDP) {
+			if ((dst->flags & LOOKUP_CREATE)
+			    && !(dst->intent.open.flags & O_CREAT))
+				dst->flags &= ~LOOKUP_CREATE;
+		} else {
+			dst->flags &= ~LOOKUP_CREATE;
+			dst->intent.open.flags &= ~O_CREAT;
+		}
+	} else
+		dst = NULL;
+
+	return dst;
+}
+
+struct nameidata *au_fake_dm(struct nameidata *fake_nd, struct nameidata *nd,
+			     struct super_block *sb, aufs_bindex_t bindex)
+{
+	LKTRTrace("nd %p, b%d\n", nd, bindex);
+
+	if (!nd)
+		return NULL;
+
+	DiMustAnyLock(nd->path.dentry);
+
+	fake_nd->path.dentry = NULL;
+	fake_nd->path.mnt = NULL;
+
+	if (bindex <= au_dbend(nd->path.dentry))
+		fake_nd->path.dentry = au_h_dptr(nd->path.dentry, bindex);
+	if (fake_nd->path.dentry) {
+		fake_nd->path.mnt = au_sbr_mnt(sb, bindex);
+		AuDebugOn(!fake_nd->path.mnt);
+		path_get(&fake_nd->path);
+	} else
+		fake_nd = ERR_PTR(-ENOENT);
+
+	AuTraceErrPtr(fake_nd);
+	return fake_nd;
+}
+
+void au_fake_dm_release(struct nameidata *fake_nd)
+{
+	if (fake_nd)
+		path_put(&fake_nd->path);
+}
+
+int au_h_create(struct inode *h_dir, struct dentry *h_dentry, int mode,
+		int dlgt, struct nameidata *nd, struct vfsmount *nfsmnt)
+{
+	int err;
+
+	LKTRTrace("hi%lu, %.*s, 0%o, nd %d, nfsmnt %d\n",
+		  h_dir->i_ino, AuDLNPair(h_dentry), mode, !!nd, !!nfsmnt);
+
+	err = -ENOSYS;
+	if (!nfsmnt)
+		err = vfsub_create(h_dir, h_dentry, mode, /*nd*/NULL, dlgt);
+	else {
+		struct nameidata fake_nd;
+
+		if (nd)
+			fake_nd = *nd;
+		else
+			memset(&fake_nd, 0, sizeof(fake_nd));
+		fake_nd.path.dentry = h_dentry;
+		fake_nd.path.mnt = nfsmnt;
+		path_get(&fake_nd.path);
+		fake_nd.flags = LOOKUP_CREATE;
+		fake_nd.intent.open.flags = O_CREAT | FMODE_READ;
+		fake_nd.intent.open.create_mode = mode;
+
+		err = vfsub_create(h_dir, h_dentry, mode, &fake_nd, dlgt);
+		path_put(&fake_nd.path);
+	}
+
+	AuTraceErr(err);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+int au_copy_file(struct file *dst, struct file *src, loff_t len,
+		 struct super_block *sb)
+{
+	int err, all_zero;
+	unsigned long blksize;
+	char *buf;
+	struct vfsub_args vargs;
+	/* reduce stack space */
+	struct iattr *ia;
+
+	LKTRTrace("%.*s, %.*s\n",
+		  AuDLNPair(dst->f_dentry), AuDLNPair(src->f_dentry));
+	AuDebugOn(!(dst->f_mode & FMODE_WRITE));
+#ifdef CONFIG_AUFS_DEBUG
+	{
+		struct dentry *parent;
+		parent = dget_parent(dst->f_dentry);
+		IMustLock(parent->d_inode);
+		dput(parent);
+	}
+#endif
+
+	err = -ENOMEM;
+	blksize = dst->f_dentry->d_sb->s_blocksize;
+	if (!blksize || PAGE_SIZE < blksize)
+		blksize = PAGE_SIZE;
+	LKTRTrace("blksize %lu\n", blksize);
+	buf = kmalloc(blksize, GFP_TEMPORARY);
+	if (unlikely(!buf))
+		goto out;
+	ia = kmalloc(sizeof(*ia), GFP_TEMPORARY);
+	if (unlikely(!ia))
+		goto out_buf;
+
+#ifdef CONFIG_AUFS_DEBUG
+	if (len > (1 << 22))
+		AuWarn("copying a large file %Ld\n", (long long)len);
+#endif
+	vfsub_args_init(&vargs, NULL, au_opt_test_dlgt(au_mntflags(sb)), 0);
+	err = 0;
+	all_zero = 0;
+	src->f_pos = 0;
+	dst->f_pos = 0;
+	while (len) {
+		size_t sz, rbytes, wbytes, i;
+		char *p;
+
+		LKTRTrace("len %lld\n", len);
+		sz = blksize;
+		if (len < blksize)
+			sz = len;
+
+		/* support LSM and notify */
+		rbytes = 0;
+		/* todo: signal_pending? */
+		while (!rbytes || err == -EAGAIN || err == -EINTR) {
+			rbytes = vfsub_read_k(src, buf, sz, &src->f_pos,
+					      vfsub_ftest(vargs.flags, DLGT));
+			err = rbytes;
+		}
+		if (unlikely(err < 0))
+			break;
+
+		all_zero = 0;
+		if (len >= rbytes && rbytes == blksize) {
+			/* todo: try bitmap or memcmp()/get_zeroed_page()? */
+			unsigned long *ulp;
+			size_t n;
+
+			all_zero = 1;
+			ulp = (void *)buf;
+			n = rbytes / sizeof(*ulp);
+			i = n;
+			while (n-- > 0 && all_zero)
+				all_zero = !*ulp++;
+			p = (void *)ulp;
+			i *= sizeof(*ulp);
+			for (; all_zero && i < rbytes; i++)
+				all_zero = !*p++;
+		}
+		if (!all_zero) {
+			wbytes = rbytes;
+			p = buf;
+			while (wbytes) {
+				size_t b;
+				/* support LSM and notify */
+				b = vfsub_write_k(dst, p, wbytes, &dst->f_pos,
+						  &vargs);
+				err = b;
+				/* todo: signal_pending? */
+				if (unlikely(err == -EAGAIN || err == -EINTR))
+					continue;
+				if (unlikely(err < 0))
+					break;
+				wbytes -= b;
+				p += b;
+			}
+		} else {
+			loff_t res;
+			LKTRLabel(hole);
+			res = vfsub_llseek(dst, rbytes, SEEK_CUR);
+			err = res;
+			if (unlikely(res < 0))
+				break;
+		}
+		len -= rbytes;
+		err = 0;
+	}
+
+	/* the last block may be a hole */
+	if (unlikely(!err && all_zero)) {
+		struct dentry *h_d = dst->f_dentry;
+		struct inode *h_i = h_d->d_inode;
+
+		LKTRLabel(last hole);
+		do {
+			/* todo: signal_pending? */
+			err = vfsub_write_k(dst, "\0", 1, &dst->f_pos, &vargs);
+		} while (err == -EAGAIN || err == -EINTR);
+		if (err == 1) {
+			ia->ia_size = dst->f_pos;
+			ia->ia_valid = ATTR_SIZE | ATTR_FILE;
+			ia->ia_file = dst;
+			mutex_lock_nested(&h_i->i_mutex, AuLsc_I_CHILD2);
+			err = vfsub_notify_change(h_d, ia, &vargs);
+			mutex_unlock(&h_i->i_mutex);
+		}
+	}
+
+	kfree(ia);
+ out_buf:
+	kfree(buf);
+ out:
+	AuTraceErr(err);
+	return err;
+}
diff --git a/fs/aufs/misc.h b/fs/aufs/misc.h
new file mode 100644
index 0000000..3dcbf7e
--- /dev/null
+++ b/fs/aufs/misc.h
@@ -0,0 +1,201 @@
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
+ *
+ */
+
+#ifndef __AUFS_MISC_H__
+#define __AUFS_MISC_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/aufs_type.h>
+
+/* ---------------------------------------------------------------------- */
+
+typedef unsigned int au_gen_t;
+/* see linux/include/linux/jiffies.h */
+#define AuGenYounger(a, b)	((int)(b) - (int)(a) < 0)
+#define AuGenOlder(a, b)	AufsGenYounger(b, a)
+
+/* ---------------------------------------------------------------------- */
+
+struct au_rwsem {
+	struct rw_semaphore	rwsem;
+#ifdef CONFIG_AUFS_DEBUG
+	atomic_t		rcnt;
+#endif
+};
+
+#ifdef CONFIG_AUFS_DEBUG
+#define AuDbgRcntInit(rw) do { \
+	atomic_set(&(rw)->rcnt, 0); \
+	smp_mb(); /* atomic set */ \
+} while (0)
+
+#define AuDbgRcntInc(rw)	atomic_inc_return(&(rw)->rcnt)
+#define AuDbgRcntDec(rw)	WARN_ON(atomic_dec_return(&(rw)->rcnt) < 0)
+#else
+#define AuDbgRcntInit(rw)	do {} while (0)
+#define AuDbgRcntInc(rw)	do {} while (0)
+#define AuDbgRcntDec(rw)	do {} while (0)
+#endif /* CONFIG_AUFS_DEBUG */
+
+static inline void au_rw_init_nolock(struct au_rwsem *rw)
+{
+	AuDbgRcntInit(rw);
+	init_rwsem(&rw->rwsem);
+}
+
+static inline void au_rw_init_wlock(struct au_rwsem *rw)
+{
+	au_rw_init_nolock(rw);
+	down_write(&rw->rwsem);
+}
+
+static inline void au_rw_init_wlock_nested(struct au_rwsem *rw,
+					   unsigned int lsc)
+{
+	au_rw_init_nolock(rw);
+	down_write_nested(&rw->rwsem, lsc);
+}
+
+static inline void au_rw_read_lock(struct au_rwsem *rw)
+{
+	down_read(&rw->rwsem);
+	AuDbgRcntInc(rw);
+}
+
+static inline void au_rw_read_lock_nested(struct au_rwsem *rw, unsigned int lsc)
+{
+	down_read_nested(&rw->rwsem, lsc);
+	AuDbgRcntInc(rw);
+}
+
+static inline void au_rw_read_unlock(struct au_rwsem *rw)
+{
+	AuDbgRcntDec(rw);
+	up_read(&rw->rwsem);
+}
+
+static inline void au_rw_dgrade_lock(struct au_rwsem *rw)
+{
+	AuDbgRcntInc(rw);
+	downgrade_write(&rw->rwsem);
+}
+
+static inline void au_rw_write_lock(struct au_rwsem *rw)
+{
+	down_write(&rw->rwsem);
+}
+
+static inline void au_rw_write_lock_nested(struct au_rwsem *rw,
+					   unsigned int lsc)
+{
+	down_write_nested(&rw->rwsem, lsc);
+}
+
+static inline void au_rw_write_unlock(struct au_rwsem *rw)
+{
+	up_write(&rw->rwsem);
+}
+
+/* why is not _nested version defined */
+static inline int au_rw_read_trylock(struct au_rwsem *rw)
+{
+	int ret = down_read_trylock(&rw->rwsem);
+	if (ret)
+		AuDbgRcntInc(rw);
+	return ret;
+}
+
+static inline int au_rw_write_trylock(struct au_rwsem *rw)
+{
+	return down_write_trylock(&rw->rwsem);
+}
+
+#undef AuDbgRcntInit
+#undef AuDbgRcntInc
+#undef AuDbgRcntDec
+
+/* to debug easier, do not make them inlined functions */
+#define AuRwMustNoWaiters(rw)	AuDebugOn(!list_empty(&(rw)->rwsem.wait_list))
+#define AuRwMustAnyLock(rw)	AuDebugOn(down_write_trylock(&(rw)->rwsem))
+#ifdef CONFIG_AUFS_DEBUG
+#define AuRwMustReadLock(rw) do { \
+	AuRwMustAnyLock(rw); \
+	AuDebugOn(!atomic_read(&(rw)->rcnt)); \
+} while (0)
+
+#define AuRwMustWriteLock(rw) do { \
+	AuRwMustAnyLock(rw); \
+	AuDebugOn(atomic_read(&(rw)->rcnt)); \
+} while (0)
+#else
+#define AuRwMustReadLock(rw)	AuRwMustAnyLock(rw)
+#define AuRwMustWriteLock(rw)	AuRwMustAnyLock(rw)
+#endif /* CONFIG_AUFS_DEBUG */
+
+#define AuSimpleLockRwsemFuncs(prefix, param, rwsem) \
+static inline void prefix##_read_lock(param) \
+{ au_rw_read_lock(&(rwsem)); } \
+static inline void prefix##_write_lock(param) \
+{ au_rw_write_lock(&(rwsem)); } \
+static inline int prefix##_read_trylock(param) \
+{ return au_rw_read_trylock(&(rwsem)); } \
+static inline int prefix##_write_trylock(param) \
+{ return au_rw_write_trylock(&(rwsem)); }
+/* static inline void prefix##_read_trylock_nested(param, lsc)
+{au_rw_read_trylock_nested(&(rwsem, lsc));}
+static inline void prefix##_write_trylock_nestd(param, lsc)
+{au_rw_write_trylock_nested(&(rwsem), nested);} */
+
+#define AuSimpleUnlockRwsemFuncs(prefix, param, rwsem) \
+static inline void prefix##_read_unlock(param) \
+{ au_rw_read_unlock(&(rwsem)); } \
+static inline void prefix##_write_unlock(param) \
+{ au_rw_write_unlock(&(rwsem)); } \
+static inline void prefix##_downgrade_lock(param) \
+{ au_rw_dgrade_lock(&(rwsem)); }
+
+#define AuSimpleRwsemFuncs(prefix, param, rwsem) \
+	AuSimpleLockRwsemFuncs(prefix, param, rwsem) \
+	AuSimpleUnlockRwsemFuncs(prefix, param, rwsem)
+
+/* ---------------------------------------------------------------------- */
+
+void *au_kzrealloc(void *p, unsigned int nused, unsigned int new_sz, gfp_t gfp);
+
+struct au_sbinfo;
+struct nameidata *au_dup_nd(struct au_sbinfo *sbinfo, struct nameidata *dst,
+			    struct nameidata *src);
+
+struct nameidata *au_fake_dm(struct nameidata *fake_nd, struct nameidata *nd,
+			     struct super_block *sb, aufs_bindex_t bindex);
+void au_fake_dm_release(struct nameidata *fake_nd);
+int au_h_create(struct inode *h_dir, struct dentry *h_dentry, int mode,
+		int dlgt, struct nameidata *nd, struct vfsmount *nfsmnt);
+
+int au_copy_file(struct file *dst, struct file *src, loff_t len,
+		 struct super_block *sb);
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_MISC_H__ */
-- 
1.5.5.1.308.g1fbb5.dirty

