Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZD0L63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZD0L63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZD0L6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:58:20 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47625 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbZD0L6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=OOKesPmz22LCrGW2YOXHS4Sr+c3C57I//5T+AGm70psHqxzN4YAszN8tkEt2E9OUKT
         F6ln7x5+QvTDj9vu/Yx63YOIzRFeVvnPONX2NhBwQLYhx5VhfGHEDbpC5cA0RHPy4fC+
         OmZGAg3FZ95ItYQzOn2Et7I+B1OFBhrAa4TsY=
Message-ID: <49F59DD9.6010903@gmail.com>
Date: Mon, 27 Apr 2009 13:58:17 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] fbcmap: non working tests on unsigned	cmap->start
References: <49EDD799.8060607@gmail.com> <20090423134110.51ea8df2.akpm@linux-foundation.org> <20090423214738.GF7134@sci.fi> <49F4519F.4090003@gmail.com> <20090426131505.GG7134@sci.fi>
In-Reply-To: <20090426131505.GG7134@sci.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ville Syrjälä wrote:
> On Sun, Apr 26, 2009 at 02:20:47PM +0200, Roel Kluin wrote:
>> cmap->start is unsigned,

>>> On Thu, Apr 23, 2009 at 01:41:10PM -0700, Andrew Morton wrote:
>>>> argh.
>>>>
>>>> - Perhaps userspace can kill the kernel by sending a "negative"
>>>>   `start'.  Removing the test will make it even less likely that we'll
>>>>   fix this bug.
>>> Shouldn't happen. 'start' is used as the starting index for the hardware
>>> palette, 'start+len-1' is the last index. All drivers should already check
>>> the passed values since the maximum index depends on the display mode.
>>> And I suppose the worst thing that could happen if the driver fails to
>>> check the values would be incorrect colors.

> You would rather need something like
> 'if (start+len > 1 << max(red.len, green.len, blue.len, transp.len))'

what do you mean with `red.len'? is that `info->var.red.length'?

> and a check to make sure that start+len doesn't overflow.
> 
> Oh and I guess it should also check that the visual is pseudocolor or
> directcolor.

I am fairly new so please review carefully.

Not yet signed off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index f53b9f1..b34e74e 100644
--- a/drivers/video/fbcmap.c
+++ b/drivers/video/fbcmap.c
@@ -249,6 +249,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 {
 	int rc, size = cmap->len * sizeof(u16);
 	struct fb_cmap umap;
+	__u32 rgba_max = 0;
 
 	memset(&umap, 0, sizeof(struct fb_cmap));
 	rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
@@ -261,13 +262,27 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 		rc = -EFAULT;
 		goto out;
 	}
+
+	if (cmap->start + cmap->len < cmap->start) {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	umap.start = cmap->start;
 	if (!lock_fb_info(info)) {
 		rc = -ENODEV;
 		goto out;
 	}
-	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
-				!info->fbops->fb_setcmap)) {
+
+	rgba_max = max(info->var.red.length, info->var.green.length);
+	rgba_max = max(rgba_max, info->var.blue.length);
+	rgba_max = max(rgba_max, info->var.transp.length);
+
+	if (cmap->start + cmap->len > 1 << rgba_max ||
+			!(info->fbops->fb_setcolreg ||
+				info->fbops->fb_setcmap) ||
+			!(info->fix.visual == FB_VISUAL_PSEUDOCOLOR ||
+				info->fix.visual == FB_VISUAL_TRUECOLOR)) {
 		rc = -EINVAL;
 		goto out1;
 	}
