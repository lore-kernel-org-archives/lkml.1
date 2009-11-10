Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZKJJna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZKJJna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbZKJJn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:43:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:42592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988AbZKJJn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:43:28 -0500
Date: Tue, 10 Nov 2009 09:43:02 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
In-Reply-To: <1257845005-7938-1-git-send-email-dfeng@redhat.com>
References: <1257845005-7938-1-git-send-email-dfeng@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] x86: pat: Remove ioremap_default()
Message-ID: <tip-2fb8f4e6a83dcaec15c1dd0ee8a6f618e7ece7f0@git.kernel.org>
Git-Commit-ID: 2fb8f4e6a83dcaec15c1dd0ee8a6f618e7ece7f0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fb8f4e6a83dcaec15c1dd0ee8a6f618e7ece7f0
Gitweb:     http://git.kernel.org/tip/2fb8f4e6a83dcaec15c1dd0ee8a6f618e7ece7f0
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Tue, 10 Nov 2009 17:23:25 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 10:34:05 +0100

x86: pat: Remove ioremap_default()

Commit:

  b6ff32d: x86, PAT: Consolidate code in pat_x_mtrr_type() and reserve_memtype()

consolidated reserve_memtype() and pat_x_mtrr_type,
this made ioremap_default() same as ioremap_cache().

Remove the redundant function and change the only caller to use
ioremap_cache.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <1257845005-7938-1-git-send-email-dfeng@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |   26 +-------------------------
 1 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 334e63c..3af10de 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -283,30 +283,6 @@ void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
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
@@ -382,7 +358,7 @@ void *xlate_dev_mem_ptr(unsigned long phys)
 	if (page_is_ram(start >> PAGE_SHIFT))
 		return __va(phys);
 
-	addr = (void __force *)ioremap_default(start, PAGE_SIZE);
+	addr = (void __force *)ioremap_cache(start, PAGE_SIZE);
 	if (addr)
 		addr = (void *)((unsigned long)addr | (phys & ~PAGE_MASK));
 
