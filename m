Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0BOOLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 09:11:43 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:63710 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab0BOOLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 09:11:41 -0500
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Add flags to __d_path for suppressing suffix and mapping /proc/self
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201002152311.IGC00525.SFOVtLJQFMOHFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 15 Feb 2010 23:11:37 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'd like to propose this patch.

TOMOYO and AppArmor are bothered by " (deleted)" suffix added by __d_path().

Also, converting /proc/PID to /proc/self makes it possible for TOMOYO to grant
read access for only self process's information. It would be also useful for
other users when auditing pathnames like /proc/self/mounts . In that case,
flags (added by this patch) should be passed to d_path() as well.

I wrote reason why I can't do it outside __d_path(). If modifying __d_path() is
not acceptable, I beg your permission for putting similar code to
security/tomoyo/ directory.

Regards.
--------------------
[PATCH] fs: Add flags to __d_path for suppressing suffix and mapping /proc/self

This patch allows __d_path() to
(1) suppress " (deleted)" suffix if dentry was already deleted
(2) convert /proc/PID to /proc/self if dentry is under /proc/self directory

Since "/path/to/file (deleted)" is a legal pathname of a not yet deleted file,
the caller of __d_path() can't blindly cut off " (deleted)" part.

Also, procfs is usually mounted on /proc , but it can be mounted on /proc2 ,
/mnt/proc3 or /p . Thus, the caller of __d_path() can't convert /proc/PID to
/proc/self from string returned by __d_path() because the caller can't find
the mount point of procfs from the returned string. If the caller traverses
dentry/vfsmount tree in order to find the mount point of procfs, it results in
duplicating __d_path() because the the caller does not use __d_path().

TOMOYO wants to use pathname without " (deleted)" suffix and pathname converted
to /proc/self . This patch adds two flags for controlling " (deleted)" suffix
and "PID => self" mapping.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/dcache.c                |   36 ++++++++++++++++++++++++++++++------
 fs/seq_file.c              |    2 +-
 include/linux/dcache.h     |    5 ++++-
 security/tomoyo/realpath.c |    4 +++-
 4 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 74da947..cf1a1e1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/fs_struct.h>
 #include <linux/hardirq.h>
+#include <linux/magic.h>
 #include "internal.h"
 
 int sysctl_vfs_cache_pressure __read_mostly = 100;
@@ -1909,9 +1910,14 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * @root: root vfsmnt/dentry (may be modified by this function)
  * @buffer: buffer to return value in
  * @buflen: buffer length
+ * @flags: combination of control flags
  *
  * Convert a dentry into an ASCII path name. If the entry has been deleted
- * the string " (deleted)" is appended. Note that this is ambiguous.
+ * the string " (deleted)" is appended unless D_PATH_NO_DELETED_SUFFIX is
+ * set to "flags". Note that this is ambiguous.
+ *
+ * If D_PATH_CONVERT_PROC_SELF is set to "flags", "/proc/PID" is converted to
+ * "/proc/self" if PID is current process.
  *
  * Returns a pointer into the buffer or an error code if the
  * path was too long.
@@ -1922,7 +1928,7 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * root is changed (without modifying refcounts).
  */
 char *__d_path(const struct path *path, struct path *root,
-	       char *buffer, int buflen)
+	       char *buffer, int buflen, unsigned int flags)
 {
 	struct dentry *dentry = path->dentry;
 	struct vfsmount *vfsmnt = path->mnt;
@@ -1931,7 +1937,7 @@ char *__d_path(const struct path *path, struct path *root,
 
 	spin_lock(&vfsmount_lock);
 	prepend(&end, &buflen, "\0", 1);
-	if (d_unlinked(dentry) &&
+	if (!(flags & D_PATH_NO_DELETED_SUFFIX) && d_unlinked(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
 
@@ -1943,6 +1949,8 @@ char *__d_path(const struct path *path, struct path *root,
 
 	for (;;) {
 		struct dentry * parent;
+		const char *name;
+		int namelen;
 
 		if (dentry == root->dentry && vfsmnt == root->mnt)
 			break;
@@ -1957,7 +1965,23 @@ char *__d_path(const struct path *path, struct path *root,
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		if ((prepend_name(&end, &buflen, &dentry->d_name) != 0) ||
+		name = dentry->d_name.name;
+		namelen = dentry->d_name.len;
+		/* Map /proc/PID to /proc/self . */
+		if ((flags & D_PATH_CONVERT_PROC_SELF) && IS_ROOT(parent) &&
+		    *name > '0' && *name <= '9' && parent->d_sb &&
+		    parent->d_sb->s_magic == PROC_SUPER_MAGIC) {
+			char *ep;
+			const pid_t pid = (pid_t) simple_strtoul(name, &ep, 10);
+			const pid_t tgid = task_tgid_nr_ns(current,
+							   dentry->d_sb->
+							   s_fs_info);
+			if (!*ep && pid == tgid && tgid) {
+				name = "self";
+				namelen = 4;
+			}
+		}
+		if ((prepend(&end, &buflen, name, namelen) != 0) ||
 		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
 		retval = end;
@@ -2019,7 +2043,7 @@ char *d_path(const struct path *path, char *buf, int buflen)
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
 	tmp = root;
-	res = __d_path(path, &tmp, buf, buflen);
+	res = __d_path(path, &tmp, buf, buflen, 0);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -2125,7 +2149,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 		struct path tmp = root;
 		char * cwd;
 
-		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
+		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE, 0);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
diff --git a/fs/seq_file.c b/fs/seq_file.c
index eae7d9d..729072d 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -463,7 +463,7 @@ int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		char *p;
 
 		spin_lock(&dcache_lock);
-		p = __d_path(path, root, buf, size);
+		p = __d_path(path, root, buf, size, 0);
 		spin_unlock(&dcache_lock);
 		res = PTR_ERR(p);
 		if (!IS_ERR(p)) {
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 30b93b2..0e2e814 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -311,7 +311,10 @@ extern int d_validate(struct dentry *, struct dentry *);
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
-extern char *__d_path(const struct path *path, struct path *root, char *, int);
+#define D_PATH_NO_DELETED_SUFFIX 1 /* Don't add " (deleted) suffix. */
+#define D_PATH_CONVERT_PROC_SELF 2 /* Map /proc/PID to /proc/self   */
+extern char *__d_path(const struct path *path, struct path *root, char *buffer,
+		      int buflen, unsigned int flags);
 extern char *d_path(const struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
diff --git a/security/tomoyo/realpath.c b/security/tomoyo/realpath.c
index 455bc39..24d3471 100644
--- a/security/tomoyo/realpath.c
+++ b/security/tomoyo/realpath.c
@@ -93,7 +93,9 @@ int tomoyo_realpath_from_path2(struct path *path, char *newname,
 
 		spin_lock(&dcache_lock);
 		/* go to whatever namespace root we are under */
-		sp = __d_path(path, &ns_root, newname, newname_len);
+		sp = __d_path(path, &ns_root, newname, newname_len,
+			      D_PATH_NO_DELETED_SUFFIX |
+			      D_PATH_CONVERT_PROC_SELF);
 		spin_unlock(&dcache_lock);
 		/* Prepend "/proc" prefix if using internal proc vfs mount. */
 		if (!IS_ERR(sp) && (path->mnt->mnt_flags & MNT_INTERNAL) &&
