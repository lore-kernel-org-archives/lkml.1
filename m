Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbZAVXan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbZAVXan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZAVXad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:30:33 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:56703 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213AbZAVXac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:30:32 -0500
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
From: Zachary Amsden <zach@vmware.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
In-Reply-To: <20090122230423.GA19569@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de>
	 <20090120112634.GA20858@elte.hu> <4978F2A4.8010807@goop.org>
	 <20090122230423.GA19569@elte.hu>
Content-Type: multipart/mixed; boundary="=-80i4iXIu0IW0iJvj/uMB"
Date: Thu, 22 Jan 2009 15:30:49 -0800
Message-Id: <1232667049.16317.193.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-80i4iXIu0IW0iJvj/uMB
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2009-01-22 at 15:04 -0800, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> In any case, it is rather inefficient of me proxy-testing your patches, 
> you can do these measurements yourself too on any Core2 or later Intel 
> CPU, by running tip/master plus picking up these two utilities:

Eek, I have no time to spend on this right now, but if anyone is curious
to run this patch (which heavily breaks Xen), I suspect it will cure
most of the performance ailments.

Back when we did the VMI prototyping, we never saw any significant
benchmark reductions until the introduction of the M-to-P conversion
functions.

Zach

--=-80i4iXIu0IW0iJvj/uMB
Content-Disposition: attachment; filename=paravirt-drop-mpn-ops.patch
Content-Type: text/x-patch; name=paravirt-drop-mpn-ops.patch; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index e9873a2..e5b39db 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -155,10 +155,6 @@ static inline pteval_t native_pte_flags(pte_t pte)
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else  /* !CONFIG_PARAVIRT */
-
 #define pgd_val(x)	native_pgd_val(x)
 #define __pgd(x)	native_make_pgd(x)
 
@@ -176,6 +172,8 @@ static inline pteval_t native_pte_flags(pte_t pte)
 #define pte_flags(x)	native_pte_flags(x)
 #define __pte(x)	native_make_pte(x)
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
 #endif	/* CONFIG_PARAVIRT */
 
 #define __pa(x)		__phys_addr((unsigned long)(x))
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index ba3e2ff..7de3169 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -278,13 +278,6 @@ struct pv_mmu_ops {
 	void (*ptep_modify_prot_commit)(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, pte_t pte);
 
-	pteval_t (*pte_val)(pte_t);
-	pteval_t (*pte_flags)(pte_t);
-	pte_t (*make_pte)(pteval_t pte);
-
-	pgdval_t (*pgd_val)(pgd_t);
-	pgd_t (*make_pgd)(pgdval_t pgd);
-
 #if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
@@ -298,13 +291,7 @@ struct pv_mmu_ops {
 
 	void (*set_pud)(pud_t *pudp, pud_t pudval);
 
-	pmdval_t (*pmd_val)(pmd_t);
-	pmd_t (*make_pmd)(pmdval_t pmd);
-
 #if PAGETABLE_LEVELS == 4
-	pudval_t (*pud_val)(pud_t);
-	pud_t (*make_pud)(pudval_t pud);
-
 	void (*set_pgd)(pgd_t *pudp, pgd_t pgdval);
 #endif	/* PAGETABLE_LEVELS == 4 */
 #endif	/* PAGETABLE_LEVELS >= 3 */
@@ -1054,81 +1041,6 @@ static inline void pte_update_defer(struct mm_struct *mm, unsigned long addr,
 	PVOP_VCALL3(pv_mmu_ops.pte_update_defer, mm, addr, ptep);
 }
 
-static inline pte_t __pte(pteval_t val)
-{
-	pteval_t ret;
-
-	if (sizeof(pteval_t) > sizeof(long))
-		ret = PVOP_CALL2(pteval_t,
-				 pv_mmu_ops.make_pte,
-				 val, (u64)val >> 32);
-	else
-		ret = PVOP_CALL1(pteval_t,
-				 pv_mmu_ops.make_pte,
-				 val);
-
-	return (pte_t) { .pte = ret };
-}
-
-static inline pteval_t pte_val(pte_t pte)
-{
-	pteval_t ret;
-
-	if (sizeof(pteval_t) > sizeof(long))
-		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.pte_val,
-				 pte.pte, (u64)pte.pte >> 32);
-	else
-		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.pte_val,
-				 pte.pte);
-
-	return ret;
-}
-
-static inline pteval_t pte_flags(pte_t pte)
-{
-	pteval_t ret;
-
-	if (sizeof(pteval_t) > sizeof(long))
-		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.pte_flags,
-				 pte.pte, (u64)pte.pte >> 32);
-	else
-		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.pte_flags,
-				 pte.pte);
-
-#ifdef CONFIG_PARAVIRT_DEBUG
-	BUG_ON(ret & PTE_PFN_MASK);
-#endif
-	return ret;
-}
-
-static inline pgd_t __pgd(pgdval_t val)
-{
-	pgdval_t ret;
-
-	if (sizeof(pgdval_t) > sizeof(long))
-		ret = PVOP_CALL2(pgdval_t, pv_mmu_ops.make_pgd,
-				 val, (u64)val >> 32);
-	else
-		ret = PVOP_CALL1(pgdval_t, pv_mmu_ops.make_pgd,
-				 val);
-
-	return (pgd_t) { ret };
-}
-
-static inline pgdval_t pgd_val(pgd_t pgd)
-{
-	pgdval_t ret;
-
-	if (sizeof(pgdval_t) > sizeof(long))
-		ret =  PVOP_CALL2(pgdval_t, pv_mmu_ops.pgd_val,
-				  pgd.pgd, (u64)pgd.pgd >> 32);
-	else
-		ret =  PVOP_CALL1(pgdval_t, pv_mmu_ops.pgd_val,
-				  pgd.pgd);
-
-	return ret;
-}
-
 #define  __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
 static inline pte_t ptep_modify_prot_start(struct mm_struct *mm, unsigned long addr,
 					   pte_t *ptep)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index e4c8fb6..ac48a2d 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -424,23 +424,12 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.pmd_clear = native_pmd_clear,
 #endif
 	.set_pud = native_set_pud,
-	.pmd_val = native_pmd_val,
-	.make_pmd = native_make_pmd,
 
 #if PAGETABLE_LEVELS == 4
-	.pud_val = native_pud_val,
-	.make_pud = native_make_pud,
 	.set_pgd = native_set_pgd,
 #endif
 #endif /* PAGETABLE_LEVELS >= 3 */
 
-	.pte_val = native_pte_val,
-	.pte_flags = native_pte_flags,
-	.pgd_val = native_pgd_val,
-
-	.make_pte = native_make_pte,
-	.make_pgd = native_make_pgd,
-
 	.dup_mmap = paravirt_nop,
 	.exit_mmap = paravirt_nop,
 	.activate_mm = paravirt_nop,

--=-80i4iXIu0IW0iJvj/uMB--

