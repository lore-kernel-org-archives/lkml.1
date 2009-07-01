Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZGARfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZGARfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZGARe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:34:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:53862 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZGARe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:34:57 -0400
Subject: [PATCH] Fix pci_unmap_addr() et al on i386.
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org, x86 maintainers <x86@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jul 2009 18:34:52 +0100
Message-Id: <1246469692.3681.1949.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can run a 32-bit kernel on boxes with an IOMMU, so we need
pci_unmap_addr() etc. to work -- without it, drivers will leak mappings.

To be honest, this whole thing looks like it's more pain than it's
worth; I'm half inclined to remove the no-op #else case altogether.

But this is the minimal fix, which just does the right thing if
CONFIG_DMAR is set.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
Needed in 2.6.30, but not earlier because you can't enable CONFIG_DMAR
before that. Jörg, if you ever enable the AMD IOMMU in 32-bit mode you
may have to fix this again (unless we just make it unconditionally do
the right thing, which probably gets my vote).

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 927958d..1ff685c 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -91,7 +91,7 @@ extern void pci_iommu_alloc(void);
 
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_DMA_API_DEBUG)
+#if defined(CONFIG_X86_64) || defined(CONFIG_DMAR) || defined(CONFIG_DMA_API_DEBUG)
 
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)       \
 	        dma_addr_t ADDR_NAME;

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

