Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbZFAGgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbZFAGgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 02:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZFAGfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 02:35:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:33081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbZFAGf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 02:35:29 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] x86: reorganize cpa_process_alias()
Date: Mon,  1 Jun 2009 15:34:48 +0900
Message-Id: <1243838091-28591-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243838091-28591-1-git-send-email-tj@kernel.org>
References: <1243838091-28591-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 06:35:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize cpa_process_alias() so that new alias condition can be
added easily.

Jan Beulich spotted problem in the original cleanup thread which
incorrectly assumed the two existing conditions were mutially
exclusive.

[ Impact: code reorganization ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pageattr.c |   50 ++++++++++++++++++++++-------------------------
 1 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e17efed..dca77d0 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -681,8 +681,9 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias);
 static int cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
-	int ret = 0;
-	unsigned long temp_cpa_vaddr, vaddr;
+	unsigned long laddr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
+	unsigned long vaddr;
+	int ret;
 
 	if (cpa->pfn >= max_pfn_mapped)
 		return 0;
@@ -706,42 +707,37 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))) {
 
 		alias_cpa = *cpa;
-		temp_cpa_vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
-		alias_cpa.vaddr = &temp_cpa_vaddr;
+		alias_cpa.vaddr = &laddr;
 		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 
-
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
+		if (ret)
+			return ret;
 	}
 
 #ifdef CONFIG_X86_64
-	if (ret)
-		return ret;
 	/*
-	 * No need to redo, when the primary call touched the high
-	 * mapping already:
-	 */
-	if (within(vaddr, (unsigned long) _text, _brk_end))
-		return 0;
-
-	/*
-	 * If the physical address is inside the kernel map, we need
+	 * If the primary call didn't touch the high mapping already
+	 * and the physical address is inside the kernel map, we need
 	 * to touch the high mapped kernel as well:
 	 */
-	if (!within(cpa->pfn, highmap_start_pfn(), highmap_end_pfn()))
-		return 0;
-
-	alias_cpa = *cpa;
-	temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
-	alias_cpa.vaddr = &temp_cpa_vaddr;
-	alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
+	if (!within(vaddr, (unsigned long)_text, _brk_end) &&
+	    within(cpa->pfn, highmap_start_pfn(), highmap_end_pfn())) {
+		unsigned long temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) +
+					       __START_KERNEL_map - phys_base;
+		alias_cpa = *cpa;
+		alias_cpa.vaddr = &temp_cpa_vaddr;
+		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 
-	/*
-	 * The high mapping range is imprecise, so ignore the return value.
-	 */
-	__change_page_attr_set_clr(&alias_cpa, 0);
+		/*
+		 * The high mapping range is imprecise, so ignore the
+		 * return value.
+		 */
+		__change_page_attr_set_clr(&alias_cpa, 0);
+	}
 #endif
-	return ret;
+
+	return 0;
 }
 
 static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
-- 
1.6.0.2

