Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbYA2STJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbYA2STJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYA2SSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:18:34 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39861 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYA2SSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:18:31 -0500
Message-Id: <20080129181828.450365787@szeredi.hu>
References: <20080129181750.616092886@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 29 Jan 2008 19:17:53 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 3/3] fuse: limit queued background requests
Content-Disposition: inline; filename=fuse_background_limit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Libfuse basically creates a new thread for each new request.  This is
fine for synchronous requests, which are naturally limited.  However
background requests (especially writepage) can cause a thread creation
storm.

To avoid this, limit the number of background requests available to
userspace.

This is done by introducing another queue for background requests, and
a counter for the number of "active" requests, which are currently
available for userspace.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dev.c
===================================================================
--- linux.orig/fs/fuse/dev.c	2008-01-29 17:12:56.000000000 +0100
+++ linux/fs/fuse/dev.c	2008-01-29 17:15:15.000000000 +0100
@@ -201,6 +201,55 @@ void fuse_put_request(struct fuse_conn *
 	}
 }
 
+static unsigned len_args(unsigned numargs, struct fuse_arg *args)
+{
+	unsigned nbytes = 0;
+	unsigned i;
+
+	for (i = 0; i < numargs; i++)
+		nbytes += args[i].size;
+
+	return nbytes;
+}
+
+static u64 fuse_get_unique(struct fuse_conn *fc)
+{
+	fc->reqctr++;
+	/* zero is special */
+	if (fc->reqctr == 0)
+		fc->reqctr = 1;
+
+	return fc->reqctr;
+}
+
+static void queue_request(struct fuse_conn *fc, struct fuse_req *req)
+{
+	req->in.h.unique = fuse_get_unique(fc);
+	req->in.h.len = sizeof(struct fuse_in_header) +
+		len_args(req->in.numargs, (struct fuse_arg *) req->in.args);
+	list_add_tail(&req->list, &fc->pending);
+	req->state = FUSE_REQ_PENDING;
+	if (!req->waiting) {
+		req->waiting = 1;
+		atomic_inc(&fc->num_waiting);
+	}
+	wake_up(&fc->waitq);
+	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
+}
+
+static void flush_bg_queue(struct fuse_conn *fc)
+{
+	while (fc->active_background < FUSE_MAX_BACKGROUND &&
+	       !list_empty(&fc->bg_queue)) {
+		struct fuse_req *req;
+
+		req = list_entry(fc->bg_queue.next, struct fuse_req, list);
+		list_del(&req->list);
+		fc->active_background++;
+		queue_request(fc, req);
+	}
+}
+
 /*
  * This function is called when a request is finished.  Either a reply
  * has arrived or it was aborted (and not yet sent) or some error
@@ -229,6 +278,8 @@ static void request_end(struct fuse_conn
 			clear_bdi_congested(&fc->bdi, WRITE);
 		}
 		fc->num_background--;
+		fc->active_background--;
+		flush_bg_queue(fc);
 	}
 	spin_unlock(&fc->lock);
 	wake_up(&req->waitq);
@@ -320,42 +371,6 @@ static void request_wait_answer(struct f
 	}
 }
 
-static unsigned len_args(unsigned numargs, struct fuse_arg *args)
-{
-	unsigned nbytes = 0;
-	unsigned i;
-
-	for (i = 0; i < numargs; i++)
-		nbytes += args[i].size;
-
-	return nbytes;
-}
-
-static u64 fuse_get_unique(struct fuse_conn *fc)
- {
- 	fc->reqctr++;
- 	/* zero is special */
- 	if (fc->reqctr == 0)
- 		fc->reqctr = 1;
-
-	return fc->reqctr;
-}
-
-static void queue_request(struct fuse_conn *fc, struct fuse_req *req)
-{
-	req->in.h.unique = fuse_get_unique(fc);
-	req->in.h.len = sizeof(struct fuse_in_header) +
-		len_args(req->in.numargs, (struct fuse_arg *) req->in.args);
-	list_add_tail(&req->list, &fc->pending);
-	req->state = FUSE_REQ_PENDING;
-	if (!req->waiting) {
-		req->waiting = 1;
-		atomic_inc(&fc->num_waiting);
-	}
-	wake_up(&fc->waitq);
-	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
-}
-
 void request_send(struct fuse_conn *fc, struct fuse_req *req)
 {
 	req->isreply = 1;
@@ -375,20 +390,26 @@ void request_send(struct fuse_conn *fc, 
 	spin_unlock(&fc->lock);
 }
 
+static void request_send_nowait_locked(struct fuse_conn *fc,
+				       struct fuse_req *req)
+{
+	req->background = 1;
+	fc->num_background++;
+	if (fc->num_background == FUSE_MAX_BACKGROUND)
+		fc->blocked = 1;
+	if (fc->num_background == FUSE_CONGESTION_THRESHOLD) {
+		set_bdi_congested(&fc->bdi, READ);
+		set_bdi_congested(&fc->bdi, WRITE);
+	}
+	list_add_tail(&req->list, &fc->bg_queue);
+	flush_bg_queue(fc);
+}
+
 static void request_send_nowait(struct fuse_conn *fc, struct fuse_req *req)
 {
 	spin_lock(&fc->lock);
 	if (fc->connected) {
-		req->background = 1;
-		fc->num_background++;
-		if (fc->num_background == FUSE_MAX_BACKGROUND)
-			fc->blocked = 1;
-		if (fc->num_background == FUSE_CONGESTION_THRESHOLD) {
-			set_bdi_congested(&fc->bdi, READ);
-			set_bdi_congested(&fc->bdi, WRITE);
-		}
-
-		queue_request(fc, req);
+		request_send_nowait_locked(fc, req);
 		spin_unlock(&fc->lock);
 	} else {
 		req->out.h.error = -ENOTCONN;
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2008-01-29 17:13:06.000000000 +0100
+++ linux/fs/fuse/fuse_i.h	2008-01-29 17:14:23.000000000 +0100
@@ -296,6 +296,12 @@ struct fuse_conn {
 	/** Number of requests currently in the background */
 	unsigned num_background;
 
+	/** Number of background requests currently queued for userspace */
+	unsigned active_background;
+
+	/** The list of background requests set aside for later queuing */
+	struct list_head bg_queue;
+
 	/** Pending interrupts */
 	struct list_head interrupts;
 
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2008-01-29 17:12:56.000000000 +0100
+++ linux/fs/fuse/inode.c	2008-01-29 17:14:23.000000000 +0100
@@ -465,6 +465,7 @@ static struct fuse_conn *new_conn(struct
 		INIT_LIST_HEAD(&fc->processing);
 		INIT_LIST_HEAD(&fc->io);
 		INIT_LIST_HEAD(&fc->interrupts);
+		INIT_LIST_HEAD(&fc->bg_queue);
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;

--
