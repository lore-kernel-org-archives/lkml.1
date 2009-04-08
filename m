Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbZDHOOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbZDHOOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765994AbZDHOKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:10:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:35396 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765138AbZDHOKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:10:49 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: beckyb@kernel.crashing.org
Subject: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
Date: Wed,  8 Apr 2009 09:09:18 -0500
Message-Id: <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239199761-22886-4-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-2-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-3-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-4-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

Some architectures require additional checking to determine
if a device can dma to an address and need to provide their
own address_needs_mapping..

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 lib/swiotlb.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e8a47c8..d81afab 100644
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
1.6.0.6

