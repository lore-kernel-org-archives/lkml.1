Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbYFWSZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbYFWSZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYFWSZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:25:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37944 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbYFWSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:25:28 -0400
To: viro@ZenIV.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org
Subject: [patch v3] vfs: fix sys_getcwd for detached mounts
Message-Id: <E1KAqjG-00080e-KH@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Jun 2008 20:25:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested this one in various situations, and it appears to do what
it's supposed to.

A somewhat analogous issue is if we have cwd (or fd) outside
current->root.  Should we add a prefix for that case as well?  Perhaps
a double slash?

--
From: Miklos Szeredi <mszeredi@suse.cz>

Currently getcwd(2) on a detached mount will give a garbled result:

   > mkdir /mnt/foo
   > mount --bind /etc /mnt/foo
   > cd /mnt/foo/skel
   > umount -l /mnt/foo
   > /bin/pwd
   etcskel

After the patch the result will be "detached:skel".

Or if the root was mounted:

   > mount --bind / /mnt/foo
   > cd /mnt/foo/etc
   > umount -l /mnt/foo
   > /bin/pwd
   /etc

After the patch the result will be "detached:etc".

Thanks to John Johansen for pointing out this bug.

v2: comment from Al Viro: use "detached:" prefix to differentiate it from
attached paths.

v3: fix case when mounted dentry is root of the filesystem.

Reported-by: John Johansen <jjohansen@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2008-06-23 19:34:21.000000000 +0200
+++ linux-2.6/fs/dcache.c	2008-06-23 20:15:09.000000000 +0200
@@ -1762,6 +1762,12 @@ static int prepend_name(char **buffer, i
 	return prepend(buffer, buflen, name->name, name->len);
 }
 
+static bool is_pseudo_root(struct dentry *dentry)
+{
+	return IS_ROOT(dentry) &&
+		(dentry->d_name.len != 1 || dentry->d_name.name[0] != '/');
+}
+
 /**
  * __d_path - return the path of a dentry
  * @path: the dentry/vfsmount to report
@@ -1828,8 +1834,16 @@ char *__d_path(const struct path *path, 
 
 global_root:
 	retval += 1;	/* hit the slash */
-	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
-		goto Elong;
+
+	if (vfsmnt->mnt_ns != NULL || is_pseudo_root(dentry)) {
+		/* Attached, or pseudo filesystem with "foo:" prefix */
+		if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
+			goto Elong;
+	} else {
+		/* Detached */
+		if (prepend(&retval, &buflen, "detached:", 9) != 0)
+			goto Elong;
+	}
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	return retval;
