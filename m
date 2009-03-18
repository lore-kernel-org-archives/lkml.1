Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbZCRSDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbZCRSDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbZCRSDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:03:24 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:16099 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756880AbZCRSDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:03:23 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/8] exofs: symlink_inode and fast_symlink_inode operations
Date: Wed, 18 Mar 2009 20:01:10 +0200
Message-Id: <1237399270-29274-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <49C1331D.1080805@panasas.com>
References: <49C1331D.1080805@panasas.com>
X-OriginalArrivalTime: 18 Mar 2009 18:02:19.0778 (UTC) FILETIME=[AE2BFE20:01C9A7F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic implementation of symlink ops.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/Kbuild    |    2 +-
 fs/exofs/exofs.h   |    4 +++
 fs/exofs/symlink.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 1 deletions(-)
 create mode 100644 fs/exofs/symlink.c

diff --git a/fs/exofs/Kbuild b/fs/exofs/Kbuild
index 269281f..42d5299 100644
--- a/fs/exofs/Kbuild
+++ b/fs/exofs/Kbuild
@@ -26,5 +26,5 @@ KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
 
 endif
 
-exofs-y := osd.o inode.o file.o
+exofs-y := osd.o inode.o file.o symlink.o
 obj-$(CONFIG_EXOFS_FS) += exofs.o
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index 28deb67..d3b8bde 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -138,4 +138,8 @@ int exofs_setattr(struct dentry *, struct iattr *);
 extern const struct inode_operations exofs_file_inode_operations;
 extern const struct file_operations exofs_file_operations;
 
+/* symlink.c         */
+extern const struct inode_operations exofs_symlink_inode_operations;
+extern const struct inode_operations exofs_fast_symlink_inode_operations;
+
 #endif
diff --git a/fs/exofs/symlink.c b/fs/exofs/symlink.c
new file mode 100644
index 0000000..36e2d7b
--- /dev/null
+++ b/fs/exofs/symlink.c
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ * Copyright (C) 2008, 2009
+ * Boaz Harrosh <bharrosh@panasas.com>
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of exofs.
+ *
+ * exofs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for exofs is version 2.
+ *
+ * exofs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with exofs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/namei.h>
+
+#include "exofs.h"
+
+static void *exofs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct exofs_i_info *oi = exofs_i(dentry->d_inode);
+
+	nd_set_link(nd, (char *)oi->i_data);
+	return NULL;
+}
+
+const struct inode_operations exofs_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= page_follow_link_light,
+	.put_link	= page_put_link,
+};
+
+const struct inode_operations exofs_fast_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= exofs_follow_link,
+};
-- 
1.6.2.1

