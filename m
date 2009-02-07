Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZBGRT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZBGRT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbZBGRTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:19:10 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43439 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZBGRTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:19:09 -0500
Date: Sat, 7 Feb 2009 12:19:05 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 15/15] asiliantfb: fix cmap memory leaks
Message-ID: <20090207121905.6d2d9575@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - fix cmap leak in removal path
 - fix cmap leak when register_framebuffer fails
 - check return value of fb_alloc_cmap
 - don't continue with driver setup if register_framebuffer fails

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/asiliantfb.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/video/asiliantfb.c b/drivers/video/asiliantfb.c
index 1fd22f4..cb89100 100644
--- a/drivers/video/asiliantfb.c
+++ b/drivers/video/asiliantfb.c
@@ -505,19 +505,26 @@ static struct fb_var_screeninfo asiliantfb_var __devinitdata = {
 	.vsync_len 	= 2,
 };
 
-static void __devinit init_asiliant(struct fb_info *p, unsigned long addr)
+static int __devinit init_asiliant(struct fb_info *p, unsigned long addr)
 {
 	p->fix			= asiliantfb_fix;
 	p->fix.smem_start	= addr;
 	p->var			= asiliantfb_var;
 	p->fbops		= &asiliantfb_ops;
 	p->flags		= FBINFO_DEFAULT;
+	int err;
 
-	fb_alloc_cmap(&p->cmap, 256, 0);
+	err = fb_alloc_cmap(&p->cmap, 256, 0);
+	if (err) {
+		printk(KERN_ERR "C&T 69000 fb failed to alloc cmap memory\n");
+		return err;
+	}
 
-	if (register_framebuffer(p) < 0) {
+	err = register_framebuffer(p);
+	if (err < 0) {
 		printk(KERN_ERR "C&T 69000 framebuffer failed to register\n");
-		return;
+		fb_dealloc_cmap(&p->cmap);
+		return err;
 	}
 
 	printk(KERN_INFO "fb%d: Asiliant 69000 frame buffer (%dK RAM detected)\n",
@@ -532,6 +539,7 @@ asiliantfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
 {
 	unsigned long addr, size;
 	struct fb_info *p;
+	int err;
 
 	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0)
 		return -ENODEV;
@@ -560,7 +568,12 @@ asiliantfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
 	pci_write_config_dword(dp, 4, 0x02800083);
 	writeb(3, p->screen_base + 0x400784);
 
-	init_asiliant(p, addr);
+	err = init_asiliant(p, addr);
+	if (err) {
+		release_mem_region(addr, size);
+		framebuffer_release(p);
+		return err;
+	}
 
 	pci_set_drvdata(dp, p);
 	return 0;
@@ -571,6 +584,7 @@ static void __devexit asiliantfb_remove(struct pci_dev *dp)
 	struct fb_info *p = pci_get_drvdata(dp);
 
 	unregister_framebuffer(p);
+	fb_dealloc_cmap(&p->cmap);
 	iounmap(p->screen_base);
 	release_mem_region(pci_resource_start(dp, 0), pci_resource_len(dp, 0));
 	pci_set_drvdata(dp, NULL);
-- 
1.5.6.5

