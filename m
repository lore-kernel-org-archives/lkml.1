Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZKSNoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZKSNoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbZKSNoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:44:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802AbZKSNoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:44:09 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH] procfs: make /proc style symlinks behave like "normal" symlinks
Date: Thu, 19 Nov 2009 08:44:11 -0500
Message-Id: <1258638251-20034-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fourth attempt to fix problems with opening files via
/proc/pid symlinks. This one takes yet another approach and makes
/proc/pid symlinks behave like "normal" symlinks.

/proc/pid symlinks are "special". They do not return an actual path
string like most filesystems. They instead return a filled out struct
path in the nameidata and set the last_type to LAST_BIND. This allows
the path resolution code to skip resolving a text path to a struct path
since in general the kernel already knows to which dentry these symlinks
point.

There are a couple of problems with this shortcut however:

1) It causes the path walking code to skip revalidating the dentry.
It's assumed that this dentry will be valid and in general, that's a
valid assumption. Still, some filesystems such as NFSv4 rely on a call
to d_revalidate to handle opens. Opening via a /proc symlink causes that
to get skipped leading to a filp with no NFSv4 state attached.

2) In certain situations, this behavior can cause directory permissions
to be ignored. The situations identified for this are rather contrived,
but it's still a security issue (albeit a rather benign one). Details of
that problem are in the following thread:

    http://seclists.org/bugtraq/2009/Oct/179

At this point, we're faced with a choice -- add special casing to the
path walking code to fix these problems, or change /proc/pid symlinks
such that they behave like "normal" symlinks. This patch implements the
latter.

Instead of returning a struct path in the nameidata, have
proc_pid_follow_link allocate a page and convert the struct path
into a path string. That string is then returned and the path walking
code can treat it like any other symlink, converting it back to a
struct path.

This approach is less efficient than the current approach, but it allows
us to avoid adding new special cases to the path walking code. I don't
perceive /proc/pid symlinks to be a performance-critical codepath, so
I'm making the assumption that this is a reasonable tradeoff.

There is at least one user-visible change that this introduces. If a
symlink under /proc/pid points to a deleted file, the existing code will
still look like a valid symlink. With this code change that will no
longer be the case, but that may be a good thing. Users shouldn't need
to take special steps to ensure that an open file is no longer
accessible for new opens once it has been unlinked.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/proc/base.c |   85 +++++++++++++++++++++++++-------------------------------
 1 files changed, 38 insertions(+), 47 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index af643b5..b383f08 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -81,6 +81,7 @@
 #include <linux/elf.h>
 #include <linux/pid_namespace.h>
 #include <linux/fs_struct.h>
+#include <linux/highmem.h>
 #include "internal.h"
 
 /* NOTE:
@@ -1343,68 +1344,58 @@ static int proc_exe_link(struct inode *inode, struct path *exe_path)
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
-	int error = -EACCES;
-
-	/* We don't need a base pointer in the /proc filesystem */
-	path_put(&nd->path);
-
-	/* Are we allowed to snoop on the tasks file descriptors? */
-	if (!proc_fd_access_allowed(inode))
-		goto out;
-
-	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path);
-	nd->last_type = LAST_BIND;
-out:
-	return ERR_PTR(error);
-}
-
-static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
-{
-	char *tmp = (char*)__get_free_page(GFP_TEMPORARY);
 	char *pathname;
-	int len;
-
-	if (!tmp)
-		return -ENOMEM;
-
-	pathname = d_path(path, tmp, PAGE_SIZE);
-	len = PTR_ERR(pathname);
-	if (IS_ERR(pathname))
-		goto out;
-	len = tmp + PAGE_SIZE - 1 - pathname;
-
-	if (len > buflen)
-		len = buflen;
-	if (copy_to_user(buffer, pathname, len))
-		len = -EFAULT;
- out:
-	free_page((unsigned long)tmp);
-	return len;
-}
-
-static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int buflen)
-{
-	int error = -EACCES;
-	struct inode *inode = dentry->d_inode;
+	struct page *page = NULL;
 	struct path path;
+	int error;
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
-	if (!proc_fd_access_allowed(inode))
+	if (!proc_fd_access_allowed(inode)) {
+		pathname = ERR_PTR(-EACCES);
 		goto out;
+	}
 
 	error = PROC_I(inode)->op.proc_get_link(inode, &path);
-	if (error)
+	if (error) {
+		pathname = ERR_PTR(error);
 		goto out;
+	}
+
+	page = alloc_page(GFP_HIGHUSER);
+	if (!page) {
+		pathname = ERR_PTR(-ENOMEM);
+		goto out_path_put;
+	}
+
+	pathname = kmap(page);
+	pathname = d_path(&path, pathname, PAGE_SIZE);
+	if (IS_ERR(pathname)) {
+		kunmap(page);
+		__free_page(page);
+		page = NULL;
+	}
 
-	error = do_proc_readlink(&path, buffer, buflen);
+out_path_put:
 	path_put(&path);
 out:
-	return error;
+	nd_set_link(nd, pathname);
+	return page;
+}
+
+static void
+proc_pid_put_link(struct dentry *dentry, struct nameidata *nd, void *cookie)
+{
+	struct page *page = cookie;
+	if (page) {
+		kunmap(page);
+		__free_page(page);
+	}
 }
 
 static const struct inode_operations proc_pid_link_inode_operations = {
-	.readlink	= proc_pid_readlink,
+	.readlink	= generic_readlink,
 	.follow_link	= proc_pid_follow_link,
+	.put_link	= proc_pid_put_link,
 	.setattr	= proc_setattr,
 };
 
-- 
1.5.5.6

