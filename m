Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbZLONFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbZLONFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbZLONFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:05:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:37357 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbZLONF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:05:29 -0500
Message-ID: <4B27894B.9090705@kernel.org>
Date: Tue, 15 Dec 2009 05:04:11 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: mingo@elte.hu
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: bisected crash due to "x86: Move swiotlb initialization before
 dma32_free_bootmem"
References: <4B2752A9.10903@kernel.org>	<20091215182243R.fujita.tomonori@lab.ntt.co.jp>	<20091215105650.GA13214@elte.hu> <20091215201039V.fujita.tomonori@lab.ntt.co.jp> <4B277235.4010308@kernel.org>
In-Reply-To: <4B277235.4010308@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> FUJITA Tomonori wrote:
>> I simply wanted to say that it's not a bug that breaks lots of boxes
>> or leads to something serious like data corruption (no need to say
>> something like "revert it now!"). It's also worth investigating why it
>> breaks, I think.
> 
> will look at it later

ok, have the solutions for that.

Ingo,

this patch depends on 4 early_res related patches i sent before.

YH

[PATCH] x86: make early_node_mem get mem > 4g if possible

so we could put pgdata for the node high, and later sparse
vmmap will get the section nr that need.

with this patch will make <4g ram will not use sparse vmmap

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

