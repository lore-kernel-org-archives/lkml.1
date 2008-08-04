Return-Path: <linux-kernel-owner+w=401wt.eu-S1764223AbYHDVCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764223AbYHDVCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbYHDVBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:01:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbYHDVBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:01:06 -0400
From: Eric Paris <eparis@redhat.com>
To: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>
Subject: [RFC 4/5] [TALPA] Exclude threads from decision making
Date: Mon,  4 Aug 2008 17:00:39 -0400
Message-Id: <1217883640-29121-4-git-send-email-eparis@redhat.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1217883640-29121-3-git-send-email-eparis@redhat.com>
References: <1217883640-29121-1-git-send-email-eparis@redhat.com>
 <1217883640-29121-2-git-send-email-eparis@redhat.com>
 <1217883640-29121-3-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it is necessary for certain processes to bypass the interception
by Talpa.  For example that may be a purely userspace on-demand scanner which wouldn't
work if unable to access malicious files.

This is implemented as a process flag in the task_struct.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 Documentation/talpa/tecat.c           |   50 +++++++++++++++++++++++++
 Documentation/talpa/thread_exclude    |    6 +++
 include/linux/sched.h                 |    1 +
 security/talpa/Kconfig                |   18 +++++++++
 security/talpa/Makefile               |    2 +
 security/talpa/talpa_interceptor.c    |    5 ++
 security/talpa/talpa_thread_exclude.c |   66 +++++++++++++++++++++++++++++++++
 7 files changed, 148 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/talpa/tecat.c
 create mode 100644 Documentation/talpa/thread_exclude
 create mode 100644 security/talpa/talpa_thread_exclude.c

diff --git a/Documentation/talpa/tecat.c b/Documentation/talpa/tecat.c
new file mode 100644
index 0000000..8c66d73
--- /dev/null
+++ b/Documentation/talpa/tecat.c
@@ -0,0 +1,50 @@
+#include <unistd.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+
+int main(int argc, char *argv[])
+{
+	int talpa;
+	int fd;
+	ssize_t size;
+	char buffer[4096];
+	int args = argc - 1;
+
+	/* Register as an excluded client. */
+	talpa = open("/security/talpa/exclude/talpa-exclude", O_WRONLY);
+	if (!talpa) {
+		fprintf(stderr, "Cannot connect to Talpa - errno %d!\n", errno);
+		return 1;
+	}
+
+	/* Signal Talpa that we want to be excluded. */
+	if (write(talpa, "1", 1) != 1) {
+		fprintf(stderr, "Failed to exclude - errno %d!\n", errno);
+		return 1;
+	}
+
+	/* Cat files given as arguments. */
+	while (args > 0) {
+		fd = open(argv[args], O_RDONLY);
+		if (fd > 0) {
+			while ((size = read(fd, buffer, sizeof(buffer))) > 0)
+				write(STDOUT_FILENO, buffer, size);
+			close(fd);
+		} else {
+			fprintf(stderr, "%s: %s!\n", argv[args], strerror(errno));
+		}
+		args--;
+	}
+
+	/* Revert back to being intercepted. */
+	if (write(talpa, "0", 1) != 1) {
+		fprintf(stderr, "Failed to revert - errno %d!\n", errno);
+		return 1;
+	}
+
+	close(talpa);
+
+	return 0;
+}
diff --git a/Documentation/talpa/thread_exclude b/Documentation/talpa/thread_exclude
new file mode 100644
index 0000000..b2e9f10
--- /dev/null
+++ b/Documentation/talpa/thread_exclude
@@ -0,0 +1,6 @@
+Provide an interface for threads to exclude themselves from all talpa decisions and always be allowed access.  This is implemented using a task_struct flag.  Userspace clients which are expected to access content normally denied can use this interface to gain access.  Userspace vetting clients will have this flag automatically set so they do not recursively call themselves asking for permissions to open files to check them for malware.
+
+***********
+/security/talpa/exclude/*
+
+exclude: WRONLY:	echo 1 into this file will cause the current task to be excluded from talpa access decisions.  0 is default
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5270d44..0274f85 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1502,6 +1502,7 @@ static inline void put_task_struct(struct task_struct *t)
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
+#define PF_TALPA_EXCL	0x08000000	/* Processes which talpa should exclude */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
diff --git a/security/talpa/Kconfig b/security/talpa/Kconfig
index 7910cc1..c5528e5 100644
--- a/security/talpa/Kconfig
+++ b/security/talpa/Kconfig
@@ -20,3 +20,21 @@ config TALPA_CACHE
 	  By default all block device backed filesystems are cached.
 
 	  If you are unsure how to answer this question, answer Y.
+
+
+config TALPA_THREAD_EXCLUSION
+	bool "Thread exclusions"
+	depends on TALPA
+	default y
+	help
+	  This adds the ability for certain threads to register
+          themselves as excluded from the vetting process. It is useful
+          for allowing certain classes of userspace programs (for
+          example anti-malware or anti-rootkit scanner) to bypass
+          inteception which would otherwise interfere with their
+	  operation.
+
+	  Access to this facility is controlled via permissions
+	  on a corresponding device node.
+
+	  If you are unsure how to answer this question, answer Y.
diff --git a/security/talpa/Makefile b/security/talpa/Makefile
index 8da21b9..16cb1d0 100644
--- a/security/talpa/Makefile
+++ b/security/talpa/Makefile
@@ -9,3 +9,5 @@ talpa-y :=	talpa_interceptor.o \
 		talpa_configuration.o
 
 talpa-$(CONFIG_TALPA_CACHE) += talpa_cache.o
+talpa-$(CONFIG_TALPA_THREAD_EXCLUSION) += talpa_thread_exclude.o
+
diff --git a/security/talpa/talpa_interceptor.c b/security/talpa/talpa_interceptor.c
index bde8a59..9aefbf0 100644
--- a/security/talpa/talpa_interceptor.c
+++ b/security/talpa/talpa_interceptor.c
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/errno.h>
+#include <linux/sched.h>
 #include <linux/talpa.h>
 
 #include "talpa_evaluation_calls.h"
@@ -53,6 +54,10 @@ static int talpa_vet_file(struct file *file, int flags, enum talpa_operation op)
 	enum talpa_action action = TALPA_NEXT;
 	int ret = -ENOSYS;
 
+	/* Tasks marked as excluded are immediately ignored. */
+	if (current->flags & PF_TALPA_EXCL)
+		return 0;
+
 	/* Try to allocate vetting details or block access.
 	   Cache will not be available before initcalls are run so
 	   allow all access until then. */
diff --git a/security/talpa/talpa_thread_exclude.c b/security/talpa/talpa_thread_exclude.c
new file mode 100644
index 0000000..77e3c39
--- /dev/null
+++ b/security/talpa/talpa_thread_exclude.c
@@ -0,0 +1,66 @@
+/*
+ *  Copyright 2008 Sophos Plc
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+
+#include "talpa.h"
+/*
+ * Very simple misc device driver. User can open it and exclude
+ * themselves from interception by writting ASCII 1 to it, or
+ * go back by writting ASCII 0.
+ */
+static ssize_t talpa_thread_excl_write(struct talpa_configuration *cfg, char *buf, size_t len)
+{
+	if (len == 1) {
+		if (*buf == '1') {
+			current->flags |= PF_TALPA_EXCL;
+			return 1;
+		} else if (*buf == '0') {
+			current->flags &= ~PF_TALPA_EXCL;
+			return 1;
+		}
+	}
+
+	return -EPROTO;
+}
+
+static struct talpa_configuration talpa_excl_cfg[] = {
+	{
+		.name = "exclude",
+		.mode = S_IRUSR|S_IWUSR,
+		.data = NULL,
+		.set = talpa_thread_excl_write,
+	},
+	{
+	},
+};
+
+static __init int talpa_thread_exclude_init(void)
+{
+	struct dentry *dentry = talpa_register_configuration("talpa-exclude", talpa_excl_cfg);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+	return 0;
+}
+
+__initcall(talpa_thread_exclude_init);
-- 
1.5.2.1

