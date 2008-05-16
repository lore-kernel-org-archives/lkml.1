Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYEPOtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYEPOtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbYEPOmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:42:47 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49264 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYEPOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:16 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 17/67] aufs special handling inode attributes on XFS branch in linux-2.6.24 and later
Date: Fri, 16 May 2008 23:32:31 +0900
Message-Id: <12109484012301-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484012213-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs special handling inode attributes on XFS branch in linux-2.6.24 and later

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/br_xfs.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/br_xfs.c b/fs/aufs/br_xfs.c
new file mode 100644
index 0000000..360ffaa
--- /dev/null
+++ b/fs/aufs/br_xfs.c
@@ -0,0 +1,69 @@
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
+ * special handling inode attributes on XFS branch in linux-2.6.24 and later
+ *
+ * $Id: br_xfs.c,v 1.2 2008/04/21 01:33:00 sfjro Exp $
+ */
+
+#include "aufs.h"
+
+/* h_mnt can be NULL, is it safe? */
+dev_t au_h_rdev(struct inode *h_inode, struct vfsmount *h_mnt,
+		struct dentry *h_dentry)
+{
+	dev_t rdev;
+	int err;
+	struct kstat st;
+
+	LKTRTrace("hi%lu\n", h_inode->i_ino);
+	if (h_dentry)
+		LKTRTrace("%.*s\n", AuDLNPair(h_dentry));
+
+	rdev = h_inode->i_rdev;
+	if (!rdev || !au_test_xfs(h_inode->i_sb))
+		goto out;
+
+	rdev = 0;
+	if (!h_dentry) {
+		err = 0;
+		h_dentry = d_find_alias(h_inode);
+		if (unlikely(!h_dentry))
+			goto failure;
+		err = PTR_ERR(h_dentry);
+		if (IS_ERR(h_dentry)) {
+			h_dentry = NULL;
+			goto failure;
+		}
+		LKTRTrace("%.*s\n", AuDLNPair(h_dentry));
+	} else
+		dget(h_dentry);
+
+	err = vfsub_getattr(h_mnt, h_dentry, &st, /*dlgt*/0);
+	dput(h_dentry);
+	if (!err) {
+		rdev = st.rdev;
+		goto out; /* success */
+	}
+
+ failure:
+	AuIOErr("failed rdev for XFS inode, hi%lu, %d\n", h_inode->i_ino, err);
+ out:
+	return rdev;
+}
-- 
1.4.4.4

