Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYJZGAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYJZGAB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 02:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYJZF7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 01:59:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:51599 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbYJZF7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 01:59:51 -0400
Message-ID: <490406FD.30604@kernel.org>
Date: Sat, 25 Oct 2008 22:58:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: keep the page count correct
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


impact: get correct page count for 2M and 1G...

found page count in /proc/meminfo is nor correct on 1G system in VirtualBox 2.0.4

# cat /proc/meminfo
MemTotal:        1017508 kB
MemFree:          822700 kB
Buffers:            1456 kB
Cached:            26632 kB
SwapCached:            0 kB
...
Hugepagesize:       2048 kB
DirectMap4k:      4032 kB
DirectMap2M:  18446744073709549568 kB

with this patch get:
...
DirectMap4k:      4032 kB
DirectMap2M:   1044480 kB

which is consistent to kernel_page_tables
---[ Low Kernel Mapping ]---
0xffff880000000000-0xffff880000001000           4K     RW     PCD     GLB x  pte
0xffff880000001000-0xffff88000009f000         632K     RW             GLB x  pte
0xffff88000009f000-0xffff8800000a0000           4K     RW     PCD     GLB x  pte
0xffff8800000a0000-0xffff880000200000        1408K     RW             GLB x  pte
0xffff880000200000-0xffff88003fe00000        1020M     RW         PSE GLB x  pmd
0xffff88003fe00000-0xffff88003fff0000        1984K     RW             GLB NX pte
0xffff88003fff0000-0xffff880040000000          64K                           pte
0xffff880040000000-0xffff888000000000         511G                           pud
0xffff888000000000-0xffffc20000000000       58880G                           pgd

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7df1209..701675a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -350,8 +350,10 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 		 * pagetable pages as RO. So assume someone who pre-setup
 		 * these mappings are more intelligent.
 		 */
-		if (pte_val(*pte))
+		if (pte_val(*pte)) {
+			pages++;
 			continue;
+		}
 
 		if (0)
 			printk("   pte=%p addr=%lx pte=%016lx\n",
@@ -418,8 +420,10 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			 * not differ with respect to page frame and
 			 * attributes.
 			 */
-			if (page_size_mask & (1 << PG_LEVEL_2M))
+			if (page_size_mask & (1 << PG_LEVEL_2M)) {
+				pages++;
 				continue;
+			}
 			new_prot = pte_pgprot(pte_clrhuge(*(pte_t *)pmd));
 		}
 
@@ -499,8 +503,10 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 * not differ with respect to page frame and
 			 * attributes.
 			 */
-			if (page_size_mask & (1 << PG_LEVEL_1G))
+			if (page_size_mask & (1 << PG_LEVEL_1G)) {
+				pages++;
 				continue;
+			}
 			prot = pte_pgprot(pte_clrhuge(*(pte_t *)pud));
 		}
 
