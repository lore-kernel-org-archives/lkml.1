Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYE2LeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYE2LeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYE2LdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:33:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56688 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYE2LdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:33:15 -0400
Message-Id: <20080529113309.365088543@szeredi.hu>
References: <20080529113245.450308367@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 13:32:47 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       John Johansen <jjohansen@suse.de>
Subject: [patch 2/8] vfs: fix sys_getcwd for detached mounts
Content-Disposition: inline; filename=d_path_fix_detached_path.patch
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

After the patch it will give a much saner "/skel" result.

Thanks to John Johansen for pointing out this bug.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: John Johansen <jjohansen@suse.de>
---
 fs/dcache.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2008-05-29 12:46:22.000000000 +0200
+++ linux-2.6/fs/dcache.c	2008-05-29 12:46:22.000000000 +0200
@@ -1825,10 +1825,20 @@ char *__d_path(const struct path *path, 
 	return retval;
 
 global_root:
-	retval += 1;	/* hit the slash */
-	name = &dentry->d_name;
-	if (prepend(&retval, &buflen, name->name, name->len) != 0)
-		goto Elong;
+	/*
+	 * If this is a root dentry, then overwrite the slash.  This
+	 * will also DTRT with pseudo filesystems which have root
+	 * dentries named "foo:".
+	 *
+	 * Otherwise this is the root of a detached mount, so don't do
+	 * anything.
+	 */
+	if (IS_ROOT(dentry)) {
+		retval += 1;
+		name = &dentry->d_name;
+		if (prepend(&retval, &buflen, name->name, name->len) != 0)
+			goto Elong;
+	}
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	return retval;

--
