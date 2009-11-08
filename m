Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZKHLMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZKHLMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbZKHLMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:12:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43338 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbZKHLMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:12:21 -0500
Date: Sun, 8 Nov 2009 12:12:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: [PATCH, v3] x86: Adjust GFP mask handling for coherent allocations
Message-ID: <20091108111214.GK11372@elte.hu>
References: <4AF18187020000780001D8AA@vpn.id2.novell.com>
 <s5hocnfu0ct.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hocnfu0ct.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Takashi Iwai <tiwai@suse.de> wrote:

> At Wed, 04 Nov 2009 12:28:39 +0000,
> Jan Beulich wrote:
> > 
> > Rather than forcing GFP flags and DMA mask to be inconsistent, GFP
> > flags should be determined even for the fallback device through
> > dma_alloc_coherent_mask()/dma_alloc_coherent_gfp_flags(). This
> > restores 64-bit behavior as it was prior to commits
> > 8965eb19386fdf5ccd0ef8b02593eb8560aa3416 and
> > 4a367f3a9dbf2e7ffcee4702203479809236ee6e (not sure why there are two of
> > them), where GFP_DMA was forced on for 32-bit, but not for 64-bit, with
> > the slight adjustment that afaict even 32-bit doesn't need this without
> > CONFIG_ISA.
> > 
> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > Cc: Takashi Iwai <tiwai@suse.de>
> 
> Acked-by: Takashi Iwai <tiwai@suse.de>

Jesse, mind picking this up for .32?

I've attached below a slightly cleaned up version of the patch, with 
Takashi's ack added.

Thanks,

	Ingo

------------------>
Subject: x86: Adjust GFP mask handling for coherent allocations
From: "Jan Beulich" <JBeulich@novell.com>
Date: Wed, 04 Nov 2009 12:28:39 +0000

Rather than forcing GFP flags and DMA mask to be inconsistent,
GFP flags should be determined even for the fallback device
through dma_alloc_coherent_mask()/dma_alloc_coherent_gfp_flags().

This restores 64-bit behavior as it was prior to commits
8965eb19386fdf5ccd0ef8b02593eb8560aa3416 and
4a367f3a9dbf2e7ffcee4702203479809236ee6e (not sure why there are
two of them), where GFP_DMA was forced on for 32-bit, but not
for 64-bit, with the slight adjustment that afaict even 32-bit
doesn't need this without CONFIG_ISA.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <4AF18187020000780001D8AA@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/dma-mapping.h |   10 +++++++---
 arch/x86/kernel/pci-dma.c          |    6 ++----
 2 files changed, 9 insertions(+), 7 deletions(-)

Index: tip/arch/x86/include/asm/dma-mapping.h
===================================================================
--- tip.orig/arch/x86/include/asm/dma-mapping.h
+++ tip/arch/x86/include/asm/dma-mapping.h
@@ -14,6 +14,12 @@
 #include <asm/swiotlb.h>
 #include <asm-generic/dma-coherent.h>
 
+#ifdef CONFIG_ISA
+# define ISA_DMA_BIT_MASK DMA_BIT_MASK(24)
+#else
+# define ISA_DMA_BIT_MASK DMA_BIT_MASK(32)
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
Index: tip/arch/x86/kernel/pci-dma.c
===================================================================
--- tip.orig/arch/x86/kernel/pci-dma.c
+++ tip/arch/x86/kernel/pci-dma.c
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
