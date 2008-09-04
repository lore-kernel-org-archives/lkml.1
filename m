Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbYIDIDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbYIDIDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbYIDICm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:02:42 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:58973 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbYIDICk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:02:40 -0400
Date: Thu, 4 Sep 2008 04:02:02 -0400 (EDT)
From: Oren Laadan <orenl@cs.columbia.edu>
X-X-Sender: orenl@takamine.ncl.cs.columbia.edu
To: dave@linux.vnet.ibm.com
cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: [RFC v3][PATCH 1/9] Create syscalls: sys_checkpoint, sys_restart
In-Reply-To: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
Message-ID: <Pine.LNX.4.64.0809040401320.5982@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Create trivial sys_checkpoint and sys_restore system calls. They will
enable to checkpoint and restart an entire container, to and from a
checkpoint image file descriptor.

The syscalls take a file descriptor (for the image file) and flags as
arguments. For sys_checkpoint the first argument identifies the target
container; for sys_restart it will identify the checkpoint image.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
  arch/x86/kernel/syscall_table_32.S |    2 ++
  checkpoint/Kconfig                 |   11 +++++++++++
  checkpoint/Makefile                |    5 +++++
  checkpoint/sys.c                   |   35 +++++++++++++++++++++++++++++++++++
  include/asm-x86/unistd_32.h        |    2 ++
  include/linux/syscalls.h           |    2 ++
  init/Kconfig                       |    2 ++
  kernel/sys_ni.c                    |    4 ++++
  8 files changed, 63 insertions(+), 0 deletions(-)
  create mode 100644 checkpoint/Kconfig
  create mode 100644 checkpoint/Makefile
  create mode 100644 checkpoint/sys.c

diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index d44395f..5543136 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,5 @@ ENTRY(sys_call_table)
  	.long sys_dup3			/* 330 */
  	.long sys_pipe2
  	.long sys_inotify_init1
+	.long sys_checkpoint
+	.long sys_restart
diff --git a/checkpoint/Kconfig b/checkpoint/Kconfig
new file mode 100644
index 0000000..a9f22ef
--- /dev/null
+++ b/checkpoint/Kconfig
@@ -0,0 +1,11 @@
+config CHECKPOINT_RESTART
+	prompt "Enable checkpoint/restart (EXPERIMENTAL)"
+	def_bool y
+	depends on X86_32 && EXPERIMENTAL
+	help
+	  Application checkpoint/restart is the ability to save the
+	  state of a running application so that it can later resume
+	  its execution from the time at which it was checkpointed.
+
+	  Turning this option on will enable checkpoint and restart
+	  functionality in the kernel.
diff --git a/checkpoint/Makefile b/checkpoint/Makefile
new file mode 100644
index 0000000..07d018b
--- /dev/null
+++ b/checkpoint/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for linux checkpoint/restart.
+#
+
+obj-$(CONFIG_CHECKPOINT_RESTART) += sys.o
diff --git a/checkpoint/sys.c b/checkpoint/sys.c
new file mode 100644
index 0000000..b9018a4
--- /dev/null
+++ b/checkpoint/sys.c
@@ -0,0 +1,35 @@
+/*
+ *  Generic container checkpoint-restart
+ *
+ *  Copyright (C) 2008 Oren Laadan
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License.  See the file COPYING in the main directory of the Linux
+ *  distribution for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+
+/**
+ * sys_checkpoint - checkpoint a container
+ * @pid: pid of the container init(1) process
+ * @fd: file to which dump the checkpoint image
+ * @flags: checkpoint operation flags
+ */
+asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
+{
+	pr_debug("sys_checkpoint not implemented yet\n");
+	return -ENOSYS;
+}
+/**
+ * sys_restart - restart a container
+ * @crid: checkpoint image identifier
+ * @fd: file from which read the checkpoint image
+ * @flags: restart operation flags
+ */
+asmlinkage long sys_restart(int crid, int fd, unsigned long flags)
+{
+	pr_debug("sys_restart not implemented yet\n");
+	return -ENOSYS;
+}
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index d739467..88bdec4 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -338,6 +338,8 @@
  #define __NR_dup3		330
  #define __NR_pipe2		331
  #define __NR_inotify_init1	332
+#define __NR_checkpoint		333
+#define __NR_restart		334

  #ifdef __KERNEL__

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d6ff145..edc218b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -622,6 +622,8 @@ asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
  asmlinkage long sys_eventfd(unsigned int count);
  asmlinkage long sys_eventfd2(unsigned int count, int flags);
  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
+asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags);
+asmlinkage long sys_restart(int crid, int fd, unsigned long flags);

  int kernel_execve(const char *filename, char *const argv[], char *const envp[]);

diff --git a/init/Kconfig b/init/Kconfig
index c11da38..fd5f7bf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -779,6 +779,8 @@ config MARKERS

  source "arch/Kconfig"

+source "checkpoint/Kconfig"
+
  config PROC_PAGE_MONITOR
   	default y
  	depends on PROC_FS && MMU
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 08d6e1b..ca95c25 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -168,3 +168,7 @@ cond_syscall(compat_sys_timerfd_settime);
  cond_syscall(compat_sys_timerfd_gettime);
  cond_syscall(sys_eventfd);
  cond_syscall(sys_eventfd2);
+
+/* checkpoint/restart */
+cond_syscall(sys_checkpoint);
+cond_syscall(sys_restart);
-- 
1.5.4.3

