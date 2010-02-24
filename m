Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab0BXVzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:55:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:34264 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221Ab0BXVzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:55:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,534,1262592000"; 
   d="scan'208";a="543669966"
Subject: [patch] x86, cpa: consider alias mapping changes also in the flush
 tlb decisions
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 24 Feb 2010 13:54:18 -0800
Message-Id: <1267048458.5149.34.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page attributes like RWX may be different for the kernel mappings
and its aliases. So it is quite possible that the change page attribute of
main mapping may not change any attribute and hence no flush tlb is necessary.
But cpa() of the kernel alias mappings may change the attributes and hence
we need to consider the result of cpa_process_alias() in making a decision
for flushing the tlb.

We haven't seen a problem yet because of this issue, as all the current usages
result in an attribute change of main mapping and the alias mapping may or
maynot change. But the current code can break easily if there is any usage
of cpa() where the main mapping doesn't change the attribute but the alias
mapping can (on 64bit kernel, original cpa() using the kernel identity mapping
vs the kernel text mapping can behave differently because of this bug).

Fix it by forwarding the CPA_FLUSHTLB flag from the alias_cpa to the
original cpa.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index cf07c26..cc62a0d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -757,6 +757,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
+		cpa->flags |= (alias_cpa.flags & CPA_FLUSHTLB);
 		if (ret)
 			return ret;
 	}
@@ -780,6 +781,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		 * return value.
 		 */
 		__change_page_attr_set_clr(&alias_cpa, 0);
+		cpa->flags |= (alias_cpa.flags & CPA_FLUSHTLB);
 	}
 #endif
 


