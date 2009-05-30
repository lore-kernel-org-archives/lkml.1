Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbZE3DQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbZE3DQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 23:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZE3DQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 23:16:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:53695 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZE3DQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 23:16:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,274,1241420400"; 
   d="scan'208";a="148602534"
From: "Henroid, Andrew D" <andrew.d.henroid@intel.com>
To: Len Brown <lenb@kernel.org>
CC: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Date: Fri, 29 May 2009 21:16:09 -0600
Subject: RE: [PATCH v2] i7300_idle: allow testing on i5000-series hardware
 w/o re-compile
Thread-Topic: [PATCH v2] i7300_idle: allow testing on i5000-series hardware
 w/o re-compile
Thread-Index: AcngBczE5TkYxbXGQUCEN+fP0wzPwwAzxrOw
Message-ID: <72D8A09E39A89147BE9CFBB6F0C73C3060666B92F8@rrsmsx501.amr.corp.intel.com>
References: <alpine.LFD.2.00.0905280024310.25587@localhost.localdomain>
 <alpine.LFD.2.00.0905282048490.9493@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905282048490.9493@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Andrew Henroid <andrew.d.henroid@intel.com>  

-----Original Message-----
From: Len Brown [mailto:lenb@kernel.org] 
Sent: Thursday, May 28, 2009 5:52 PM
To: Henroid, Andrew D
Cc: linux-pm@lists.linux-foundation.org; Linux Kernel Mailing List; Pallipadi, Venkatesh; Williams, Dan J; Sosnowski, Maciej
Subject: [PATCH v2] i7300_idle: allow testing on i5000-series hardware w/o re-compile

From: Len Brown <len.brown@intel.com>

Testing the i7300_idle driver on i5000-series hardware required
an edit to i7300_idle.h to "#define SUPPORT_I5000 1" and a re-build
of both i7300_idle and ioat_dma.

Replace that build-time scheme with a load-time module parameter:
"7300_idle.forceload=1" to make it easier to test the driver
on hardware that while not officially validated, works fine
and is much more commonly available.

By default (no modparam) the driver will continue to load
only on the i7300.

Note that ioat_dma runs a copy of i7300_idle's probe routine
to know to reserve an IOAT channel for i7300_idle.
This change makes ioat_dma do that always on the i5000,
just like it does on the i7300.

Signed-off-by: Len Brown <len.brown@intel.com>
---
v2: make sure ioat_dma_enumerate_channels() reserves a channel
    on i5000 as it does on i7300.

 drivers/dma/ioat_dma.c     |    2 +-
 drivers/idle/i7300_idle.c  |    6 +++++-
 include/linux/i7300_idle.h |   20 ++++++++++----------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 1955ee8..a600fc0 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -173,7 +173,7 @@ static int ioat_dma_enumerate_channels(struct ioatdma_device *device)
 	xfercap = (xfercap_scale == 0 ? -1 : (1UL << xfercap_scale));
 
 #ifdef  CONFIG_I7300_IDLE_IOAT_CHANNEL
-	if (i7300_idle_platform_probe(NULL, NULL) == 0) {
+	if (i7300_idle_platform_probe(NULL, NULL, 1) == 0) {
 		device->common.chancnt--;
 	}
 #endif
diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
index bf74039..949c97f 100644
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -41,6 +41,10 @@ static int debug;
 module_param_named(debug, debug, uint, 0644);
 MODULE_PARM_DESC(debug, "Enable debug printks in this driver");
 
+static int forceload;
+module_param_named(forceload, forceload, uint, 0644);
+MODULE_PARM_DESC(debug, "Enable driver testing on unvalidated i5000");
+
 #define dprintk(fmt, arg...) \
 	do { if (debug) printk(KERN_INFO I7300_PRINT fmt, ##arg); } while (0)
 
@@ -552,7 +556,7 @@ static int __init i7300_idle_init(void)
 	cpus_clear(idle_cpumask);
 	total_us = 0;
 
-	if (i7300_idle_platform_probe(&fbd_dev, &ioat_dev))
+	if (i7300_idle_platform_probe(&fbd_dev, &ioat_dev, forceload))
 		return -ENODEV;
 
 	if (i7300_idle_thrt_save())
diff --git a/include/linux/i7300_idle.h b/include/linux/i7300_idle.h
index 05a80c4..1587b7d 100644
--- a/include/linux/i7300_idle.h
+++ b/include/linux/i7300_idle.h
@@ -16,35 +16,33 @@
 struct fbd_ioat {
 	unsigned int vendor;
 	unsigned int ioat_dev;
+	unsigned int enabled;
 };
 
 /*
  * The i5000 chip-set has the same hooks as the i7300
- * but support is disabled by default because this driver
- * has not been validated on that platform.
+ * but it is not enabled by default and must be manually
+ * manually enabled with "forceload=1" because it is
+ * only lightly validated.
  */
-#define SUPPORT_I5000 0
 
 static const struct fbd_ioat fbd_ioat_list[] = {
-	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB},
-#if SUPPORT_I5000
-	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT},
-#endif
+	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB, 1},
+	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT, 0},
 	{0, 0}
 };
 
 /* table of devices that work with this driver */
 static const struct pci_device_id pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_FBD_CNB) },
-#if SUPPORT_I5000
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
-#endif
 	{ } /* Terminating entry */
 };
 
 /* Check for known platforms with I/O-AT */
 static inline int i7300_idle_platform_probe(struct pci_dev **fbd_dev,
-						struct pci_dev **ioat_dev)
+						struct pci_dev **ioat_dev,
+						int enable_all)
 {
 	int i;
 	struct pci_dev *memdev, *dmadev;
@@ -69,6 +67,8 @@ static inline int i7300_idle_platform_probe(struct pci_dev **fbd_dev,
 	for (i = 0; fbd_ioat_list[i].vendor != 0; i++) {
 		if (dmadev->vendor == fbd_ioat_list[i].vendor &&
 		    dmadev->device == fbd_ioat_list[i].ioat_dev) {
+			if (!(fbd_ioat_list[i].enabled || enable_all))
+				continue;
 			if (fbd_dev)
 				*fbd_dev = memdev;
 			if (ioat_dev)
-- 
1.6.3.1.169.g33fd


