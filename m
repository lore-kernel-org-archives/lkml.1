Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYFPL3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYFPL3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYFPL2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:28:34 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53231 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYFPL2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:28:32 -0400
Message-Id: <20080616112828.731144133@szeredi.hu>
References: <20080616112804.930095761@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 16 Jun 2008 13:28:06 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: [patch 2/3] vfs: fix sys_getcwd for detached mounts
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

After the patch it will give a much saner "/skel" result.

Thanks to John Johansen for pointing out this bug.

Reported-by: John Johansen <jjohansen@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Christoph Hellwig <hch@infradead.org>
---
 fs/dcache.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2008-06-13 13:12:57.000000000 +0200
+++ linux-2.6/fs/dcache.c	2008-06-13 13:13:01.000000000 +0200
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
