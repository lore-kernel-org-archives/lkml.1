Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbYABULZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbYABULZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYABUJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:09:37 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:55712 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbYABUJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:09:36 -0500
Date: Wed, 2 Jan 2008 15:08:51 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/7] UML - Re-remove accidentally restored code
Message-ID: <20080102200851.GA7939@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
restores some code which had been deleted by
uml-move-um_virt_to_phys.patch and uml-add-virt_to_pte.patch,
presumably due to a botched diff.

This patch gets rid of it again.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/process.c |   44 --------------------------------------------
 1 file changed, 44 deletions(-)

Index: linux-2.6.22/arch/um/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/process.c	2007-12-13 13:28:34.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/process.c	2007-12-13 13:30:45.000000000 -0500
@@ -4,7 +4,6 @@
  * Licensed under the GPL
  */
 
-#include "linux/module.h"
 #include "linux/stddef.h"
 #include "linux/err.h"
 #include "linux/hardirq.h"
@@ -256,49 +255,6 @@ void cpu_idle(void)
 	default_idle();
 }
 
-void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
-		      pte_t *pte_out)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	pte_t ptent;
-
-	if (task->mm == NULL)
-		return ERR_PTR(-EINVAL);
-	pgd = pgd_offset(task->mm, addr);
-	if (!pgd_present(*pgd))
-		return ERR_PTR(-EINVAL);
-
-	pud = pud_offset(pgd, addr);
-	if (!pud_present(*pud))
-		return ERR_PTR(-EINVAL);
-
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd))
-		return ERR_PTR(-EINVAL);
-
-	pte = pte_offset_kernel(pmd, addr);
-	ptent = *pte;
-	if (!pte_present(ptent))
-		return ERR_PTR(-EINVAL);
-
-	if (pte_out != NULL)
-		*pte_out = ptent;
-	return (void *) (pte_val(ptent) & PAGE_MASK) + (addr & ~PAGE_MASK);
-}
-
-char *current_cmd(void)
-{
-#if defined(CONFIG_SMP) || defined(CONFIG_HIGHMEM)
-	return "(Unknown)";
-#else
-	void *addr = um_virt_to_phys(current, current->mm->arg_start, NULL);
-	return IS_ERR(addr) ? "(Unknown)": __va((unsigned long) addr);
-#endif
-}
-
 int __cant_sleep(void) {
 	return in_atomic() || irqs_disabled() || in_interrupt();
 	/* Is in_interrupt() really needed? */
