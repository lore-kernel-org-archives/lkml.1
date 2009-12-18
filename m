Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbZLRQFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbZLRQFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZLRQFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:05:02 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:40067 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZLRQE7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Fri, 18 Dec 2009 11:04:59 -0500
Message-Id: <4B2BB66F0200007800026AD6@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Dec 2009 16:05:51 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: lift restriction on the location of FIX_BTMAP_*
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The early ioremap fixmap entries cover half (or for 32-bit non-PAE, a
quarter) of a page table, yet they got uncondtitionally aligned so far
to a 256-entry boundary. This is not necessary if the range of page
table entries anyway falls into a single page table.

This buys back, for (theoretically) 50% of all configurations (25% of
all non-PAE ones), at least some of the lowmem necessarily lost with
commit e621bd18958ef5dbace3129ebe17a0a475e127d9.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/fixmap.h |   16 +++++++++++-----
 arch/x86/mm/ioremap.c         |    4 ++++
 2 files changed, 15 insertions(+), 5 deletions(-)

--- linux-2.6.33-rc1/arch/x86/include/asm/fixmap.h	2009-12-03 04:51:21.000000000 +0100
+++ 2.6.33-rc1-x86-fix-btmap-reduce/arch/x86/include/asm/fixmap.h	2009-12-10 17:24:58.000000000 +0100
@@ -118,14 +118,20 @@ enum fixed_addresses {
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
 	 *
-	 * We round it up to the next 256 pages boundary so that we
-	 * can have a single pgd entry and a single pte table:
+	 * If necessary we round it up to the next 256 pages boundary so
+	 * that we can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
 #define FIX_BTMAPS_SLOTS	4
-	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
-			(__end_of_permanent_fixed_addresses & 255),
-	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
+#define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
+	FIX_BTMAP_END =
+	 (__end_of_permanent_fixed_addresses ^
+	  (__end_of_permanent_fixed_addresses + TOTAL_FIX_BTMAPS - 1)) &
+	 -PTRS_PER_PTE
+	 ? __end_of_permanent_fixed_addresses + TOTAL_FIX_BTMAPS -
+	   (__end_of_permanent_fixed_addresses & (TOTAL_FIX_BTMAPS - 1))
+	 : __end_of_permanent_fixed_addresses,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
--- linux-2.6.33-rc1/arch/x86/mm/ioremap.c	2009-12-18 16:05:40.000000000 +0100
+++ 2.6.33-rc1-x86-fix-btmap-reduce/arch/x86/mm/ioremap.c	2009-12-10 17:30:57.000000000 +0100
@@ -422,6 +422,10 @@ void __init early_ioremap_init(void)
 	 * The boot-ioremap range spans multiple pmds, for which
 	 * we are not prepared:
 	 */
+#define __FIXADDR_TOP (-PAGE_SIZE)
+	BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
+		     != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));
+#undef __FIXADDR_TOP
 	if (pmd != early_ioremap_pmd(fix_to_virt(FIX_BTMAP_END))) {
 		WARN_ON(1);
 		printk(KERN_WARNING "pmd %p != %p\n",



