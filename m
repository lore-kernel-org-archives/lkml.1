Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbYHUAMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbYHUAMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbYHUAL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:11:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:10491 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbYHUAL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:11:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,242,1217833200"; 
   d="scan'208";a="430926496"
Message-Id: <20080820234604.469656000@intel.com>
References: <20080820234550.923970000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Aug 2008 16:45:52 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 2/4] x86: PAT Change /dev/mem mmap with O_SYNC to use UC_MINUS
Content-Disposition: inline; filename=osync_as_ucminus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All kernel mappings like ioremap(), etc uses UC_MINUS as the type. /dev/mem
mappings with /dev/mem being opened with O_SYNC however was using UC,
resulting in a conflict with /dev/mem mmap failing. This seems to be
affecting some apps (one being flashrom) which are using O_SYNC and which were
working before.

Switch /dev/mem with O_SYNC also to UC_MINUS.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/pat.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

Index: tip/arch/x86/mm/pat.c
===================================================================
--- tip.orig/arch/x86/mm/pat.c	2008-08-20 14:25:18.000000000 -0700
+++ tip/arch/x86/mm/pat.c	2008-08-20 14:26:35.000000000 -0700
@@ -390,14 +390,6 @@ int free_memtype(u64 start, u64 end)
 }
 
 
-/*
- * /dev/mem mmap interface. The memtype used for mapping varies:
- * - Use UC for mappings with O_SYNC flag
- * - Without O_SYNC flag, if there is any conflict in reserve_memtype,
- *   inherit the memtype from existing mapping.
- * - Else use UC_MINUS memtype (for backward compatibility with existing
- *   X drivers.
- */
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t vma_prot)
 {
@@ -435,14 +427,14 @@ int phys_mem_access_prot_allowed(struct 
 				unsigned long size, pgprot_t *vma_prot)
 {
 	u64 offset = ((u64) pfn) << PAGE_SHIFT;
-	unsigned long flags = _PAGE_CACHE_UC_MINUS;
+	unsigned long flags = -1;
 	int retval;
 
 	if (!range_is_allowed(pfn, size))
 		return 0;
 
 	if (file->f_flags & O_SYNC) {
-		flags = _PAGE_CACHE_UC;
+		flags = _PAGE_CACHE_UC_MINUS;
 	}
 
 #ifdef CONFIG_X86_32
@@ -465,13 +457,14 @@ int phys_mem_access_prot_allowed(struct 
 #endif
 
 	/*
-	 * With O_SYNC, we can only take UC mapping. Fail if we cannot.
+	 * With O_SYNC, we can only take UC_MINUS mapping. Fail if we cannot.
+	 *
 	 * Without O_SYNC, we want to get
 	 * - WB for WB-able memory and no other conflicting mappings
 	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
 	 * - Inherit from confliting mappings otherwise
 	 */
-	if (flags != _PAGE_CACHE_UC_MINUS) {
+	if (flags != -1) {
 		retval = reserve_memtype(offset, offset + size, flags, NULL);
 	} else {
 		retval = reserve_memtype(offset, offset + size, -1, &flags);

-- 

