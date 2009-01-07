Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZAGBds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZAGBds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 20:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZAGBdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 20:33:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:18356 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZAGBdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 20:33:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,222,1231142400"; 
   d="scan'208";a="479498661"
Date: Tue, 6 Jan 2009 17:33:36 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Dave Airlie <airlied@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Alexey Fisher <bug-track@fisher-privat.net>,
       "kernel-testers-owner@vger.kernel.org" 
	<kernel-testers-owner@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Kevin Winchester <kjwinchester@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [regression] glx performance drop with: "x86: PAT: implement track/untrack of pfnmap regions for x86 - v3"
Message-ID: <20090107013335.GA4141@linux-os.sc.intel.com>
References: <4963A71C.2020107@fisher-privat.net> <4963A859.6030406@zytor.com> <7E82351C108FA840AB1866AC776AEC464399F2D6@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E82351C108FA840AB1866AC776AEC464399F2D6@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 11:05:51AM -0800, Pallipadi, Venkatesh wrote:
> 
>  
> 
> >-----Original Message-----
> >From: H. Peter Anvin [mailto:hpa@zytor.com] 
> >Sent: Tuesday, January 06, 2009 10:52 AM
> >To: Alexey Fisher
> >Cc: kernel-testers-owner@vger.kernel.org; 
> >linux-kernel@vger.kernel.org; Siddha, Suresh B; Pallipadi, Venkatesh
> >Subject: Re: [regression] glx performance drop with: "x86: 
> >PAT: implement track/untrack of pfnmap regions for x86 - v3"
> >
> >Alexey Fisher wrote:
> >> glx perfomance regression after this patch.
> >> goot kernel: glxgears = 1400 fps
> >> bad kernel: glxgears = 300 fps ( same speed with disabled 
> >drm module )
> >> 
> >> kernel log:
> >> glxgears:5775 map pfn expected mapping type write-back for
> >> d1000000-d1c80000, got uncached-minus
> >> glxgears:5775 freeing invalid memtype d1000000-d1c80000
> >> 
> >
> >Have we caught a case of actual overlap, i.e. a driver bug here?
> >
> 
> This error is similar to one reported by Kevin here.
> http://lkml.indiana.edu/hypermail/linux/kernel/0901.0/00970.html
> [  111.775378] X:5010 map pfn expected mapping type write-back for d0000000-d0101000, got write-combining
> [  111.775456] X:5010 freeing invalid memtype d0000000-d0101000
> 
> 
> The sequence seems to be somewhat like this
> 
> - Kernel driver sets the whole graphics region to uc-minus or write-combining
> - There is a remap_pfn_range() to map a portion of this region to user with "write-back" mapping.
> 
> Now there may be a MTRR for this region or there may be none. It will depend on specific system and
> whether there were available MTRRs or MTRR setting was possible at all.If there are no MTRR settings,
> then we have caught a valid aliasing here.
> 
> I have reproduced this problem on a local system here and looking for a sane solution....
>

Looks like there is more than one problem with glxgears with latest git.

Below test patch fixes the memory type conflicts with remap_pfn_range. But,
with this test patch applied to latest git, glxgears does not work on my
test system. It goes into a repeaed ioctl(4, 0x40046445, ..) loop.

But, with
vanilla 2.6.28 + earlier pfnmap tracking patchset v3
I do see lower performance of glxgears compared to vanilla 2.6.28.

and with
vanilla 2.6.28 + earlier pfnmap tracking patchset v3 + test patch below
brings the glxgears performance back to vanilla 2.6.28 level.


Dave: Do you know of any other drm changes post 2.6.28 that may be resulting
in glxgears getting stuck with above ioctl?

Thanks,
Venki
 

Below is the test patch that fixes the problems related to remap_pfn_range
memory type conflicts. The patch needs some cleanup and comments before it can
go into base. Good enough as a test patch.


Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/pat.c             |   59 +++++++++++++++++++++++++++++-------------
 include/asm-generic/pgtable.h |    4 +-
 mm/memory.c                   |   12 ++++++--
 3 files changed, 52 insertions(+), 23 deletions(-)

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2009-01-06 17:07:29.000000000 -0800
+++ linux-2.6/mm/memory.c	2009-01-06 17:11:08.000000000 -0800
@@ -1458,7 +1458,7 @@ int vm_insert_pfn(struct vm_area_struct 
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (track_pfn_vma_new(vma, vma->vm_page_prot, pfn, PAGE_SIZE))
+	if (track_pfn_vma_new(vma, &vma->vm_page_prot, pfn, PAGE_SIZE))
 		return -EINVAL;
 
 	ret = insert_pfn(vma, addr, pfn, vma->vm_page_prot);
@@ -1604,9 +1604,15 @@ int remap_pfn_range(struct vm_area_struc
 
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
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2009-01-06 17:10:49.000000000 -0800
+++ linux-2.6/arch/x86/mm/pat.c	2009-01-06 17:11:08.000000000 -0800
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
 
@@ -625,16 +626,35 @@ static int reserve_pfn_range(u64 paddr, 
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
-	}
+		if (strict_prot) {
+			free_memtype(paddr, paddr + size);
+			printk(KERN_ERR "%s:%d map pfn expected mapping type "
+					"%s for %Lx-%Lx, got %s\n",
+					current->comm, current->pid,
+					cattr_name(want_flags),
+					(unsigned long long)paddr,
+					(unsigned long long)(paddr + size),
+					cattr_name(flags));
+			return -EINVAL;
+		} else if ((want_flags == _PAGE_CACHE_UC_MINUS &&
+			    flags == _PAGE_CACHE_WB) ||
+			   (want_flags == _PAGE_CACHE_WC &&
+			    flags == _PAGE_CACHE_WB)) {
+			free_memtype(paddr, paddr + size);
+			printk(KERN_ERR "%s:%d map pfn expected mapping type "
+					"%s for %Lx-%Lx, got %s\n",
+					current->comm, current->pid,
+					cattr_name(want_flags),
+					(unsigned long long)paddr,
+					(unsigned long long)(paddr + size),
+					cattr_name(flags));
+			return -EINVAL;
+		}
+		*vma_prot = __pgprot((pgprot_val(*vma_prot) &
+				      (~_PAGE_CACHE_MASK)) |
+				     flags);
+		return 0;
+        }
 
 	/* Need to keep identity mapping in sync */
 	if (paddr >= __pa(high_memory))
@@ -689,6 +709,7 @@ int track_pfn_vma_copy(struct vm_area_st
 	unsigned long vma_start = vma->vm_start;
 	unsigned long vma_end = vma->vm_end;
 	unsigned long vma_size = vma_end - vma_start;
+	pgprot_t pgprot;
 
 	if (!pat_enabled)
 		return 0;
@@ -702,7 +723,8 @@ int track_pfn_vma_copy(struct vm_area_st
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
-		return reserve_pfn_range(paddr, vma_size, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
 	}
 
 	/* reserve entire vma page by page, using pfn and prot from pte */
@@ -710,7 +732,8 @@ int track_pfn_vma_copy(struct vm_area_st
 		if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
 			continue;
 
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, &pgprot, 1);
 		if (retval)
 			goto cleanup_ret;
 	}
@@ -732,7 +755,7 @@ cleanup_ret:
  * track_pfn_vma_new is called when a _new_ pfn mapping is being established
  * for physical range indicated by pfn and size.
  *
- * prot is passed in as a parameter for the new mapping. If the vma has a
+ * prot is passed in as pointer parameter for the new mapping. If the vma has a
  * linear pfn mapping for the entire range reserve the entire vma range with
  * single reserve_pfn_range call.
  * Otherwise, we look t the pfn and size and reserve only the specified range
@@ -741,7 +764,7 @@ cleanup_ret:
  * Note that this function can be called with caller trying to map only a
  * subrange/page inside the vma.
  */
-int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
 	int retval = 0;
@@ -758,14 +781,14 @@ int track_pfn_vma_new(struct vm_area_str
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
Index: linux-2.6/include/asm-generic/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-generic/pgtable.h	2009-01-06 17:10:49.000000000 -0800
+++ linux-2.6/include/asm-generic/pgtable.h	2009-01-06 17:11:08.000000000 -0800
@@ -301,7 +301,7 @@ static inline void ptep_modify_prot_comm
  * track_pfn_vma_new is called when a _new_ pfn mapping is being established
  * for physical range indicated by pfn and size.
  */
-static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+static inline int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 					unsigned long pfn, unsigned long size)
 {
 	return 0;
@@ -332,7 +332,7 @@ static inline void untrack_pfn_vma(struc
 {
 }
 #else
-extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
+extern int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 				unsigned long pfn, unsigned long size);
 extern int track_pfn_vma_copy(struct vm_area_struct *vma);
 extern void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
