Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbYARBmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbYARBmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYARBmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:42:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:37466 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbYARBmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:42:24 -0500
X-ExtLoop1: 1
Date: Thu, 17 Jan 2008 17:42:23 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux ACPI mailing list <linux-acpi@vger.kernel.org>,
       Intel E/100 mailing list <e1000-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       andreas.herrmann3@amd.com
Subject: Re: 2.6.24-rc8-mm1
Message-ID: <20080118014223.GB25389@linux-os.sc.intel.com>
References: <20080117104021.25a8e562.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5E909A@orsmsx423.amr.corp.intel.com> <20080117230403.GA5411@balbir.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117230403.GA5411@balbir.in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 03:04:03PM -0800, Balbir Singh wrote:
> I think I found the root cause of the problem and a fix for it.
> The fix works for me.
> 

Thanks Balbir. But the appended fix is more clean and appropriate. Can you
please check if it works.
---

>From Balbir Singh:
> With the introduction of reserve_mattr() and free_mattr(), the ioremap*
> routines
> started exploiting it. The recent 2.6.24-rc8-mm1 kernel has a peculiar
> problem
> where in, certain devices disappear. In my case for example
>
> e100: Intel(R) PRO/100 Network Driver, 3. 5.23-k4-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> ACPI: PCI Interrupt 0000:04:08.0[A] -> GSI 20 (level, low) -> IRQ 20
> modprobe:2584 conflicting cache attribute 50000000-50001000
> uncached<->default
> e100: 0000:04:08.0: e100_probe: Cannot map device registers, aborting.
> ACPI: PCI interrupt for device 0000:04:08.0 disabled
>
> On further analysis, it was discovered that quirk_e100_interrupt() calls
> ioremap(), which reserves memory attributes for the e100 card, but
> iounmap()
> does not free it.

Fix the iounmap() to call free_matrr() unconditionally.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

diff --git a/arch/x86/mm/ioremap_32.c b/arch/x86/mm/ioremap_32.c
index ae9c8b3..4d5bea8 100644
--- a/arch/x86/mm/ioremap_32.c
+++ b/arch/x86/mm/ioremap_32.c
@@ -201,12 +201,11 @@ void iounmap(volatile void __iomem *addr)
 		return;
 	}
 
+	free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
+	           p->flags>>20);
 	/* Reset the direct mapping. Can block */
-	if (p->flags >> 20) {
-		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
-		           p->flags>>20);
+	if (p->flags >> 20)
 		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
-	}
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
diff --git a/arch/x86/mm/ioremap_64.c b/arch/x86/mm/ioremap_64.c
index 022b645..c766327 100644
--- a/arch/x86/mm/ioremap_64.c
+++ b/arch/x86/mm/ioremap_64.c
@@ -183,12 +183,11 @@ void iounmap(volatile void __iomem *addr)
 		return;
 	}
 
+	free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
+	           p->flags>>20);
 	/* Reset the direct mapping. Can block */
-	if (p->flags >> 20) {
-		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
-		           p->flags>>20);
+	if (p->flags >> 20)
 		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
-	}
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
