Return-Path: <linux-kernel-owner+w=401wt.eu-S936313AbZLQEKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936313AbZLQEKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936296AbZLQEJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:09:46 -0500
Received: from kroah.org ([198.145.64.141]:56058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936200AbZLQEFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:51 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:01 2009
Message-Id: <20091217035701.039621306@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shaohua Li <shaohua.li@intel.com>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [139/151] drm/i915: PineView only has LVDS and CRT ports
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 103a196f4224dc6872081305cf7f82ebf67aa7bd upstream.

PineView only has 2 ports for LVDS and CRT. Don't enable other
ports for it.

Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.h      |    4 ++++
 drivers/gpu/drm/i915/intel_display.c |    6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -957,6 +957,7 @@ extern int i915_wait_ring(struct drm_dev
 #define IS_I85X(dev) ((dev)->pci_device == 0x3582)
 #define IS_I855(dev) ((dev)->pci_device == 0x3582)
 #define IS_I865G(dev) ((dev)->pci_device == 0x2572)
+#define IS_I8XX(dev) (IS_I830(dev) || IS_845G(dev) || IS_I85X(dev) || IS_I865G(dev))
 
 #define IS_I915G(dev) ((dev)->pci_device == 0x2582 || (dev)->pci_device == 0x258a)
 #define IS_I915GM(dev) ((dev)->pci_device == 0x2592)
@@ -1018,9 +1019,12 @@ extern int i915_wait_ring(struct drm_dev
  */
 #define HAS_128_BYTE_Y_TILING(dev) (IS_I9XX(dev) && !(IS_I915G(dev) || \
 						      IS_I915GM(dev)))
+#define SUPPORTS_DIGITAL_OUTPUTS(dev)	(IS_I9XX(dev) && !IS_IGD(dev))
 #define SUPPORTS_INTEGRATED_HDMI(dev)	(IS_G4X(dev) || IS_IGDNG(dev))
 #define SUPPORTS_INTEGRATED_DP(dev)	(IS_G4X(dev) || IS_IGDNG(dev))
 #define SUPPORTS_EDP(dev)		(IS_IGDNG_M(dev))
+#define SUPPORTS_TV(dev)		(IS_I9XX(dev) && IS_MOBILE(dev) && \
+					!IS_IGDNG(dev) && !IS_IGD(dev))
 #define I915_HAS_HOTPLUG(dev) (IS_I945G(dev) || IS_I945GM(dev) || IS_G33(dev) || IS_I965G(dev))
 /* dsparb controlled by hw only */
 #define DSPARB_HWCONTROL(dev) (IS_G4X(dev) || IS_IGDNG(dev))
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4119,7 +4119,7 @@ static void intel_setup_outputs(struct d
 		if (I915_READ(PCH_DP_D) & DP_DETECTED)
 			intel_dp_init(dev, PCH_DP_D);
 
-	} else if (IS_I9XX(dev)) {
+	} else if (SUPPORTS_DIGITAL_OUTPUTS(dev)) {
 		bool found = false;
 
 		if (I915_READ(SDVOB) & SDVO_DETECTED) {
@@ -4146,10 +4146,10 @@ static void intel_setup_outputs(struct d
 
 		if (SUPPORTS_INTEGRATED_DP(dev) && (I915_READ(DP_D) & DP_DETECTED))
 			intel_dp_init(dev, DP_D);
-	} else
+	} else if (IS_I8XX(dev))
 		intel_dvo_init(dev);
 
-	if (IS_I9XX(dev) && IS_MOBILE(dev) && !IS_IGDNG(dev))
+	if (SUPPORTS_TV(dev))
 		intel_tv_init(dev);
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {


