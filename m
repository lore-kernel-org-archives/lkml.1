Return-Path: <linux-kernel-owner+w=401wt.eu-S1761915AbYEPPB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915AbYEPPB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758589AbYEPOo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:44:27 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49290 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYEPOmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:22 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 15/67] aufs special handling for inode attributes on FUSE branch
Date: Fri, 16 May 2008 23:32:29 +0900
Message-Id: <12109484013834-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484012543-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs special handling for inode attributes on FUSE branch

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/br_fuse.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/br_fuse.c b/fs/aufs/br_fuse.c
new file mode 100644
index 0000000..295139b
--- /dev/null
+++ b/fs/aufs/br_fuse.c
@@ -0,0 +1,109 @@
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
+ * special handling for inode attributes on FUSE branch
+ *
+ * $Id: br_fuse.c,v 1.2 2008/04/21 01:32:05 sfjro Exp $
+ */
+
+#include "aufs.h"
+
+/* h_mnt can be NULL, is it safe? */
+int au_update_fuse_h_inode(struct vfsmount *h_mnt, struct dentry *h_dentry)
+{
+	int err;
+	struct kstat st;
+
+	LKTRTrace("%.*s\n", AuDLNPair(h_dentry));
+
+	err = 0;
+	if (unlikely(h_dentry->d_inode
+		     //&& atomic_read(&h_dentry->d_inode->i_count)
+		     && au_test_fuse(h_dentry->d_sb))) {
+		err = vfsub_getattr(h_mnt, h_dentry, &st, /*dlgt*/0);
+		if (unlikely(err)) {
+			AuDbg("err %d\n", err);
+			au_debug_on();
+			AuDbgDentry(h_dentry);
+			au_debug_off();
+			WARN_ON(err);
+		}
+	}
+	return err;
+}
+
+/* currently, for fuse only */
+int aufs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *st)
+{
+	int err;
+	struct inode *inode, *h_inode;
+	struct dentry *h_dentry;
+
+	LKTRTrace("%.*s\n", AuDLNPair(dentry));
+
+	err = 0;
+	aufs_read_lock(dentry, AuLock_IR);
+	inode = dentry->d_inode;
+	h_inode = au_h_iptr(inode, au_ibstart(inode));
+	if (unlikely(au_test_fuse(h_inode->i_sb))) {
+		h_dentry = d_find_alias(h_inode);
+		/* simply gave up updating fuse inode */
+		if (h_dentry) {
+			/*ignore*/
+			if (!au_update_fuse_h_inode(NULL, h_dentry))
+				au_cpup_attr_all(inode);
+			dput(h_dentry);
+		}
+	}
+	generic_fillattr(inode, st);
+
+	aufs_read_unlock(dentry, AuLock_IR);
+	return err;
+}
+
+#if 0 // temp
+/*
+ * This function was born after a discussion with the FUSE developer.
+ * The inode attributes on a filesystem who defines i_op->getattr()
+ * is unreliable since such fs may not maintain the attributes at lookup.
+ * This function doesn't want the result of stat, instead wants the side-effect
+ * which refreshes the attributes.
+ * Hmm, there seems to be no such filesystem except fuse.
+ */
+int vfsub_i_attr(struct vfsmount *mnt, struct dentry *dentry, int dlgt)
+{
+	int err;
+	struct inode *inode;
+	struct inode_operations *op;
+	struct kstat st;
+
+	inode = dentry->d_inode;
+	AuDebugOn(!inode);
+
+	err = 0;
+	op = inode->i_op;
+	if (unlikely(op && op->getattr && !au_test_aufs(dentry->d_sb))) {
+		err = security_inode_getattr(mnt, dentry);
+		if (!err)
+			err = op->getattr(mnt, dentry, &st);
+	}
+	AuTraceErr(err);
+	return err;
+}
+#endif
-- 
1.4.4.4

