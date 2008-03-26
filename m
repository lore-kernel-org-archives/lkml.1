Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYCZRz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYCZRz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYCZRzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:55:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:36163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbYCZRzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:55:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,559,1199692800"; 
   d="scan'208";a="223534673"
Date: Wed, 26 Mar 2008 10:55:00 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       venkatesh.pallipadi@intel.com, arjan@linux.intel.com,
       bug-track@fisher-privat.net
Subject: Re: [Bug 10328] New: [regression] performance drop for glx
Message-ID: <20080326175500.GD3313@linux-os.sc.intel.com>
References: <bug-10328-27@http.bugzilla.kernel.org/> <20080325152809.e2b07251.akpm@linux-foundation.org> <20080326003912.GB3313@linux-os.sc.intel.com> <20080326052911.GA8173@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326052911.GA8173@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 06:29:11AM +0100, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > fb drivers are using ioremap()/ioremap_nocache(), followed by mtrr_add 
> > with WC attribute. Recent changes in page attribute code made both 
> > ioremap()/ioremap_nocache() mappings as UC (instead of previous UC-). 
> > This breaks the graphics performance, as the effective memory type is 
> > UC instead of expected WC.
> > 
> > The correct way to fix this is to add ioremap_wc() (which uses UC- in 
> > the absence of PAT kernel support and WC with PAT) and change all the 
> > fb drivers to use this new ioremap_wc() API.
> > 
> > We can take this correct and longer route for post 2.6.25. For now, 
> > revert back to the UC- behavior for ioremap/ioremap_nocache.
> 
> thanks Suresh, applied.

Well, we need to take care of set_memory_uc() aswell, as the previous version
didn't fix Alexey's issue.

Alexey, can you please test and ack this, before Andrew/Ingo can push relevant
bits to their trees. Thanks.
---

fb drivers are using ioremap()/ioremap_nocache(), followed by mtrr_add with
WC attribute. Recent changes in page attribute code made both
ioremap()/ioremap_nocache() mappings as UC (instead of previous UC-). This
breaks the graphics performance, as the effective memory type is UC instead
of expected WC.

The correct way to fix this is to add ioremap_wc() (which uses UC- in the
absence of PAT kernel support and WC with PAT) and change all the
drivers to use this new ioremap_wc() API.

We can take this correct and longer route for post 2.6.25. For now,
revert back to the UC- behavior for ioremap/ioremap_nocache.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 4afaba0..794895c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -137,7 +137,11 @@ static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
 	switch (mode) {
 	case IOR_MODE_UNCACHED:
 	default:
-		prot = PAGE_KERNEL_NOCACHE;
+		/*
+		 * FIXME: we will use UC MINUS for now, as video fb drivers
+		 * depend on it. Upcoming ioremap_wc() will fix this behavior.
+		 */
+		prot = PAGE_KERNEL_UC_MINUS;
 		break;
 	case IOR_MODE_CACHED:
 		prot = PAGE_KERNEL;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 14e48b5..7b79f6b 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -771,7 +771,7 @@ static inline int change_page_attr_clear(unsigned long addr, int numpages,
 int set_memory_uc(unsigned long addr, int numpages)
 {
 	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_PCD | _PAGE_PWT));
+				    __pgprot(_PAGE_PCD));
 }
 EXPORT_SYMBOL(set_memory_uc);
 
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 174b877..9cf472a 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -85,6 +85,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
 #define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
@@ -101,6 +102,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define PAGE_KERNEL_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX			MAKE_GLOBAL(__PAGE_KERNEL_RX)
 #define PAGE_KERNEL_NOCACHE		MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_UC_MINUS		MAKE_GLOBAL(__PAGE_KERNEL_UC_MINUS)
 #define PAGE_KERNEL_EXEC_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_EXEC_NOCACHE)
 #define PAGE_KERNEL_LARGE		MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
 #define PAGE_KERNEL_LARGE_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_LARGE_EXEC)
