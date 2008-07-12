Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYGLVds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYGLVds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 17:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYGLVd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 17:33:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:7327 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYGLVd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 17:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=k0Azujws9MIBDgAEJVsezcDoh/KSrmZAK7sxqkeQFm4+mY062HFKotPyKlBxkfT58D
         0QcN1YbUHSzAQKRSg0Gz9a8hUsW5jj5TgMx+LKsiO9A1nyWWf2wUh/Ha0gHxp97P8TLv
         zg2kHZ+O8Mt97Jvq6gFjVnbNQypbiWzZjmeZY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: max_low_pfn_mapped fix #2
Date: Sat, 12 Jul 2008 14:31:28 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com>
In-Reply-To: <200807102038.26591.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807121431.28725.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tight the boundary check

also print out tseg for amd cpu.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/amd_64.c |    1 +
 arch/x86/mm/pageattr.c       |    4 ++--
 arch/x86/mm/pat.c            |    4 ++--
 arch/x86/pci/i386.c          |    4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd_64.c
+++ linux-2.6/arch/x86/kernel/cpu/amd_64.c
@@ -200,6 +200,7 @@ static void __cpuinit init_amd(struct cp
 		 * benefit in doing so.
 		 */
 		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
+		    printk(KERN_DEBUG "tseg: %010llx\n", tseg);
 		    if ((tseg>>PMD_SHIFT) <
 				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
 			((tseg>>PMD_SHIFT) <
Index: linux-2.6/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pageattr.c
+++ linux-2.6/arch/x86/mm/pageattr.c
@@ -658,11 +658,11 @@ static int cpa_process_alias(struct cpa_
 	struct cpa_data alias_cpa;
 	int ret = 0;
 
-	if (cpa->pfn > max_pfn_mapped)
+	if (cpa->pfn >= max_pfn_mapped)
 		return 0;
 
 #ifdef CONFIG_X86_64
-	if (cpa->pfn > max_low_pfn_mapped && cpa->pfn < (1UL<<(32-PAGE_SHIFT)))
+	if (cpa->pfn >= max_low_pfn_mapped && cpa->pfn < (1UL<<(32-PAGE_SHIFT)))
 		return 0;
 #endif
 	/*
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c
+++ linux-2.6/arch/x86/mm/pat.c
@@ -449,8 +449,8 @@ int phys_mem_access_prot_allowed(struct
 	if (retval < 0)
 		return 0;
 
-	if (((pfn <= max_low_pfn_mapped) ||
-	     (pfn >= (1UL<<(32 - PAGE_SHIFT)) && pfn <= max_pfn_mapped)) &&
+	if (((pfn < max_low_pfn_mapped) ||
+	     (pfn >= (1UL<<(32 - PAGE_SHIFT)) && pfn < max_pfn_mapped)) &&
 	    ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
 		free_memtype(offset, offset + size);
 		printk(KERN_INFO
Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -334,9 +334,9 @@ int pci_mmap_page_range(struct pci_dev *
 		flags = new_flags;
 	}
 
-	if (((vma->vm_pgoff <= max_low_pfn_mapped) ||
+	if (((vma->vm_pgoff < max_low_pfn_mapped) ||
 	     (vma->vm_pgoff >= (1UL<<(32 - PAGE_SHIFT)) &&
-	      vma->vm_pgoff <= max_pfn_mapped)) &&
+	      vma->vm_pgoff < max_pfn_mapped)) &&
 	    ioremap_change_attr((unsigned long)__va(addr), len, flags)) {
 		free_memtype(addr, addr + len);
 		return -EINVAL;
