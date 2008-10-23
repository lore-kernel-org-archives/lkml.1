Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYJWU4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYJWU4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYJWU4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:56:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:33617 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbYJWU4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:56:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,472,1220252400"; 
   d="scan'208";a="351719491"
Date: Thu, 23 Oct 2008 13:56:29 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Subject: Re: x86info results ioremap.c:226 __ioremap_caller+0xf2/0x2d6() WARNINGs
Message-ID: <20081023205629.GD18919@linux-os.sc.intel.com>
References: <20081021083615.GA4658@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021083615.GA4658@basil.nowhere.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 01:36:15AM -0700, Andi Kleen wrote:
> 
> When running x86info on a 2.6.27-git8 system I get
> 
> (the M taint is harmless in this case, came from other testing)
> 
> resource map sanity check conflict: 0x9e000 0x9efff 0x10000 0x9e7ff System RAM
> ------------[ cut here ]------------
> WARNING: at /home/lsrc/linux/arch/x86/mm/ioremap.c:226 __ioremap_caller+0xf2/0x2d6()
> Modules linked in:
> Pid: 8805, comm: x86info Tainted: G   M       2.6.27-git8 #110
> Call Trace:
>  [<ffffffff80236ba1>] warn_on_slowpath+0x58/0x75
>  [<ffffffff8021db80>] ? do_flush_tlb_all+0x0/0x37
>  [<ffffffff8023b058>] ? on_each_cpu+0x21/0x2c
>  [<ffffffff8023bc80>] ? iomem_map_sanity_check+0x61/0x89
>  [<ffffffff8022467b>] __ioremap_caller+0xf2/0x2d6
>  [<ffffffff803c0648>] ? read_mem+0x5a/0xca
>  [<ffffffff802248e4>] xlate_dev_mem_ptr+0x73/0x9e
>  [<ffffffff803c0648>] read_mem+0x5a/0xca
>  [<ffffffff8028ed19>] vfs_read+0xab/0x134
>  [<ffffffff8028f01e>] sys_read+0x47/0x70
>  [<ffffffff8020b27b>] system_call_fastpath+0x16/0x1b
> ---[ end trace 8262d1d3f66bcc38 ]---

Andi, Appended patch fixes this issue. Thanks.

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

Fix the warning by skipping the map conflict checks for low addresses
below 1MB. No PCI BAR's reside in this region anyway.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ae71e11..ed17c9b 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -221,9 +221,15 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 
 	/*
 	 * Check if the request spans more than any BAR in the iomem resource
-	 * tree.
+	 * tree. Skip this check for physical addresses below ISA_END_ADDRESS,
+	 * as typically some of the pages below these addresses will be shared
+	 * by both BIOS and system RAM(as reported by e820) and it will
+	 * result in a conflict if some app (through /dev/mem mapping)
+	 * is trying to accesses these pages.
+	 * NO PCI BAR's reside in this region anyway.
 	 */
-	WARN_ON(iomem_map_sanity_check(phys_addr, size));
+	WARN_ON(last_addr >= ISA_END_ADDRESS &&
+		iomem_map_sanity_check(phys_addr, size));
 
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
