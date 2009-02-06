Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbZBFS35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbZBFS35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZBFS3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:29:37 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:59305 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135AbZBFS3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:29:36 -0500
Subject: Re: [PARAVIRT/x86] BUGFIX: Put a missing paravirt_release_pmd in
	pgd_dtor
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Zach Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Rohit Jain <rjain@vmware.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <498C6CC9.5050302@goop.org>
References: <1233885731.29693.26.camel@alok-dev1>
	 <498BA0CA.2040603@goop.org> <1233901043.8943.6.camel@alok-dev1>
	 <498BDE1D.8030101@goop.org> <20090206145324.GF18368@elte.hu>
	 <498C6CC9.5050302@goop.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 06 Feb 2009 10:29:35 -0800
Message-Id: <1233944975.15269.14.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 09:00 -0800, Jeremy Fitzhardinge wrote:
> >   
> 
> Yeah.  Though:
> >  /*
> > + * We hack the pgd_free hook for releasing the pgd page.
> >   
> Its hardly a hack to use a hook for exactly its intended purpose...

Ok Ingo, below is the patch with a better comment. Please apply this.

Thanks,
Alok

--
[VMI/x86] Put a missing release on the pgd page in pgd_dtor

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

Since this release is only required for VMI, I now release the pgd page from
the (vmi)_pgd_free hook.

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
index 1d3302c..c4d6c74 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -321,6 +321,16 @@ static void vmi_release_pmd(unsigned long pfn)
 }
 
 /*
+ * We use the pgd_free hook for releasing the pgd page.
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


