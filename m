Return-Path: <linux-kernel-owner+w=401wt.eu-S1765041AbXHQAK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765041AbXHQAK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 20:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbXHQAKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 20:10:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:19179 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXHQAKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 20:10:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,273,1183359600"; 
   d="scan'208";a="118468745"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [-mm PATCH] DMA engine kconfig improvements (rev2)
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: shannon.nelson@intel.com, dan.j.williams@intel.com, ssatyam@cse.iitk.ac.in,
       bunk@kernel.org
Date: Thu, 16 Aug 2007 17:10:25 -0700
Message-ID: <20070817001025.5634.54557.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

This patch contains the following changes to the DMA engine menus:
- switch to menuconfig
- INTEL_IOATDMA must depend on X86
- INTEL_IOATDMA must select DCA
- device drivers shouldn't "default m"
- DCA shouldn't be a user visible option
- make it clear in the INTEL_IOATDMA help text that this driver is for
  rare hardware the user most likely doesn't has
- let DMA_ENGINE be select'ed by the DMA devices, making it less likely
  for a user to accidentally enable NET_DMA

[dan.j.williams@intel.com: fix up Kconfig text]
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dca/Kconfig |    7 ++----
 drivers/dma/Kconfig |   60 ++++++++++++++++++++++++++++++---------------------
 2 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/dca/Kconfig b/drivers/dca/Kconfig
index d901615..c2ed77c 100644
--- a/drivers/dca/Kconfig
+++ b/drivers/dca/Kconfig
@@ -3,9 +3,6 @@
 #
 
 config DCA
-	tristate "DCA support for clients and providers"
-	---help---
-          This is a server to help modules that want to use Direct Cache
-	  Access to find DCA providers that will supply correct CPU tags.
-	default m
+	tristate
+
 
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 8f670da..955a99b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -2,42 +2,52 @@
 # DMA engine configuration
 #
 
-menu "DMA Engine support"
-	depends on HAS_DMA
+menuconfig DMADEVICES
+	bool "DMA Offload Engine support"
+	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+	help
+	  Intel(R) offload engines enable offloading memory copies in the
+	  network stack and RAID operations in the MD driver.
+
+if DMADEVICES
+
+comment "DMA Devices"
+
+config INTEL_IOATDMA
+	tristate "Intel I/OAT DMA support"
+	depends on PCI && X86
+	select DMA_ENGINE
+	select DCA
+	help
+	  Enable support for the Intel(R) I/OAT DMA engine present
+	  in recent chipsets.
+
+	  Say Y here if you have such a chipset.
+
+	  If unsure, say N.
+
+config INTEL_IOP_ADMA
+	tristate "Intel IOP ADMA support"
+	depends on ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+	select ASYNC_CORE
+	select DMA_ENGINE
+	help
+	  Enable support for the Intel(R) IOP Series RAID engines.
 
 config DMA_ENGINE
-	bool "Support for DMA engines"
-	---help---
-          DMA engines offload bulk memory operations from the CPU to dedicated
-          hardware, allowing the operations to happen asynchronously.
+	bool
 
 comment "DMA Clients"
+	depends on DMA_ENGINE
 
 config NET_DMA
 	bool "Network: TCP receive copy offload"
 	depends on DMA_ENGINE && NET
 	default y
-	---help---
+	help
 	  This enables the use of DMA engines in the network stack to
 	  offload receive copy-to-user operations, freeing CPU cycles.
 	  Since this is the main user of the DMA engine, it should be enabled;
 	  say Y here.
 
-comment "DMA Devices"
-
-config INTEL_IOATDMA
-	tristate "Intel I/OAT DMA support"
-	depends on DMA_ENGINE && PCI
-	default m
-	---help---
-	  Enable support for the Intel(R) I/OAT DMA engine.
-
-config INTEL_IOP_ADMA
-        tristate "Intel IOP ADMA support"
-        depends on DMA_ENGINE && (ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX)
-	select ASYNC_CORE
-        default m
-        ---help---
-          Enable support for the Intel(R) IOP Series RAID engines.
-
-endmenu
+endif
