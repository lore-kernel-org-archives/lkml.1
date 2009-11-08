Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZKHRG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZKHRG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZKHRG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:06:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:58705 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbZKHRG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:06:57 -0500
Date: Sun, 8 Nov 2009 17:06:35 GMT
From: tip-bot for Clark Williams <williams@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, williams@redhat.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, williams@redhat.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091101155621.2b3503ee@torg>
References: <20091101155621.2b3503ee@torg>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add debugfs utility routines for perf
Message-ID: <tip-afe61f677866ffc484e69c4ecca2d316d564d78b@git.kernel.org>
Git-Commit-ID: afe61f677866ffc484e69c4ecca2d316d564d78b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  afe61f677866ffc484e69c4ecca2d316d564d78b
Gitweb:     http://git.kernel.org/tip/afe61f677866ffc484e69c4ecca2d316d564d78b
Author:     Clark Williams <williams@redhat.com>
AuthorDate: Sun, 8 Nov 2009 09:01:37 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 18:01:34 +0100

perf tools: Add debugfs utility routines for perf

Add routines to locate the debugfs mount point and to manage the
mounting and unmounting of the debugfs.

Signed-off-by: Clark Williams <williams@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091101155621.2b3503ee@torg>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile       |    2 +
 tools/perf/util/debugfs.c |  241 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/debugfs.h |   25 +++++
 3 files changed, 268 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 542b29e..b9509b1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -353,6 +353,7 @@ LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
 LIB_H += perf.h
+LIB_H += util/debugfs.h
 LIB_H += util/event.h
 LIB_H += util/types.h
 LIB_H += util/levenshtein.h
@@ -378,6 +379,7 @@ LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
 LIB_OBJS += util/config.o
 LIB_OBJS += util/ctype.o
+LIB_OBJS += util/debugfs.o
 LIB_OBJS += util/environment.o
 LIB_OBJS += util/event.o
 LIB_OBJS += util/exec_cmd.o
diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
new file mode 100644
index 0000000..06b73ee
--- /dev/null
+++ b/tools/perf/util/debugfs.c
@@ -0,0 +1,241 @@
+#include "util.h"
+#include "debugfs.h"
+#include "cache.h"
+
+static int debugfs_premounted;
+static char debugfs_mountpoint[MAX_PATH+1];
+
+static const char *debugfs_known_mountpoints[] = {
+	"/sys/kernel/debug/",
+	"/debug/",
+	0,
+};
+
+/* use this to force a umount */
+void debugfs_force_cleanup(void)
+{
+	debugfs_find_mountpoint();
+	debugfs_premounted = 0;
+	debugfs_umount();
+}
+
+/* construct a full path to a debugfs element */
+int debugfs_make_path(const char *element, char *buffer, int size)
+{
+	int len;
+
+	if (strlen(debugfs_mountpoint) == 0) {
+		buffer[0] = '\0';
+		return -1;
+	}
+
+	len = strlen(debugfs_mountpoint) + strlen(element) + 1;
+	if (len >= size)
+		return len+1;
+
+	snprintf(buffer, size-1, "%s/%s", debugfs_mountpoint, element);
+	return 0;
+}
+
+static int debugfs_found;
+
+/* find the path to the mounted debugfs */
+const char *debugfs_find_mountpoint(void)
+{
+	const char **ptr;
+	char type[100];
+	FILE *fp;
+
+	if (debugfs_found)
+		return (const char *) debugfs_mountpoint;
+
+	ptr = debugfs_known_mountpoints;
+	while (*ptr) {
+		if (debugfs_valid_mountpoint(*ptr) == 0) {
+			debugfs_found = 1;
+			strcpy(debugfs_mountpoint, *ptr);
+			return debugfs_mountpoint;
+		}
+		ptr++;
+	}
+
+	/* give up and parse /proc/mounts */
+	fp = fopen("/proc/mounts", "r");
+	if (fp == NULL)
+		die("Can't open /proc/mounts for read");
+
+	while (fscanf(fp, "%*s %"
+		      STR(MAX_PATH)
+		      "s %99s %*s %*d %*d\n",
+		      debugfs_mountpoint, type) == 2) {
+		if (strcmp(type, "debugfs") == 0)
+			break;
+	}
+	fclose(fp);
+
+	if (strcmp(type, "debugfs") != 0)
+		return NULL;
+
+	debugfs_found = 1;
+
+	return debugfs_mountpoint;
+}
+
+/* verify that a mountpoint is actually a debugfs instance */
+
+int debugfs_valid_mountpoint(const char *debugfs)
+{
+	struct statfs st_fs;
+
+	if (statfs(debugfs, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
+		return -ENOENT;
+
+	return 0;
+}
+
+
+int debugfs_valid_entry(const char *path)
+{
+	struct stat st;
+
+	if (stat(path, &st))
+		return -errno;
+
+	return 0;
+}
+
+/* mount the debugfs somewhere */
+
+int debugfs_mount(const char *mountpoint)
+{
+	char mountcmd[128];
+
+	/* see if it's already mounted */
+	if (debugfs_find_mountpoint()) {
+		debugfs_premounted = 1;
+		return 0;
+	}
+
+	/* if not mounted and no argument */
+	if (mountpoint == NULL) {
+		/* see if environment variable set */
+		mountpoint = getenv(PERF_DEBUGFS_ENVIRONMENT);
+		/* if no environment variable, use default */
+		if (mountpoint == NULL)
+			mountpoint = "/sys/kernel/debug";
+	}
+
+	/* save the mountpoint */
+	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
+
+	/* mount it */
+	snprintf(mountcmd, sizeof(mountcmd),
+		 "/bin/mount -t debugfs debugfs %s", mountpoint);
+	return system(mountcmd);
+}
+
+/* umount the debugfs */
+
+int debugfs_umount(void)
+{
+	char umountcmd[128];
+	int ret;
+
+	/* if it was already mounted, leave it */
+	if (debugfs_premounted)
+		return 0;
+
+	/* make sure it's a valid mount point */
+	ret = debugfs_valid_mountpoint(debugfs_mountpoint);
+	if (ret)
+		return ret;
+
+	snprintf(umountcmd, sizeof(umountcmd),
+		 "/bin/umount %s", debugfs_mountpoint);
+	return system(umountcmd);
+}
+
+int debugfs_write(const char *entry, const char *value)
+{
+	char path[MAX_PATH+1];
+	int ret, count;
+	int fd;
+
+	/* construct the path */
+	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
+
+	/* verify that it exists */
+	ret = debugfs_valid_entry(path);
+	if (ret)
+		return ret;
+
+	/* get how many chars we're going to write */
+	count = strlen(value);
+
+	/* open the debugfs entry */
+	fd = open(path, O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	while (count > 0) {
+		/* write it */
+		ret = write(fd, value, count);
+		if (ret <= 0) {
+			if (ret == EAGAIN)
+				continue;
+			close(fd);
+			return -errno;
+		}
+		count -= ret;
+	}
+
+	/* close it */
+	close(fd);
+
+	/* return success */
+	return 0;
+}
+
+/*
+ * read a debugfs entry
+ * returns the number of chars read or a negative errno
+ */
+int debugfs_read(const char *entry, char *buffer, size_t size)
+{
+	char path[MAX_PATH+1];
+	int ret;
+	int fd;
+
+	/* construct the path */
+	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
+
+	/* verify that it exists */
+	ret = debugfs_valid_entry(path);
+	if (ret)
+		return ret;
+
+	/* open the debugfs entry */
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	do {
+		/* read it */
+		ret = read(fd, buffer, size);
+		if (ret == 0) {
+			close(fd);
+			return EOF;
+		}
+	} while (ret < 0 && errno == EAGAIN);
+
+	/* close it */
+	close(fd);
+
+	/* make *sure* there's a null character at the end */
+	buffer[ret] = '\0';
+
+	/* return the number of chars read */
+	return ret;
+}
diff --git a/tools/perf/util/debugfs.h b/tools/perf/util/debugfs.h
new file mode 100644
index 0000000..3cd14f9
--- /dev/null
+++ b/tools/perf/util/debugfs.h
@@ -0,0 +1,25 @@
+#ifndef __DEBUGFS_H__
+#define __DEBUGFS_H__
+
+#include <sys/mount.h>
+
+#ifndef MAX_PATH
+# define MAX_PATH 256
+#endif
+
+#ifndef STR
+# define _STR(x) #x
+# define STR(x) _STR(x)
+#endif
+
+extern const char *debugfs_find_mountpoint(void);
+extern int debugfs_valid_mountpoint(const char *debugfs);
+extern int debugfs_valid_entry(const char *path);
+extern int debugfs_mount(const char *mountpoint);
+extern int debugfs_umount(void);
+extern int debugfs_write(const char *entry, const char *value);
+extern int debugfs_read(const char *entry, char *buffer, size_t size);
+extern void debugfs_force_cleanup(void);
+extern int debugfs_make_path(const char *element, char *buffer, int size);
+
+#endif /* __DEBUGFS_H__ */
