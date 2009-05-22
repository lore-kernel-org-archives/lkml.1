Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZEVE7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZEVE7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZEVEz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:33823 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZEVEzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IO3FDBZ59xABbELAKjQAEhZUfofoY2H1Mj09xLQtW+27UY6U4S9U1N/orHibshuUEr
         OCB7vv/llMLyTPxWxM0k9o4Pwk7xhf/MY8p6FuA2SxJ8mg0ZG2OzDv3ZFs0FROcdNz24
         VEJl3K6ZZhhUwus/8sUh7M0VM+VC1y/EzW+6g=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 15/38] dcache: extract and use d_unlinked()
Date: Fri, 22 May 2009 08:55:09 +0400
Message-Id: <1242968132-1044-15-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_unlinked() will be used in middle-term to ban checkpointing when opened
but unlinked file is detected, and in long term, to detect such situation
and special case on it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/dcache.c            |    7 +++----
 fs/namespace.c         |    8 ++++----
 include/linux/dcache.h |    5 +++++
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 75659a6..9e5cd3c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1910,7 +1910,7 @@ char *__d_path(const struct path *path, struct path *root,
 
 	spin_lock(&vfsmount_lock);
 	prepend(&end, &buflen, "\0", 1);
-	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
 
@@ -2035,7 +2035,7 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 
 	spin_lock(&dcache_lock);
 	prepend(&end, &buflen, "\0", 1);
-	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, "//deleted", 9) != 0))
 			goto Elong;
 	if (buflen < 1)
@@ -2097,9 +2097,8 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 	read_unlock(&current->fs->lock);
 
 	error = -ENOENT;
-	/* Has the current directory has been unlinked? */
 	spin_lock(&dcache_lock);
-	if (IS_ROOT(pwd.dentry) || !d_unhashed(pwd.dentry)) {
+	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		struct path tmp = root;
 		char * cwd;
diff --git a/fs/namespace.c b/fs/namespace.c
index 134d494..be33bfc 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1430,7 +1430,7 @@ static int graft_tree(struct vfsmount *mnt, struct path *path)
 		goto out_unlock;
 
 	err = -ENOENT;
-	if (IS_ROOT(path->dentry) || !d_unhashed(path->dentry))
+	if (!d_unlinked(path->dentry))
 		err = attach_recursive_mnt(mnt, path, NULL);
 out_unlock:
 	mutex_unlock(&path->dentry->d_inode->i_mutex);
@@ -1612,7 +1612,7 @@ static int do_move_mount(struct path *path, char *old_name)
 	if (IS_DEADDIR(path->dentry->d_inode))
 		goto out1;
 
-	if (!IS_ROOT(path->dentry) && d_unhashed(path->dentry))
+	if (d_unlinked(path->dentry))
 		goto out1;
 
 	err = -EINVAL;
@@ -2175,9 +2175,9 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	error = -ENOENT;
 	if (IS_DEADDIR(new.dentry->d_inode))
 		goto out2;
-	if (d_unhashed(new.dentry) && !IS_ROOT(new.dentry))
+	if (d_unlinked(new.dentry))
 		goto out2;
-	if (d_unhashed(old.dentry) && !IS_ROOT(old.dentry))
+	if (d_unlinked(old.dentry))
 		goto out2;
 	error = -EBUSY;
 	if (new.mnt == root.mnt ||
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 1515636..f8488bd 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -351,6 +351,11 @@ static inline int d_unhashed(struct dentry *dentry)
 	return (dentry->d_flags & DCACHE_UNHASHED);
 }
 
+static inline int d_unlinked(struct dentry *dentry)
+{
+	return d_unhashed(dentry) && !IS_ROOT(dentry);
+}
+
 static inline struct dentry *dget_parent(struct dentry *dentry)
 {
 	struct dentry *ret;
-- 
1.5.6.5

