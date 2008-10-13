Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYJMUy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYJMUy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYJMUyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:54:15 -0400
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:57280 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbYJMUyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:54:14 -0400
Message-ID: <48F3B56E.9050404@freemail.hu>
Date: Mon, 13 Oct 2008 22:54:06 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: video4linux-list@redhat.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] video: simplify cx18_get_input() and ivtv_get_input()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32722; Body=2 Fuz1=2
	Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The cx18_get_input() and ivtv_get_input() are called
once from the VIDIOC_ENUMINPUT ioctl() and once from
the *_log_status() functions. In the first case the
struct v4l2_input is already filled with zeros,
so doing this again is unnecessary.

The *_log_status() functions are called from
VIDIOC_LOG_STATUS ioctl() which is only used for
debug purposes, so it is worth to move the filling
with zeros to a least frequently used function.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr linux-2.6.27.orig/drivers/media/video/cx18/cx18-cards.c linux-2.6.27/drivers/media/video/cx18/cx18-cards.c
--- linux-2.6.27.orig/drivers/media/video/cx18/cx18-cards.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/cx18/cx18-cards.c	2008-10-13 21:27:54.000000000 +0200
@@ -320,10 +320,9 @@ int cx18_get_input(struct cx18 *cx, u16
 		"Composite 3"
 	};

-	memset(input, 0, sizeof(*input));
 	if (index >= cx->nof_inputs)
 		return -EINVAL;
-	input->index = index;
+
 	strlcpy(input->name, input_strs[card_input->video_type - 1],
 			sizeof(input->name));
 	input->type = (card_input->video_type == CX18_CARD_INPUT_VID_TUNER ?
diff -upr linux-2.6.27.orig/drivers/media/video/cx18/cx18-ioctl.c linux-2.6.27/drivers/media/video/cx18/cx18-ioctl.c
--- linux-2.6.27.orig/drivers/media/video/cx18/cx18-ioctl.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/cx18/cx18-ioctl.c	2008-10-13 21:28:11.000000000 +0200
@@ -712,7 +712,11 @@ static int cx18_log_status(struct file *
 		cx18_read_eeprom(cx, &tv);
 	}
 	cx18_call_i2c_clients(cx, VIDIOC_LOG_STATUS, NULL);
+
+	memset(&vidin, 0, sizeof(vidin));
+	vidin.index = cx->active_input;
 	cx18_get_input(cx, cx->active_input, &vidin);
+
 	cx18_get_audio_input(cx, cx->audio_input, &audin);
 	CX18_INFO("Video Input: %s\n", vidin.name);
 	CX18_INFO("Audio Input: %s\n", audin.name);
diff -upr linux-2.6.27.orig/drivers/media/video/ivtv/ivtv-cards.c linux-2.6.27/drivers/media/video/ivtv/ivtv-cards.c
--- linux-2.6.27.orig/drivers/media/video/ivtv/ivtv-cards.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/ivtv/ivtv-cards.c	2008-10-13 21:22:59.000000000 +0200
@@ -1199,10 +1199,9 @@ int ivtv_get_input(struct ivtv *itv, u16
 		"Composite 3"
 	};

-	memset(input, 0, sizeof(*input));
 	if (index >= itv->nof_inputs)
 		return -EINVAL;
-	input->index = index;
+
 	strlcpy(input->name, input_strs[card_input->video_type - 1],
 			sizeof(input->name));
 	input->type = (card_input->video_type == IVTV_CARD_INPUT_VID_TUNER ?
diff -upr linux-2.6.27.orig/drivers/media/video/ivtv/ivtv-ioctl.c linux-2.6.27/drivers/media/video/ivtv/ivtv-ioctl.c
--- linux-2.6.27.orig/drivers/media/video/ivtv/ivtv-ioctl.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/drivers/media/video/ivtv/ivtv-ioctl.c	2008-10-13 21:21:35.000000000 +0200
@@ -1446,7 +1446,11 @@ static int ivtv_log_status(struct file *
 		ivtv_read_eeprom(itv, &tv);
 	}
 	ivtv_call_i2c_clients(itv, VIDIOC_LOG_STATUS, NULL);
+
+	memset(&vidin, 0, sizeof(vidin));
+	vidin.index = itv->active_input;
 	ivtv_get_input(itv, itv->active_input, &vidin);
+
 	ivtv_get_audio_input(itv, itv->audio_input, &audin);
 	IVTV_INFO("Video Input:  %s\n", vidin.name);
 	IVTV_INFO("Audio Input:  %s%s\n", audin.name,
