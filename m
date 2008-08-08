Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbYHHTQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbYHHTQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759247AbYHHTP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:15:59 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43166 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759085AbYHHTP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:15:57 -0400
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>
Cc: Zach Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489B6E83.7000202@kernel.org>
References: <1218136365.23770.52.camel@alok-dev1>
	 <489B6710.9000604@kernel.org>
	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
	 <489B6A5C.8030400@kernel.org>
	 <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>
	 <489B6E83.7000202@kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 08 Aug 2008 12:15:57 -0700
Message-Id: <1218222957.26510.16.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 14:52 -0700, H. Peter Anvin wrote:
> Zachary Amsden wrote:
> > My point is 1) these could be two separate calls, or 2) the lowmem
> > mapping table need not depend on max_low_pfn at all, it is safe to
> > create an extra large mapping which covers all possible lowmem instead
> > of the physical ram that is actually available.
> 
> Realistically speaking, any (virtual) machine which does *not* have a
> full complement of lowmem (i.e. less than 896 MB in the common case)
> will not suffer significatly from losing a few megabytes of address space.


Ok, since we are already past rc-2, I think we should fix the VMI
problem sooner than later.  Any approach that we eventually take to make
the fixmap's actually *fixed*, would be independent of this fix. 

Below is the patch which does away from the dependency of activating VMI
only after max_low_pfn is known. We move vmi_initialization very early
in the setup_arch code. 

Patch on top of current git. Please have a look and apply.
--
From: Alok N Kataria <akataria@vmware.com>

The lowmem mapping table created by VMI need not depend on max_low_pfn
at all.  Instead we now create an extra large mapping which covers all
possible lowmem instead of the physical ram that is actually available.

This allows the vmi initialization to be done before max_low_pfn could
be computed. We also move the vmi_init code very early in the boot process
so that nobody accidentally breaks the fixmap dependancy.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Acked-by: Zachary Amsden <zach@vmware.com>
---

 arch/x86/kernel/setup.c  |   16 ++++++++--------
 arch/x86/kernel/vmi_32.c |    3 ++-
 2 files changed, 10 insertions(+), 9 deletions(-)


diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2d88858..6e5823b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -604,6 +604,14 @@ void __init setup_arch(char **cmdline_p)
 	early_cpu_init();
 	early_ioremap_init();
 
+#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
+	/*
+	 * Must be before kernel pagetables are setup
+	 * or fixmap area is touched.
+	 */
+	vmi_init();
+#endif
+
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
 	edid_info = boot_params.edid_info;
@@ -817,14 +825,6 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
-	/*
-	 * Must be after max_low_pfn is determined, and before kernel
-	 * pagetables are setup.
-	 */
-	vmi_init();
-#endif
-
 	paravirt_pagetable_setup_start(swapper_pg_dir);
 	paging_init();
 	paravirt_pagetable_setup_done(swapper_pg_dir);
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 0a1b1a9..6ca515d 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -37,6 +37,7 @@
 #include <asm/timer.h>
 #include <asm/vmi_time.h>
 #include <asm/kmap_types.h>
+#include <asm/setup.h>
 
 /* Convenient for calling VMI functions indirectly in the ROM */
 typedef u32 __attribute__((regparm(1))) (VROMFUNC)(void);
@@ -683,7 +684,7 @@ void vmi_bringup(void)
 {
  	/* We must establish the lowmem mapping for MMU ops to work */
 	if (vmi_ops.set_linear_mapping)
-		vmi_ops.set_linear_mapping(0, (void *)__PAGE_OFFSET, max_low_pfn, 0);
+		vmi_ops.set_linear_mapping(0, (void *)__PAGE_OFFSET, MAXMEM_PFN, 0);
 }
 
 /*




