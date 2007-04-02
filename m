Return-Path: <linux-kernel-owner+w=401wt.eu-S966004AbXDBWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966004AbXDBWcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966007AbXDBWcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:32:35 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:42056 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966004AbXDBWce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:32:34 -0400
To: tsavola@movial.fi
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net
In-reply-to: <20070402204749.GA11774@movial.fi> (message from Timo Savola on
	Mon, 2 Apr 2007 23:47:54 +0300)
Subject: Re: [PATCH] FUSE: Validate rootmode mount option
References: <20070402204749.GA11774@movial.fi>
Message-Id: <E1HYV47-0002FN-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Apr 2007 00:31:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If rootmode doesn't include any file type bits, we hit the BUG() in
> fuse_init_inode.  Now EINVAL is returned.

Thanks, well spotted.

I'll queue this more complete fix.

Miklos

----
From: Timo Savola <tsavola@movial.fi>
Subject: fuse: validate rootmode mount option

If rootmode isn't valid, we hit the BUG() in fuse_init_inode.  Now
EINVAL is returned.

Signed-off-by: Timo Savola <tsavola@movial.fi>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-03-21 18:44:43.000000000 +0100
+++ linux/fs/fuse/inode.c	2007-04-03 00:01:07.000000000 +0200
@@ -330,6 +330,8 @@ static int parse_fuse_opt(char *opt, str
 		case OPT_ROOTMODE:
 			if (match_octal(&args[0], &value))
 				return 0;
+			if (!fuse_valid_type(value))
+				return 0;
 			d->rootmode = value;
 			d->rootmode_present = 1;
 			break;
Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-03-21 18:44:43.000000000 +0100
+++ linux/fs/fuse/dir.c	2007-04-03 00:00:00.000000000 +0200
@@ -195,7 +195,7 @@ static struct dentry_operations fuse_den
 	.d_revalidate	= fuse_dentry_revalidate,
 };
 
-static int valid_mode(int m)
+int fuse_valid_type(int m)
 {
 	return S_ISREG(m) || S_ISDIR(m) || S_ISLNK(m) || S_ISCHR(m) ||
 		S_ISBLK(m) || S_ISFIFO(m) || S_ISSOCK(m);
@@ -248,7 +248,8 @@ static struct dentry *fuse_lookup(struct
 	fuse_put_request(fc, req);
 	/* Zero nodeid is same as -ENOENT, but with valid timeout */
 	if (!err && outarg.nodeid &&
-	    (invalid_nodeid(outarg.nodeid) || !valid_mode(outarg.attr.mode)))
+	    (invalid_nodeid(outarg.nodeid) ||
+	     !fuse_valid_type(outarg.attr.mode)))
 		err = -EIO;
 	if (!err && outarg.nodeid) {
 		inode = fuse_iget(dir->i_sb, outarg.nodeid, outarg.generation,
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-02-04 19:44:54.000000000 +0100
+++ linux/fs/fuse/fuse_i.h	2007-04-03 00:01:20.000000000 +0200
@@ -552,3 +552,8 @@ int fuse_ctl_add_conn(struct fuse_conn *
  * Remove connection from control filesystem
  */
 void fuse_ctl_remove_conn(struct fuse_conn *fc);
+
+/**
+ * Is file type valid?
+ */
+int fuse_valid_type(int m);
