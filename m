Return-Path: <linux-kernel-owner+w=401wt.eu-S936056AbYEUDuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936056AbYEUDuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934469AbYEUDfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:35:09 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44110 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286AbYEUDdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:33:00 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 09/39] aufs object lifetime management via sysfs
Date: Wed, 21 May 2008 12:22:39 +0900
Message-Id: <1211340189-11813-10-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
some aufs objects have a corresponding entry under sysfs, so the
lifetime will be managed by struct kref even if CONFIG_SYSFS is
disabled.
This file is compiled unconditionally.

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/sysaufs.c |  102 +++++++++++++++++++++++++++++++++++++++
 fs/aufs/sysaufs.h |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 239 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/sysaufs.c
 create mode 100644 fs/aufs/sysaufs.h

diff --git a/fs/aufs/sysaufs.c b/fs/aufs/sysaufs.c
new file mode 100644
index 0000000..0872b7a
--- /dev/null
+++ b/fs/aufs/sysaufs.c
@@ -0,0 +1,102 @@
+/*
+ * Copyright (C) 2007-2008 Junjiro Okajima
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
+ * sysfs interface and lifetime management
+ * they are necessary regardless sysfs is disabled.
+ */
+
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/sysfs.h>
+#include "aufs.h"
+
+/* ---------------------------------------------------------------------- */
+
+/* super_blocks list is not exported */
+DEFINE_MUTEX(au_sbilist_mtx);
+LIST_HEAD(au_sbilist);
+
+/* ---------------------------------------------------------------------- */
+
+static struct kset au_kset;
+
+#define AuSbiAttr(_name) { \
+	.attr   = { .name = __stringify(_name), .mode = 0444 },	\
+	.show   = sysaufs_sbi_##_name,				\
+}
+
+static struct au_sbi_attr au_sbi_attr_xino = AuSbiAttr(xino);
+struct attribute *au_sbi_attrs[] = {
+	&au_sbi_attr_xino.attr,
+	NULL,
+};
+
+static struct sysfs_ops au_sbi_ops = {
+	.show   = sysaufs_sbi_show
+};
+
+static struct kobj_type au_sbi_ktype = {
+	.release	= au_si_free,
+	.sysfs_ops	= &au_sbi_ops,
+	.default_attrs	= au_sbi_attrs,
+};
+
+/* ---------------------------------------------------------------------- */
+
+int sysaufs_si_init(struct au_sbinfo *sbinfo)
+{
+	int err;
+
+	sbinfo->si_kobj.kset = &au_kset;
+	err = kobject_init_and_add(&sbinfo->si_kobj, &au_sbi_ktype,
+				   NULL/*&au_kset.kobj*/,
+				   SysaufsSb_PREFIX "%p", sbinfo);
+	AuTraceErr(err);
+	return err;
+}
+
+
+/* ---------------------------------------------------------------------- */
+
+void sysaufs_fin(void)
+{
+	AuDebugOn(!list_empty(&au_sbilist));
+	sysfs_remove_group(&au_kset.kobj, au_attr_group);
+	kset_unregister(&au_kset);
+}
+
+int __init sysaufs_init(void)
+{
+	int err;
+
+	sysaufs_brs_init();
+	au_kset.kobj.parent = fs_kobj;
+	kobject_set_name(&au_kset.kobj, AUFS_NAME);
+	au_kset.kobj.ktype = au_ktype;
+	err = kset_register(&au_kset);
+	if (unlikely(err))
+		goto out;
+	err = sysfs_create_group(&au_kset.kobj, au_attr_group);
+	if (unlikely(err))
+		kset_unregister(&au_kset);
+
+ out:
+	AuTraceErr(err);
+	return err;
+}
diff --git a/fs/aufs/sysaufs.h b/fs/aufs/sysaufs.h
new file mode 100644
index 0000000..126f1bd
--- /dev/null
+++ b/fs/aufs/sysaufs.h
@@ -0,0 +1,137 @@
+/*
+ * Copyright (C) 2007-2008 Junjiro Okajima
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
+ * sysfs interface and lifetime management
+ */
+
+#ifndef __SYSAUFS_H__
+#define __SYSAUFS_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/sysfs.h>
+#include "module.h"
+#include "super.h"
+
+#define SysaufsSb_PREFIX	"si_"	/* followed by %p */
+
+struct au_sbi_attr {
+	struct attribute attr;
+	int (*show)(struct seq_file *seq, struct super_block *sb);
+};
+
+/* ---------------------------------------------------------------------- */
+
+/* sysaufs.c */
+extern struct mutex au_sbilist_mtx;
+extern struct list_head au_sbilist;
+extern struct attribute *au_sbi_attrs[];
+int sysaufs_si_init(struct au_sbinfo *sbinfo);
+int __init sysaufs_init(void);
+void sysaufs_fin(void);
+
+/* ---------------------------------------------------------------------- */
+
+static inline void au_sbilist_lock(void)
+{
+	mutex_lock(&au_sbilist_mtx);
+}
+
+static inline void au_sbilist_unlock(void)
+{
+	mutex_unlock(&au_sbilist_mtx);
+}
+
+static inline void au_sbilist_del(struct au_sbinfo *sbinfo)
+{
+	list_del(&sbinfo->si_list);
+}
+
+static inline void au_sbilist_add(struct au_sbinfo *sbinfo)
+{
+	/* the order in this list is important */
+	list_add_tail(&sbinfo->si_list, &au_sbilist);
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct au_branch;
+#ifdef CONFIG_SYSFS
+/* sysfs.c */
+extern struct attribute_group *au_attr_group;
+extern struct kobj_type *au_ktype;
+
+int sysaufs_sbi_xino(struct seq_file *seq, struct super_block *sb);
+int sysaufs_sbi_mntpnt1(struct seq_file *seq, struct super_block *sb);
+ssize_t sysaufs_sbi_show(struct kobject *kobj, struct attribute *attr,
+			 char *buf);
+
+void sysaufs_br_init(struct au_branch *br);
+void sysaufs_brs_add(struct super_block *sb, aufs_bindex_t bindex);
+void sysaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex);
+
+#define sysaufs_brs_init()	do {} while (0)
+
+#else
+#define au_attr_group	NULL
+#define au_ktype	NULL
+
+static inline
+int sysaufs_sbi_xino(struct seq_file *seq, struct super_block *sb)
+{
+	return 0;
+}
+
+static inline
+int sysaufs_sbi_mntpnt1(struct seq_file *seq, struct super_block *sb)
+{
+	return 0;
+}
+
+static inline
+ssize_t sysaufs_sbi_show(struct kobject *kobj, struct attribute *attr,
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
+#endif /* CONFIG_SYSFS */
+
+#endif /* __KERNEL__ */
+#endif /* __SYSAUFS_H__ */
-- 
1.5.5.1.308.g1fbb5.dirty

