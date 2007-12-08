Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbXLHNfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbXLHNfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 08:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXLHNfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 08:35:23 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:64695 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbXLHNfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 08:35:22 -0500
Date: Sat, 8 Dec 2007 14:35:06 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: hverkuil@xs4all.nl, mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071208133712.28347.12998.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] ivtv: Some general fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "warning: Using plain integer as NULL pointer".
Convert 'x < y ? x : y' to use min() instead.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
Compile-tested on i386 with "allyesconfig" and "allmodconfig".
Resend, since the 'Remove a gcc-2.95 requirement'-part is taken away.
Was sent 2007-12-04

 ivtv-driver.c  |    2 +-
 ivtv-ioctl.c   |    2 +-
 ivtv-irq.c     |    4 ++--
 ivtv-streams.c |    4 ++--
 ivtvfb.c       |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)


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
