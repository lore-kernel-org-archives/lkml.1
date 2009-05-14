Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbZENMvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbZENMvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760503AbZENMuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:50:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:45946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760597AbZENMuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:50:24 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu,
       linux-kernel-owner@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] x86: simplify cpa_process_alias()
Date: Thu, 14 May 2009 21:49:48 +0900
Message-Id: <1242305390-21958-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1242305390-21958-1-git-send-email-tj@kernel.org>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 14 May 2009 12:49:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two existing alias conditions in cpa_process_alias() are mutually
exclusive and future ones are likely to be exclusive too.  Simplify
control flow to ease adding other alias cases.

The within(vaddr, (unsigned long)_text, _brk_end) test is removed as
it's guaranteed to be false if vaddr is in the page mapped area.

[ Impact: cleanup, no functional difference ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pageattr.c |   42 ++++++++++++++++++------------------------
 1 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 797f9f1..1097b61 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -686,7 +686,6 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias);
 static int cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
-	int ret = 0;
 	unsigned long temp_cpa_vaddr, vaddr;
 
 	if (cpa->pfn >= max_pfn_mapped)
@@ -715,38 +714,33 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		alias_cpa.vaddr = &temp_cpa_vaddr;
 		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 
-
-		ret = __change_page_attr_set_clr(&alias_cpa, 0);
+		return __change_page_attr_set_clr(&alias_cpa, 0);
 	}
 
-#ifdef CONFIG_X86_64
-	if (ret)
-		return ret;
-	/*
-	 * No need to redo, when the primary call touched the high
-	 * mapping already:
-	 */
-	if (within(vaddr, (unsigned long) _text, _brk_end))
-		return 0;
+	/* vaddr is in page mapped area */
 
+#ifdef CONFIG_X86_64
 	/*
 	 * If the physical address is inside the kernel map, we need
 	 * to touch the high mapped kernel as well:
 	 */
-	if (!within(cpa->pfn, highmap_start_pfn(), highmap_end_pfn()))
-		return 0;
-
-	alias_cpa = *cpa;
-	temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
-	alias_cpa.vaddr = &temp_cpa_vaddr;
-	alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
+	if (within(cpa->pfn, highmap_start_pfn(), highmap_end_pfn())) {
+		alias_cpa = *cpa;
+		temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) +
+				 __START_KERNEL_map - phys_base;
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
+		return 0;
+	}
 #endif
-	return ret;
+
+	return 0;
 }
 
 static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
-- 
1.6.0.2

