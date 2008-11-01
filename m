Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYKAUAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYKAUAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 16:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYKAUAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 16:00:12 -0400
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:56670 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYKAUAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 16:00:11 -0400
Message-ID: <490CB545.90702@freemail.hu>
Date: Sat, 01 Nov 2008 21:00:05 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Robert William Fuller <hydrologiccycle@gmail.com>,
       video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] video: simplify cx18_get_input() and ivtv_get_input()
References: <48F3B56E.9050404@freemail.hu> <200810132328.47170.hverkuil@xs4all.nl> <48F3C060.2050302@gmail.com> <200810132349.06834.hverkuil@xs4all.nl>
In-Reply-To: <200810132349.06834.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02a.mail.t-online.hu 32710; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The cx18_get_input() and ivtv_get_input() are called
once from the VIDIOC_ENUMINPUT ioctl() (see
drivers/media/video/v4l2-ioctl.c:1165) and once from
the *_log_status() functions. In the first case the
struct v4l2_input is already filled with zeros,
so doing this again is unnecessary.

The second case is only used for debugging purposes
from the VIDIOC_LOG_STATUS ioctl(). Currently only
the "name" field is used in the *_log_status() functions.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr linux-2.6.28-rc1.orig/drivers/media/video/cx18/cx18-cards.c linux-2.6.28-rc1/drivers/media/video/cx18/cx18-cards.c
--- linux-2.6.28-rc1.orig/drivers/media/video/cx18/cx18-cards.c	2008-11-01 20:27:58.000000000 +0100
+++ linux-2.6.28-rc1/drivers/media/video/cx18/cx18-cards.c	2008-11-01 20:36:39.000000000 +0100
@@ -419,10 +419,8 @@ int cx18_get_input(struct cx18 *cx, u16
 		"Composite 3"
 	};

-	memset(input, 0, sizeof(*input));
 	if (index >= cx->nof_inputs)
 		return -EINVAL;
-	input->index = index;
 	strlcpy(input->name, input_strs[card_input->video_type - 1],
 			sizeof(input->name));
 	input->type = (card_input->video_type == CX18_CARD_INPUT_VID_TUNER ?
diff -upr linux-2.6.28-rc1.orig/drivers/media/video/ivtv/ivtv-cards.c linux-2.6.28-rc1/drivers/media/video/ivtv/ivtv-cards.c
--- linux-2.6.28-rc1.orig/drivers/media/video/ivtv/ivtv-cards.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.28-rc1/drivers/media/video/ivtv/ivtv-cards.c	2008-11-01 20:37:27.000000000 +0100
@@ -1199,10 +1199,8 @@ int ivtv_get_input(struct ivtv *itv, u16
 		"Composite 3"
 	};

-	memset(input, 0, sizeof(*input));
 	if (index >= itv->nof_inputs)
 		return -EINVAL;
-	input->index = index;
 	strlcpy(input->name, input_strs[card_input->video_type - 1],
 			sizeof(input->name));
 	input->type = (card_input->video_type == IVTV_CARD_INPUT_VID_TUNER ?
