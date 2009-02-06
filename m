Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbZBFGRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbZBFGRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbZBFGRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:17:25 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:36003 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755673AbZBFGRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:17:24 -0500
Subject: Re: [PARAVIRT/x86] BUGFIX: Put a missing paravirt_release_pmd in
	pgd_dtor
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Zach Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Rohit Jain <rjain@vmware.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <498BA0CA.2040603@goop.org>
References: <1233885731.29693.26.camel@alok-dev1>
	 <498BA0CA.2040603@goop.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 05 Feb 2009 22:17:23 -0800
Message-Id: <1233901043.8943.6.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 18:30 -0800, Jeremy Fitzhardinge wrote: 
> >  
> > +	if (PAGETABLE_LEVELS == 2 ||
> > +            (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD) ||
> > +            PAGETABLE_LEVELS == 4) {
> > +		paravirt_release_pmd(__pa(pgd) >> PAGE_SHIFT);
> > +	}
> >   
> 
> Ah, you want release_pmd to be called on pgds as well...  Why?  Do you 
> track the page type for pgds? 

VMI didn't/still doesn't differentiate between a *release* of pgd or
pmd. 
>  Why not just make a copy of the entries 
> on cr3 reload like the real hardware does?
> 
> Alternatively you could hook pv_mmu_ops.exit_mmap to get a call when the 
> last reference to the pagetable has been dropped.

> 
> Or, if you really must, introduce paravirt_release_pgd and hook that.

As it affects only VMI, instead of adding another callback, i have
hooked on the paravirt_pgd_free call for vmi to release the pgd page.
Below is the patch. I will run some overnight tests with this patch and
get back if there are any errors.

> 
> But either way, calling release_pmd here is wrong, since its only meant 
> to be applied to pmds,
Maybe i misunderstand, but that's how it used to work before that
commit, we had a single call to release_*pd*, no ?
>  and it would break the Xen code.

i see xen doesn't define the alloc_pmd_clone call. 

Thanks,
Alok

-- 
[VMI/x86] Release the pgd page in pgd_dtor.

From: Alok N Kataria <akataria@vmware.com>

The commit...
-----------------------------
commit 6194ba6ff6ccf8d5c54c857600843c67aa82c407
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Wed Jan 30 13:34:11 2008 +0100

    x86: don't special-case pmd allocations as much
------------------------------
...made changes to the way we handle pmd allocations, and while doing that
it dropped a call to  paravirt_release_pd on the pgd page from the pgd_dtor
code path.

As a result of this missing release, the hypervisor is now unaware of the
pgd page being freed, and as a result it ends up tracking this page as a
page table page.
After this the guest may start using the same page for other purposes, and
depending on what use the page is put to, it may result in various performance
and/or functional issues ( hangs, reboots).

Since this bug affects only VMI, instead of adding another pgd_release hook,
I now release the pgd page in the (vmi)_pgd_free hook.

Patch on top of 2.6.29-rc3 (mainline head).

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Rohit Jain <rjain@vmware.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: stable@kernel.org
---

 arch/x86/kernel/vmi_32.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 1d3302c..dfed18f 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -321,6 +321,16 @@ static void vmi_release_pmd(unsigned long pfn)
 }
 
 /*
+ * We hack the pgd_free hook for releasing the pgd page.
+ */
+static void vmi_pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	unsigned long pfn = __pa(pgd) >> PAGE_SHIFT;
+
+	vmi_ops.release_page(pfn, VMI_PAGE_L2);
+}
+
+/*
  * Helper macros for MMU update flags.  We can defer updates until a flush
  * or page invalidation only if the update is to the current address space
  * (otherwise, there is no flush).  We must check against init_mm, since
@@ -762,6 +772,7 @@ static inline int __init activate_vmi(void)
 	if (vmi_ops.release_page) {
 		pv_mmu_ops.release_pte = vmi_release_pte;
 		pv_mmu_ops.release_pmd = vmi_release_pmd;
+		pv_mmu_ops.pgd_free = vmi_pgd_free;
 	}
 
 	/* Set linear is needed in all cases */


