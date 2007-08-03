Return-Path: <linux-kernel-owner+w=401wt.eu-S932548AbXHCRyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbXHCRyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764717AbXHCRue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:50:34 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:34827 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764024AbXHCRuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:50:32 -0400
Message-Id: <20070803174950.187746190@szeredi.hu>
References: <20070803174425.998083527@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 19:44:35 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 09/11] fuse: cleanup in release
Content-Disposition: inline; filename=fuse_release_end.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move dput/mntput pair from request_end() to fuse_release_end(),
because there's no other place they are used.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dev.c
===================================================================
--- linux.orig/fs/fuse/dev.c	2007-08-03 18:36:01.000000000 +0200
+++ linux/fs/fuse/dev.c	2007-08-03 18:37:24.000000000 +0200
@@ -231,8 +231,6 @@ static void request_end(struct fuse_conn
 		fc->num_background--;
 	}
 	spin_unlock(&fc->lock);
-	dput(req->dentry);
-	mntput(req->vfsmount);
 	wake_up(&req->waitq);
 	if (end)
 		end(fc, req);
Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-08-03 18:36:15.000000000 +0200
+++ linux/fs/fuse/file.c	2007-08-03 18:37:24.000000000 +0200
@@ -71,11 +71,19 @@ static struct fuse_file *fuse_file_get(s
 	return ff;
 }
 
+static void fuse_release_end(struct fuse_conn *fc, struct fuse_req *req)
+{
+	dput(req->dentry);
+	mntput(req->vfsmount);
+	fuse_put_request(fc, req);
+}
+
 static void fuse_file_put(struct fuse_file *ff)
 {
 	if (atomic_dec_and_test(&ff->count)) {
 		struct fuse_req *req = ff->reserved_req;
 		struct fuse_conn *fc = get_fuse_conn(req->dentry->d_inode);
+		req->end = fuse_release_end;
 		request_send_background(fc, req);
 		kfree(ff);
 	}

--
