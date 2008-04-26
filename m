Return-Path: <linux-kernel-owner+w=401wt.eu-S1765891AbYDZAHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765891AbYDZAHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYDZAHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:07:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:64218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbYDZAHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:07:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,709,1199692800"; 
   d="scan'208";a="274879574"
Date: Fri, 25 Apr 2008 17:07:22 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       venkatesh.pallipadi@intel.com, jbarnes@virtuousgeek.org,
       keithp@keithp.com, airlied@gmail.com
Subject: Re: [Bug 10328] New: [regression] performance drop for glx
Message-ID: <20080426000722.GJ14062@linux-os.sc.intel.com>
References: <bug-10328-27@http.bugzilla.kernel.org/> <20080325152809.e2b07251.akpm@linux-foundation.org> <20080326003912.GB3313@linux-os.sc.intel.com> <47E9D42F.5080506@linux.intel.com> <1209101723.21553.1.camel@zwerg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209101723.21553.1.camel@zwerg>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 07:35:23AM +0200, Alexey Fisher wrote:
> > >> On Tue, 25 Mar 2008 15:11:15 -0700 (PDT)
> > >> bugme-daemon@bugzilla.kernel.org wrote:
> > >>
> > >>> http://bugzilla.kernel.org/show_bug.cgi?id=10328
> > >>>
> > >>>            Summary: [regression] performance drop for glx
> > > 
> > > Alexey, Can you please try the appended patch?
> > > 
> > > Andrew, can you please push the appended patch for 2.6.25? Thanks.
> > > ---
> > > 
> 
> 
> This issue come again with commit:
> 
> commit 2e5d9c857d4e6c9e7b7d8c8c86a68a7842d213d6
> Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
> Date:   Tue Mar 18 17:00:14 2008 -0700
> 
>     x86: PAT infrastructure patch
> 
>     Sets up pat_init() infrastructure.
> 

Alexey, Sorry. I missed posting a fix in the post PAT series for this issue. Can you
please try the appended patch and Ack?

copying X folks get their attention and their Ack on the patch and next steps outlined.

Thanks.
---

[patch] use UC minus for ioremap(), ioremap_nocache() and pci_mmap_page_range()

Use UC_MINUS for ioremap(), ioremap_nocache() instead of strong UC.
Once all the X drivers move to ioremap_wc(), we can go back to strong
UC semantics for ioremap() and ioremap_nocache().

To avoid attribute aliasing issues, pci_mmap_page_range() will also
use UC_MINUS for default non write-combining mapping request.

Next steps:
	a) change all the video drivers using ioremap() or ioremap_nocache()
	   and adding WC MTTR using mttr_add() to ioremap_wc()

	b) for strict usage, we can go back to strong uc semantics
	   for ioremap() and ioremap_nocache() after some grace period for
	   completing step-a.

	c) user level X server needs to use the appropriate method for setting
	   up WC mapping (like using resourceX_wc sysfs file instead of
	   adding MTRR for WC and using /dev/mem or resourceX under /sys)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 3a4baf9..c053977 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -176,11 +176,11 @@ static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
 		/*
 		 * Do not fallback to certain memory types with certain
 		 * requested type:
-		 * - request is uncached, return cannot be write-back
-		 * - request is uncached, return cannot be write-combine
+		 * - request is uc-, return cannot be write-back
+		 * - request is uc-, return cannot be write-combine
 		 * - request is write-combine, return cannot be write-back
 		 */
-		if ((prot_val == _PAGE_CACHE_UC &&
+		if ((prot_val == _PAGE_CACHE_UC_MINUS &&
 		     (new_prot_val == _PAGE_CACHE_WB ||
 		      new_prot_val == _PAGE_CACHE_WC)) ||
 		    (prot_val == _PAGE_CACHE_WC &&
@@ -201,6 +201,9 @@ static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
 	default:
 		prot = PAGE_KERNEL_NOCACHE;
 		break;
+	case _PAGE_CACHE_UC_MINUS:
+		prot = PAGE_KERNEL_UC_MINUS;
+		break;
 	case _PAGE_CACHE_WC:
 		prot = PAGE_KERNEL_WC;
 		break;
@@ -255,7 +258,16 @@ static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
  */
 void __iomem *ioremap_nocache(resource_size_t phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, _PAGE_CACHE_UC);
+	/*
+	 * Ideally, this should be:
+	 * 	pat_wc_enabled ? _PAGE_CACHE_UC : _PAGE_CACHE_UC_MINUS;
+	 *
+	 * Till we fix all X drivers to use ioremap_wc(), we will use
+	 * UC MINUS.
+	 */
+	unsigned long val = _PAGE_CACHE_UC_MINUS;
+
+	return __ioremap(phys_addr, size, val);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index c29ebd0..ad3202c 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -779,14 +779,20 @@ static inline int change_page_attr_clear(unsigned long addr, int numpages,
 
 int _set_memory_uc(unsigned long addr, int numpages)
 {
+	/*
+	 * for now UC MINUS. see comments in ioremap_nocache()
+	 */
 	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_CACHE_UC));
+				    __pgprot(_PAGE_CACHE_UC_MINUS));
 }
 
 int set_memory_uc(unsigned long addr, int numpages)
 {
+	/*
+	 * for now UC MINUS. see comments in ioremap_nocache()
+	 */
 	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
-	                    _PAGE_CACHE_UC, NULL))
+	                    _PAGE_CACHE_UC_MINUS, NULL))
 		return -EINVAL;
 
 	return _set_memory_uc(addr, numpages);
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 94f6c73..8af0f0b 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -301,6 +301,13 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 	prot = pgprot_val(vma->vm_page_prot);
 	if (pat_wc_enabled && write_combine)
 		prot |= _PAGE_CACHE_WC;
+	else if (pat_wc_enabled)
+		/*
+		 * ioremap() and ioremap_nocache() defaults to UC MINUS for now.
+		 * To avoid attribute conflicts, request UC MINUS here
+		 * aswell.
+		 */
+		prot |= _PAGE_CACHE_UC_MINUS;
 	else if (boot_cpu_data.x86 > 3)
 		prot |= _PAGE_CACHE_UC;
 
@@ -319,9 +326,8 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		 * - request is uncached, return cannot be write-combine
 		 * - request is write-combine, return cannot be write-back
 		 */
-		if ((flags == _PAGE_CACHE_UC &&
-		     (new_flags == _PAGE_CACHE_WB ||
-		      new_flags == _PAGE_CACHE_WC)) ||
+		if ((flags == _PAGE_CACHE_UC_MINUS &&
+		     (new_flags == _PAGE_CACHE_WB)) ||
 		    (flags == _PAGE_CACHE_WC &&
 		     new_flags == _PAGE_CACHE_WB)) {
 			free_memtype(addr, addr+len);
