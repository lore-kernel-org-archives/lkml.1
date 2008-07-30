Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbYGaAUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbYGaAUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762968AbYGaATq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:19:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:37252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763460AbYGaATp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:19:45 -0400
Date: Wed, 30 Jul 2008 16:59:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 42/62] V4L: uvcvideo: Dont free URB buffers on suspend
Message-ID: <20080730235922.GP12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-uvcvideo-don-t-free-urb-buffers-on-suspend.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Laurent Pinchart <laurent.pinchart@skynet.be>

(cherry picked from commit e01117c81676dc9897f567e32cdc13a26e85280b)

V4L: uvcvideo: Don't free URB buffers on suspend.

All submitted URBs must be killed at suspend time, but URB buffers don't
have to be freed. Avoiding a free on suspend/reallocate on resume lowers
the pressure on system memory.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_video.c |   96 ++++++++++++++++++++++++------------
 drivers/media/video/uvc/uvcvideo.h  |    2 
 2 files changed, 66 insertions(+), 32 deletions(-)

--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -554,9 +554,56 @@ static void uvc_video_complete(struct ur
 }
 
 /*
+ * Free transfer buffers.
+ */
+static void uvc_free_urb_buffers(struct uvc_video_device *video)
+{
+	unsigned int i;
+
+	for (i = 0; i < UVC_URBS; ++i) {
+		if (video->urb_buffer[i]) {
+			usb_buffer_free(video->dev->udev, video->urb_size,
+				video->urb_buffer[i], video->urb_dma[i]);
+			video->urb_buffer[i] = NULL;
+		}
+	}
+
+	video->urb_size = 0;
+}
+
+/*
+ * Allocate transfer buffers. This function can be called with buffers
+ * already allocated when resuming from suspend, in which case it will
+ * return without touching the buffers.
+ *
+ * Return 0 on success or -ENOMEM when out of memory.
+ */
+static int uvc_alloc_urb_buffers(struct uvc_video_device *video,
+	unsigned int size)
+{
+	unsigned int i;
+
+	/* Buffers are already allocated, bail out. */
+	if (video->urb_size)
+		return 0;
+
+	for (i = 0; i < UVC_URBS; ++i) {
+		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
+			size, GFP_KERNEL, &video->urb_dma[i]);
+		if (video->urb_buffer[i] == NULL) {
+			uvc_free_urb_buffers(video);
+			return -ENOMEM;
+		}
+	}
+
+	video->urb_size = size;
+	return 0;
+}
+
+/*
  * Uninitialize isochronous/bulk URBs and free transfer buffers.
  */
-static void uvc_uninit_video(struct uvc_video_device *video)
+static void uvc_uninit_video(struct uvc_video_device *video, int free_buffers)
 {
 	struct urb *urb;
 	unsigned int i;
@@ -566,19 +613,12 @@ static void uvc_uninit_video(struct uvc_
 			continue;
 
 		usb_kill_urb(urb);
-		/* urb->transfer_buffer_length is not touched by USB core, so
-		 * we can use it here as the buffer length.
-		 */
-		if (video->urb_buffer[i]) {
-			usb_buffer_free(video->dev->udev,
-				urb->transfer_buffer_length,
-				video->urb_buffer[i], urb->transfer_dma);
-			video->urb_buffer[i] = NULL;
-		}
-
 		usb_free_urb(urb);
 		video->urb[i] = NULL;
 	}
+
+	if (free_buffers)
+		uvc_free_urb_buffers(video);
 }
 
 /*
@@ -610,18 +650,13 @@ static int uvc_init_video_isoc(struct uv
 
 	size = npackets * psize;
 
+	if (uvc_alloc_urb_buffers(video, size) < 0)
+		return -ENOMEM;
+
 	for (i = 0; i < UVC_URBS; ++i) {
 		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
-			uvc_uninit_video(video);
-			return -ENOMEM;
-		}
-
-		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
-			size, gfp_flags, &urb->transfer_dma);
-		if (video->urb_buffer[i] == NULL) {
-			usb_free_urb(urb);
-			uvc_uninit_video(video);
+			uvc_uninit_video(video, 1);
 			return -ENOMEM;
 		}
 
@@ -632,6 +667,7 @@ static int uvc_init_video_isoc(struct uv
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 		urb->interval = ep->desc.bInterval;
 		urb->transfer_buffer = video->urb_buffer[i];
+		urb->transfer_dma = video->urb_dma[i];
 		urb->complete = uvc_video_complete;
 		urb->number_of_packets = npackets;
 		urb->transfer_buffer_length = size;
@@ -671,20 +707,15 @@ static int uvc_init_video_bulk(struct uv
 	if (size > psize * UVC_MAX_ISO_PACKETS)
 		size = psize * UVC_MAX_ISO_PACKETS;
 
+	if (uvc_alloc_urb_buffers(video, size) < 0)
+		return -ENOMEM;
+
 	pipe = usb_rcvbulkpipe(video->dev->udev, ep->desc.bEndpointAddress);
 
 	for (i = 0; i < UVC_URBS; ++i) {
 		urb = usb_alloc_urb(0, gfp_flags);
 		if (urb == NULL) {
-			uvc_uninit_video(video);
-			return -ENOMEM;
-		}
-
-		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
-			size, gfp_flags, &urb->transfer_dma);
-		if (video->urb_buffer[i] == NULL) {
-			usb_free_urb(urb);
-			uvc_uninit_video(video);
+			uvc_uninit_video(video, 1);
 			return -ENOMEM;
 		}
 
@@ -692,6 +723,7 @@ static int uvc_init_video_bulk(struct uv
 			video->urb_buffer[i], size, uvc_video_complete,
 			video);
 		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_dma = video->urb_dma[i];
 
 		video->urb[i] = urb;
 	}
@@ -766,7 +798,7 @@ static int uvc_init_video(struct uvc_vid
 		if ((ret = usb_submit_urb(video->urb[i], gfp_flags)) < 0) {
 			uvc_printk(KERN_ERR, "Failed to submit URB %u "
 					"(%d).\n", i, ret);
-			uvc_uninit_video(video);
+			uvc_uninit_video(video, 1);
 			return ret;
 		}
 	}
@@ -791,7 +823,7 @@ int uvc_video_suspend(struct uvc_video_d
 		return 0;
 
 	video->frozen = 1;
-	uvc_uninit_video(video);
+	uvc_uninit_video(video, 0);
 	usb_set_interface(video->dev->udev, video->streaming->intfnum, 0);
 	return 0;
 }
@@ -920,7 +952,7 @@ int uvc_video_enable(struct uvc_video_de
 	int ret;
 
 	if (!enable) {
-		uvc_uninit_video(video);
+		uvc_uninit_video(video, 1);
 		usb_set_interface(video->dev->udev,
 			video->streaming->intfnum, 0);
 		uvc_queue_enable(&video->queue, 0);
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -602,6 +602,8 @@ struct uvc_video_device {
 
 	struct urb *urb[UVC_URBS];
 	char *urb_buffer[UVC_URBS];
+	dma_addr_t urb_dma[UVC_URBS];
+	unsigned int urb_size;
 
 	__u8 last_fid;
 };

-- 
