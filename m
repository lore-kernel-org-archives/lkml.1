Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbZCXS0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbZCXS0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZCXS0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:26:17 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:59770 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbZCXS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:26:15 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #4 2/3] aufs: convert some aufs entries from sysfs to debugfs
Date: Wed, 25 Mar 2009 03:24:06 +0900
Message-Id: <1237919047-8751-3-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237919047-8751-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237919047-8751-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the comments from Greg KH on LKML.
Move 'xib', 'xigen' and 'xi0 ... xiN' entries from sysaufs to debugfs.
They show how many disk blocks are consumed.
- compile dbgaufs.c.
- remove 'xigen', 'xib' and 'xi0 ... xiN' entries from sysfs.
- new members of struct au_sbinfo for dentries under debugfs.
- replace members in struct au_xino_file by a dentry of debugfs.
- intialization and finalization for aufs entries under debugfs.
- show the xino file path in /proc/mounts only when CONFIG_SYSFS is disabled.
- minor enhancement, make sure that sysaufs_si_mask is not zero.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/Makefile  |    1 +
 fs/aufs/aufs.h    |    1 +
 fs/aufs/branch.c  |    2 +-
 fs/aufs/branch.h  |    6 +-
 fs/aufs/super.c   |    5 ++
 fs/aufs/super.h   |   19 ++++++
 fs/aufs/sysaufs.c |   30 +++++++---
 fs/aufs/sysaufs.h |   16 +++--
 fs/aufs/sysfs.c   |  168 ++++++++++-------------------------------------------
 9 files changed, 92 insertions(+), 156 deletions(-)

diff --git a/fs/aufs/Makefile b/fs/aufs/Makefile
index 7f9e9a3..52d8498 100644
--- a/fs/aufs/Makefile
+++ b/fs/aufs/Makefile
@@ -13,6 +13,7 @@ aufs-y := module.o sbinfo.o super.o branch.o xino.o sysaufs.o opts.o \
 
 # all are boolean
 aufs-$(CONFIG_SYSFS) += sysfs.o
+aufs-$(CONFIG_DEBUG_FS) += dbgaufs.o
 aufs-$(CONFIG_AUFS_BDEV_LOOP) += loop.o
 aufs-$(CONFIG_AUFS_HINOTIFY) += hinotify.o
 aufs-$(CONFIG_AUFS_DEBUG) += debug.o
diff --git a/fs/aufs/aufs.h b/fs/aufs/aufs.h
index a599aee..132e84e 100644
--- a/fs/aufs/aufs.h
+++ b/fs/aufs/aufs.h
@@ -23,6 +23,7 @@
 #include "branch.h"
 #include "cpup.h"
 #include "dcsub.h"
+#include "dbgaufs.h"
 #include "dentry.h"
 #include "dir.h"
 #include "file.h"
diff --git a/fs/aufs/branch.c b/fs/aufs/branch.c
index 232f5b3..5e11a11 100644
--- a/fs/aufs/branch.c
+++ b/fs/aufs/branch.c
@@ -304,7 +304,7 @@ static int au_br_init(struct au_branch *br, struct super_block *sb,
 	int err;
 
 	err = 0;
-	br->br_xino.xi_file = NULL;
+	memset(&br->br_xino, 0, sizeof(br->br_xino));
 	mutex_init(&br->br_xino.xi_nondir_mtx);
 	br->br_perm = add->perm;
 	br->br_mnt = add->path.mnt; /* set first, mntget() later */
diff --git a/fs/aufs/branch.h b/fs/aufs/branch.h
index 838648f..ffe0c08 100644
--- a/fs/aufs/branch.h
+++ b/fs/aufs/branch.h
@@ -32,10 +32,8 @@ struct au_xino_file {
 
 	/* todo: make xino files an array to support huge inode number */
 
-#ifdef CONFIG_SYSFS
-	/* an entry under sysfs per mount-point */
-	char			xi_name[8];
-	struct attribute	xi_attr;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry		 *xi_dbgaufs;
 #endif
 };
 
diff --git a/fs/aufs/super.c b/fs/aufs/super.c
index 700f8c8..c8f4c97 100644
--- a/fs/aufs/super.c
+++ b/fs/aufs/super.c
@@ -130,6 +130,9 @@ static void au_show_wbr_create(struct seq_file *m, int v,
 
 static int au_show_xino(struct seq_file *seq, struct vfsmount *mnt)
 {
+#ifdef CONFIG_SYSFS
+	return 0;
+#else
 	int err;
 	const int len = sizeof(AUFS_XINO_FNAME) - 1;
 	aufs_bindex_t bindex, brid;
@@ -164,6 +167,7 @@ static int au_show_xino(struct seq_file *seq, struct vfsmount *mnt)
 
  out:
 	return err;
+#endif
 }
 
 /* seq_file will re-call me in case of too long string */
@@ -394,6 +398,7 @@ static void aufs_put_super(struct super_block *sb)
 		return;
 
 	aufs_umount_begin(sb);
+	dbgaufs_si_fin(sbinfo);
 	kobject_put(&sbinfo->si_kobj);
 }
 
diff --git a/fs/aufs/super.h b/fs/aufs/super.h
index 83721ef..95420ca 100644
--- a/fs/aufs/super.h
+++ b/fs/aufs/super.h
@@ -135,6 +135,12 @@ struct au_sbinfo {
 	 * but using sysfs is majority.
 	 */
 	struct kobject		si_kobj;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry		 *si_dbgaufs, *si_dbgaufs_xib;
+#ifdef CONFIG_AUFS_EXPORT
+	struct dentry		 *si_dbgaufs_xigen;
+#endif
+#endif
 
 	/* dirty, necessary for unmounting, sysfs and sysrq */
 	struct super_block	*si_sb;
@@ -193,6 +199,19 @@ static inline struct au_sbinfo *au_sbi(struct super_block *sb)
 
 /* ---------------------------------------------------------------------- */
 
+static inline void dbgaufs_si_null(struct au_sbinfo *sbinfo)
+{
+#ifdef CONFIG_DEBUG_FS
+	sbinfo->si_dbgaufs = NULL;
+	sbinfo->si_dbgaufs_xib = NULL;
+#ifdef CONFIG_AUFS_EXPORT
+	sbinfo->si_dbgaufs_xigen = NULL;
+#endif
+#endif
+}
+
+/* ---------------------------------------------------------------------- */
+
 /* lock superblock. mainly for entry point functions */
 /*
  * si_noflush_read_lock, si_noflush_write_lock,
diff --git a/fs/aufs/sysaufs.c b/fs/aufs/sysaufs.c
index c6fde2c..623f2e6 100644
--- a/fs/aufs/sysaufs.c
+++ b/fs/aufs/sysaufs.c
@@ -25,11 +25,9 @@ struct kset *sysaufs_ket;
 	.show   = sysaufs_si_##_name,				\
 }
 
-static struct sysaufs_si_attr sysaufs_si_attr_xi_path = AuSiAttr(xi_path),
-	sysaufs_si_attr_xib = AuSiAttr(xib);
+static struct sysaufs_si_attr sysaufs_si_attr_xi_path = AuSiAttr(xi_path);
 struct attribute *sysaufs_si_attrs[] = {
 	&sysaufs_si_attr_xi_path.attr,
-	&sysaufs_si_attr_xib.attr,
 	NULL,
 };
 
@@ -50,14 +48,23 @@ int sysaufs_si_init(struct au_sbinfo *sbinfo)
 	int err;
 
 	sbinfo->si_kobj.kset = sysaufs_ket;
-	err = kobject_init_and_add(&sbinfo->si_kobj, &au_sbi_ktype,
-				   /*&sysaufs_ket->kobj*/NULL,
-				   "si_%lx", sysaufs_si_id(sbinfo));
+	/* cf. sysaufs_name() */
+	err = kobject_init_and_add
+		(&sbinfo->si_kobj, &au_sbi_ktype, /*&sysaufs_ket->kobj*/NULL,
+		 SysaufsSiNamePrefix "%lx", sysaufs_si_id(sbinfo));
+
+	dbgaufs_si_null(sbinfo);
+	if (!err) {
+		err = dbgaufs_si_init(sbinfo);
+		if (unlikely(err))
+			kobject_put(&sbinfo->si_kobj);
+	}
 	return err;
 }
 
 void sysaufs_fin(void)
 {
+	dbgaufs_fin();
 	sysfs_remove_group(&sysaufs_ket->kobj, sysaufs_attr_group);
 	kset_unregister(sysaufs_ket);
 }
@@ -66,16 +73,23 @@ int __init sysaufs_init(void)
 {
 	int err;
 
-	get_random_bytes(&sysaufs_si_mask, sizeof(sysaufs_si_mask));
+	do {
+		get_random_bytes(&sysaufs_si_mask, sizeof(sysaufs_si_mask));
+	} while (!sysaufs_si_mask);
 
 	sysaufs_ket = kset_create_and_add(AUFS_NAME, NULL, fs_kobj);
 	err = PTR_ERR(sysaufs_ket);
 	if (IS_ERR(sysaufs_ket))
 		goto out;
 	err = sysfs_create_group(&sysaufs_ket->kobj, sysaufs_attr_group);
-	if (unlikely(err))
+	if (unlikely(err)) {
 		kset_unregister(sysaufs_ket);
+		goto out;
+	}
 
+	err = dbgaufs_init();
+	if (unlikely(err))
+		sysaufs_fin();
  out:
 	return err;
 }
diff --git a/fs/aufs/sysaufs.h b/fs/aufs/sysaufs.h
index 71a0bba..c1202fa 100644
--- a/fs/aufs/sysaufs.h
+++ b/fs/aufs/sysaufs.h
@@ -19,6 +19,7 @@
 #include <linux/fs.h>
 #include <linux/sysfs.h>
 #include <linux/aufs_type.h>
+#include "module.h"
 
 struct sysaufs_si_attr {
 	struct attribute attr;
@@ -43,13 +44,20 @@ static inline unsigned long sysaufs_si_id(struct au_sbinfo *sbinfo)
 	return sysaufs_si_mask ^ (unsigned long)sbinfo;
 }
 
+#define SysaufsSiNamePrefix	"si_"
+#define SysaufsSiNameLen	(sizeof(SysaufsSiNamePrefix) + 16)
+static inline void sysaufs_name(struct au_sbinfo *sbinfo, char *name)
+{
+	snprintf(name, SysaufsSiNameLen, SysaufsSiNamePrefix "%lx",
+		 sysaufs_si_id(sbinfo));
+}
+
 struct au_branch;
 #ifdef CONFIG_SYSFS
 /* sysfs.c */
 extern struct attribute_group *sysaufs_attr_group;
 
 int sysaufs_si_xi_path(struct seq_file *seq, struct super_block *sb);
-int sysaufs_si_xib(struct seq_file *seq, struct super_block *sb);
 ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
 			 char *buf);
 
@@ -69,12 +77,6 @@ int sysaufs_si_xi_path(struct seq_file *seq, struct super_block *sb)
 }
 
 static inline
-int sysaufs_si_xib(struct seq_file *seq, struct super_block *sb)
-{
-	return 0;
-}
-
-static inline
 ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
 			 char *buf)
 {
diff --git a/fs/aufs/sysfs.c b/fs/aufs/sysfs.c
index 9bcdce2..496a2fc 100644
--- a/fs/aufs/sysfs.c
+++ b/fs/aufs/sysfs.c
@@ -40,60 +40,6 @@ int sysaufs_si_xi_path(struct seq_file *seq, struct super_block *sb)
 	return err;
 }
 
-static int sysaufs_xi_attr(struct seq_file *seq, struct file *xf,
-			   struct kstat *st)
-{
-	int err;
-
-	err = vfs_getattr(xf->f_vfsmnt, xf->f_dentry, st);
-	if (!err)
-		seq_printf(seq, "%llux%lu %lld\n",
-			   st->blocks, st->blksize, (long long)st->size);
-	else
-		seq_printf(seq, "err %d\n", err);
-
-	return err;
-}
-
-int sysaufs_si_xib(struct seq_file *seq, struct super_block *sb)
-{
-	int err;
-	struct kstat st;
-
-	err = 0;
-	if (au_opt_test(au_mntflags(sb), XINO))
-		err = sysaufs_xi_attr(seq, au_sbi(sb)->si_xib, &st);
-	return err;
-}
-
-static int sysaufs_si_xino(struct seq_file *seq, struct super_block *sb,
-			   aufs_bindex_t bindex)
-{
-	int err;
-	struct kstat st;
-	struct file *xf;
-
-	err = 0;
-	if (!au_opt_test(au_mntflags(sb), XINO))
-		goto out; /* success */
-
-	AuDbg("b%d\n", bindex);
-
-	xf = au_sbr(sb, bindex)->br_xino.xi_file;
-	if (xf) {
-		err = vfs_getattr(xf->f_vfsmnt, xf->f_dentry, &st);
-		if (!err)
-			seq_printf(seq, "%ld, %llux%lu %lld\n",
-				   (long)file_count(xf), st.blocks, st.blksize,
-				   (long long)st.size);
-		else
-			seq_printf(seq, "err %d\n", err);
-	}
-
- out:
-	return err;
-}
-
 /*
  * the lifetime of branch is independent from the entry under sysfs.
  * sysfs handles the lifetime of the entry, and never call ->show() after it is
@@ -138,7 +84,6 @@ static struct seq_file *au_seq(char *p, ssize_t len)
 }
 
 #define SysaufsBr_PREFIX "br"
-#define SysaufsXi_PREFIX "xi"
 
 /* todo: file size may exceed PAGE_SIZE */
 ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
@@ -152,26 +97,6 @@ ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
 	struct seq_file *seq;
 	char *name;
 	struct attribute **cattr;
-	static struct {
-		const int prefix_len;
-		char *prefix;
-		int (*func)(struct seq_file *seq, struct super_block *sb,
-			    aufs_bindex_t bindex);
-	} a[] = {
-		{
-			.prefix_len	= sizeof(SysaufsBr_PREFIX) - 1,
-			.prefix		= SysaufsBr_PREFIX,
-			.func		= sysaufs_si_br
-		},
-		{
-			.prefix_len	= sizeof(SysaufsXi_PREFIX) - 1,
-			.prefix		= SysaufsXi_PREFIX,
-			.func		= sysaufs_si_xino
-		},
-		{
-			.prefix_len	= 0
-		}
-	}, *p;
 
 	sbinfo = container_of(kobj, struct au_sbinfo, si_kobj);
 	sb = sbinfo->si_sb;
@@ -193,22 +118,17 @@ ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
 		cattr++;
 	}
 
-	p = a;
 	bend = au_sbend(sb);
-	while (p->prefix_len) {
-		if (!strncmp(name, p->prefix, p->prefix_len)) {
-			name += p->prefix_len;
-			err = strict_strtol(name, 10, &l);
-			if (!err) {
-				if (l <= bend)
-					err = p->func(seq, sb,
-						      (aufs_bindex_t)l);
-				else
-					err = -ENOENT;
-			}
-			goto out_seq;
+	if (!strncmp(name, SysaufsBr_PREFIX, sizeof(SysaufsBr_PREFIX) - 1)) {
+		name += sizeof(SysaufsBr_PREFIX) - 1;
+		err = strict_strtol(name, 10, &l);
+		if (!err) {
+			if (l <= bend)
+				err = sysaufs_si_br(seq, sb, (aufs_bindex_t)l);
+			else
+				err = -ENOENT;
 		}
-		p++;
+		goto out_seq;
 	}
 	BUG();
 
@@ -229,74 +149,50 @@ ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
 
 void sysaufs_br_init(struct au_branch *br)
 {
-	struct au_xino_file *xi;
-
 	br->br_attr.name = br->br_name;
 	br->br_attr.mode = S_IRUGO;
 	br->br_attr.owner = THIS_MODULE;
-
-	xi = &br->br_xino;
-	xi->xi_attr.name = xi->xi_name;
-	xi->xi_attr.mode = S_IRUGO;
-	xi->xi_attr.owner = THIS_MODULE;
 }
 
 void sysaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex)
 {
 	struct au_branch *br;
-	struct au_xino_file *xi;
 	struct kobject *kobj;
-	aufs_bindex_t bend, bi;
+	aufs_bindex_t bend;
+
+	dbgaufs_brs_del(sb, bindex);
+
+	if (!sysaufs_brs)
+		return;
 
 	kobj = &au_sbi(sb)->si_kobj;
 	bend = au_sbend(sb);
-	for (bi = bindex; bi <= bend; bi++) {
-		br = au_sbr(sb, bi);
-		xi = &br->br_xino;
-		sysfs_remove_file(kobj, &xi->xi_attr);
+	for (; bindex <= bend; bindex++) {
+		br = au_sbr(sb, bindex);
+		sysfs_remove_file(kobj, &br->br_attr);
 	}
-
-	if (sysaufs_brs)
-		for (; bindex <= bend; bindex++) {
-			br = au_sbr(sb, bindex);
-			sysfs_remove_file(kobj, &br->br_attr);
-		}
-}
-
-static void sysaufs_brs_do_add(struct kobject *kobj, struct attribute *attr,
-			       char name[], int nlen, char prefix[],
-			       aufs_bindex_t bindex)
-{
-	int err;
-
-	snprintf(name, nlen, "%s%d", prefix, bindex);
-	err = sysfs_create_file(kobj, attr);
-	if (unlikely(err))
-		AuWarn("failed %s under sysfs(%d)\n", name, err);
 }
 
 void sysaufs_brs_add(struct super_block *sb, aufs_bindex_t bindex)
 {
-	aufs_bindex_t bend, bi;
+	int err;
+	aufs_bindex_t bend;
 	struct kobject *kobj;
 	struct au_branch *br;
-	struct au_xino_file *xi;
+
+	dbgaufs_brs_add(sb, bindex);
+
+	if (!sysaufs_brs)
+		return;
 
 	kobj = &au_sbi(sb)->si_kobj;
 	bend = au_sbend(sb);
-	for (bi = bindex; bi <= bend; bi++) {
-		br = au_sbr(sb, bi);
-		xi = &br->br_xino;
-		/* todo: create link for shared xino */
-		sysaufs_brs_do_add(kobj, &xi->xi_attr, xi->xi_name,
-				   sizeof(xi->xi_name), SysaufsXi_PREFIX, bi);
+	for (; bindex <= bend; bindex++) {
+		br = au_sbr(sb, bindex);
+		snprintf(br->br_name, sizeof(br->br_name), SysaufsBr_PREFIX
+			 "%d", bindex);
+		err = sysfs_create_file(kobj, &br->br_attr);
+		if (unlikely(err))
+			AuWarn("failed %s under sysfs(%d)\n", br->br_name, err);
 	}
-
-	if (sysaufs_brs)
-		for (; bindex <= bend; bindex++) {
-			br = au_sbr(sb, bindex);
-			sysaufs_brs_do_add(kobj, &br->br_attr, br->br_name,
-					   sizeof(br->br_name),
-					   SysaufsBr_PREFIX, bindex);
-		}
 }
-- 
1.6.1.284.g5dc13

