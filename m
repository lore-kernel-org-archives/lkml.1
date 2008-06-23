Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbYFWQNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbYFWQNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760166AbYFWQMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:12:21 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57090 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbYFWQMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:12:16 -0400
Message-Id: <20080623161213.116829182@szeredi.hu>
References: <20080623161151.597847108@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 23 Jun 2008 18:11:54 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org
Subject: [patch 3/3] vfs: fix sys_getcwd for detached mounts
Content-Disposition: inline; filename=vfs-fix-sys_getcwd-for-detached-mounts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Currently getcwd(2) on a detached mount will give a garbled result:

   > mkdir /mnt/foo
   > mount --bind /etc /mnt/foo
   > cd /mnt/foo/skel
   > /bin/pwd
   /mnt/foo/skel
   > umount -l /mnt/foo
   > /bin/pwd
   etcskel

After the patch it will give "detached:skel" as result.

Thanks to John Johansen for pointing out this bug.

Comment from Al Viro: use "detached:" prefix to differentiate it from
attached paths.

Reported-by: John Johansen <jjohansen@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2008-06-23 17:35:39.000000000 +0200
+++ linux-2.6/fs/dcache.c	2008-06-23 17:46:05.000000000 +0200
@@ -1828,8 +1828,16 @@ char *__d_path(const struct path *path, 
 
 global_root:
 	retval += 1;	/* hit the slash */
-	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
-		goto Elong;
+
+	if (IS_ROOT(dentry)) {
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

--
