Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0BTMYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 07:24:32 -0500
Received: from adelie.canonical.com ([91.189.90.139]:38061 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab0BTMYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 07:24:30 -0500
Message-ID: <4B7FD479.5020807@canonical.com>
Date: Sat, 20 Feb 2010 04:24:25 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH 01/12] Miscellaneous functions and defines needed by AppArmor,
 including the base path resolution routines.
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com> <1266572188-26529-2-git-send-email-john.johansen@canonical.com> <20100219110320.GL30031@ZenIV.linux.org.uk>
In-Reply-To: <20100219110320.GL30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Fri, Feb 19, 2010 at 01:36:17AM -0800, john.johansen@canonical.com wrote:
> 
>> +	spin_lock(&dcache_lock);
>> +	/* There is a race window between path lookup here and the
>> +	 * need to strip the " (deleted) string that __d_path applies
>> +	 * Detect the race and relookup the path
>> +	 *
>> +	 * The stripping of (deleted) is a hack that could be removed
>> +	 * with an updated __d_path
> 
> Yes, it could.  Where's the patch doing just that?  Or discussion of
> desired interface, at lease...
> 
Glad you asked I was going to include it with a couple other patches to
__d_path.  Basically trying to separate proposed changes to __d_path
from AppArmor, as most people who will be looking at the __d_path code
would rather not have the whole AppArmor patchset dropped on them.

The attached patch is just a first pass and a starting point for
discussion.  I only modified TOMOYO to match current behavior of the
kernel and will leave it to Tetsuo to modify TOMOYO to make use
of the flag.

---

Make __d_path unambiguous for deleted files

__d_path currently appends the string " (deleted)" to deleted entries, but
this results in an ambiguous path.  This is problematic for TOMOYO and
AppArmor as they use __d_path to retrieve path names for file objects.

This patch matches the appending the " (deleted)" string optional,
removing the need for AppArmor and TOMOYO to remove the string after
the fact.

Signed-off-by: John Johansen <john.johansen@canonical.com>

diff --git a/fs/dcache.c b/fs/dcache.c
index df49666..44c2afc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1890,9 +1890,10 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * @root: root vfsmnt/dentry (may be modified by this function)
  * @buffer: buffer to return value in
  * @buflen: buffer length
- *
+ * @mark_deleted: for deleted entries determine whether to append " (deleted)"
  * Convert a dentry into an ASCII path name. If the entry has been deleted
- * the string " (deleted)" is appended. Note that this is ambiguous.
+ * and @mark_deleted is true then the string " (deleted)" is appended.
+ * Note that this is ambiguous.
  *
  * Returns a pointer into the buffer or an error code if the
  * path was too long.
@@ -1903,7 +1904,7 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * root is changed (without modifying refcounts).
  */
 char *__d_path(const struct path *path, struct path *root,
-	       char *buffer, int buflen)
+	       char *buffer, int buflen, bool mark_deleted)
 {
 	struct dentry *dentry = path->dentry;
 	struct vfsmount *vfsmnt = path->mnt;
@@ -1912,7 +1913,7 @@ char *__d_path(const struct path *path, struct path *root,
 
 	spin_lock(&vfsmount_lock);
 	prepend(&end, &buflen, "\0", 1);
-	if (d_unlinked(dentry) &&
+	if (d_unlinked(dentry) && mark_deleted &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
 
@@ -2019,7 +2020,7 @@ char *d_path(const struct path *path, char *buf, int buflen)
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
 	tmp = root;
-	res = __d_path(path, &tmp, buf, buflen);
+	res = __d_path(path, &tmp, buf, buflen, DPATH_MARK_DELETED);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -2124,7 +2125,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 		struct path tmp = root;
 		char * cwd;
 
-		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
+		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE, DPATH_MARK_DELETED);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
diff --git a/fs/seq_file.c b/fs/seq_file.c
index eae7d9d..f046bd3 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -463,7 +463,7 @@ int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		char *p;
 
 		spin_lock(&dcache_lock);
-		p = __d_path(path, root, buf, size);
+		p = __d_path(path, root, buf, size, DPATH_MARK_DELETED);
 		spin_unlock(&dcache_lock);
 		res = PTR_ERR(p);
 		if (!IS_ERR(p)) {
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 30b93b2..021f515 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -309,9 +309,12 @@ extern int d_validate(struct dentry *, struct dentry *);
 /*
  * helper function for dentry_operations.d_dname() members
  */
+#define DPATH_MARK_DELETED 1
+
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
-extern char *__d_path(const struct path *path, struct path *root, char *, int);
+extern char *__d_path(const struct path *path, struct path *root, char *, int,
+		      bool);
 extern char *d_path(const struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
diff --git a/security/tomoyo/realpath.c b/security/tomoyo/realpath.c
index 18369d4..0f4d4e2 100644
--- a/security/tomoyo/realpath.c
+++ b/security/tomoyo/realpath.c
@@ -106,7 +106,8 @@ int tomoyo_realpath_from_path2(struct path *path, char *newname,
 		spin_unlock(&vfsmount_lock);
 		spin_lock(&dcache_lock);
 		tmp = ns_root;
-		sp = __d_path(path, &tmp, newname, newname_len);
+		sp = __d_path(path, &tmp, newname, newname_len,
+			      DPATH_MARK_DELETED);
 		spin_unlock(&dcache_lock);
 		path_put(&root);
 		path_put(&ns_root);
