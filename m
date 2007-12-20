Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbXLTLoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbXLTLoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757653AbXLTLoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:44:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40612 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757620AbXLTLoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:44:10 -0500
Date: Thu, 20 Dec 2007 11:44:06 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-kernel@vger.kernel.org, Bob Picco <bob.picco@hp.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Andi Kleen <ak@muc.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Keith Mannthey <kmannth@gmail.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@osdl.org>, ralf@linux-mips.org
Subject: Re: [PATCH] Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
Message-ID: <20071220114405.GA9623@csn.ul.ie>
References: <20071218120300.7565AE3030@solo.franken.de> <20071218135828.GB24917@csn.ul.ie> <20071218160938.GA20688@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071218160938.GA20688@alpha.franken.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/12/07 17:09), Thomas Bogendoerfer didst pronounce:
> On Tue, Dec 18, 2007 at 01:58:28PM +0000, Mel Gorman wrote:
> > That commit is over a year old and it initially distressed me that it
> > would take this long to show up on a boot test. However, you said this was
> > to fix MIPS in a follow-on mail and I never made it use arch-independent
> > zone-sizing which is where CONFIG_ARCH_POPULATES_NODE_MAP comes from. Support
> > for arch-independent zone-sizing was added for MIPS on Nov 3rd 2007 by commit
> > cce335ae47e231398269fb05fa48e0e9cbf289e0 (relevant cc added) which is a much
> > more reasonable timeframe for catching this sort of problem. I believe the
> > real bug might be in there.
> 
> either that or it got uncovered.

You're right, the arches using POPULATES_NODE_MAP would have had
ARCH_PFN_OFFSET at 0. Your patch corrects that and should not affect
other arches so;

Acked-by: Mel Gorman <mel@csn.ul.ie>

Thanks for fixing.

While looking at this, it occured to me that maybe you could avoid a
subtraction at runtime for MIPS using page_to_pfn() on FLATMEM by getting rid
of ARCH_PFN_OFFSET. It's probably only of miniscule benefit but something
like this (totally untested) patch may work if you want to try it out. It
should have fixed your problem too but would it would have been achieved by
hiding the problem. I believe your patch is still correct.

====

Get rid of ARCH_PFN_OFFSET calculation in MIPS with FLATMEM memory
model.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 

 arch/mips/kernel/setup.c |   13 +++++++------
 include/asm-mips/page.h  |    9 +--------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 7f6ddcb..9199314 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -273,6 +273,7 @@ static void __init bootmem_init(void)
 	unsigned long mapstart = ~0UL;
 	unsigned long bootmap_size;
 	int i;
+	unsigned long phys_pfn_offset = PFN_UP(PHYS_OFFSET);
 
 	/*
 	 * Init any data related to initrd. It's a nop if INITRD is
@@ -314,17 +315,17 @@ static void __init bootmem_init(void)
 
 	if (min_low_pfn >= max_low_pfn)
 		panic("Incorrect memory mapping !!!");
-	if (min_low_pfn > ARCH_PFN_OFFSET) {
+	if (min_low_pfn > phys_pfn_offset) {
 		printk(KERN_INFO
 		       "Wasting %lu bytes for tracking %lu unused pages\n",
-		       (min_low_pfn - ARCH_PFN_OFFSET) * sizeof(struct page),
-		       min_low_pfn - ARCH_PFN_OFFSET);
-	} else if (min_low_pfn < ARCH_PFN_OFFSET) {
+		       (min_low_pfn - phys_pfn_offset) * sizeof(struct page),
+		       min_low_pfn - phys_pfn_offset);
+	} else if (min_low_pfn < phys_pfn_offset) {
 		printk(KERN_INFO
 		       "%lu free pages won't be used\n",
-		       ARCH_PFN_OFFSET - min_low_pfn);
+		       phys_pfn_offset - min_low_pfn);
 	}
-	min_low_pfn = ARCH_PFN_OFFSET;
+	min_low_pfn = phys_pfn_offset;
 
 	/*
 	 * Determine low and high memory ranges
diff --git a/include/asm-mips/page.h b/include/asm-mips/page.h
index d2ea983..3e57755 100644
--- a/include/asm-mips/page.h
+++ b/include/asm-mips/page.h
@@ -37,13 +37,6 @@
 #include <linux/pfn.h>
 #include <asm/io.h>
 
-/*
- * It's normally defined only for FLATMEM config but it's
- * used in our early mem init code for all memory models.
- * So always define it.
- */
-#define ARCH_PFN_OFFSET		PFN_UP(PHYS_OFFSET)
-
 extern void clear_page(void * page);
 extern void copy_page(void * to, void * from);
 
@@ -159,7 +152,7 @@ typedef struct { unsigned long pgprot; } pgprot_t;
 
 #ifdef CONFIG_FLATMEM
 
-#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && (pfn) < max_mapnr)
+#define pfn_valid(pfn)		((pfn) >= PFN_UP(PHYS_OFFSET) && (pfn) < max_mapnr)
 
 #elif defined(CONFIG_SPARSEMEM)
 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
