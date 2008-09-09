Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYIIPnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYIIPnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYIIPnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:43:02 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60133 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYIIPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:43:00 -0400
Date: Tue, 9 Sep 2008 16:42:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip] x86: unsigned long pte_pfn
In-Reply-To: <48C589D2.5030905@goop.org>
Message-ID: <Pine.LNX.4.64.0809091612410.19349@blonde.site>
References: <Pine.LNX.4.64.0809082100090.30216@blonde.site> <48C589D2.5030905@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Jeremy Fitzhardinge wrote:
> Hugh Dickins wrote:
> > Copy the inline function used by 32-bit's pgtable-3level.h.
> 
> That looks OK, but rather than copying it, why not move the definition
> into pgtable.h?  Isn't it identical for all pagetable modes?

That's a much better idea, thanks.  Though it wasn't *quite* the same
in the 32-bit 2-level case, because that mode didn't need any mask at
all, the right shift was sufficient.

I expected gcc to optimize away that difference, and often it does,
but not always (I'm using 4.2.1 and CC_OPTIMIZE_FOR_SIZE here):
pte_page() involved
 228:	c1 e8 0c             	shr    $0xc,%eax
 22b:	c1 e0 05             	shl    $0x5,%eax
before the unification, but afterwards
 228:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 22d:	c1 e8 07             	shr    $0x7,%eax

So it's bloated that kernel by 0.001% (around 40 bytes).  Oh well,
I think we may suppose that with a different version of gcc or
different optimizations, it could just as well have gone the
other way - I vote to go with your unification.


[PATCH tip] x86: unsigned long pte_pfn

pte_pfn() has always been of type unsigned long, even on 32-bit PAE;
but in the current tip/next/mm tree it works out to be unsigned long
long on 64-bit, which gives an irritating warning if you try to printk
a pfn with the usual %lx.

Now use the same pte_pfn() function, moved from pgtable-3level.h
to pgtable.h, for all models: as suggested by Jeremy Fitzhardinge.
And pte_page() can well move along with it (remaining a macro to
avoid dependence on mm_types.h).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/asm-x86/pgtable-2level.h |    2 --
 include/asm-x86/pgtable-3level.h |    7 -------
 include/asm-x86/pgtable.h        |    7 +++++++
 include/asm-x86/pgtable_64.h     |    2 --
 4 files changed, 7 insertions(+), 11 deletions(-)

--- 2.6.27-rc5-mm1/include/asm-x86/pgtable-2level.h	2008-09-05 10:05:51.000000000 +0100
+++ linux/include/asm-x86/pgtable-2level.h	2008-09-09 13:53:34.000000000 +0100
@@ -53,9 +53,7 @@ static inline pte_t native_ptep_get_and_
 #define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
 #endif
 
-#define pte_page(x)		pfn_to_page(pte_pfn(x))
 #define pte_none(x)		(!(x).pte_low)
-#define pte_pfn(x)		(pte_val(x) >> PAGE_SHIFT)
 
 /*
  * Bits 0, 6 and 7 are taken, split up the 29 bits of offset
--- 2.6.27-rc5-mm1/include/asm-x86/pgtable-3level.h	2008-09-05 10:05:51.000000000 +0100
+++ linux/include/asm-x86/pgtable-3level.h	2008-09-09 13:53:34.000000000 +0100
@@ -151,18 +151,11 @@ static inline int pte_same(pte_t a, pte_
 	return a.pte_low == b.pte_low && a.pte_high == b.pte_high;
 }
 
-#define pte_page(x)	pfn_to_page(pte_pfn(x))
-
 static inline int pte_none(pte_t pte)
 {
 	return !pte.pte_low && !pte.pte_high;
 }
 
-static inline unsigned long pte_pfn(pte_t pte)
-{
-	return (pte_val(pte) & PTE_PFN_MASK) >> PAGE_SHIFT;
-}
-
 /*
  * Bits 0, 6 and 7 are taken in the low part of the pte,
  * put the 32 bits of offset into the high part.
--- 2.6.27-rc5-mm1/include/asm-x86/pgtable.h	2008-09-05 10:05:51.000000000 +0100
+++ linux/include/asm-x86/pgtable.h	2008-09-09 13:53:34.000000000 +0100
@@ -186,6 +186,13 @@ static inline int pte_special(pte_t pte)
 	return pte_val(pte) & _PAGE_SPECIAL;
 }
 
+static inline unsigned long pte_pfn(pte_t pte)
+{
+	return (pte_val(pte) & PTE_PFN_MASK) >> PAGE_SHIFT;
+}
+
+#define pte_page(pte)	pfn_to_page(pte_pfn(pte))
+
 static inline int pmd_large(pmd_t pte)
 {
 	return (pmd_val(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
--- 2.6.27-rc5-mm1/include/asm-x86/pgtable_64.h	2008-09-05 10:05:51.000000000 +0100
+++ linux/include/asm-x86/pgtable_64.h	2008-09-09 13:53:34.000000000 +0100
@@ -181,8 +181,6 @@ static inline int pmd_bad(pmd_t pmd)
 #endif
 
 #define pages_to_mb(x)	((x) >> (20 - PAGE_SHIFT))   /* FIXME: is this right? */
-#define pte_page(x)	pfn_to_page(pte_pfn((x)))
-#define pte_pfn(x)	((pte_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 
 /*
  * Macro to mark a page protection value as "uncacheable".
