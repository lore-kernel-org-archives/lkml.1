Return-Path: <linux-kernel-owner+w=401wt.eu-S938455AbZDJHYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938455AbZDJHYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938099AbZDJHSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:18:06 -0400
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:61498 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938072AbZDJHR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:17:58 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 20/29] aufs sysfs entries
Date: Fri, 10 Apr 2009 16:02:34 +0900
Message-Id: <1239346963-30953-21-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
sysfs entries, compiled only when CONFIG_SYSFS is enabled

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/sysfs.c |  198 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 198 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/sysfs.c

diff --git a/fs/aufs/sysfs.c b/fs/aufs/sysfs.c
new file mode 100644
index 0000000..496a2fc
--- /dev/null
+++ b/fs/aufs/sysfs.c
@@ -0,0 +1,198 @@
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
+ * sysfs interface
+ */
+
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/sysfs.h>
+#include "aufs.h"
+
+static struct attribute *au_attr[] = {
+	NULL,	/* need to NULL terminate the list of attributes */
+};
+
+static struct attribute_group sysaufs_attr_group_body = {
+	.attrs = au_attr
+};
+
+struct attribute_group *sysaufs_attr_group = &sysaufs_attr_group_body;
+
+/* ---------------------------------------------------------------------- */
+
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
+/*
+ * the lifetime of branch is independent from the entry under sysfs.
+ * sysfs handles the lifetime of the entry, and never call ->show() after it is
+ * unlinked.
+ */
+static int sysaufs_si_br(struct seq_file *seq, struct super_block *sb,
+			 aufs_bindex_t bindex)
+{
+	struct path path;
+	struct dentry *root;
+	struct au_branch *br;
+
+	AuDbg("b%d\n", bindex);
+
+	root = sb->s_root;
+	di_read_lock_parent(root, !AuLock_IR);
+	br = au_sbr(sb, bindex);
+	path.mnt = br->br_mnt;
+	path.dentry = au_h_dptr(root, bindex);
+	au_seq_path(seq, &path);
+	di_read_unlock(root, !AuLock_IR);
+	seq_printf(seq, "=%s\n", au_optstr_br_perm(br->br_perm));
+	return 0;
+}
+
+/* ---------------------------------------------------------------------- */
+
+static struct seq_file *au_seq(char *p, ssize_t len)
+{
+	struct seq_file *seq;
+
+	seq = kzalloc(sizeof(*seq), GFP_NOFS);
+	if (seq) {
+		/* mutex_init(&seq.lock); */
+		seq->buf = p;
+		seq->size = len;
+		return seq; /* success */
+	}
+
+	seq = ERR_PTR(-ENOMEM);
+	return seq;
+}
+
+#define SysaufsBr_PREFIX "br"
+
+/* todo: file size may exceed PAGE_SIZE */
+ssize_t sysaufs_si_show(struct kobject *kobj, struct attribute *attr,
+			 char *buf)
+{
+	ssize_t err;
+	long l;
+	aufs_bindex_t bend;
+	struct au_sbinfo *sbinfo;
+	struct super_block *sb;
+	struct seq_file *seq;
+	char *name;
+	struct attribute **cattr;
+
+	sbinfo = container_of(kobj, struct au_sbinfo, si_kobj);
+	sb = sbinfo->si_sb;
+	si_noflush_read_lock(sb);
+
+	seq = au_seq(buf, PAGE_SIZE);
+	err = PTR_ERR(seq);
+	if (IS_ERR(seq))
+		goto out;
+
+	name = (void *)attr->name;
+	cattr = sysaufs_si_attrs;
+	while (*cattr) {
+		if (!strcmp(name, (*cattr)->name)) {
+			err = container_of(*cattr, struct sysaufs_si_attr, attr)
+				->show(seq, sb);
+			goto out_seq;
+		}
+		cattr++;
+	}
+
+	bend = au_sbend(sb);
+	if (!strncmp(name, SysaufsBr_PREFIX, sizeof(SysaufsBr_PREFIX) - 1)) {
+		name += sizeof(SysaufsBr_PREFIX) - 1;
+		err = strict_strtol(name, 10, &l);
+		if (!err) {
+			if (l <= bend)
+				err = sysaufs_si_br(seq, sb, (aufs_bindex_t)l);
+			else
+				err = -ENOENT;
+		}
+		goto out_seq;
+	}
+	BUG();
+
+ out_seq:
+	if (!err) {
+		err = seq->count;
+		/* sysfs limit */
+		if (unlikely(err == PAGE_SIZE))
+			err = -EFBIG;
+	}
+	kfree(seq);
+ out:
+	si_read_unlock(sb);
+	return err;
+}
+
+/* ---------------------------------------------------------------------- */
+
+void sysaufs_br_init(struct au_branch *br)
+{
+	br->br_attr.name = br->br_name;
+	br->br_attr.mode = S_IRUGO;
+	br->br_attr.owner = THIS_MODULE;
+}
+
+void sysaufs_brs_del(struct super_block *sb, aufs_bindex_t bindex)
+{
+	struct au_branch *br;
+	struct kobject *kobj;
+	aufs_bindex_t bend;
+
+	dbgaufs_brs_del(sb, bindex);
+
+	if (!sysaufs_brs)
+		return;
+
+	kobj = &au_sbi(sb)->si_kobj;
+	bend = au_sbend(sb);
+	for (; bindex <= bend; bindex++) {
+		br = au_sbr(sb, bindex);
+		sysfs_remove_file(kobj, &br->br_attr);
+	}
+}
+
+void sysaufs_brs_add(struct super_block *sb, aufs_bindex_t bindex)
+{
+	int err;
+	aufs_bindex_t bend;
+	struct kobject *kobj;
+	struct au_branch *br;
+
+	dbgaufs_brs_add(sb, bindex);
+
+	if (!sysaufs_brs)
+		return;
+
+	kobj = &au_sbi(sb)->si_kobj;
+	bend = au_sbend(sb);
+	for (; bindex <= bend; bindex++) {
+		br = au_sbr(sb, bindex);
+		snprintf(br->br_name, sizeof(br->br_name), SysaufsBr_PREFIX
+			 "%d", bindex);
+		err = sysfs_create_file(kobj, &br->br_attr);
+		if (unlikely(err))
+			AuWarn("failed %s under sysfs(%d)\n", br->br_name, err);
+	}
+}
-- 
1.6.1.284.g5dc13

