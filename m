Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbXGRFze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbXGRFze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbXGRFz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:55:26 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42285 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbXGRFzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:55:25 -0400
Date: Wed, 18 Jul 2007 01:55:24 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 2/3] drivers/video/aty/radeon_base: fix
	radeonfb_pci_register() err handling
Message-ID: <20070718055524.GA5748@havoc.gtf.org>
References: <20070718055348.GA5734@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718055348.GA5734@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following change was checked into 'warnings' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

commit 61470a24062de01853fb922ec4a81dcd1c0ba1d0
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Jul 18 01:43:05 2007 -0400

    drivers/video/aty/radeon_base: fix radeonfb_pci_register() err handling
    
    * silence warnings by handling failure of sysfs_create_bin_file()
    
    * fix leak-on-error if register_framebuffer() fails, and sysfs is active
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/video/aty/radeon_base.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

61470a24062de01853fb922ec4a81dcd1c0ba1d0
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 47ca62f..5a5458b 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2326,10 +2326,16 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	radeon_check_modes(rinfo, mode_option);
 
 	/* Register some sysfs stuff (should be done better) */
-	if (rinfo->mon1_EDID)
-		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr);
-	if (rinfo->mon2_EDID)
-		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr);
+	if (rinfo->mon1_EDID) {
+		ret = sysfs_create_bin_file(&rinfo->pdev->dev.kobj,&edid1_attr);
+		if (ret)
+			goto err_unmap_fb;
+	}
+	if (rinfo->mon2_EDID) {
+		ret = sysfs_create_bin_file(&rinfo->pdev->dev.kobj,&edid2_attr);
+		if (ret)
+			goto err_free_mon1;
+	}
 
 	/* save current mode regs before we switch into the new one
 	 * so we can restore this upon __exit
@@ -2353,7 +2359,7 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	if (ret < 0) {
 		printk (KERN_ERR "radeonfb (%s): could not register framebuffer\n",
 			pci_name(rinfo->pdev));
-		goto err_unmap_fb;
+		goto err_free_mon2;
 	}
 
 #ifdef CONFIG_MTRR
@@ -2372,6 +2378,13 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	RTRACE("radeonfb_pci_register END\n");
 
 	return 0;
+
+err_free_mon2:
+	if (rinfo->mon2_EDID)
+		sysfs_remove_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr);
+err_free_mon1:
+	if (rinfo->mon1_EDID)
+		sysfs_remove_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr);
 err_unmap_fb:
 	iounmap(rinfo->fb_base);
 err_unmap_rom:
