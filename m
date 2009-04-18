Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbZDRPAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbZDRPAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 11:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758542AbZDRO7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 10:59:42 -0400
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:51228 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441AbZDRO7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:59:41 -0400
Message-ID: <49E9EAC8.9000706@freemail.hu>
Date: Sat, 18 Apr 2009 16:59:20 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>, video4linux-list@redhat.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]: uvcvideo: fill reserved fields with zero of VIDIOC_QUERYMENU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00d.mail.t-online.hu 32720; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When querying menu items with VIDIOC_QUERYMENU the reserved field
is not set to zero as required by V4L2 API revision 0.24 [1].
Add this fill.

The patch was tested with v4l-test 0.11 [2] with CNF7129 webcam found
on EeePC 901.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/r13317.htm#V4L2-QUERYMENU

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.30-rc2/drivers/media/video/uvc/uvc_v4l2.c.orig	2009-04-17 18:31:29.000000000 +0200
+++ linux-2.6.30-rc2/drivers/media/video/uvc/uvc_v4l2.c	2009-04-18 16:43:20.000000000 +0200
@@ -46,6 +46,8 @@ static int uvc_v4l2_query_menu(struct uv
 	struct uvc_menu_info *menu_info;
 	struct uvc_control_mapping *mapping;
 	struct uvc_control *ctrl;
+	__u32 id;
+	__u32 index;

 	ctrl = uvc_find_control(video, query_menu->id, &mapping);
 	if (ctrl == NULL || mapping->v4l2_type != V4L2_CTRL_TYPE_MENU)
@@ -54,6 +56,11 @@ static int uvc_v4l2_query_menu(struct uv
 	if (query_menu->index >= mapping->menu_count)
 		return -EINVAL;

+	id = query_menu->id;
+	index = query_menu->index;
+	memset(query_menu, 0, sizeof(*query_menu));
+	query_menu->id = id;
+	query_menu->index = index;
 	menu_info = &mapping->menu_info[query_menu->index];
 	strlcpy(query_menu->name, menu_info->name, sizeof query_menu->name);
 	return 0;
