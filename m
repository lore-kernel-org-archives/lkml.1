Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbZE2Ioy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbZE2Ioy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbZE2IoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:44:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60514 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbZE2IoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:44:08 -0400
X-IronPort-AV: E=Sophos;i="4.41,270,1241409600"; 
   d="scan'208";a="53001166"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, <x86@kernel.org>
Subject: [PATCH 3/9] x86: use dma_map_range when allocating PCI DMA memory
Date: Fri, 29 May 2009 09:43:57 +0100
Message-ID: <1243586643-5554-4-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
References: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is intended to replaces is_buffer_dma_capable with a
more generic interface.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: x86@kernel.org
---
 arch/x86/kernel/pci-dma.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 6a6a116..a355083 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -160,7 +160,6 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 {
 	unsigned long dma_mask;
 	struct page *page;
-	dma_addr_t addr;
 
 	dma_mask = dma_alloc_coherent_mask(dev, flag);
 
@@ -170,8 +169,7 @@ again:
 	if (!page)
 		return NULL;
 
-	addr = page_to_phys(page);
-	if (!is_buffer_dma_capable(dma_mask, addr, size)) {
+	if (!dma_map_range(dev, dma_mask, page_to_phys(page), size, dma_addr)) {
 		__free_pages(page, get_order(size));
 
 		if (dma_mask < DMA_BIT_MASK(32) && !(flag & GFP_DMA)) {
@@ -182,7 +180,6 @@ again:
 		return NULL;
 	}
 
-	*dma_addr = addr;
 	return page_address(page);
 }
 
-- 
1.5.6.5

