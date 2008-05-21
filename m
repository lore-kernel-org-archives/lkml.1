Return-Path: <linux-kernel-owner+w=401wt.eu-S934860AbYEUDgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934860AbYEUDgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932296AbYEUDdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:33:09 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44078 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbYEUDcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:32:54 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 30/39] aufs delegate mode
Date: Wed, 21 May 2008 12:23:00 +0900
Message-Id: <1211340189-11813-31-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
'delegate' is a special mode for people who don't want their application
to access branches through aufs or to be traced strictly by task I/O
accounting. Also it will be helpful for LSM users, because the internal
access from aufs to branches may be detected, reported or prohibited by
LSM. in 'delegate' mode, aufs passes the internal access to the aufs
kernel thread.

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/dlgt.c |  110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/dlgt.c

diff --git a/fs/aufs/dlgt.c b/fs/aufs/dlgt.c
new file mode 100644
index 0000000..9fb25b7
--- /dev/null
+++ b/fs/aufs/dlgt.c
@@ -0,0 +1,110 @@
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
+ * lookup functions in 'delegate' mode
+ */
+
+#include "aufs.h"
+
+/* ---------------------------------------------------------------------- */
+
+struct au_lookup_one_len_args {
+	struct dentry **errp;
+	const char *name;
+	struct dentry *parent;
+	int len;
+};
+
+static void au_call_lookup_one_len(void *args)
+{
+	struct au_lookup_one_len_args *a = args;
+	*a->errp = vfsub_lookup_one_len(a->name, a->parent, a->len);
+}
+
+struct dentry *au_lkup_one_dlgt(const char *name, struct dentry *parent,
+				int len, unsigned int flags)
+{
+	struct dentry *dentry;
+	int dirperm1;
+
+	LKTRTrace("%.*s/%.*s, 0x%x\n", AuDLNPair(parent), len, name, flags);
+
+	dirperm1 = au_ftest_ndx(flags, DIRPERM1);
+	if (!dirperm1 && !au_ftest_ndx(flags, DLGT))
+		dentry = vfsub_lookup_one_len(name, parent, len);
+	else {
+		int wkq_err;
+		struct au_lookup_one_len_args args = {
+			.errp	= &dentry,
+			.name	= name,
+			.parent	= parent,
+			.len	= len
+		};
+		wkq_err = au_wkq_wait(au_call_lookup_one_len, &args,
+				      /*dlgt*/!dirperm1);
+		if (unlikely(wkq_err))
+			dentry = ERR_PTR(wkq_err);
+	}
+
+	AuTraceErrPtr(dentry);
+	return dentry;
+}
+
+/* ---------------------------------------------------------------------- */
+
+struct security_inode_permission_args {
+	int *errp;
+	struct inode *h_inode;
+	int mask;
+	struct nameidata *fake_nd;
+};
+
+static void call_security_inode_permission(void *args)
+{
+	struct security_inode_permission_args *a = args;
+	LKTRTrace("fsuid %d\n", current->fsuid);
+	*a->errp = security_inode_permission(a->h_inode, a->mask, a->fake_nd);
+}
+
+int au_security_inode_permission(struct inode *h_inode, int mask,
+				 struct nameidata *fake_nd, int dlgt)
+{
+	int err;
+
+	AuTraceEnter();
+
+	if (!dlgt)
+		err = security_inode_permission(h_inode, mask, fake_nd);
+	else {
+		int wkq_err;
+		struct security_inode_permission_args args = {
+			.errp		= &err,
+			.h_inode	= h_inode,
+			.mask		= mask,
+			.fake_nd	= fake_nd
+		};
+		wkq_err = au_wkq_wait(call_security_inode_permission, &args,
+				      /*dlgt*/1);
+		if (unlikely(wkq_err))
+			err = wkq_err;
+	}
+
+	AuTraceErr(err);
+	return err;
+}
-- 
1.5.5.1.308.g1fbb5.dirty

