Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXJMHZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXJMHZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXJMHZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:25:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37412 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762015AbXJMHZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:25:27 -0400
Date: Sat, 13 Oct 2007 08:25:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] v4l: copy_to_user() is not a good method name
Message-ID: <20071013072524.GF8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Breaks on any target that has copy_to_user() defined as a non-trivial
macro.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index c606332..5599a36 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -674,7 +674,7 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
 	}
 
 	/* Copy to userspace */
-	retval=CALL(q,copy_to_user,q,data,count,nonblocking);
+	retval=CALL(q,video_copy_to_user,q,data,count,nonblocking);
 	if (retval<0)
 		goto done;
 
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 8bb7fdd..3eb6123 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -670,7 +670,7 @@ static struct videobuf_qtype_ops pci_ops = {
 	.sync         = __videobuf_sync,
 	.mmap_free    = __videobuf_mmap_free,
 	.mmap_mapper  = __videobuf_mmap_mapper,
-	.copy_to_user = __videobuf_copy_to_user,
+	.video_copy_to_user = __videobuf_copy_to_user,
 	.copy_stream  = __videobuf_copy_stream,
 };
 
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index 2e3689a..cd74341 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -320,7 +320,7 @@ static struct videobuf_qtype_ops qops = {
 	.sync         = __videobuf_sync,
 	.mmap_free    = __videobuf_mmap_free,
 	.mmap_mapper  = __videobuf_mmap_mapper,
-	.copy_to_user = __videobuf_copy_to_user,
+	.video_copy_to_user = __videobuf_copy_to_user,
 	.copy_stream  = __videobuf_copy_stream,
 };
 
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index 9fa09fb..0fa5d59 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -133,7 +133,7 @@ struct videobuf_qtype_ops {
 				 enum v4l2_memory memory);
 	int (*sync)		(struct videobuf_queue* q,
 				 struct videobuf_buffer *buf);
-	int (*copy_to_user)	(struct videobuf_queue *q,
+	int (*video_copy_to_user)(struct videobuf_queue *q,
 				 char __user *data,
 				 size_t count,
 				 int nonblocking);
