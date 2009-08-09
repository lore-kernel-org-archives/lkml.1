Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbZHIHo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbZHIHo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 03:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZHIHo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 03:44:27 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54894 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZHIHo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 03:44:26 -0400
Date: Sun, 9 Aug 2009 09:44:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] drivers/video: Correct use of request_region/request_mem_region
Message-ID: <Pine.LNX.4.64.0908090943560.13271@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

request_region should be used with release_region, not request_mem_region.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r1@
expression start;
@@

request_region(start,...)

@b1@
expression r1.start;
@@

request_mem_region(start,...)

@depends on !b1@
expression r1.start;
expression E;
@@

- release_mem_region
+ release_region
  (start,E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/gbefb.c  |    4 ++--
 drivers/video/tdfxfb.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -u -p a/drivers/video/gbefb.c b/drivers/video/gbefb.c
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -1246,7 +1246,7 @@ out_tiles_free:
 out_unmap:
 	iounmap(gbe);
 out_release_mem_region:
-	release_mem_region(GBE_BASE, sizeof(struct sgi_gbe));
+	release_region(GBE_BASE, sizeof(struct sgi_gbe));
 out_release_framebuffer:
 	framebuffer_release(info);
 
@@ -1265,7 +1265,7 @@ static int __devexit gbefb_remove(struct
 		iounmap(gbe_mem);
 	dma_free_coherent(NULL, GBE_TLB_SIZE * sizeof(uint16_t),
 			  (void *)gbe_tiles.cpu, gbe_tiles.dma);
-	release_mem_region(GBE_BASE, sizeof(struct sgi_gbe));
+	release_region(GBE_BASE, sizeof(struct sgi_gbe));
 	iounmap(gbe);
 	gbefb_remove_sysfs(&p_dev->dev);
 	framebuffer_release(info);
diff -u -p a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c
+++ b/drivers/video/tdfxfb.c
@@ -1571,8 +1571,8 @@ out_err_iobase:
 	if (default_par->mtrr_handle >= 0)
 		mtrr_del(default_par->mtrr_handle, info->fix.smem_start,
 			 info->fix.smem_len);
-	release_mem_region(pci_resource_start(pdev, 2),
-			   pci_resource_len(pdev, 2));
+	release_region(pci_resource_start(pdev, 2),
+		       pci_resource_len(pdev, 2));
 out_err_screenbase:
 	if (info->screen_base)
 		iounmap(info->screen_base);
