Return-Path: <linux-kernel-owner+w=401wt.eu-S938179AbZDJHTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938179AbZDJHTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937912AbZDJHRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:17:08 -0400
Received: from mfbichi12.ns.itscom.net ([219.110.2.190]:35949 "EHLO
	mfbichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936856AbZDJHRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:17:04 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 06/29] aufs object lifetime management via sysfs
Date: Fri, 10 Apr 2009 16:02:20 +0900
Message-Id: <1239346963-30953-7-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
some aufs objects have a corresponding entry under sysfs, so the
lifetime will be managed by struct kref even if CONFIG_SYSFS is
disabled.
This file is compiled unconditionally.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/ABI/testing/sysfs-aufs |   25 ++++++++
 fs/aufs/sysaufs.c                    |   95 +++++++++++++++++++++++++++++
 fs/aufs/sysaufs.h                    |  109 ++++++++++++++++++++++++++++++++++
 3 files changed, 229 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-aufs
 create mode 100644 fs/aufs/sysaufs.c
 create mode 100644 fs/aufs/sysaufs.h

diff --git a/Documentation/ABI/testing/sysfs-aufs b/Documentation/ABI/testing/sysfs-aufs
new file mode 100644
index 0000000..ca49330
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-aufs
@@ -0,0 +1,25 @@
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
diff --git a/fs/aufs/sysaufs.c b/fs/aufs/sysaufs.c
new file mode 100644
index 0000000..623f2e6
--- /dev/null
+++ b/fs/aufs/sysaufs.c
@@ -0,0 +1,95 @@
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
+ * sysfs interface and lifetime management
+ * they are necessary regardless sysfs is disabled.
+ */
+
+#include <linux/fs.h>
+#include <linux/random.h>
+#include <linux/sysfs.h>
+#include "aufs.h"
+
+unsigned long sysaufs_si_mask;
+struct kset *sysaufs_ket;
+
+#define AuSiAttr(_name) { \
+	.attr   = { .name = __stringify(_name), .mode = 0444 },	\
+	.show   = sysaufs_si_##_name,				\
+}
+
+static struct sysaufs_si_attr sysaufs_si_attr_xi_path = AuSiAttr(xi_path);
+struct attribute *sysaufs_si_attrs[] = {
+	&sysaufs_si_attr_xi_path.attr,
+	NULL,
+};
+
+static struct sysfs_ops au_sbi_ops = {
+	.show   = sysaufs_si_show
+};
+
+static struct kobj_type au_sbi_ktype = {
+	.release	= au_si_free,
+	.sysfs_ops	= &au_sbi_ops,
+	.default_attrs	= sysaufs_si_attrs
+};
+
+/* ---------------------------------------------------------------------- */
+
+int sysaufs_si_init(struct au_sbinfo *sbinfo)
+{
+	int err;
+
+	sbinfo->si_kobj.kset = sysaufs_ket;
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
+	return err;
+}
+
+void sysaufs_fin(void)
+{
+	dbgaufs_fin();
+	sysfs_remove_group(&sysaufs_ket->kobj, sysaufs_attr_group);
+	kset_unregister(sysaufs_ket);
+}
+
+int __init sysaufs_init(void)
+{
+	int err;
+
+	do {
+		get_random_bytes(&sysaufs_si_mask, sizeof(sysaufs_si_mask));
+	} while (!sysaufs_si_mask);
+
+	sysaufs_ket = kset_create_and_add(AUFS_NAME, NULL, fs_kobj);
+	err = PTR_ERR(sysaufs_ket);
+	if (IS_ERR(sysaufs_ket))
+		goto out;
+	err = sysfs_create_group(&sysaufs_ket->kobj, sysaufs_attr_group);
+	if (unlikely(err)) {
+		kset_unregister(sysaufs_ket);
+		goto out;
+	}
+
+	err = dbgaufs_init();
+	if (unlikely(err))
+		sysaufs_fin();
+ out:
+	return err;
+}
diff --git a/fs/aufs/sysaufs.h b/fs/aufs/sysaufs.h
new file mode 100644
index 0000000..c1202fa
--- /dev/null
+++ b/fs/aufs/sysaufs.h
@@ -0,0 +1,109 @@
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
+ * sysfs interface and mount lifetime management
+ */
+
+#ifndef __SYSAUFS_H__
+#define __SYSAUFS_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/sysfs.h>
+#include <linux/aufs_type.h>
+#include "module.h"
+
+struct sysaufs_si_attr {
+	struct attribute attr;
+	int (*show)(struct seq_file *seq, struct super_block *sb);
+};
+
+/* ---------------------------------------------------------------------- */
+
+/* sysaufs.c */
+extern unsigned long sysaufs_si_mask;
+extern struct kset *sysaufs_ket;
+extern struct attribute *sysaufs_si_attrs[];
+int sysaufs_si_init(struct au_sbinfo *sbinfo);
+int __init sysaufs_init(void);
+void sysaufs_fin(void);
+
+/* ---------------------------------------------------------------------- */
+
+/* some people doesn't like to show a pointer in kernel */
+static inline unsigned long sysaufs_si_id(struct au_sbinfo *sbinfo)
+{
+	return sysaufs_si_mask ^ (unsigned long)sbinfo;
+}
+
+#define SysaufsSiNamePrefix	"si_"
+#define SysaufsSiNameLen	(sizeof(SysaufsSiNamePrefix) + 16)
+static inline void sysaufs_name(struct au_sbinfo *sbinfo, char *name)
+{
+	snprintf(name, SysaufsSiNameLen, SysaufsSiNamePrefix "%lx",
+		 sysaufs_si_id(sbinfo));
+}
+
+struct au_branch;
+#ifdef CONFIG_SYSFS
+/* sysfs.c */
+extern struct attribute_group *sysaufs_attr_group;
+
+int sysaufs_si_xi_path(struct seq_file *seq, struct super_block *sb);
+ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
+			 char *buf);
+
+void sysaufs_br_init(struct au_branch *br);
+void sysaufs_brs_add(struct super_block *sb, aufs_bindex_t bindex);
+void sysaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex);
+
+#define sysaufs_brs_init()	do {} while (0)
+
+#else
+#define sysaufs_attr_group	NULL
+
+static inline
+int sysaufs_si_xi_path(struct seq_file *seq, struct super_block *sb)
+{
+	return 0;
+}
+
+static inline
+ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
+			 char *buf)
+{
+	return 0;
+}
+
+static inline void sysaufs_br_init(struct au_branch *br)
+{
+	/* empty */
+}
+
+static inline void sysaufs_brs_add(struct super_block *sb, aufs_bindex_t bindex)
+{
+	/* nothing */
+}
+
+static inline void sysaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex)
+{
+	/* nothing */
+}
+
+static inline void sysaufs_brs_init(void)
+{
+	sysaufs_brs = 0;
+}
+
+#endif /* CONFIG_SYSFS */
+
+#endif /* __KERNEL__ */
+#endif /* __SYSAUFS_H__ */
-- 
1.6.1.284.g5dc13

