Return-Path: <linux-kernel-owner+w=401wt.eu-S933726AbXH0Vqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbXH0Vqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932641AbXH0VbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:31:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765620AbXH0VbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:31:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 4/4] Hibernation: Use temporary page tables for kernel text mapping on x86_64
Date: Mon, 27 Aug 2007 23:39:32 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708272331.28584.rjw@sisk.pl>
In-Reply-To: <200708272331.28584.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708272339.32772.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use temporary page tables for the kernel text mapping during hibernation restore
on x86_64.

Without the patch, the original boot kernel's page tables that represent the
kernel text mapping are used while the core of the image kernel is being
restored.  However, in principle, if the boot kernel is not identical to the
image kernel, the location of these page tables in the image kernel need not be
the same, so we should create a safe copy of the kernel text mapping prior to
restoring the core of the image kernel.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 arch/x86_64/kernel/suspend.c |   39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

Index: linux-2.6.23-rc3/arch/x86_64/kernel/suspend.c
===================================================================
--- linux-2.6.23-rc3.orig/arch/x86_64/kernel/suspend.c	2007-08-25 22:51:56.000000000 +0200
+++ linux-2.6.23-rc3/arch/x86_64/kernel/suspend.c	2007-08-25 22:53:01.000000000 +0200
@@ -191,25 +191,42 @@ static int res_phys_pud_init(pud_t *pud,
 	return 0;
 }
 
+static int res_kernel_text_pud_init(pud_t *pud, unsigned long start)
+{
+	pmd_t *pmd;
+	unsigned long paddr;
+
+	pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
+	if (!pmd)
+		return -ENOMEM;
+	set_pud(pud + pud_index(start), __pud(__pa(pmd) | _KERNPG_TABLE));
+	for (paddr = 0; paddr < KERNEL_TEXT_SIZE; pmd++, paddr += PMD_SIZE) {
+		unsigned long pe;
+
+		pe = __PAGE_KERNEL_LARGE_EXEC | _PAGE_GLOBAL | paddr;
+		pe &= __supported_pte_mask;
+		set_pmd(pmd, __pmd(pe));
+	}
+
+	return 0;
+}
+
 static int set_up_temporary_mappings(void)
 {
 	unsigned long start, end, next;
+	pud_t *pud;
 	int error;
 
 	temp_level4_pgt = (pgd_t *)get_safe_page(GFP_ATOMIC);
 	if (!temp_level4_pgt)
 		return -ENOMEM;
 
-	/* It is safe to reuse the original kernel mapping */
-	set_pgd(temp_level4_pgt + pgd_index(__START_KERNEL_map),
-		init_level4_pgt[pgd_index(__START_KERNEL_map)]);
-
 	/* Set up the direct mapping from scratch */
 	start = (unsigned long)pfn_to_kaddr(0);
 	end = (unsigned long)pfn_to_kaddr(end_pfn);
 
 	for (; start < end; start = next) {
-		pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
+		pud = (pud_t *)get_safe_page(GFP_ATOMIC);
 		if (!pud)
 			return -ENOMEM;
 		next = start + PGDIR_SIZE;
@@ -220,7 +237,17 @@ static int set_up_temporary_mappings(voi
 		set_pgd(temp_level4_pgt + pgd_index(start),
 			mk_kernel_pgd(__pa(pud)));
 	}
-	return 0;
+
+	/* Set up the kernel text mapping from scratch */
+	pud = (pud_t *)get_safe_page(GFP_ATOMIC);
+	if (!pud)
+		return -ENOMEM;
+	error = res_kernel_text_pud_init(pud, __START_KERNEL_map);
+	if (!error)
+		set_pgd(temp_level4_pgt + pgd_index(__START_KERNEL_map),
+			__pgd(__pa(pud) | _PAGE_TABLE));
+
+	return error;
 }
 
 int swsusp_arch_resume(void)
