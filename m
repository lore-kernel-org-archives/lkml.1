Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbXLBRrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbXLBRrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 12:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbXLBRrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 12:47:12 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:50702 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbXLBRrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 12:47:11 -0500
Date: Sun, 2 Dec 2007 18:46:55 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: hverkuil@xs4all.nl, mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071202173329.15374.4223.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH 1/2] ivtv: Some general fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "warning: Using plain integer as NULL pointer".
Remove a gcc-2.95 requirement.
Convert 'x < y ? x : y' to use min() instead.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested on i386 with "allyesconfig" and "allmodconfig".

 ivtv-driver.c  |    2 +-
 ivtv-driver.h  |    4 +---
 ivtv-ioctl.c   |    2 +-
 ivtv-irq.c     |    4 ++--
 ivtv-streams.c |    4 ++--
 ivtvfb.c       |    2 +-
 6 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 6d2dd87..96f340c 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -979,7 +979,7 @@ static int __devinit ivtv_probe(struct pci_dev *dev,
 	}
 
 	itv = kzalloc(sizeof(struct ivtv), GFP_ATOMIC);
-	if (itv == 0) {
+	if (itv == NULL) {
 		spin_unlock(&ivtv_cards_lock);
 		return -ENOMEM;
 	}
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index 49ce14d..5c4956c 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -132,12 +132,10 @@ extern int ivtv_debug;
 /* Flag to turn on high volume debugging */
 #define IVTV_DBGFLG_HIGHVOL (1 << 10)
 
-/* NOTE: extra space before comma in 'itv->num , ## args' is required for
-   gcc-2.95, otherwise it won't compile. */
 #define IVTV_DEBUG(x, type, fmt, args...) \
 	do { \
 		if ((x) & ivtv_debug) \
-			printk(KERN_INFO "ivtv%d " type ": " fmt, itv->num , ## args); \
+			printk(KERN_INFO "ivtv%d " type ": " fmt, itv->num, ## args); \
 	} while (0)
 #define IVTV_DEBUG_WARN(fmt, args...)  IVTV_DEBUG(IVTV_DBGFLG_WARN,  "warn",  fmt , ## args)
 #define IVTV_DEBUG_INFO(fmt, args...)  IVTV_DEBUG(IVTV_DBGFLG_INFO,  "info",  fmt , ## args)
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index fd6826f..24270de 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -688,7 +688,7 @@ static int ivtv_debug_ioctls(struct file *filp, unsigned int cmd, void *arg)
 			ivtv_reset_ir_gpio(itv);
 		}
 		if (val & 0x02) {
-			itv->video_dec_func(itv, cmd, 0);
+			itv->video_dec_func(itv, cmd, NULL);
 		}
 		break;
 	}
diff --git a/drivers/media/video/ivtv/ivtv-irq.c b/drivers/media/video/ivtv/ivtv-irq.c
index fd1688e..1384615 100644
--- a/drivers/media/video/ivtv/ivtv-irq.c
+++ b/drivers/media/video/ivtv/ivtv-irq.c
@@ -204,7 +204,7 @@ static int stream_enc_dma_append(struct ivtv_stream *s, u32 data[CX2341X_MBOX_MA
 		s->sg_pending[idx].dst = buf->dma_handle;
 		s->sg_pending[idx].src = offset;
 		s->sg_pending[idx].size = s->buf_size;
-		buf->bytesused = (size < s->buf_size) ? size : s->buf_size;
+		buf->bytesused = min(size, s->buf_size);
 		buf->dma_xfer_cnt = s->dma_xfer_cnt;
 
 		s->q_predma.bytesused += buf->bytesused;
@@ -705,7 +705,7 @@ static void ivtv_irq_dec_data_req(struct ivtv *itv)
 		s = &itv->streams[IVTV_DEC_STREAM_TYPE_YUV];
 	}
 	else {
-		itv->dma_data_req_size = data[2] >= 0x10000 ? 0x10000 : data[2];
+		itv->dma_data_req_size = min_t(u32, data[2], 0x10000);
 		itv->dma_data_req_offset = data[1];
 		s = &itv->streams[IVTV_DEC_STREAM_TYPE_MPG];
 	}
diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
index aa03e61..0e9e7d0 100644
--- a/drivers/media/video/ivtv/ivtv-streams.c
+++ b/drivers/media/video/ivtv/ivtv-streams.c
@@ -572,10 +572,10 @@ int ivtv_start_v4l2_encode_stream(struct ivtv_stream *s)
 		clear_bit(IVTV_F_I_EOS, &itv->i_flags);
 
 		/* Initialize Digitizer for Capture */
-		itv->video_dec_func(itv, VIDIOC_STREAMOFF, 0);
+		itv->video_dec_func(itv, VIDIOC_STREAMOFF, NULL);
 		ivtv_msleep_timeout(300, 1);
 		ivtv_vapi(itv, CX2341X_ENC_INITIALIZE_INPUT, 0);
-		itv->video_dec_func(itv, VIDIOC_STREAMON, 0);
+		itv->video_dec_func(itv, VIDIOC_STREAMON, NULL);
 	}
 
 	/* begin_capture */
diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
index 52ffd15..f73ce98 100644
--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -1053,7 +1053,7 @@ static int ivtvfb_init_card(struct ivtv *itv)
 	}
 
 	itv->osd_info = kzalloc(sizeof(struct osd_info), GFP_ATOMIC);
-	if (itv->osd_info == 0) {
+	if (itv->osd_info == NULL) {
 		IVTVFB_ERR("Failed to allocate memory for osd_info\n");
 		return -ENOMEM;
 	}
