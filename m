Return-Path: <linux-kernel-owner+w=401wt.eu-S937654AbZDDB7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937654AbZDDB7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 21:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937415AbZDDB5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 21:57:50 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64895 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937410AbZDDB5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 21:57:49 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
Date: Fri,  3 Apr 2009 20:56:46 -0500
Message-Id: <1238810209-24499-5-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1238810209-24499-4-git-send-email-beckyb@kernel.crashing.org>
References: <1238810209-24499-1-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-2-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-3-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-4-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures require additional checking to determine
if a device can dma to an address and need to provide their
own address_needs_mapping..

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index eb6dbbd..af2ec25 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -145,6 +145,12 @@ static void *swiotlb_bus_to_virt(dma_addr_t address)
 	return phys_to_virt(swiotlb_bus_to_phys(address));
 }
 
+int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
+					       dma_addr_t addr, size_t size)
+{
+	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
+}
+
 int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
 	return 0;
@@ -309,10 +315,10 @@ cleanup1:
 	return -ENOMEM;
 }
 
-static int
+static inline int
 address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 {
-	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
+	return swiotlb_arch_address_needs_mapping(hwdev, addr, size);
 }
 
 static inline int range_needs_mapping(phys_addr_t paddr, size_t size)
-- 
1.5.6.6

