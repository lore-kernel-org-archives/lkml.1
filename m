Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbZGJLUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbZGJLUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 07:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZGJLUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 07:20:36 -0400
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:36259 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbZGJLUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 07:20:35 -0400
X-Greylist: delayed 3316 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jul 2009 07:20:35 EDT
From: Simon Farnsworth <simon.farnsworth@onelan.com>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Simon Farnsworth <simon.farnsworth@onelan.com>
Subject: [PATCH] DRM: Fix VBlank IRQ on VIA hardware.
Date: Fri, 10 Jul 2009 11:25:16 +0100
Message-Id: <1247221516-28054-1-git-send-email-simon.farnsworth@onelan.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

via_enable_vblank wasn't setting the VBlank enable bit - instead, it
was masking out the rest of the register.

At the same time, fix via_disable_vblank to clear the VBlank enable
bit.
---
 drivers/gpu/drm/via/via_irq.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/via/via_irq.c b/drivers/gpu/drm/via/via_irq.c
index c248c1d..5935b88 100644
--- a/drivers/gpu/drm/via/via_irq.c
+++ b/drivers/gpu/drm/via/via_irq.c
@@ -183,7 +183,7 @@ int via_enable_vblank(struct drm_device *dev, int crtc)
 	}
 
 	status = VIA_READ(VIA_REG_INTERRUPT);
-	VIA_WRITE(VIA_REG_INTERRUPT, status & VIA_IRQ_VBLANK_ENABLE);
+	VIA_WRITE(VIA_REG_INTERRUPT, status | VIA_IRQ_VBLANK_ENABLE);
 
 	VIA_WRITE8(0x83d4, 0x11);
 	VIA_WRITE8(0x83d5, VIA_READ8(0x83d5) | 0x30);
@@ -194,6 +194,10 @@ int via_enable_vblank(struct drm_device *dev, int crtc)
 void via_disable_vblank(struct drm_device *dev, int crtc)
 {
 	drm_via_private_t *dev_priv = dev->dev_private;
+	u32 status;
+
+	status = VIA_READ(VIA_REG_INTERRUPT);
+	VIA_WRITE(VIA_REG_INTERRUPT, status & ~VIA_IRQ_VBLANK_ENABLE);
 
 	VIA_WRITE8(0x83d4, 0x11);
 	VIA_WRITE8(0x83d5, VIA_READ8(0x83d5) & ~0x30);
-- 
1.5.4.1

