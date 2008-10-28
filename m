Return-Path: <linux-kernel-owner+w=401wt.eu-S1751201AbYJ1Tkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbYJ1Tkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYJ1Tkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:40:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:43046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbYJ1Tkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:40:35 -0400
Message-ID: <49076A6B.4020904@kernel.org>
Date: Tue, 28 Oct 2008 12:39:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix init_memory_mapping for [dc000000 - e0000000) -
 v2
References: <490406FD.30604@kernel.org> <20081027165028.GB30573@linux-os.sc.intel.com> <20081027175547.GE3046@elte.hu> <49067058.7010106@kernel.org> <20081028092737.GT15734@elte.hu> <20081028093930.GA9699@elte.hu> <20081028094758.GA11958@elte.hu> <4906E048.6060006@kernel.org> <20081028095244.GY15734@elte.hu>
In-Reply-To: <20081028095244.GY15734@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: change over-mapping to precise mapping, fix /proc/meminfo output

v2: fix less 1G ram system handling

when gart aperture is 0xdc000000 - 0xe0000000
it return 0xc0000000 - 0xe0000000

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
 arch/x86/mm/init_64.c |   50 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -671,12 +671,13 @@ unsigned long __init_refok init_memory_m
 	unsigned long last_map_addr = 0;
 	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
+	unsigned long pos;
 
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
 	int use_pse, use_gbpages;
 
-	printk(KERN_INFO "init_memory_mapping\n");
+	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
 	/*
 	 * Find space for the kernel direct mapping tables.
@@ -710,35 +711,50 @@ unsigned long __init_refok init_memory_m
 
 	/* head if not big page alignment ?*/
 	start_pfn = start >> PAGE_SHIFT;
-	end_pfn = ((start + (PMD_SIZE - 1)) >> PMD_SHIFT)
+	pos = start_pfn << PAGE_SHIFT;
+	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
 			<< (PMD_SHIFT - PAGE_SHIFT);
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+		pos = end_pfn << PAGE_SHIFT;
+	}
 
 	/* big page (2M) range*/
-	start_pfn = ((start + (PMD_SIZE - 1))>>PMD_SHIFT)
+	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
 			 << (PMD_SHIFT - PAGE_SHIFT);
-	end_pfn = ((start + (PUD_SIZE - 1))>>PUD_SHIFT)
+	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
 			 << (PUD_SHIFT - PAGE_SHIFT);
-	if (end_pfn > ((end>>PUD_SHIFT)<<(PUD_SHIFT - PAGE_SHIFT)))
-		end_pfn = ((end>>PUD_SHIFT)<<(PUD_SHIFT - PAGE_SHIFT));
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-			page_size_mask & (1<<PG_LEVEL_2M));
+	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
+		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+		pos = end_pfn << PAGE_SHIFT;
+	}
 
 	/* big page (1G) range */
-	start_pfn = end_pfn;
-	end_pfn = (end>>PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
+			 << (PUD_SHIFT - PAGE_SHIFT);
+	end_pfn = (end >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
 				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
+		pos = end_pfn << PAGE_SHIFT;
+	}
 
 	/* tail is not big page (1G) alignment */
-	start_pfn = end_pfn;
-	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-			page_size_mask & (1<<PG_LEVEL_2M));
+	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
+			 << (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = (end >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+		pos = end_pfn << PAGE_SHIFT;
+	}
 
 	/* tail is not big page (2M) alignment */
-	start_pfn = end_pfn;
+	start_pfn = pos>>PAGE_SHIFT;
 	end_pfn = end>>PAGE_SHIFT;
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 

