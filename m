Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbZATWUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbZATWUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbZATWUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:20:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:12432 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516AbZATWUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:20:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,297,1231142400"; 
   d="scan'208";a="102058214"
Date: Tue, 20 Jan 2009 14:20:21 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, yinghai@kernel.org
Cc: venkatesh.pallipadi@intel.com, akpm@linux-foundation.org,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       jaswinderlinux@gmail.com, just.for.lkml@googlemail.com, npiggin@suse.de
Subject: [patch] x86: fix page attribute corruption with cpa()
Message-ID: <20090120222021.GB28352@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a performance issue reported by Linus on his
Nehalem system. While Linus reverted the PAT patch (commit
58dab916dfb57328d50deb0aa9b3fc92efa248ff) which exposed the issue,
existing cpa() code can potentially still cause wrong(page attribute
corruption) behavior.

This patch also fixes the "WARNING: at arch/x86/mm/pageattr.c:560" that
various people reported.

---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: fix page attribute corruption with cpa()

In 64bit kernel, kernel identity mapping might have holes depending
on the available memory and how e820 reports the address range
covering the RAM, ACPI, PCI reserved regions. If there is a 2MB/1GB hole
in the address range that is not listed by e820 entries, kernel identity
mapping will have a corresponding hole in its 1-1 identity mapping.

If cpa() happens on the kernel identity mapping which falls into these holes,
existing code fails like this:

	__change_page_attr_set_clr()
		__change_page_attr()
			returns 0 because of if (!kpte). But doesn't
			set cpa->numpages and cpa->pfn.
		cpa_process_alias()
			uses uninitialized cpa->pfn (random value)
			which can potentially lead to changing the page
			attribute of kernel text/data, kernel identity
			mapping of RAM pages etc. oops!

This bug was easily exposed by another PAT patch which was doing
cpa() more often on kernel identity mapping holes (physical range between
max_low_pfn_mapped and 4GB), where in here it was setting the
cache disable attribute(PCD) for kernel identity mappings aswell.

Fix cpa() to handle the kernel identity mapping holes. Retain
the WARN() for cpa() calls to other not present address ranges
(kernel-text/data, ioremap() addresses)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: stable@kernel.org
---

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e89d248..84ba748 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -534,6 +534,36 @@ out_unlock:
 	return 0;
 }
 
+static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
+			       int primary)
+{
+	/*
+	 * Ignore all non primary paths.
+	 */
+	if (!primary)
+		return 0;
+
+	/*
+	 * Ignore the NULL PTE for kernel identity mapping, as it is expected
+	 * to have holes.
+	 * Also set numpages to '1' indicating that we processed cpa req for
+	 * one virtual address page and its pfn. TBD: numpages can be set based
+	 * on the initial value and the level returned by lookup_address().
+	 */
+	if (within(vaddr, PAGE_OFFSET,
+		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
+		cpa->numpages = 1;
+		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
+		return 0;
+	} else {
+		WARN(1, KERN_WARNING "CPA: called for zero pte. "
+			"vaddr = %lx cpa->vaddr = %lx\n", vaddr,
+			*cpa->vaddr);
+
+		return -EFAULT;
+	}
+}
+
 static int __change_page_attr(struct cpa_data *cpa, int primary)
 {
 	unsigned long address;
@@ -549,17 +579,11 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 repeat:
 	kpte = lookup_address(address, &level);
 	if (!kpte)
-		return 0;
+		return __cpa_process_fault(cpa, address, primary);
 
 	old_pte = *kpte;
-	if (!pte_val(old_pte)) {
-		if (!primary)
-			return 0;
-		WARN(1, KERN_WARNING "CPA: called for zero pte. "
-		       "vaddr = %lx cpa->vaddr = %lx\n", address,
-		       *cpa->vaddr);
-		return -EINVAL;
-	}
+	if (!pte_val(old_pte))
+		return __cpa_process_fault(cpa, address, primary);
 
 	if (level == PG_LEVEL_4K) {
 		pte_t new_pte;
@@ -657,12 +681,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		vaddr = *cpa->vaddr;
 
 	if (!(within(vaddr, PAGE_OFFSET,
-		    PAGE_OFFSET + (max_low_pfn_mapped << PAGE_SHIFT))
-#ifdef CONFIG_X86_64
-		|| within(vaddr, PAGE_OFFSET + (1UL<<32),
-		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))
-#endif
-	)) {
+		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))) {
 
 		alias_cpa = *cpa;
 		temp_cpa_vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
