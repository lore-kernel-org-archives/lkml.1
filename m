Return-Path: <linux-kernel-owner+w=401wt.eu-S964790AbYD1Qf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790AbYD1Qf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbYD1Qfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:35:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45414 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932775AbYD1Qfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:35:46 -0400
Date: Mon, 28 Apr 2008 18:34:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       venkatesh.pallipadi@intel.com, jbarnes@virtuousgeek.org,
       keithp@keithp.com, airlied@gmail.com
Subject: Re: [Bug 10328] New: [regression] performance drop for glx
Message-ID: <20080428163457.GA18210@elte.hu>
References: <bug-10328-27@http.bugzilla.kernel.org/> <20080325152809.e2b07251.akpm@linux-foundation.org> <20080326003912.GB3313@linux-os.sc.intel.com> <47E9D42F.5080506@linux.intel.com> <1209101723.21553.1.camel@zwerg> <20080426000722.GJ14062@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426000722.GJ14062@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Alexey, Sorry. I missed posting a fix in the post PAT series for this 
> issue. Can you please try the appended patch and Ack?
> 
> copying X folks get their attention and their Ack on the patch and 
> next steps outlined.

i queued up the patch below - hand-merged to x86.git.

	Ingo

----------->
Subject: x86 PAT: fix performance drop for glx, use UC minus for ioremap(), ioremap_nocache() and pci_mmap_page_range()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Date: Fri, 25 Apr 2008 17:07:22 -0700

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
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c  |   20 ++++++++++++++++----
 arch/x86/mm/pageattr.c |   10 ++++++++--
 arch/x86/pci/i386.c    |   12 +++++++++---
 3 files changed, 33 insertions(+), 9 deletions(-)

Index: linux-x86.q/arch/x86/mm/ioremap.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/ioremap.c
+++ linux-x86.q/arch/x86/mm/ioremap.c
@@ -176,11 +176,11 @@ static void __iomem *__ioremap(resource_
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
@@ -201,6 +201,9 @@ static void __iomem *__ioremap(resource_
 	default:
 		prot = PAGE_KERNEL_NOCACHE;
 		break;
+	case _PAGE_CACHE_UC_MINUS:
+		prot = PAGE_KERNEL_UC_MINUS;
+		break;
 	case _PAGE_CACHE_WC:
 		prot = PAGE_KERNEL_WC;
 		break;
@@ -255,7 +258,16 @@ static void __iomem *__ioremap(resource_
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
 
Index: linux-x86.q/arch/x86/mm/pageattr.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/pageattr.c
+++ linux-x86.q/arch/x86/mm/pageattr.c
@@ -829,14 +829,20 @@ static inline int change_page_attr_clear
 
 int _set_memory_uc(unsigned long addr, int numpages)
 {
+	/*
+	 * for now UC MINUS. see comments in ioremap_nocache()
+	 */
 	return change_page_attr_set(&addr, numpages,
-				    __pgprot(_PAGE_CACHE_UC), 0);
+				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
 }
 
 int set_memory_uc(unsigned long addr, int numpages)
 {
+	/*
+	 * for now UC MINUS. see comments in ioremap_nocache()
+	 */
 	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
-	                    _PAGE_CACHE_UC, NULL))
+			    _PAGE_CACHE_UC_MINUS, NULL))
 		return -EINVAL;
 
 	return _set_memory_uc(addr, numpages);
Index: linux-x86.q/arch/x86/pci/i386.c
===================================================================
--- linux-x86.q.orig/arch/x86/pci/i386.c
+++ linux-x86.q/arch/x86/pci/i386.c
@@ -301,6 +301,13 @@ int pci_mmap_page_range(struct pci_dev *
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
 
@@ -319,9 +326,8 @@ int pci_mmap_page_range(struct pci_dev *
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
