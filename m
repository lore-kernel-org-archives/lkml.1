Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYJQXMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYJQXMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbYJQXLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:11:49 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:4016 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588AbYJQXLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:11:47 -0400
From: Andrey Mirkin <major@openvz.org>
To: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrey Mirkin <major@openvz.org>
Subject: [PATCH 02/10] Make checkpoint/restart functionality modular
Date: Sat, 18 Oct 2008 03:11:30 +0400
Message-Id: <1224285098-573-3-git-send-email-major@openvz.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1224285098-573-2-git-send-email-major@openvz.org>
References: <1224285098-573-1-git-send-email-major@openvz.org>
 <1224285098-573-2-git-send-email-major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A config option CONFIG_CHECKPOINT is introduced.
New structure cpt_operations is introduced to store pointers to
checkpoint/restart functions from module.

Signed-off-by: Andrey Mirkin <major@openvz.org>
---
 checkpoint/Kconfig      |    7 ++++++
 checkpoint/Makefile     |    4 +++
 checkpoint/checkpoint.h |   19 ++++++++++++++++++
 checkpoint/sys.c        |   48 +++++++++++++++++++++++++++++++++++++++++++++++
 checkpoint/sys_core.c   |   29 ++++++++++++++++++++++++++-
 init/Kconfig            |    2 +
 6 files changed, 107 insertions(+), 2 deletions(-)
 create mode 100644 checkpoint/Kconfig
 create mode 100644 checkpoint/checkpoint.h
 create mode 100644 checkpoint/sys.c

diff --git a/checkpoint/Kconfig b/checkpoint/Kconfig
new file mode 100644
index 0000000..b9bc72d
--- /dev/null
+++ b/checkpoint/Kconfig
@@ -0,0 +1,7 @@
+config CHECKPOINT
+	tristate "Checkpoint & restart for containers"
+	depends on EXPERIMENTAL
+	default n
+	help
+	  This option adds module "cptrst", which allow to save a running
+	  container to a file and restart it later using this image file.
diff --git a/checkpoint/Makefile b/checkpoint/Makefile
index 2276fb1..bfe75d5 100644
--- a/checkpoint/Makefile
+++ b/checkpoint/Makefile
@@ -1 +1,5 @@
 obj-y += sys_core.o
+
+obj-$(CONFIG_CHECKPOINT) += cptrst.o
+
+cptrst-objs := sys.o
diff --git a/checkpoint/checkpoint.h b/checkpoint/checkpoint.h
new file mode 100644
index 0000000..381a9bf
--- /dev/null
+++ b/checkpoint/checkpoint.h
@@ -0,0 +1,19 @@
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
+struct cpt_operations
+{
+	struct module * owner;
+	int (*checkpoint)(pid_t pid, int fd, unsigned long flags);
+	int (*restart)(int ctid, int fd, unsigned long flags);
+};
+extern struct cpt_operations cpt_ops;
diff --git a/checkpoint/sys.c b/checkpoint/sys.c
new file mode 100644
index 0000000..010e4eb
--- /dev/null
+++ b/checkpoint/sys.c
@@ -0,0 +1,48 @@
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
+#include <linux/notifier.h>
+#include <linux/module.h>
+
+#include "checkpoint.h"
+
+MODULE_LICENSE("GPL");
+
+static int checkpoint(pid_t pid, int fd, unsigned long flags)
+{
+	return -ENOSYS; 
+}
+
+static int restart(int ctid, int fd, unsigned long flags)
+{
+	return -ENOSYS; 
+}
+
+static int __init init_cptrst(void)
+{
+	cpt_ops.owner = THIS_MODULE;
+	cpt_ops.checkpoint = checkpoint;
+	cpt_ops.restart = restart;
+	return 0;
+}
+module_init(init_cptrst);
+
+static void __exit exit_cptrst(void)
+{
+	cpt_ops.checkpoint = NULL;
+	cpt_ops.restart = NULL;
+	cpt_ops.owner = NULL;
+}
+module_exit(exit_cptrst);
diff --git a/checkpoint/sys_core.c b/checkpoint/sys_core.c
index 1a97fb6..528aaec 100644
--- a/checkpoint/sys_core.c
+++ b/checkpoint/sys_core.c
@@ -13,6 +13,13 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+
+#include "checkpoint.h"
+
+struct cpt_operations cpt_ops = { NULL, NULL, NULL };
+EXPORT_SYMBOL(cpt_ops);
 
 /**
  * sys_checkpoint - checkpoint a container from outside
@@ -23,7 +30,16 @@
  */
 asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
 {
-	return -ENOSYS;
+	int ret;
+
+	ret = -ENOSYS;
+
+	if (try_module_get(cpt_ops.owner)) {
+		if (cpt_ops.checkpoint)
+			ret = cpt_ops.checkpoint(pid, fd, flags);
+		module_put(cpt_ops.owner);
+	}
+	return ret;
 }
 
 /**
@@ -34,5 +50,14 @@ asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
  */
 asmlinkage long sys_restart(int ctid, int fd, unsigned long flags)
 {
-	return -ENOSYS;
+	int ret;
+
+	ret = -ENOSYS;
+
+	if (try_module_get(cpt_ops.owner)) {
+		if (cpt_ops.restart)
+			ret = cpt_ops.restart(ctid, fd, flags);
+		module_put(cpt_ops.owner);
+	}
+	return ret;
 }
diff --git a/init/Kconfig b/init/Kconfig
index 4bd4b0c..b10f3cf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -344,6 +344,8 @@ config CGROUP_FREEZER
           Provides a way to freeze and unfreeze all tasks in a
 	  cgroup
 
+source "checkpoint/Kconfig"
+	  
 config FAIR_GROUP_SCHED
 	bool "Group scheduling for SCHED_OTHER"
 	depends on GROUP_SCHED
-- 
1.5.6

