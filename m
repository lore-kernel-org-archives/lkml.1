Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbXKUHbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbXKUHbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 02:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbXKUH32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 02:29:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758628AbXKUH30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:29:26 -0500
Date: Wed, 21 Nov 2007 02:28:50 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711210728.lAL7Sob8015043@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv5 1/5] actual sys_indirect code
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the actual architecture-independent part of the system call
implementation.

 include/linux/indirect.h |   17 +++++++++++++++++
 include/linux/sched.h    |    4 ++++
 include/linux/syscalls.h |    4 ++++
 kernel/Makefile          |    3 +++
 kernel/indirect.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 68 insertions(+)


diff -u linux/include/linux/indirect.h linux/include/linux/indirect.h
--- linux/include/linux/indirect.h
+++ linux/include/linux/indirect.h
@@ -0,0 +1,17 @@
+#ifndef _LINUX_INDIRECT_H
+#define _LINUX_INDIRECT_H
+
+#include <asm/indirect.h>
+
+
+/* IMPORTANT:
+   All the elements of this union must be neutral to the word size
+   and must not require reworking when used in compat syscalls.  Used
+   fixed-size types or types which are known to not vary in size across
+   architectures.  */
+union indirect_params {
+};
+
+#define INDIRECT_PARAM(set, name) current->indirect_params.set.name
+
+#endif
diff -u linux/kernel/Makefile linux/kernel/Makefile
--- linux/kernel/Makefile
+++ linux/kernel/Makefile
@@ -57,6 +57,7 @@
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
+obj-$(CONFIG_ARCH_HAS_INDIRECT_SYSCALLS) += indirect.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
@@ -67,6 +68,8 @@
 CFLAGS_sched.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
+CFLAGS_indirect.o = -Wno-undef
+
 $(obj)/configs.o: $(obj)/config_data.h
 
 # config_data.h contains the same information as ikconfig.h but gzipped.
diff -u linux/kernel/indirect.c linux/kernel/indirect.c
--- linux/kernel/indirect.c
+++ linux/kernel/indirect.c
@@ -0,0 +1,40 @@
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
+#define INDSYSCALL(name) __NR_##name
+#include <linux/indirect.h>
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (paramslen > sizeof(union indirect_params))
+		return -EINVAL;
+
+	result = -EFAULT;
+	if (!copy_from_user(&current->indirect_params, userparams, paramslen))
+		result = call_indirect(&regs);
+
+	memset(&current->indirect_params, '\0', paramslen);
+
+	return result;
+}
diff -u linux/include/linux/syscalls.h linux/include/linux/syscalls.h
--- linux/include/linux/syscalls.h
+++ linux/include/linux/syscalls.h
@@ -54,6 +54,7 @@
 struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
+struct indirect_registers;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -611,6 +612,9 @@
 			    const struct itimerspec __user *utmr);
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
+asmlinkage long sys_indirect(struct indirect_registers __user *userregs,
+			     void __user *userparams, size_t paramslen,
+			     int flags);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
--- linux/include/linux/sched.h
+++ linux/include/linux/sched.h
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
