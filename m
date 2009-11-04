Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbZKDM2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbZKDM2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZKDM2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:28:37 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:32937 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbZKDM2h convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Wed, 4 Nov 2009 07:28:37 -0500
Message-Id: <4AF18187020000780001D8AA@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 04 Nov 2009 12:28:39 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Takashi Iwai" <tiwai@suse.de>, <linux-kernel@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>
Subject: [PATCH] x86: adjust GFP mask handling for coherent allocations
	 (take 2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than forcing GFP flags and DMA mask to be inconsistent, GFP
flags should be determined even for the fallback device through
dma_alloc_coherent_mask()/dma_alloc_coherent_gfp_flags(). This
restores 64-bit behavior as it was prior to commits
8965eb19386fdf5ccd0ef8b02593eb8560aa3416 and
4a367f3a9dbf2e7ffcee4702203479809236ee6e (not sure why there are two of
them), where GFP_DMA was forced on for 32-bit, but not for 64-bit, with
the slight adjustment that afaict even 32-bit doesn't need this without
CONFIG_ISA.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

---
 arch/x86/include/asm/dma-mapping.h |   10 +++++++---
 arch/x86/kernel/pci-dma.c          |    6 ++----
 2 files changed, 9 insertions(+), 7 deletions(-)

--- linux-2.6.32-rc6/arch/x86/include/asm/dma-mapping.h	2009-11-04 13:23:36.000000000 +0100
+++ 2.6.32-rc6-x86-dma-mask-gfp/arch/x86/include/asm/dma-mapping.h	2009-10-27 11:10:28.000000000 +0100
@@ -14,6 +14,12 @@
 #include <asm/swiotlb.h>
 #include <asm-generic/dma-coherent.h>
 
+#ifdef CONFIG_ISA
+#define ISA_DMA_BIT_MASK DMA_BIT_MASK(24)
+#else
+#define ISA_DMA_BIT_MASK DMA_BIT_MASK(32)
+#endif
+
 extern dma_addr_t bad_dma_address;
 extern int iommu_merge;
 extern struct device x86_dma_fallback_dev;
@@ -124,10 +130,8 @@ dma_alloc_coherent(struct device *dev, s
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
 		return memory;
 
-	if (!dev) {
+	if (!dev)
 		dev = &x86_dma_fallback_dev;
-		gfp |= GFP_DMA;
-	}
 
 	if (!is_device_dma_capable(dev))
 		return NULL;
--- linux-2.6.32-rc6/arch/x86/kernel/pci-dma.c	2009-11-04 13:23:36.000000000 +0100
+++ 2.6.32-rc6-x86-dma-mask-gfp/arch/x86/kernel/pci-dma.c	2009-10-27 11:14:11.000000000 +0100
@@ -45,12 +45,10 @@ int iommu_pass_through __read_mostly;
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
 
-/* Dummy device used for NULL arguments (normally ISA). Better would
-   be probably a smaller DMA mask, but this is bug-to-bug compatible
-   to older i386. */
+/* Dummy device used for NULL arguments (normally ISA). */
 struct device x86_dma_fallback_dev = {
 	.init_name = "fallback device",
-	.coherent_dma_mask = DMA_BIT_MASK(32),
+	.coherent_dma_mask = ISA_DMA_BIT_MASK,
 	.dma_mask = &x86_dma_fallback_dev.coherent_dma_mask,
 };
 EXPORT_SYMBOL(x86_dma_fallback_dev);



