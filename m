Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYKTLiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYKTLiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbYKTLgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:36:21 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55014 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbYKTLgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:36:14 -0500
Message-Id: <20081120112732.678470045@I-love.SAKURA.ne.jp>
References: <20081120112543.799450455@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 20:25:47 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: [TOMOYO #13 (mmotm 2008-11-19-02-19) 04/11] Introduce d_realpath().
Content-Disposition: inline; filename=introduce-d_realpath.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To remove factors that make pathname based access control difficult
(e.g. symbolic links, "..", "//", chroot() etc.), a variant of d_path()
which traverses up to the root of the namespace is needed.

This patch introduces d_realpath(), a variant of d_path().
While d_path() stops traversing at current->fs->root,
d_realpath() doesn't stop traversiong at current->fs->root.

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

--- linux-2.6.28-rc5-mm1.orig/fs/dcache.c
+++ linux-2.6.28-rc5-mm1/fs/dcache.c
@@ -33,6 +33,7 @@
 #include <linux/swap.h>
 #include <linux/bootmem.h>
 #include <linux/backing-dev.h>
+#include <linux/magic.h>
 #include "internal.h"
 
 
@@ -1982,6 +1983,89 @@ Elong:
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
--- linux-2.6.28-rc5-mm1.orig/include/linux/dcache.h
+++ linux-2.6.28-rc5-mm1/include/linux/dcache.h
@@ -305,6 +305,7 @@ extern char *dynamic_dname(struct dentry
 extern char *__d_path(const struct path *path, struct path *root, char *, int);
 extern char *d_path(const struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
+extern char *d_realpath(struct path *, char *, int);
 
 /* Allocation counts.. */
 

-- 
