Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbYHRCS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbYHRCS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 22:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbYHRCST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 22:18:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:2320 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbYHRCSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 22:18:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,225,1217833200"; 
   d="scan'208";a="326922433"
Subject: [patch]pageattr: cache flush before tlb flush
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 10:27:31 +0800
Message-Id: <1219026451.16428.4.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clflush uses a virtual address but cache line is physical indexed in
x86. In my understanding, clflush will do some pagetable walk, so doing
cache flush first should reduce some pagetable walk.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f5f5154..d8b24df 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -168,10 +168,8 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 	BUG_ON(irqs_disabled());
 	WARN_ON(PAGE_ALIGN(start) != start);
 
-	on_each_cpu(__cpa_flush_range, NULL, 1);
-
 	if (!cache)
-		return;
+		goto tlb_flush;
 
 	/*
 	 * We only need to flush on one CPU,
@@ -188,6 +186,9 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 		if (pte && (pte_val(*pte) & _PAGE_PRESENT))
 			clflush_cache_range((void *) addr, PAGE_SIZE);
 	}
+
+tlb_flush:
+	on_each_cpu(__cpa_flush_range, NULL, 1);
 }
 
 /*


