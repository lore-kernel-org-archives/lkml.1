Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbYHVDgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbYHVDgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYHVDgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:36:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45064 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYHVDgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:36:40 -0400
Date: Fri, 22 Aug 2008 05:36:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM_GUEST: use the right parameter type on
	kvm_release_pt() (was Re: i386 allmodconfig in linux-next)
Message-ID: <20080822033613.GA25309@elte.hu>
References: <20080819024549.5f2c43cf.akpm@linux-foundation.org> <48AACD95.8050207@qumranet.com> <20080819191607.GQ6342@blackpad> <48AD72B7.3090608@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD72B7.3090608@qumranet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Avi Kivity <avi@qumranet.com> wrote:

> Eduardo Habkost wrote:
>> From: Eduardo Habkost <ehabkost@redhat.com>
>> Subject: [PATCH] KVM_GUEST: Use the right parameter type on kvm_release_pt()
>>
>> This fixes the following compiler warnings, that were introduced by me
>> on commit fa24f8e67c189b8b904c8a34f12e6dae9c14dbba.
>>
>> arch/x86/kernel/kvm.c: In function 'paravirt_ops_setup':
>> arch/x86/kernel/kvm.c:233: warning: assignment from incompatible pointer type
>> arch/x86/kernel/kvm.c:234: warning: assignment from incompatible pointer type
>> arch/x86/kernel/kvm.c:235: warning: assignment from incompatible pointer type
>>   
>
> Ingo?  Can you queue/fold this into the original patch?

done - updated v2 combo patch below, queued in tip/x86/paravirt.

	Ingo

-------------------->
>From f86399396ce7a4f4069828b7dceac5aa5113dfb5 Mon Sep 17 00:00:00 2001
From: Eduardo Habkost <ehabkost@redhat.com>
Date: Wed, 30 Jul 2008 18:32:27 -0300
Subject: [PATCH] x86, paravirt_ops: use unsigned long instead of u32 for alloc_p*() pfn args

This patch changes the pfn args from 'u32' to 'unsigned long'
on alloc_p*() functions on paravirt_ops, and the corresponding
implementations for Xen and VMI. The prototypes for CONFIG_PARAVIRT=n
are already using unsigned long, so paravirt.h now matches the prototypes
on asm-x86/pgalloc.h.

It shouldn't result in any changes on generated code on 32-bit, with
or without CONFIG_PARAVIRT. On both cases, 'codiff -f' didn't show any
change after applying this patch.

On 64-bit, there are (expected) binary changes only when CONFIG_PARAVIRT
is enabled, as the patch is really supposed to change the size of the
pfn args.

[ v2: KVM_GUEST: use the right parameter type on kvm_release_pt() ]

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Acked-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kvm.c      |    2 +-
 arch/x86/kernel/vmi_32.c   |   10 +++++-----
 arch/x86/xen/enlighten.c   |   20 ++++++++++----------
 include/asm-x86/paravirt.h |   30 +++++++++++++++---------------
 4 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8b7a3cf..478bca9 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -178,7 +178,7 @@ static void kvm_flush_tlb(void)
 	kvm_deferred_mmu_op(&ftlb, sizeof ftlb);
 }
 
-static void kvm_release_pt(u32 pfn)
+static void kvm_release_pt(unsigned long pfn)
 {
 	struct kvm_mmu_op_release_pt rpt = {
 		.header.op = KVM_MMU_OP_RELEASE_PT,
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 0a1b1a9..340b036 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -392,13 +392,13 @@ static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
 }
 #endif
 
-static void vmi_allocate_pte(struct mm_struct *mm, u32 pfn)
+static void vmi_allocate_pte(struct mm_struct *mm, unsigned long pfn)
 {
 	vmi_set_page_type(pfn, VMI_PAGE_L1);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L1, 0, 0, 0);
 }
 
-static void vmi_allocate_pmd(struct mm_struct *mm, u32 pfn)
+static void vmi_allocate_pmd(struct mm_struct *mm, unsigned long pfn)
 {
  	/*
 	 * This call comes in very early, before mem_map is setup.
@@ -409,20 +409,20 @@ static void vmi_allocate_pmd(struct mm_struct *mm, u32 pfn)
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2, 0, 0, 0);
 }
 
-static void vmi_allocate_pmd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
+static void vmi_allocate_pmd_clone(unsigned long pfn, unsigned long clonepfn, unsigned long start, unsigned long count)
 {
  	vmi_set_page_type(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE);
 	vmi_check_page_type(clonepfn, VMI_PAGE_L2);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE, clonepfn, start, count);
 }
 
-static void vmi_release_pte(u32 pfn)
+static void vmi_release_pte(unsigned long pfn)
 {
 	vmi_ops.release_page(pfn, VMI_PAGE_L1);
 	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
 }
 
-static void vmi_release_pmd(u32 pfn)
+static void vmi_release_pmd(unsigned long pfn)
 {
 	vmi_ops.release_page(pfn, VMI_PAGE_L2);
 	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 9ff6e3c..db970bd 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -812,7 +812,7 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 
 /* Early in boot, while setting up the initial pagetable, assume
    everything is pinned. */
-static __init void xen_alloc_pte_init(struct mm_struct *mm, u32 pfn)
+static __init void xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
 {
 #ifdef CONFIG_FLATMEM
 	BUG_ON(mem_map);	/* should only be used early */
@@ -822,7 +822,7 @@ static __init void xen_alloc_pte_init(struct mm_struct *mm, u32 pfn)
 
 /* Early release_pte assumes that all pts are pinned, since there's
    only init_mm and anything attached to that is pinned. */
-static void xen_release_pte_init(u32 pfn)
+static void xen_release_pte_init(unsigned long pfn)
 {
 	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
@@ -838,7 +838,7 @@ static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
 
 /* This needs to make sure the new pte page is pinned iff its being
    attached to a pinned pagetable. */
-static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
+static void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn, unsigned level)
 {
 	struct page *page = pfn_to_page(pfn);
 
@@ -856,12 +856,12 @@ static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
 	}
 }
 
-static void xen_alloc_pte(struct mm_struct *mm, u32 pfn)
+static void xen_alloc_pte(struct mm_struct *mm, unsigned long pfn)
 {
 	xen_alloc_ptpage(mm, pfn, PT_PTE);
 }
 
-static void xen_alloc_pmd(struct mm_struct *mm, u32 pfn)
+static void xen_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
 {
 	xen_alloc_ptpage(mm, pfn, PT_PMD);
 }
@@ -909,7 +909,7 @@ static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
 }
 
 /* This should never happen until we're OK to use struct page */
-static void xen_release_ptpage(u32 pfn, unsigned level)
+static void xen_release_ptpage(unsigned long pfn, unsigned level)
 {
 	struct page *page = pfn_to_page(pfn);
 
@@ -923,23 +923,23 @@ static void xen_release_ptpage(u32 pfn, unsigned level)
 	}
 }
 
-static void xen_release_pte(u32 pfn)
+static void xen_release_pte(unsigned long pfn)
 {
 	xen_release_ptpage(pfn, PT_PTE);
 }
 
-static void xen_release_pmd(u32 pfn)
+static void xen_release_pmd(unsigned long pfn)
 {
 	xen_release_ptpage(pfn, PT_PMD);
 }
 
 #if PAGETABLE_LEVELS == 4
-static void xen_alloc_pud(struct mm_struct *mm, u32 pfn)
+static void xen_alloc_pud(struct mm_struct *mm, unsigned long pfn)
 {
 	xen_alloc_ptpage(mm, pfn, PT_PUD);
 }
 
-static void xen_release_pud(u32 pfn)
+static void xen_release_pud(unsigned long pfn)
 {
 	xen_release_ptpage(pfn, PT_PUD);
 }
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index fbbde93..497aea0 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -257,13 +257,13 @@ struct pv_mmu_ops {
 	 * Hooks for allocating/releasing pagetable pages when they're
 	 * attached to a pagetable
 	 */
-	void (*alloc_pte)(struct mm_struct *mm, u32 pfn);
-	void (*alloc_pmd)(struct mm_struct *mm, u32 pfn);
-	void (*alloc_pmd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
-	void (*alloc_pud)(struct mm_struct *mm, u32 pfn);
-	void (*release_pte)(u32 pfn);
-	void (*release_pmd)(u32 pfn);
-	void (*release_pud)(u32 pfn);
+	void (*alloc_pte)(struct mm_struct *mm, unsigned long pfn);
+	void (*alloc_pmd)(struct mm_struct *mm, unsigned long pfn);
+	void (*alloc_pmd_clone)(unsigned long pfn, unsigned long clonepfn, unsigned long start, unsigned long count);
+	void (*alloc_pud)(struct mm_struct *mm, unsigned long pfn);
+	void (*release_pte)(unsigned long pfn);
+	void (*release_pmd)(unsigned long pfn);
+	void (*release_pud)(unsigned long pfn);
 
 	/* Pagetable manipulation functions */
 	void (*set_pte)(pte_t *ptep, pte_t pteval);
@@ -993,35 +993,35 @@ static inline void paravirt_pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	PVOP_VCALL2(pv_mmu_ops.pgd_free, mm, pgd);
 }
 
-static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned pfn)
+static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned long pfn)
 {
 	PVOP_VCALL2(pv_mmu_ops.alloc_pte, mm, pfn);
 }
-static inline void paravirt_release_pte(unsigned pfn)
+static inline void paravirt_release_pte(unsigned long pfn)
 {
 	PVOP_VCALL1(pv_mmu_ops.release_pte, pfn);
 }
 
-static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned pfn)
+static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
 {
 	PVOP_VCALL2(pv_mmu_ops.alloc_pmd, mm, pfn);
 }
 
-static inline void paravirt_alloc_pmd_clone(unsigned pfn, unsigned clonepfn,
-					    unsigned start, unsigned count)
+static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,
+					    unsigned long start, unsigned long count)
 {
 	PVOP_VCALL4(pv_mmu_ops.alloc_pmd_clone, pfn, clonepfn, start, count);
 }
-static inline void paravirt_release_pmd(unsigned pfn)
+static inline void paravirt_release_pmd(unsigned long pfn)
 {
 	PVOP_VCALL1(pv_mmu_ops.release_pmd, pfn);
 }
 
-static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned pfn)
+static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned long pfn)
 {
 	PVOP_VCALL2(pv_mmu_ops.alloc_pud, mm, pfn);
 }
-static inline void paravirt_release_pud(unsigned pfn)
+static inline void paravirt_release_pud(unsigned long pfn)
 {
 	PVOP_VCALL1(pv_mmu_ops.release_pud, pfn);
 }
