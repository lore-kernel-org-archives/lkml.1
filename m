Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYJMUxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYJMUxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYJMUxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:53:45 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:55892 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbYJMUxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:53:44 -0400
Message-ID: <48F3B549.8080907@freemail.hu>
Date: Mon, 13 Oct 2008 22:53:29 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: video4linux-list@redhat.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/1] video: simplify different VIDIOC_ENUMINPUT implementations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32721; Body=2 Fuz1=2
	Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The vidioc_enum_input() functions are only called from
drivers/media/video/v4l2-ioctl.c when the VIDIOC_ENUMINPUT
ioctl() call is executed. Before the driver is called
the struct v4l2_input is already filled with zeros,
so doing this again is unnecessary.

When the buffer is not filled with zeros, then it is also
not needed to restore the .index field.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr linux-2.6.27.orig/drivers/media/video/bt8xx/bttv-driver.c linux-2.6.27/drivers/media/video/bt8xx/bttv-driver.c
--- linux-2.6.27.orig/drivers/media/video/bt8xx/bttv-driver.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/bt8xx/bttv-driver.c	2008-10-13 21:05:22.000000000 +0200
@@ -1892,9 +1892,6 @@ static int bttv_enum_input(struct file *
 	if (n >= bttv_tvcards[btv->c.type].video_inputs)
 		return -EINVAL;

-	memset(i, 0, sizeof(*i));
-
-	i->index    = n;
 	i->type     = V4L2_INPUT_TYPE_CAMERA;
 	i->audioset = 1;

diff -upr linux-2.6.27.orig/drivers/media/video/cx23885/cx23885-417.c linux-2.6.27/drivers/media/video/cx23885/cx23885-417.c
--- linux-2.6.27.orig/drivers/media/video/cx23885/cx23885-417.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/cx23885/cx23885-417.c	2008-10-13 21:01:14.000000000 +0200
@@ -1210,9 +1210,6 @@ static int vidioc_enum_input(struct file
 	if (input->type == 0)
 		return -EINVAL;

-	memset(i, 0, sizeof(*i));
-	i->index = n;
-
 	/* FIXME
 	 * strcpy(i->name, input->name); */
 	strcpy(i->name, "unset");
diff -upr linux-2.6.27.orig/drivers/media/video/cx23885/cx23885-video.c linux-2.6.27/drivers/media/video/cx23885/cx23885-video.c
--- linux-2.6.27.orig/drivers/media/video/cx23885/cx23885-video.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/cx23885/cx23885-video.c	2008-10-13 21:05:44.000000000 +0200
@@ -1169,8 +1169,6 @@ int cx23885_enum_input(struct cx23885_de
 	if (0 == INPUT(n)->type)
 		return -EINVAL;

-	memset(i, 0, sizeof(*i));
-	i->index = n;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, iname[INPUT(n)->type]);
 	if ((CX23885_VMUX_TELEVISION == INPUT(n)->type) ||
diff -upr linux-2.6.27.orig/drivers/media/video/cx88/cx88-video.c linux-2.6.27/drivers/media/video/cx88/cx88-video.c
--- linux-2.6.27.orig/drivers/media/video/cx88/cx88-video.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/cx88/cx88-video.c	2008-10-13 21:04:07.000000000 +0200
@@ -1260,8 +1260,6 @@ int cx88_enum_input (struct cx88_core  *
 		return -EINVAL;
 	if (0 == INPUT(n).type)
 		return -EINVAL;
-	memset(i,0,sizeof(*i));
-	i->index = n;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name,iname[INPUT(n).type]);
 	if ((CX88_VMUX_TELEVISION == INPUT(n).type) ||
diff -upr linux-2.6.27.orig/drivers/media/video/em28xx/em28xx-video.c linux-2.6.27/drivers/media/video/em28xx/em28xx-video.c
--- linux-2.6.27.orig/drivers/media/video/em28xx/em28xx-video.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/em28xx/em28xx-video.c	2008-10-13 21:04:53.000000000 +0200
@@ -868,7 +868,6 @@ static int vidioc_enum_input(struct file
 	if (0 == INPUT(n)->type)
 		return -EINVAL;

-	i->index = n;
 	i->type = V4L2_INPUT_TYPE_CAMERA;

 	strcpy(i->name, iname[INPUT(n)->type]);
diff -upr linux-2.6.27.orig/drivers/media/video/gspca/gspca.c linux-2.6.27/drivers/media/video/gspca/gspca.c
--- linux-2.6.27.orig/drivers/media/video/gspca/gspca.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/gspca/gspca.c	2008-10-13 21:11:04.000000000 +0200
@@ -956,7 +956,7 @@ static int vidioc_enum_input(struct file

 	if (input->index != 0)
 		return -EINVAL;
-	memset(input, 0, sizeof *input);
+
 	input->type = V4L2_INPUT_TYPE_CAMERA;
 	strncpy(input->name, gspca_dev->sd_desc->name,
 		sizeof input->name);
diff -upr linux-2.6.27.orig/drivers/media/video/meye.c linux-2.6.27/drivers/media/video/meye.c
--- linux-2.6.27.orig/drivers/media/video/meye.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/meye.c	2008-10-13 21:02:03.000000000 +0200
@@ -1037,8 +1037,6 @@ static int vidioc_enum_input(struct file
 	if (i->index != 0)
 		return -EINVAL;

-	memset(i, 0, sizeof(*i));
-	i->index = 0;
 	strcpy(i->name, "Camera");
 	i->type = V4L2_INPUT_TYPE_CAMERA;

diff -upr linux-2.6.27.orig/drivers/media/video/saa7134/saa7134-video.c linux-2.6.27/drivers/media/video/saa7134/saa7134-video.c
--- linux-2.6.27.orig/drivers/media/video/saa7134/saa7134-video.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/saa7134/saa7134-video.c	2008-10-13 21:09:16.000000000 +0200
@@ -1712,8 +1712,7 @@ static int saa7134_enum_input(struct fil
 		return -EINVAL;
 	if (NULL == card_in(dev, i->index).name)
 		return -EINVAL;
-	memset(i, 0, sizeof(*i));
-	i->index = n;
+
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, card_in(dev, n).name);
 	if (card_in(dev, n).tv)
diff -upr linux-2.6.27.orig/drivers/media/video/vino.c linux-2.6.27/drivers/media/video/vino.c
--- linux-2.6.27.orig/drivers/media/video/vino.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/vino.c	2008-10-13 21:03:08.000000000 +0200
@@ -3020,9 +3020,6 @@ static int vino_v4l2_enuminput(struct vi
 	if (input == VINO_INPUT_NONE)
 		return -EINVAL;

-	memset(i, 0, sizeof(struct v4l2_input));
-
-	i->index = index;
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	i->std = vino_inputs[input].std;
 	strcpy(i->name, vino_inputs[input].name);
diff -upr linux-2.6.27.orig/drivers/media/video/zr364xx.c linux-2.6.27/drivers/media/video/zr364xx.c
--- linux-2.6.27.orig/drivers/media/video/zr364xx.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/zr364xx.c	2008-10-13 21:34:56.000000000 +0200
@@ -434,8 +434,7 @@ static int zr364xx_vidioc_enum_input(str
 {
 	if (i->index != 0)
 		return -EINVAL;
-	memset(i, 0, sizeof(*i));
-	i->index = 0;
+
 	strcpy(i->name, DRIVER_DESC " Camera");
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	return 0;
