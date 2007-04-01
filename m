Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXDAQDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXDAQDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbXDAQDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:03:23 -0400
Received: from haxent.com ([65.99.219.155]:2894 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933473AbXDAQDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:03:22 -0400
Message-Id: <20070401160310.002947000@haxent.com.br>
References: <20070401155810.277757000@haxent.com.br>
User-Agent: quilt/0.46-1
Date: Sun, 01 Apr 2007 12:58:11 -0300
From: davi@haxent.com.br
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 01/12] pollfs: kernel-side API header
Content-Disposition: inline; filename=pollfs-api.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add pollfs_fs.h header which contains the kernel-side declarations
and auxiliary macros for type safety checks.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>
---

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
