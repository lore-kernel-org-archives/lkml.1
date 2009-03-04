Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbZCDGJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbZCDGJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 01:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZCDGJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 01:09:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:28899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZCDGJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 01:09:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,299,1233561600"; 
   d="scan'208";a="435986611"
Date: Tue, 3 Mar 2009 22:08:58 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thellstrom@vmware.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.29 pat issue
Message-ID: <20090304060857.GA18318@linux-os.sc.intel.com>
References: <498ADFE3.9020907@vmware.com> <1233856988.4286.83.camel@localhost.localdomain> <498B5ADE.3090602@vmware.com> <m1tz78pdwy.fsf@fess.ebiederm.org> <498C062C.201@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <498C062C.201@vmware.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 01:43:08AM -0800, Thomas Hellström wrote:
> Eric W. Biederman wrote:
> > Thomas Hellstrom <thellstrom@vmware.com> writes:
> >
> >
> >
> >> Indeed, it's crucial to keep the mappings consistent, but failure to do so is a
> >> kernel driver bug, it should never be the result of invalid user data.
> >>
> >
> > It easily can be.  Think of an X server mmaping frame buffers. Or other
> > device bars.
> >
> >
> Hmm, Yes  you're right, although I'm still a bit doubtful about RAM pages.
> 
> Wait. Now I see what's causing the problems. The code is  assuming that
> VM_PFNMAP vmas never map RAM pages. That's also an invalid assumption.
> See comments in mm/memory.c
> 
> So probably the attribute check should be done for the insert_pfn path
> of VM_MIXEDMAP as well. That's not done today.
> 
> So there are three distinct bugs at this point:
> 
> 1) VMAs with VM_PFNMAP are incorrectly assumed to be linear if
> vma->vm_pgoff non-null.
> 2) VM_PFNMAP VMA PTEs are incorrectly assumed to never point to physical
> RAM.
> 3) There is no check for the insert_pfn  path of vm_insert_mixed().
> 

Patch below will solve (1) above.

About (2), Yes. we can optimize the PAT code if we use struct page to track
PFNMAP as long at memory is backed by a struct page. It has some complications
with refcounting the number of mappings and related things. We are actively
looking at it. About (3), vm_insert_mixed was not used by any in kernel driver,
so, we did not add checks there, with the intention of fixing most commonly
used remap_pfn_range and vm_insert_pfn first.

Below patch should fix the regression upstream. I don't like the way we
overloaded a bit here. But, we don't seem to see any other option.
Nick: Do you see any cleaner way to do this?

Thanks,
Venki

Subject: [PATCH] VM, x86 PAT: Change implementation of is_linear_pfn_mapping

Use of vma->vm_pgoff to identify the pfnmaps that are fully mapped at
mmap time is broken, as vm_pgoff can also be set when full mapping is
not setup at mmap time.
http://marc.info/?l=linux-kernel&m=123383810628583&w=2

Change the logic to overload VM_NONLINEAR flag along with VM_PFNMAP to
mean full mapping setup at mmap time. This distinction is needed by x86 PAT
code.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/linux/mm.h |    8 +++++++-
 mm/memory.c        |    2 ++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 065cdf8..6c3fc3a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -127,6 +127,12 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_RESERVED | VM_PFNMAP)
 
 /*
+ * pfnmap vmas that are fully mapped at mmap time (not mapped on fault).
+ * Used by x86 PAT to identify such PFNMAP mappings and optimize their handling.
+ */
+#define VM_PFNMAP_AT_MMAP (VM_NONLINEAR | VM_PFNMAP)
+
+/*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
@@ -145,7 +151,7 @@ extern pgprot_t protection_map[16];
  */
 static inline int is_linear_pfn_mapping(struct vm_area_struct *vma)
 {
-	return ((vma->vm_flags & VM_PFNMAP) && vma->vm_pgoff);
+	return ((vma->vm_flags & VM_PFNMAP_AT_MMAP) == VM_PFNMAP_AT_MMAP);
 }
 
 static inline int is_pfn_mapping(struct vm_area_struct *vma)
diff --git a/mm/memory.c b/mm/memory.c
index baa999e..457e97e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1671,6 +1671,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		return -EINVAL;
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
+	vma->vm_flags |= VM_PFNMAP_AT_MMAP;
 
 	err = track_pfn_vma_new(vma, &prot, pfn, PAGE_ALIGN(size));
 	if (err) {
@@ -1679,6 +1680,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		 * needed from higher level routine calling unmap_vmas
 		 */
 		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
+		vma->vm_flags &= ~VM_PFNMAP_AT_MMAP;
 		return -EINVAL;
 	}
 
-- 
1.6.0.6

