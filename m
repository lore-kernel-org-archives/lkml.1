Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZCQVBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZCQVBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZCQVBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:01:43 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56083 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZCQVBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:01:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Bt+Zxbz2q+l0SV07ICYeh94j3TvP5EPe6wLOoep1JrRLKAv2fTn+l475IYbIALnY8B
         IQ4/yJ5i+p9Pzkuz5UFQ3gWSEbFQKix7OHEUyvrHmxZr6JISJtrswz1wxNnp/fpyANl+
         043cMurNc72lSIchXtezwaWMefVniiyRlm3bo=
From: Alessio Igor Bogani <abogani@texware.it>
To: Antonino Daplas <adaplas@gmail.com>
Cc: Linux FBDev <linux-fbdev-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] nvidiafb: remove open_lock mutex
Date: Tue, 17 Mar 2009 21:55:25 +0100
Message-Id: <1237323325-6104-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove mutex from the nvidiafb_open/nvidiafb_release functions as these
operations are mutexed at fb layer.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/video/nvidia/nv_type.h |    2 --
 drivers/video/nvidia/nvidia.c  |    7 -------
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/video/nvidia/nv_type.h b/drivers/video/nvidia/nv_type.h
index f132aab..c03f7f5 100644
--- a/drivers/video/nvidia/nv_type.h
+++ b/drivers/video/nvidia/nv_type.h
@@ -5,7 +5,6 @@
 #include <linux/types.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
-#include <linux/mutex.h>
 #include <video/vga.h>
 
 #define NV_ARCH_04  0x04
@@ -99,7 +98,6 @@ struct nvidia_par {
 	RIVA_HW_STATE initial_state;
 	RIVA_HW_STATE *CurrentState;
 	struct vgastate vgastate;
-	struct mutex open_lock;
 	u32 pseudo_palette[16];
 	struct pci_dev *pci_dev;
 	u32 Architecture;
diff --git a/drivers/video/nvidia/nvidia.c b/drivers/video/nvidia/nvidia.c
index 9dbb5a5..efe10ff 100644
--- a/drivers/video/nvidia/nvidia.c
+++ b/drivers/video/nvidia/nvidia.c
@@ -1004,15 +1004,12 @@ static int nvidiafb_open(struct fb_info *info, int user)
 {
 	struct nvidia_par *par = info->par;
 
-	mutex_lock(&par->open_lock);
-
 	if (!par->open_count) {
 		save_vga_x86(par);
 		nvidia_save_vga(par, &par->initial_state);
 	}
 
 	par->open_count++;
-	mutex_unlock(&par->open_lock);
 	return 0;
 }
 
@@ -1021,8 +1018,6 @@ static int nvidiafb_release(struct fb_info *info, int user)
 	struct nvidia_par *par = info->par;
 	int err = 0;
 
-	mutex_lock(&par->open_lock);
-
 	if (!par->open_count) {
 		err = -EINVAL;
 		goto done;
@@ -1035,7 +1030,6 @@ static int nvidiafb_release(struct fb_info *info, int user)
 
 	par->open_count--;
 done:
-	mutex_unlock(&par->open_lock);
 	return err;
 }
 
@@ -1300,7 +1294,6 @@ static int __devinit nvidiafb_probe(struct pci_dev *pd,
 
 	par = info->par;
 	par->pci_dev = pd;
-	mutex_init(&par->open_lock);
 	info->pixmap.addr = kzalloc(8 * 1024, GFP_KERNEL);
 
 	if (info->pixmap.addr == NULL)
-- 
1.6.0.4

