Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZBGRW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZBGRW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZBGRWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:22:32 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43441 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbZBGRWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:22:30 -0500
Date: Sat, 7 Feb 2009 12:15:40 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.comj
Subject: [PATCH 10/15] sunxvr500: fix cmap memory leaks
Message-ID: <20090207121540.0e618d0f@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - fix cmap leak in removal path
 - fix cmap leak when register_framebuffer fails

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/sunxvr500.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/video/sunxvr500.c b/drivers/video/sunxvr500.c
index c2ba51b..18b9507 100644
--- a/drivers/video/sunxvr500.c
+++ b/drivers/video/sunxvr500.c
@@ -349,11 +349,14 @@ static int __devinit e3d_pci_register(struct pci_dev *pdev,
 	if (err < 0) {
 		printk(KERN_ERR "e3d: Could not register framebuffer %s\n",
 		       pci_name(pdev));
-		goto err_unmap_fb;
+		goto err_free_cmap;
 	}
 
 	return 0;
 
+err_free_cmap:
+	fb_dealloc_cmap(&info->cmap);
+
 err_unmap_fb:
 	iounmap(ep->fb_base);
 
@@ -389,6 +392,7 @@ static void __devexit e3d_pci_unregister(struct pci_dev *pdev)
 	pci_release_region(pdev, 0);
 	pci_release_region(pdev, 1);
 
+	fb_dealloc_cmap(&info->cmap);
         framebuffer_release(info);
 
 	pci_disable_device(pdev);
-- 
1.5.6.5

