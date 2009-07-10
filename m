Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZGJRCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZGJRCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:02:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZGJQ7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:7792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbZGJQ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777339"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 09/10] x86, PAT: lookup the protection from memtype list on vm_insert_pfn()
Date: Fri, 10 Jul 2009 09:57:40 -0700
Message-Id: <d21ca9019989911369192a5f6e3317ef55ac8fb8.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <f1bc76700599173408bf67167efc49027d70d98b.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
 <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
 <cf6926fb54db50cb0758c4213fe39354c3850157.1247162373.git.venkatesh.pallipadi@intel.com>
 <cdf060718f1e13a3ae2f102d363eb0e25d25c74c.1247162373.git.venkatesh.pallipadi@intel.com>
 <5f0d51bf79a36ebb7c65ab0b80e5018438fe8a77.1247162373.git.venkatesh.pallipadi@intel.com>
 <3a66cb82f9810b9ecc942694b1bb23db7fff8ab2.1247162373.git.venkatesh.pallipadi@intel.com>
 <d165be9f92bc753ebe685b66b512a8fd36205d42.1247162373.git.venkatesh.pallipadi@intel.com>
 <9b94ff556a45738ea3bf5756662ed605c2a8f16f.1247162373.git.venkatesh.pallipadi@intel.com>
 <f1bc76700599173408bf67167efc49027d70d98b.1247162373.git.venkatesh.pallipadi@intel.com>
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lookup the reserved memtype during vm_insert_pfn and use that memtype
for the new mapping. This takes care or handling of vm_insert_pfn()
interface in track_pfn_vma*/untrack_pfn_vma.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 71aa6f7..b629f75 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -848,11 +848,6 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
 	pgprot_t pgprot;
 
-	/*
-	 * For now, only handle remap_pfn_range() vmas where
-	 * is_linear_pfn_mapping() == TRUE. Handling of
-	 * vm_insert_pfn() is TBD.
-	 */
 	if (is_linear_pfn_mapping(vma)) {
 		/*
 		 * reserve the whole chunk covered by vma. We need the
@@ -880,20 +875,24 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
+	unsigned long flags;
 	resource_size_t paddr;
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
 
-	/*
-	 * For now, only handle remap_pfn_range() vmas where
-	 * is_linear_pfn_mapping() == TRUE. Handling of
-	 * vm_insert_pfn() is TBD.
-	 */
 	if (is_linear_pfn_mapping(vma)) {
 		/* reserve the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
 		return reserve_pfn_range(paddr, vma_size, prot, 0);
 	}
 
+	if (!pat_enabled)
+		return 0;
+
+	/* for vm_insert_pfn and friends, we set prot based on lookup */
+	flags = lookup_memtype(pfn << PAGE_SHIFT);
+	*prot = __pgprot((pgprot_val(vma->vm_page_prot) & (~_PAGE_CACHE_MASK)) |
+			 flags);
+
 	return 0;
 }
 
@@ -908,11 +907,6 @@ void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
 	resource_size_t paddr;
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
 
-	/*
-	 * For now, only handle remap_pfn_range() vmas where
-	 * is_linear_pfn_mapping() == TRUE. Handling of
-	 * vm_insert_pfn() is TBD.
-	 */
 	if (is_linear_pfn_mapping(vma)) {
 		/* free the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-- 
1.6.0.6

