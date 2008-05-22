Return-Path: <linux-kernel-owner+w=401wt.eu-S933660AbYEVWqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660AbYEVWqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbYEVWpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:45:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:61628 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbYEVWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pkiufNXMxnwrCHVwfX3pTVf2AD+hybqqYBvyYGHRgLjrFiU9QY0koB7pOGJLhp3jkVQRiQ3IhcHCdBNrGat2tbGOobl4KWoejY4BwXOtaoYDRdw2nKrNxIGPK8ZhN/SdiyN9IwaSwOrD3K6RHBrfw7wSq+tw4rgKAELqxyRj4zE=
Subject: [PATCH 5/5] fbdev: fix integer as NULL pointer warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 May 2008 15:45:08 -0700
Message-Id: <1211496308.6888.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/aty/atyfb_base.c:3359:26: warning: Using plain integer as NULL pointer
drivers/video/aty/radeon_base.c:2280:32: warning: Using plain integer as NULL pointer
drivers/video/matrox/matroxfb_base.h:203:25: warning: Using plain integer as NULL pointer
drivers/video/matrox/matroxfb_base.h:203:25: warning: Using plain integer as NULL pointer
drivers/video/sis/sis_main.c:5790:44: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/video/aty/atyfb_base.c       |    2 +-
 drivers/video/aty/radeon_base.c      |    4 ++--
 drivers/video/matrox/matroxfb_base.h |    2 +-
 drivers/video/sis/sis_main.c         |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index e4bcf53..bd4ac0b 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -3356,7 +3356,7 @@ static int __devinit atyfb_setup_generic(struct pci_dev *pdev, struct fb_info *i
 
 	info->fix.mmio_start = raddr;
 	par->ati_regbase = ioremap(info->fix.mmio_start, 0x1000);
-	if (par->ati_regbase == 0)
+	if (par->ati_regbase == NULL)
 		return -ENOMEM;
 
 	info->fix.mmio_start += par->aux_start ? 0x400 : 0xc00;
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 72cd0d2..400e926 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2277,8 +2277,8 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	do {
 		rinfo->fb_base = ioremap (rinfo->fb_base_phys,
 					  rinfo->mapped_vram);
-	} while (   rinfo->fb_base == 0 &&
-		  ((rinfo->mapped_vram /=2) >= MIN_MAPPED_VRAM) );
+	} while (rinfo->fb_base == NULL &&
+		 ((rinfo->mapped_vram /= 2) >= MIN_MAPPED_VRAM));
 
 	if (rinfo->fb_base == NULL) {
 		printk (KERN_ERR "radeonfb (%s): cannot map FB\n",
diff --git a/drivers/video/matrox/matroxfb_base.h b/drivers/video/matrox/matroxfb_base.h
index f3107ad..9588323 100644
--- a/drivers/video/matrox/matroxfb_base.h
+++ b/drivers/video/matrox/matroxfb_base.h
@@ -200,7 +200,7 @@ static inline int mga_ioremap(unsigned long phys, unsigned long size, int flags,
 		virt->vaddr = ioremap_nocache(phys, size);
 	else
 		virt->vaddr = ioremap(phys, size);
-	return (virt->vaddr == 0); /* 0, !0... 0, error_code in future */
+	return (virt->vaddr == NULL); /* 0, !0... 0, error_code in future */
 }
 
 static inline void mga_iounmap(vaddr_t va) {
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 7380362..b934384 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -5787,7 +5787,7 @@ sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} else {
 		struct sis_video_info *countvideo = card_list;
 		ivideo->cardnumber = 1;
-		while((countvideo = countvideo->next) != 0)
+		while((countvideo = countvideo->next) != NULL)
 			ivideo->cardnumber++;
 	}
 
-- 
1.5.5.1.579.g4e43

