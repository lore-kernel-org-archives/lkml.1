Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbYKNJBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbYKNJBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 04:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbYKNJBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 04:01:11 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:30582 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYKNJBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 04:01:10 -0500
Message-Id: <491D4C89.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 14 Nov 2008 09:01:46 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ian Campbell" <ian.campbell@citrix.com>, "Ingo Molnar" <mingo@elte.hu>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 03 of 38] swiotlb: allow architectures
	 tooverride swiotlb pool allocation
References: <patchbomb.1226603398@abulafia.goop.org>
 <e9f25b3bb6625ee88f9f.1226603401@abulafia.goop.org>
In-Reply-To: <e9f25b3bb6625ee88f9f.1226603401@abulafia.goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not directly related to this patch alone, but to the combined set of changes
to swiotlb: I don't see any handling of CONFIG_HIGHMEM here (or at least
a note that this a known limitation needing work). I mention this because
this was the largest part of the changes I had posted long ago to make
lib/swiotlb.c Xen-ready, and which got rejected due to their ugliness.

While perhaps less intrusive to take care of, I also didn't see an equivalent
of the range_straddles_page_boundary() logic, without which I can't see
how this would work in the common case.

Jan

>>> Jeremy Fitzhardinge <jeremy@goop.org> 13.11.08 20:10 >>>
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



_______________________________________________
Xen-devel mailing list
Xen-devel@lists.xensource.com 
http://lists.xensource.com/xen-devel

