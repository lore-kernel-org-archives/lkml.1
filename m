Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbXJXLQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbXJXLQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbXJXLOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:14:47 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:45460 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbXJXLOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:14:45 -0400
Message-Id: <20071024111428.100395398@szeredi.hu>
References: <20071024111333.530227696@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 24 Oct 2007 13:13:36 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/5] fuse: cleanup: add fuse_get_attr_version()
Content-Disposition: inline; filename=fuse_attr_version_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Extract repeated code into helper function, as suggested by Akpm.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-10-19 16:46:33.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-10-19 17:04:15.000000000 +0200
@@ -132,6 +132,21 @@ static void fuse_lookup_init(struct fuse
 	req->out.args[0].value = outarg;
 }
 
+static u64 fuse_get_attr_version(struct fuse_conn *fc)
+{
+	u64 curr_version;
+
+	/*
+	 * The spin lock isn't actually needed on 64bit archs, but we
+	 * don't yet care too much about such optimizations.
+	 */
+	spin_lock(&fc->lock);
+	curr_version = fc->attr_version;
+	spin_unlock(&fc->lock);
+
+	return curr_version;
+}
+
 /*
  * Check whether the dentry is still valid
  *
@@ -171,9 +186,7 @@ static int fuse_dentry_revalidate(struct
 			return 0;
 		}
 
-		spin_lock(&fc->lock);
-		attr_version = fc->attr_version;
-		spin_unlock(&fc->lock);
+		attr_version = fuse_get_attr_version(fc);
 
 		parent = dget_parent(entry);
 		fuse_lookup_init(req, parent->d_inode, entry, &outarg);
@@ -264,9 +277,7 @@ static struct dentry *fuse_lookup(struct
 		return ERR_PTR(PTR_ERR(forget_req));
 	}
 
-	spin_lock(&fc->lock);
-	attr_version = fc->attr_version;
-	spin_unlock(&fc->lock);
+	attr_version = fuse_get_attr_version(fc);
 
 	fuse_lookup_init(req, dir, entry, &outarg);
 	request_send(fc, req);
@@ -733,9 +744,7 @@ static int fuse_do_getattr(struct inode 
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	spin_lock(&fc->lock);
-	attr_version = fc->attr_version;
-	spin_unlock(&fc->lock);
+	attr_version = fuse_get_attr_version(fc);
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));

--
