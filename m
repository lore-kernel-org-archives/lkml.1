Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbZBFCCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbZBFCCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZBFCCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:02:13 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:44404 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbZBFCCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:02:12 -0500
Subject: [PARAVIRT/x86] BUGFIX: Put a missing paravirt_release_pmd in
	pgd_dtor
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Rohit Jain <rjain@vmware.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 05 Feb 2009 18:02:11 -0800
Message-Id: <1233885731.29693.26.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PARAVIRT/x86] Put a missing paravirt_release_pmd in pgd_dtor.

From: Alok N Kataria <akataria@vmware.com>

The commit...
-----------------------------
commit 6194ba6ff6ccf8d5c54c857600843c67aa82c407
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Wed Jan 30 13:34:11 2008 +0100

    x86: don't special-case pmd allocations as much
------------------------------
...made changes to the way we handle pmd allocations, and while doing that
it (accidently ?) dropped a call to  paravirt_release_pd from the pgd_dtor
code path.

As a result of this missing release, the hypervisor is now unaware of the
pgd page being freed, and as a result it ends up tracking this page as a
page table page.
After this the guest may start using the same page for other purposes, and
depending on what use the page is put to, it may result in various performance
and/or functional issues ( hangs, reboots).

The patch below adds a paravirt_release_pmd call for the PGD page.
Patch on top of 2.6.29-rc3 (mainline-git).

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Rohit Jain <rjain@vmware.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: stable@kernel.org
---

 arch/x86/mm/pgtable.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 86f2ffc..c23cd7e 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -89,6 +89,12 @@ static void pgd_dtor(pgd_t *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
+	if (PAGETABLE_LEVELS == 2 ||
+            (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD) ||
+            PAGETABLE_LEVELS == 4) {
+		paravirt_release_pmd(__pa(pgd) >> PAGE_SHIFT);
+	}
+
 	if (SHARED_KERNEL_PMD)
 		return;
 



