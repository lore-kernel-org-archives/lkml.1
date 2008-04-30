Return-Path: <linux-kernel-owner+w=401wt.eu-S1765301AbYD3WEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765301AbYD3WEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764728AbYD3WD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:03:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11309 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765972AbYD3WD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EdEOZCP2P9XSwLhHxvTn6Wa7xTnk0WpZ11sBmD/xwLNQV/p9NoAOVs8MzkFFrWXzIosUe8r5KKpR2CVdY6IzD9aPlCmzW08UxmVqSF6UIqaRztjtikZZEeChsF/DnCvnVA174tPls/SjpZrRHx2dCCaOLSf+lGaO3Mj7t86jVjg=
Subject: [PATCH 04/10] video: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 15:03:41 -0700
Message-Id: <1209593021.24729.114.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/aty/atyfb_base.c:3359:26: warning: Using plain integer as NULL pointer
drivers/video/aty/radeon_base.c:2280:32: warning: Using plain integer as NULL pointer
drivers/video/matrox/matroxfb_base.h:203:25: warning: Using plain integer as NULL pointer
drivers/video/matrox/matroxfb_base.h:203:25: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/video/aty/atyfb_base.c       |    2 +-
 drivers/video/aty/radeon_base.c      |    2 +-
 drivers/video/matrox/matroxfb_base.h |    2 +-
 drivers/video/sis/sis_main.c         |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index e4bcf53..d051d3e 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -3356,7 +3356,7 @@ static int __devinit atyfb_setup_generic(struct pci_dev *pdev, struct fb_info *i
 
 	info->fix.mmio_start = raddr;
 	par->ati_regbase = ioremap(info->fix.mmio_start, 0x1000);
-	if (par->ati_regbase == 0)
+	if (!par->ati_regbase)
 		return -ENOMEM;
 
 	info->fix.mmio_start += par->aux_start ? 0x400 : 0xc00;
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 72cd0d2..cca6c84 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2277,7 +2277,7 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	do {
 		rinfo->fb_base = ioremap (rinfo->fb_base_phys,
 					  rinfo->mapped_vram);
-	} while (   rinfo->fb_base == 0 &&
+	} while (!rinfo->fb_base &&
 		  ((rinfo->mapped_vram /=2) >= MIN_MAPPED_VRAM) );
 
 	if (rinfo->fb_base == NULL) {
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
1.5.5.1.305.g7c84


