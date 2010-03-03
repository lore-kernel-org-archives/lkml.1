Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0CCC6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 21:58:39 -0500
Received: from sh.osrg.net ([192.16.179.4]:38173 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab0CCC6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 21:58:37 -0500
Date: Wed, 3 Mar 2010 11:58:31 +0900
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH -mm 7/7] pci: move pci_set_dma_mask and
 pci_set_consistent_dma_mask to pci-dma-compat.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100302182927.0099eb68.akpm@linux-foundation.org>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1265967212-9126-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20100302182927.0099eb68.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100303115805Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 03 Mar 2010 11:58:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010 18:29:27 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 12 Feb 2010 18:33:32 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > We can use pci-dma-compat.h to implement pci_set_dma_mask and
> > pci_set_consistent_dma_mask as we do with the other PCI DMA API.
> > 
> > We can remove HAVE_ARCH_PCI_SET_DMA_MASK too.
> 
> i386 allnoconfig:

Sorry about that.

> include/asm-generic/pci-dma-compat.h:105: error: redefinition of 'pci_set_dma_mask'
> include/linux/pci.h:1092: error: previous definition of 'pci_set_dma_mask' was here
> include/asm-generic/pci-dma-compat.h:110: error: redefinition of 'pci_set_consistent_dma_mask'
> include/linux/pci.h:1097: error: previous definition of 'pci_set_consistent_dma_mask' was here
> 
> In fact the whole of include/asm-generic/pci-dma-compat.h seems a bit
> fishy when CONFIG_PCI=n.  Shouldn't all those functions be
> EIO-returning stubs?

Might be (and it should work). However, when CONFIG_PCI=n, we has
silently converted the PCI DMA API to the generic DMA API.

In the long term, we remove the pci_dma_* API.

Can you fold this into the above patch?

diff --git a/include/asm-generic/pci-dma-compat.h b/include/asm-generic/pci-dma-compat.h
index ddfa9c5..1437b7d 100644
--- a/include/asm-generic/pci-dma-compat.h
+++ b/include/asm-generic/pci-dma-compat.h
@@ -101,6 +101,7 @@ pci_dma_mapping_error(struct pci_dev *pdev, dma_addr_t dma_addr)
 	return dma_mapping_error(&pdev->dev, dma_addr);
 }
 
+#ifdef CONFIG_PCI
 static inline int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
 {
 	return dma_set_mask(&dev->dev, mask);
@@ -110,5 +111,6 @@ static inline int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
 {
 	return dma_set_coherent_mask(&dev->dev, mask);
 }
+#endif
 
 #endif
