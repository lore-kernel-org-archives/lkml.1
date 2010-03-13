Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935605Ab0CMAdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:33:05 -0500
Received: from kroah.org ([198.145.64.141]:46903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935413Ab0CMAba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:30 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:09 2010
Message-Id: <20100313002709.858526562@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Airlie <airlied@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [053/145] offb: Add support for framebuffer handoff to offb.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Dave Airlie <airlied@ppcg5.localdomain>

commit ceae8cbe94f3127253110e2d01b9334069e93177 upstream.

This allows offb to be used for initial framebuffer,
and a kms driver to take over later in the boot sequence.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/offb.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/video/offb.c
+++ b/drivers/video/offb.c
@@ -282,8 +282,17 @@ static int offb_set_par(struct fb_info *
 	return 0;
 }
 
+static void offb_destroy(struct fb_info *info)
+{
+	if (info->screen_base)
+		iounmap(info->screen_base);
+	release_mem_region(info->aperture_base, info->aperture_size);
+	framebuffer_release(info);
+}
+
 static struct fb_ops offb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_destroy	= offb_destroy,
 	.fb_setcolreg	= offb_setcolreg,
 	.fb_set_par	= offb_set_par,
 	.fb_blank	= offb_blank,
@@ -482,10 +491,14 @@ static void __init offb_init_fb(const ch
 	var->sync = 0;
 	var->vmode = FB_VMODE_NONINTERLACED;
 
+	/* set offb aperture size for generic probing */
+	info->aperture_base = address;
+	info->aperture_size = fix->smem_len;
+
 	info->fbops = &offb_ops;
 	info->screen_base = ioremap(address, fix->smem_len);
 	info->pseudo_palette = (void *) (info + 1);
-	info->flags = FBINFO_DEFAULT | foreign_endian;
+	info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE | foreign_endian;
 
 	fb_alloc_cmap(&info->cmap, 256, 0);
 


