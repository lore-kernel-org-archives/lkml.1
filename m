Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYEEJWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYEEJWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYEEJWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:22:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbYEEJW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:22:29 -0400
Date: Mon, 5 May 2008 05:21:57 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805050921.m459LvhU007242@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] file descriptor leak in sys_pipe
Cc: akpm@linux-foundation.org, dm.n9107@gmail.com,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DM <dm.n9107@gmail.com> wrote:
> I realize this code is old, but wouldn't file descriptors leak if
> copy_to_user fails?

I think you're right.  The following should patch it for the remaining
C implementations which need that kind of patch.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/arch/cris/kernel/sys_cris.c b/arch/cris/kernel/sys_cris.c
index 8b99841..d124066 100644
--- a/arch/cris/kernel/sys_cris.c
+++ b/arch/cris/kernel/sys_cris.c
@@ -40,8 +40,11 @@ asmlinkage int sys_pipe(unsigned long __user * fildes)
         error = do_pipe(fd);
         unlock_kernel();
         if (!error) {
-                if (copy_to_user(fildes, fd, 2*sizeof(int)))
+                if (copy_to_user(fildes, fd, 2*sizeof(int))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
                         error = -EFAULT;
+		}
         }
         return error;
 }
diff --git a/arch/m32r/kernel/sys_m32r.c b/arch/m32r/kernel/sys_m32r.c
index 6d7a80f..319c797 100644
--- a/arch/m32r/kernel/sys_m32r.c
+++ b/arch/m32r/kernel/sys_m32r.c
@@ -90,8 +90,11 @@ sys_pipe(unsigned long r0, unsigned long r1, unsigned long r2,
 
 	error = do_pipe(fd);
 	if (!error) {
-		if (copy_to_user((void __user *)r0, fd, 2*sizeof(int)))
+		if (copy_to_user((void __user *)r0, fd, 2*sizeof(int))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
 			error = -EFAULT;
+		}
 	}
 	return error;
 }
diff --git a/fs/pipe.c b/fs/pipe.c
index 3499f9f..ec228bc 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -17,6 +17,7 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/audit.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
@@ -1086,8 +1087,11 @@ asmlinkage long __weak sys_pipe(int __user *fildes)
 
 	error = do_pipe(fd);
 	if (!error) {
-		if (copy_to_user(fildes, fd, sizeof(fd)))
+		if (copy_to_user(fildes, fd, sizeof(fd))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
 			error = -EFAULT;
+		}
 	}
 	return error;
 }
