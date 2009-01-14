Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbZANWs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbZANWs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbZANWsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:48:20 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:58681 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644AbZANWsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:48:18 -0500
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>
Subject: [PATCH] drm/i915: why does kconfig hate?
Date: Wed, 14 Jan 2009 14:48:12 -0800
Message-Id: <1231973292-8344-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the obvious fix attempt for people updating their .configs and not
getting the i915 driver any more, or people not selecting FB and not finding
it as an option.  We want to just enable the code needed to build the driver,
not force the user to go find the option to enable it, because they really
don't care.

However, with this patch, the build results in:
drivers/gpu/drm/Kconfig:8:error: found recursive dependency: DRM -> <choice> -> DRM_I915 -> FB -> FB_I810 -> AGP -> DRM
and I need some help interpreting this.  In particular, how do these two
dependencies get produced:
FB -> FB_I810
AGP -> DRM
as they seem to be backwards (DRM results in AGP being required, FB_I810
results in FB being required).  If I remove this wonky bit from DRM:

 menuconfig DRM
        tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI support
-       depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
+       depends on PCI && !EMULATED_CMPXCHG && MMU

then it still produces:
drivers/video/Kconfig:23:error: found recursive dependency: FB -> FB_I810 -> AGP -> <choice> -> DRM_I915 -> FB
---
 drivers/gpu/drm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 5130b72..4be3acb 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -70,7 +70,7 @@ config DRM_I915
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	depends on FB
+	select FB
 	tristate "i915 driver"
 	help
 	  Choose this option if you have a system that has Intel 830M, 845G,
-- 
1.5.6.5

