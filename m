Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbYHTT3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbYHTT3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYHTT03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:26:29 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60220 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586AbYHTT02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:26:28 -0400
Subject: [RFC v2][PATCH 5/9] Create trivial sys_checkpoint and sys_restore system calls
To: arnd@arndb.de
Cc: orenl@cs.columbia.edu, jeremy@goop.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 Aug 2008 12:26:03 -0700
References: <20080820192557.98788FAB@nimitz>
In-Reply-To: <20080820192557.98788FAB@nimitz>
Message-Id: <20080820192603.AE9E8048@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Oren Laadan <orenl@cs.columbia.edu>

Create trivial sys_checkpoint and sys_restore system calls. They will
enable to checkpoint and restart an entire container, to and from a
checkpoint image file.

First create a template for both syscalls: they take a file descriptor
(for the image file) and flags as arguments. For sys_checkpoint the
first argument identifies the target container; for sys_restart it will
identify the checkpoint image.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---

 oren-cr.git-dave/arch/x86/kernel/syscall_table_32.S |    2 ++
 oren-cr.git-dave/include/asm-x86/unistd_32.h        |    2 ++
 oren-cr.git-dave/include/linux/syscalls.h           |    3 +++
 3 files changed, 7 insertions(+)

diff -puN arch/x86/kernel/syscall_table_32.S~0006-Create-trivial-sys_checkpoint-and-sys_restore-system arch/x86/kernel/syscall_table_32.S
--- oren-cr.git/arch/x86/kernel/syscall_table_32.S~0006-Create-trivial-sys_checkpoint-and-sys_restore-system	2008-08-20 12:12:50.000000000 -0700
+++ oren-cr.git-dave/arch/x86/kernel/syscall_table_32.S	2008-08-20 12:12:50.000000000 -0700
@@ -332,3 +332,5 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+ 	.long sys_checkpoint
+ 	.long sys_restart
diff -puN include/asm-x86/unistd_32.h~0006-Create-trivial-sys_checkpoint-and-sys_restore-system include/asm-x86/unistd_32.h
--- oren-cr.git/include/asm-x86/unistd_32.h~0006-Create-trivial-sys_checkpoint-and-sys_restore-system	2008-08-20 12:12:50.000000000 -0700
+++ oren-cr.git-dave/include/asm-x86/unistd_32.h	2008-08-20 12:12:50.000000000 -0700
@@ -338,6 +338,8 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_checkpoint		333
+#define __NR_restart		334
 
 #ifdef __KERNEL__
 
diff -puN include/linux/syscalls.h~0006-Create-trivial-sys_checkpoint-and-sys_restore-system include/linux/syscalls.h
--- oren-cr.git/include/linux/syscalls.h~0006-Create-trivial-sys_checkpoint-and-sys_restore-system	2008-08-20 12:12:50.000000000 -0700
+++ oren-cr.git-dave/include/linux/syscalls.h	2008-08-20 12:12:50.000000000 -0700
@@ -625,4 +625,7 @@ asmlinkage long sys_fallocate(int fd, in
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags);
+asmlinkage long sys_restart(int crid, int fd, unsigned long flags);
+
 #endif
_
