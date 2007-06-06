Return-Path: <linux-kernel-owner+w=401wt.eu-S936594AbXFFWbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936594AbXFFWbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936290AbXFFWan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:30:43 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1333 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936051AbXFFWaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:30:39 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 06 Jun 2007 15:30:31 -0700
Subject: [patch 4/8] fdmap v2 - add a new O_NONSEQFD flag to sys_open
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.4625.1181169038.4>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new O_NONSEQFD flag for the sys_open()
system call. Using such flag, the caller can ask the kernel to allocate
the file descriptor inside the non-sequential area.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.mod/fs/open.c
===================================================================
--- linux-2.6.mod.orig/fs/open.c	2007-06-06 12:48:03.000000000 -0700
+++ linux-2.6.mod/fs/open.c	2007-06-06 12:48:37.000000000 -0700
@@ -978,6 +978,23 @@
 	return FDMAP_NONSEQ_BASE + (rndb & ((1U << FDMAP_RANDOM_BITS) - 1));
 }
 
+/**
+ * allocate_fd - Allocates a new file descriptor
+ *
+ * @flags:  [in] Flags to control the allocation type and the new descriptor
+ *               characteristics
+ *
+ * Returns the newly allocated file descriptor, or a negative value in
+ * case of error.
+ */
+int allocate_fd(unsigned long flags)
+{
+	if (flags & O_NONSEQFD)
+		return alloc_nonseq_fd(current->files, flags);
+	else
+		return  get_unused_fd();
+}
+
 /*
  * Install a file pointer in the fd array.
  *
@@ -1011,7 +1028,7 @@
 	int fd = PTR_ERR(tmp);
 
 	if (!IS_ERR(tmp)) {
-		fd = get_unused_fd();
+		fd = allocate_fd((unsigned int) flags);
 		if (fd >= 0) {
 			struct file *f = do_filp_open(dfd, tmp, flags, mode);
 			if (IS_ERR(f)) {
Index: linux-2.6.mod/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.mod.orig/include/asm-generic/fcntl.h	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/include/asm-generic/fcntl.h	2007-06-06 12:48:37.000000000 -0700
@@ -48,6 +48,9 @@
 #ifndef O_NOATIME
 #define O_NOATIME	01000000
 #endif
+#ifndef O_NONSEQFD
+#define O_NONSEQFD	02000000
+#endif
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
Index: linux-2.6.mod/include/linux/file.h
===================================================================
--- linux-2.6.mod.orig/include/linux/file.h	2007-06-06 12:48:28.000000000 -0700
+++ linux-2.6.mod/include/linux/file.h	2007-06-06 12:48:37.000000000 -0700
@@ -85,6 +85,7 @@
 extern int __alloc_nonseq_fd(struct files_struct *files, unsigned long flags);
 extern int alloc_nonseq_fd(struct files_struct *files, unsigned long flags);
 extern unsigned int gen_nonseqfd_base(void);
+extern int allocate_fd(unsigned long flags);
 
 /**
  * nonseq_files_fdmap - Must be called with @files->file_lock held. It forces

