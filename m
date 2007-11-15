Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbXKOQmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbXKOQmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbXKOQlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:41:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758817AbXKOQla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:41:30 -0500
Date: Thu, 15 Nov 2007 11:41:22 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711151641.lAFGfMgJ024333@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] actual sys_indirect code
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the actual architecture-independent part of the system call
implementation.

 b/include/linux/indirect.h |   13 +++++++++++++
 b/include/linux/syscalls.h |    3 +++
 b/kernel/Makefile          |    2 +-
 b/kernel/indirect.c        |   25 +++++++++++++++++++++++++
 b/include/linux/sched.h    |    4 ++++
 5 files changed, 46 insertions(+), 1 deletion(-)


--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -80,6 +80,7 @@ struct sched_param {
 #include <linux/rcupdate.h>
 #include <linux/futex.h>
 #include <linux/rtmutex.h>
+#include <linux/indirect.h>
 
 #include <linux/time.h>
 #include <linux/param.h>
@@ -1174,6 +1175,9 @@ struct task_struct {
 	int make_it_fail;
 #endif
 	struct prop_local_single dirties;
+
+	/* Additional system call parameters.  */
+	union indirect_params indirect_params;
 };
 
 /*
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 61def7c..614ff36 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -54,6 +54,7 @@ struct compat_stat;
 struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
+struct indirect_registers;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -611,6 +612,8 @@ asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 			    const struct itimerspec __user *utmr);
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
+asmlinkage long sys_indirect(struct indirect_registers __user *userregs,
+			     void __user *userparams, size_t paramslen);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
diff --git a/kernel/Makefile b/kernel/Makefile
index f60afe7..ef82be0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o \
-	    utsname.o notifier.o
+	    utsname.o notifier.o indirect.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff --git a/net/socket.c b/net/socket.c
index 74784df..e3a3a04 100644
--- /dev/null	2007-09-23 16:36:38.465394704 -0700
+++ b/include/linux/indirect.h	2007-11-14 17:53:18.000000000 -0800
@@ -0,0 +1,13 @@
+#ifndef _LINUX_INDIRECT_H
+#define _LINUX_INDIRECT_H
+
+#include <asm/indirect.h>
+
+
+union indirect_params {
+  struct {
+    int flags;
+  } file_flags;
+};
+
+#endif
--- /dev/null	2007-09-23 16:36:38.465394704 -0700
+++ b/kernel/indirect.c	2007-11-14 18:15:17.000000000 -0800
@@ -0,0 +1,25 @@
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
+#include <asm/asm-offsets.h>
+
+
+long sys_indirect(struct indirect_registers __user *userregs,
+		  void __user *userparams, size_t paramslen)
+{
+	struct indirect_registers regs;
+	long result;
+
+	if (copy_from_user(&regs, userregs, sizeof(regs)))
+		return -EFAULT;
+	if (paramslen > sizeof(union indirect_params))
+		return -EINVAL;
+	if (copy_from_user(&current->indirect_params, userparams, paramslen))
+		return -EFAULT;
+
+	result = CALL_INDIRECT(&regs);
+
+	memset(&current->indirect_params, '\0', paramslen);
+
+	return result;
+}
