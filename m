Return-Path: <linux-kernel-owner+w=401wt.eu-S934424AbZLPBNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424AbZLPBNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934399AbZLPBNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:13:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:52004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934413AbZLPBNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:13:36 -0500
Message-ID: <4B2833C8.10607@kernel.org>
Date: Tue, 15 Dec 2009 17:11:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/3] x86: make early_node_mem get mem > 4g if possible -v2
References: <4B22D4DA.2000104@kernel.org> <4B22D754.2020706@kernel.org> <4B26EF1B.5090706@kernel.org> <4B26EF49.6010306@kernel.org> <4B26EF84.4020903@kernel.org>
In-Reply-To: <4B26EF84.4020903@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so we could put pgdata for the node high, and later sparse
vmmap will get the section nr that need.

with this patch will make <4g ram will not use sparse vmmap

before this patch, will get, before swiotlb try get bootmem
[    0.000000] nid=1 start=0 end=2080000 aligned=1
[    0.000000]   free [10 - 96]
[    0.000000]   free [b12 - 1000]
[    0.000000]   free [359f - 38a3]
[    0.000000]   free [38b5 - 3a00]
[    0.000000]   free [41e01 - 42000]
[    0.000000]   free [73dde - 73e00]
[    0.000000]   free [73fdd - 74000]
[    0.000000]   free [741dd - 74200]
[    0.000000]   free [743dd - 74400]
[    0.000000]   free [745dd - 74600]
[    0.000000]   free [747dd - 74800]
[    0.000000]   free [749dd - 74a00]
[    0.000000]   free [74bdd - 74c00]
[    0.000000]   free [74ddd - 74e00]
[    0.000000]   free [74fdd - 75000]
[    0.000000]   free [751dd - 75200]
[    0.000000]   free [753dd - 75400]
[    0.000000]   free [755dd - 75600]
[    0.000000]   free [757dd - 75800]
[    0.000000]   free [759dd - 75a00]
[    0.000000]   free [75bdd - 7bf5f]
[    0.000000]   free [7f730 - 7f750]
[    0.000000]   free [100000 - 2080000]
[    0.000000]   total free 1f87170
[   93.301474] Placing 64MB software IO TLB between ffff880075bdd000 - ffff880079bdd000
[   93.311814] software IO TLB at phys 0x75bdd000 - 0x79bdd000

with this patch will get: before swiotlb try get bootmem
[    0.000000] nid=1 start=0 end=2080000 aligned=1
[    0.000000]   free [a - 96]
[    0.000000]   free [702 - 1000]
[    0.000000]   free [359f - 3600]
[    0.000000]   free [37de - 3800]
[    0.000000]   free [39dd - 3a00]
[    0.000000]   free [3bdd - 3c00]
[    0.000000]   free [3ddd - 3e00]
[    0.000000]   free [3fdd - 4000]
[    0.000000]   free [41dd - 4200]
[    0.000000]   free [43dd - 4400]
[    0.000000]   free [45dd - 4600]
[    0.000000]   free [47dd - 4800]
[    0.000000]   free [49dd - 4a00]
[    0.000000]   free [4bdd - 4c00]
[    0.000000]   free [4ddd - 4e00]
[    0.000000]   free [4fdd - 5000]
[    0.000000]   free [51dd - 5200]
[    0.000000]   free [53dd - 5400]
[    0.000000]   free [55dd - 7bf5f]
[    0.000000]   free [7f730 - 7f750]
[    0.000000]   free [100428 - 100600]
[    0.000000]   free [13ea01 - 13ec00]
[    0.000000]   free [170800 - 2080000]
[    0.000000]   total free 1f87170

[   92.689485] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   92.699799] Placing 64MB software IO TLB between ffff8800055dd000 - ffff8800095dd000
[   92.710916] software IO TLB at phys 0x55dd000 - 0x95dd000

so will get enough space below 4G, aka pfn 0x100000

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa_64.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -163,14 +163,27 @@ static void * __init early_node_mem(int
 				    unsigned long end, unsigned long size,
 				    unsigned long align)
 {
-	unsigned long mem = find_e820_area(start, end, size, align);
+	unsigned long mem;
 
+	/*
+	 * put it on high as possible
+	 * something will go with NODE_DATA
+	 */
+	if (start < (MAX_DMA_PFN<<PAGE_SHIFT))
+		start = MAX_DMA_PFN<<PAGE_SHIFT;
+	if (start < (MAX_DMA32_PFN<<PAGE_SHIFT) &&
+	    end > (MAX_DMA32_PFN<<PAGE_SHIFT))
+		start = MAX_DMA32_PFN<<PAGE_SHIFT;
+	mem = find_e820_area(start, end, size, align);
 	if (mem != -1L)
 		return __va(mem);
 
 
-	start = __pa(MAX_DMA_ADDRESS);
-	end = max_low_pfn_mapped << PAGE_SHIFT;
+	end = max_pfn_mapped << PAGE_SHIFT;
+	if (end > (MAX_DMA32_PFN<<PAGE_SHIFT))
+		start = MAX_DMA32_PFN<<PAGE_SHIFT;
+	else
+		start = MAX_DMA_PFN<<PAGE_SHIFT;
 	mem = find_e820_area(start, end, size, align);
 	if (mem != -1L)
 		return __va(mem);
