Return-Path: <linux-kernel-owner+w=401wt.eu-S934387AbZLGAQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387AbZLGAQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbZLGAQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:16:36 -0500
Received: from kroah.org ([198.145.64.141]:34719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839AbZLGAOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:07:00 2009
Message-Id: <20091207000659.932750419@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Airlie <airlied@redhat.com>,
       Paulius Zaleckas <paulius.zaleckas@gmail.com>,
       Clemens Ladisch <clemens@ladisch.de>
Subject: [110/119] drm/fb: fix FBIOGET/PUT_VSCREENINFO pixel clock handling
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=drm-fb-fix-fbioget-put_vscreeninfo-pixel-clock-handling.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit 5349ef3127c77075ff70b2014f17ae0fbcaaf199 upstream

When the framebuffer driver does not publish detailed timing information
for the current video mode, the correct value for the pixclock field is
zero, not -1.

Since pixclock is actually unsigned, the value -1 would be interpreted
as 4294967295 picoseconds (i.e., about 4 milliseconds) by
register_framebuffer() and userspace programs.

This patch allows X.org's fbdev driver to work.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Tested-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_fb.c    |    8 ++++----
 drivers/gpu/drm/radeon/radeon_fb.c |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -114,7 +114,7 @@ static int intelfb_check_var(struct fb_v
 	struct drm_framebuffer *fb = &intel_fb->base;
 	int depth;
 
-	if (var->pixclock == -1 || !var->pixclock)
+	if (var->pixclock != 0)
 		return -EINVAL;
 
 	/* Need to resize the fb object !!! */
@@ -205,7 +205,7 @@ static int intelfb_set_par(struct fb_inf
 
 	DRM_DEBUG("%d %d\n", var->xres, var->pixclock);
 
-	if (var->pixclock != -1) {
+	if (var->pixclock != 0) {
 
 		DRM_ERROR("PIXEL CLOCK SET\n");
 		return -EINVAL;
@@ -692,7 +692,7 @@ static int intelfb_multi_fb_probe_crtc(s
 	par->crtc_count = 1;
 
 	if (new_fb) {
-		info->var.pixclock = -1;
+		info->var.pixclock = 0;
 		if (register_framebuffer(info) < 0)
 			return -EINVAL;
 	} else
@@ -846,7 +846,7 @@ static int intelfb_single_fb_probe(struc
 	par->crtc_count = crtc_count;
 
 	if (new_fb) {
-		info->var.pixclock = -1;
+		info->var.pixclock = 0;
 		if (register_framebuffer(info) < 0)
 			return -EINVAL;
 	} else
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -120,7 +120,7 @@ static int radeonfb_check_var(struct fb_
 	struct drm_framebuffer *fb = &rfb->base;
 	int depth;
 
-	if (var->pixclock == -1 || !var->pixclock) {
+	if (var->pixclock != 0) {
 		return -EINVAL;
 	}
 	/* Need to resize the fb object !!! */
@@ -234,7 +234,7 @@ static int radeonfb_set_par(struct fb_in
 	int ret;
 	int i;
 
-	if (var->pixclock != -1) {
+	if (var->pixclock != 0) {
 		DRM_ERROR("PIXEL CLCOK SET\n");
 		return -EINVAL;
 	}
@@ -828,7 +828,7 @@ static int radeonfb_single_fb_probe(stru
 	rfbdev->crtc_count = crtc_count;
 
 	if (new_fb) {
-		info->var.pixclock = -1;
+		info->var.pixclock = 0;
 		if (register_framebuffer(info) < 0)
 			return -EINVAL;
 	} else {


