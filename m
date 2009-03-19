Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZCSFNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZCSFNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 01:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZCSFMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 01:12:52 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:38679 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZCSFMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 01:12:51 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs
Date: Thu, 19 Mar 2009 14:12:45 +0900
Message-Id: <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the comments from Greg KH on LKML.
- make all entries "one value per file".
- split 'xino' into 'xi_path', 'xib' and 'xi0'...'xiN'.
- new members in struct au_xino_file for xi[0-9]* entry.
- remove sysaufs_si_attr_xino.
- sysaufs_si_xino() shows only a size info of one xino file.
- new variables sysaufs_si_attr_xi_path and sysaufs_si_attr_xib.
- new functions sysaufs_si_xi_path() and sysaufs_si_xib().
- rename sysaufs_sbi_xi() to sysaufs_xi_attr().
- sysaufs_si_show() supports xiN.
- sysaufs_br_init() initializes br->br_xino.xi_attr too.
- sysaufs_brs_del() and sysaufs_brs_add() always handle
  br->br_xino.xi_attr.
- new static function sysaufs_brs_do_add() to generate brN and xiN
  names.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/ABI/testing/sysfs-aufs |   62 +++++++++++
 fs/aufs/branch.h                     |    6 +
 fs/aufs/sysaufs.c                    |    6 +-
 fs/aufs/sysaufs.h                    |   11 ++-
 fs/aufs/sysfs.c                      |  195 +++++++++++++++++++++++-----------
 5 files changed, 212 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-aufs

diff --git a/Documentation/ABI/testing/sysfs-aufs b/Documentation/ABI/testing/sysfs-aufs
new file mode 100644
index 0000000..1552d3e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-aufs
@@ -0,0 +1,62 @@
+What:		/sys/fs/aufs/si_<id>/
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		Under /sys/fs/aufs, a directory named si_<id> is created
+		per aufs mount, where <id> is a unique id generated
+		internally.
+
+What:		/sys/fs/aufs/si_<id>/br0, br1 ... brN
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the abolute path of a member directory (which
+		is called branch) in aufs, and its permission.
+
+What:		/sys/fs/aufs/si_<id>/xi_path
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the abolute path of XINO (External Inode Number
+		Bitmap, Translation Table and Generation Table) file
+		even if it is the default path.
+		When the aufs mount option 'noxino' is specified, it
+		will be empty. About XINO files, see
+		Documentation/filesystems/aufs/aufs.5 in detail.
+
+What:		/sys/fs/aufs/si_<id>/xib
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the consumed blocks by xib (External Inode Number
+		Bitmap), its block size and file size.
+		When the aufs mount option 'noxino' is specified, it
+		will be empty. About XINO files, see
+		Documentation/filesystems/aufs/aufs.5 in detail.
+
+What:		/sys/fs/aufs/si_<id>/xino0, xino1 ... xinoN
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the consumed blocks by xino (External Inode Number
+		Translation Table), its link count, block size and file
+		size.
+		When the aufs mount option 'noxino' is specified, it
+		will be empty. About XINO files, see
+		Documentation/filesystems/aufs/aufs.5 in detail.
+
+What:		/sys/fs/aufs/si_<id>/xigen
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the consumed blocks by xigen (External Inode
+		Generation Table), its block size and file size.
+		If CONFIG_AUFS_EXPORT is disabled, this entry will not
+		be created.
+		When the aufs mount option 'noxino' is specified, it
+		will be empty. About XINO files, see
+		Documentation/filesystems/aufs/aufs.5 in detail.
+
+# Local variables: ;
+# mode: text;
+# End: ;
diff --git a/fs/aufs/branch.h b/fs/aufs/branch.h
index 5a7fed4..838648f 100644
--- a/fs/aufs/branch.h
+++ b/fs/aufs/branch.h
@@ -31,6 +31,12 @@ struct au_xino_file {
 	struct mutex		xi_nondir_mtx;
 
 	/* todo: make xino files an array to support huge inode number */
+
+#ifdef CONFIG_SYSFS
+	/* an entry under sysfs per mount-point */
+	char			xi_name[8];
+	struct attribute	xi_attr;
+#endif
 };
 
 /* members for writable branch only */
diff --git a/fs/aufs/sysaufs.c b/fs/aufs/sysaufs.c
index 47ffbfd..c6fde2c 100644
--- a/fs/aufs/sysaufs.c
+++ b/fs/aufs/sysaufs.c
@@ -25,9 +25,11 @@ struct kset *sysaufs_ket;
 	.show   = sysaufs_si_##_name,				\
 }
 
-static struct sysaufs_si_attr sysaufs_si_attr_xino = AuSiAttr(xino);
+static struct sysaufs_si_attr sysaufs_si_attr_xi_path = AuSiAttr(xi_path),
+	sysaufs_si_attr_xib = AuSiAttr(xib);
 struct attribute *sysaufs_si_attrs[] = {
-	&sysaufs_si_attr_xino.attr,
+	&sysaufs_si_attr_xi_path.attr,
+	&sysaufs_si_attr_xib.attr,
 	NULL,
 };
 
diff --git a/fs/aufs/sysaufs.h b/fs/aufs/sysaufs.h
index 60b18a8..71a0bba 100644
--- a/fs/aufs/sysaufs.h
+++ b/fs/aufs/sysaufs.h
@@ -48,7 +48,8 @@ struct au_branch;
 /* sysfs.c */
 extern struct attribute_group *sysaufs_attr_group;
 
-int sysaufs_si_xino(struct seq_file *seq, struct super_block *sb);
+int sysaufs_si_xi_path(struct seq_file *seq, struct super_block *sb);
+int sysaufs_si_xib(struct seq_file *seq, struct super_block *sb);
 ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
 			 char *buf);
 
@@ -62,7 +63,13 @@ void sysaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex);
 #define sysaufs_attr_group	NULL
 
 static inline
-int sysaufs_si_xino(struct seq_file *seq, struct super_block *sb)
+int sysaufs_si_xi_path(struct seq_file *seq, struct super_block *sb)
+{
+	return 0;
+}
+
+static inline
+int sysaufs_si_xib(struct seq_file *seq, struct super_block *sb)
 {
 	return 0;
 }
diff --git a/fs/aufs/sysfs.c b/fs/aufs/sysfs.c
index 2112f3b..9bcdce2 100644
--- a/fs/aufs/sysfs.c
+++ b/fs/aufs/sysfs.c
@@ -28,55 +28,65 @@ struct attribute_group *sysaufs_attr_group = &sysaufs_attr_group_body;
 
 /* ---------------------------------------------------------------------- */
 
-static int sysaufs_sbi_xi(struct seq_file *seq, struct file *xf,
-			  struct kstat *st)
+int sysaufs_si_xi_path(struct seq_file *seq, struct super_block *sb)
+{
+	int err;
+
+	err = 0;
+	if (au_opt_test(au_mntflags(sb), XINO)) {
+		err = au_xino_path(seq, au_sbi(sb)->si_xib);
+		seq_putc(seq, '\n');
+	}
+	return err;
+}
+
+static int sysaufs_xi_attr(struct seq_file *seq, struct file *xf,
+			   struct kstat *st)
 {
 	int err;
 
 	err = vfs_getattr(xf->f_vfsmnt, xf->f_dentry, st);
-	if (!err) {
-		seq_printf(seq, "%llux%lu %lld",
+	if (!err)
+		seq_printf(seq, "%llux%lu %lld\n",
 			   st->blocks, st->blksize, (long long)st->size);
-		seq_putc(seq, '\n');
-	} else
+	else
 		seq_printf(seq, "err %d\n", err);
 
 	return err;
 }
 
-int sysaufs_si_xino(struct seq_file *seq, struct super_block *sb)
+int sysaufs_si_xib(struct seq_file *seq, struct super_block *sb)
+{
+	int err;
+	struct kstat st;
+
+	err = 0;
+	if (au_opt_test(au_mntflags(sb), XINO))
+		err = sysaufs_xi_attr(seq, au_sbi(sb)->si_xib, &st);
+	return err;
+}
+
+static int sysaufs_si_xino(struct seq_file *seq, struct super_block *sb,
+			   aufs_bindex_t bindex)
 {
 	int err;
-	aufs_bindex_t bend, bindex;
 	struct kstat st;
-	struct au_sbinfo *sbinfo;
 	struct file *xf;
 
 	err = 0;
-	sbinfo = au_sbi(sb);
 	if (!au_opt_test(au_mntflags(sb), XINO))
 		goto out; /* success */
 
-	xf = sbinfo->si_xib;
-	err = au_xino_path(seq, xf);
-	seq_putc(seq, '\n');
-	if (!err)
-		err = sysaufs_sbi_xi(seq, xf, &st);
-
-	bend = au_sbend(sb);
-	for (bindex = 0; !err && bindex <= bend; bindex++) {
-		xf = au_sbr(sb, bindex)->br_xino.xi_file;
-		if (!xf)
-			continue;
+	AuDbg("b%d\n", bindex);
 
-		seq_printf(seq, "%d: ", bindex);
+	xf = au_sbr(sb, bindex)->br_xino.xi_file;
+	if (xf) {
 		err = vfs_getattr(xf->f_vfsmnt, xf->f_dentry, &st);
-		if (!err) {
-			seq_printf(seq, "%ld, %llux%lu %lld",
+		if (!err)
+			seq_printf(seq, "%ld, %llux%lu %lld\n",
 				   (long)file_count(xf), st.blocks, st.blksize,
 				   (long long)st.size);
-			seq_putc(seq, '\n');
-		} else
+		else
 			seq_printf(seq, "err %d\n", err);
 	}
 
@@ -89,20 +99,15 @@ int sysaufs_si_xino(struct seq_file *seq, struct super_block *sb)
  * sysfs handles the lifetime of the entry, and never call ->show() after it is
  * unlinked.
  */
-#define SysaufsBr_PREFIX "br"
-static int sysaufs_sbi_br(struct seq_file *seq, struct super_block *sb,
-			  aufs_bindex_t bindex)
+static int sysaufs_si_br(struct seq_file *seq, struct super_block *sb,
+			 aufs_bindex_t bindex)
 {
-	int err;
 	struct path path;
 	struct dentry *root;
 	struct au_branch *br;
 
-	err = -ENOENT;
-	if (unlikely(au_sbend(sb) < bindex))
-		goto out;
+	AuDbg("b%d\n", bindex);
 
-	err = 0;
 	root = sb->s_root;
 	di_read_lock_parent(root, !AuLock_IR);
 	br = au_sbr(sb, bindex);
@@ -111,9 +116,7 @@ static int sysaufs_sbi_br(struct seq_file *seq, struct super_block *sb,
 	au_seq_path(seq, &path);
 	di_read_unlock(root, !AuLock_IR);
 	seq_printf(seq, "=%s\n", au_optstr_br_perm(br->br_perm));
-
- out:
-	return err;
+	return 0;
 }
 
 /* ---------------------------------------------------------------------- */
@@ -134,17 +137,41 @@ static struct seq_file *au_seq(char *p, ssize_t len)
 	return seq;
 }
 
+#define SysaufsBr_PREFIX "br"
+#define SysaufsXi_PREFIX "xi"
+
 /* todo: file size may exceed PAGE_SIZE */
 ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
 			 char *buf)
 {
 	ssize_t err;
 	long l;
+	aufs_bindex_t bend;
 	struct au_sbinfo *sbinfo;
 	struct super_block *sb;
 	struct seq_file *seq;
 	char *name;
 	struct attribute **cattr;
+	static struct {
+		const int prefix_len;
+		char *prefix;
+		int (*func)(struct seq_file *seq, struct super_block *sb,
+			    aufs_bindex_t bindex);
+	} a[] = {
+		{
+			.prefix_len	= sizeof(SysaufsBr_PREFIX) - 1,
+			.prefix		= SysaufsBr_PREFIX,
+			.func		= sysaufs_si_br
+		},
+		{
+			.prefix_len	= sizeof(SysaufsXi_PREFIX) - 1,
+			.prefix		= SysaufsXi_PREFIX,
+			.func		= sysaufs_si_xino
+		},
+		{
+			.prefix_len	= 0
+		}
+	}, *p;
 
 	sbinfo = container_of(kobj, struct au_sbinfo, si_kobj);
 	sb = sbinfo->si_sb;
@@ -166,12 +193,22 @@ ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
 		cattr++;
 	}
 
-	if (!strncmp(name, SysaufsBr_PREFIX, sizeof(SysaufsBr_PREFIX) - 1)) {
-		name += sizeof(SysaufsBr_PREFIX) - 1;
-		err = strict_strtol(name, 10, &l);
-		if (!err)
-			err = sysaufs_sbi_br(seq, sb, (aufs_bindex_t)l);
-		goto out_seq;
+	p = a;
+	bend = au_sbend(sb);
+	while (p->prefix_len) {
+		if (!strncmp(name, p->prefix, p->prefix_len)) {
+			name += p->prefix_len;
+			err = strict_strtol(name, 10, &l);
+			if (!err) {
+				if (l <= bend)
+					err = p->func(seq, sb,
+						      (aufs_bindex_t)l);
+				else
+					err = -ENOENT;
+			}
+			goto out_seq;
+		}
+		p++;
 	}
 	BUG();
 
@@ -192,44 +229,74 @@ ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
 
 void sysaufs_br_init(struct au_branch *br)
 {
+	struct au_xino_file *xi;
+
 	br->br_attr.name = br->br_name;
 	br->br_attr.mode = S_IRUGO;
 	br->br_attr.owner = THIS_MODULE;
+
+	xi = &br->br_xino;
+	xi->xi_attr.name = xi->xi_name;
+	xi->xi_attr.mode = S_IRUGO;
+	xi->xi_attr.owner = THIS_MODULE;
 }
 
 void sysaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex)
 {
-	struct au_sbinfo *sbinfo;
-	aufs_bindex_t bend;
-
-	if (!sysaufs_brs)
-		return;
+	struct au_branch *br;
+	struct au_xino_file *xi;
+	struct kobject *kobj;
+	aufs_bindex_t bend, bi;
 
-	sbinfo = au_sbi(sb);
+	kobj = &au_sbi(sb)->si_kobj;
 	bend = au_sbend(sb);
-	for (; bindex <= bend; bindex++)
-		sysfs_remove_file(&sbinfo->si_kobj,
-				  &au_sbr(sb, bindex)->br_attr);
+	for (bi = bindex; bi <= bend; bi++) {
+		br = au_sbr(sb, bi);
+		xi = &br->br_xino;
+		sysfs_remove_file(kobj, &xi->xi_attr);
+	}
+
+	if (sysaufs_brs)
+		for (; bindex <= bend; bindex++) {
+			br = au_sbr(sb, bindex);
+			sysfs_remove_file(kobj, &br->br_attr);
+		}
 }
 
-void sysaufs_brs_add(struct super_block *sb, aufs_bindex_t bindex)
+static void sysaufs_brs_do_add(struct kobject *kobj, struct attribute *attr,
+			       char name[], int nlen, char prefix[],
+			       aufs_bindex_t bindex)
 {
 	int err;
-	aufs_bindex_t bend;
+
+	snprintf(name, nlen, "%s%d", prefix, bindex);
+	err = sysfs_create_file(kobj, attr);
+	if (unlikely(err))
+		AuWarn("failed %s under sysfs(%d)\n", name, err);
+}
+
+void sysaufs_brs_add(struct super_block *sb, aufs_bindex_t bindex)
+{
+	aufs_bindex_t bend, bi;
 	struct kobject *kobj;
 	struct au_branch *br;
-
-	if (!sysaufs_brs)
-		return;
+	struct au_xino_file *xi;
 
 	kobj = &au_sbi(sb)->si_kobj;
 	bend = au_sbend(sb);
-	for (; bindex <= bend; bindex++) {
-		br = au_sbr(sb, bindex);
-		snprintf(br->br_name, sizeof(br->br_name),
-			 SysaufsBr_PREFIX "%d", bindex);
-		err = sysfs_create_file(kobj, &br->br_attr);
-		if (unlikely(err))
-			AuWarn("failed %s under sysfs(%d)\n", br->br_name, err);
+	for (bi = bindex; bi <= bend; bi++) {
+		br = au_sbr(sb, bi);
+		xi = &br->br_xino;
+		/* todo: create link for shared xino */
+		sysaufs_brs_do_add(kobj, &xi->xi_attr, xi->xi_name,
+				   sizeof(xi->xi_name), SysaufsXi_PREFIX, bi);
 	}
+
+	if (sysaufs_brs)
+		for (; bindex <= bend; bindex++) {
+			br = au_sbr(sb, bindex);
+			sysaufs_brs_do_add(kobj, &br->br_attr, br->br_name,
+					   sizeof(br->br_name),
+					   SysaufsBr_PREFIX, bindex);
+		}
 }
-- 
1.6.1.284.g5dc13

