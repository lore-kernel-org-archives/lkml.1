Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbYEPOsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbYEPOsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbYEPOmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:42:45 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49258 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYEPOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:16 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 19/67] aufs sysfs interface and lifetime management, source
Date: Fri, 16 May 2008 23:32:33 +0900
Message-Id: <12109484013702-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1210948401175-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs sysfs interface and lifetime management, source

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/sysaufs.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/sysaufs.c b/fs/aufs/sysaufs.c
new file mode 100644
index 0000000..7df12fd
--- /dev/null
+++ b/fs/aufs/sysaufs.c
@@ -0,0 +1,104 @@
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
+ *
+ * $Id: sysaufs.c,v 1.4 2008/04/28 03:05:39 sfjro Exp $
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
-- 
1.4.4.4

