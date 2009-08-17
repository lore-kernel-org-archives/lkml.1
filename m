Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbZHQUYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbZHQUYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbZHQUYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:24:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:39232 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbZHQUYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,398,1246863600"; 
   d="scan'208";a="484284723"
Subject: [patch] x86, pat: allow ISA memory range uncacheable mapping
 requests
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: venkatesh.pallipadi@intel.com, xam@debian.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 17 Aug 2009 13:23:50 -0700
Message-Id: <1250540630.2709.193.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Vozeler reported:
>  Bug 13877 -  bogl-term broken with CONFIG_X86_PAT=y, works with =n  
>
>  strace of bogl-term:
>  814   mmap2(NULL, 65536, PROT_READ|PROT_WRITE, MAP_SHARED, 4, 0)
>				 = -1 EAGAIN (Resource temporarily unavailable)
>  814   write(2, "bogl: mmaping /dev/fb0: Resource temporarily unavailable\n",
>	       57) = 57

PAT code maps the ISA memory range as WB in the PAT attribute, so that
fixed range MTRR registers define the actual memory type (UC/WC/WT etc).

But the upper level is_new_memtype_allowed() API checks are failing,
as the request here is for UC and the return tracked type is WB (Tracked type is
WB as MTRR type for this legacy range potentially will be different for each
4k page).

Fix is_new_memtype_allowed() by always succeeding the ISA address range
checks, as the null PAT (WB) and def MTRR fixed range register settings
satisfy the memory type needs of the applications that map the ISA address
range.

Reported-and-Tested-by: Max Vozeler <xam@debian.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 9de8729..5d2774e 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_PGTABLE_H
 
 #include <asm/page.h>
+#include <asm/e820.h>
 
 #include <asm/pgtable_types.h>
 
@@ -274,10 +275,17 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 
 #define canon_pgprot(p) __pgprot(massage_pgprot(p))
 
-static inline int is_new_memtype_allowed(unsigned long flags,
-						unsigned long new_flags)
+static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
+					 unsigned long flags,
+					 unsigned long new_flags)
 {
 	/*
+ 	 * PAT type is always WB for ISA. So no need to check.
+ 	 */
+	if (is_ISA_range(paddr, paddr + size - 1))
+		return 1;
+	
+	/*
 	 * Certain new memtypes are not allowed with certain
 	 * requested memtype:
 	 * - request is uncached, return cannot be write-back
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e6718bb..352aa9e 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -623,7 +623,8 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 		return ret;
 
 	if (flags != want_flags) {
-		if (strict_prot || !is_new_memtype_allowed(want_flags, flags)) {
+		if (strict_prot ||
+		    !is_new_memtype_allowed(paddr, size, want_flags, flags)) {
 			free_memtype(paddr, paddr + size);
 			printk(KERN_ERR "%s:%d map pfn expected mapping type %s"
 				" for %Lx-%Lx, got %s\n",


