Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbZHNJlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbZHNJlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZHNJlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:41:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45816 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZHNJlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:41:04 -0400
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       John Johansen <jjohansen@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [PATCH RESEND] vfs: fix d_path() for unreachable paths
Message-Id: <E1MbtHL-0005zN-9B@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Aug 2009 11:40:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were no comments at the last submission:

  http://lkml.org/lkml/2008/7/30/204

Andrew, could you please put this into -mm so it doesn't get lost
while Al is absent?  It really shoulnd't hurt.

Thanks,
Miklos
----

From: Miklos Szeredi <mszeredi@suse.cz>

John Johansen pointed out, that getcwd(2) will give a garbled result
if a bind mount of a non-filesystem-root directory is detached:

   > mkdir /mnt/foo
   > mount --bind /etc /mnt/foo
   > cd /mnt/foo/skel
   > umount -l /mnt/foo
   > /bin/pwd
   etcskel

If it was the root of the filesystem which was detached, it will give
a saner looking result, but it still won't be a valid absolute path by
which the CWD can be reached (assuming the process's root is not also
on the detached mount).

A similar issue happens if the CWD is outside the process's root or in
a different namespace.  These problems are relevant to symlinks under
/proc/<pid>/ and /proc/<pid>/fd/ as well.

This patch addresses all these issues, by prefixing such unreachable
paths with "(unreachable)".  This isn't perfect since the returned
path may still be a valid _relative_ path, and applications may not
check the result of getcwd() for starting with a '/' before using it.

For this reason Andreas Gruenbacher thinks getcwd(2) should return
ENOENT in these cases, but that breaks /bin/pwd and bash in the above
cases.

Reported-by: John Johansen <jjohansen@suse.de>
CC: Matthew Wilcox <matthew@wil.cx>
CC: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2009-07-03 13:12:06.000000000 +0200
+++ linux-2.6/fs/dcache.c	2009-08-14 11:30:43.000000000 +0200
@@ -1882,6 +1882,12 @@ static int prepend_name(char **buffer, i
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
@@ -1949,8 +1955,18 @@ out:
 
 global_root:
 	retval += 1;	/* hit the slash */
-	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
-		goto Elong;
+
+	if (is_pseudo_root(dentry)) {
+		/* Pseudo filesystem with "foo:" prefix */
+		if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
+			goto Elong;
+	} else {
+		/*
+		 * Unreachable (detached or outside root or outside namespace)
+		 */
+		if (prepend(&retval, &buflen, "(unreachable)/", 14) != 0)
+			goto Elong;
+	}
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	goto out;
