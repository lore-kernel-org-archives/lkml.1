Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYLPUWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYLPUWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYLPUSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:18:52 -0500
Received: from gw.goop.org ([64.81.55.164]:45911 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532AbYLPUSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:18:49 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 14] swiotlb: consolidate swiotlb info message printing
X-Mercurial-Node: 13e4d6097a647003137015a9628417cd8430931e
Message-Id: <13e4d6097a6470031370.1229458654@abulafia.goop.org>
In-Reply-To: <patchbomb.1229458644@abulafia.goop.org>
Date: Tue, 16 Dec 2008 12:17:34 -0800
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

Remove duplicated swiotlb info printing, and make it more detailed.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 lib/swiotlb.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -156,6 +156,32 @@
 	return swiotlb_phys_to_bus(page_to_phys(sg_page(sg)) + sg->offset);
 }
 
+static void swiotlb_print_info(unsigned long bytes)
+{
+	phys_addr_t pstart, pend;
+	dma_addr_t bstart, bend;
+
+	pstart = virt_to_phys(io_tlb_start);
+	pend = virt_to_phys(io_tlb_end);
+
+	bstart = swiotlb_phys_to_bus(pstart);
+	bend = swiotlb_phys_to_bus(pend);
+
+	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
+	       bytes >> 20, io_tlb_start, io_tlb_end);
+	if (pstart != bstart || pend != bend)
+		printk(KERN_INFO "software IO TLB at phys %#llx - %#llx"
+		       " bus %#llx - %#llx\n",
+		       (unsigned long long)pstart,
+		       (unsigned long long)pend,
+		       (unsigned long long)bstart,
+		       (unsigned long long)bend);
+	else
+		printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
+		       (unsigned long long)pstart,
+		       (unsigned long long)pend);
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -198,8 +224,7 @@
 	if (!io_tlb_overflow_buffer)
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 
-	printk(KERN_INFO "Placing software IO TLB between 0x%lx - 0x%lx\n",
-	       swiotlb_virt_to_bus(io_tlb_start), swiotlb_virt_to_bus(io_tlb_end));
+	swiotlb_print_info(bytes);
 }
 
 void __init
@@ -279,9 +304,7 @@
 	if (!io_tlb_overflow_buffer)
 		goto cleanup4;
 
-	printk(KERN_INFO "Placing %luMB software IO TLB between 0x%lx - "
-	       "0x%lx\n", bytes >> 20,
-	       swiotlb_virt_to_bus(io_tlb_start), swiotlb_virt_to_bus(io_tlb_end));
+	swiotlb_print_info(bytes);
 
 	return 0;
 


