Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYGHIob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYGHIob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYGHIoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:44:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:45439 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYGHIoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gWT9HmH4KyPtPZTEYoytBhsR8U7HMRnIUgWijzdD4OXbULRSDMkpbBBM2b/etz18/2
         MlooKq3TeFvVwRrlfKUBk2T2PpsjKxQatcKh01NtTsXfb0Bo7Pq6FUeqNUpMPrs2L11J
         ZZeAjvSopNs61CCYPj0Ns0iESL9EPd4yJg8Gs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: not overmap than end in init_memory_mapping - 64bit
Date: Tue, 8 Jul 2008 01:43:27 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com>
In-Reply-To: <200807080141.05436.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807080143.27997.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


handle head and tail that can not aligned to big pages.

with this patch, on system that support gbpages
change
last_map_addr: 1080000000 end: 1078000000
to
last_map_addr: 1078000000 end: 1078000000

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/init_64.c |   77 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -422,18 +422,25 @@ phys_pud_update(pgd_t *pgd, unsigned lon
 
 static void __init find_early_table_space(unsigned long end)
 {
-	unsigned long puds, tables, start;
+	unsigned long puds, pmds, ptes, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
-	if (!direct_gbpages) {
-		unsigned long pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-		tables += round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
-	}
-	if (!cpu_has_pse) {
-		unsigned long ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		tables += round_up(ptes * sizeof(pte_t), PAGE_SIZE);
-	}
+	if (direct_gbpages) {
+		unsigned long extra;
+		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
+		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+	} else
+		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+	tables += round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+
+	if (cpu_has_pse) {
+		unsigned long extra;
+		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	} else
+		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	tables += round_up(ptes * sizeof(pte_t), PAGE_SIZE);
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
@@ -634,8 +641,9 @@ static unsigned long __init kernel_physi
 unsigned long __init_refok init_memory_mapping(unsigned long start,
 					       unsigned long end)
 {
-	unsigned long last_map_addr;
+	unsigned long last_map_addr = end;
 	unsigned long page_size_mask = 0;
+	unsigned long start_pfn, end_pfn;
 
 	printk(KERN_INFO "init_memory_mapping\n");
 
@@ -656,8 +664,53 @@ unsigned long __init_refok init_memory_m
 	if (cpu_has_pse)
 		page_size_mask |= 1 << PG_LEVEL_2M;
 
-	last_map_addr = kernel_physical_mapping_init(start, end,
-							 page_size_mask);
+	/* head if not big page aligment ?*/
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = ((start + (PMD_SIZE - 1)) >> PMD_SHIFT)
+			<< (PMD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn)
+		last_map_addr = kernel_physical_mapping_init(
+					start_pfn<<PAGE_SHIFT,
+					end_pfn<<PAGE_SHIFT, 0);
+
+	/* big page (2M) range*/
+	start_pfn = ((start + (PMD_SIZE - 1))>>PMD_SHIFT)
+			 << (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = ((start + (PUD_SIZE - 1))>>PUD_SHIFT)
+			 << (PUD_SHIFT - PAGE_SHIFT);
+	if (end_pfn > ((end>>PUD_SHIFT)<<(PUD_SHIFT - PAGE_SHIFT)))
+		end_pfn = ((end>>PUD_SHIFT)<<(PUD_SHIFT - PAGE_SHIFT));
+	if (start_pfn < end_pfn)
+		last_map_addr = kernel_physical_mapping_init(
+					     start_pfn<<PAGE_SHIFT,
+					     end_pfn<<PAGE_SHIFT,
+					     page_size_mask & (1<<PG_LEVEL_2M));
+
+	/* big page (1G) range */
+	start_pfn = end_pfn;
+	end_pfn = (end>>PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn)
+		last_map_addr = kernel_physical_mapping_init(
+					     start_pfn<<PAGE_SHIFT,
+					     end_pfn<<PAGE_SHIFT,
+					     page_size_mask & ((1<<PG_LEVEL_2M)
+							 | (1<<PG_LEVEL_1G)));
+
+	/* tail is not big page (1G) alignment */
+	start_pfn = end_pfn;
+	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn)
+		last_map_addr = kernel_physical_mapping_init(
+					     start_pfn<<PAGE_SHIFT,
+					     end_pfn<<PAGE_SHIFT,
+					     page_size_mask & (1<<PG_LEVEL_2M));
+	/* tail is not big page (2M) alignment */
+	start_pfn = end_pfn;
+	end_pfn = end>>PAGE_SHIFT;
+	if (start_pfn < end_pfn)
+		last_map_addr = kernel_physical_mapping_init(
+					     start_pfn<<PAGE_SHIFT,
+					     end_pfn<<PAGE_SHIFT, 0);
 
 	if (!after_bootmem)
 		mmu_cr4_features = read_cr4();
