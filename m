Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYEPOpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYEPOpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYEPOmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:42:11 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49199 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYEPOmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:01 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 54/67] aufs lookup functions in 'delegate' mode
Date: Fri, 16 May 2008 23:33:08 +0900
Message-Id: <12109484022265-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484024124-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs lookup functions in 'delegate' mode

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/dlgt.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/dlgt.c b/fs/aufs/dlgt.c
new file mode 100644
index 0000000..0721a73
--- /dev/null
+++ b/fs/aufs/dlgt.c
@@ -0,0 +1,113 @@
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
+ *
+ * $Id: dlgt.c,v 1.2 2008/04/21 02:00:37 sfjro Exp $
+ */
+
+//#include <linux/security.h>
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
1.4.4.4

