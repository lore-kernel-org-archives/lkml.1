Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZJVMCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZJVMCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbZJVMCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:02:51 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52336 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbZJVMCv convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Thu, 22 Oct 2009 08:02:51 -0400
Message-Id: <4AE06644020000780001B4AD@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 22 Oct 2009 13:03:48 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Takashi Iwai" <tiwai@suse.de>, <linux-kernel@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>
Subject: [PATCH] x86: adjust GFP mask handling for coherent allocations
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
 arch/x86/include/asm/dma-mapping.h |    4 +---
 arch/x86/kernel/pci-dma.c          |    8 +++++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.32-rc5/arch/x86/include/asm/dma-mapping.h	2009-10-19 13:09:44.000000000 +0200
+++ 2.6.32-rc5-x86-dma-mask-gfp/arch/x86/include/asm/dma-mapping.h	2009-10-22 10:54:08.000000000 +0200
@@ -124,10 +124,8 @@ dma_alloc_coherent(struct device *dev, s
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
 		return memory;
 
-	if (!dev) {
+	if (!dev)
 		dev = &x86_dma_fallback_dev;
-		gfp |= GFP_DMA;
-	}
 
 	if (!is_device_dma_capable(dev))
 		return NULL;
--- linux-2.6.32-rc5/arch/x86/kernel/pci-dma.c	2009-10-19 13:09:45.000000000 +0200
+++ 2.6.32-rc5-x86-dma-mask-gfp/arch/x86/kernel/pci-dma.c	2009-10-22 10:56:46.000000000 +0200
@@ -45,12 +45,14 @@ int iommu_pass_through __read_mostly;
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
 
-/* Dummy device used for NULL arguments (normally ISA). Better would
-   be probably a smaller DMA mask, but this is bug-to-bug compatible
-   to older i386. */
+/* Dummy device used for NULL arguments (normally ISA). */
 struct device x86_dma_fallback_dev = {
 	.init_name = "fallback device",
+#ifdef CONFIG_ISA
+	.coherent_dma_mask = DMA_BIT_MASK(24),
+#else
 	.coherent_dma_mask = DMA_BIT_MASK(32),
+#endif
 	.dma_mask = &x86_dma_fallback_dev.coherent_dma_mask,
 };
 EXPORT_SYMBOL(x86_dma_fallback_dev);



