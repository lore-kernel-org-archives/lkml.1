Return-Path: <linux-kernel-owner+w=401wt.eu-S1764786AbXHCRuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764786AbXHCRuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764512AbXHCRt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:49:56 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:50605 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764616AbXHCRtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:49:55 -0400
Message-Id: <20070803174915.551760695@szeredi.hu>
References: <20070803174425.998083527@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 19:44:28 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 02/11] fuse: fix reserved request wake up
Content-Disposition: inline; filename=fuse_wake_up_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Use wake_up_all instead of wake_up in put_reserved_req(), otherwise it
is possible that the right task is not woken up.

Also create a separate reserved_req_waitq in addition to the
blocked_waitq, since they fulfill totally separate functions.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dev.c
===================================================================
--- linux.orig/fs/fuse/dev.c	2007-08-03 17:54:53.000000000 +0200
+++ linux/fs/fuse/dev.c	2007-08-03 17:54:54.000000000 +0200
@@ -129,7 +129,7 @@ static struct fuse_req *get_reserved_req
 	struct fuse_file *ff = file->private_data;
 
 	do {
-		wait_event(fc->blocked_waitq, ff->reserved_req);
+		wait_event(fc->reserved_req_waitq, ff->reserved_req);
 		spin_lock(&fc->lock);
 		if (ff->reserved_req) {
 			req = ff->reserved_req;
@@ -155,7 +155,7 @@ static void put_reserved_req(struct fuse
 	fuse_request_init(req);
 	BUG_ON(ff->reserved_req);
 	ff->reserved_req = req;
-	wake_up(&fc->blocked_waitq);
+	wake_up_all(&fc->reserved_req_waitq);
 	spin_unlock(&fc->lock);
 	fput(file);
 }
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-08-03 17:54:53.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-08-03 17:54:54.000000000 +0200
@@ -289,6 +289,9 @@ struct fuse_conn {
 	/** waitq for blocked connection */
 	wait_queue_head_t blocked_waitq;
 
+	/** waitq for reserved requests */
+	wait_queue_head_t reserved_req_waitq;
+
 	/** The next unique request id */
 	u64 reqctr;
 
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-08-03 17:54:50.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-08-03 17:54:54.000000000 +0200
@@ -232,6 +232,7 @@ static void fuse_put_super(struct super_
 	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
 	wake_up_all(&fc->waitq);
 	wake_up_all(&fc->blocked_waitq);
+	wake_up_all(&fc->reserved_req_waitq);
 	mutex_lock(&fuse_mutex);
 	list_del(&fc->entry);
 	fuse_ctl_remove_conn(fc);
@@ -426,6 +427,7 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->count, 1);
 		init_waitqueue_head(&fc->waitq);
 		init_waitqueue_head(&fc->blocked_waitq);
+		init_waitqueue_head(&fc->reserved_req_waitq);
 		INIT_LIST_HEAD(&fc->pending);
 		INIT_LIST_HEAD(&fc->processing);
 		INIT_LIST_HEAD(&fc->io);

--
