Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbYCXVsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbYCXVsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYCXVsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:48:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:11849 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbYCXVsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:48:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,548,1199692800"; 
   d="scan'208";a="359864081"
Date: Mon, 24 Mar 2008 14:39:55 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: [PATCH] x86: PAT bug fix for attribute type check after reserve_memtype
Message-ID: <20080324213955.GA10456@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bug fixes for reserve_memtype() call in __ioremap and pci_mmap_page_range().
If reserve_memtype returns non-zero, then it is an error and subsequent free is
not required. Requested and returned prot value check should be done when
reserve_memtype returns success.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/mm/ioremap.c |   11 +++++++++--
 arch/x86/pci/i386.c   |    7 ++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

Index: linux-2.6-x86.git/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/ioremap.c	2008-03-21 08:28:47.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/ioremap.c	2008-03-24 06:59:09.000000000 -0700
@@ -126,6 +126,7 @@ static void __iomem *__ioremap(unsigned 
 	unsigned long new_prot_val;
 	pgprot_t prot;
 	void __iomem *ret_addr;
+	int retval;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
@@ -165,8 +166,14 @@ static void __iomem *__ioremap(unsigned 
 	phys_addr &= PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
-	if (reserve_memtype(phys_addr, phys_addr + size,
-	                    prot_val, &new_prot_val)) {
+	retval = reserve_memtype(phys_addr, phys_addr + size,
+						prot_val, &new_prot_val);
+	if (retval) {
+		printk("reserve_memtype returned %d\n", retval);
+		return NULL;
+	}
+
+	if (prot_val != new_prot_val) {
 		/*
 		 * Do not fallback to certain memory types with certain
 		 * requested type:
Index: linux-2.6-x86.git/arch/x86/pci/i386.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/pci/i386.c	2008-03-21 08:28:47.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/pci/i386.c	2008-03-24 07:01:22.000000000 -0700
@@ -328,6 +328,7 @@ int pci_mmap_page_range(struct pci_dev *
 	unsigned long len = vma->vm_end - vma->vm_start;
 	unsigned long flags;
 	unsigned long new_flags;
+	int retval;
 
 	/* I/O space cannot be accessed via normal processor loads and
 	 * stores on this platform.
@@ -344,7 +345,11 @@ int pci_mmap_page_range(struct pci_dev *
 	vma->vm_page_prot = __pgprot(prot);
 
 	flags = pgprot_val(vma->vm_page_prot) & _PAGE_CACHE_MASK;
-	if (reserve_memtype(addr, addr + len, flags, &new_flags)) {
+	retval = reserve_memtype(addr, addr + len, flags, &new_flags);
+	if (retval)
+		return retval;
+
+	if (flags != new_flags) {
 		/*
 		 * Do not fallback to certain memory types with certain
 		 * requested type:
