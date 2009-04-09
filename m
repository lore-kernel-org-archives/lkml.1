Return-Path: <linux-kernel-owner+w=401wt.eu-S936976AbZDIWNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936976AbZDIWNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765663AbZDIWLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:11:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:3719 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846AbZDIWLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:11:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,163,1239001200"; 
   d="scan'208";a="505147732"
Message-Id: <20090409212708.939936000@intel.com>
References: <20090409212646.511925000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 09 Apr 2009 14:26:51 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 5/6] x86, PAT: Consolidate code in pat_x_mtrr_type() and reserve_memtype()
Content-Disposition: inline; filename=0005-x86-PAT-Consolidate-code-in-pat_x_mtrr_type-and.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 5/6] x86, PAT: Consolidate code in pat_x_mtrr_type() and reserve_memtype()

Fix pat_x_mtrr_type() to use UC_MINUS when the mtrr type return UC. This
is to be  consistent with ioremap() and ioremap_nocache() which uses
UC_MINUS.

Consolidate the code such that reserve_memtype() also uses
pat_x_mtrr_type() when the caller doesn't specify any special attribute
(non WB attribute).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/mm/ioremap.c |    3 ++-
 arch/x86/mm/pat.c     |   35 +++++++++++++----------------------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 329387e..d4c4b2c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -375,7 +375,8 @@ static void __iomem *ioremap_default(resource_size_t phys_addr,
 	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
 	 * - Inherit from confliting mappings otherwise
 	 */
-	err = reserve_memtype(phys_addr, phys_addr + size, -1, &flags);
+	err = reserve_memtype(phys_addr, phys_addr + size,
+				_PAGE_CACHE_WB, &flags);
 	if (err < 0)
 		return NULL;
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 95d3b1a..3c8624c 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -182,10 +182,10 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 		u8 mtrr_type;
 
 		mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type == MTRR_TYPE_UNCACHABLE)
-			return _PAGE_CACHE_UC;
-		if (mtrr_type == MTRR_TYPE_WRCOMB)
-			return _PAGE_CACHE_WC;
+		if (mtrr_type != MTRR_TYPE_WRBACK)
+			return _PAGE_CACHE_UC_MINUS;
+
+		return _PAGE_CACHE_WB;
 	}
 
 	return req_type;
@@ -352,23 +352,13 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return 0;
 	}
 
-	if (req_type == -1) {
-		/*
-		 * Call mtrr_lookup to get the type hint. This is an
-		 * optimization for /dev/mem mmap'ers into WB memory (BIOS
-		 * tools and ACPI tools). Use WB request for WB memory and use
-		 * UC_MINUS otherwise.
-		 */
-		u8 mtrr_type = mtrr_type_lookup(start, end);
-
-		if (mtrr_type == MTRR_TYPE_WRBACK)
-			actual_type = _PAGE_CACHE_WB;
-		else
-			actual_type = _PAGE_CACHE_UC_MINUS;
-	} else {
-		actual_type = pat_x_mtrr_type(start, end,
-					      req_type & _PAGE_CACHE_MASK);
-	}
+	/*
+	 * Call mtrr_lookup to get the type hint. This is an
+	 * optimization for /dev/mem mmap'ers into WB memory (BIOS
+	 * tools and ACPI tools). Use WB request for WB memory and use
+	 * UC_MINUS otherwise.
+	 */
+	actual_type = pat_x_mtrr_type(start, end, req_type & _PAGE_CACHE_MASK);
 
 	if (new_type)
 		*new_type = actual_type;
@@ -587,7 +577,8 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 	if (flags != -1) {
 		retval = reserve_memtype(offset, offset + size, flags, NULL);
 	} else {
-		retval = reserve_memtype(offset, offset + size, -1, &flags);
+		retval = reserve_memtype(offset, offset + size,
+					_PAGE_CACHE_WB, &flags);
 	}
 
 	if (retval < 0)
-- 
1.6.0.6

-- 

