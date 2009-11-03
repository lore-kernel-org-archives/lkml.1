Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZKCMSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZKCMSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZKCMSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:18:53 -0500
Received: from smtprelay06.ispgateway.de ([80.67.18.44]:32922 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZKCMSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:18:53 -0500
Message-ID: <4AF01FAA.2040909@ladisch.de>
Date: Tue, 03 Nov 2009 13:18:50 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: dri-devel@lists.sourceforge.net, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] drm/fb: fix FBIOGET/PUT_VSCREENINFO pixel clock handling
References: <4AEE8CDD.10600@ladisch.de> <4AEE8D6F.60209@ladisch.de> <alpine.LFD.2.00.0911021431360.30135@casper.infradead.org> <4AF01F72.2030605@ladisch.de>
In-Reply-To: <4AF01F72.2030605@ladisch.de>
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
---
No changes from v1.

 drivers/gpu/drm/drm_fb_helper.c |   6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6/drivers/gpu/drm/drm_fb_helper.c
+++ linux-2.6/drivers/gpu/drm/drm_fb_helper.c
@@ -599,7 +599,7 @@ int drm_fb_helper_check_var(struct fb_va
 	struct drm_framebuffer *fb = fb_helper->fb;
 	int depth;
 
-	if (var->pixclock == -1 || !var->pixclock)
+	if (var->pixclock != 0)
 		return -EINVAL;
 
 	/* Need to resize the fb object !!! */
@@ -691,7 +691,7 @@ int drm_fb_helper_set_par(struct fb_info
 	int ret;
 	int i;
 
-	if (var->pixclock != -1) {
+	if (var->pixclock != 0) {
 		DRM_ERROR("PIXEL CLCOK SET\n");
 		return -EINVAL;
 	}
@@ -904,7 +904,7 @@ int drm_fb_helper_single_fb_probe(struct
 	fb_helper->fb = fb;
 
 	if (new_fb) {
-		info->var.pixclock = -1;
+		info->var.pixclock = 0;
 		if (register_framebuffer(info) < 0)
 			return -EINVAL;
 	} else {

