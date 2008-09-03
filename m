Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbYICKz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbYICKz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYICKzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:55:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:29485 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYICKzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:55:09 -0400
From: Andrey Mirkin <major@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Andrey Mirkin <major@openvz.org>
Subject: [PATCH 1/9] Introduce trivial sys_checkpoint and sys_restore system calls
Date: Wed,  3 Sep 2008 14:57:48 +0400
Message-Id: <1220439476-16465-2-git-send-email-major@openvz.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1220439476-16465-1-git-send-email-major@openvz.org>
References: <1220439476-16465-1-git-send-email-major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now they just return -ENOSYS. Later they will provide functionality
to checkpoint and restart a container.

Both syscalls take as arguments a file descriptor and flags.
Also sys_checkpoint take as the first argument a PID of container's init
(later it will be container ID); sys_restart takes as the first argument
a container ID (right now it will not be used).

Signed-off-by: Andrey Mirkin <major@openvz.org>
---
 Makefile                           |    2 +-
 arch/x86/kernel/syscall_table_32.S |    2 +
 cpt/Makefile                       |    1 +
 cpt/sys_core.c                     |   38 ++++++++++++++++++++++++++++++++++++
 include/asm-x86/unistd_32.h        |    2 +
 5 files changed, 44 insertions(+), 1 deletions(-)
 create mode 100644 cpt/Makefile
 create mode 100644 cpt/sys_core.c

diff --git a/Makefile b/Makefile
index ea413fa..1dee5c0 100644
--- a/Makefile
+++ b/Makefile
@@ -619,7 +619,7 @@ export mod_strip_cmd
 
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ cpt/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index fd9d4f4..4a0d7fb 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -333,3 +333,5 @@ ENTRY(sys_call_table)
 	.long sys_pipe2
 	.long sys_inotify_init1
 	.long sys_hijack
+	.long sys_checkpoint
+	.long sys_restart		/* 335 */
diff --git a/cpt/Makefile b/cpt/Makefile
new file mode 100644
index 0000000..2276fb1
--- /dev/null
+++ b/cpt/Makefile
@@ -0,0 +1 @@
+obj-y += sys_core.o
diff --git a/cpt/sys_core.c b/cpt/sys_core.c
new file mode 100644
index 0000000..1a97fb6
--- /dev/null
+++ b/cpt/sys_core.c
@@ -0,0 +1,38 @@
+/*
+ *  Copyright (C) 2008 Parallels, Inc.
+ *
+ *  Author: Andrey Mirkin <major@openvz.org>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License as
+ *  published by the Free Software Foundation, version 2 of the
+ *  License.
+ *
+ */
+
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+
+/**
+ * sys_checkpoint - checkpoint a container from outside
+ * @pid: pid of the container init(1) process
+ * TODO: should switch to container id later
+ * @fd: file to which save the checkpoint image
+ * @flags: checkpoint operation flags
+ */
+asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
+{
+	return -ENOSYS;
+}
+
+/**
+ * sys_restart - restart a container
+ * @ctid: container id which should be used to restart a container
+ * @fd: file from which read the checkpoint image
+ * @flags: restart operation flags
+ */
+asmlinkage long sys_restart(int ctid, int fd, unsigned long flags)
+{
+	return -ENOSYS;
+}
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 70280da..1a09604 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -339,6 +339,8 @@
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
 #define __NR_hijack		333
+#define __NR_checkpoint		334
+#define __NR_restart		335
 
 #ifdef __KERNEL__
 
-- 
1.5.6

