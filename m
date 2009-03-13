Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZCMCg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZCMCg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbZCMCfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:35:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:52519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926AbZCMCfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:35:39 -0400
Date: Fri, 13 Mar 2009 02:34:27 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B91826.76E4.0078.0@novell.com>
References: <49B91826.76E4.0078.0@novell.com>
Subject: [tip:x86/mm] x86: create a non-zero sized bm_pte only when needed
Message-ID: <tip-698609bdcd35d0641f4c6622c83680ab1a6d67cb@git.kernel.org>
Git-Commit-ID: 698609bdcd35d0641f4c6622c83680ab1a6d67cb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 02:34:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  698609bdcd35d0641f4c6622c83680ab1a6d67cb
Gitweb:     http://git.kernel.org/tip/698609bdcd35d0641f4c6622c83680ab1a6d67cb
Author:     Jan Beulich <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 13:11:50 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 02:37:20 +0100

x86: create a non-zero sized bm_pte only when needed

Impact: kernel image size reduction

Since in most configurations the pmd page needed maps the same range of
virtual addresses which is also mapped by the earlier inserted one for
covering FIX_DBGP_BASE, that page (and its insertion in the page
tables) can be avoided altogether by detecting the condition at compile
time.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B91826.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/ioremap.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 83ed74a..55e127f 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -487,7 +487,12 @@ static int __init early_ioremap_debug_setup(char *str)
 early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
 static __initdata int after_paging_init;
-static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
+#define __FIXADDR_TOP (-PAGE_SIZE)
+static pte_t bm_pte[(__fix_to_virt(FIX_DBGP_BASE)
+		     ^ __fix_to_virt(FIX_BTMAP_BEGIN)) >> PMD_SHIFT
+		    ? PAGE_SIZE / sizeof(pte_t) : 0] __page_aligned_bss;
+#undef __FIXADDR_TOP
+static __initdata pte_t *bm_ptep;
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
@@ -502,6 +507,8 @@ static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 
 static inline pte_t * __init early_ioremap_pte(unsigned long addr)
 {
+	if (!sizeof(bm_pte))
+		return &bm_ptep[pte_index(addr)];
 	return &bm_pte[pte_index(addr)];
 }
 
@@ -519,8 +526,14 @@ void __init early_ioremap_init(void)
 		slot_virt[i] = fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
-	memset(bm_pte, 0, sizeof(bm_pte));
-	pmd_populate_kernel(&init_mm, pmd, bm_pte);
+	if (sizeof(bm_pte)) {
+		memset(bm_pte, 0, sizeof(bm_pte));
+		pmd_populate_kernel(&init_mm, pmd, bm_pte);
+	} else {
+		bm_ptep = pte_offset_kernel(pmd, 0);
+		if (early_ioremap_debug)
+			printk(KERN_INFO "bm_ptep=%p\n", bm_ptep);
+	}
 
 	/*
 	 * The boot-ioremap range spans multiple pmds, for which
