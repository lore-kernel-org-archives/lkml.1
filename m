Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYDWSvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYDWSvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYDWSvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:51:18 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:37359 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYDWSvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:51:17 -0400
Message-ID: <480F8522.4090805@tiscali.nl>
Date: Wed, 23 Apr 2008 20:51:14 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] atafb: test virtual screen range before subtraction on unsigned
References: <480F6FF9.9000605@tiscali.nl>
In-Reply-To: <480F6FF9.9000605@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a bit similar to vga16fb,
---
dx and dy are u32's, so the test should occur before the subtraction

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index 5d4fbaa..8f60a8f 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -2593,13 +2593,16 @@ static void atafb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 	width = x2 - dx;
 	height = y2 - dy;
 
+	if (area->sx + dx < area->dx || area->sy + dy < area->dy)
+		return;
+
 	/* update sx,sy */
 	sx = area->sx + (dx - area->dx);
 	sy = area->sy + (dy - area->dy);
 
 	/* the source must be completely inside the virtual screen */
-	if (sx < 0 || sy < 0 || (sx + width) > info->var.xres_virtual ||
-	    (sy + height) > info->var.yres_virtual)
+	if (sx + width > info->var.xres_virtual ||
+			sy + height > info->var.yres_virtual)
 		return;
 
 	if (dy > sy || (dy == sy && dx > sx)) {

