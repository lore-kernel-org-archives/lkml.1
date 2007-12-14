Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbXLNXeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbXLNXeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 18:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXLNXeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 18:34:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:12159 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbXLNXeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 18:34:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,169,1196668800"; 
   d="scan'208";a="241957844"
Date: Fri, 14 Dec 2007 15:34:01 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: ebiederm@xmission.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, venkatesh.pallipadi@intel.com,
       ak@muc.de, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
Message-ID: <20071214233401.GE717@linux-os.sc.intel.com>
References: <20071213235543.568682000@intel.com> <20071213235711.464325000@intel.com> <m1d4taq6le.fsf@ebiederm.dsl.xmission.com> <m1wsrhq4zl.fsf@ebiederm.dsl.xmission.com> <20071214211039.GB717@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214211039.GB717@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 01:10:39PM -0800, Siddha, Suresh B wrote:
> On Thu, Dec 13, 2007 at 09:23:26PM -0700, Eric W. Biederman wrote:
> > ebiederm@xmission.com (Eric W. Biederman) writes:
> > Ok.  My analysis here was wrong.  Currently pgprot_noncached and
> > ioremap_nocache are out of sync.  With ioremap_nocache only specifying
> > _PAGE_PCD and pgprot_noncached specifying _PAGE_PCD | _PAGE_PWT.
> > 
> > So I don't have a clue how someone could reprogram the mtrrs currently
> > and expect things to work.
> > 
> > ...
> > 
> > If we bother to ask ioremap for memory that is not cached, the last
> > thing in the world we want is the MTRRs upgrading that to write combining.
> > So ioremap_nocache has been slightly buggy for ages.  ioremap_nocache
> > and PAGE_KERNEL_NOCACHE should get _PAGE_PWT added to their
> > definitions.
> > 
> > Could we please get a cleanup patch at the beginning of this patchset
> > or that comes before it that fixes ioremap_nocache on x86?
> > 
> > That will make us a lot more git-bisect safe.
> 
> Ok. I will send a separate patch  fixing ioremap_nocache on x86.

Appended the patch. x86 folks, please consider for x86 mm git tree. Thanks.

---
[patch] x86: Set strong uncacheable where UC is really desired

Also use _PAGE_PWT for all the mappings which need uncache mapping. Instead of
existing PAT2 which is UC- (and can be overwritten by MTRRs), we now use PAT3
which is strong uncacheable.

This makes it consistent with pgprot_noncached()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/mm/ioremap_32.c b/arch/x86/mm/ioremap_32.c
index 0b27831..ef0f6a4 100644
--- a/arch/x86/mm/ioremap_32.c
+++ b/arch/x86/mm/ioremap_32.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(__ioremap);
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
 	unsigned long last_addr;
-	void __iomem *p = __ioremap(phys_addr, size, _PAGE_PCD);
+	void __iomem *p = __ioremap(phys_addr, size, _PAGE_PCD | _PAGE_PWT);
 	if (!p) 
 		return p; 
 
diff --git a/arch/x86/mm/ioremap_64.c b/arch/x86/mm/ioremap_64.c
index 6cac90a..8be3062 100644
--- a/arch/x86/mm/ioremap_64.c
+++ b/arch/x86/mm/ioremap_64.c
@@ -158,7 +158,7 @@ EXPORT_SYMBOL(__ioremap);
 
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, _PAGE_PCD);
+	return __ioremap(phys_addr, size, _PAGE_PCD | _PAGE_PWT);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index ed3e70d..b1215e1 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -156,7 +156,7 @@ void paging_init(void);
 extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
-#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD)
+#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 9b0ff47..4e4dcc4 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -185,13 +185,13 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long
 #define __PAGE_KERNEL_EXEC \
 	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
 #define __PAGE_KERNEL_NOCACHE \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_PCD | _PAGE_ACCESSED | _PAGE_NX)
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_PCD | _PAGE_PWT | _PAGE_ACCESSED | _PAGE_NX)
 #define __PAGE_KERNEL_RO \
 	(_PAGE_PRESENT | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX)
 #define __PAGE_KERNEL_VSYSCALL \
 	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE \
-	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_PCD)
+	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE \
 	(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC \
