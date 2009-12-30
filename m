Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZL3MW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZL3MW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZL3MW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:22:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:42465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbZL3MWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:22:55 -0500
Date: Wed, 30 Dec 2009 12:22:05 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, jbeulich@novell.com,
       akpm@linux-foundation.org, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jbeulich@novell.com,
       torvalds@linux-foundation.org, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B2BB66F0200007800026AD6@vpn.id2.novell.com>
References: <4B2BB66F0200007800026AD6@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Lift restriction on the location of FIX_BTMAP_*
Message-ID: <tip-499a5f1efa0b0ac56ec5d060412aed84ae68e63e@git.kernel.org>
Git-Commit-ID: 499a5f1efa0b0ac56ec5d060412aed84ae68e63e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  499a5f1efa0b0ac56ec5d060412aed84ae68e63e
Gitweb:     http://git.kernel.org/tip/499a5f1efa0b0ac56ec5d060412aed84ae68e63e
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 18 Dec 2009 16:05:51 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 11:57:30 +0100

x86: Lift restriction on the location of FIX_BTMAP_*

The early ioremap fixmap entries cover half (or for 32-bit
non-PAE, a quarter) of a page table, yet they got
uncondtitionally aligned so far to a 256-entry boundary. This is
not necessary if the range of page table entries anyway falls
into a single page table.

This buys back, for (theoretically) 50% of all configurations
(25% of all non-PAE ones), at least some of the lowmem
necessarily lost with commit e621bd18958ef5dbace3129ebe17a0a475e127d9.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4B2BB66F0200007800026AD6@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/fixmap.h |   16 +++++++++++-----
 arch/x86/mm/ioremap.c         |    4 ++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 14f9890..635f03b 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
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
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index c246d25..03c75ff 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
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
