Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYC3QOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYC3QOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 12:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYC3QOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 12:14:05 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:45765 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYC3QOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 12:14:04 -0400
Date: Sun, 30 Mar 2008 20:14:00 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>
Cc: Bob Tracy <rct@frus.com>, Tyson Whitehead <twhitehe@uwo.ca>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       Michael Cree <mcree@orcon.net.nz>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
Message-ID: <20080330161400.GA24443@jurassic.park.msu.ru>
References: <20080329064227.58074DBA2@gherkin.frus.com> <47EE317E.9030807@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EE317E.9030807@keyaccess.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2008 at 01:09:34PM +0100, Rene Herman wrote:
> Okay. The thing that "fixed" Tyson was disabling mmap from the driver:
>
> http://mailman.alsa-project.org/pipermail/alsa-devel/2008-March/006911.html

Weird - I was sure the mmap problem has been fixed, but obviously
the patch didn't go in...

Andrew, could you please queue this up for 2.6.26?

Ivan.

--
alpha: fix ALSA DMA mmap crash

Make dma_alloc_coherent respect gfp flags (__GFP_COMP is one that
matters).

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/pci_iommu.c   |    8 +++++---
 include/asm-alpha/dma-mapping.h |    2 +-
 include/asm-alpha/pci.h         |    8 +++++++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 4e1c086..dd6e334 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -424,11 +424,13 @@ EXPORT_SYMBOL(pci_unmap_page);
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
@@ -458,7 +460,7 @@ try_again:
 
 	return cpu_addr;
 }
-EXPORT_SYMBOL(pci_alloc_consistent);
+EXPORT_SYMBOL(__pci_alloc_consistent);
 
 /* Free and unmap a consistent DMA buffer.  CPU_ADDR and DMA_ADDR must
    be values that were returned from pci_alloc_consistent.  SIZE must
diff --git a/include/asm-alpha/dma-mapping.h b/include/asm-alpha/dma-mapping.h
index 75a1aff..db351d1 100644
--- a/include/asm-alpha/dma-mapping.h
+++ b/include/asm-alpha/dma-mapping.h
@@ -11,7 +11,7 @@
 #define dma_unmap_single(dev, addr, size, dir)		\
 		pci_unmap_single(alpha_gendev_to_pci(dev), addr, size, dir)
 #define dma_alloc_coherent(dev, size, addr, gfp)	\
-		pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr)
+	      __pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr, gfp)
 #define dma_free_coherent(dev, size, va, addr)		\
 		pci_free_consistent(alpha_gendev_to_pci(dev), size, va, addr)
 #define dma_map_page(dev, page, off, size, dir)		\
diff --git a/include/asm-alpha/pci.h b/include/asm-alpha/pci.h
index d5b10ef..d31fd49 100644
--- a/include/asm-alpha/pci.h
+++ b/include/asm-alpha/pci.h
@@ -76,7 +76,13 @@ extern inline void pcibios_penalize_isa_irq(int irq, int active)
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
