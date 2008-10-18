Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329AbYJRTPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbYJRTPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYJRTFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:08 -0400
Received: from mail.suse.de ([195.135.220.2]:38553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYJRTFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:05 -0400
Date: Sat, 18 Oct 2008 11:48:01 -0700
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
       Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: [patch 16/26] V4L/DVB (8498): uvcvideo: Return sensible min and
	max values when querying a boolean control.
Message-ID: <20081018184801.GQ301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-dvb-uvcvideo-return-sensible-min-and-max-values-when-querying-a-boolean-control.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Laurent Pinchart <laurent.pinchart@skynet.be>

commit 54812c77bc830e2dbcb62b4c6d8a9c7f97cfdd1b upstream

[required to get the following two patches to apply]

Although the V4L2 spec states that the minimum and maximum fields may not be
valid for control types other than V4L2_CTRL_TYPE_INTEGER, it makes sense
to set the bounds to 0 and 1 for boolean controls instead of returning
uninitialized values.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_ctrl.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -592,6 +592,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 	if (ctrl == NULL)
 		return -EINVAL;
 
+	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
 	v4l2_ctrl->id = mapping->id;
 	v4l2_ctrl->type = mapping->v4l2_type;
 	strncpy(v4l2_ctrl->name, mapping->name, sizeof v4l2_ctrl->name);
@@ -608,7 +609,8 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 		v4l2_ctrl->default_value = uvc_get_le_value(data, mapping);
 	}
 
-	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
+	switch (mapping->v4l2_type) {
+	case V4L2_CTRL_TYPE_MENU:
 		v4l2_ctrl->minimum = 0;
 		v4l2_ctrl->maximum = mapping->menu_count - 1;
 		v4l2_ctrl->step = 1;
@@ -622,6 +624,15 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 		}
 
 		return 0;
+
+	case V4L2_CTRL_TYPE_BOOLEAN:
+		v4l2_ctrl->minimum = 0;
+		v4l2_ctrl->maximum = 1;
+		v4l2_ctrl->step = 1;
+		return 0;
+
+	default:
+		break;
 	}
 
 	if (ctrl->info->flags & UVC_CONTROL_GET_MIN) {

-- 
