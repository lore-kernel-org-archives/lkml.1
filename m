Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbZCDTWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbZCDTWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbZCDTWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:22:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:54535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937AbZCDTWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:22:14 -0500
Date: Wed, 4 Mar 2009 19:21:36 GMT
From: Huang Ying <ying.huang@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
       mingo@redhat.com, yinghai@kernel.org, bmaly@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, yinghai@kernel.org, bmaly@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236135513.6204.306.camel@yhuang-dev.sh.intel.com>
References: <1236135513.6204.306.camel@yhuang-dev.sh.intel.com>
Subject: [tip:x86/mm] x86: EFI: Back efi_ioremap with init_memory_mapping instead of FIX_MAP
Message-ID: <tip-dd39ecf522ba86c70809715af46e6557f6491131@git.kernel.org>
Git-Commit-ID: dd39ecf522ba86c70809715af46e6557f6491131
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 19:21:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd39ecf522ba86c70809715af46e6557f6491131
Gitweb:     http://git.kernel.org/tip/dd39ecf522ba86c70809715af46e6557f6491131
Author:     "Huang Ying" <ying.huang@intel.com>
AuthorDate: Wed, 4 Mar 2009 10:58:33 +0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 19:20:16 +0100

x86: EFI: Back efi_ioremap with init_memory_mapping instead of FIX_MAP

Impact: Fix boot failure on EFI system with large runtime memory range

Brian Maly reported that some EFI system with large runtime memory
range can not boot. Because the FIX_MAP used to map runtime memory
range is smaller than run time memory range.

This patch fixes this issue by re-implement efi_ioremap() with
init_memory_mapping().

Reported-and-tested-by: Brian Maly <bmaly@redhat.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Brian Maly <bmaly@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236135513.6204.306.camel@yhuang-dev.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/efi.h       |    2 --
 arch/x86/include/asm/fixmap_64.h |    4 ----
 arch/x86/kernel/efi.c            |    7 +++++--
 arch/x86/kernel/efi_64.c         |   21 ++++-----------------
 4 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index ca5ffb2..edc90f2 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -37,8 +37,6 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
-#define MAX_EFI_IO_PAGES	100
-
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
diff --git a/arch/x86/include/asm/fixmap_64.h b/arch/x86/include/asm/fixmap_64.h
index 00a30ab..8be7409 100644
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -16,7 +16,6 @@
 #include <asm/apicdef.h>
 #include <asm/page.h>
 #include <asm/vsyscall.h>
-#include <asm/efi.h>
 
 /*
  * Here we define all the compile-time 'special' virtual
@@ -43,9 +42,6 @@ enum fixed_addresses {
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 	FIX_IO_APIC_BASE_0,
 	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS - 1,
-	FIX_EFI_IO_MAP_LAST_PAGE,
-	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE
-				  + MAX_EFI_IO_PAGES - 1,
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 1119d24..eb1ef3b 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -467,7 +467,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab, addr, npages;
+	u64 end, systab, addr, npages, end_pfn;
 	void *p, *va;
 
 	efi.systab = NULL;
@@ -479,7 +479,10 @@ void __init efi_enter_virtual_mode(void)
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
 
-		if (PFN_UP(end) <= max_low_pfn_mapped)
+		end_pfn = PFN_UP(end);
+		if (end_pfn <= max_low_pfn_mapped
+		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
+			&& end_pfn <= max_pfn_mapped))
 			va = __va(md->phys_addr);
 		else
 			va = efi_ioremap(md->phys_addr, size);
diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/kernel/efi_64.c
index 652c528..cb783b9 100644
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -99,24 +99,11 @@ void __init efi_call_phys_epilog(void)
 
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size)
 {
-	static unsigned pages_mapped __initdata;
-	unsigned i, pages;
-	unsigned long offset;
+	unsigned long last_map_pfn;
 
-	pages = PFN_UP(phys_addr + size) - PFN_DOWN(phys_addr);
-	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
-
-	if (pages_mapped + pages > MAX_EFI_IO_PAGES)
+	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
+	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size)
 		return NULL;
 
-	for (i = 0; i < pages; i++) {
-		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
-			     phys_addr, PAGE_KERNEL);
-		phys_addr += PAGE_SIZE;
-		pages_mapped++;
-	}
-
-	return (void __iomem *)__fix_to_virt(FIX_EFI_IO_MAP_FIRST_PAGE - \
-					     (pages_mapped - pages)) + offset;
+	return (void __iomem *)__va(phys_addr);
 }
