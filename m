Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbZFDGBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbZFDGBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756390AbZFDF7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:59:07 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:7383 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbZFDF7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:59:05 -0400
Subject: [PATCH v2 10/11] ACPI: video: convert to acpi_get_pci_dev
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, linux-pci@vger.kernel.org
Date: Wed, 03 Jun 2009 23:59:07 -0600
Message-ID: <20090604055907.18802.64431.stgit@bob.kio>
In-Reply-To: <20090604054504.18802.21690.stgit@bob.kio>
References: <20090604054504.18802.21690.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that acpi_get_pci_dev is available, let's use it instead of
acpi_get_physical_pci_device()

Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/video.c        |    6 +++---
 drivers/acpi/video_detect.c |    9 +++++----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 1bdfb37..5adbf93 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1054,15 +1054,15 @@ static void acpi_video_bus_find_cap(struct acpi_video_bus *video)
 static int acpi_video_bus_check(struct acpi_video_bus *video)
 {
 	acpi_status status = -ENOENT;
-	struct device *dev;
+	struct pci_dev *dev;
 
 	if (!video)
 		return -EINVAL;
 
-	dev = acpi_get_physical_pci_device(video->device->handle);
+	dev = acpi_get_pci_dev(video->device->handle);
 	if (!dev)
 		return -ENODEV;
-	put_device(dev);
+	pci_dev_put(dev);
 
 	/* Since there is no HID, CID and so on for VGA driver, we have
 	 * to check well known required nodes.
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 0973727..7cd2b63 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -10,7 +10,7 @@
  * assinged
  *
  * After PCI devices are glued with ACPI devices
- * acpi_get_physical_pci_device() can be called to identify ACPI graphics
+ * acpi_get_pci_dev() can be called to identify ACPI graphics
  * devices for which a real graphics card is plugged in
  *
  * Now acpi_video_get_capabilities() can be called to check which
@@ -36,6 +36,7 @@
 
 #include <linux/acpi.h>
 #include <linux/dmi.h>
+#include <linux/pci.h>
 
 ACPI_MODULE_NAME("video");
 #define _COMPONENT		ACPI_VIDEO_COMPONENT
@@ -109,7 +110,7 @@ static acpi_status
 find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	long *cap = context;
-	struct device *dev;
+	struct pci_dev *dev;
 	struct acpi_device *acpi_dev;
 
 	const struct acpi_device_id video_ids[] = {
@@ -120,10 +121,10 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
 		return AE_OK;
 
 	if (!acpi_match_device_ids(acpi_dev, video_ids)) {
-		dev = acpi_get_physical_pci_device(handle);
+		dev = acpi_get_pci_dev(handle);
 		if (!dev)
 			return AE_OK;
-		put_device(dev);
+		pci_dev_put(dev);
 		*cap |= acpi_is_video_device(acpi_dev);
 	}
 	return AE_OK;

