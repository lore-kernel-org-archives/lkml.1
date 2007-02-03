Return-Path: <linux-kernel-owner+w=401wt.eu-S1946308AbXBCDXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946308AbXBCDXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 22:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946307AbXBCDXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 22:23:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946306AbXBCDXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 22:23:13 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
Subject: [PATCH] Fix d_path for lazy unmounts
Date: Fri, 2 Feb 2007 19:23:02 -0800
User-Agent: KMail/1.9.5
MIME-Version: 1.0
X-Length: 9327
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Cc: Tony Jones <tonyj@suse.de>
Reply-To: linux-kernel@vger.kernel.org
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WAAxFbrwhJ/C0fI"
Message-Id: <200702021923.02491.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_WAAxFbrwhJ/C0fI
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

here is a bugfix to d_path. Please apply (after 2.6.20).

First, when d_path() hits a lazily unmounted mount point, it tries to
prepend the name of the lazily unmounted dentry to the path name. It
gets this wrong, and also overwrites the slash that separates the name
from the following pathname component. This is demonstrated by the
attached test case, which prints "getcwd returned d_path-bugsubdir"
with the bug. The correct result would be "getcwd returned
d_path-bug/subdir".

It could be argued that the name of the root dentry should not be part
of the result of d_path in the first place. On the other hand, what the
unconnected namespace was once reachable as may provide some useful
hints to users, and so that seems okay.

Second, it isn't always possible to tell from the __d_path result whether
the specified root and rootmnt (i.e., the chroot) was reached: lazy
unmounts of bind mounts will produce a path that does start with a
non-slash so we can tell from that, but other lazy unmounts will produce
a path that starts with a slash, just like "ordinary" paths.

The attached patch cleans up __d_path() to fix the bug with overlapping
pathname components. It also adds a @fail_deleted argument, which allows
to get rid of some of the mess in sys_getcwd(). Grabbing the dcache_lock
can then also be moved into __d_path(). The patch also makes sure that
paths will only start with a slash for paths which are connected to the
root and rootmnt.

The @fail_deleted argument could be added to d_path() as well: this would
allow callers to recognize deleted files, without having to resort to the
ambiguous check for the " (deleted)" string at the end of the pathnames.
This is not currently done, but it might be worthwhile.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -1739,45 +1739,43 @@ shouldnt_be_hashed:
  * @rootmnt: vfsmnt to which the root dentry belongs
  * @buffer: buffer to return value in
  * @buflen: buffer length
+ * @fail_deleted: what to return for deleted files
  *
- * Convert a dentry into an ASCII path name. If the entry has been deleted
- * the string " (deleted)" is appended. Note that this is ambiguous.
+ * Convert a dentry into an ASCII path name. If the entry has been deleted,
+ * then if @fail_deleted is true, ERR_PTR(-ENOENT) is returned. Otherwise,
+ * the the string " (deleted)" is appended. Note that this is ambiguous.
  *
- * Returns the buffer or an error code if the path was too long.
- *
- * "buflen" should be positive. Caller holds the dcache_lock.
+ * Returns the buffer or an error code.
  */
-static char * __d_path( struct dentry *dentry, struct vfsmount *vfsmnt,
-			struct dentry *root, struct vfsmount *rootmnt,
-			char *buffer, int buflen)
+static char *__d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
+		      struct dentry *root, struct vfsmount *rootmnt,
+		      char *buffer, int buflen, int fail_deleted)
 {
-	char * end = buffer+buflen;
-	char * retval;
+	char *end = buffer + buflen - 1;
 	int namelen;
 
-	*--end = '\0';
+	buffer = end;
+	if (buflen < 2)
+		return ERR_PTR(-ENAMETOOLONG);
+	*end = '\0';
 	buflen--;
+
+	spin_lock(&dcache_lock);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
-		buflen -= 10;
-		end -= 10;
-		if (buflen < 0)
+		if (fail_deleted) {
+			buffer = ERR_PTR(-ENOENT);
+			goto out;
+		}
+		if (buflen < 10)
 			goto Elong;
-		memcpy(end, " (deleted)", 10);
+		buflen -= 10;
+		buffer -= 10;
+		memcpy(buffer, " (deleted)", 10);
 	}
-
-	if (buflen < 1)
-		goto Elong;
-	/* Get '/' right */
-	retval = end-1;
-	*retval = '/';
-
-	for (;;) {
+	while (dentry != root || vfsmnt != rootmnt) {
 		struct dentry * parent;
 
-		if (dentry == root && vfsmnt == rootmnt)
-			break;
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
-			/* Global root? */
 			spin_lock(&vfsmount_lock);
 			if (vfsmnt->mnt_parent == vfsmnt) {
 				spin_unlock(&vfsmount_lock);
@@ -1791,33 +1789,49 @@ static char * __d_path( struct dentry *d
 		parent = dentry->d_parent;
 		prefetch(parent);
 		namelen = dentry->d_name.len;
-		buflen -= namelen + 1;
-		if (buflen < 0)
+		if (buflen <= namelen)
 			goto Elong;
-		end -= namelen;
-		memcpy(end, dentry->d_name.name, namelen);
-		*--end = '/';
-		retval = end;
+		buflen -= namelen + 1;
+		buffer -= namelen;
+		memcpy(buffer, dentry->d_name.name, namelen);
+		*--buffer = '/';
 		dentry = parent;
 	}
+	/* Get '/' right */
+	if (buffer == end)
+		*--buffer = '/';
 
-	return retval;
+out:
+	spin_unlock(&dcache_lock);
+	return buffer;
 
 global_root:
+	/*
+	 * We went past the (vfsmount, dentry) we were looking for and have
+	 * either hit a root dentry, a lazily unmounted dentry, or an
+	 * unconnected dentry. Make sure we won't return a pathname rooted
+	 * in '/'.
+	 */
 	namelen = dentry->d_name.len;
-	buflen -= namelen;
-	if (buflen < 0)
-		goto Elong;
-	retval -= namelen-1;	/* hit the slash */
-	memcpy(retval, dentry->d_name.name, namelen);
-	return retval;
+	if (namelen == 1 && *dentry->d_name.name == '/') {
+		if (buffer != end)
+			buffer++;
+	} else {
+		if (buflen < namelen)
+			goto Elong;
+		buffer -= namelen;
+		memcpy(buffer, dentry->d_name.name, namelen);
+	}
+	goto out;
+
 Elong:
-	return ERR_PTR(-ENAMETOOLONG);
+	buffer = ERR_PTR(-ENAMETOOLONG);
+	goto out;
 }
 
 /* write full pathname into buffer and return start of pathname */
-char * d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-				char *buf, int buflen)
+char *d_path(struct dentry *dentry, struct vfsmount *vfsmnt, char *buf,
+	     int buflen)
 {
 	char *res;
 	struct vfsmount *rootmnt;
@@ -1827,9 +1841,7 @@ char * d_path(struct dentry *dentry, str
 	rootmnt = mntget(current->fs->rootmnt);
 	root = dget(current->fs->root);
 	read_unlock(&current->fs->lock);
-	spin_lock(&dcache_lock);
-	res = __d_path(dentry, vfsmnt, root, rootmnt, buf, buflen);
-	spin_unlock(&dcache_lock);
+	res = __d_path(dentry, vfsmnt, root, rootmnt, buf, buflen, 0);
 	dput(root);
 	mntput(rootmnt);
 	return res;
@@ -1855,10 +1867,10 @@ char * d_path(struct dentry *dentry, str
  */
 asmlinkage long sys_getcwd(char __user *buf, unsigned long size)
 {
-	int error;
+	int error, len;
 	struct vfsmount *pwdmnt, *rootmnt;
 	struct dentry *pwd, *root;
-	char *page = (char *) __get_free_page(GFP_USER);
+	char *page = (char *) __get_free_page(GFP_USER), *cwd;
 
 	if (!page)
 		return -ENOMEM;
@@ -1870,29 +1882,18 @@ asmlinkage long sys_getcwd(char __user *
 	root = dget(current->fs->root);
 	read_unlock(&current->fs->lock);
 
-	error = -ENOENT;
-	/* Has the current directory has been unlinked? */
-	spin_lock(&dcache_lock);
-	if (pwd->d_parent == pwd || !d_unhashed(pwd)) {
-		unsigned long len;
-		char * cwd;
-
-		cwd = __d_path(pwd, pwdmnt, root, rootmnt, page, PAGE_SIZE);
-		spin_unlock(&dcache_lock);
-
-		error = PTR_ERR(cwd);
-		if (IS_ERR(cwd))
-			goto out;
-
-		error = -ERANGE;
-		len = PAGE_SIZE + page - cwd;
-		if (len <= size) {
-			error = len;
-			if (copy_to_user(buf, cwd, len))
-				error = -EFAULT;
-		}
-	} else
-		spin_unlock(&dcache_lock);
+	cwd = __d_path(pwd, pwdmnt, root, rootmnt, page, PAGE_SIZE, 1);
+	error = PTR_ERR(cwd);
+	if (IS_ERR(cwd))
+		goto out;
+
+	error = -ERANGE;
+	len = PAGE_SIZE + page - cwd;
+	if (len <= size) {
+		error = len;
+		if (copy_to_user(buf, cwd, len))
+			error = -EFAULT;
+	}
 
 out:
 	dput(pwd);

--Boundary-00=_WAAxFbrwhJ/C0fI
Content-Type: text/x-csrc;
  charset="us-ascii";
  name="d_path-lazy-unmounts.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="d_path-lazy-unmounts.c"

#include <stdio.h>
#include <limits.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>

#define MNT_DETACH 2

int
main(void)
{
	char tmpdir[] = "/var/tmp/d_path-bug";
	char path[PATH_MAX];
	int status = 1;

	if (mkdir(tmpdir, 0777) != 0 ||
	    mount(tmpdir, tmpdir, NULL, MS_BIND, NULL) != 0 ||
	    chdir(tmpdir) != 0 ||
	    umount2(tmpdir, MNT_DETACH) != 0) {
		perror(tmpdir);
		goto out;
	}
	if (mkdir("subdir", 0777) != 0 ||
	    chdir("subdir") != 0) {
		perror("subdir");
		goto out2;
	}
	if (getcwd(path, sizeof(path)) == NULL) {
		perror("getcwd");
		goto out2;
	}
	printf("getcwd returned %s\n", path);
	status = 0;
out2:
	chdir("..");
	rmdir("subdir");
	chdir("/");
out:
	umount(tmpdir);
	rmdir(tmpdir);
	return status;
}

--Boundary-00=_WAAxFbrwhJ/C0fI--
