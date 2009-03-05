Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZCENh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZCENh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZCENhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:37:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:49870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbZCENhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:37:18 -0500
Date: Thu, 5 Mar 2009 13:36:49 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-3-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-3-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: find_early_table_space() unification
Message-ID: <tip-49a2bf7303b0dc5fccbb3ff7cf2e7751f0e3953d@git.kernel.org>
Git-Commit-ID: 49a2bf7303b0dc5fccbb3ff7cf2e7751f0e3953d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:36:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49a2bf7303b0dc5fccbb3ff7cf2e7751f0e3953d
Gitweb:     http://git.kernel.org/tip/49a2bf7303b0dc5fccbb3ff7cf2e7751f0e3953d
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:54:54 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:11 +0100

x86: find_early_table_space() unification

Impact: cleanup

There are some minor differences between the 32-bit and 64-bit
find_early_table_space() functions. This patch wraps those
differences under CONFIG_X86_32 to make the function identical
on both configurations.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-3-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |    9 +++++++++
 arch/x86/mm/init_64.c |   14 ++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5fad0f9..86a9994 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -855,24 +855,33 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 		unsigned long extra;
 
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+#ifdef CONFIG_X86_32
 		extra += PMD_SIZE;
+#endif
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
+#ifdef CONFIG_X86_32
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+#endif
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
 	 * cause a hotspot and fill up ZONE_DMA. The page tables
 	 * need roughly 0.5KB per GB.
 	 */
+#ifdef CONFIG_X86_32
 	start = 0x7000;
 	table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
 					tables, PAGE_SIZE);
+#else /* CONFIG_X86_64 */
+	start = 0x8000;
+	table_start = find_e820_area(start, end, tables, PAGE_SIZE);
+#endif
 	if (table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index cdb3be1..151e5ba 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -569,19 +569,33 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 		unsigned long extra;
 
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+#ifdef CONFIG_X86_32
+		extra += PMD_SIZE;
+#endif
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
+#ifdef CONFIG_X86_32
+	/* for fixmap */
+	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+#endif
+
 	/*
 	 * RED-PEN putting page tables only on node 0 could
 	 * cause a hotspot and fill up ZONE_DMA. The page tables
 	 * need roughly 0.5KB per GB.
 	 */
+#ifdef CONFIG_X86_32
+	start = 0x7000;
+	table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
+					tables, PAGE_SIZE);
+#else /* CONFIG_X86_64 */
 	start = 0x8000;
 	table_start = find_e820_area(start, end, tables, PAGE_SIZE);
+#endif
 	if (table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
