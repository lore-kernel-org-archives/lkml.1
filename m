Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbXKTGzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbXKTGzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759276AbXKTGxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:53:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759240AbXKTGxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:53:44 -0500
Date: Tue, 20 Nov 2007 01:53:14 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711200653.lAK6rEVB025878@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv4 1/6] actual sys_indirect code
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the actual architecture-independent part of the system call
implementation.

 include/linux/indirect.h |    6 ++++++
 include/linux/sched.h    |    4 ++++
 include/linux/syscalls.h |    4 ++++
 kernel/Makefile          |    2 +-
 kernel/indirect.c        |   36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 51 insertions(+), 1 deletion(-)

--- /dev/null
+++ include/linux/indirect.h
@@ -0,0 +1,6 @@
+#ifndef _LINUX_INDIRECT_H
+#define _LINUX_INDIRECT_H
+
+#include <asm/indirect.h>
+
+#endif
--- include/linux/sched.h
+++ include/linux/sched.h
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
--- include/linux/syscalls.h
+++ include/linux/syscalls.h
@@ -54,6 +54,7 @@ struct compat_stat;
 struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
+struct indirect_registers;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -611,6 +612,9 @@ asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 			    const struct itimerspec __user *utmr);
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
+asmlinkage long sys_indirect(struct indirect_registers __user *userregs,
+			     void __user *userparams, size_t paramslen,
+			     int flags);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
--- /dev/null
+++ kernel/indirect.c
@@ -0,0 +1,36 @@
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
+#include <asm/asm-offsets.h>
+
+
+asmlinkage long sys_indirect(struct indirect_registers __user *userregs,
+			     void __user *userparams, size_t paramslen,
+			     int flags)
+{
+	struct indirect_registers regs;
+	long result;
+
+	if (unlikely(flags != 0))
+		return -EINVAL;
+
+	if (copy_from_user(&regs, userregs, sizeof(regs)))
+		return -EFAULT;
+
+	switch (INDIRECT_SYSCALL (&regs))
+	{
+	default:
+		return -EINVAL;
+	}
+
+	if (paramslen > sizeof(union indirect_params))
+		return -EINVAL;
+
+	result = -EFAULT;
+	if (!copy_from_user(&current->indirect_params, userparams, paramslen))
+		result = CALL_INDIRECT(&regs);
+
+	memset(&current->indirect_params, '\0', paramslen);
+
+	return result;
+}
--- kernel/Makefile
+++ kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o \
-	    utsname.o notifier.o
+	    utsname.o notifier.o indirect.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
