Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbYLPUVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbYLPUVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYLPUSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:18:50 -0500
Received: from gw.goop.org ([64.81.55.164]:45921 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbYLPUSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:18:48 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 14] swiotlb: add arch hook to force mapping
X-Mercurial-Node: de816a2fdde6a5f940cd43eba668240351202b8b
Message-Id: <de816a2fdde6a5f940cd.1229458651@abulafia.goop.org>
In-Reply-To: <patchbomb.1229458644@abulafia.goop.org>
Date: Tue, 16 Dec 2008 12:17:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jan Beulich <jbeulich@novell.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Some architectures require special rules to determine whether a range
needs mapping or not.  This adds a weak function for architectures to
override.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/swiotlb.h |    2 ++
 lib/swiotlb.c           |   15 +++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -30,6 +30,8 @@
 extern dma_addr_t swiotlb_phys_to_bus(phys_addr_t address);
 extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
 
+extern int swiotlb_arch_range_needs_mapping(void *ptr, size_t size);
+
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -145,6 +145,11 @@
 	return phys_to_virt(swiotlb_bus_to_phys(address));
 }
 
+int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
+{
+	return 0;
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -297,6 +302,11 @@
 	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
 }
 
+static inline int range_needs_mapping(void *ptr, size_t size)
+{
+	return swiotlb_force || swiotlb_arch_range_needs_mapping(ptr, size);
+}
+
 static int is_swiotlb_buffer(char *addr)
 {
 	return addr >= io_tlb_start && addr < io_tlb_end;
@@ -581,7 +591,8 @@
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(hwdev, dev_addr, size) && !swiotlb_force)
+	if (!address_needs_mapping(hwdev, dev_addr, size) &&
+	    !range_needs_mapping(ptr, size))
 		return dev_addr;
 
 	/*
@@ -741,7 +752,7 @@
 	for_each_sg(sgl, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
 		dev_addr = swiotlb_virt_to_bus(addr);
-		if (swiotlb_force ||
+		if (range_needs_mapping(sg_virt(sg), sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, addr, sg->length, dir);
 			if (!map) {


