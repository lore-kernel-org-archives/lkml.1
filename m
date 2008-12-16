Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYLPUTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYLPUTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYLPUSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:18:46 -0500
Received: from gw.goop.org ([64.81.55.164]:45893 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbYLPUSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:18:45 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 14] swiotlb: allow architectures to override swiotlb pool
	allocation
X-Mercurial-Node: 2807da57d86c95c414a4ae730ff499d82278d30b
Message-Id: <2807da57d86c95c414a4.1229458646@abulafia.goop.org>
In-Reply-To: <patchbomb.1229458644@abulafia.goop.org>
Date: Tue, 16 Dec 2008 12:17:26 -0800
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

Architectures may need to allocate memory specially for use with
the swiotlb.  Create the weak function swiotlb_alloc_boot() and
swiotlb_alloc() defaulting to the current behaviour.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/swiotlb.h |    3 +++
 lib/swiotlb.c           |   16 +++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -10,6 +10,9 @@
 extern void
 swiotlb_init(void);
 
+extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
+extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
+
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -21,6 +21,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/swiotlb.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
@@ -126,6 +127,16 @@
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
+void * __weak swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+{
+	return alloc_bootmem_low_pages(size);
+}
+
+void * __weak swiotlb_alloc(unsigned order, unsigned long nslabs)
+{
+	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -145,7 +156,7 @@
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
+	io_tlb_start = swiotlb_alloc_boot(bytes, io_tlb_nslabs);
 	if (!io_tlb_start)
 		panic("Cannot allocate SWIOTLB buffer");
 	io_tlb_end = io_tlb_start + bytes;
@@ -202,8 +213,7 @@
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = (char *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
-		                                        order);
+		io_tlb_start = swiotlb_alloc(order, io_tlb_nslabs);
 		if (io_tlb_start)
 			break;
 		order--;


