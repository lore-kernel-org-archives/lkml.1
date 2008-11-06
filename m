Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYKFFom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYKFFom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 00:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYKFFoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 00:44:34 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:60638 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKFFod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 00:44:33 -0500
X-Greylist: delayed 2019 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2008 00:44:33 EST
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>
Subject: [PATCH] i915: Filter pci devices based on PCI_CLASS_DISPLAY_VGA
Date: Wed,  5 Nov 2008 21:11:04 -0800
Message-Id: <1225948264-15216-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes hangs on 855-class hardware by avoiding double attachment of the
driver due to the stub second head device having the same pci id as the real
device.

Other DRM drivers probably want this treatment as well, but I'm applying it
just to this one for safety.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/gpu/drm/drm_drv.c |   10 +++++++-
 include/drm/drm_pciids.h  |   52 +++++++++++++++++++++++++-------------------
 2 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 96f416a..3ab1e9c 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -266,11 +266,19 @@ int drm_init(struct drm_driver *driver)
 	for (i = 0; driver->pci_driver.id_table[i].vendor != 0; i++) {
 		pid = (struct pci_device_id *)&driver->pci_driver.id_table[i];
 
+		/* Loop around setting up a DRM device for each PCI device
+		 * matching our ID and device class.  If we had the internal
+		 * function that pci_get_subsys and pci_get_class used, we'd
+		 * be able to just pass pid in instead of doing a two-stage
+		 * thing.
+		 */
 		pdev = NULL;
-		/* pass back in pdev to account for multiple identical cards */
 		while ((pdev =
 			pci_get_subsys(pid->vendor, pid->device, pid->subvendor,
 				       pid->subdevice, pdev)) != NULL) {
+			if ((pdev->class & pid->class_mask) != pid->class)
+				continue;
+
 			/* stealth mode requires a manual probe */
 			pci_dev_get(pdev);
 			drm_get_dev(pdev, pid, driver);
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index da04109..d209578 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -394,28 +394,34 @@
 #define ffb_PCI_IDS \
 	{0, 0, 0}
 
+#define i915_PCI_DEVID(vendor, device) {				\
+	vendor, device,							\
+	PCI_ANY_ID, PCI_ANY_ID,						\
+	PCI_CLASS_DISPLAY_VGA << 8, 0xffff00,				\
+	0								\
+}
 #define i915_PCI_IDS \
-	{0x8086, 0x3577, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2562, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x3582, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2572, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2582, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x258a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2592, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2772, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x27a2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x27ae, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2972, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2982, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2992, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x29a2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x29b2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x29c2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x29d2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2a02, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2a12, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2a42, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2e02, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2e12, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2e22, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
+	i915_PCI_DEVID(0x8086, 0x3577), \
+	i915_PCI_DEVID(0x8086, 0x2562), \
+	i915_PCI_DEVID(0x8086, 0x3582), \
+	i915_PCI_DEVID(0x8086, 0x2572), \
+	i915_PCI_DEVID(0x8086, 0x2582), \
+	i915_PCI_DEVID(0x8086, 0x258a), \
+	i915_PCI_DEVID(0x8086, 0x2592), \
+	i915_PCI_DEVID(0x8086, 0x2772), \
+	i915_PCI_DEVID(0x8086, 0x27a2), \
+	i915_PCI_DEVID(0x8086, 0x27ae), \
+	i915_PCI_DEVID(0x8086, 0x2972), \
+	i915_PCI_DEVID(0x8086, 0x2982), \
+	i915_PCI_DEVID(0x8086, 0x2992), \
+	i915_PCI_DEVID(0x8086, 0x29a2), \
+	i915_PCI_DEVID(0x8086, 0x29b2), \
+	i915_PCI_DEVID(0x8086, 0x29c2), \
+	i915_PCI_DEVID(0x8086, 0x29d2), \
+	i915_PCI_DEVID(0x8086, 0x2a02), \
+	i915_PCI_DEVID(0x8086, 0x2a12), \
+	i915_PCI_DEVID(0x8086, 0x2a42), \
+	i915_PCI_DEVID(0x8086, 0x2e02), \
+	i915_PCI_DEVID(0x8086, 0x2e12), \
+	i915_PCI_DEVID(0x8086, 0x2e22), \
 	{0, 0, 0}
-- 
1.5.6.5

