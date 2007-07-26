Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbXGZF1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbXGZF1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbXGZF04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:26:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44894 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751163AbXGZF0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:26:55 -0400
Date: Thu, 26 Jul 2007 07:26:28 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Shannon Nelson <shannon.nelson@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] DMA engine kconfig improvements
Message-ID: <20070726052628.GL3572@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +dma-arch-fix.patch
> 
>  Fix git-dma.patch
>...

This results in an ARM-only driver in an X86-only menu...

What about the patch below instead that also improves a few other things?


<--  snip  -->


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

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/dca/Kconfig |    7 +----
 drivers/dma/Kconfig |   59 +++++++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 30 deletions(-)

--- linux-2.6.23-rc1-mm1/drivers/dma/Kconfig.old	2007-07-26 06:45:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/dma/Kconfig	2007-07-26 07:08:46.000000000 +0200
@@ -2,42 +2,51 @@
 # DMA engine configuration
 #
 
-menu "DMA Engine support"
-	depends on HAS_DMA
+menuconfig DMADEVICES
+	bool "DMA Engine support"
+	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+	help
+	  Intel(R) DMA engines
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
+	  in recent Intel Xeon CPUs.
+
+	  Say yes if you have such a CPU.
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
--- linux-2.6.23-rc1-mm1/drivers/dca/Kconfig.old	2007-07-26 06:49:32.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/dca/Kconfig	2007-07-26 06:49:41.000000000 +0200
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
 

