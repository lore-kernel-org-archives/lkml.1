Return-Path: <linux-kernel-owner+w=401wt.eu-S1759778AbZAJA0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbZAJA0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757769AbZAJAYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:24:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:20732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172AbZAJAYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:24:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,242,1231142400"; 
   d="scan'208";a="377242488"
Message-Id: <20090110001404.883541000@intel.com>
References: <20090110001308.403550000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 Jan 2009 16:13:12 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       kjwinchester@gmail.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 4/6] x86 PAT: return compatible mapping to remap_pfn_range callers
Content-Disposition: inline; filename=allow_non_exact_memtype_in_track_pfn_vma_new.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change x86 PAT code to return compatible memtype if the exact memtype that
was requested in remap_pfn_rage and friends is not available due to some
conflict.

This is done by returning the compatible type in pgprot parameter of
track_pfn_vma_new(), and the caller uses that memtype for page table.

Note that track_pfn_vma_copy() which is basically called during fork gets the
prot from existing page table and should not have any conflict. Hence we use
strict memtype check there and do not allow compatible memtypes.

This patch fixes the bug reported here
http://marc.info/?l=linux-kernel&m=123108883716357&w=2

Specifically the error message
X:5010 map pfn expected mapping type write-back for d0000000-d0101000, 
got write-combining


Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/mm/pat.c |   43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2009-01-07 16:17:47.000000000 -0800
+++ linux-2.6/arch/x86/mm/pat.c	2009-01-07 16:35:57.000000000 -0800
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
 
@@ -625,15 +626,24 @@ static int reserve_pfn_range(u64 paddr, 
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
+		if (strict_prot || !is_new_memtype_allowed(want_flags, flags)) {
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
 	}
 
 	/* Need to keep identity mapping in sync */
@@ -689,6 +699,7 @@ int track_pfn_vma_copy(struct vm_area_st
 	unsigned long vma_start = vma->vm_start;
 	unsigned long vma_end = vma->vm_end;
 	unsigned long vma_size = vma_end - vma_start;
+	pgprot_t pgprot;
 
 	if (!pat_enabled)
 		return 0;
@@ -702,7 +713,8 @@ int track_pfn_vma_copy(struct vm_area_st
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
-		return reserve_pfn_range(paddr, vma_size, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
 	}
 
 	/* reserve entire vma page by page, using pfn and prot from pte */
@@ -710,7 +722,8 @@ int track_pfn_vma_copy(struct vm_area_st
 		if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
 			continue;
 
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, __pgprot(prot));
+		pgprot = __pgprot(prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, &pgprot, 1);
 		if (retval)
 			goto cleanup_ret;
 	}
@@ -758,14 +771,14 @@ int track_pfn_vma_new(struct vm_area_str
 	if (is_linear_pfn_mapping(vma)) {
 		/* reserve the whole chunk starting from vm_pgoff */
 		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		return reserve_pfn_range(paddr, vma_size, *prot);
+		return reserve_pfn_range(paddr, vma_size, prot, 0);
 	}
 
 	/* reserve page by page using pfn and size */
 	base_paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	for (i = 0; i < size; i += PAGE_SIZE) {
 		paddr = base_paddr + i;
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, *prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot, 0);
 		if (retval)
 			goto cleanup_ret;
 	}

-- 

