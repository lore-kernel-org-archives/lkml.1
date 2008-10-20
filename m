Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbYJTHil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbYJTHil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYJTHhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:37:00 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:51661 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYJTHgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:36:55 -0400
Message-Id: <20081020073650.404956820@nttdata.co.jp>
References: <20081020073423.024299308@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Mon, 20 Oct 2008 16:34:27 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #11 (linux-next) 04/11] Introduce d_realpath().
X-OriginalArrivalTime: 20 Oct 2008 07:36:52.0597 (UTC) FILETIME=[9EADDA50:01C93286]
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
 fs/dcache.c            |   79 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |    1 
 2 files changed, 80 insertions(+)

--- linux-next.orig/fs/dcache.c
+++ linux-next/fs/dcache.c
@@ -33,6 +33,7 @@
 #include <linux/swap.h>
 #include <linux/bootmem.h>
 #include <linux/backing-dev.h>
+#include <linux/magic.h>
 #include "internal.h"
 
 
@@ -1972,6 +1973,84 @@ Elong:
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
+ * If /proc/PID/ is replaced by /proc/self/ if PID == current->tgid.
+ */
+char *d_realpath(struct path *path, char *buffer, int buflen)
+{
+	struct dentry *dentry = path->dentry;
+	struct vfsmount *vfsmnt = path->mnt;
+	char *end = buffer + buflen;
+	char self_pid[16];
+
+	snprintf(self_pid, sizeof(self_pid), "%u", current->tgid);
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
+		if (IS_ROOT(parent) &&
+		    parent->d_sb->s_magic == PROC_SUPER_MAGIC &&
+		    !strcmp(name, self_pid)) {
+			if (prepend(&end, &buflen, "self", 4))
+				goto Elong;
+		} else {
+			if (prepend_name(&end, &buflen, &dentry->d_name))
+				goto Elong;
+		}
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
--- linux-next.orig/include/linux/dcache.h
+++ linux-next/include/linux/dcache.h
@@ -304,6 +304,7 @@ extern char *dynamic_dname(struct dentry
 extern char *__d_path(const struct path *path, struct path *root, char *, int);
 extern char *d_path(const struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
+extern char *d_realpath(struct path *, char *, int);
 
 /* Allocation counts.. */
 

--

