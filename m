Return-Path: <linux-kernel-owner+w=401wt.eu-S1763561AbYEFN52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763561AbYEFN52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYEFN5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:57:19 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43771 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbYEFN5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:57:18 -0400
Date: Tue, 6 May 2008 14:56:21 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
In-Reply-To: <20080506124946.GA2146@elte.hu>
Message-ID: <Pine.LNX.4.64.0805061435510.32567@blonde.site>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com>
 <20080506124946.GA2146@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Ingo Molnar wrote:
> * Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > 
> > I'm seeing this on a Dell 2950 (quad-core) during boot up, but not on
> > my IBM X60s (dual-core). This is using the lastest git 2.6.26-rc1.

You need PAE (HIGHMEM64G), and probably HIGHPTE and >4G, to see it.
It's harmless, but annoying.

> > Just checking to see if this is a known bug before doing the bisect -- 
> > more painful on the 2950 to reboot.

Don't spend any time on bisection: it bothered me too,
and I've meanwhile tracked it down.

> 
> > WARNING: at arch/x86/mm/pgtable_32.c:178 pmd_bad+0xa3/0xe3()
> 
> no, i have not seen this reported yet.

Actually, Gabriel C reported it back in April: not forgotten!

> 
> we have an strace/ptrace fix pending in x86.git - but that should not 
> affect khelper.

No, it comes from your pmd_bad_v1/pmd_bad_v2 debug patch, which
Linus objected to, yet has crept into his tree nonetheless.

I looked back through the mails and logs on that, and disagree
with most of what was done there.  Here's my pending fix below,
but I've not yet tested whether it builds correctly on all relevant
configs, nor whether my pmd_huge does what's intended, nor written
the necessary comments, nor worked out the Cc list - I'm going out
for a short while, all those will follow later, this sent as a
heads up to relieve Jeff from bisecting.

Not-yet-Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 arch/x86/mm/hugetlbpage.c    |    3 +++
 arch/x86/mm/pgtable_32.c     |    7 -------
 include/asm-x86/pgtable_32.h |    9 +--------
 include/asm-x86/pgtable_64.h |    6 ++----
 mm/memory.c                  |    5 ++++-
 5 files changed, 10 insertions(+), 20 deletions(-)

--- 2.6.26-rc1/arch/x86/mm/hugetlbpage.c	2008-04-17 03:49:44.000000000 +0100
+++ linux/arch/x86/mm/hugetlbpage.c	2008-05-06 14:13:24.000000000 +0100
@@ -205,6 +205,9 @@ follow_huge_addr(struct mm_struct *mm, u
 
 int pmd_huge(pmd_t pmd)
 {
+	pmd_t unhuge_pmd = __pmd(pmd_val(pmd) & ~(_PAGE_PSE | _PAGE_NX));
+	if (pmd_bad(unhuge_pmd))
+		return 0;
 	return !!(pmd_val(pmd) & _PAGE_PSE);
 }
 
--- 2.6.26-rc1/arch/x86/mm/pgtable_32.c	2008-05-03 21:54:41.000000000 +0100
+++ linux/arch/x86/mm/pgtable_32.c	2008-05-06 14:13:24.000000000 +0100
@@ -172,10 +172,3 @@ void reserve_top_address(unsigned long r
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
 	__VMALLOC_RESERVE += reserve;
 }
-
-int pmd_bad(pmd_t pmd)
-{
-	WARN_ON_ONCE(pmd_bad_v1(pmd) != pmd_bad_v2(pmd));
-
-	return pmd_bad_v1(pmd);
-}
--- 2.6.26-rc1/include/asm-x86/pgtable_32.h	2008-05-03 21:55:10.000000000 +0100
+++ linux/include/asm-x86/pgtable_32.h	2008-05-06 14:13:24.000000000 +0100
@@ -88,14 +88,7 @@ extern unsigned long pg0[];
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
-
-extern int pmd_bad(pmd_t pmd);
-
-#define pmd_bad_v1(x)							\
-	(_KERNPG_TABLE != (pmd_val((x)) & ~(PAGE_MASK | _PAGE_USER)))
-#define	pmd_bad_v2(x)							\
-	(_KERNPG_TABLE != (pmd_val((x)) & ~(PAGE_MASK | _PAGE_USER |	\
-					    _PAGE_PSE | _PAGE_NX)))
+#define pmd_bad(x) ((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
 
--- 2.6.26-rc1/include/asm-x86/pgtable_64.h	2008-05-03 21:55:10.000000000 +0100
+++ linux/include/asm-x86/pgtable_64.h	2008-05-06 14:13:24.000000000 +0100
@@ -158,14 +158,12 @@ static inline unsigned long pgd_bad(pgd_
 
 static inline unsigned long pud_bad(pud_t pud)
 {
-	return pud_val(pud) &
-		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
+	return pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
 }
 
 static inline unsigned long pmd_bad(pmd_t pmd)
 {
-	return pmd_val(pmd) &
-		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
+	return pmd_val(pmd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
 }
 
 #define pte_none(x)	(!pte_val((x)))
--- 2.6.26-rc1/mm/memory.c	2008-05-03 21:55:12.000000000 +0100
+++ linux/mm/memory.c	2008-05-06 14:13:24.000000000 +0100
@@ -969,7 +969,7 @@ struct page *follow_page(struct vm_area_
 		goto no_page_table;
 	
 	pmd = pmd_offset(pud, address);
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+	if (pmd_none(*pmd))
 		goto no_page_table;
 
 	if (pmd_huge(*pmd)) {
@@ -978,6 +978,9 @@ struct page *follow_page(struct vm_area_
 		goto out;
 	}
 
+	if (unlikely(pmd_bad(*pmd)))
+		goto no_page_table;
+
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!ptep)
 		goto out;
