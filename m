Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYAXA20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYAXA20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYAXA2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:28:18 -0500
Received: from gw.goop.org ([64.81.55.164]:42120 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYAXA2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:28:18 -0500
Message-ID: <4797DBA0.5020909@goop.org>
Date: Wed, 23 Jan 2008 16:28:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH UPDATE] x86: ignore spurious faults
References: <4797D64D.1060105@goop.org> <1201133916.16972.124.camel@brick>
In-Reply-To: <1201133916.16972.124.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When changing a kernel page from RO->RW, it's OK to leave stale TLB
entries around, since doing a global flush is expensive and they pose
no security problem.  They can, however, generate a spurious fault,
which we should catch and simply return from (which will have the
side-effect of reloading the TLB to the current PTE).

This can occur when running under Xen, because it frequently changes
kernel pages from RW->RO->RW to implement Xen's pagetable semantics.
It could also occur when using CONFIG_DEBUG_PAGEALLOC, since it avoids
doing a global TLB flush after changing page permissions.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault_64.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

===================================================================
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -324,6 +324,51 @@ static int is_f00f_bug(struct pt_regs *r
 }
 
 /*
+ * Handle a spurious fault caused by a stale TLB entry.  This allows
+ * us to lazily refresh the TLB when increasing the permissions of a
+ * kernel page (RO -> RW or NX -> X).  Doing it eagerly is very
+ * expensive since that implies doing a full cross-processor TLB
+ * flush, even if no stale TLB entries exist on other processors.
+ * There are no security implications to leaving a stale TLB when
+ * increasing the permissions on a page.
+ */
+static int spurious_fault(unsigned long address,
+			  unsigned long error_code)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	/* Reserved-bit violation or user access to kernel space? */
+	if (error_code & (PF_USER | PF_RSVD))
+		return 0;
+
+	pgd = init_mm.pgd + pgd_index(address);
+	if (!pgd_present(*pgd))
+		return 0;
+
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return 0;
+
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd))
+		return 0;
+
+	pte = pte_offset_kernel(pmd, address);
+	if (!pte_present(*pte))
+		return 0;
+
+	if ((error_code & PF_WRITE) && !pte_write(*pte))
+		return 0;
+	if ((error_code & PF_INSTR) && !pte_exec(*pte))
+		return 0;
+
+	return 1;
+}
+
+/*
  * Handle a fault on the vmalloc or module mapping area
  *
  * This assumes no large pages in there.
@@ -446,6 +491,11 @@ void __kprobes do_page_fault(struct pt_r
 		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
 		    vmalloc_fault(address) >= 0)
 			return;
+
+		/* Can handle a stale RO->RW TLB */
+		if (spurious_fault(address, error_code))
+			return;
+
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
 		 * fault we could otherwise deadlock.
===================================================================
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -312,6 +312,51 @@ static noinline void pgtable_bad(unsigne
 }
 
 /*
+ * Handle a spurious fault caused by a stale TLB entry.  This allows
+ * us to lazily refresh the TLB when increasing the permissions of a
+ * kernel page (RO -> RW or NX -> X).  Doing it eagerly is very
+ * expensive since that implies doing a full cross-processor TLB
+ * flush, even if no stale TLB entries exist on other processors.
+ * There are no security implications to leaving a stale TLB when
+ * increasing the permissions on a page.
+ */
+static int spurious_fault(unsigned long address,
+			  unsigned long error_code)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	/* Reserved-bit violation or user access to kernel space? */
+	if (error_code & (PF_USER | PF_RSVD))
+		return 0;
+
+	pgd = init_mm.pgd + pgd_index(address);
+	if (!pgd_present(*pgd))
+		return 0;
+
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return 0;
+
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd))
+		return 0;
+
+	pte = pte_offset_kernel(pmd, address);
+	if (!pte_present(*pte))
+		return 0;
+
+	if ((error_code & PF_WRITE) && !pte_write(*pte))
+		return 0;
+	if ((error_code & PF_INSTR) && !pte_exec(*pte))
+		return 0;
+
+	return 1;
+}
+
+/*
  * Handle a fault on the vmalloc area
  *
  * This assumes no large pages in there.
@@ -443,6 +488,11 @@ asmlinkage void __kprobes do_page_fault(
 			if (vmalloc_fault(address) >= 0)
 				return;
 		}
+
+		/* Can handle a stale RO->RW TLB */
+		if (spurious_fault(address, error_code))
+			return;
+
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
 		 * fault we could otherwise deadlock.

