Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZKER4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZKER4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757761AbZKERzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:55:42 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:45221 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbZKERzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:55:41 -0500
Message-Id: <20091105152702.365281887@linux-mips.org>
User-Agent: quilt/0.47-1
Date: Thu, 05 Nov 2009 16:26:01 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Julia Lawall <julia@diku.dk>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] VIDEO: Correct use of request_region/request_mem_region
References: <20091105152555.227009519@linux-mips.org>
Content-Disposition: inline; filename=0006.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Geert Uytterhoeven pointed out that in the case of drivers/video/gbefb.c,
the problem is actually the other way around; request_mem_region should be
used instead of request_region.

The semantic patch that finds/fixes this problem is as follows:
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
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 drivers/video/gbefb.c  |    2 +-
 drivers/video/tdfxfb.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: upstream-linus/drivers/video/gbefb.c
===================================================================
--- upstream-linus.orig/drivers/video/gbefb.c
+++ upstream-linus/drivers/video/gbefb.c
@@ -1147,7 +1147,7 @@ static int __init gbefb_probe(struct pla
 	gbefb_setup(options);
 #endif
 
-	if (!request_region(GBE_BASE, sizeof(struct sgi_gbe), "GBE")) {
+	if (!request_mem_region(GBE_BASE, sizeof(struct sgi_gbe), "GBE")) {
 		printk(KERN_ERR "gbefb: couldn't reserve mmio region\n");
 		ret = -EBUSY;
 		goto out_release_framebuffer;
Index: upstream-linus/drivers/video/tdfxfb.c
===================================================================
--- upstream-linus.orig/drivers/video/tdfxfb.c
+++ upstream-linus/drivers/video/tdfxfb.c
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


