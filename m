Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbZFAPe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbZFAPe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZFAPdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:33:33 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:29936 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbZFAPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:33:32 -0400
X-IronPort-AV: E=Sophos;i="4.41,284,1241409600"; 
   d="scan'208";a="53320395"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, <x86@kernel.org>
Subject: [PATCH 05/11] x86: use dma_map_range when allocating PCI GART memory
Date: Mon, 1 Jun 2009 16:32:57 +0100
Message-ID: <1243870383-12954-6-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
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
 arch/x86/kernel/pci-gart_64.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 1e8920d..eb043bd 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -190,14 +190,16 @@ static void iommu_full(struct device *dev, size_t size, int dir)
 static inline int
 need_iommu(struct device *dev, unsigned long addr, size_t size)
 {
+	dma_addr_t dma_addr;
 	return force_iommu ||
-		!is_buffer_dma_capable(*dev->dma_mask, addr, size);
+	       !dma_map_range(dev, *dev->dma_mask, addr, size, &dma_addr);
 }
 
 static inline int
 nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 {
-	return !is_buffer_dma_capable(*dev->dma_mask, addr, size);
+	dma_addr_t dma_addr;
+	return !dma_map_range(dev, *dev->dma_mask, addr, size, &dma_addr);
 }
 
 /* Map a single continuous physical area into the IOMMU.
-- 
1.5.6.5

