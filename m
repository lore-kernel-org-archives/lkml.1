Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbYEUAdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbYEUAdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757808AbYEUAbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:31:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45308 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765071AbYEUAbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:31:42 -0400
To: mchehab@infradead.org
Subject: [PATCH] ivtv: trivial annotations
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycF3-0004p2-Qw@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:31:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/ivtv/ivtv-driver.h  |   10 ++++++++--
 drivers/media/video/ivtv/ivtv-fileops.c |    2 +-
 drivers/media/video/ivtv/ivtv-irq.c     |    8 ++++----
 drivers/media/video/ivtv/ivtv-queue.c   |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.c     |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.h     |    2 +-
 6 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index ba06e81..9d23b1e 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -259,6 +259,12 @@ struct ivtv_mailbox_data {
 
 /* Scatter-Gather array element, used in DMA transfers */
 struct ivtv_sg_element {
+	__le32 src;
+	__le32 dst;
+	__le32 size;
+};
+
+struct ivtv_sg_host_element {
 	u32 src;
 	u32 dst;
 	u32 size;
@@ -349,8 +355,8 @@ struct ivtv_stream {
 	u16 dma_xfer_cnt;
 
 	/* Base Dev SG Array for cx23415/6 */
-	struct ivtv_sg_element *sg_pending;
-	struct ivtv_sg_element *sg_processing;
+	struct ivtv_sg_host_element *sg_pending;
+	struct ivtv_sg_host_element *sg_processing;
 	struct ivtv_sg_element *sg_dma;
 	dma_addr_t sg_handle;
 	int sg_pending_size;
diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index f2fa434..db813e0 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -587,7 +587,7 @@ retry:
 	since we may get here before the stream has been fully set-up */
 	if (mode == OUT_YUV && s->q_full.length == 0 && itv->dma_data_req_size) {
 		while (count >= itv->dma_data_req_size) {
-			if (!ivtv_yuv_udma_stream_frame (itv, (void *)user_buf)) {
+			if (!ivtv_yuv_udma_stream_frame (itv, (void __user *)user_buf)) {
 				bytes_written += itv->dma_data_req_size;
 				user_buf += itv->dma_data_req_size;
 				count -= itv->dma_data_req_size;
diff --git a/drivers/media/video/ivtv/ivtv-irq.c b/drivers/media/video/ivtv/ivtv-irq.c
index d8ba3a4..fba150a 100644
--- a/drivers/media/video/ivtv/ivtv-irq.c
+++ b/drivers/media/video/ivtv/ivtv-irq.c
@@ -231,14 +231,14 @@ static void dma_post(struct ivtv_stream *s)
 	struct ivtv_buffer *buf = NULL;
 	struct list_head *p;
 	u32 offset;
-	u32 *u32buf;
+	__le32 *u32buf;
 	int x = 0;
 
 	IVTV_DEBUG_HI_DMA("%s %s completed (%x)\n", ivtv_use_pio(s) ? "PIO" : "DMA",
 			s->name, s->dma_offset);
 	list_for_each(p, &s->q_dma.list) {
 		buf = list_entry(p, struct ivtv_buffer, list);
-		u32buf = (u32 *)buf->buf;
+		u32buf = (__le32 *)buf->buf;
 
 		/* Sync Buffer */
 		ivtv_buf_sync_for_cpu(s, buf);
@@ -444,7 +444,7 @@ static void ivtv_dma_enc_start(struct ivtv_stream *s)
 	}
 
 	s->dma_xfer_cnt++;
-	memcpy(s->sg_processing, s->sg_pending, sizeof(struct ivtv_sg_element) * s->sg_pending_size);
+	memcpy(s->sg_processing, s->sg_pending, sizeof(struct ivtv_sg_host_element) * s->sg_pending_size);
 	s->sg_processing_size = s->sg_pending_size;
 	s->sg_pending_size = 0;
 	s->sg_processed = 0;
@@ -473,7 +473,7 @@ static void ivtv_dma_dec_start(struct ivtv_stream *s)
 	if (s->q_predma.bytesused)
 		ivtv_queue_move(s, &s->q_predma, NULL, &s->q_dma, s->q_predma.bytesused);
 	s->dma_xfer_cnt++;
-	memcpy(s->sg_processing, s->sg_pending, sizeof(struct ivtv_sg_element) * s->sg_pending_size);
+	memcpy(s->sg_processing, s->sg_pending, sizeof(struct ivtv_sg_host_element) * s->sg_pending_size);
 	s->sg_processing_size = s->sg_pending_size;
 	s->sg_pending_size = 0;
 	s->sg_processed = 0;
diff --git a/drivers/media/video/ivtv/ivtv-queue.c b/drivers/media/video/ivtv/ivtv-queue.c
index fc8b1ea..71bd13e 100644
--- a/drivers/media/video/ivtv/ivtv-queue.c
+++ b/drivers/media/video/ivtv/ivtv-queue.c
@@ -193,7 +193,7 @@ void ivtv_flush_queues(struct ivtv_stream *s)
 int ivtv_stream_alloc(struct ivtv_stream *s)
 {
 	struct ivtv *itv = s->itv;
-	int SGsize = sizeof(struct ivtv_sg_element) * s->buffers;
+	int SGsize = sizeof(struct ivtv_sg_host_element) * s->buffers;
 	int i;
 
 	if (s->buffers == 0)
diff --git a/drivers/media/video/ivtv/ivtv-yuv.c b/drivers/media/video/ivtv/ivtv-yuv.c
index a9417f6..3092ff1 100644
--- a/drivers/media/video/ivtv/ivtv-yuv.c
+++ b/drivers/media/video/ivtv/ivtv-yuv.c
@@ -1116,7 +1116,7 @@ void ivtv_yuv_setup_stream_frame(struct ivtv *itv)
 }
 
 /* Attempt to dma a frame from a user buffer */
-int ivtv_yuv_udma_stream_frame(struct ivtv *itv, void *src)
+int ivtv_yuv_udma_stream_frame(struct ivtv *itv, void __user *src)
 {
 	struct yuv_playback_info *yi = &itv->yuv_info;
 	struct ivtv_dma_frame dma_args;
diff --git a/drivers/media/video/ivtv/ivtv-yuv.h b/drivers/media/video/ivtv/ivtv-yuv.h
index 2fe5f12..ca5173f 100644
--- a/drivers/media/video/ivtv/ivtv-yuv.h
+++ b/drivers/media/video/ivtv/ivtv-yuv.h
@@ -35,7 +35,7 @@ extern const u32 yuv_offset[IVTV_YUV_BUFFERS];
 
 int ivtv_yuv_filter_check(struct ivtv *itv);
 void ivtv_yuv_setup_stream_frame(struct ivtv *itv);
-int ivtv_yuv_udma_stream_frame(struct ivtv *itv, void *src);
+int ivtv_yuv_udma_stream_frame(struct ivtv *itv, void __user *src);
 void ivtv_yuv_frame_complete(struct ivtv *itv);
 int ivtv_yuv_prep_frame(struct ivtv *itv, struct ivtv_dma_frame *args);
 void ivtv_yuv_close(struct ivtv *itv);
-- 
1.5.3.GIT


