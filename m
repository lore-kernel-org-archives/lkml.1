Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbYJ1Bxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbYJ1Bxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYJ1Bxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:53:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:48001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYJ1Bxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:53:40 -0400
Message-ID: <49067058.7010106@kernel.org>
Date: Mon, 27 Oct 2008 18:52:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix init_memory_mapping for [dc000000 - e0000000)
References: <490406FD.30604@kernel.org> <20081027165028.GB30573@linux-os.sc.intel.com> <20081027175547.GE3046@elte.hu>
In-Reply-To: <20081027175547.GE3046@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix range calculation

when gart aperture is 0xdc000000 - 0xe0000000
it returned 0xc0000000 - 0xe0000000

PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ dc000000 size 65536 KB
init_memory_mapping
 00c0000000 - 00e0000000 page 2M
last_map_addr: e0000000 end: e0000000
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture

that is not right.

this patch fix that will get exact mapping

on 256g sytem with that aperture after patch
LBSuse:~ # cat /proc/meminfo
MemTotal:       264742432 kB
MemFree:        263920628 kB
Buffers:            1416 kB
Cached:            24468 kB
...
DirectMap4k:      5760 kB
DirectMap2M:   3205120 kB
DirectMap1G:  265289728 kB

it is consistent to
LBSuse:~ # cat /sys/kernel/debug/kernel_page_tables
..
---[ Low Kernel Mapping ]---
0xffff880000000000-0xffff880000200000           2M     RW             GLB x  pte
0xffff880000200000-0xffff880040000000        1022M     RW         PSE GLB x  pmd
0xffff880040000000-0xffff8800c0000000           2G     RW         PSE GLB NX pud
0xffff8800c0000000-0xffff8800d7e00000         382M     RW         PSE GLB NX pmd
0xffff8800d7e00000-0xffff8800d7fa0000        1664K     RW             GLB NX pte
0xffff8800d7fa0000-0xffff8800d8000000         384K                           pte
0xffff8800d8000000-0xffff8800dc000000          64M                           pmd
0xffff8800dc000000-0xffff8800e0000000          64M     RW         PSE GLB NX pmd
0xffff8800e0000000-0xffff880100000000         512M                           pmd
0xffff880100000000-0xffff880800000000          28G     RW         PSE GLB NX pud
0xffff880800000000-0xffff880824600000         582M     RW         PSE GLB NX pmd
0xffff880824600000-0xffff8808247f0000        1984K     RW             GLB NX pte
0xffff8808247f0000-0xffff880824800000          64K     RW     PCD     GLB NX pte
0xffff880824800000-0xffff880840000000         440M     RW         PSE GLB NX pmd
0xffff880840000000-0xffff884000000000         223G     RW         PSE GLB NX pud
0xffff884000000000-0xffff884028000000         640M     RW         PSE GLB NX pmd
0xffff884028000000-0xffff884040000000         384M                           pmd
0xffff884040000000-0xffff888000000000         255G                           pud
0xffff888000000000-0xffffc20000000000       58880G                           pgd 

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -676,7 +676,7 @@ unsigned long __init_refok init_memory_m
 	int nr_range, i;
 	int use_pse, use_gbpages;
 
-	printk(KERN_INFO "init_memory_mapping\n");
+	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
 	/*
 	 * Find space for the kernel direct mapping tables.
@@ -719,26 +719,30 @@ unsigned long __init_refok init_memory_m
 			 << (PMD_SHIFT - PAGE_SHIFT);
 	end_pfn = ((start + (PUD_SIZE - 1))>>PUD_SHIFT)
 			 << (PUD_SHIFT - PAGE_SHIFT);
-	if (end_pfn > ((end>>PUD_SHIFT)<<(PUD_SHIFT - PAGE_SHIFT)))
-		end_pfn = ((end>>PUD_SHIFT)<<(PUD_SHIFT - PAGE_SHIFT));
+	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
+		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 			page_size_mask & (1<<PG_LEVEL_2M));
 
 	/* big page (1G) range */
-	start_pfn = end_pfn;
+	start_pfn = ((start + (PUD_SIZE - 1))>>PUD_SHIFT)
+			 << (PUD_SHIFT - PAGE_SHIFT);
 	end_pfn = (end>>PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+	if (start_pfn < end_pfn) {
+		/* if no 1g blocks, no 2M blocks on tail*/
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
 				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
 
-	/* tail is not big page (1G) alignment */
-	start_pfn = end_pfn;
-	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-			page_size_mask & (1<<PG_LEVEL_2M));
+		/* tail is not big page (1G) alignment */
+		start_pfn = end_pfn;
+		end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+	}
 
 	/* tail is not big page (2M) alignment */
-	start_pfn = end_pfn;
+	start_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
 	end_pfn = end>>PAGE_SHIFT;
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
