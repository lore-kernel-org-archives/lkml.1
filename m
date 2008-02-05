Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYBEPqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYBEPqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbYBEPpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:45:07 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:49927 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759313AbYBEPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:45:05 -0500
Date: Tue, 5 Feb 2008 18:44:45 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: adaplas@gmail.com, linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Subject: [PATCH 2/2] [POWERPC] offb: add support for foreign endianness
Message-ID: <20080205154445.GB8749@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/video/offb.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/video/offb.c b/drivers/video/offb.c
index 452433d..d7b3dcc 100644
--- a/drivers/video/offb.c
+++ b/drivers/video/offb.c
@@ -248,7 +248,7 @@ static void __iomem *offb_map_reg(struct device_node *np, int index,
 static void __init offb_init_fb(const char *name, const char *full_name,
 				int width, int height, int depth,
 				int pitch, unsigned long address,
-				struct device_node *dp)
+				int foreign_endian, struct device_node *dp)
 {
 	unsigned long res_size = pitch * height * (depth + 7) / 8;
 	struct offb_par *par = &default_par;
@@ -397,7 +397,7 @@ static void __init offb_init_fb(const char *name, const char *full_name,
 	info->screen_base = ioremap(address, fix->smem_len);
 	info->par = par;
 	info->pseudo_palette = (void *) (info + 1);
-	info->flags = FBINFO_DEFAULT;
+	info->flags = FBINFO_DEFAULT | foreign_endian;
 
 	fb_alloc_cmap(&info->cmap, 256, 0);
 
@@ -424,6 +424,15 @@ static void __init offb_init_nodriver(struct device_node *dp, int no_real_node)
 	u64 rstart, address = OF_BAD_ADDR;
 	const u32 *pp, *addrp, *up;
 	u64 asize;
+	int foreign_endian = 0;
+
+#ifdef __BIG_ENDIAN
+	if (of_get_property(dp, "little-endian", NULL))
+		foreign_endian = FBINFO_FOREIGN_ENDIAN;
+#else
+	if (of_get_property(dp, "big-endian", NULL))
+		foreign_endian = FBINFO_FOREIGN_ENDIAN;
+#endif
 
 	pp = of_get_property(dp, "linux,bootx-depth", &len);
 	if (pp == NULL)
@@ -509,7 +518,7 @@ static void __init offb_init_nodriver(struct device_node *dp, int no_real_node)
 		offb_init_fb(no_real_node ? "bootx" : dp->name,
 			     no_real_node ? "display" : dp->full_name,
 			     width, height, depth, pitch, address,
-			     no_real_node ? NULL : dp);
+			     foreign_endian, no_real_node ? NULL : dp);
 	}
 }
 
-- 
1.5.2.2
