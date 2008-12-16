Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbYLPPVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbYLPPVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbYLPPVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:21:23 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:18699 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754446AbYLPPVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:21:22 -0500
Message-ID: <4947C76E.6070807@panasas.com>
Date: Tue, 16 Dec 2008 17:21:18 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/9] exofs: symlink_inode and fast_symlink_inode operations
References: <4947BFAA.4030208@panasas.com>
In-Reply-To: <4947BFAA.4030208@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2008 15:19:50.0976 (UTC) FILETIME=[BD6DDC00:01C95F91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Generic implementation of symlink ops.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/Kbuild    |    2 +-
 fs/exofs/exofs.h   |    4 +++
 fs/exofs/symlink.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletions(-)
 create mode 100644 fs/exofs/symlink.c

diff --git a/fs/exofs/Kbuild b/fs/exofs/Kbuild
index d9dedc9..b372058 100644
--- a/fs/exofs/Kbuild
+++ b/fs/exofs/Kbuild
@@ -26,5 +26,5 @@ KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
 
 endif
 
-exofs-objs := osd.o inode.o file.o
+exofs-objs := osd.o inode.o file.o symlink.o
 obj-$(CONFIG_EXOFS_FS) += exofs.o
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index f11250c..6f9b56c 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -191,4 +191,8 @@ int exofs_setattr(struct dentry *, struct iattr *);
 extern struct inode_operations exofs_file_inode_operations;
 extern struct file_operations exofs_file_operations;
 
+/* symlink.c         */
+extern struct inode_operations exofs_symlink_inode_operations;
+extern struct inode_operations exofs_fast_symlink_inode_operations;
+
 #endif
diff --git a/fs/exofs/symlink.c b/fs/exofs/symlink.c
new file mode 100644
index 0000000..4275451
--- /dev/null
+++ b/fs/exofs/symlink.c
@@ -0,0 +1,54 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
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
+	struct exofs_i_info *oi = EXOFS_I(dentry->d_inode);
+	nd_set_link(nd, (char *)oi->i_data);
+	return NULL;
+}
+
+struct inode_operations exofs_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= page_follow_link_light,
+	.put_link	= page_put_link,
+};
+
+struct inode_operations exofs_fast_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= exofs_follow_link,
+};
-- 
1.6.0.1


