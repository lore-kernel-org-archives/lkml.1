Return-Path: <linux-kernel-owner+w=401wt.eu-S964878AbXGSAGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878AbXGSAGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763467AbXGSAGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:06:08 -0400
Received: from havoc.gtf.org ([69.61.125.42]:56627 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760876AbXGSAGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:06:07 -0400
Date: Wed, 18 Jul 2007 19:55:04 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Subject: [git patches] two warning fixes
Message-ID: <20070718235504.GA9601@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'warnings' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git warnings

to receive the following updates:

 drivers/video/aty/radeon_base.c |   23 ++++++++++++++++++-----
 include/asm-x86_64/tlbflush.h   |    6 +++++-
 2 files changed, 23 insertions(+), 6 deletions(-)

Jeff Garzik (2):
      drivers/video/aty/radeon_base: fix radeonfb_pci_register() err handling
      [X86-64] make flush_tlb_kernel_range() a static inline function

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
diff --git a/include/asm-x86_64/tlbflush.h b/include/asm-x86_64/tlbflush.h
index 8516225..a82464c 100644
--- a/include/asm-x86_64/tlbflush.h
+++ b/include/asm-x86_64/tlbflush.h
@@ -92,7 +92,11 @@ static inline void flush_tlb_range(struct vm_area_struct * vma, unsigned long st
 
 #endif
 
-#define flush_tlb_kernel_range(start, end) flush_tlb_all()
+static inline void flush_tlb_kernel_range(unsigned long start,
+					  unsigned long end)
+{
+	flush_tlb_all();
+}
 
 static inline void flush_tlb_pgtables(struct mm_struct *mm,
 				      unsigned long start, unsigned long end)
