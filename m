Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbYJRTP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbYJRTP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYJRTFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:47674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbYJRTFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:10 -0400
Date: Sat, 18 Oct 2008 11:48:03 -0700
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
       alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@infradead.org>,
       Bruce Schmid <duck@freescale.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: [patch 17/26] V4L/DVB (8617): uvcvideo: dont use stack-based
	buffers for USB transfers.
Message-ID: <20081018184803.GR301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-dvb-uvcvideo-don-t-use-stack-based-buffers-for-usb-transfers.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Laurent Pinchart <laurent.pinchart@skynet.be>

commit 04793dd041bbb88a39b768b714c725de2c339b51 upstream

Data buffers on the stack are not allowed for USB I/O. Use dynamically
allocated buffers instead.

Signed-off-by: Bruce Schmid <duck@freescale.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_ctrl.c  |   33 +++++++++++++++++++++------------
 drivers/media/video/uvc/uvc_video.c |   33 ++++++++++++++++++++++-----------
 2 files changed, 43 insertions(+), 23 deletions(-)

--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -585,13 +585,17 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 	struct uvc_control_mapping *mapping;
 	struct uvc_menu_info *menu;
 	unsigned int i;
-	__u8 data[8];
+	__u8 *data;
 	int ret;
 
 	ctrl = uvc_find_control(video, v4l2_ctrl->id, &mapping);
 	if (ctrl == NULL)
 		return -EINVAL;
 
+	data = kmalloc(8, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
 	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
 	v4l2_ctrl->id = mapping->id;
 	v4l2_ctrl->type = mapping->v4l2_type;
@@ -604,8 +608,8 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 	if (ctrl->info->flags & UVC_CONTROL_GET_DEF) {
 		if ((ret = uvc_query_ctrl(video->dev, GET_DEF, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
-				&data, ctrl->info->size)) < 0)
-			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->default_value = uvc_get_le_value(data, mapping);
 	}
 
@@ -623,13 +627,15 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 			}
 		}
 
-		return 0;
+		ret = 0;
+		goto out;
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		v4l2_ctrl->minimum = 0;
 		v4l2_ctrl->maximum = 1;
 		v4l2_ctrl->step = 1;
-		return 0;
+		ret = 0;
+		goto out;
 
 	default:
 		break;
@@ -638,26 +644,29 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 	if (ctrl->info->flags & UVC_CONTROL_GET_MIN) {
 		if ((ret = uvc_query_ctrl(video->dev, GET_MIN, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
-				&data, ctrl->info->size)) < 0)
-			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->minimum = uvc_get_le_value(data, mapping);
 	}
 	if (ctrl->info->flags & UVC_CONTROL_GET_MAX) {
 		if ((ret = uvc_query_ctrl(video->dev, GET_MAX, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
-				&data, ctrl->info->size)) < 0)
-			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->maximum = uvc_get_le_value(data, mapping);
 	}
 	if (ctrl->info->flags & UVC_CONTROL_GET_RES) {
 		if ((ret = uvc_query_ctrl(video->dev, GET_RES, ctrl->entity->id,
 				video->dev->intfnum, ctrl->info->selector,
-				&data, ctrl->info->size)) < 0)
-			return ret;
+				data, ctrl->info->size)) < 0)
+			goto out;
 		v4l2_ctrl->step = uvc_get_le_value(data, mapping);
 	}
 
-	return 0;
+	ret = 0;
+out:
+	kfree(data);
+	return ret;
 }
 
 
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -90,17 +90,20 @@ static void uvc_fixup_buffer_size(struct
 static int uvc_get_video_ctrl(struct uvc_video_device *video,
 	struct uvc_streaming_control *ctrl, int probe, __u8 query)
 {
-	__u8 data[34];
-	__u8 size;
+	__u8 *data;
+	__u16 size;
 	int ret;
 
 	size = video->dev->uvc_version >= 0x0110 ? 34 : 26;
+	data = kmalloc(size, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
 	ret = __uvc_query_ctrl(video->dev, query, 0, video->streaming->intfnum,
-		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, &data, size,
+		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, data, size,
 		UVC_CTRL_STREAMING_TIMEOUT);
-
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ctrl->bmHint = le16_to_cpup((__le16 *)&data[0]);
 	ctrl->bFormatIndex = data[2];
@@ -136,17 +139,22 @@ static int uvc_get_video_ctrl(struct uvc
 	 */
 	uvc_fixup_buffer_size(video, ctrl);
 
-	return 0;
+out:
+	kfree(data);
+	return ret;
 }
 
 int uvc_set_video_ctrl(struct uvc_video_device *video,
 	struct uvc_streaming_control *ctrl, int probe)
 {
-	__u8 data[34];
-	__u8 size;
+	__u8 *data;
+	__u16 size;
+	int ret;
 
 	size = video->dev->uvc_version >= 0x0110 ? 34 : 26;
-	memset(data, 0, sizeof data);
+	data = kzalloc(size, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
 
 	*(__le16 *)&data[0] = cpu_to_le16(ctrl->bmHint);
 	data[2] = ctrl->bFormatIndex;
@@ -174,10 +182,13 @@ int uvc_set_video_ctrl(struct uvc_video_
 		data[33] = ctrl->bMaxVersion;
 	}
 
-	return __uvc_query_ctrl(video->dev, SET_CUR, 0,
+	ret = __uvc_query_ctrl(video->dev, SET_CUR, 0,
 		video->streaming->intfnum,
-		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, &data, size,
+		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, data, size,
 		UVC_CTRL_STREAMING_TIMEOUT);
+
+	kfree(data);
+	return ret;
 }
 
 int uvc_probe_video(struct uvc_video_device *video,

-- 
