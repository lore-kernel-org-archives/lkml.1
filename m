Return-Path: <linux-kernel-owner+w=401wt.eu-S2993074AbXCIIOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993074AbXCIIOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993075AbXCIIOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:14:44 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44308 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993074AbXCIIOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:14:42 -0500
Date: Fri, 9 Mar 2007 10:14:42 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       serue@us.ibm.com
Subject: [PATCH 2/7] revoke: add f_light flag for struct file
Message-ID: <Pine.LNX.4.64.0703091014110.32320@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This adds a f_light flag to struct file to indicate that the file was
looked up with fget_light().  Needed by revoke to ensure we don't
close a file pointer while someone is using it without actually
holding a reference.

These bits were taken from the forced unmount patches by Tigran
Aivazian.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/file_table.c      |    1 +
 include/linux/file.h |   14 ++++++++++++++
 include/linux/fs.h   |    2 ++
 3 files changed, 17 insertions(+)

Index: uml-2.6/fs/file_table.c
===================================================================
--- uml-2.6.orig/fs/file_table.c	2007-03-08 10:24:24.000000000 +0200
+++ uml-2.6/fs/file_table.c	2007-03-08 10:24:31.000000000 +0200
@@ -219,6 +219,7 @@
 	*fput_needed = 0;
 	if (likely((atomic_read(&files->count) == 1))) {
 		file = fcheck_files(files, fd);
+		set_f_light(file);
 	} else {
 		rcu_read_lock();
 		file = fcheck_files(files, fd);
Index: uml-2.6/include/linux/file.h
===================================================================
--- uml-2.6.orig/include/linux/file.h	2007-03-08 10:24:24.000000000 +0200
+++ uml-2.6/include/linux/file.h	2007-03-08 10:24:31.000000000 +0200
@@ -6,6 +6,7 @@
 #define __LINUX_FILE_H
 
 #include <asm/atomic.h>
+#include <linux/fs.h>
 #include <linux/posix_types.h>
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
@@ -62,10 +63,23 @@
 extern void FASTCALL(__fput(struct file *));
 extern void FASTCALL(fput(struct file *));
 
+static inline void clear_f_light(struct file *file)
+{
+	file->f_light = 0;
+}
+
+static inline void set_f_light(struct file *file)
+{
+	if (file)
+		file->f_light = 1;
+}
+
 static inline void fput_light(struct file *file, int fput_needed)
 {
 	if (unlikely(fput_needed))
 		fput(file);
+	else
+		clear_f_light(file);
 }
 
 extern struct file * FASTCALL(fget(unsigned int fd));
Index: uml-2.6/include/linux/fs.h
===================================================================
--- uml-2.6.orig/include/linux/fs.h	2007-03-08 10:24:24.000000000 +0200
+++ uml-2.6/include/linux/fs.h	2007-03-08 10:24:31.000000000 +0200
@@ -739,6 +739,8 @@
 	struct list_head	f_ep_links;
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
+	/* This instance is being used without holding a reference. */
+	int			f_light;
 	struct address_space	*f_mapping;
 };
 extern spinlock_t files_lock;
