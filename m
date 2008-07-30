Return-Path: <linux-kernel-owner+w=401wt.eu-S1763173AbYGaAV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763173AbYGaAV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763059AbYGaAUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:20:11 -0400
Received: from ns.suse.de ([195.135.220.2]:39297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbYGaAUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:20:09 -0400
Date: Wed, 30 Jul 2008 16:59:24 -0700
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
Subject: [patch 43/62] V4L: uvcvideo: Make input device support optional
Message-ID: <20080730235924.GQ12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-uvcvideo-make-input-device-support-optional.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Laurent Pinchart <laurent.pinchart@skynet.be>

(cherry picked from commit 6833c917b4de1757febdbf946d709ece6dc7a86f)

V4L: uvcvideo: Make input device support optional

UVC devices can report button events. The uvcvideo driver depends on
CONFIG_INPUT to report events to the input layer. This patch removes the hard
dependency by introducing a new CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV option.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/Kconfig          |    8 +-------
 drivers/media/video/uvc/Kconfig      |   17 +++++++++++++++++
 drivers/media/video/uvc/uvc_status.c |   17 +++++++++++++++--
 3 files changed, 33 insertions(+), 9 deletions(-)

--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -793,13 +793,7 @@ menuconfig V4L_USB_DRIVERS
 
 if V4L_USB_DRIVERS && USB
 
-config USB_VIDEO_CLASS
-	tristate "USB Video Class (UVC)"
-	---help---
-	  Support for the USB Video Class (UVC).  Currently only video
-	  input devices, such as webcams, are supported.
-
-	  For more information see: <http://linux-uvc.berlios.de/>
+source "drivers/media/video/uvc/Kconfig"
 
 source "drivers/media/video/pvrusb2/Kconfig"
 
--- /dev/null
+++ b/drivers/media/video/uvc/Kconfig
@@ -0,0 +1,17 @@
+config USB_VIDEO_CLASS
+	tristate "USB Video Class (UVC)"
+	---help---
+	  Support for the USB Video Class (UVC).  Currently only video
+	  input devices, such as webcams, are supported.
+
+	  For more information see: <http://linux-uvc.berlios.de/>
+
+config USB_VIDEO_CLASS_INPUT_EVDEV
+	bool "UVC input events device support"
+	default y
+	depends on USB_VIDEO_CLASS && INPUT
+	---help---
+	  This option makes USB Video Class devices register an input device
+	  to report button events.
+
+	  If you are in doubt, say Y.
--- a/drivers/media/video/uvc/uvc_status.c
+++ b/drivers/media/video/uvc/uvc_status.c
@@ -22,6 +22,7 @@
 /* --------------------------------------------------------------------------
  * Input device
  */
+#ifdef CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV
 static int uvc_input_init(struct uvc_device *dev)
 {
 	struct usb_device *udev = dev->udev;
@@ -67,6 +68,19 @@ static void uvc_input_cleanup(struct uvc
 		input_unregister_device(dev->input);
 }
 
+static void uvc_input_report_key(struct uvc_device *dev, unsigned int code,
+	int value)
+{
+	if (dev->input)
+		input_report_key(dev->input, code, value);
+}
+
+#else
+#define uvc_input_init(dev)
+#define uvc_input_cleanup(dev)
+#define uvc_input_report_key(dev, code, value)
+#endif /* CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV */
+
 /* --------------------------------------------------------------------------
  * Status interrupt endpoint
  */
@@ -83,8 +97,7 @@ static void uvc_event_streaming(struct u
 			return;
 		uvc_trace(UVC_TRACE_STATUS, "Button (intf %u) %s len %d\n",
 			data[1], data[3] ? "pressed" : "released", len);
-		if (dev->input)
-			input_report_key(dev->input, BTN_0, data[3]);
+		uvc_input_report_key(dev, BTN_0, data[3]);
 	} else {
 		uvc_trace(UVC_TRACE_STATUS, "Stream %u error event %02x %02x "
 			"len %d.\n", data[1], data[2], data[3], len);

-- 
