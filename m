Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbZFXTzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbZFXTzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZFXTz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:55:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZFXTz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:55:26 -0400
Subject: Re: [RFC] x86: gup_fast() batch limit
From: Peter Zijlstra <peterz@infradead.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <4A422E22.6020801@inria.fr>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <1238242929.4039.706.camel@laptop> <1238244374.4039.743.camel@laptop>
	 <200904022219.53949.nickpiggin@yahoo.com.au>  <4A422E22.6020801@inria.fr>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 21:55:29 +0200
Message-Id: <1245873329.1658.79.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 15:46 +0200, Brice Goglin wrote:
> Any news about this patch?

Compile tested on x86_64 and ppc64.

---
Implement the batching mentioned in the gup_fast comment.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/mm/gup.c |   28 +++++++++++++---------------
 arch/x86/mm/gup.c     |   46 ++++++++++++++++++++--------------------------
 2 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/arch/powerpc/mm/gup.c b/arch/powerpc/mm/gup.c
index bc400c7..cf535bf 100644
--- a/arch/powerpc/mm/gup.c
+++ b/arch/powerpc/mm/gup.c
@@ -146,11 +146,13 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 	return 1;
 }
 
+#define CHUNK_SIZE (64 * PAGE_SIZE)
+
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages)
 {
 	struct mm_struct *mm = current->mm;
-	unsigned long addr, len, end;
+	unsigned long addr, len, end, chunk;
 	unsigned long next;
 	pgd_t *pgdp;
 	int nr = 0;
@@ -191,16 +193,9 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	}
 #endif /* CONFIG_HUGETLB_PAGE */
 
-	/*
-	 * XXX: batch / limit 'nr', to avoid large irq off latency
-	 * needs some instrumenting to determine the common sizes used by
-	 * important workloads (eg. DB2), and whether limiting the batch size
-	 * will decrease performance.
-	 *
-	 * It seems like we're in the clear for the moment. Direct-IO is
-	 * the main guy that batches up lots of get_user_pages, and even
-	 * they are limited to 64-at-a-time which is not so many.
-	 */
+again:
+	chunk = min(addr + CHUNK_SIZE, end);
+
 	/*
 	 * This doesn't prevent pagetable teardown, but does prevent
 	 * the pagetables from being freed on powerpc.
@@ -235,10 +230,10 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			VM_BUG_ON(shift != mmu_psize_defs[get_slice_psize(mm, a)].shift);
 			ptep = huge_pte_offset(mm, a);
 			pr_debug(" %016lx: huge ptep %p\n", a, ptep);
-			if (!ptep || !gup_huge_pte(ptep, hstate, &a, end, write, pages,
+			if (!ptep || !gup_huge_pte(ptep, hstate, &a, chunk, write, pages,
 						   &nr))
 				goto slow;
-		} while (a != end);
+		} while (a != chunk);
 	} else
 #endif /* CONFIG_HUGETLB_PAGE */
 	{
@@ -251,15 +246,18 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 #endif
 			pr_debug("  %016lx: normal pgd %p\n", addr,
 				 (void *)pgd_val(pgd));
-			next = pgd_addr_end(addr, end);
+			next = pgd_addr_end(addr, chunk);
 			if (pgd_none(pgd))
 				goto slow;
 			if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
 				goto slow;
-		} while (pgdp++, addr = next, addr != end);
+		} while (pgdp++, addr = next, addr != chunk);
 	}
 	local_irq_enable();
 
+	if (addr != end)
+		goto again;
+
 	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
 	return nr;
 
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 71da1bc..9e0552b 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -219,6 +219,8 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 	return 1;
 }
 
+#define CHUNK_SIZE	(64 * PAGE_SIZE)
+
 /*
  * Like get_user_pages_fast() except its IRQ-safe in that it won't fall
  * back to the regular GUP.
@@ -227,7 +229,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages)
 {
 	struct mm_struct *mm = current->mm;
-	unsigned long addr, len, end;
+	unsigned long addr, len, end, chunk;
 	unsigned long next;
 	unsigned long flags;
 	pgd_t *pgdp;
@@ -241,16 +243,9 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 					(void __user *)start, len)))
 		return 0;
 
-	/*
-	 * XXX: batch / limit 'nr', to avoid large irq off latency
-	 * needs some instrumenting to determine the common sizes used by
-	 * important workloads (eg. DB2), and whether limiting the batch size
-	 * will decrease performance.
-	 *
-	 * It seems like we're in the clear for the moment. Direct-IO is
-	 * the main guy that batches up lots of get_user_pages, and even
-	 * they are limited to 64-at-a-time which is not so many.
-	 */
+again:
+	chunk = min(addr + CHUNK_SIZE, end);
+
 	/*
 	 * This doesn't prevent pagetable teardown, but does prevent
 	 * the pagetables and pages from being freed on x86.
@@ -264,14 +259,17 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	do {
 		pgd_t pgd = *pgdp;
 
-		next = pgd_addr_end(addr, end);
+		next = pgd_addr_end(addr, chunk);
 		if (pgd_none(pgd))
 			break;
 		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
 			break;
-	} while (pgdp++, addr = next, addr != end);
+	} while (pgdp++, addr = next, addr != chunk);
 	local_irq_restore(flags);
 
+	if (addr != end)
+		goto again;
+
 	return nr;
 }
 
@@ -295,7 +293,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages)
 {
 	struct mm_struct *mm = current->mm;
-	unsigned long addr, len, end;
+	unsigned long addr, len, end, chunk;
 	unsigned long next;
 	pgd_t *pgdp;
 	int nr = 0;
@@ -313,16 +311,9 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		goto slow_irqon;
 #endif
 
-	/*
-	 * XXX: batch / limit 'nr', to avoid large irq off latency
-	 * needs some instrumenting to determine the common sizes used by
-	 * important workloads (eg. DB2), and whether limiting the batch size
-	 * will decrease performance.
-	 *
-	 * It seems like we're in the clear for the moment. Direct-IO is
-	 * the main guy that batches up lots of get_user_pages, and even
-	 * they are limited to 64-at-a-time which is not so many.
-	 */
+again:
+	chunk = min(addr + CHUNK_SIZE, end);
+
 	/*
 	 * This doesn't prevent pagetable teardown, but does prevent
 	 * the pagetables and pages from being freed on x86.
@@ -336,14 +327,17 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	do {
 		pgd_t pgd = *pgdp;
 
-		next = pgd_addr_end(addr, end);
+		next = pgd_addr_end(addr, chunk);
 		if (pgd_none(pgd))
 			goto slow;
 		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
 			goto slow;
-	} while (pgdp++, addr = next, addr != end);
+	} while (pgdp++, addr = next, addr != chunk);
 	local_irq_enable();
 
+	if (addr != end)
+		goto again;
+
 	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
 	return nr;
 


