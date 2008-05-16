Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbYEPO6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbYEPO6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYEPOoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:44:07 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49302 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbYEPOmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:25 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 18/67] aufs sysfs interface and lifetime management, header
Date: Fri, 16 May 2008 23:32:32 +0900
Message-Id: <1210948401175-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484012301-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs sysfs interface and lifetime management, header

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/sysaufs.h |  150 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 150 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/sysaufs.h b/fs/aufs/sysaufs.h
new file mode 100644
index 0000000..eff08c0
--- /dev/null
+++ b/fs/aufs/sysaufs.h
@@ -0,0 +1,150 @@
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
+ *
+ * $Id: sysaufs.h,v 1.5 2008/05/04 23:51:26 sfjro Exp $
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
+/* entries under sysfs per super block */
+enum {
+	SysaufsSb_XINO,
+	SysaufsSb_MNTPNT1,
+#if 0
+	SysaufsSb_PLINK,
+	SysaufsSb_files,
+#endif
+	SysaufsSb_Last
+};
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
1.4.4.4

