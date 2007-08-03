Return-Path: <linux-kernel-owner+w=401wt.eu-S1764592AbXHCRuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764592AbXHCRuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764613AbXHCRtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:49:55 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:34687 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764096AbXHCRtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:49:53 -0400
Message-Id: <20070803174914.002759597@szeredi.hu>
References: <20070803174425.998083527@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 19:44:27 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 01/11] fuse: update backing_dev_info congestion state
Content-Disposition: inline; filename=fuse_congestion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Set the read and write congestion state if the request queue is close
to blocking, and clear it when it's not.

This prevents unnecessary blocking in readahead and (when writable
mmaps are allowed) writeback.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dev.c
===================================================================
--- linux.orig/fs/fuse/dev.c	2007-08-03 17:54:50.000000000 +0200
+++ linux/fs/fuse/dev.c	2007-08-03 17:54:53.000000000 +0200
@@ -224,6 +224,10 @@ static void request_end(struct fuse_conn
 			fc->blocked = 0;
 			wake_up_all(&fc->blocked_waitq);
 		}
+		if (fc->num_background == FUSE_CONGESTION_THRESHOLD) {
+			clear_bdi_congested(&fc->bdi, READ);
+			clear_bdi_congested(&fc->bdi, WRITE);
+		}
 		fc->num_background--;
 	}
 	spin_unlock(&fc->lock);
@@ -378,6 +382,10 @@ static void request_send_nowait(struct f
 		fc->num_background++;
 		if (fc->num_background == FUSE_MAX_BACKGROUND)
 			fc->blocked = 1;
+		if (fc->num_background == FUSE_CONGESTION_THRESHOLD) {
+			set_bdi_congested(&fc->bdi, READ);
+			set_bdi_congested(&fc->bdi, WRITE);
+		}
 
 		queue_request(fc, req);
 		spin_unlock(&fc->lock);
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-08-03 17:54:50.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-08-03 17:54:53.000000000 +0200
@@ -20,7 +20,10 @@
 #define FUSE_MAX_PAGES_PER_REQ 32
 
 /** Maximum number of outstanding background requests */
-#define FUSE_MAX_BACKGROUND 10
+#define FUSE_MAX_BACKGROUND 12
+
+/** Congestion starts at 75% of maximum */
+#define FUSE_CONGESTION_THRESHOLD (FUSE_MAX_BACKGROUND * 75 / 100)
 
 /** It could be as large as PATH_MAX, but would that have any uses? */
 #define FUSE_NAME_MAX 1024

--
