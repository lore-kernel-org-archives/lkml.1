Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZHNTqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZHNTqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 15:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZHNTqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 15:46:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:48260 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756072AbZHNTqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 15:46:16 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/GymI1hxjG1rFITrrFgrTmIwJYNNbcsXSeTETplu
	ItHo8ainXP1CoE
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH] viafb: fix ioremap_nocache error handling
Date: Fri, 14 Aug 2009 19:47:56 +0000
Message-Id: <1250279276-3936-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: fix ioremap_nocache error handling

Correct the returned error code for remapping the video framebuffer.
Introduce error handling for remapping MMIO register address space to
avoid a NULL pointer dereference. Disable hardware acceleration if
remapping MMIO register address space failed as those registers are only
used for hardware acceleration.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 viafbdev.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 743eed4..72759b6 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -2134,12 +2134,16 @@ static int __devinit via_pci_probe(void)
 
 	if (!viaparinfo->fbmem_virt) {
 		printk(KERN_INFO "ioremap failed\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	viafb_get_mmio_info(&viaparinfo->mmio_base, &viaparinfo->mmio_len);
 	viaparinfo->io_virt = ioremap_nocache(viaparinfo->mmio_base,
 		viaparinfo->mmio_len);
+	if (!viaparinfo->io_virt) {
+		printk(KERN_WARNING "ioremap failed: hardware acceleration disabled\n");
+		viafb_accel = 0;
+	}
 
 	viafbinfo->node = 0;
 	viafbinfo->fbops = &viafb_ops;
-- 
1.6.3.2

