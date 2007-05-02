Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbXEBFeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbXEBFeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXEBFen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:34:43 -0400
Received: from haxent.com ([65.99.219.155]:2152 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbXEBFem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:42 -0400
Message-Id: <20070502053424.077818000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:36 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 01/22] pollfs: kernel-side API header
Content-Disposition: inline; filename=pollfs-api.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add pollfs_fs.h header which contains the kernel-side declarations
and auxiliary macros for type safety checks. Those macros can be
simplified later.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 include/linux/pollfs_fs.h |   57 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

Index: linux-2.6/include/linux/pollfs_fs.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pollfs_fs.h
@@ -0,0 +1,57 @@
+/*
+ * pollfs, a naive filesystem for pollable (waitable) files (objects)
+ *
+ * Copyright (C) 2007 Davi E. M. Arnaut
+ *
+ */
+
+#ifndef _LINUX_POLL_FS_H
+#define _LINUX_POLL_FS_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/dcache.h>
+#include <linux/fs.h>
+
+#define PFS_CHECK_CALLBACK_1(f, a) (void*)				\
+	(sizeof((f)((typeof(a *))0)))
+
+#define PFS_CHECK_CALLBACK_2(f, a, b) (void*)				\
+	(sizeof((f)((typeof(a *))0, (typeof(b*))0)))
+
+#define PFS_WRITE(func, type, utype)					\
+	(ssize_t (*)(void *, const void __user *))			\
+	(0 ? PFS_CHECK_CALLBACK_2(func, type, utype) : func)
+
+#define PFS_READ(func, type, utype)					\
+	(ssize_t (*)(void *, void __user *))				\
+	(0 ? PFS_CHECK_CALLBACK_2(func, type, utype) : func)
+
+#define PFS_POLL(func, type)						\
+	(int (*)(void *))(0 ? PFS_CHECK_CALLBACK_1(func, type) : func)
+
+#define PFS_RELEASE(func, type)						\
+	(int (*)(void *))(0 ? PFS_CHECK_CALLBACK_1(func, type) : func)
+
+struct pfs_operations {
+	ssize_t (*read)(void *, void __user *);
+	ssize_t (*write)(void *, const void __user *);
+	int (*mmap)(void *, struct vm_area_struct *);
+	int (*poll)(void *);
+	int (*release)(void *);
+	size_t rsize;
+	size_t wsize;
+};
+
+struct pfs_file {
+	void *data;
+	wait_queue_head_t *wait;
+	const struct pfs_operations *fops;
+};
+
+long pfs_open(struct pfs_file *pfs);
+
+#endif	/* __KERNEL __ */
+
+#endif	/* _LINUX_POLLFS_FS_H */

--
