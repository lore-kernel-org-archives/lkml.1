Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbYG3LuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbYG3LuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYG3Lt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:49:57 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56912 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYG3Lt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:49:56 -0400
To: viro@ZenIV.linux.org.uk
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       jjohansen@suse.de, matthew@wil.cx, agruen@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [rfc patch] vfs: fix d_path() for unreachable paths
Message-Id: <E1KOABb-0004rk-CT@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jul 2008 13:49:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not convinced that this is really a safe thing to do: it will
modify the behavior of sys_getcwd() even for the cases when it gave a
somewhat sane (though arguably wrong) result.

So I think it should wait till 2.6.28 as there doesn't seem to be
anybody who is actually bothered by this bug...

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
 fs/dcache.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2008-07-30 13:41:50.000000000 +0200
+++ linux-2.6/fs/dcache.c	2008-07-30 13:41:52.000000000 +0200
@@ -1788,6 +1788,12 @@ static int prepend_name(char **buffer, i
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
@@ -1854,8 +1860,16 @@ out:
 
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
+		/* Unreachable (detached/outside root/outside namespace) */
+		if (prepend(&retval, &buflen, "(unreachable)/", 14) != 0)
+			goto Elong;
+	}
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	goto out;
