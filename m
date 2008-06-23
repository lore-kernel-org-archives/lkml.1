Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbYFWQNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbYFWQNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbYFWQMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:12:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57088 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbYFWQMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:12:15 -0400
Message-Id: <20080623161211.870094712@szeredi.hu>
References: <20080623161151.597847108@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 23 Jun 2008 18:11:53 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org
Subject: [patch 2/3] vfs: dcache cleanups
Content-Disposition: inline; filename=vfs-dcache-cleanups.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Comment from Al Viro: add prepend_name() wrapper.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2008-06-23 17:27:11.000000000 +0200
+++ linux-2.6/fs/dcache.c	2008-06-23 17:55:57.000000000 +0200
@@ -1747,8 +1747,7 @@ shouldnt_be_hashed:
 	BUG();
 }
 
-static int prepend(char **buffer, int *buflen, const char *str,
-			  int namelen)
+static int prepend(char **buffer, int *buflen, const char *str, int namelen)
 {
 	*buflen -= namelen;
 	if (*buflen < 0)
@@ -1758,6 +1757,11 @@ static int prepend(char **buffer, int *b
 	return 0;
 }
 
+static int prepend_name(char **buffer, int *buflen, struct qstr *name)
+{
+	return prepend(buffer, buflen, name->name, name->len);
+}
+
 /**
  * __d_path - return the path of a dentry
  * @path: the dentry/vfsmount to report
@@ -1780,8 +1784,8 @@ char *__d_path(const struct path *path, 
 {
 	struct dentry *dentry = path->dentry;
 	struct vfsmount *vfsmnt = path->mnt;
-	char * end = buffer+buflen;
-	char * retval;
+	char *end = buffer + buflen;
+	char *retval;
 
 	prepend(&end, &buflen, "\0", 1);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
@@ -1813,8 +1817,7 @@ char *__d_path(const struct path *path, 
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		if ((prepend(&end, &buflen, dentry->d_name.name,
-				dentry->d_name.len) != 0) ||
+		if ((prepend_name(&end, &buflen, &dentry->d_name) != 0) ||
 		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
 		retval = end;
@@ -1825,8 +1828,7 @@ char *__d_path(const struct path *path, 
 
 global_root:
 	retval += 1;	/* hit the slash */
-	if (prepend(&retval, &buflen, dentry->d_name.name,
-		    dentry->d_name.len) != 0)
+	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
 		goto Elong;
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
@@ -1916,16 +1918,11 @@ char *dentry_path(struct dentry *dentry,
 	retval = end-1;
 	*retval = '/';
 
-	for (;;) {
-		struct dentry *parent;
-		if (IS_ROOT(dentry))
-			break;
+	while (!IS_ROOT(dentry)) {
+		struct dentry *parent = dentry->d_parent;
 
-		parent = dentry->d_parent;
 		prefetch(parent);
-
-		if ((prepend(&end, &buflen, dentry->d_name.name,
-				dentry->d_name.len) != 0) ||
+		if ((prepend_name(&end, &buflen, &dentry->d_name) != 0) ||
 		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
 
@@ -1976,7 +1973,7 @@ asmlinkage long sys_getcwd(char __user *
 	error = -ENOENT;
 	/* Has the current directory has been unlinked? */
 	spin_lock(&dcache_lock);
-	if (pwd.dentry->d_parent == pwd.dentry || !d_unhashed(pwd.dentry)) {
+	if (IS_ROOT(pwd.dentry) || !d_unhashed(pwd.dentry)) {
 		unsigned long len;
 		struct path tmp = root;
 		char * cwd;

--
