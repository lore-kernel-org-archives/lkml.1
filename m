Return-Path: <linux-kernel-owner+w=401wt.eu-S1764223AbXGKNCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764223AbXGKNCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbXGKNCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:02:46 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:48811 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbXGKNCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:02:46 -0400
Date: Wed, 11 Jul 2007 17:02:45 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Hugh Dickins <hugh@veritas.com>
Cc: Bob Tracy <rct@gherkin.frus.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc6 bad page error
Message-ID: <20070711170245.A1148@jurassic.park.msu.ru>
References: <20070709185324.387ACDBA1@gherkin.frus.com> <Pine.LNX.4.64.0707102120550.7594@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <Pine.LNX.4.64.0707102120550.7594@blonde.wat.veritas.com>; from hugh@veritas.com on Tue, Jul 10, 2007 at 09:25:50PM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 09:25:50PM +0100, Hugh Dickins wrote:
> On Mon, 9 Jul 2007, Bob Tracy wrote:
> > That seems to have done the trick.  Normally, I get the "bad page"
> > errors on the second NX session, but I'm on the third session of the
> > day (thus far), and everything seems to be ok as far as I can tell.
> 
> Thanks a lot for the feedback, that tells us we've made the right
> guesses, and my __GFP_COMP patch should be a good bandaid for you;
> but for the right patch, let's wait to hear from Ivan.

Here it is. Bob, can you test this one?

---

Take care of DMA flags passed to dma_alloc_coherent().
Particularly ALSA needs that.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.

--- 2.6.22/arch/alpha/kernel/pci_iommu.c	Mon Jul  9 03:32:17 2007
+++ linux/arch/alpha/kernel/pci_iommu.c	Wed Jul 11 14:40:37 2007
@@ -398,11 +398,13 @@ EXPORT_SYMBOL(pci_unmap_page);
    else DMA_ADDRP is undefined.  */
 
 void *
-pci_alloc_consistent(struct pci_dev *pdev, size_t size, dma_addr_t *dma_addrp)
+__pci_alloc_consistent(struct pci_dev *pdev, size_t size,
+		       dma_addr_t *dma_addrp, gfp_t gfp)
 {
 	void *cpu_addr;
 	long order = get_order(size);
-	gfp_t gfp = GFP_ATOMIC;
+
+	gfp &= ~GFP_DMA;
 
 try_again:
 	cpu_addr = (void *)__get_free_pages(gfp, order);
@@ -432,7 +434,7 @@ try_again:
 
 	return cpu_addr;
 }
-EXPORT_SYMBOL(pci_alloc_consistent);
+EXPORT_SYMBOL(__pci_alloc_consistent);
 
 /* Free and unmap a consistent DMA buffer.  CPU_ADDR and DMA_ADDR must
    be values that were returned from pci_alloc_consistent.  SIZE must
--- 2.6.22/include/asm-alpha/pci.h	Mon Jul  9 03:32:17 2007
+++ linux/include/asm-alpha/pci.h	Wed Jul 11 14:40:37 2007
@@ -75,7 +75,13 @@ extern inline void pcibios_penalize_isa_
    successful and sets *DMA_ADDRP to the pci side dma address as well,
    else DMA_ADDRP is undefined.  */
 
-extern void *pci_alloc_consistent(struct pci_dev *, size_t, dma_addr_t *);
+extern void *__pci_alloc_consistent(struct pci_dev *, size_t,
+				    dma_addr_t *, gfp_t);
+static inline void *
+pci_alloc_consistent(struct pci_dev *dev, size_t size, dma_addr_t *dma)
+{
+	return __pci_alloc_consistent(dev, size, dma, GFP_ATOMIC);
+}
 
 /* Free and unmap a consistent DMA buffer.  CPU_ADDR and DMA_ADDR must
    be values that were returned from pci_alloc_consistent.  SIZE must
--- 2.6.22/include/asm-alpha/dma-mapping.h	Mon Jul  9 03:32:17 2007
+++ linux/include/asm-alpha/dma-mapping.h	Wed Jul 11 14:40:37 2007
@@ -11,7 +11,7 @@
 #define dma_unmap_single(dev, addr, size, dir)		\
 		pci_unmap_single(alpha_gendev_to_pci(dev), addr, size, dir)
 #define dma_alloc_coherent(dev, size, addr, gfp)	\
-		pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr)
+	      __pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr, gfp)
 #define dma_free_coherent(dev, size, va, addr)		\
 		pci_free_consistent(alpha_gendev_to_pci(dev), size, va, addr)
 #define dma_map_page(dev, page, off, size, dir)		\
