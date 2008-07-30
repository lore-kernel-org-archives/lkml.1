Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbYGaAU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbYGaAU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762979AbYGaATX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:19:23 -0400
Received: from ns.suse.de ([195.135.220.2]:39199 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762882AbYGaATV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:19:21 -0400
Date: Wed, 30 Jul 2008 16:59:20 -0700
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
Subject: [patch 41/62] V4L: uvcvideo: Use GFP_NOIO when allocating memory
	during resume
Message-ID: <20080730235920.GO12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-uvcvideo-use-gfp_noio-when-allocating-memory-during-resume.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Laurent Pinchart <laurent.pinchart@skynet.be>

(cherry picked from commit 291358785cde5536d98a4f3cae77efd8ca626486)

V4L: uvcvideo: Use GFP_NOIO when allocating memory during resume

The swap device might still be asleep, so memory allocated in the resume
handler must use GFP_NOIO. Thanks to Oliver Neukum for catching and reporting
this bug.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_status.c |    2 +-
 drivers/media/video/uvc/uvc_video.c  |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/media/video/uvc/uvc_status.c
+++ b/drivers/media/video/uvc/uvc_status.c
@@ -203,5 +203,5 @@ int uvc_status_resume(struct uvc_device 
 	if (dev->int_urb == NULL)
 		return 0;
 
-	return usb_submit_urb(dev->int_urb, GFP_KERNEL);
+	return usb_submit_urb(dev->int_urb, GFP_NOIO);
 }
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -586,7 +586,7 @@ static void uvc_uninit_video(struct uvc_
  * is given by the endpoint.
  */
 static int uvc_init_video_isoc(struct uvc_video_device *video,
-	struct usb_host_endpoint *ep)
+	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
 	unsigned int npackets, i, j;
@@ -611,14 +611,14 @@ static int uvc_init_video_isoc(struct uv
 	size = npackets * psize;
 
 	for (i = 0; i < UVC_URBS; ++i) {
-		urb = usb_alloc_urb(npackets, GFP_KERNEL);
+		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
 			uvc_uninit_video(video);
 			return -ENOMEM;
 		}
 
 		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
-			size, GFP_KERNEL, &urb->transfer_dma);
+			size, gfp_flags, &urb->transfer_dma);
 		if (video->urb_buffer[i] == NULL) {
 			usb_free_urb(urb);
 			uvc_uninit_video(video);
@@ -652,7 +652,7 @@ static int uvc_init_video_isoc(struct uv
  * given by the endpoint.
  */
 static int uvc_init_video_bulk(struct uvc_video_device *video,
-	struct usb_host_endpoint *ep)
+	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
 	unsigned int pipe, i;
@@ -674,14 +674,14 @@ static int uvc_init_video_bulk(struct uv
 	pipe = usb_rcvbulkpipe(video->dev->udev, ep->desc.bEndpointAddress);
 
 	for (i = 0; i < UVC_URBS; ++i) {
-		urb = usb_alloc_urb(0, GFP_KERNEL);
+		urb = usb_alloc_urb(0, gfp_flags);
 		if (urb == NULL) {
 			uvc_uninit_video(video);
 			return -ENOMEM;
 		}
 
 		video->urb_buffer[i] = usb_buffer_alloc(video->dev->udev,
-			size, GFP_KERNEL, &urb->transfer_dma);
+			size, gfp_flags, &urb->transfer_dma);
 		if (video->urb_buffer[i] == NULL) {
 			usb_free_urb(urb);
 			uvc_uninit_video(video);
@@ -702,7 +702,7 @@ static int uvc_init_video_bulk(struct uv
 /*
  * Initialize isochronous/bulk URBs and allocate transfer buffers.
  */
-static int uvc_init_video(struct uvc_video_device *video)
+static int uvc_init_video(struct uvc_video_device *video, gfp_t gfp_flags)
 {
 	struct usb_interface *intf = video->streaming->intf;
 	struct usb_host_interface *alts;
@@ -747,7 +747,7 @@ static int uvc_init_video(struct uvc_vid
 		if ((ret = usb_set_interface(video->dev->udev, intfnum, i)) < 0)
 			return ret;
 
-		ret = uvc_init_video_isoc(video, ep);
+		ret = uvc_init_video_isoc(video, ep, gfp_flags);
 	} else {
 		/* Bulk endpoint, proceed to URB initialization. */
 		ep = uvc_find_endpoint(&intf->altsetting[0],
@@ -755,7 +755,7 @@ static int uvc_init_video(struct uvc_vid
 		if (ep == NULL)
 			return -EIO;
 
-		ret = uvc_init_video_bulk(video, ep);
+		ret = uvc_init_video_bulk(video, ep, gfp_flags);
 	}
 
 	if (ret < 0)
@@ -763,7 +763,7 @@ static int uvc_init_video(struct uvc_vid
 
 	/* Submit the URBs. */
 	for (i = 0; i < UVC_URBS; ++i) {
-		if ((ret = usb_submit_urb(video->urb[i], GFP_KERNEL)) < 0) {
+		if ((ret = usb_submit_urb(video->urb[i], gfp_flags)) < 0) {
 			uvc_printk(KERN_ERR, "Failed to submit URB %u "
 					"(%d).\n", i, ret);
 			uvc_uninit_video(video);
@@ -818,7 +818,7 @@ int uvc_video_resume(struct uvc_video_de
 	if (!uvc_queue_streaming(&video->queue))
 		return 0;
 
-	if ((ret = uvc_init_video(video)) < 0)
+	if ((ret = uvc_init_video(video, GFP_NOIO)) < 0)
 		uvc_queue_enable(&video->queue, 0);
 
 	return ret;
@@ -930,5 +930,5 @@ int uvc_video_enable(struct uvc_video_de
 	if ((ret = uvc_queue_enable(&video->queue, 1)) < 0)
 		return ret;
 
-	return uvc_init_video(video);
+	return uvc_init_video(video, GFP_KERNEL);
 }

-- 
