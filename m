Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab0CGMML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 07:12:11 -0500
Received: from smtp134.mail.ukl.yahoo.com ([77.238.184.65]:20867 "HELO
	smtp134.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753168Ab0CGMMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 07:12:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=Ur4U+oWk1G1cF68DCbNv7pIzu4E0cCbVfGTHDqvQhIomIA5VyU19EbphwPPNJn6UDQJ9woZsEvoJ2FcpPvpZG+PD2MGYHK4H1CfdKeYYi88NdVn4LBiyDItcdb836JneaErSFVmrPsK+L5bkNsnIfyYuJhZy7R3mZ9Jym1pZCFc=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: MvtpEE4VM1kqg5xGT5QuiBLkiq9N6Bzaxz2RObwV.ftbRNuDfzvy0azKPaedVAkBdVZ77wBmUZub6MXICx7ro_tnDi6U7HR58Zd1xub8hp.6Q2fuykutxV1dMGdBkr27a.4vZPjK2WfNb3LH35BVaMFiJMQ9TRvidtNzoSXw4KcFGC6er_d7fl7Vle6JYDTxYcTZne4pv5iUShBXfbKOsSXRvtGQsfEd9rNt76mCNvpbm9hkBtN30M3H8fx5r3n5hLV7f7vS52M0v4tM3bhBlpNunXo_bmUIVA--
X-Yahoo-Newman-Property: ymail-3
From: Albert Herranz <albert_herranz@yahoo.es>
To: linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Albert Herranz <albert_herranz@yahoo.es>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-ia64@vger.kernel.org
Subject: [RFC PATCH v3 03/11] swiotbl: add back swiotlb_alloc_boot()
Date: Sun,  7 Mar 2010 13:11:44 +0100
Message-Id: <1267963912-984-4-git-send-email-albert_herranz@yahoo.es>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267963912-984-1-git-send-email-albert_herranz@yahoo.es>
References: <1267963912-984-1-git-send-email-albert_herranz@yahoo.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes swiotlb_alloc_boot() available again.

This weak function can be overloaded to modify slightly how the SWIOTLB
and the overflow areas are allocated during boot.

This will be used later to support the Nintendo Wii video game console,
which requires placing the SWIOTLB area above 0x10000000 (MEM2).

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
CC: linuxppc-dev@lists.ozlabs.org
CC: linux-kernel@vger.kernel.org
CC: x86@kernel.org
CC: linux-ia64@vger.kernel.org
---
 include/linux/swiotlb.h |    2 ++
 lib/swiotlb.c           |   10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index febedcf..3954228 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -24,6 +24,8 @@ extern int swiotlb_force;
 
 extern void swiotlb_init(int verbose);
 
+extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
+
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 437eedb..94db5df 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -117,6 +117,11 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
+void * __weak __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+{
+	return alloc_bootmem_low_pages(size);
+}
+
 /* Note that this doesn't work with highmem page */
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 				      volatile void *address)
@@ -158,7 +163,7 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
+	io_tlb_start = swiotlb_alloc_boot(bytes, io_tlb_nslabs);
 	if (!io_tlb_start)
 		panic("Cannot allocate SWIOTLB buffer");
 	io_tlb_end = io_tlb_start + bytes;
@@ -177,7 +182,8 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
+	io_tlb_overflow_buffer = swiotlb_alloc_boot(io_tlb_overflow,
+						    io_tlb_nslabs);
 	if (!io_tlb_overflow_buffer)
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 	if (verbose)
-- 
1.6.3.3

