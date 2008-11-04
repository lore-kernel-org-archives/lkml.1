Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYKDGLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYKDGLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYKDGJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:09:56 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:46056 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYKDGJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:09:51 -0500
Message-Id: <20081104060948.233911964@nttdata.co.jp>
References: <20081104060847.086543472@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Tue, 04 Nov 2008 15:08:51 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Toshiharu Harada <haradats@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #12 (2.6.28-rc2-mm1) 04/11] Introduce d_realpath().
X-OriginalArrivalTime: 04 Nov 2008 06:09:49.0457 (UTC) FILETIME=[F1A43010:01C93E43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To remove factors that make pathname based access control difficult
(e.g. symbolic links, "..", "//", chroot() etc.), a variant of d_path()
which traverses up to the root of the namespace is needed.

Three differences compared to d_path().
(1) Ignores current process's root directory.
(2) Trailing '/' is added if the pathname refers to a directory.
(3) /proc/PID/ is represented as /proc/self/ if PID equals current->tgid.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 fs/dcache.c            |   84 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |    1 
 2 files changed, 85 insertions(+)

--- linux-2.6.28-rc2-mm1.orig/fs/dcache.c
+++ linux-2.6.28-rc2-mm1/fs/dcache.c
@@ -32,6 +32,7 @@
 #include <linux/seqlock.h>
 #include <linux/swap.h>
 #include <linux/bootmem.h>
+#include <linux/magic.h>
 #include "internal.h"
 
 
@@ -1980,6 +1981,89 @@ Elong:
 }
 
 /**
+ * d_realpath - Get the realpath of a dentry.
+ *
+ * @path: Pointer to "struct path".
+ * @buffer: Pointer to buffer to return value in.
+ * @buflen: Sizeof @buffer.
+ *
+ * Returns pointer to the realpath on success, an error code othersize.
+ *
+ * If @dentry is a directory, trailing '/' is appended.
+ * /proc/PID/ is replaced by /proc/self/ if PID == task_tgid_nr_ns(current).
+ */
+char *d_realpath(struct path *path, char *buffer, int buflen)
+{
+	struct dentry *dentry = path->dentry;
+	struct vfsmount *vfsmnt = path->mnt;
+	char *end = buffer + buflen;
+
+	spin_lock(&dcache_lock);
+	spin_lock(&vfsmount_lock);
+	if (buflen < 1 || prepend(&end, &buflen, "", 1))
+		goto Elong;
+	/*
+	 * Exception: Add trailing '/' for directory.
+	 */
+	if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode) &&
+	    prepend(&end, &buflen, "/", 1))
+		goto Elong;
+	for (;;) {
+		struct dentry *parent;
+		const char *name;
+		int name_len;
+		unsigned long pid;
+
+		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
+			/* Global root? */
+			if (vfsmnt->mnt_parent == vfsmnt)
+				break;
+			dentry = vfsmnt->mnt_mountpoint;
+			vfsmnt = vfsmnt->mnt_parent;
+			continue;
+		}
+		parent = dentry->d_parent;
+		prefetch(parent);
+		/*
+		 * Exception: Use /proc/self/ rather than /proc/\$/
+		 * for current process.
+		 */
+		name = dentry->d_name.name;
+		name_len = dentry->d_name.len;
+		if (IS_ROOT(parent) &&
+		    parent->d_sb->s_magic == PROC_SUPER_MAGIC &&
+		    !strict_strtoul(name, 10, &pid)) {
+			const pid_t tgid
+				= task_tgid_nr_ns(current,
+						  dentry->d_sb->s_fs_info);
+			if (tgid && (pid_t) pid == tgid) {
+				name = "self";
+				name_len = 4;
+			}
+		}
+		if (prepend(&end, &buflen, name, name_len))
+			goto Elong;
+		if (prepend(&end, &buflen, "/", 1))
+			goto Elong;
+		dentry = parent;
+	}
+	if (*end == '/') {
+		/* hit the slash */
+		buflen++;
+		end++;
+	}
+	if (prepend_name(&end, &buflen, &dentry->d_name))
+		goto Elong;
+ out:
+	spin_unlock(&vfsmount_lock);
+	spin_unlock(&dcache_lock);
+	return end;
+ Elong:
+	end = ERR_PTR(-ENAMETOOLONG);
+	goto out;
+}
+
+/**
  * d_path - return the path of a dentry
  * @path: path to report
  * @buf: buffer to return value in
--- linux-2.6.28-rc2-mm1.orig/include/linux/dcache.h
+++ linux-2.6.28-rc2-mm1/include/linux/dcache.h
@@ -305,6 +305,7 @@ extern char *dynamic_dname(struct dentry
 extern char *__d_path(const struct path *path, struct path *root, char *, int);
 extern char *d_path(const struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
+extern char *d_realpath(struct path *, char *, int);
 
 /* Allocation counts.. */
 

--

