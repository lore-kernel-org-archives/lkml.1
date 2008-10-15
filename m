Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYJOCJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYJOCJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 22:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYJOCIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 22:08:41 -0400
Received: from gw.goop.org ([64.81.55.164]:55287 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbYJOCIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 22:08:40 -0400
Message-ID: <48F5509B.80905@goop.org>
Date: Tue, 14 Oct 2008 19:08:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Joerg Roedel <joerg.roedel@amd.com>, Jan Beulich <jbeulich@novell.com>,
       Tony Luck <tony.luck@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] swiotlb: allow architectures to override swiotlb pool
 allocation
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures may need to allocate memory specially for use with
the swiotlb.  Create the weak function swiotlb_alloc_boot() and
swiotlb_alloc() defaulting to the current behaviour.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/swiotlb.h |    3 +++
 lib/swiotlb.c           |   15 ++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

===================================================================
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -2,6 +2,9 @@
 #define LINUX__SWIOTLB_H
 
 #include <asm/swiotlb.h>
+
+extern void *swiotlb_alloc_boot(size_t bytes);
+extern void *swiotlb_alloc(unsigned order);
 
 /* SWIOTLB interface */
 
===================================================================
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -127,6 +127,16 @@
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
+void * __weak swiotlb_alloc_boot(size_t size)
+{
+	return alloc_bootmem_low_pages(size);
+}
+
+void * __weak swiotlb_alloc(unsigned order)
+{
+	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -146,7 +156,7 @@
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
+	io_tlb_start = swiotlb_alloc_boot(bytes);
 	if (!io_tlb_start)
 		panic("Cannot allocate SWIOTLB buffer");
 	io_tlb_end = io_tlb_start + bytes;
@@ -203,8 +213,7 @@
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = (char *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
-		                                        order);
+		io_tlb_start = swiotlb_alloc(order);
 		if (io_tlb_start)
 			break;
 		order--;


