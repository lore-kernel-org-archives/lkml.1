Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZCPHag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZCPHag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbZCPHX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:23:57 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:35659 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087AbZCPHW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:22:57 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #2 07/28] aufs object lifetime management via sysfs
Date: Mon, 16 Mar 2009 16:20:19 +0900
Message-Id: <1237188040-11404-8-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
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
 fs/aufs/sysaufs.c |   79 +++++++++++++++++++++++++++++++++++++++++
 fs/aufs/sysaufs.h |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 181 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/sysaufs.c
 create mode 100644 fs/aufs/sysaufs.h

diff --git a/fs/aufs/sysaufs.c b/fs/aufs/sysaufs.c
new file mode 100644
index 0000000..47ffbfd
--- /dev/null
+++ b/fs/aufs/sysaufs.c
@@ -0,0 +1,79 @@
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
+static struct sysaufs_si_attr sysaufs_si_attr_xino = AuSiAttr(xino);
+struct attribute *sysaufs_si_attrs[] = {
+	&sysaufs_si_attr_xino.attr,
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
+	err = kobject_init_and_add(&sbinfo->si_kobj, &au_sbi_ktype,
+				   /*&sysaufs_ket->kobj*/NULL,
+				   "si_%lx", sysaufs_si_id(sbinfo));
+	return err;
+}
+
+void sysaufs_fin(void)
+{
+	sysfs_remove_group(&sysaufs_ket->kobj, sysaufs_attr_group);
+	kset_unregister(sysaufs_ket);
+}
+
+int __init sysaufs_init(void)
+{
+	int err;
+
+	get_random_bytes(&sysaufs_si_mask, sizeof(sysaufs_si_mask));
+
+	sysaufs_ket = kset_create_and_add(AUFS_NAME, NULL, fs_kobj);
+	err = PTR_ERR(sysaufs_ket);
+	if (IS_ERR(sysaufs_ket))
+		goto out;
+	err = sysfs_create_group(&sysaufs_ket->kobj, sysaufs_attr_group);
+	if (unlikely(err))
+		kset_unregister(sysaufs_ket);
+
+ out:
+	return err;
+}
diff --git a/fs/aufs/sysaufs.h b/fs/aufs/sysaufs.h
new file mode 100644
index 0000000..04ffab2
--- /dev/null
+++ b/fs/aufs/sysaufs.h
@@ -0,0 +1,102 @@
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
+struct au_branch;
+#ifdef CONFIG_SYSFS
+/* sysfs.c */
+extern struct attribute_group *sysaufs_attr_group;
+extern struct kobj_type *sysaufs_ktype;
+
+int sysaufs_si_xino(struct seq_file *seq, struct super_block *sb);
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
+#define sysaufs_ktype		NULL
+
+static inline
+int sysaufs_si_xino(struct seq_file *seq, struct super_block *sb)
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

