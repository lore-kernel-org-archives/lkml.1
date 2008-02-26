Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbYBZUeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbYBZUeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762603AbYBZUeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:34:15 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:5057 "EHLO
	outbound4-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761515AbYBZUeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:34:13 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JWV4QG-02-DKJ-01
Date: Tue, 26 Feb 2008 21:25:33 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Adam Litke <aglitke@gmail.com>, nacc <nacc@linux.vnet.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and return page size
Message-ID: <20080226202533.GD5963@escobedo.amd.com>
References: <20080220135743.GA10127@escobedo.amd.com> <1203733096.14838.154.camel@cinder.waste.org> <1203791461.11305.135.camel@nimitz.home.sr71.net> <20080225120951.GA5963@escobedo.amd.com> <1203964750.28196.7.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203964750.28196.7.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 26 Feb 2008 20:24:40.0967 (UTC) FILETIME=[9DAA8170:01C878B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 10:39:10AM -0800, Dave Hansen wrote:
> Did you read my suggestion?  We use one bit in the pte to specify that
> its a large page mapping, then specify a mask to apply to the address to
> get the *first* mapping of the large page, where you're find the actual
> physical address.  That keeps us from having to worry about specifying
> *both* the page size and the pfn in the same pte.

I did read it, but I don't see the point. I think we have enough bits in
that pseudo pte to include both the page size and the address/pfn.

> I'm just asking that you please put this in a nice helper function to
> hide it from the poor powerpc/ia64/mips... guys that don't want to see
> x86 code cluttering up otherwise generic functions.  Yes, the compiler
> optimizes it away, but it still has a cost to my eyeballs. :)
> 
> I eagerly await your next patch!

Ok, here it comes. What I changed is:
- added x86-specific inline function pmd_to_ppte() to asm-x86/pgtable.h
  and a dummy definition to asm-generic/pgtable.h
- added a function add_huge_to_pagemap to fs/proc/task_mmu.c that is
  completely independent of the huge page size
- use pshift instead of psize in pseudo pte, had to shorten paddr field
  to 56 bits which is probably still enough for quite some time
- renamed the struct ppte to struct pagemap_ppte, making more clear what
  it is actually used for. Since I weren't sure where to put it, I put
  the definition in a new header linux/pagemap_ppte.h. I guess that it
  will be put somewhere else, linux/pagemap.h or asm-generic/pgtable.h
  are what I had in mind. Using one of those created more problems that
  I didn't want to look at.



Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>

---
 fs/proc/task_mmu.c            |   54 +++++++++++++++++++++++++---------------
 include/asm-generic/pgtable.h |    6 ++++
 include/asm-x86/pgtable.h     |   16 ++++++++++++
 include/asm-x86/pgtable_64.h  |    1 -
 include/linux/pagemap_ppte.h  |   17 +++++++++++++
 5 files changed, 73 insertions(+), 21 deletions(-)
 create mode 100644 include/linux/pagemap_ppte.h

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 49958cf..b3f07f6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -527,16 +527,11 @@ struct pagemapread {
 	char __user *out, *end;
 };
 
-#define PM_ENTRY_BYTES sizeof(u64)
-#define PM_RESERVED_BITS    3
-#define PM_RESERVED_OFFSET  (64 - PM_RESERVED_BITS)
-#define PM_RESERVED_MASK    (((1LL<<PM_RESERVED_BITS)-1) << PM_RESERVED_OFFSET)
-#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) | PM_RESERVED_MASK)
-#define PM_NOT_PRESENT      PM_SPECIAL(1LL)
-#define PM_SWAP             PM_SPECIAL(2LL)
-#define PM_END_OF_BUFFER    1
-
-static int add_to_pagemap(unsigned long addr, u64 pfn,
+#define PM_NOT_PRESENT   ((struct pagemap_ppte) {0, 0, 0, 0})
+#define PM_ENTRY_BYTES   sizeof(struct pagemap_ppte)
+#define PM_END_OF_BUFFER 1
+
+static int add_to_pagemap(unsigned long addr, struct pagemap_ppte ppte,
 			  struct pagemapread *pm)
 {
 	/*
@@ -545,18 +540,30 @@ static int add_to_pagemap(unsigned long addr, u64 pfn,
 	 * the pfn.
 	 */
 	if (pm->out + PM_ENTRY_BYTES >= pm->end) {
-		if (copy_to_user(pm->out, &pfn, pm->end - pm->out))
+		if (copy_to_user(pm->out, &ppte, pm->end - pm->out))
 			return -EFAULT;
 		pm->out = pm->end;
 		return PM_END_OF_BUFFER;
 	}
 
-	if (put_user(pfn, pm->out))
+	if (copy_to_user(pm->out, &ppte, sizeof(ppte)))
 		return -EFAULT;
 	pm->out += PM_ENTRY_BYTES;
 	return 0;
 }
 
+static int add_huge_to_pagemap(unsigned long addr, unsigned long end,
+			       struct pagemap_ppte ppte, struct pagemapread *pm)
+{
+	int err;
+
+	for (; addr != end; addr += PAGE_SIZE) {
+		err = add_to_pagemap(addr, ppte, pm);
+		if (err)
+			return err;
+	}
+}
+	
 static int pagemap_pte_hole(unsigned long start, unsigned long end,
 				void *private)
 {
@@ -574,7 +581,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
 u64 swap_pte_to_pagemap_entry(pte_t pte)
 {
 	swp_entry_t e = pte_to_swp_entry(pte);
-	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
+	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
 }
 
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
@@ -584,16 +591,23 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t *pte;
 	int err = 0;
 
-	for (; addr != end; addr += PAGE_SIZE) {
-		u64 pfn = PM_NOT_PRESENT;
+	if (pmd_huge(*pmd))
+		add_huge_to_pagemap(addr, end, pmd_to_ppte(pmd), pm);
+	else	for (; addr != end; addr += PAGE_SIZE) {
+		struct pagemap_ppte ppte = { 0, 0, 0, 0};
+
 		pte = pte_offset_map(pmd, addr);
-		if (is_swap_pte(*pte))
-			pfn = swap_pte_to_pagemap_entry(*pte);
-		else if (pte_present(*pte))
-			pfn = pte_pfn(*pte);
+		if (is_swap_pte(*pte)) {
+			ppte.swap = 1;
+			ppte.paddr = swap_pte_to_pagemap_entry(*pte);
+		} else if (pte_present(*pte)) {
+			ppte.present = 1;
+			ppte.pshift = PAGE_SHIFT;
+			ppte.paddr = pte_pfn(*pte) << PAGE_SHIFT;
+		}
 		/* unmap so we're not in atomic when we copy to userspace */
 		pte_unmap(pte);
-		err = add_to_pagemap(addr, pfn, pm);
+		err = add_to_pagemap(addr, ppte, pm);
 		if (err)
 			return err;
 	}
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 44ef329..d7df89d 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -195,6 +195,12 @@ static inline int pmd_none_or_clear_bad(pmd_t *pmd)
 	}
 	return 0;
 }
+
+/* dummy for !x86 */
+#ifndef pmd_to_ppte
+#define pmd_to_ppte(x) ((struct pagemap_ppte) {0, 0, 0, 0})
+#endif
+ 
 #endif /* CONFIG_MMU */
 
 /*
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 174b877..7a446e0 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -181,6 +181,8 @@ static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 		      pgprot_val(pgprot)) & __supported_pte_mask);
 }
 
+#define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
+
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	pteval_t val = pte_val(pte);
@@ -242,6 +244,20 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 
 #ifndef __ASSEMBLY__
 
+#include <linux/pagemap_ppte.h>
+
+static inline struct pagemap_ppte pmd_to_ppte(pmd_t *pmd)
+{
+	struct pagemap_ppte ppte = {
+		.paddr   = pmd_pfn(*pmd) << PAGE_SHIFT,
+		.pshift  = HPAGE_SHIFT,
+		.swap    = 0,
+		.present = 1,
+	};
+
+	return ppte;
+}
+
 enum {
 	PG_LEVEL_NONE,
 	PG_LEVEL_4K,
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 02bd4aa..094a538 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -216,7 +216,6 @@ static inline int pud_large(pud_t pte)
 #define pmd_none(x)	(!pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
 #define pfn_pmd(nr,prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val(prot)))
-#define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 
 #define pte_to_pgoff(pte) ((pte_val(pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
 #define pgoff_to_pte(off) ((pte_t) { .pte = ((off) << PAGE_SHIFT) | _PAGE_FILE })
diff --git a/include/linux/pagemap_ppte.h b/include/linux/pagemap_ppte.h
new file mode 100644
index 0000000..4d1256f
--- /dev/null
+++ b/include/linux/pagemap_ppte.h
@@ -0,0 +1,17 @@
+#ifndef _LINUX_PAGEMAP_PPTE_H
+#define _LINUX_PAGEMAP_PPTE_H
+
+#include <linux/types.h>
+
+/*
+ * structure used by /proc/pid/pagemap to describe mappings
+ */
+
+struct pagemap_ppte {
+	__u64 paddr:56;
+	__u64 pshift:6;
+	__u64 swap:1;
+	__u64 present:1;
+};
+
+#endif /* _LINUX_PAGEMAP_PPTE_H */
-- 
1.5.3.7

