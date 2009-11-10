Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZKJJXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZKJJXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZKJJXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:23:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036AbZKJJXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:23:33 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Ingo Molnar <mingo@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH -tip  2/2] x86: PAT remove ioremap_default
Date: Tue, 10 Nov 2009 17:23:25 +0800
Message-Id: <1257845005-7938-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b6ff32 consolidates reserve_memtype and pat_x_mtrr_type, this
makes ioremap_default same as ioremap_cache. Remove the redundant
function and change the only caller to use ioremap_cache.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/mm/ioremap.c |   26 +-------------------------
 1 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 2feb9bd..c246d25 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -281,30 +281,6 @@ void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap_cache);
 
-static void __iomem *ioremap_default(resource_size_t phys_addr,
-					unsigned long size)
-{
-	unsigned long flags;
-	void __iomem *ret;
-	int err;
-
-	/*
-	 * - WB for WB-able memory and no other conflicting mappings
-	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
-	 * - Inherit from confliting mappings otherwise
-	 */
-	err = reserve_memtype(phys_addr, phys_addr + size,
-				_PAGE_CACHE_WB, &flags);
-	if (err < 0)
-		return NULL;
-
-	ret = __ioremap_caller(phys_addr, size, flags,
-			       __builtin_return_address(0));
-
-	free_memtype(phys_addr, phys_addr + size);
-	return ret;
-}
-
 void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
 				unsigned long prot_val)
 {
@@ -380,7 +356,7 @@ void *xlate_dev_mem_ptr(unsigned long phys)
 	if (page_is_ram(start >> PAGE_SHIFT))
 		return __va(phys);
 
-	addr = (void __force *)ioremap_default(start, PAGE_SIZE);
+	addr = (void __force *)ioremap_cache(start, PAGE_SIZE);
 	if (addr)
 		addr = (void *)((unsigned long)addr | (phys & ~PAGE_MASK));
 
-- 
1.6.2.5

