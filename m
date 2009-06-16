Return-Path: <linux-kernel-owner+w=401wt.eu-S1763870AbZFPUmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763870AbZFPUmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762874AbZFPUkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59590 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760787AbZFPUkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/17] VFS: Implement the AFS system call
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org,
       Jacob Thebault-Spieker <summatusmentis@gmail.com>
Date: Tue, 16 Jun 2009 21:38:56 +0100
Message-ID: <20090616203856.4526.36438.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Thebault-Spieker <summatusmentis@gmail.com>

Implement the AFS system call, supporting just the pioctl() function for now.

Signed-off-by: Jacob Thebault-Spieker <summatusmentis@gmail.com>
---

 arch/x86/ia32/ia32entry.S          |    2 +-
 arch/x86/include/asm/unistd_64.h   |    2 +-
 arch/x86/kernel/syscall_table_32.S |    2 +-
 fs/Makefile                        |    5 ++++-
 fs/afs/Kconfig                     |   12 ++++++++++++
 fs/afs/pioctl.c                    |    1 +
 fs/afs_call.c                      |   33 ++++++++++++++++++++++++++++++++
 fs/afs_compat.c                    |   37 ++++++++++++++++++++++++++++++++++++
 include/linux/afscall.h            |   16 ++++++++++++++++
 include/linux/syscalls.h           |    2 ++
 10 files changed, 108 insertions(+), 4 deletions(-)
 create mode 100644 fs/afs_call.c
 create mode 100644 fs/afs_compat.c
 create mode 100644 include/linux/afscall.h


diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 5caa7bd..43abb72 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -632,7 +632,7 @@ ia32_sys_call_table:
 	.quad quiet_ni_syscall	/* bdflush */
 	.quad sys_sysfs		/* 135 */
 	.quad sys_personality
-	.quad quiet_ni_syscall	/* for afs_syscall */
+	.quad compat_sys_afs	/* for afs_syscall */
 	.quad sys_setfsuid16
 	.quad sys_setfsgid16
 	.quad sys_llseek		/* 140 */
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 495d0fb..5b0a806 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -424,7 +424,7 @@ __SYSCALL(__NR_putpmsg, sys_ni_syscall)
 
 /* reserved for AFS */
 #define __NR_afs_syscall			183
-__SYSCALL(__NR_afs_syscall, sys_ni_syscall)
+__SYSCALL(__NR_afs_syscall, sys_afs)
 
 /* reserved for tux */
 #define __NR_tuxcall				184
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 723f33e..530c5d0 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -136,7 +136,7 @@ ENTRY(sys_call_table)
 	.long sys_bdflush
 	.long sys_sysfs		/* 135 */
 	.long sys_personality
-	.long sys_ni_syscall	/* reserved for afs_syscall */
+	.long sys_afs	/* reserved for afs_syscall */
 	.long sys_setfsuid16
 	.long sys_setfsgid16
 	.long sys_llseek	/* 140 */
diff --git a/fs/Makefile b/fs/Makefile
index d5bf38a..a75d3d9 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -64,7 +64,10 @@ obj-y				+= devpts/
 
 obj-$(CONFIG_PROFILING)		+= dcookies.o
 obj-$(CONFIG_DLM)		+= dlm/
- 
+
+afs-compat-$(CONFIG_COMPAT)	+= afs_compat.o
+obj-$(CONFIG_AFS_CALL)		+= afs_call.o $(afs-compat-y)
+
 # Do not add any filesystems before this line
 obj-$(CONFIG_FSCACHE)		+= fscache/
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
diff --git a/fs/afs/Kconfig b/fs/afs/Kconfig
index 2bd2324..6871ca3 100644
--- a/fs/afs/Kconfig
+++ b/fs/afs/Kconfig
@@ -1,8 +1,15 @@
+config AFS_CALL
+	bool "Enable AFS system call"
+	depends on EXPERIMENTAL
+	help
+	  Enable AFS system call functions, AFS_FS depends on this option.
+
 config AFS_FS
 	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
 	select AF_RXRPC
 	select PIOCTL
+ 	select AFS_CALL
 	help
 	  If you say Y here, you will get an experimental Andrew File System
 	  driver. It currently only supports unsecured read-only AFS access.
@@ -28,3 +35,8 @@ config AFS_FSCACHE
 	help
 	  Say Y here if you want AFS data to be cached locally on disk through
 	  the generic filesystem cache manager
+
+
+
+
+
diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index e266f27..5a76017 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -8,6 +8,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 #include <linux/fs.h>
+#include <linux/afscall.h>
 #include <linux/pioctl.h>
 #include "internal.h"
 
diff --git a/fs/afs_call.c b/fs/afs_call.c
new file mode 100644
index 0000000..5dc28f8
--- /dev/null
+++ b/fs/afs_call.c
@@ -0,0 +1,33 @@
+/* AFS system call multiplexor
+ *
+ * Copyright (C) 2009 David Howells <dhowells@redhat.com>
+ * Copyright (C) 2008 Jacob Thebault-Spieker <summatusmentis@gmail.com>
+ *
+ * Modified by David Howells <dhowells@redhat.com>
+ *
+ * This program is free software; you can redistribute it a/or
+ * modify it uer the terms of the GNU General Public License
+ * as published by the Free Software Fouation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/syscalls.h>
+#include <linux/afscall.h>
+#include <linux/pioctl.h>
+
+/*
+ * The AFS system call entry point
+ */
+SYSCALL_DEFINE5(afs, int, option,
+		unsigned long, arg2, unsigned long, arg3,
+		unsigned long, arg4, unsigned long, arg5)
+{
+	switch (option) {
+	case AFSCALL_PIOCTL:
+		return sys_pioctl((const char __user *) arg2, (int) arg3,
+				  (struct ViceIoctl __user *) arg4, (int) arg5);
+
+	default:
+		printk(KERN_NOTICE "Unknown AFS call %x invoked\n", option);
+		return -ENOSYS;
+	}
+}
diff --git a/fs/afs_compat.c b/fs/afs_compat.c
new file mode 100644
index 0000000..0add585
--- /dev/null
+++ b/fs/afs_compat.c
@@ -0,0 +1,37 @@
+/* AFS syscall multiplexor, compatibility
+ *
+ * Copyright (C) 2009 David Howells <dhowells@redhat.com>
+ * Copyright (C) 2008 Jacob Thebault-Spieker <summatusmentis@gmail.com>
+ *
+ * Modified by David Howells <dhowells@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/syscalls.h>
+#include <linux/afscall.h>
+#include <linux/pioctl.h>
+#include <linux/compat.h>
+
+/*
+ * The AFS system call 32-bit compatibility entry point
+ */
+asmlinkage long compat_sys_afs(int option,
+			       unsigned long arg2, unsigned long arg3,
+			       unsigned long arg4, unsigned long arg5)
+{
+	switch (option) {
+	case AFSCALL_PIOCTL:
+		return compat_sys_pioctl(
+			(const char __user *) compat_ptr(arg2),
+			(int) arg3,
+			(struct compat_ViceIoctl __user *) compat_ptr(arg4),
+			(int) arg5);
+
+	default:
+		printk(KERN_NOTICE "Unknown AFS call %x invoked\n", option);
+		return -ENOSYS;
+	}
+}
diff --git a/include/linux/afscall.h b/include/linux/afscall.h
new file mode 100644
index 0000000..40cbfa5
--- /dev/null
+++ b/include/linux/afscall.h
@@ -0,0 +1,16 @@
+/* AFS system call multiplexor
+ *
+ * Copyright (C) 2008 Jacob Thebault-Spieker <summatusmentis@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_AFSCALL_H
+#define _LINUX_AFSCALL_H
+
+#define AFSCALL_PIOCTL 0x14
+
+#endif /* _LINUX_AFSCALL_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index ab6f49f..0a8a194 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -764,5 +764,7 @@ asmlinkage long sys_perf_counter_open(
 
 asmlinkage long sys_pioctl(const char __user *filename, int cmd,
 			   struct ViceIoctl __user *args, int nofollow);
+asmlinkage long sys_afs(int option, unsigned long arg2, unsigned long arg3,
+			unsigned long arg4, unsigned long arg5);
 
 #endif

