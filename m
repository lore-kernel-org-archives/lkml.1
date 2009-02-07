Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZBGRXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZBGRXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZBGRWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:22:33 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43445 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbZBGRWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:22:31 -0500
Date: Sat, 7 Feb 2009 12:14:57 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 7/15] sstfb: check fb_alloc_cmap return value and handle
 failure properly
Message-ID: <20090207121457.28550bdd@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/sstfb.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
index 5b11a00..609d0a5 100644
--- a/drivers/video/sstfb.c
+++ b/drivers/video/sstfb.c
@@ -1421,13 +1421,16 @@ static int __devinit sstfb_probe(struct pci_dev *pdev,
 		goto fail;
 	}
 	
-	fb_alloc_cmap(&info->cmap, 256, 0);
+	if (fb_alloc_cmap(&info->cmap, 256, 0)) {
+		printk(KERN_ERR "sstfb: can't alloc cmap memory.\n");
+		goto fail;
+	}
 
 	/* register fb */
 	info->device = &pdev->dev;
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "sstfb: can't register framebuffer.\n");
-		goto fail;
+		goto fail_register;
 	}
 
 	sstfb_clear_screen(info);
@@ -1441,8 +1444,9 @@ static int __devinit sstfb_probe(struct pci_dev *pdev,
 
 	return 0;
 
-fail:
+fail_register:
 	fb_dealloc_cmap(&info->cmap);
+fail:
 	iounmap(info->screen_base);
 fail_fb_remap:
 	iounmap(par->mmio_vbase);
-- 
1.5.6.5

