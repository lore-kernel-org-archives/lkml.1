Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYKIV4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYKIV4G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYKIVzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:55:55 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:59065 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbYKIVzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:55:54 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, David Airlie <airlied@linux.ie>
Subject: [PATCH 1/1] DRM: fix radeon suspend/resume oops
Date: Sun,  9 Nov 2008 22:55:26 +0100
Message-Id: <1226267726-32714-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <49048B88.1060807@gmail.com>
References: <49048B88.1060807@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've sent a bugreport twice with no reply, so coming with a patch.
Andrew please apply, if no comments or a better patch from drm
fellows comes.

As the accesses to the mmio member are not protected by anything, they
seem to be racy with the open/clsoe anyways, setting this down there
too.

--
When the driver is bound to a device and nobody opens the device node,
it will oops on suspend and resume, since it's not mapped and
dev_priv->mmio is NULL.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/radeon/radeon_drv.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 71af746..2e74a98 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -52,10 +52,14 @@ static int dri_library_name(struct drm_device *dev, char *buf)
 		        "r300"));
 }
 
+/* FIXME all this suspend/resume races with open/close? */
 static int radeon_suspend(struct drm_device *dev, pm_message_t state)
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 
+	if (!dev_priv->mmio)
+		return 0;
+
 	/* Disable *all* interrupts */
 	if ((dev_priv->flags & RADEON_FAMILY_MASK) >= CHIP_RS690)
 		RADEON_WRITE(R500_DxMODE_INT_MASK, 0);
@@ -67,6 +71,9 @@ static int radeon_resume(struct drm_device *dev)
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
 
+	if (!dev_priv->mmio)
+		return 0;
+
 	/* Restore interrupt registers */
 	if ((dev_priv->flags & RADEON_FAMILY_MASK) >= CHIP_RS690)
 		RADEON_WRITE(R500_DxMODE_INT_MASK, dev_priv->r500_disp_irq_reg);
-- 
1.6.0.3

