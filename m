Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbYFJOHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbYFJOHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYFJOH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:07:28 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:29152 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbYFJOH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:07:26 -0400
X-BigFish: VPS4(zzzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K2937Z-02-AXR-01
Date: Tue, 10 Jun 2008 16:06:21 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 4/5] x86: rename pat_wc_enabled to pat_enabled
Message-ID: <20080610140621.GH5024@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Jun 2008 14:06:15.0833 (UTC) FILETIME=[25B9C090:01C8CB03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, what does pat_wc_enabled stand for? Does it mean
"write-combining"?

Currently it is used to globally switch on or off PAT support.
Thus I renamed it to pat_enabled.
I think this increases readability (and hope that I didn't miss
something).

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/ioremap.c  |    4 ++--
 arch/x86/mm/pageattr.c |    2 +-
 arch/x86/mm/pat.c      |   16 ++++++++--------
 arch/x86/pci/i386.c    |    4 ++--
 include/asm-x86/pat.h  |    4 ++--
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 71bb315..ddeafed 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -261,7 +261,7 @@ void __iomem *ioremap_nocache(resource_size_t phys_addr, unsigned long size)
 {
 	/*
 	 * Ideally, this should be:
-	 *	pat_wc_enabled ? _PAGE_CACHE_UC : _PAGE_CACHE_UC_MINUS;
+	 *	pat_enabled ? _PAGE_CACHE_UC : _PAGE_CACHE_UC_MINUS;
 	 *
 	 * Till we fix all X drivers to use ioremap_wc(), we will use
 	 * UC MINUS.
@@ -285,7 +285,7 @@ EXPORT_SYMBOL(ioremap_nocache);
  */
 void __iomem *ioremap_wc(unsigned long phys_addr, unsigned long size)
 {
-	if (pat_wc_enabled)
+	if (pat_enabled)
 		return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
 					__builtin_return_address(0));
 	else
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 60bcb5b..6916fe4 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -805,7 +805,7 @@ int _set_memory_wc(unsigned long addr, int numpages)
 
 int set_memory_wc(unsigned long addr, int numpages)
 {
-	if (!pat_wc_enabled)
+	if (!pat_enabled)
 		return set_memory_uc(addr, numpages);
 
 	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index c9a3074..2f6c33d 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -26,11 +26,11 @@
 #include <asm/io.h>
 
 #ifdef CONFIG_X86_PAT
-int __read_mostly pat_wc_enabled = 1;
+int __read_mostly pat_enabled = 1;
 
 void __cpuinit pat_disable(char *reason)
 {
-	pat_wc_enabled = 0;
+	pat_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
 }
 
@@ -72,7 +72,7 @@ void pat_init(void)
 {
 	u64 pat;
 
-	if (!pat_wc_enabled)
+	if (!pat_enabled)
 		return;
 
 	/* Paranoia check. */
@@ -224,8 +224,8 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	unsigned long actual_type;
 	int err = 0;
 
-	/* Only track when pat_wc_enabled */
-	if (!pat_wc_enabled) {
+	/* Only track when pat_enabled */
+	if (!pat_enabled) {
 		/* This is identical to page table setting without PAT */
 		if (ret_type) {
 			if (req_type == -1) {
@@ -441,8 +441,8 @@ int free_memtype(u64 start, u64 end)
 	struct memtype *ml;
 	int err = -EINVAL;
 
-	/* Only track when pat_wc_enabled */
-	if (!pat_wc_enabled) {
+	/* Only track when pat_enabled */
+	if (!pat_enabled) {
 		return 0;
 	}
 
@@ -536,7 +536,7 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 	 * caching for the high addresses through the KEN pin, but
 	 * we maintain the tradition of paranoia in this code.
 	 */
-	if (!pat_wc_enabled &&
+	if (!pat_enabled &&
 	    !(boot_cpu_has(X86_FEATURE_MTRR) ||
 	      boot_cpu_has(X86_FEATURE_K6_MTRR) ||
 	      boot_cpu_has(X86_FEATURE_CYRIX_ARR) ||
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 10fb308..6ccd7a1 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -299,9 +299,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		return -EINVAL;
 
 	prot = pgprot_val(vma->vm_page_prot);
-	if (pat_wc_enabled && write_combine)
+	if (pat_enabled && write_combine)
 		prot |= _PAGE_CACHE_WC;
-	else if (pat_wc_enabled || boot_cpu_data.x86 > 3)
+	else if (pat_enabled || boot_cpu_data.x86 > 3)
 		/*
 		 * ioremap() and ioremap_nocache() defaults to UC MINUS for now.
 		 * To avoid attribute conflicts, request UC MINUS here
diff --git a/include/asm-x86/pat.h b/include/asm-x86/pat.h
index 6fa9710..7edc473 100644
--- a/include/asm-x86/pat.h
+++ b/include/asm-x86/pat.h
@@ -4,10 +4,10 @@
 #include <linux/types.h>
 
 #ifdef CONFIG_X86_PAT
-extern int pat_wc_enabled;
+extern int pat_enabled;
 extern void validate_pat_support(struct cpuinfo_x86 *c);
 #else
-static const int pat_wc_enabled;
+static const int pat_enabled;
 static inline void validate_pat_support(struct cpuinfo_x86 *c) { }
 #endif
 
-- 
1.5.5.3



