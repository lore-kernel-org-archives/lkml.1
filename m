Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZKBHlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZKBHlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZKBHlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:41:10 -0500
Received: from smtprelay08.ispgateway.de ([80.67.31.42]:38015 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbZKBHlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:41:09 -0500
Message-ID: <4AEE8D19.10305@ladisch.de>
Date: Mon, 02 Nov 2009 08:41:13 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drm/fb: fix FBIOGET/PUT_VSCREENINFO pixel clock handling
References: <4AEE8CDD.10600@ladisch.de>
In-Reply-To: <4AEE8CDD.10600@ladisch.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the framebuffer driver does not publish detailed timing information
for the current video mode, the correct value for the pixclock field is
zero, not -1.

Since pixclock is actually unsigned, the value -1 would be interpreted
as 4294967295 picoseconds (i.e., about 4 milliseconds) by
register_framebuffer() and userspace programs.

This patch allows X.org's fbdev driver to work.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- linux-2.6/drivers/gpu/drm/drm_fb_helper.c
+++ linux-2.6/drivers/gpu/drm/drm_fb_helper.c
@@ -583,7 +583,7 @@ int drm_fb_helper_check_var(struct fb_va
 	struct drm_framebuffer *fb = fb_helper->fb;
 	int depth;
 
-	if (var->pixclock == -1 || !var->pixclock)
+	if (var->pixclock != 0)
 		return -EINVAL;
 
 	/* Need to resize the fb object !!! */
@@ -675,7 +675,7 @@ int drm_fb_helper_set_par(struct fb_info
 	int ret;
 	int i;
 
-	if (var->pixclock != -1) {
+	if (var->pixclock != 0) {
 		DRM_ERROR("PIXEL CLCOK SET\n");
 		return -EINVAL;
 	}
@@ -888,7 +888,7 @@ int drm_fb_helper_single_fb_probe(struct
 	fb_helper->fb = fb;
 
 	if (new_fb) {
-		info->var.pixclock = -1;
+		info->var.pixclock = 0;
 		if (register_framebuffer(info) < 0)
 			return -EINVAL;
 	} else {
