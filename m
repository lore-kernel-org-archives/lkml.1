Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZBINU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZBINU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZBINUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:20:49 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:2280 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754092AbZBINUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:20:48 -0500
From: Boaz Harrosh <bharrosh@panasas.com>
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/8] exofs: symlink_inode and fast_symlink_inode operations
Date: Mon,  9 Feb 2009 15:20:36 +0200
Message-Id: <1234185636-7822-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <49902A9E.3070002@panasas.com>
References: <49902A9E.3070002@panasas.com>
X-OriginalArrivalTime: 09 Feb 2009 13:20:46.0486 (UTC) FILETIME=[37B37360:01C98AB9]
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
index d8bd4d5..18c6158 100644
--- a/fs/exofs/Kbuild
+++ b/fs/exofs/Kbuild
@@ -26,5 +26,5 @@ KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
 
 endif
 
-exofs-objs := osd.o inode.o file.o
+exofs-objs := osd.o inode.o file.o symlink.o
 obj-$(CONFIG_EXOFS_FS) += exofs.o
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index b6d9089..9470be3 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -147,4 +147,8 @@ int exofs_setattr(struct dentry *, struct iattr *);
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
1.6.0.1

