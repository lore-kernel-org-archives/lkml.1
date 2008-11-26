Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYKZWTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYKZWTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYKZWTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:19:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:29937 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbYKZWTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:19:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=EGs7gmD+I0TSgSF9f1PofNBHQSDxRRn/yY/k2/+AVUflJCVOCR3B/WB/pjz9PG72Kf
         AUBclMepKIZ3fgxiPpXjkSQF0ffWTmDjUKJgaMNXgW2OVUkVmlIK2SdpUPrsTXwZO21f
         UhBaNs0F/LI2kyuQUrZM3QyjpAFbko1VKqr9A=
Message-ID: <492DCB50.9040005@gmail.com>
Date: Wed, 26 Nov 2008 17:18:56 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: adaplas@gmail.com
CC: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] gbefb: unsigned var->pixclock cannot be less than 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned var->pixclock cannot be less than 0

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
var->pixclock has type __u32, see
vi include/linux/fb.h +231

compute_gbe_timing() returns int, see
vi drivers/video/gbefb.c +466

diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index f89c3cc..fe5b519 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -912,6 +912,7 @@ static int gbefb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	unsigned int line_length;
 	struct gbe_timing_info timing;
+	int ret;
 
 	/* Limit bpp to 8, 16, and 32 */
 	if (var->bits_per_pixel <= 8)
@@ -930,8 +931,10 @@ static int gbefb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 	var->grayscale = 0;	/* No grayscale for now */
 
-	if ((var->pixclock = compute_gbe_timing(var, &timing)) < 0)
-		return(-EINVAL);
+	ret = compute_gbe_timing(var, &timing);
+	var->pixclock = ret;
+	if (ret < 0)
+		return -EINVAL;
 
 	/* Adjust virtual resolution, if necessary */
 	if (var->xres > var->xres_virtual || (!ywrap && !ypan))

