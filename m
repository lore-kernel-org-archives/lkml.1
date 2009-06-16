Return-Path: <linux-kernel-owner+w=401wt.eu-S1764318AbZFPUna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764318AbZFPUna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760218AbZFPUk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59624 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762322AbZFPUk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/17] VFS: Define pioctl command wrappers
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:16 +0100
Message-ID: <20090616203916.4526.30440.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define pioctl() command wrappers, equivalent to ioctl() command wrapper _IOW().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/pioctl.c       |    7 ++++---
 include/linux/venus.h |   21 +++++++++++++++++++++
 include/linux/vice.h  |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/venus.h
 create mode 100644 include/linux/vice.h


diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index 63d2fe1..6cac006 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -31,7 +31,9 @@ long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 		return ret;
 	}
 
-	switch (cmd) {
+#define VIOC_COMMAND(nr) (_VICEIOCTL(nr) & ~IOCSIZE_MASK)
+
+	switch (cmd & ~IOCSIZE_MASK) {
 	default:
 		_debug("fallback to pathless: %x", cmd);
 		ret = afs_pathless_pioctl(cmd, arg);
@@ -57,8 +59,7 @@ long afs_pathless_pioctl(int cmd, struct vice_ioctl *arg)
 
 	switch (cmd & ~IOCSIZE_MASK) {
 	default:
-		printk(KERN_DEBUG
-			"AFS: Unsupported pioctl command %x\n", cmd);
+		printk(KERN_DEBUG "AFS: Unsupported pioctl command %x\n", cmd);
 		ret = -EOPNOTSUPP;
 		break;
 	}
diff --git a/include/linux/venus.h b/include/linux/venus.h
new file mode 100644
index 0000000..19fe13e
--- /dev/null
+++ b/include/linux/venus.h
@@ -0,0 +1,21 @@
+/* Venus VICE (p)ioctls used by AFS
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_VENUS_H
+#define _LINUX_VENUS_H
+
+#include <linux/vice.h>
+
+/*
+ * pioctl commands (not usable as ioctls)
+ */
+
+#endif /* _LINUX_VENUS_H */
diff --git a/include/linux/vice.h b/include/linux/vice.h
new file mode 100644
index 0000000..76080fb
--- /dev/null
+++ b/include/linux/vice.h
@@ -0,0 +1,35 @@
+/* Command wrappers for the Vast Interconnected Computing Environment ioctls
+ * and pioctls
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_VICE_H
+#define _LINUX_VICE_H
+
+#include <linux/pioctl.h>
+#include <linux/ioctl.h>
+#include <linux/compat.h>
+
+/*
+ * Wrappers for VICE ioctl/pioctl
+ */
+#define _VICEIOCTL(nr)		_IOW('V', nr, struct ViceIoctl)
+#define _CVICEIOCTL(nr)		_IOW('C', nr, struct ViceIoctl)
+#define _OVICEIOCTL(nr)		_IOW('O', nr, struct ViceIoctl)
+
+#ifdef __KERNEL__
+#ifdef CONFIG_COMPAT
+#define _compat_VICEIOCTL(nr)	_IOW('V', nr, struct compat_ViceIoctl)
+#define _compat_CVICEIOCTL(nr)	_IOW('C', nr, struct compat_ViceIoctl)
+#define _compat_OVICEIOCTL(nr)	_IOW('O', nr, struct compat_ViceIoctl)
+#endif
+#endif
+
+#endif /* _LINUX_VICE_H */

