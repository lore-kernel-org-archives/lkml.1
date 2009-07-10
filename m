Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbZGJRAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbZGJRAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZGJQ7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:7787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbZGJQ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777314"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 02/10] x86, PAT: ioremap to follow same PAT restrictions as other PAT users
Date: Fri, 10 Jul 2009 09:57:33 -0700
Message-Id: <cf6926fb54db50cb0758c4213fe39354c3850157.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
 <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap has this hard-coded check for new type and requested type. That
check differs from other PAT users like /dev/mem mmap, remap_pfn_range
in only one condition where requested type is UC_MINUS and new type
is WC. Under that condition, ioremap fails. But other PAT interfaces succeed
with a WC mapping.

Change to make ioremap be in sync with other PAT APIs and use the same
macro as others. Also changes the error print to KERN_ERR instead of
pr_debug.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/ioremap.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 8a45093..aeaea8c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -228,24 +228,13 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	retval = reserve_memtype(phys_addr, (u64)phys_addr + size,
 						prot_val, &new_prot_val);
 	if (retval) {
-		pr_debug("Warning: reserve_memtype returned %d\n", retval);
+		printk(KERN_ERR "ioremap reserve_memtype failed %d\n", retval);
 		return NULL;
 	}
 
 	if (prot_val != new_prot_val) {
-		/*
-		 * Do not fallback to certain memory types with certain
-		 * requested type:
-		 * - request is uc-, return cannot be write-back
-		 * - request is uc-, return cannot be write-combine
-		 * - request is write-combine, return cannot be write-back
-		 */
-		if ((prot_val == _PAGE_CACHE_UC_MINUS &&
-		     (new_prot_val == _PAGE_CACHE_WB ||
-		      new_prot_val == _PAGE_CACHE_WC)) ||
-		    (prot_val == _PAGE_CACHE_WC &&
-		     new_prot_val == _PAGE_CACHE_WB)) {
-			pr_debug(
+		if (!is_new_memtype_allowed(prot_val, new_prot_val)) {
+			printk(KERN_ERR
 		"ioremap error for 0x%llx-0x%llx, requested 0x%lx, got 0x%lx\n",
 				(unsigned long long)phys_addr,
 				(unsigned long long)(phys_addr + size),
-- 
1.6.0.6

