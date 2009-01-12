Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZALT3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZALT3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbZALT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:29:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:37485 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbZALT3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:29:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,254,1231142400"; 
   d="scan'208";a="421721086"
Date: Mon, 12 Jan 2009 11:29:12 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090112192912.GA31650@linux-os.sc.intel.com>
References: <20090111143951.GA6666@elte.hu> <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com> <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com> <20090112191934.GA28851@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112191934.GA28851@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:19:35AM -0800, Pallipadi, Venkatesh wrote:
> On Mon, Jan 12, 2009 at 11:01:57AM -0800, Torsten Kaiser wrote:
> > On Mon, Jan 12, 2009 at 7:17 PM, Pallipadi, Venkatesh
> > <venkatesh.pallipadi@intel.com> wrote:
> > >
> > > I don't seem to be able to reproduce this failure on my test systems..
> > > What distribution are you using here? Can you send me the kernel config that you used.
> > 
> > I'm using Gentoo, the compiler is:
> > gcc (Gentoo 4.3.2-r2 p1.5, pie-10.1.5) 4.3.2
> > 
> > The system has 2x 2218 Opterons with 4GB of RAM, so it a NUMA system
> > with 2 nodes.
> > What might be important is, that I switched to the new TREE_RCU:
> > # CONFIG_CLASSIC_RCU is not set
> > CONFIG_TREE_RCU=y
> > # CONFIG_PREEMPT_RCU is not set
> > # CONFIG_RCU_TRACE is not set
> > CONFIG_RCU_FANOUT=4
> > # CONFIG_RCU_FANOUT_EXACT is not set
> > # CONFIG_TREE_RCU_TRACE is not set
> > # CONFIG_PREEMPT_RCU_TRACE is not set
> > 
> > Rest of the .config is attached. I used the same .config for the
> > vanilla 2.6.29-rc1 that worked apart from the DRM trouble that was
> > also reported by others and the version patched with these fixes.
> > 
> 
> I will try with this config. Meanwhile can you try the single patch below
> over 2.6.29-rc1 and see whether you still see the failure. This patch
> is fixing the DRM issue that you had seen and does not include other fixes
> cleaups that were in the patch series. If you still see the failure, can yo
> usend me the full boot log from the crash.
> 

oops. I missed out one file in the earlier test patch. Below is the
updated test patch that will go against 29-rc1.

Thanks,
Venki

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipad@intel.com>

---

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2009-01-12 10:45:03.000000000 -0800
+++ linux-2.6/arch/x86/mm/pat.c	2009-01-12 11:06:43.000000000 -0800
@@ -601,12 +601,13 @@ void unmap_devmem(unsigned long pfn, uns
  * Reserved non RAM regions only and after successful reserve_memtype,
  * this func also keeps identity mapping (if any) in sync with this new prot.
  */
-static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t vma_prot)
+static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
+				int strict_prot)
 {
 	int is_ram = 0;
 	int id_sz, ret;
 	unsigned long flags;
-	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
+	unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
 
 	is_ram = pagerange_is_ram(paddr, paddr + size);
 
@@ -625,15 +626,29 @@ static int reserve_pfn_range(u64 paddr, 
 		return ret;
 
 	if (flags != want_flags) {
-		free_memtype(paddr, paddr + size);
-		printk(KERN_ERR
-		"%s:%d map pfn expected mapping type %s for %Lx-%Lx, got %s\n",
-			current->comm, current->pid,
-			cattr_name(want_flags),
-			(unsigned long long)paddr,
-			(unsigned long long)(paddr + size),
-			cattr_name(flags));
-		return -EINVAL;
+		if (strict_prot ||
+		    (want_flags == _PAGE_CACHE_UC_MINUS &&
+		     flags == _PAGE_CACHE_WB) ||
+		    (want_flags == _PAGE_CACHE_WC &&
+		     flags == _PAGE_CACHE_WB)) {
+			free_memtype(paddr, paddr + size);
+			printk(KERN_ERR "%s:%d map pfn expected mapping type %s"
+				" for %Lx-%Lx, got %s\n",
+				current->comm, current->pid,
+				cattr_name(want_flags),
+				(unsigned long long)paddr,
+				(unsigned long long)(paddr + size),
+				cattr_name(flags));
+			return -EINVAL;
+		}
+		/*
+		 * We allow returning different type than the one requested in
+		 * non strict case.
+		 */
+		*vma_prot = __pgprot((pgprot_val(*vma_prot) &
+				      (~_PAGE_CACHE_MASK)) |
+				     flags);
+
 	}
 
 	/* Need to keep identity mapping in sync */
@@ -689,6 +704,7 @@ int track_pfn_vma_copy(struct vm_area_st
 	unsigned long vma_start = vma->vm_start;
 	unsigned long vma_end = vma->vm_end;
 	unsigned long vma_size = vma_end - vma_start;
+	pgprot_t pgprot;
 
 	if (!pat_enabled)
 		return 0;
@@ -702,7 +718,8 @@ int track_pfn_vma_copy(struct vm_area_st
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
-		return reserve_pfn_range(paddr, vma_size, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
 	}
 
 	/* reserve entire vma page by page, using pfn and prot from pte */
@@ -710,7 +727,8 @@ int track_pfn_vma_copy(struct vm_area_st
 		if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
 			continue;
 
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, &pgprot, 1);
 		if (retval)
 			goto cleanup_ret;
 	}
@@ -741,7 +759,7 @@ cleanup_ret:
  * Note that this function can be called with caller trying to map only a
  * subrange/page inside the vma.
  */
-int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
 	int retval = 0;
@@ -758,14 +776,14 @@ int track_pfn_vma_new(struct vm_area_str
 	if (is_linear_pfn_mapping(vma)) {
 		/* reserve the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		return reserve_pfn_range(paddr, vma_size, prot);
+		return reserve_pfn_range(paddr, vma_size, prot, 0);
 	}
 
 	/* reserve page by page using pfn and size */
 	base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	for (i = 0; i < size; i += PAGE_SIZE) {
 		paddr = base_paddr + i;
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot, 0);
 		if (retval)
 			goto cleanup_ret;
 	}
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2009-01-12 10:45:03.000000000 -0800
+++ linux-2.6/mm/memory.c	2009-01-12 10:59:30.000000000 -0800
@@ -1511,6 +1511,7 @@ int vm_insert_pfn(struct vm_area_struct 
 			unsigned long pfn)
 {
 	int ret;
+	pgprot_t pgprot = vma->vm_page_prot;
 	/*
 	 * Technically, architectures with pte_special can avoid all these
 	 * restrictions (same for remap_pfn_range).  However we would like
@@ -1525,10 +1526,10 @@ int vm_insert_pfn(struct vm_area_struct 
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (track_pfn_vma_new(vma, vma->vm_page_prot, pfn, PAGE_SIZE))
+	if (track_pfn_vma_new(vma, &pgprot, pfn, PAGE_SIZE))
 		return -EINVAL;
 
-	ret = insert_pfn(vma, addr, pfn, vma->vm_page_prot);
+	ret = insert_pfn(vma, addr, pfn, pgprot);
 
 	if (ret)
 		untrack_pfn_vma(vma, pfn, PAGE_SIZE);
@@ -1671,9 +1672,15 @@ int remap_pfn_range(struct vm_area_struc
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
-	err = track_pfn_vma_new(vma, prot, pfn, PAGE_ALIGN(size));
-	if (err)
+	err = track_pfn_vma_new(vma, &prot, pfn, PAGE_ALIGN(size));
+	if (err) {
+		/*
+		 * To indicate that track_pfn related cleanup is not
+		 * needed from higher level routine calling unmap_vmas
+		 */
+		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
 		return -EINVAL;
+	}
 
 	BUG_ON(addr >= end);
 	pfn -= addr >> PAGE_SHIFT;
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 72ebe91..8e6d0ca 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -301,7 +301,7 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
  * track_pfn_vma_new is called when a _new_ pfn mapping is being established
  * for physical range indicated by pfn and size.
  */
-static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 					unsigned long pfn, unsigned long size)
 {
 	return 0;
@@ -332,7 +332,7 @@ static inline void untrack_pfn_vma(struct vm_area_struct *vma,
 {
 }
 #else
-extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 				unsigned long pfn, unsigned long size);
 extern int track_pfn_vma_copy(struct vm_area_struct *vma);
 extern void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
