Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYEQTfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYEQTfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYEQTfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:35:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52486 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbYEQTfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:35:08 -0400
Date: Sat, 17 May 2008 12:34:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "koos vriezen" <koos.vriezen@gmail.com>, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: mplayer v4l hangs in 2.6.25.2/4    (likely regression)
Message-ID: <20080517123452.79b82be2@infradead.org>
In-Reply-To: <20080517122640.2d15aeed@infradead.org>
References: <d4e708d60805170954n6b2044c7h306bc6cb76bf798d@mail.gmail.com>
	<20080517111639.21a3e177@infradead.org>
	<d4e708d60805171211q1a1966a3i78dc3dc98d275dd1@mail.gmail.com>
	<20080517122640.2d15aeed@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



and here is an (untest) patch that should fix this problem:
Koos, can you apply this to your kernel tree and report back if this
fixes your deadlock?



From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] Fix a deadlock in the bttv driver

vidiocgmbuf() does this:
        mutex_lock(&fh->cap.vb_lock);
        retval = videobuf_mmap_setup(&fh->cap, gbuffers, gbufsize,
                                     V4L2_MEMORY_MMAP);

and videobuf_mmap_setup() then just does
        mutex_lock(&q->vb_lock);
        ret = __videobuf_mmap_setup(q, bcount, bsize, memory);
        mutex_unlock(&q->vb_lock);

which is an obvious double-take deadlock.

This patch fixes this by having vidiocgmbuf() just call the __videobuf_mmap_setup
function instead.

Reported-by: Koos Vriezen <koos.vriezen@gmail.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/media/video/bt8xx/bttv-driver.c |    2 +-
 drivers/media/video/videobuf-core.c     |    3 ++-
 include/media/videobuf-core.h           |    3 +++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 2ca3e9c..0165aac 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -2613,7 +2613,7 @@ static int vidiocgmbuf(struct file *file, void *priv, struct video_mbuf *mbuf)
 	struct bttv_fh *fh = priv;
 
 	mutex_lock(&fh->cap.vb_lock);
-	retval = videobuf_mmap_setup(&fh->cap, gbuffers, gbufsize,
+	retval = __videobuf_mmap_setup(&fh->cap, gbuffers, gbufsize,
 				     V4L2_MEMORY_MMAP);
 	if (retval < 0) {
 		mutex_unlock(&fh->cap.vb_lock);
diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 982f446..0a88c44 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -331,7 +331,7 @@ int videobuf_mmap_free(struct videobuf_queue *q)
 }
 
 /* Locking: Caller holds q->vb_lock */
-static int __videobuf_mmap_setup(struct videobuf_queue *q,
+int __videobuf_mmap_setup(struct videobuf_queue *q,
 			unsigned int bcount, unsigned int bsize,
 			enum v4l2_memory memory)
 {
@@ -1129,6 +1129,7 @@ EXPORT_SYMBOL_GPL(videobuf_read_stream);
 EXPORT_SYMBOL_GPL(videobuf_read_one);
 EXPORT_SYMBOL_GPL(videobuf_poll_stream);
 
+EXPORT_SYMBOL_GPL(__videobuf_mmap_setup);
 EXPORT_SYMBOL_GPL(videobuf_mmap_setup);
 EXPORT_SYMBOL_GPL(videobuf_mmap_free);
 EXPORT_SYMBOL_GPL(videobuf_mmap_mapper);
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index 5b39a22..874f134 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -237,6 +237,9 @@ unsigned int videobuf_poll_stream(struct file *file,
 int videobuf_mmap_setup(struct videobuf_queue *q,
 			unsigned int bcount, unsigned int bsize,
 			enum v4l2_memory memory);
+int __videobuf_mmap_setup(struct videobuf_queue *q,
+			unsigned int bcount, unsigned int bsize,
+			enum v4l2_memory memory);
 int videobuf_mmap_free(struct videobuf_queue *q);
 int videobuf_mmap_mapper(struct videobuf_queue *q,
 			 struct vm_area_struct *vma);
-- 
1.5.4.5

