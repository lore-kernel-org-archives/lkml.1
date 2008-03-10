Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYCJVVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYCJVVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYCJVVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:21:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:32139 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYCJVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TWO2PEQs23fNCva67hot6Ehr8Wb7NErw2+pzVqiH4vQpL3QVdiNzyRMpuqYCF03wqGqGJ7oAXHXze2jHuHflttvG48shqPZaTjvN8sI7e2/gnQ28w8+iSMfHO0I9M3nAPJtOfEKf0hqhUSpaNL96OOrf8GabP2ohBzBLTqTfFiE=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH 2/3 v4l-dvb] v4l: reduce stack usage of v4l_compat_translate_ioctl
Date: Mon, 10 Mar 2008 22:20:26 +0100
Message-Id: <1205184026-28055-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: 20080310145707.6815fbf0@gaivota
References: 20080310145707.6815fbf0@gaivota
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4l_compat_translate_ioctl used 1376 bytes of stack (x86_64),
so split this 800 lines long function into ~20 small noinline functions;
the biggest function takes now 712 bytes (v4l1_compat_sync)

fix VIDIOCSWIN handler which printked wrong errors

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/video/v4l1-compat.c | 1681 +++++++++++++++++++++----------------
 1 files changed, 938 insertions(+), 743 deletions(-)

diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index 6455b2f..e42cea9 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -203,7 +203,7 @@ static int poll_one(struct file *file)
 {
 	int retval = 1;
 	poll_table *table;
-	struct poll_wqueues pwq;
+	struct poll_wqueues pwq; /*TODO: allocate dynamically*/
 
 	poll_initwait(&pwq);
 	table = &pwq.pt;
@@ -225,9 +225,10 @@ static int poll_one(struct file *file)
 	return retval;
 }
 
-static int count_inputs(struct inode         *inode,
-			struct file          *file,
-			v4l2_kioctl          drv)
+static int count_inputs(
+			struct inode *inode,
+			struct file *file,
+			v4l2_kioctl drv)
 {
 	struct v4l2_input input2;
 	int i;
@@ -241,10 +242,12 @@ static int count_inputs(struct inode         *inode,
 	return i;
 }
 
-static int check_size(struct inode         *inode,
-		      struct file          *file,
-		      v4l2_kioctl          drv,
-		      int *maxw, int *maxh)
+static int check_size(
+		struct inode *inode,
+		struct file *file,
+		v4l2_kioctl drv,
+		int *maxw,
+		int *maxh)
 {
 	struct v4l2_fmtdesc desc2;
 	struct v4l2_format  fmt2;
@@ -266,828 +269,1020 @@ static int check_size(struct inode         *inode,
 	*maxw = fmt2.fmt.pix.width;
 	*maxh = fmt2.fmt.pix.height;
 
- done:
+done:
 	return 0;
 }
 
 /* ----------------------------------------------------------------- */
 
-/*
- *	This function is exported.
- */
-int
-v4l_compat_translate_ioctl(struct inode         *inode,
-			   struct file		*file,
-			   int			cmd,
-			   void			*arg,
-			   v4l2_kioctl          drv)
+static noinline int v4l1_compat_get_capabilities(
+					struct video_capability *cap,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
 {
-	struct v4l2_capability  *cap2 = NULL;
-	struct v4l2_format	*fmt2 = NULL;
-	enum v4l2_buf_type      captype = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	struct v4l2_framebuffer fbuf2;
-	struct v4l2_input	input2;
-	struct v4l2_tuner	tun2;
-	struct v4l2_standard	std2;
-	struct v4l2_frequency   freq2;
-	struct v4l2_audio	aud2;
-	struct v4l2_queryctrl	qctrl2;
-	struct v4l2_buffer	buf2;
-	v4l2_std_id    		sid;
-	int i, err = 0;
-
-	switch (cmd) {
-	case VIDIOCGCAP:	/* capability */
-	{
-		struct video_capability *cap = arg;
-
-		cap2 = kzalloc(sizeof(*cap2), GFP_KERNEL);
-		if (!cap2) {
-			err = -ENOMEM;
-			break;
-		}
-		memset(cap, 0, sizeof(*cap));
-		memset(&fbuf2, 0, sizeof(fbuf2));
+	int err;
+	struct v4l2_framebuffer fbuf;
+	struct v4l2_capability *cap2;
+
+	cap2 = kzalloc(sizeof(*cap2), GFP_KERNEL);
+	if (!cap2) {
+		err = -ENOMEM;
+		return err;
+	}
+	memset(cap, 0, sizeof(*cap));
+	memset(&fbuf, 0, sizeof(fbuf));
 
-		err = drv(inode, file, VIDIOC_QUERYCAP, cap2);
+	err = drv(inode, file, VIDIOC_QUERYCAP, cap2);
+	if (err < 0) {
+		dprintk("VIDIOCGCAP / VIDIOC_QUERYCAP: %d\n", err);
+		goto done;
+	}
+	if (cap2->capabilities & V4L2_CAP_VIDEO_OVERLAY) {
+		err = drv(inode, file, VIDIOC_G_FBUF, &fbuf);
 		if (err < 0) {
-			dprintk("VIDIOCGCAP / VIDIOC_QUERYCAP: %d\n", err);
-			break;
-		}
-		if (cap2->capabilities & V4L2_CAP_VIDEO_OVERLAY) {
-			err = drv(inode, file, VIDIOC_G_FBUF, &fbuf2);
-			if (err < 0) {
-				dprintk("VIDIOCGCAP / VIDIOC_G_FBUF: %d\n", err);
-				memset(&fbuf2, 0, sizeof(fbuf2));
-			}
-			err = 0;
+			dprintk("VIDIOCGCAP / VIDIOC_G_FBUF: %d\n", err);
+			memset(&fbuf, 0, sizeof(fbuf));
 		}
-
-		memcpy(cap->name, cap2->card,
-		       min(sizeof(cap->name), sizeof(cap2->card)));
-		cap->name[sizeof(cap->name) - 1] = 0;
-		if (cap2->capabilities & V4L2_CAP_VIDEO_CAPTURE)
-			cap->type |= VID_TYPE_CAPTURE;
-		if (cap2->capabilities & V4L2_CAP_TUNER)
-			cap->type |= VID_TYPE_TUNER;
-		if (cap2->capabilities & V4L2_CAP_VBI_CAPTURE)
-			cap->type |= VID_TYPE_TELETEXT;
-		if (cap2->capabilities & V4L2_CAP_VIDEO_OVERLAY)
-			cap->type |= VID_TYPE_OVERLAY;
-		if (fbuf2.capability & V4L2_FBUF_CAP_LIST_CLIPPING)
-			cap->type |= VID_TYPE_CLIPPING;
-
-		cap->channels  = count_inputs(inode, file, drv);
-		check_size(inode, file, drv,
-			   &cap->maxwidth, &cap->maxheight);
-		cap->audios    =  0; /* FIXME */
-		cap->minwidth  = 48; /* FIXME */
-		cap->minheight = 32; /* FIXME */
-		break;
+		err = 0;
 	}
-	case VIDIOCGFBUF: /*  get frame buffer  */
-	{
-		struct video_buffer	*buffer = arg;
 
-		memset(buffer, 0, sizeof(*buffer));
-		memset(&fbuf2, 0, sizeof(fbuf2));
+	memcpy(cap->name, cap2->card,
+	       min(sizeof(cap->name), sizeof(cap2->card)));
+	cap->name[sizeof(cap->name) - 1] = 0;
+	if (cap2->capabilities & V4L2_CAP_VIDEO_CAPTURE)
+		cap->type |= VID_TYPE_CAPTURE;
+	if (cap2->capabilities & V4L2_CAP_TUNER)
+		cap->type |= VID_TYPE_TUNER;
+	if (cap2->capabilities & V4L2_CAP_VBI_CAPTURE)
+		cap->type |= VID_TYPE_TELETEXT;
+	if (cap2->capabilities & V4L2_CAP_VIDEO_OVERLAY)
+		cap->type |= VID_TYPE_OVERLAY;
+	if (fbuf.capability & V4L2_FBUF_CAP_LIST_CLIPPING)
+		cap->type |= VID_TYPE_CLIPPING;
+
+	cap->channels  = count_inputs(inode, file, drv);
+	check_size(inode, file, drv,
+		   &cap->maxwidth, &cap->maxheight);
+	cap->audios    =  0; /* FIXME */
+	cap->minwidth  = 48; /* FIXME */
+	cap->minheight = 32; /* FIXME */
+
+done:
+	kfree(cap2);
+	return err;
+}
 
-		err = drv(inode, file, VIDIOC_G_FBUF, &fbuf2);
-		if (err < 0) {
-			dprintk("VIDIOCGFBUF / VIDIOC_G_FBUF: %d\n", err);
-			break;
-		}
-		buffer->base   = fbuf2.base;
-		buffer->height = fbuf2.fmt.height;
-		buffer->width  = fbuf2.fmt.width;
+static noinline int v4l1_compat_get_frame_buffer(
+					struct video_buffer *buffer,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_framebuffer fbuf;
 
-		switch (fbuf2.fmt.pixelformat) {
-		case V4L2_PIX_FMT_RGB332:
-			buffer->depth = 8;
-			break;
-		case V4L2_PIX_FMT_RGB555:
-			buffer->depth = 15;
-			break;
-		case V4L2_PIX_FMT_RGB565:
-			buffer->depth = 16;
-			break;
-		case V4L2_PIX_FMT_BGR24:
-			buffer->depth = 24;
-			break;
-		case V4L2_PIX_FMT_BGR32:
-			buffer->depth = 32;
-			break;
-		default:
-			buffer->depth = 0;
-		}
-		if (fbuf2.fmt.bytesperline) {
-			buffer->bytesperline = fbuf2.fmt.bytesperline;
-			if (!buffer->depth && buffer->width)
-				buffer->depth   = ((fbuf2.fmt.bytesperline<<3)
-						  + (buffer->width-1))
-						  / buffer->width;
-		} else {
-			buffer->bytesperline =
-				(buffer->width * buffer->depth + 7) & 7;
-			buffer->bytesperline >>= 3;
-		}
+	memset(buffer, 0, sizeof(*buffer));
+	memset(&fbuf, 0, sizeof(fbuf));
+
+	err = drv(inode, file, VIDIOC_G_FBUF, &fbuf);
+	if (err < 0) {
+		dprintk("VIDIOCGFBUF / VIDIOC_G_FBUF: %d\n", err);
+		goto done;
+	}
+	buffer->base   = fbuf.base;
+	buffer->height = fbuf.fmt.height;
+	buffer->width  = fbuf.fmt.width;
+
+	switch (fbuf.fmt.pixelformat) {
+	case V4L2_PIX_FMT_RGB332:
+		buffer->depth = 8;
 		break;
+	case V4L2_PIX_FMT_RGB555:
+		buffer->depth = 15;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		buffer->depth = 16;
+		break;
+	case V4L2_PIX_FMT_BGR24:
+		buffer->depth = 24;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		buffer->depth = 32;
+		break;
+	default:
+		buffer->depth = 0;
 	}
-	case VIDIOCSFBUF: /*  set frame buffer  */
-	{
-		struct video_buffer	*buffer = arg;
-
-		memset(&fbuf2, 0, sizeof(fbuf2));
-		fbuf2.base       = buffer->base;
-		fbuf2.fmt.height = buffer->height;
-		fbuf2.fmt.width  = buffer->width;
-		switch (buffer->depth) {
-		case 8:
-			fbuf2.fmt.pixelformat = V4L2_PIX_FMT_RGB332;
-			break;
-		case 15:
-			fbuf2.fmt.pixelformat = V4L2_PIX_FMT_RGB555;
-			break;
-		case 16:
-			fbuf2.fmt.pixelformat = V4L2_PIX_FMT_RGB565;
-			break;
-		case 24:
-			fbuf2.fmt.pixelformat = V4L2_PIX_FMT_BGR24;
-			break;
-		case 32:
-			fbuf2.fmt.pixelformat = V4L2_PIX_FMT_BGR32;
-			break;
-		}
-		fbuf2.fmt.bytesperline = buffer->bytesperline;
-		err = drv(inode, file, VIDIOC_S_FBUF, &fbuf2);
-		if (err < 0)
-			dprintk("VIDIOCSFBUF / VIDIOC_S_FBUF: %d\n", err);
+	if (fbuf.fmt.bytesperline) {
+		buffer->bytesperline = fbuf.fmt.bytesperline;
+		if (!buffer->depth && buffer->width)
+			buffer->depth   = ((fbuf.fmt.bytesperline<<3)
+					  + (buffer->width-1))
+					  / buffer->width;
+	} else {
+		buffer->bytesperline =
+			(buffer->width * buffer->depth + 7) & 7;
+		buffer->bytesperline >>= 3;
+	}
+done:
+	return err;
+}
+
+static noinline int v4l1_compat_set_frame_buffer(
+					struct video_buffer *buffer,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_framebuffer fbuf;
+
+	memset(&fbuf, 0, sizeof(fbuf));
+	fbuf.base       = buffer->base;
+	fbuf.fmt.height = buffer->height;
+	fbuf.fmt.width  = buffer->width;
+	switch (buffer->depth) {
+	case 8:
+		fbuf.fmt.pixelformat = V4L2_PIX_FMT_RGB332;
+		break;
+	case 15:
+		fbuf.fmt.pixelformat = V4L2_PIX_FMT_RGB555;
+		break;
+	case 16:
+		fbuf.fmt.pixelformat = V4L2_PIX_FMT_RGB565;
+		break;
+	case 24:
+		fbuf.fmt.pixelformat = V4L2_PIX_FMT_BGR24;
+		break;
+	case 32:
+		fbuf.fmt.pixelformat = V4L2_PIX_FMT_BGR32;
 		break;
 	}
-	case VIDIOCGWIN: /*  get window or capture dimensions  */
-	{
-		struct video_window	*win = arg;
+	fbuf.fmt.bytesperline = buffer->bytesperline;
+	err = drv(inode, file, VIDIOC_S_FBUF, &fbuf);
+	if (err < 0)
+		dprintk("VIDIOCSFBUF / VIDIOC_S_FBUF: %d\n", err);
+	return err;
+}
 
-		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
-		if (!fmt2) {
-			err = -ENOMEM;
-			break;
-		}
-		memset(win, 0, sizeof(*win));
+static noinline int v4l1_compat_get_win_cap_dimensions(
+					struct video_window *win,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_format *fmt;
 
-		fmt2->type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
-		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
-		if (err < 0)
-			dprintk("VIDIOCGWIN / VIDIOC_G_WIN: %d\n", err);
-		if (err == 0) {
-			win->x         = fmt2->fmt.win.w.left;
-			win->y         = fmt2->fmt.win.w.top;
-			win->width     = fmt2->fmt.win.w.width;
-			win->height    = fmt2->fmt.win.w.height;
-			win->chromakey = fmt2->fmt.win.chromakey;
-			win->clips     = NULL;
-			win->clipcount = 0;
-			break;
-		}
+	fmt = kzalloc(sizeof(*fmt), GFP_KERNEL);
+	if (!fmt) {
+		err = -ENOMEM;
+		return err;
+	}
+	memset(win, 0, sizeof(*win));
 
-		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
-		if (err < 0) {
-			dprintk("VIDIOCGWIN / VIDIOC_G_FMT: %d\n", err);
-			break;
-		}
-		win->x         = 0;
-		win->y         = 0;
-		win->width     = fmt2->fmt.pix.width;
-		win->height    = fmt2->fmt.pix.height;
-		win->chromakey = 0;
+	fmt->type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
+	err = drv(inode, file, VIDIOC_G_FMT, fmt);
+	if (err < 0)
+		dprintk("VIDIOCGWIN / VIDIOC_G_WIN: %d\n", err);
+	if (err == 0) {
+		win->x         = fmt->fmt.win.w.left;
+		win->y         = fmt->fmt.win.w.top;
+		win->width     = fmt->fmt.win.w.width;
+		win->height    = fmt->fmt.win.w.height;
+		win->chromakey = fmt->fmt.win.chromakey;
 		win->clips     = NULL;
 		win->clipcount = 0;
-		break;
+		goto done;
 	}
-	case VIDIOCSWIN: /*  set window and/or capture dimensions  */
-	{
-		struct video_window	*win = arg;
-		int err1, err2;
 
-		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
-		if (!fmt2) {
-			err = -ENOMEM;
-			break;
-		}
-		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		drv(inode, file, VIDIOC_STREAMOFF, &fmt2->type);
-		err1 = drv(inode, file, VIDIOC_G_FMT, fmt2);
-		if (err1 < 0)
-			dprintk("VIDIOCSWIN / VIDIOC_G_FMT: %d\n", err);
-		if (err1 == 0) {
-			fmt2->fmt.pix.width  = win->width;
-			fmt2->fmt.pix.height = win->height;
-			fmt2->fmt.pix.field  = V4L2_FIELD_ANY;
-			fmt2->fmt.pix.bytesperline = 0;
-			err = drv(inode, file, VIDIOC_S_FMT, fmt2);
-			if (err < 0)
-				dprintk("VIDIOCSWIN / VIDIOC_S_FMT #1: %d\n",
-					err);
-			win->width  = fmt2->fmt.pix.width;
-			win->height = fmt2->fmt.pix.height;
-		}
+	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	err = drv(inode, file, VIDIOC_G_FMT, fmt);
+	if (err < 0) {
+		dprintk("VIDIOCGWIN / VIDIOC_G_FMT: %d\n", err);
+		goto done;
+	}
+	win->x         = 0;
+	win->y         = 0;
+	win->width     = fmt->fmt.pix.width;
+	win->height    = fmt->fmt.pix.height;
+	win->chromakey = 0;
+	win->clips     = NULL;
+	win->clipcount = 0;
+done:
+	kfree(fmt);
+	return err;
+}
 
-		memset(fmt2, 0, sizeof(*fmt2));
-		fmt2->type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
-		fmt2->fmt.win.w.left    = win->x;
-		fmt2->fmt.win.w.top     = win->y;
-		fmt2->fmt.win.w.width   = win->width;
-		fmt2->fmt.win.w.height  = win->height;
-		fmt2->fmt.win.chromakey = win->chromakey;
-		fmt2->fmt.win.clips     = (void __user *)win->clips;
-		fmt2->fmt.win.clipcount = win->clipcount;
-		err2 = drv(inode, file, VIDIOC_S_FMT, fmt2);
-		if (err2 < 0)
-			dprintk("VIDIOCSWIN / VIDIOC_S_FMT #2: %d\n", err);
-
-		if (err1 != 0 && err2 != 0)
-			err = err1;
-		break;
+static noinline int v4l1_compat_set_win_cap_dimensions(
+					struct video_window *win,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err, err1, err2;
+	struct v4l2_format *fmt;
+
+	fmt = kzalloc(sizeof(*fmt), GFP_KERNEL);
+	if (!fmt) {
+		err = -ENOMEM;
+		return err;
 	}
-	case VIDIOCCAPTURE: /*  turn on/off preview  */
-	{
-		int *on = arg;
-
-		if (0 == *on) {
-			/* dirty hack time.  But v4l1 has no STREAMOFF
-			 * equivalent in the API, and this one at
-			 * least comes close ... */
-			drv(inode, file, VIDIOC_STREAMOFF, &captype);
-		}
-		err = drv(inode, file, VIDIOC_OVERLAY, arg);
+	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	drv(inode, file, VIDIOC_STREAMOFF, &fmt->type);
+	err1 = drv(inode, file, VIDIOC_G_FMT, fmt);
+	if (err1 < 0)
+		dprintk("VIDIOCSWIN / VIDIOC_G_FMT: %d\n", err1);
+	if (err1 == 0) {
+		fmt->fmt.pix.width  = win->width;
+		fmt->fmt.pix.height = win->height;
+		fmt->fmt.pix.field  = V4L2_FIELD_ANY;
+		fmt->fmt.pix.bytesperline = 0;
+		err = drv(inode, file, VIDIOC_S_FMT, fmt);
 		if (err < 0)
-			dprintk("VIDIOCCAPTURE / VIDIOC_PREVIEW: %d\n", err);
-		break;
+			dprintk("VIDIOCSWIN / VIDIOC_S_FMT #1: %d\n",
+				err);
+		win->width  = fmt->fmt.pix.width;
+		win->height = fmt->fmt.pix.height;
 	}
-	case VIDIOCGCHAN: /*  get input information  */
-	{
-		struct video_channel	*chan = arg;
 
-		memset(&input2, 0, sizeof(input2));
-		input2.index = chan->channel;
-		err = drv(inode, file, VIDIOC_ENUMINPUT, &input2);
-		if (err < 0) {
-			dprintk("VIDIOCGCHAN / VIDIOC_ENUMINPUT: "
-				"channel=%d err=%d\n", chan->channel, err);
-			break;
-		}
-		chan->channel = input2.index;
-		memcpy(chan->name, input2.name,
-		       min(sizeof(chan->name), sizeof(input2.name)));
-		chan->name[sizeof(chan->name) - 1] = 0;
-		chan->tuners = (input2.type == V4L2_INPUT_TYPE_TUNER) ? 1 : 0;
-		chan->flags = (chan->tuners) ? VIDEO_VC_TUNER : 0;
-		switch (input2.type) {
-		case V4L2_INPUT_TYPE_TUNER:
-			chan->type = VIDEO_TYPE_TV;
-			break;
-		default:
-		case V4L2_INPUT_TYPE_CAMERA:
-			chan->type = VIDEO_TYPE_CAMERA;
-			break;
-		}
-		chan->norm = 0;
-		err = drv(inode, file, VIDIOC_G_STD, &sid);
-		if (err < 0)
-			dprintk("VIDIOCGCHAN / VIDIOC_G_STD: %d\n", err);
-		if (err == 0) {
-			if (sid & V4L2_STD_PAL)
-				chan->norm = VIDEO_MODE_PAL;
-			if (sid & V4L2_STD_NTSC)
-				chan->norm = VIDEO_MODE_NTSC;
-			if (sid & V4L2_STD_SECAM)
-				chan->norm = VIDEO_MODE_SECAM;
-		}
-		break;
-	}
-	case VIDIOCSCHAN: /*  set input  */
-	{
-		struct video_channel *chan = arg;
+	memset(fmt, 0, sizeof(*fmt));
+	fmt->type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
+	fmt->fmt.win.w.left    = win->x;
+	fmt->fmt.win.w.top     = win->y;
+	fmt->fmt.win.w.width   = win->width;
+	fmt->fmt.win.w.height  = win->height;
+	fmt->fmt.win.chromakey = win->chromakey;
+	fmt->fmt.win.clips     = (void __user *)win->clips;
+	fmt->fmt.win.clipcount = win->clipcount;
+	err2 = drv(inode, file, VIDIOC_S_FMT, fmt);
+	if (err2 < 0)
+		dprintk("VIDIOCSWIN / VIDIOC_S_FMT #2: %d\n", err2);
+
+	if (err1 != 0 && err2 != 0)
+		err = err1;
+	else
+		err = 0;
+	kfree(fmt);
+	return err;
+}
 
-		sid = 0;
-		err = drv(inode, file, VIDIOC_S_INPUT, &chan->channel);
-		if (err < 0)
-			dprintk("VIDIOCSCHAN / VIDIOC_S_INPUT: %d\n", err);
-		switch (chan->norm) {
-		case VIDEO_MODE_PAL:
-			sid = V4L2_STD_PAL;
-			break;
-		case VIDEO_MODE_NTSC:
-			sid = V4L2_STD_NTSC;
-			break;
-		case VIDEO_MODE_SECAM:
-			sid = V4L2_STD_SECAM;
-			break;
-		}
-		if (0 != sid) {
-			err = drv(inode, file, VIDIOC_S_STD, &sid);
-			if (err < 0)
-				dprintk("VIDIOCSCHAN / VIDIOC_S_STD: %d\n", err);
-		}
-		break;
+static noinline int v4l1_compat_turn_preview_on_off(
+					int *on,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	enum v4l2_buf_type captype = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	if (0 == *on) {
+		/* dirty hack time.  But v4l1 has no STREAMOFF
+		 * equivalent in the API, and this one at
+		 * least comes close ... */
+		drv(inode, file, VIDIOC_STREAMOFF, &captype);
 	}
-	case VIDIOCGPICT: /*  get tone controls & partial capture format  */
-	{
-		struct video_picture	*pict = arg;
-
-		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
-		if (!fmt2) {
-			err = -ENOMEM;
-			break;
-		}
+	err = drv(inode, file, VIDIOC_OVERLAY, on);
+	if (err < 0)
+		dprintk("VIDIOCCAPTURE / VIDIOC_PREVIEW: %d\n", err);
+	return err;
+}
 
-		pict->brightness = get_v4l_control(inode, file,
-						   V4L2_CID_BRIGHTNESS, drv);
-		pict->hue = get_v4l_control(inode, file,
-					    V4L2_CID_HUE, drv);
-		pict->contrast = get_v4l_control(inode, file,
-						 V4L2_CID_CONTRAST, drv);
-		pict->colour = get_v4l_control(inode, file,
-					       V4L2_CID_SATURATION, drv);
-		pict->whiteness = get_v4l_control(inode, file,
-						  V4L2_CID_WHITENESS, drv);
-
-		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
-		if (err < 0) {
-			dprintk("VIDIOCGPICT / VIDIOC_G_FMT: %d\n", err);
-			break;
-		}
+static noinline int v4l1_compat_get_input_info(
+					struct video_channel *chan,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_input	input2;
+	v4l2_std_id    		sid;
 
-		pict->depth   = ((fmt2->fmt.pix.bytesperline << 3)
-				 + (fmt2->fmt.pix.width - 1))
-				 / fmt2->fmt.pix.width;
-		pict->palette = pixelformat_to_palette(
-			fmt2->fmt.pix.pixelformat);
+	memset(&input2, 0, sizeof(input2));
+	input2.index = chan->channel;
+	err = drv(inode, file, VIDIOC_ENUMINPUT, &input2);
+	if (err < 0) {
+		dprintk("VIDIOCGCHAN / VIDIOC_ENUMINPUT: "
+			"channel=%d err=%d\n", chan->channel, err);
+		goto done;
+	}
+	chan->channel = input2.index;
+	memcpy(chan->name, input2.name,
+	       min(sizeof(chan->name), sizeof(input2.name)));
+	chan->name[sizeof(chan->name) - 1] = 0;
+	chan->tuners = (input2.type == V4L2_INPUT_TYPE_TUNER) ? 1 : 0;
+	chan->flags = (chan->tuners) ? VIDEO_VC_TUNER : 0;
+	switch (input2.type) {
+	case V4L2_INPUT_TYPE_TUNER:
+		chan->type = VIDEO_TYPE_TV;
+		break;
+	default:
+	case V4L2_INPUT_TYPE_CAMERA:
+		chan->type = VIDEO_TYPE_CAMERA;
 		break;
 	}
-	case VIDIOCSPICT: /*  set tone controls & partial capture format  */
-	{
-		struct video_picture	*pict = arg;
-		int mem_err = 0, ovl_err = 0;
+	chan->norm = 0;
+	err = drv(inode, file, VIDIOC_G_STD, &sid);
+	if (err < 0)
+		dprintk("VIDIOCGCHAN / VIDIOC_G_STD: %d\n", err);
+	if (err == 0) {
+		if (sid & V4L2_STD_PAL)
+			chan->norm = VIDEO_MODE_PAL;
+		if (sid & V4L2_STD_NTSC)
+			chan->norm = VIDEO_MODE_NTSC;
+		if (sid & V4L2_STD_SECAM)
+			chan->norm = VIDEO_MODE_SECAM;
+	}
+done:
+	return err;
+}
 
-		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
-		if (!fmt2) {
-			err = -ENOMEM;
-			break;
-		}
-		memset(&fbuf2, 0, sizeof(fbuf2));
-
-		set_v4l_control(inode, file,
-				V4L2_CID_BRIGHTNESS, pict->brightness, drv);
-		set_v4l_control(inode, file,
-				V4L2_CID_HUE, pict->hue, drv);
-		set_v4l_control(inode, file,
-				V4L2_CID_CONTRAST, pict->contrast, drv);
-		set_v4l_control(inode, file,
-				V4L2_CID_SATURATION, pict->colour, drv);
-		set_v4l_control(inode, file,
-				V4L2_CID_WHITENESS, pict->whiteness, drv);
-		/*
-		 * V4L1 uses this ioctl to set both memory capture and overlay
-		 * pixel format, while V4L2 has two different ioctls for this.
-		 * Some cards may not support one or the other, and may support
-		 * different pixel formats for memory vs overlay.
-		 */
-
-		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
-		/* If VIDIOC_G_FMT failed, then the driver likely doesn't
-		   support memory capture.  Trying to set the memory capture
-		   parameters would be pointless.  */
-		if (err < 0) {
-			dprintk("VIDIOCSPICT / VIDIOC_G_FMT: %d\n", err);
-			mem_err = -1000;  /* didn't even try */
-		} else if (fmt2->fmt.pix.pixelformat !=
-			 palette_to_pixelformat(pict->palette)) {
-			fmt2->fmt.pix.pixelformat = palette_to_pixelformat(
-				pict->palette);
-			mem_err = drv(inode, file, VIDIOC_S_FMT, fmt2);
-			if (mem_err < 0)
-				dprintk("VIDIOCSPICT / VIDIOC_S_FMT: %d\n",
-					mem_err);
-		}
+static noinline int v4l1_compat_set_input(
+					struct video_channel *chan,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	v4l2_std_id sid = 0;
 
-		err = drv(inode, file, VIDIOC_G_FBUF, &fbuf2);
-		/* If VIDIOC_G_FBUF failed, then the driver likely doesn't
-		   support overlay.  Trying to set the overlay parameters
-		   would be quite pointless.  */
-		if (err < 0) {
-			dprintk("VIDIOCSPICT / VIDIOC_G_FBUF: %d\n", err);
-			ovl_err = -1000;  /* didn't even try */
-		} else if (fbuf2.fmt.pixelformat !=
-			 palette_to_pixelformat(pict->palette)) {
-			fbuf2.fmt.pixelformat = palette_to_pixelformat(
-				pict->palette);
-			ovl_err = drv(inode, file, VIDIOC_S_FBUF, &fbuf2);
-			if (ovl_err < 0)
-				dprintk("VIDIOCSPICT / VIDIOC_S_FBUF: %d\n",
-					ovl_err);
-		}
-		if (ovl_err < 0 && mem_err < 0) {
-			/* ioctl failed, couldn't set either parameter */
-			if (mem_err != -1000)
-				err = mem_err;
-			else if (ovl_err == -EPERM)
-				err = 0;
-			else
-				err = ovl_err;
-		} else
-			err = 0;
+	err = drv(inode, file, VIDIOC_S_INPUT, &chan->channel);
+	if (err < 0)
+		dprintk("VIDIOCSCHAN / VIDIOC_S_INPUT: %d\n", err);
+	switch (chan->norm) {
+	case VIDEO_MODE_PAL:
+		sid = V4L2_STD_PAL;
+		break;
+	case VIDEO_MODE_NTSC:
+		sid = V4L2_STD_NTSC;
+		break;
+	case VIDEO_MODE_SECAM:
+		sid = V4L2_STD_SECAM;
 		break;
 	}
-	case VIDIOCGTUNER: /*  get tuner information  */
-	{
-		struct video_tuner	*tun = arg;
-
-		memset(&tun2, 0, sizeof(tun2));
-		err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
-		if (err < 0) {
-			dprintk("VIDIOCGTUNER / VIDIOC_G_TUNER: %d\n", err);
-			break;
-		}
-		memcpy(tun->name, tun2.name,
-		       min(sizeof(tun->name), sizeof(tun2.name)));
-		tun->name[sizeof(tun->name) - 1] = 0;
-		tun->rangelow = tun2.rangelow;
-		tun->rangehigh = tun2.rangehigh;
-		tun->flags = 0;
-		tun->mode = VIDEO_MODE_AUTO;
-
-		for (i = 0; i < 64; i++) {
-			memset(&std2, 0, sizeof(std2));
-			std2.index = i;
-			if (0 != drv(inode, file, VIDIOC_ENUMSTD, &std2))
-				break;
-			if (std2.id & V4L2_STD_PAL)
-				tun->flags |= VIDEO_TUNER_PAL;
-			if (std2.id & V4L2_STD_NTSC)
-				tun->flags |= VIDEO_TUNER_NTSC;
-			if (std2.id & V4L2_STD_SECAM)
-				tun->flags |= VIDEO_TUNER_SECAM;
-		}
-
-		err = drv(inode, file, VIDIOC_G_STD, &sid);
+	if (0 != sid) {
+		err = drv(inode, file, VIDIOC_S_STD, &sid);
 		if (err < 0)
-			dprintk("VIDIOCGTUNER / VIDIOC_G_STD: %d\n", err);
-		if (err == 0) {
-			if (sid & V4L2_STD_PAL)
-				tun->mode = VIDEO_MODE_PAL;
-			if (sid & V4L2_STD_NTSC)
-				tun->mode = VIDEO_MODE_NTSC;
-			if (sid & V4L2_STD_SECAM)
-				tun->mode = VIDEO_MODE_SECAM;
-		}
-
-		if (tun2.capability & V4L2_TUNER_CAP_LOW)
-			tun->flags |= VIDEO_TUNER_LOW;
-		if (tun2.rxsubchans & V4L2_TUNER_SUB_STEREO)
-			tun->flags |= VIDEO_TUNER_STEREO_ON;
-		tun->signal = tun2.signal;
-		break;
+			dprintk("VIDIOCSCHAN / VIDIOC_S_STD: %d\n", err);
 	}
-	case VIDIOCSTUNER: /*  select a tuner input  */
-	{
-		struct video_tuner	*tun = arg;
-		struct v4l2_tuner	t;
-		memset(&t, 0, sizeof(t));
-
-		t.index = tun->tuner;
+	return err;
+}
 
-		err = drv(inode, file, VIDIOC_S_INPUT, &t);
-		if (err < 0)
-			dprintk("VIDIOCSTUNER / VIDIOC_S_INPUT: %d\n", err);
+static noinline int v4l1_compat_get_picture(
+					struct video_picture *pict,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_format *fmt;
 
-		break;
+	fmt = kzalloc(sizeof(*fmt), GFP_KERNEL);
+	if (!fmt) {
+		err = -ENOMEM;
+		return err;
 	}
-	case VIDIOCGFREQ: /*  get frequency  */
-	{
-		unsigned long *freq = arg;
-		memset(&freq2, 0, sizeof(freq2));
 
-		freq2.tuner = 0;
-		err = drv(inode, file, VIDIOC_G_FREQUENCY, &freq2);
-		if (err < 0)
-			dprintk("VIDIOCGFREQ / VIDIOC_G_FREQUENCY: %d\n", err);
-		if (0 == err)
-			*freq = freq2.frequency;
-		break;
+	pict->brightness = get_v4l_control(inode, file,
+					   V4L2_CID_BRIGHTNESS, drv);
+	pict->hue = get_v4l_control(inode, file,
+				    V4L2_CID_HUE, drv);
+	pict->contrast = get_v4l_control(inode, file,
+					 V4L2_CID_CONTRAST, drv);
+	pict->colour = get_v4l_control(inode, file,
+				       V4L2_CID_SATURATION, drv);
+	pict->whiteness = get_v4l_control(inode, file,
+					  V4L2_CID_WHITENESS, drv);
+
+	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	err = drv(inode, file, VIDIOC_G_FMT, fmt);
+	if (err < 0) {
+		dprintk("VIDIOCGPICT / VIDIOC_G_FMT: %d\n", err);
+		goto done;
 	}
-	case VIDIOCSFREQ: /*  set frequency  */
-	{
-		unsigned long *freq = arg;
-		memset(&freq2, 0, sizeof(freq2));
 
-		drv(inode, file, VIDIOC_G_FREQUENCY, &freq2);
-		freq2.frequency = *freq;
-		err = drv(inode, file, VIDIOC_S_FREQUENCY, &freq2);
-		if (err < 0)
-			dprintk("VIDIOCSFREQ / VIDIOC_S_FREQUENCY: %d\n", err);
-		break;
+	pict->depth   = ((fmt->fmt.pix.bytesperline << 3)
+			 + (fmt->fmt.pix.width - 1))
+			 / fmt->fmt.pix.width;
+	pict->palette = pixelformat_to_palette(
+		fmt->fmt.pix.pixelformat);
+done:
+	kfree(fmt);
+	return err;
+}
+
+static noinline int v4l1_compat_set_picture(
+					struct video_picture *pict,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_framebuffer fbuf;
+	int mem_err = 0, ovl_err = 0;
+	struct v4l2_format *fmt;
+
+	fmt = kzalloc(sizeof(*fmt), GFP_KERNEL);
+	if (!fmt) {
+		err = -ENOMEM;
+		return err;
+	}
+	memset(&fbuf, 0, sizeof(fbuf));
+
+	set_v4l_control(inode, file,
+			V4L2_CID_BRIGHTNESS, pict->brightness, drv);
+	set_v4l_control(inode, file,
+			V4L2_CID_HUE, pict->hue, drv);
+	set_v4l_control(inode, file,
+			V4L2_CID_CONTRAST, pict->contrast, drv);
+	set_v4l_control(inode, file,
+			V4L2_CID_SATURATION, pict->colour, drv);
+	set_v4l_control(inode, file,
+			V4L2_CID_WHITENESS, pict->whiteness, drv);
+	/*
+	 * V4L1 uses this ioctl to set both memory capture and overlay
+	 * pixel format, while V4L2 has two different ioctls for this.
+	 * Some cards may not support one or the other, and may support
+	 * different pixel formats for memory vs overlay.
+	 */
+
+	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	err = drv(inode, file, VIDIOC_G_FMT, fmt);
+	/* If VIDIOC_G_FMT failed, then the driver likely doesn't
+	   support memory capture.  Trying to set the memory capture
+	   parameters would be pointless.  */
+	if (err < 0) {
+		dprintk("VIDIOCSPICT / VIDIOC_G_FMT: %d\n", err);
+		mem_err = -1000;  /* didn't even try */
+	} else if (fmt->fmt.pix.pixelformat !=
+		 palette_to_pixelformat(pict->palette)) {
+		fmt->fmt.pix.pixelformat = palette_to_pixelformat(
+			pict->palette);
+		mem_err = drv(inode, file, VIDIOC_S_FMT, fmt);
+		if (mem_err < 0)
+			dprintk("VIDIOCSPICT / VIDIOC_S_FMT: %d\n",
+				mem_err);
 	}
-	case VIDIOCGAUDIO: /*  get audio properties/controls  */
-	{
-		struct video_audio	*aud = arg;
-		memset(&aud2, 0, sizeof(aud2));
 
-		err = drv(inode, file, VIDIOC_G_AUDIO, &aud2);
-		if (err < 0) {
-			dprintk("VIDIOCGAUDIO / VIDIOC_G_AUDIO: %d\n", err);
-			break;
-		}
-		memcpy(aud->name, aud2.name,
-		       min(sizeof(aud->name), sizeof(aud2.name)));
-		aud->name[sizeof(aud->name) - 1] = 0;
-		aud->audio = aud2.index;
-		aud->flags = 0;
-		i = get_v4l_control(inode, file, V4L2_CID_AUDIO_VOLUME, drv);
-		if (i >= 0) {
-			aud->volume = i;
-			aud->flags |= VIDEO_AUDIO_VOLUME;
-		}
-		i = get_v4l_control(inode, file, V4L2_CID_AUDIO_BASS, drv);
-		if (i >= 0) {
-			aud->bass = i;
-			aud->flags |= VIDEO_AUDIO_BASS;
-		}
-		i = get_v4l_control(inode, file, V4L2_CID_AUDIO_TREBLE, drv);
-		if (i >= 0) {
-			aud->treble = i;
-			aud->flags |= VIDEO_AUDIO_TREBLE;
-		}
-		i = get_v4l_control(inode, file, V4L2_CID_AUDIO_BALANCE, drv);
-		if (i >= 0) {
-			aud->balance = i;
-			aud->flags |= VIDEO_AUDIO_BALANCE;
-		}
-		i = get_v4l_control(inode, file, V4L2_CID_AUDIO_MUTE, drv);
-		if (i >= 0) {
-			if (i)
-				aud->flags |= VIDEO_AUDIO_MUTE;
-			aud->flags |= VIDEO_AUDIO_MUTABLE;
-		}
-		aud->step = 1;
-		qctrl2.id = V4L2_CID_AUDIO_VOLUME;
-		if (drv(inode, file, VIDIOC_QUERYCTRL, &qctrl2) == 0 &&
-		    !(qctrl2.flags & V4L2_CTRL_FLAG_DISABLED))
-			aud->step = qctrl2.step;
-		aud->mode = 0;
-
-		memset(&tun2, 0, sizeof(tun2));
-		err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
-		if (err < 0) {
-			dprintk("VIDIOCGAUDIO / VIDIOC_G_TUNER: %d\n", err);
+	err = drv(inode, file, VIDIOC_G_FBUF, &fbuf);
+	/* If VIDIOC_G_FBUF failed, then the driver likely doesn't
+	   support overlay.  Trying to set the overlay parameters
+	   would be quite pointless.  */
+	if (err < 0) {
+		dprintk("VIDIOCSPICT / VIDIOC_G_FBUF: %d\n", err);
+		ovl_err = -1000;  /* didn't even try */
+	} else if (fbuf.fmt.pixelformat !=
+		 palette_to_pixelformat(pict->palette)) {
+		fbuf.fmt.pixelformat = palette_to_pixelformat(
+			pict->palette);
+		ovl_err = drv(inode, file, VIDIOC_S_FBUF, &fbuf);
+		if (ovl_err < 0)
+			dprintk("VIDIOCSPICT / VIDIOC_S_FBUF: %d\n",
+				ovl_err);
+	}
+	if (ovl_err < 0 && mem_err < 0) {
+		/* ioctl failed, couldn't set either parameter */
+		if (mem_err != -1000)
+			err = mem_err;
+		else if (ovl_err == -EPERM)
 			err = 0;
+		else
+			err = ovl_err;
+	} else
+		err = 0;
+	kfree(fmt);
+	return err;
+}
+
+static noinline int v4l1_compat_get_tuner(
+					struct video_tuner *tun,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err, i;
+	struct v4l2_tuner	tun2;
+	struct v4l2_standard	std2;
+	v4l2_std_id    		sid;
+
+	memset(&tun2, 0, sizeof(tun2));
+	err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
+	if (err < 0) {
+		dprintk("VIDIOCGTUNER / VIDIOC_G_TUNER: %d\n", err);
+		goto done;
+	}
+	memcpy(tun->name, tun2.name,
+	       min(sizeof(tun->name), sizeof(tun2.name)));
+	tun->name[sizeof(tun->name) - 1] = 0;
+	tun->rangelow = tun2.rangelow;
+	tun->rangehigh = tun2.rangehigh;
+	tun->flags = 0;
+	tun->mode = VIDEO_MODE_AUTO;
+
+	for (i = 0; i < 64; i++) {
+		memset(&std2, 0, sizeof(std2));
+		std2.index = i;
+		if (0 != drv(inode, file, VIDIOC_ENUMSTD, &std2))
 			break;
-		}
+		if (std2.id & V4L2_STD_PAL)
+			tun->flags |= VIDEO_TUNER_PAL;
+		if (std2.id & V4L2_STD_NTSC)
+			tun->flags |= VIDEO_TUNER_NTSC;
+		if (std2.id & V4L2_STD_SECAM)
+			tun->flags |= VIDEO_TUNER_SECAM;
+	}
 
-		if (tun2.rxsubchans & V4L2_TUNER_SUB_LANG2)
-			aud->mode = VIDEO_SOUND_LANG1 | VIDEO_SOUND_LANG2;
-		else if (tun2.rxsubchans & V4L2_TUNER_SUB_STEREO)
-			aud->mode = VIDEO_SOUND_STEREO;
-		else if (tun2.rxsubchans & V4L2_TUNER_SUB_MONO)
-			aud->mode = VIDEO_SOUND_MONO;
-		break;
+	err = drv(inode, file, VIDIOC_G_STD, &sid);
+	if (err < 0)
+		dprintk("VIDIOCGTUNER / VIDIOC_G_STD: %d\n", err);
+	if (err == 0) {
+		if (sid & V4L2_STD_PAL)
+			tun->mode = VIDEO_MODE_PAL;
+		if (sid & V4L2_STD_NTSC)
+			tun->mode = VIDEO_MODE_NTSC;
+		if (sid & V4L2_STD_SECAM)
+			tun->mode = VIDEO_MODE_SECAM;
 	}
-	case VIDIOCSAUDIO: /*  set audio controls  */
-	{
-		struct video_audio	*aud = arg;
 
-		memset(&aud2, 0, sizeof(aud2));
-		memset(&tun2, 0, sizeof(tun2));
+	if (tun2.capability & V4L2_TUNER_CAP_LOW)
+		tun->flags |= VIDEO_TUNER_LOW;
+	if (tun2.rxsubchans & V4L2_TUNER_SUB_STEREO)
+		tun->flags |= VIDEO_TUNER_STEREO_ON;
+	tun->signal = tun2.signal;
+done:
+	return err;
+}
 
-		aud2.index = aud->audio;
-		err = drv(inode, file, VIDIOC_S_AUDIO, &aud2);
-		if (err < 0) {
-			dprintk("VIDIOCSAUDIO / VIDIOC_S_AUDIO: %d\n", err);
-			break;
-		}
+static noinline int v4l1_compat_select_tuner(
+					struct video_tuner *tun,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_tuner	t;/*84 bytes on x86_64*/
+	memset(&t, 0, sizeof(t));
 
-		set_v4l_control(inode, file, V4L2_CID_AUDIO_VOLUME,
-				aud->volume, drv);
-		set_v4l_control(inode, file, V4L2_CID_AUDIO_BASS,
-				aud->bass, drv);
-		set_v4l_control(inode, file, V4L2_CID_AUDIO_TREBLE,
-				aud->treble, drv);
-		set_v4l_control(inode, file, V4L2_CID_AUDIO_BALANCE,
-				aud->balance, drv);
-		set_v4l_control(inode, file, V4L2_CID_AUDIO_MUTE,
-				!!(aud->flags & VIDEO_AUDIO_MUTE), drv);
-
-		err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
-		if (err < 0)
-			dprintk("VIDIOCSAUDIO / VIDIOC_G_TUNER: %d\n", err);
-		if (err == 0) {
-			switch (aud->mode) {
-			default:
-			case VIDEO_SOUND_MONO:
-			case VIDEO_SOUND_LANG1:
-				tun2.audmode = V4L2_TUNER_MODE_MONO;
-				break;
-			case VIDEO_SOUND_STEREO:
-				tun2.audmode = V4L2_TUNER_MODE_STEREO;
-				break;
-			case VIDEO_SOUND_LANG2:
-				tun2.audmode = V4L2_TUNER_MODE_LANG2;
-				break;
-			}
-			err = drv(inode, file, VIDIOC_S_TUNER, &tun2);
-			if (err < 0)
-				dprintk("VIDIOCSAUDIO / VIDIOC_S_TUNER: %d\n", err);
-		}
+	t.index = tun->tuner;
+
+	err = drv(inode, file, VIDIOC_S_INPUT, &t);
+	if (err < 0)
+		dprintk("VIDIOCSTUNER / VIDIOC_S_INPUT: %d\n", err);
+	return err;
+}
+
+static noinline int v4l1_compat_get_frequency(
+					unsigned long *freq,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_frequency   freq2;
+	memset(&freq2, 0, sizeof(freq2));
+
+	freq2.tuner = 0;
+	err = drv(inode, file, VIDIOC_G_FREQUENCY, &freq2);
+	if (err < 0)
+		dprintk("VIDIOCGFREQ / VIDIOC_G_FREQUENCY: %d\n", err);
+	if (0 == err)
+		*freq = freq2.frequency;
+	return err;
+}
+
+static noinline int v4l1_compat_set_frequency(
+					unsigned long *freq,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_frequency   freq2;
+	memset(&freq2, 0, sizeof(freq2));
+
+	drv(inode, file, VIDIOC_G_FREQUENCY, &freq2);
+	freq2.frequency = *freq;
+	err = drv(inode, file, VIDIOC_S_FREQUENCY, &freq2);
+	if (err < 0)
+		dprintk("VIDIOCSFREQ / VIDIOC_S_FREQUENCY: %d\n", err);
+	return err;
+}
+
+static noinline int v4l1_compat_get_audio(
+					struct video_audio *aud,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err, i;
+	struct v4l2_queryctrl	qctrl2;
+	struct v4l2_audio	aud2;
+	struct v4l2_tuner	tun2;
+	memset(&aud2, 0, sizeof(aud2));
+
+	err = drv(inode, file, VIDIOC_G_AUDIO, &aud2);
+	if (err < 0) {
+		dprintk("VIDIOCGAUDIO / VIDIOC_G_AUDIO: %d\n", err);
+		goto done;
+	}
+	memcpy(aud->name, aud2.name,
+	       min(sizeof(aud->name), sizeof(aud2.name)));
+	aud->name[sizeof(aud->name) - 1] = 0;
+	aud->audio = aud2.index;
+	aud->flags = 0;
+	i = get_v4l_control(inode, file, V4L2_CID_AUDIO_VOLUME, drv);
+	if (i >= 0) {
+		aud->volume = i;
+		aud->flags |= VIDEO_AUDIO_VOLUME;
+	}
+	i = get_v4l_control(inode, file, V4L2_CID_AUDIO_BASS, drv);
+	if (i >= 0) {
+		aud->bass = i;
+		aud->flags |= VIDEO_AUDIO_BASS;
+	}
+	i = get_v4l_control(inode, file, V4L2_CID_AUDIO_TREBLE, drv);
+	if (i >= 0) {
+		aud->treble = i;
+		aud->flags |= VIDEO_AUDIO_TREBLE;
+	}
+	i = get_v4l_control(inode, file, V4L2_CID_AUDIO_BALANCE, drv);
+	if (i >= 0) {
+		aud->balance = i;
+		aud->flags |= VIDEO_AUDIO_BALANCE;
+	}
+	i = get_v4l_control(inode, file, V4L2_CID_AUDIO_MUTE, drv);
+	if (i >= 0) {
+		if (i)
+			aud->flags |= VIDEO_AUDIO_MUTE;
+		aud->flags |= VIDEO_AUDIO_MUTABLE;
+	}
+	aud->step = 1;
+	qctrl2.id = V4L2_CID_AUDIO_VOLUME;
+	if (drv(inode, file, VIDIOC_QUERYCTRL, &qctrl2) == 0 &&
+	    !(qctrl2.flags & V4L2_CTRL_FLAG_DISABLED))
+		aud->step = qctrl2.step;
+	aud->mode = 0;
+
+	memset(&tun2, 0, sizeof(tun2));
+	err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
+	if (err < 0) {
+		dprintk("VIDIOCGAUDIO / VIDIOC_G_TUNER: %d\n", err);
 		err = 0;
-		break;
+		goto done;
 	}
-	case VIDIOCMCAPTURE: /*  capture a frame  */
-	{
-		struct video_mmap	*mm = arg;
 
-		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
-		if (!fmt2) {
-			err = -ENOMEM;
-			break;
-		}
-		memset(&buf2, 0, sizeof(buf2));
+	if (tun2.rxsubchans & V4L2_TUNER_SUB_LANG2)
+		aud->mode = VIDEO_SOUND_LANG1 | VIDEO_SOUND_LANG2;
+	else if (tun2.rxsubchans & V4L2_TUNER_SUB_STEREO)
+		aud->mode = VIDEO_SOUND_STEREO;
+	else if (tun2.rxsubchans & V4L2_TUNER_SUB_MONO)
+		aud->mode = VIDEO_SOUND_MONO;
+done:
+	return err;
+}
 
-		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
-		if (err < 0) {
-			dprintk("VIDIOCMCAPTURE / VIDIOC_G_FMT: %d\n", err);
+static noinline int v4l1_compat_set_audio(
+					struct video_audio *aud,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_audio	aud2;
+	struct v4l2_tuner	tun2;
+
+	memset(&aud2, 0, sizeof(aud2));
+	memset(&tun2, 0, sizeof(tun2));
+
+	aud2.index = aud->audio;
+	err = drv(inode, file, VIDIOC_S_AUDIO, &aud2);
+	if (err < 0) {
+		dprintk("VIDIOCSAUDIO / VIDIOC_S_AUDIO: %d\n", err);
+		goto done;
+	}
+
+	set_v4l_control(inode, file, V4L2_CID_AUDIO_VOLUME,
+			aud->volume, drv);
+	set_v4l_control(inode, file, V4L2_CID_AUDIO_BASS,
+			aud->bass, drv);
+	set_v4l_control(inode, file, V4L2_CID_AUDIO_TREBLE,
+			aud->treble, drv);
+	set_v4l_control(inode, file, V4L2_CID_AUDIO_BALANCE,
+			aud->balance, drv);
+	set_v4l_control(inode, file, V4L2_CID_AUDIO_MUTE,
+			!!(aud->flags & VIDEO_AUDIO_MUTE), drv);
+
+	err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
+	if (err < 0)
+		dprintk("VIDIOCSAUDIO / VIDIOC_G_TUNER: %d\n", err);
+	if (err == 0) {
+		switch (aud->mode) {
+		default:
+		case VIDEO_SOUND_MONO:
+		case VIDEO_SOUND_LANG1:
+			tun2.audmode = V4L2_TUNER_MODE_MONO;
 			break;
-		}
-		if (mm->width   != fmt2->fmt.pix.width  ||
-		    mm->height  != fmt2->fmt.pix.height ||
-		    palette_to_pixelformat(mm->format) !=
-		    fmt2->fmt.pix.pixelformat) {
-			/* New capture format...  */
-			fmt2->fmt.pix.width = mm->width;
-			fmt2->fmt.pix.height = mm->height;
-			fmt2->fmt.pix.pixelformat =
-				palette_to_pixelformat(mm->format);
-			fmt2->fmt.pix.field = V4L2_FIELD_ANY;
-			fmt2->fmt.pix.bytesperline = 0;
-			err = drv(inode, file, VIDIOC_S_FMT, fmt2);
-			if (err < 0) {
-				dprintk("VIDIOCMCAPTURE / VIDIOC_S_FMT: %d\n", err);
-				break;
-			}
-		}
-		buf2.index = mm->frame;
-		buf2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		err = drv(inode, file, VIDIOC_QUERYBUF, &buf2);
-		if (err < 0) {
-			dprintk("VIDIOCMCAPTURE / VIDIOC_QUERYBUF: %d\n", err);
+		case VIDEO_SOUND_STEREO:
+			tun2.audmode = V4L2_TUNER_MODE_STEREO;
 			break;
-		}
-		err = drv(inode, file, VIDIOC_QBUF, &buf2);
-		if (err < 0) {
-			dprintk("VIDIOCMCAPTURE / VIDIOC_QBUF: %d\n", err);
+		case VIDEO_SOUND_LANG2:
+			tun2.audmode = V4L2_TUNER_MODE_LANG2;
 			break;
 		}
-		err = drv(inode, file, VIDIOC_STREAMON, &captype);
+		err = drv(inode, file, VIDIOC_S_TUNER, &tun2);
 		if (err < 0)
-			dprintk("VIDIOCMCAPTURE / VIDIOC_STREAMON: %d\n", err);
-		break;
+			dprintk("VIDIOCSAUDIO / VIDIOC_S_TUNER: %d\n", err);
 	}
-	case VIDIOCSYNC: /*  wait for a frame  */
-	{
-		int			*i = arg;
+	err = 0;
+done:
+	return err;
+}
 
-		memset(&buf2, 0, sizeof(buf2));
-		buf2.index = *i;
-		buf2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		err = drv(inode, file, VIDIOC_QUERYBUF, &buf2);
-		if (err < 0) {
-			/*  No such buffer */
-			dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n", err);
-			break;
-		}
-		if (!(buf2.flags & V4L2_BUF_FLAG_MAPPED)) {
-			/* Buffer is not mapped  */
-			err = -EINVAL;
-			break;
-		}
+static noinline int v4l1_compat_capture_frame(
+					struct video_mmap *mm,
+					struct inode *inode,
+					struct file *file,
+					v4l2_kioctl drv)
+{
+	int err;
+	enum v4l2_buf_type      captype = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	struct v4l2_buffer	buf;
+	struct v4l2_format	*fmt;
 
-		/* make sure capture actually runs so we don't block forever */
-		err = drv(inode, file, VIDIOC_STREAMON, &captype);
+	fmt = kzalloc(sizeof(*fmt), GFP_KERNEL);
+	if (!fmt) {
+		err = -ENOMEM;
+		return err;
+	}
+	memset(&buf, 0, sizeof(buf));
+
+	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	err = drv(inode, file, VIDIOC_G_FMT, fmt);
+	if (err < 0) {
+		dprintk("VIDIOCMCAPTURE / VIDIOC_G_FMT: %d\n", err);
+		goto done;
+	}
+	if (mm->width   != fmt->fmt.pix.width  ||
+	    mm->height  != fmt->fmt.pix.height ||
+	    palette_to_pixelformat(mm->format) !=
+	    fmt->fmt.pix.pixelformat) {
+		/* New capture format...  */
+		fmt->fmt.pix.width = mm->width;
+		fmt->fmt.pix.height = mm->height;
+		fmt->fmt.pix.pixelformat =
+			palette_to_pixelformat(mm->format);
+		fmt->fmt.pix.field = V4L2_FIELD_ANY;
+		fmt->fmt.pix.bytesperline = 0;
+		err = drv(inode, file, VIDIOC_S_FMT, fmt);
 		if (err < 0) {
-			dprintk("VIDIOCSYNC / VIDIOC_STREAMON: %d\n", err);
-			break;
+			dprintk("VIDIOCMCAPTURE / VIDIOC_S_FMT: %d\n", err);
+			goto done;
 		}
+	}
+	buf.index = mm->frame;
+	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	err = drv(inode, file, VIDIOC_QUERYBUF, &buf);
+	if (err < 0) {
+		dprintk("VIDIOCMCAPTURE / VIDIOC_QUERYBUF: %d\n", err);
+		goto done;
+	}
+	err = drv(inode, file, VIDIOC_QBUF, &buf);
+	if (err < 0) {
+		dprintk("VIDIOCMCAPTURE / VIDIOC_QBUF: %d\n", err);
+		goto done;
+	}
+	err = drv(inode, file, VIDIOC_STREAMON, &captype);
+	if (err < 0)
+		dprintk("VIDIOCMCAPTURE / VIDIOC_STREAMON: %d\n", err);
+done:
+	kfree(fmt);
+	return err;
+}
 
-		/*  Loop as long as the buffer is queued, but not done  */
-		while ((buf2.flags &
-			(V4L2_BUF_FLAG_QUEUED | V4L2_BUF_FLAG_DONE))
-		       == V4L2_BUF_FLAG_QUEUED) {
-			err = poll_one(file);
-			if (err < 0 ||	/* error or sleep was interrupted  */
-			    err == 0)	/* timeout? Shouldn't occur.  */
-				break;
-			err = drv(inode, file, VIDIOC_QUERYBUF, &buf2);
-			if (err < 0)
-				dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n", err);
-		}
-		if (!(buf2.flags & V4L2_BUF_FLAG_DONE)) /* not done */
-			break;
-		do {
-			err = drv(inode, file, VIDIOC_DQBUF, &buf2);
-			if (err < 0)
-				dprintk("VIDIOCSYNC / VIDIOC_DQBUF: %d\n", err);
-		} while (err == 0 && buf2.index != *i);
-		break;
+static noinline int v4l1_compat_sync(
+				int *i,
+				struct inode *inode,
+				struct file *file,
+				v4l2_kioctl drv)
+{
+	int err;
+	enum v4l2_buf_type captype = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	struct v4l2_buffer buf;
+
+	memset(&buf, 0, sizeof(buf));
+	buf.index = *i;
+	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	err = drv(inode, file, VIDIOC_QUERYBUF, &buf);
+	if (err < 0) {
+		/*  No such buffer */
+		dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n", err);
+		goto done;
+	}
+	if (!(buf.flags & V4L2_BUF_FLAG_MAPPED)) {
+		/* Buffer is not mapped  */
+		err = -EINVAL;
+		goto done;
 	}
 
-	case VIDIOCGVBIFMT: /* query VBI data capture format */
-	{
-		struct vbi_format      *fmt = arg;
+	/* make sure capture actually runs so we don't block forever */
+	err = drv(inode, file, VIDIOC_STREAMON, &captype);
+	if (err < 0) {
+		dprintk("VIDIOCSYNC / VIDIOC_STREAMON: %d\n", err);
+		goto done;
+	}
 
-		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
-		if (!fmt2) {
-			err = -ENOMEM;
+	/*  Loop as long as the buffer is queued, but not done  */
+	while ((buf.flags & (V4L2_BUF_FLAG_QUEUED | V4L2_BUF_FLAG_DONE))
+						== V4L2_BUF_FLAG_QUEUED) {
+		err = poll_one(file);
+		if (err < 0 ||	/* error or sleep was interrupted  */
+		    err == 0)	/* timeout? Shouldn't occur.  */
 			break;
-		}
-		fmt2->type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		err = drv(inode, file, VIDIOC_QUERYBUF, &buf);
+		if (err < 0)
+			dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n", err);
+	}
+	if (!(buf.flags & V4L2_BUF_FLAG_DONE)) /* not done */
+		goto done;
+	do {
+		err = drv(inode, file, VIDIOC_DQBUF, &buf);
+		if (err < 0)
+			dprintk("VIDIOCSYNC / VIDIOC_DQBUF: %d\n", err);
+	} while (err == 0 && buf.index != *i);
+done:
+	return err;
+}
 
-		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
-		if (err < 0) {
-			dprintk("VIDIOCGVBIFMT / VIDIOC_G_FMT: %d\n", err);
-			break;
-		}
-		if (fmt2->fmt.vbi.sample_format != V4L2_PIX_FMT_GREY) {
-			err = -EINVAL;
-			break;
-		}
-		memset(fmt, 0, sizeof(*fmt));
-		fmt->samples_per_line = fmt2->fmt.vbi.samples_per_line;
-		fmt->sampling_rate    = fmt2->fmt.vbi.sampling_rate;
-		fmt->sample_format    = VIDEO_PALETTE_RAW;
-		fmt->start[0]         = fmt2->fmt.vbi.start[0];
-		fmt->count[0]         = fmt2->fmt.vbi.count[0];
-		fmt->start[1]         = fmt2->fmt.vbi.start[1];
-		fmt->count[1]         = fmt2->fmt.vbi.count[1];
-		fmt->flags            = fmt2->fmt.vbi.flags & 0x03;
-		break;
+static noinline int v4l1_compat_get_vbi_format(
+				struct vbi_format *fmt,
+				struct inode *inode,
+				struct file *file,
+				v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_format *fmt2;
+
+	fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+	if (!fmt2) {
+		err = -ENOMEM;
+		return err;
 	}
-	case VIDIOCSVBIFMT:
-	{
-		struct vbi_format      *fmt = arg;
+	fmt2->type = V4L2_BUF_TYPE_VBI_CAPTURE;
 
-		if (VIDEO_PALETTE_RAW != fmt->sample_format) {
-			err = -EINVAL;
-			break;
-		}
+	err = drv(inode, file, VIDIOC_G_FMT, fmt2);
+	if (err < 0) {
+		dprintk("VIDIOCGVBIFMT / VIDIOC_G_FMT: %d\n", err);
+		goto done;
+	}
+	if (fmt2->fmt.vbi.sample_format != V4L2_PIX_FMT_GREY) {
+		err = -EINVAL;
+		goto done;
+	}
+	memset(fmt, 0, sizeof(*fmt));
+	fmt->samples_per_line = fmt2->fmt.vbi.samples_per_line;
+	fmt->sampling_rate    = fmt2->fmt.vbi.sampling_rate;
+	fmt->sample_format    = VIDEO_PALETTE_RAW;
+	fmt->start[0]         = fmt2->fmt.vbi.start[0];
+	fmt->count[0]         = fmt2->fmt.vbi.count[0];
+	fmt->start[1]         = fmt2->fmt.vbi.start[1];
+	fmt->count[1]         = fmt2->fmt.vbi.count[1];
+	fmt->flags            = fmt2->fmt.vbi.flags & 0x03;
+done:
+	kfree(fmt2);
+	return err;
+}
 
-		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
-		if (!fmt2) {
-			err = -ENOMEM;
-			break;
-		}
-		fmt2->type = V4L2_BUF_TYPE_VBI_CAPTURE;
-		fmt2->fmt.vbi.samples_per_line = fmt->samples_per_line;
-		fmt2->fmt.vbi.sampling_rate    = fmt->sampling_rate;
-		fmt2->fmt.vbi.sample_format    = V4L2_PIX_FMT_GREY;
-		fmt2->fmt.vbi.start[0]         = fmt->start[0];
-		fmt2->fmt.vbi.count[0]         = fmt->count[0];
-		fmt2->fmt.vbi.start[1]         = fmt->start[1];
-		fmt2->fmt.vbi.count[1]         = fmt->count[1];
-		fmt2->fmt.vbi.flags            = fmt->flags;
-		err = drv(inode, file, VIDIOC_TRY_FMT, fmt2);
-		if (err < 0) {
-			dprintk("VIDIOCSVBIFMT / VIDIOC_TRY_FMT: %d\n", err);
-			break;
-		}
+static noinline int v4l1_compat_set_vbi_format(
+				struct vbi_format *fmt,
+				struct inode *inode,
+				struct file *file,
+				v4l2_kioctl drv)
+{
+	int err;
+	struct v4l2_format	*fmt2 = NULL;
 
-		if (fmt2->fmt.vbi.samples_per_line != fmt->samples_per_line ||
-		    fmt2->fmt.vbi.sampling_rate    != fmt->sampling_rate    ||
-		    fmt2->fmt.vbi.sample_format    != V4L2_PIX_FMT_GREY     ||
-		    fmt2->fmt.vbi.start[0]         != fmt->start[0]         ||
-		    fmt2->fmt.vbi.count[0]         != fmt->count[0]         ||
-		    fmt2->fmt.vbi.start[1]         != fmt->start[1]         ||
-		    fmt2->fmt.vbi.count[1]         != fmt->count[1]         ||
-		    fmt2->fmt.vbi.flags            != fmt->flags) {
-			err = -EINVAL;
-			break;
-		}
-		err = drv(inode, file, VIDIOC_S_FMT, fmt2);
-		if (err < 0)
-			dprintk("VIDIOCSVBIFMT / VIDIOC_S_FMT: %d\n", err);
-		break;
+	if (VIDEO_PALETTE_RAW != fmt->sample_format) {
+		err = -EINVAL;
+		return err;
+	}
+
+	fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+	if (!fmt2) {
+		err = -ENOMEM;
+		return err;
 	}
+	fmt2->type = V4L2_BUF_TYPE_VBI_CAPTURE;
+	fmt2->fmt.vbi.samples_per_line = fmt->samples_per_line;
+	fmt2->fmt.vbi.sampling_rate    = fmt->sampling_rate;
+	fmt2->fmt.vbi.sample_format    = V4L2_PIX_FMT_GREY;
+	fmt2->fmt.vbi.start[0]         = fmt->start[0];
+	fmt2->fmt.vbi.count[0]         = fmt->count[0];
+	fmt2->fmt.vbi.start[1]         = fmt->start[1];
+	fmt2->fmt.vbi.count[1]         = fmt->count[1];
+	fmt2->fmt.vbi.flags            = fmt->flags;
+	err = drv(inode, file, VIDIOC_TRY_FMT, fmt2);
+	if (err < 0) {
+		dprintk("VIDIOCSVBIFMT / VIDIOC_TRY_FMT: %d\n", err);
+		goto done;
+	}
+
+	if (fmt2->fmt.vbi.samples_per_line != fmt->samples_per_line ||
+	    fmt2->fmt.vbi.sampling_rate    != fmt->sampling_rate    ||
+	    fmt2->fmt.vbi.sample_format    != V4L2_PIX_FMT_GREY     ||
+	    fmt2->fmt.vbi.start[0]         != fmt->start[0]         ||
+	    fmt2->fmt.vbi.count[0]         != fmt->count[0]         ||
+	    fmt2->fmt.vbi.start[1]         != fmt->start[1]         ||
+	    fmt2->fmt.vbi.count[1]         != fmt->count[1]         ||
+	    fmt2->fmt.vbi.flags            != fmt->flags) {
+		err = -EINVAL;
+		goto done;
+	}
+	err = drv(inode, file, VIDIOC_S_FMT, fmt2);
+	if (err < 0)
+		dprintk("VIDIOCSVBIFMT / VIDIOC_S_FMT: %d\n", err);
+done:
+	kfree(fmt2);
+	return err;
+}
+
+/*
+ *	This function is exported.
+ */
+int
+v4l_compat_translate_ioctl(struct inode         *inode,
+			   struct file		*file,
+			   int			cmd,
+			   void			*arg,
+			   v4l2_kioctl          drv)
+{
+	int err;
 
+	switch (cmd) {
+	case VIDIOCGCAP:	/* capability */
+		err = v4l1_compat_get_capabilities(arg, inode, file, drv);
+		break;
+	case VIDIOCGFBUF: /*  get frame buffer  */
+		err = v4l1_compat_get_frame_buffer(arg, inode, file, drv);
+		break;
+	case VIDIOCSFBUF: /*  set frame buffer  */
+		err = v4l1_compat_set_frame_buffer(arg, inode, file, drv);
+		break;
+	case VIDIOCGWIN: /*  get window or capture dimensions  */
+		err = v4l1_compat_get_win_cap_dimensions(arg, inode, file, drv);
+		break;
+	case VIDIOCSWIN: /*  set window and/or capture dimensions  */
+		err = v4l1_compat_set_win_cap_dimensions(arg, inode, file, drv);
+		break;
+	case VIDIOCCAPTURE: /*  turn on/off preview  */
+		err = v4l1_compat_turn_preview_on_off(arg, inode, file, drv);
+		break;
+	case VIDIOCGCHAN: /*  get input information  */
+		err = v4l1_compat_get_input_info(arg, inode, file, drv);
+		break;
+	case VIDIOCSCHAN: /*  set input  */
+		err = v4l1_compat_set_input(arg, inode, file, drv);
+		break;
+	case VIDIOCGPICT: /*  get tone controls & partial capture format  */
+		err = v4l1_compat_get_picture(arg, inode, file, drv);
+		break;
+	case VIDIOCSPICT: /*  set tone controls & partial capture format  */
+		err = v4l1_compat_set_picture(arg, inode, file, drv);
+		break;
+	case VIDIOCGTUNER: /*  get tuner information  */
+		err = v4l1_compat_get_tuner(arg, inode, file, drv);
+		break;
+	case VIDIOCSTUNER: /*  select a tuner input  */
+		err = v4l1_compat_select_tuner(arg, inode, file, drv);
+		break;
+	case VIDIOCGFREQ: /*  get frequency  */
+		err = v4l1_compat_get_frequency(arg, inode, file, drv);
+		break;
+	case VIDIOCSFREQ: /*  set frequency  */
+		err = v4l1_compat_set_frequency(arg, inode, file, drv);
+		break;
+	case VIDIOCGAUDIO: /*  get audio properties/controls  */
+		err = v4l1_compat_get_audio(arg, inode, file, drv);
+		break;
+	case VIDIOCSAUDIO: /*  set audio controls  */
+		err = v4l1_compat_set_audio(arg, inode, file, drv);
+		break;
+	case VIDIOCMCAPTURE: /*  capture a frame  */
+		err = v4l1_compat_capture_frame(arg, inode, file, drv);
+		break;
+	case VIDIOCSYNC: /*  wait for a frame  */
+		err = v4l1_compat_sync(arg, inode, file, drv);
+		break;
+	case VIDIOCGVBIFMT: /* query VBI data capture format */
+		err = v4l1_compat_get_vbi_format(arg, inode, file, drv);
+		break;
+	case VIDIOCSVBIFMT:
+		err = v4l1_compat_set_vbi_format(arg, inode, file, drv);
+		break;
 	default:
 		err = -ENOIOCTLCMD;
 		break;
 	}
 
-	kfree(cap2);
-	kfree(fmt2);
 	return err;
 }
 EXPORT_SYMBOL(v4l_compat_translate_ioctl);
-- 
1.5.3.7

