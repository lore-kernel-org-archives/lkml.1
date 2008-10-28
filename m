Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYJ1Spz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYJ1Spz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYJ1Spo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:45:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:39258 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYJ1Spn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:45:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,500,1220252400"; 
   d="scan'208";a="66543380"
Date: Tue, 28 Oct 2008 11:45:42 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: x86info results ioremap.c:226 __ioremap_caller+0xf2/0x2d6() WARNINGs
Message-ID: <20081028184542.GI30573@linux-os.sc.intel.com>
References: <20081021083615.GA4658@basil.nowhere.org> <20081023205629.GD18919@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023205629.GD18919@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 01:56:29PM -0700, Siddha, Suresh B wrote:
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: fix x86info ioremap sanity check warnings
> 
> Andi Kleen reported:
> > When running x86info on a 2.6.27-git8 system I get
> >
> > resource map sanity check conflict: 0x9e000 0x9efff 0x10000 0x9e7ff System RAM
> > ------------[ cut here ]------------
> > WARNING: at /home/lsrc/linux/arch/x86/mm/ioremap.c:226 __ioremap_caller+0xf2/0x2d6()
> > ...
> 
> Some of the pages below the 1MB ISA addresses will be shared typically by both
> BIOS and system usable RAM. For example:
> 	BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> 	BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> 
> x86info reads the low physical address using /dev/mem, which internally
> uses ioremap() for accessing non RAM pages. ioremap() of such low
> pages conflicts with multiple resource entities leading to the
> above warning.
> 
> Fix the warning by skipping the map conflict checks for low addresses
> below 1MB. No PCI BAR's reside in this region anyway.

More cleaner patch(which fixes the issue in a generic fashion) for this
is appended. Ingo, please consider this for inclusion instead.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: fix x86info ioremap sanity check warnings

Andi Kleen reported:
> When running x86info on a 2.6.27-git8 system I get
>
> resource map sanity check conflict: 0x9e000 0x9efff 0x10000 0x9e7ff System RAM
> ------------[ cut here ]------------
> WARNING: at /home/lsrc/linux/arch/x86/mm/ioremap.c:226 __ioremap_caller+0xf2/0x2d6()
> ...

Some of the pages below the 1MB ISA addresses will be shared typically by both
BIOS and system usable RAM. For example:
	BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
	BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)

x86info reads the low physical address using /dev/mem, which internally
uses ioremap() for accessing non RAM pages. ioremap() of such low
pages conflicts with multiple resource entities leading to the
above warning.

Change the iomem_map_sanity_check() to allow mapping a page spanning multiple
resource entities (minimum granularity that one can map is a page anyhow).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/resource.c b/kernel/resource.c
index 4089d12..bee50d7 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -17,6 +17,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/device.h>
+#include <linux/pfn.h>
 #include <asm/io.h>
 
 
@@ -849,7 +850,8 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 			continue;
 		if (p->end < addr)
 			continue;
-		if (p->start <= addr && (p->end >= addr + size - 1))
+		if (PFN_DOWN(p->start) <= PFN_DOWN(addr) &&
+		    PFN_DOWN(p->end) >= PFN_DOWN(addr + size - 1))
 			continue;
 		printk(KERN_WARNING "resource map sanity check conflict: "
 		       "0x%llx 0x%llx 0x%llx 0x%llx %s\n",
