Return-Path: <linux-kernel-owner+w=401wt.eu-S936529AbXFFWbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936529AbXFFWbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936223AbXFFWam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:30:42 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1327 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935943AbXFFWaj (ORCPT
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
Subject: [patch 3/8] fdmap v2 - implement sys_nonseqfd
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.4625.1181169037.3>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement a new syscall sys_nonseqfd():

int nonseqfd(int fd, int flags);

The sys_nonseqfd() syscall can be used to map an existing file
descriptor inside the non-sequential fd area.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.mod/fs/fcntl.c
===================================================================
--- linux-2.6.mod.orig/fs/fcntl.c	2007-06-06 12:48:03.000000000 -0700
+++ linux-2.6.mod/fs/fcntl.c	2007-06-06 12:48:35.000000000 -0700
@@ -81,6 +81,25 @@
 	return fd;
 }
 
+asmlinkage long sys_nonseqfd(unsigned int fd, unsigned int flags)
+{
+	struct files_struct *files = current->files;
+	int nfd = -EBADF;
+	struct file *file;
+
+	spin_lock(&files->file_lock);
+	if (!(file = fcheck(fd)))
+		goto out_unlock;
+	nfd = __alloc_nonseq_fd(files, flags);
+	if (likely(nfd >= 0))
+		get_file(file);
+out_unlock:
+	spin_unlock(&files->file_lock);
+	if (likely(nfd >= 0))
+		fd_install(nfd, file);
+	return nfd;
+}
+
 static int dupfd(struct file *file, unsigned int start)
 {
 	struct files_struct *files = current->files;
Index: linux-2.6.mod/include/linux/syscalls.h
===================================================================
--- linux-2.6.mod.orig/include/linux/syscalls.h	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/include/linux/syscalls.h	2007-06-06 12:48:35.000000000 -0700
@@ -302,6 +302,7 @@
 asmlinkage long sys_fcntl64(unsigned int fd,
 				unsigned int cmd, unsigned long arg);
 #endif
+asmlinkage long sys_nonseqfd(unsigned int fd, unsigned int flags);
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
 asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int on);

