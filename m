Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYAQXE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYAQXE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758950AbYAQXEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:04:33 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57553 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759398AbYAQXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:04:30 -0500
Date: Fri, 18 Jan 2008 04:34:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux ACPI mailing list <linux-acpi@vger.kernel.org>,
       Intel E/100 mailing list <e1000-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-mm1
Message-ID: <20080117230403.GA5411@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Linux ACPI mailing list <linux-acpi@vger.kernel.org>,
	Intel E/100 mailing list <e1000-devel@lists.sourceforge.net>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <20080117104021.25a8e562.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5E909A@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5E909A@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> [2008-01-17 11:22:19]:

> 
> 
> >-----Original Message-----
> >From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> >Sent: Thursday, January 17, 2008 10:40 AM
> >To: balbir@linux.vnet.ibm.com
> >Cc: linux-kernel@vger.kernel.org; Linux ACPI mailing list; 
> >Intel E/100 mailing list; Ingo Molnar; Thomas Gleixner; 
> >Pallipadi, Venkatesh
> >Subject: Re: 2.6.24-rc8-mm1
> >
> >On Thu, 17 Jan 2008 18:16:22 +0530 Balbir Singh 
> ><balbir@linux.vnet.ibm.com> wrote:
> >
> >> * Andrew Morton <akpm@linux-foundation.org> [2008-01-17 02:35:14]:
> >> 
> >> > 
> >> > 
> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2
> >.6.24-rc8/2.6.24-rc8-mm1/
> >> > 
> >> > - selinux is busted on one of my two selinux-enabled test machines.
> >> > 
> >> > - suspend-to-ram and suspend-to-disk are totally hosed on 
> >one of my test
> >> >   machines.  I guess I get to bisect this.
> >> > 
> >> > - git-nfsd is dropped due to conflicts with git-nfs
> >> > 
> >> > - git-newsetup is dropped due to conflicts with git-x86 (I think)
> >> > 
> >> > - git-perfmon is dropped due to conflicts with git-x86 (I think)
> >> > 
> >> > - git-kgdb is dropped due to conflicts with 
> >git-damn-near-everything
> >> > 
> >> > - git-block is dropped due to conflicts with the IDE tree
> >> > 
> >> > - kvm probably doesn't work properly because I couldn't be 
> >bothered fixing
> >> >   the conflicts between git-kvm and the driver tree
> >> > 
> >> > - the volume of rejects and build errors which are caused 
> >by subsystem
> >> >   maintainers fiddling with other people's stuff is quite 
> >out of control. 
> >> >   Something needs to happen here.
> >> 
> >> Hi, Andrew,
> >> 
> >> May be it was one of the conflicts, but my system fails to get
> >> ethernet working with this version. I see
> >> 
> >> e100: Intel(R) PRO/100 Network Driver, 3. 5.23-k4-NAPI
> >> e100: Copyright(c) 1999-2006 Intel Corporation
> >> ACPI: PCI Interrupt 0000:04:08.0[A] -> GSI 20 (level, low) -> IRQ 20
> >> modprobe:2584 conflicting cache attribute 50000000-50001000
> >> uncached<->default
> >> e100: 0000:04:08.0: e100_probe: Cannot map device registers, 
> >aborting.
> >> ACPI: PCI interrupt for device 0000:04:08.0 disabled
> >> e100: probe of 0000:04:08.0 failed with error -12
> >> 
> >It appears that the new PAT code didn't like e100's 
> >pci_iomap().  Venki, can you
> >take a look please?
> >
> 
> This seems similar to one problem we saw yday. May not be specific to
> e1000. May be at some generic pci code.
> 
> The problem is
> >> modprobe:2584 conflicting cache attribute 50000000-50001000
> >> uncached<->default
> 
> Some address range here is being mapped with conflicting types.
> Somewhere the range was mapped with default (write-back). Later
> pci_iomap() is mapping that region as uncacheable which is basically
> aliasing. PAT code detects the aliasing and fails the second uncacheable
> request which leads in the failure.
> 
> We are trying to find who exactly is mapping this with default at the
> beginning.
> Balbir: Full dmesg with debug boot parameter may help.
>

Venki/Andrew,

I think I found the root cause of the problem and a fix for it. 
The fix works for me.

Description
-----------

With the introduction of reserve_mattr() and free_mattr(), the ioremap* routines
started exploiting it. The recent 2.6.24-rc8-mm1 kernel has a peculiar problem
where in, certain devices disappear. In my case for example

e100: Intel(R) PRO/100 Network Driver, 3. 5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:04:08.0[A] -> GSI 20 (level, low) -> IRQ 20
modprobe:2584 conflicting cache attribute 50000000-50001000 uncached<->default
e100: 0000:04:08.0: e100_probe: Cannot map device registers, aborting.
ACPI: PCI interrupt for device 0000:04:08.0 disabled

On further analysis, it was discovered that quirk_e100_interrupt() calls
ioremap(), which reserves memory attributes for the e100 card, but iounmap()
does not free it. The patch below removes the check fixes this problem.
It removes for the check of (p->flags >> 20), which checks for architecture
specific bits set on the vm_struct's flags member. ioremap() unconditionally
reserves memory attributes, iounmap() should undo it.


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 arch/x86/mm/ioremap_32.c |    2 +-
 arch/x86/mm/ioremap_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/ioremap_32.c~fix-mattr-issue arch/x86/mm/ioremap_32.c
--- linux-2.6.24-rc8/arch/x86/mm/ioremap_32.c~fix-mattr-issue	2008-01-18 04:25:33.000000000 +0530
+++ linux-2.6.24-rc8-balbir/arch/x86/mm/ioremap_32.c	2008-01-18 04:25:53.000000000 +0530
@@ -220,7 +220,7 @@ void iounmap(volatile void __iomem *addr
 	}
 
 	/* Reset the direct mapping. Can block */
-	if (p->flags >> 20) {
+	if (p->flags) {
 		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
 		           p->flags>>20);
 		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
diff -puN arch/x86/mm/ioremap_64.c~fix-mattr-issue arch/x86/mm/ioremap_64.c
--- linux-2.6.24-rc8/arch/x86/mm/ioremap_64.c~fix-mattr-issue	2008-01-18 04:25:33.000000000 +0530
+++ linux-2.6.24-rc8-balbir/arch/x86/mm/ioremap_64.c	2008-01-18 04:25:53.000000000 +0530
@@ -191,7 +191,7 @@ void iounmap(volatile void __iomem *addr
 	}
 
 	/* Reset the direct mapping. Can block */
-	if (p->flags >> 20) {
+	if (p->flags) {
 		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
 		           p->flags>>20);
 		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
_
 
-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
