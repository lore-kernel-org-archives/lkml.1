Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZCUQTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZCUQTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZCUQTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:19:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:52907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbZCUQTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:19:13 -0400
Date: Sat, 21 Mar 2009 16:18:27 GMT
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jeremy.fitzhardinge@citrix.com, jeremy@goop.org, jbeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, jeremy@goop.org, jbeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C43A8E.5090203@goop.org>
References: <49C43A8E.5090203@goop.org>
Subject: [tip:x86/mm] Revert "x86: create a non-zero sized bm_pte only when needed"
Message-ID: <tip-45c7b28f3c7e3a45cc5a597cc19816a9015ee8ae@git.kernel.org>
Git-Commit-ID: 45c7b28f3c7e3a45cc5a597cc19816a9015ee8ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Mar 2009 16:18:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45c7b28f3c7e3a45cc5a597cc19816a9015ee8ae
Gitweb:     http://git.kernel.org/tip/45c7b28f3c7e3a45cc5a597cc19816a9015ee8ae
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Fri, 20 Mar 2009 17:53:34 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Mar 2009 17:11:41 +0100

Revert "x86: create a non-zero sized bm_pte only when needed"

This reverts commit 698609bdcd35d0641f4c6622c83680ab1a6d67cb.

69860 breaks Xen booting, as it relies on head*.S to set up the fixmap
pagetables (as a side-effect of initializing the USB debug port).
Xen, however, does not boot via head*.S, and so the fixmap area is
not initialized.

The specific symptom of the crash is a fault in dmi_scan(), because
the pointer that early_ioremap returns is not actually present.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49C43A8E.5090203@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/ioremap.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 55e127f..83ed74a 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -487,12 +487,7 @@ static int __init early_ioremap_debug_setup(char *str)
 early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
 static __initdata int after_paging_init;
-#define __FIXADDR_TOP (-PAGE_SIZE)
-static pte_t bm_pte[(__fix_to_virt(FIX_DBGP_BASE)
-		     ^ __fix_to_virt(FIX_BTMAP_BEGIN)) >> PMD_SHIFT
-		    ? PAGE_SIZE / sizeof(pte_t) : 0] __page_aligned_bss;
-#undef __FIXADDR_TOP
-static __initdata pte_t *bm_ptep;
+static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
@@ -507,8 +502,6 @@ static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 
 static inline pte_t * __init early_ioremap_pte(unsigned long addr)
 {
-	if (!sizeof(bm_pte))
-		return &bm_ptep[pte_index(addr)];
 	return &bm_pte[pte_index(addr)];
 }
 
@@ -526,14 +519,8 @@ void __init early_ioremap_init(void)
 		slot_virt[i] = fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
-	if (sizeof(bm_pte)) {
-		memset(bm_pte, 0, sizeof(bm_pte));
-		pmd_populate_kernel(&init_mm, pmd, bm_pte);
-	} else {
-		bm_ptep = pte_offset_kernel(pmd, 0);
-		if (early_ioremap_debug)
-			printk(KERN_INFO "bm_ptep=%p\n", bm_ptep);
-	}
+	memset(bm_pte, 0, sizeof(bm_pte));
+	pmd_populate_kernel(&init_mm, pmd, bm_pte);
 
 	/*
 	 * The boot-ioremap range spans multiple pmds, for which
