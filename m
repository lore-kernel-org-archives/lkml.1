Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbZCAQxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbZCAQxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 11:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZCAQxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 11:53:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:50686 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbZCAQxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 11:53:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,285,1233561600"; 
   d="scan'208";a="115540119"
Date: Sun, 1 Mar 2009 08:53:27 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Keith Packard <keithp@keithp.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: gpu/drm, x86, PAT: io_mapping_create_wc and resource_size_t
Message-ID: <20090301165327.GA12970@linux-os.sc.intel.com>
References: <200902280201.n1S217FR011162@hera.kernel.org> <200903011454.55865.s.L-H@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903011454.55865.s.L-H@gmx.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 05:54:53AM -0800, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Samstag, 28. Februar 2009, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4ab0d47d0ab311eb181532c1ecb6d02905685071
> > Commit:     4ab0d47d0ab311eb181532c1ecb6d02905685071
> > Parent:     6644107d57a8fa82b47e4c55da4d9d91a612f29c
> > Author:     Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > AuthorDate: Tue Feb 24 17:35:12 2009 -0800
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed Feb 25 13:09:51 2009 +0100
> >
> >     gpu/drm, x86, PAT: io_mapping_create_wc and resource_size_t
> >
> >     io_mapping_create_wc should take a resource_size_t parameter in place of
> >     unsigned long. With unsigned long, there will be no way to map greater than 4GB
> >     address in i386/32 bit.
> >
> >     On x86, greater than 4GB addresses cannot be mapped on i386 without PAE. Return
> >     error for such a case.
> >
> >     Patch also adds a structure for io_mapping, that saves the base, size and
> >     type on HAVE_ATOMIC_IOMAP archs, that can be used to verify the offset on
> >     io_mapping_map calls.
> >
> >     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> >     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >     Cc: Dave Airlie <airlied@redhat.com>
> >     Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> >     Cc: Eric Anholt <eric@anholt.net>
> >     Cc: Keith Packard <keithp@keithp.com>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> This patch, as part of 2.6.29-rc6-git5, fails to build for me on i386 (it
> builds on amd64) with the attached (slimmed down) config (CONFIG_X86_PAT=y)
> and buildlog:
> 
>   Building modules, stage 2.
>   MODPOST 809 modules
> ERROR: "pgprot_writecombine" [drivers/gpu/drm/i915/i915.ko] undefined!
> ERROR: "is_io_mapping_possible" [drivers/gpu/drm/i915/i915.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> This is a build regression in comparison to 2.6.29-rc6.
> 

My bad. I had missed drm as module compilation. Below patch should fix it.
Can you please verify.

Thanks,
Venki


Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/iomap_32.c     |    1 +
 arch/x86/mm/pat.c          |    2 ++
 include/linux/io-mapping.h |    3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/iomap_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/iomap_32.c	2009-03-01 08:31:12.000000000 -0800
+++ linux-2.6/arch/x86/mm/iomap_32.c	2009-03-01 08:47:20.000000000 -0800
@@ -37,6 +37,7 @@ is_io_mapping_possible(resource_size_t b
 	return 1;
 }
 #endif
+EXPORT_SYMBOL_GPL(is_io_mapping_possible);
 
 /* Map 'pfn' using fixed map 'type' and protections 'prot'
  */
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2009-03-01 08:31:00.000000000 -0800
+++ linux-2.6/arch/x86/mm/pat.c	2009-03-01 08:45:48.000000000 -0800
@@ -11,6 +11,7 @@
 #include <linux/bootmem.h>
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
@@ -868,6 +869,7 @@ pgprot_t pgprot_writecombine(pgprot_t pr
 	else
 		return pgprot_noncached(prot);
 }
+EXPORT_SYMBOL(pgprot_writecombine);
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
Index: linux-2.6/include/linux/io-mapping.h
===================================================================
--- linux-2.6.orig/include/linux/io-mapping.h	2009-03-01 08:31:12.000000000 -0800
+++ linux-2.6/include/linux/io-mapping.h	2009-03-01 08:49:53.000000000 -0800
@@ -91,8 +91,9 @@ io_mapping_unmap_atomic(void *vaddr)
 static inline void *
 io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
 {
+	resource_size_t phys_addr;
 	BUG_ON(offset >= mapping->size);
-	resource_size_t phys_addr = mapping->base + offset;
+	phys_addr = mapping->base + offset;
 	return ioremap_wc(phys_addr, PAGE_SIZE);
 }
 
