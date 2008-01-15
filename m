Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbYAOLk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbYAOLk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 06:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYAOLkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 06:40:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33912 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYAOLkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 06:40:16 -0500
Date: Tue, 15 Jan 2008 12:39:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: bugreport kernel panic on early stage, with HIGHMEM4G:
Message-ID: <20080115113947.GA14603@elte.hu>
References: <20080107053908.M5584@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107053908.M5584@visp.net.lb>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Denys Fedoryshchenko <denys@visp.net.lb> wrote:

> Hi
> 
> After physical memory upgrade from 3GB to 4GB (also it happens on 5GB) 
> got kernel panic.
> 
> Because it is happening on early stage and my machine doesn't contain 
> serial port, i had to take photo. Kernel boots fine with 64GB highmem, 
> no highmem, or highmem4G with limited memory by mem=3G. All dmesg 
> attached. Also i attach dmidecode and lspci -vvv output, probably it 
> will be useful.

thanks for the detailed report, i think i know what's going on. Could 
you try the patch below, does it fix your problem?

this seems to be a SPARSEMEM bug which is present in v2.6.23 as well and 
has probably been present ever since SPARSEMEM was added to 32-bit x86.

There's a ~256MB hole in your e820 memory map (the pci aperture), which 
causes the last 4 sparsemem sections (each covering 64MB of RAM) to be 
not present - and they are thus missing from the sparsemem mem_map[] 
too. The highmem init code on the other hand assumes that all pages are 
in the mem_map[]:

 static void __init set_highmem_pages_init(int bad_ppro)
 {
        int pfn;
        for (pfn = highstart_pfn; pfn < highend_pfn; pfn++)
                add_one_highpage_init(pfn_to_page(pfn), pfn, bad_ppro);

the pfn_to_page() is unconditional and dereferences to a NULL-ish 
pointer which crashes your box. highend_pfn is what got miscalculated by 
256 MB, so set_highmem_pages_init() tried to reference a non-existing 
struct page - but it should still be robust enough against non-existent 
pages.

The patch below fixes this bug. Please also send a dmesg if you manage 
to boot the box up fine, i've added a few debug printouts to confirm 
this theory. (i'll figure out whether we need to clip highend_pfn as 
well - but this patch alone should be good enough to fix the crash on 
your box.)

	Ingo

------------->
Subject: x86: fix CONFIG_SPARSEMEM highmem init bug
From: Ingo Molnar <mingo@elte.hu>

fix CONFIG_SPARSEMEM highmem init bug.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |   43 ++++++++++++++++++++++++++++++++++++++++---
 mm/sparse.c           |    8 +++++++-
 2 files changed, 47 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -321,11 +321,48 @@ extern void set_highmem_pages_init(int);
 static void __init set_highmem_pages_init(int bad_ppro)
 {
 	int pfn;
-	for (pfn = highstart_pfn; pfn < highend_pfn; pfn++)
-		add_one_highpage_init(pfn_to_page(pfn), pfn, bad_ppro);
+
+	printk("set_highmem_pages_init(bad_ppro:%d)\n", bad_ppro);
+	printk("sizeof(struct page):        %d\n", sizeof(struct page));
+	printk("sizeof(struct mem_section): %d\n", sizeof(struct mem_section));
+	printk("PFN_SECTION_SHIFT:          %d\n", PFN_SECTION_SHIFT);
+
+	printk("mem_map: %p\n", mem_map);
+	printk("  highstart_pfn: %9ld [page: %p]\n",
+		highstart_pfn, pfn_to_page(highstart_pfn));
+	printk("    highend_pfn: %9ld [page: %p]\n",
+		highend_pfn, pfn_to_page(highend_pfn));
+	printk("  highend_pfn-1: %9ld [page: %p]\n",
+		highend_pfn-1, pfn_to_page(highend_pfn-1));
+
+	printk("NR_MEM_SECTIONS: %ld\n", NR_MEM_SECTIONS);
+	printk("pfn_to_section_nr(highstart_pfn): %9ld\n",
+		pfn_to_section_nr(highstart_pfn));
+	printk("pfn_to_section_nr(highend_pfn):   %9ld\n",
+		pfn_to_section_nr(highend_pfn));
+	printk("pfn_to_section_nr(highend_pfn-1): %9ld\n",
+		pfn_to_section_nr(highend_pfn-1));
+
+	printk("totalhigh_pages: %9ld\n", totalhigh_pages);
+	printk(" totalram_pages: %9ld\n", totalram_pages);
+
+	for (pfn = highstart_pfn; pfn < highend_pfn; pfn++) {
+		if (pfn_valid(pfn))
+			add_one_highpage_init(pfn_to_page(pfn), pfn, bad_ppro);
+		else {
+			if (WARN_ON_ONCE(1)) {
+				printk("bad pfn: %d\n", pfn);
+				break;
+			}
+		}
+	}
+	printk("totalhigh_pages: %9ld\n", totalhigh_pages);
+	printk(" totalram_pages: %9ld\n", totalram_pages);
+
+
 	totalram_pages += totalhigh_pages;
 }
-#endif /* CONFIG_FLATMEM */
+#endif /* CONFIG_NUMA */
 
 #else
 #define kmap_init() do { } while (0)
Index: linux/mm/sparse.c
===================================================================
--- linux.orig/mm/sparse.c
+++ linux/mm/sparse.c
@@ -295,9 +295,13 @@ void __init sparse_init(void)
 	struct page *map;
 	unsigned long *usemap;
 
+	printk("sparse_init()\n");
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		if (!present_section_nr(pnum))
+		printk("section %2ld: ", pnum);
+		if (!present_section_nr(pnum)) {
+			printk("!present\n");
 			continue;
+		}
 
 		map = sparse_early_mem_map_alloc(pnum);
 		if (!map)
@@ -309,6 +313,8 @@ void __init sparse_init(void)
 
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
 								usemap);
+		printk("map: %p, usemap: %p [content: %08lx]\n",
+			map, usemap, __nr_to_section(pnum)->section_mem_map);
 	}
 }
 

