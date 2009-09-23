Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbZIWPDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbZIWPDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZIWPDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:03:50 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:34303 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZIWPDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:03:50 -0400
Date: Wed, 23 Sep 2009 17:03:27 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fs: change sys_truncate/sys_ftruncate length parameter type
Message-ID: <20090923150326.GB23595@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

For both system calls user space passes a signed long length parameter,
while the kernel side takes an unsigned long parameter and converts it
later to signed long again.
As far as I can see there is no point in doing the unsigned -> signed
conversion.
But it has led to bugs in compat wrappers see e.g.
dd90bbd5 "powerpc: Add compat_sys_truncate".
The s390 compat wrappers for these two system calls are broken as well
since they also perform zero extension instead of sign extension for
the length parameter.

In addition if hpa comes up with an automated way of generating
compat wrappers it would generate wrong ones for these two cases.

So change the length parameter from unsigned long to long.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/open.c                |    7 +++----
 include/linux/syscalls.h |    5 ++---
 2 files changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c
+++ linux-2.6/fs/open.c
@@ -290,10 +290,9 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE2(truncate, const char __user *, path, unsigned long, length)
+SYSCALL_DEFINE2(truncate, const char __user *, path, long, length)
 {
-	/* on 32-bit boxen it will cut the range 2^31--2^32-1 off */
-	return do_sys_truncate(path, (long)length);
+	return do_sys_truncate(path, length);
 }
 
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
@@ -342,7 +341,7 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE2(ftruncate, unsigned int, fd, unsigned long, length)
+SYSCALL_DEFINE2(ftruncate, unsigned int, fd, long, length)
 {
 	long ret = do_sys_ftruncate(fd, length, 1);
 	/* avoid REGPARM breakage on x86: */
Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h
+++ linux-2.6/include/linux/syscalls.h
@@ -460,9 +460,8 @@ asmlinkage long sys_mount(char __user *d
 				void __user *data);
 asmlinkage long sys_umount(char __user *name, int flags);
 asmlinkage long sys_oldumount(char __user *name);
-asmlinkage long sys_truncate(const char __user *path,
-				unsigned long length);
-asmlinkage long sys_ftruncate(unsigned int fd, unsigned long length);
+asmlinkage long sys_truncate(const char __user *path, long length);
+asmlinkage long sys_ftruncate(unsigned int fd, long length);
 asmlinkage long sys_stat(char __user *filename,
 			struct __old_kernel_stat __user *statbuf);
 asmlinkage long sys_statfs(const char __user * path,
