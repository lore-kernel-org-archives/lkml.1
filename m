Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZAARPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZAARPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 12:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbZAARPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 12:15:04 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46746 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbZAARPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 12:15:02 -0500
Date: Thu, 1 Jan 2009 18:14:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/media/video: Use usb_set_intfdata
Message-ID: <Pine.LNX.4.64.0901011814360.20447@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This code had calls to both usb_set_intfdata and dev_set_drvdata, doing the
same thing.

The semantic patch that lead to finding this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@header@
@@

#include <linux/usb.h>

@same depends on header@
position p;
@@

usb_set_intfdata@p(...) { ... }

@depends on header@
position _p!=same.p;
identifier _f;
struct usb_interface *intf;
expression data;
@@

_f@_p(...) { <+...
- dev_set_drvdata(&intf->dev, data);
+ usb_set_intfdata(intf, data);
...+> }

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/zr364xx.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index a1d81ed..ab7cbbd 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -894,7 +894,6 @@ static void zr364xx_disconnect(struct usb_interface *intf)
 {
 	struct zr364xx_camera *cam = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
-	dev_set_drvdata(&intf->dev, NULL);
 	dev_info(&intf->dev, DRIVER_DESC " webcam unplugged\n");
 	if (cam->vdev)
 		video_unregister_device(cam->vdev);
