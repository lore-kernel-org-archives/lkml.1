Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZGJRAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZGJRAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZGJQ7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:7780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbZGJQ7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777311"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 01/10] x86, PAT: keep identity maps consistent with mmaps even when pat_disabled
Date: Fri, 10 Jul 2009 09:57:32 -0700
Message-Id: <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make reserve_memtype internally take care of pat disabled case and fallback
to default return values.

Remove the specific pat_disabled checks in track_* routines.

Change kernel_map_sync_memtype to sync identity map even when
pat_disabled.

This change ensures that, even for pat_disabled case, we take care of
keeping identity map in sync. Before this patch, in pat disabled case,
ioremap() keeps the identity maps in sync and other APIs like pci and
/dev/mem mmap don't, which is not a very consistent behavior.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e6718bb..d5af279 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -339,6 +339,8 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		if (new_type) {
 			if (req_type == -1)
 				*new_type = _PAGE_CACHE_WB;
+			else if (req_type == _PAGE_CACHE_WC)
+				*new_type = _PAGE_CACHE_UC_MINUS;
 			else
 				*new_type = req_type & _PAGE_CACHE_MASK;
 		}
@@ -577,7 +579,7 @@ int kernel_map_sync_memtype(u64 base, unsigned long size, unsigned long flags)
 {
 	unsigned long id_sz;
 
-	if (!pat_enabled || base >= __pa(high_memory))
+	if (base >= __pa(high_memory))
 		return 0;
 
 	id_sz = (__pa(high_memory) < base + size) ?
@@ -677,9 +679,6 @@ int track_pfn_vma_copy(struct vm_area_struct *vma)
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
 	pgprot_t pgprot;
 
-	if (!pat_enabled)
-		return 0;
-
 	/*
 	 * For now, only handle remap_pfn_range() vmas where
 	 * is_linear_pfn_mapping() == TRUE. Handling of
@@ -715,9 +714,6 @@ int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 	resource_size_t paddr;
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
 
-	if (!pat_enabled)
-		return 0;
-
 	/*
 	 * For now, only handle remap_pfn_range() vmas where
 	 * is_linear_pfn_mapping() == TRUE. Handling of
@@ -743,9 +739,6 @@ void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
 	resource_size_t paddr;
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
 
-	if (!pat_enabled)
-		return;
-
 	/*
 	 * For now, only handle remap_pfn_range() vmas where
 	 * is_linear_pfn_mapping() == TRUE. Handling of
-- 
1.6.0.6

