Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbYB0UnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbYB0UnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbYB0Um4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:42:56 -0500
Received: from www.tglx.de ([62.245.132.106]:46520 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbYB0Umz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:42:55 -0500
Date: Wed, 27 Feb 2008 21:42:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: hpwdt oops in clflush_cache_range
In-Reply-To: <20080227203655.GA30054@elte.hu>
Message-ID: <alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
References: <adad4qiwcmz.fsf@cisco.com> <alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de> <ada1w6y1bzk.fsf@cisco.com> <alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de> <20080227203655.GA30054@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > [    0.004000] Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
> > 
> > This one has 36bit physical address space. You can verify that via
> > /proc/cpuinfo
> > 
> > > [ 8425.910898] ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 21 (level, low) -> IRQ 21
> > > [ 8425.915097] hpwdt: New timer passed in is 30 seconds.
> > > [ 8425.915139] BUG: unable to handle kernel paging request at ffffc20001a0a000
> > > [ 8425.919087] IP: [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
> > > [ 8425.919087] PGD 1bf80e067 PUD 1bf80f067 PMD 1bb497067 PTE 80000047000ee17b
> > 
> > While the physical address of your ioremap is 47000ee000.
> > 
> > 2^ 36 == 1000000000
> > ---->    47000ee000
> > 
> > So the fault is not very surprising. Unfortunately we do not check, 
> > whether physaddr is inside the valid physical address space. I whip up 
> > a patch to do that.
> 
> also note that the driver would have faulted in a similar same way 
> anyway, the first time it tried to access that ioremap range. It's just 
> that due to the clflush we took the fault first in ioremap().
> 
> via the physical range check we'll do a more graceful exit and the 
> driver wont crash either. (it will just not work)

Roland,

does the patch below detect the wreckage ?

Thanks,
	tglx

--------------->

Subject: x86: check physical address range in ioremap
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 27 Feb 2008 20:57:40 +0100

Roland Dreier reported in http://lkml.org/lkml/2008/2/27/194

[ 8425.915139] BUG: unable to handle kernel paging request at ffffc20001a0a000
[ 8425.919087] IP: [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
[ 8425.919087] PGD 1bf80e067 PUD 1bf80f067 PMD 1bb497067 PTE 80000047000ee17b

This is on a Intel machine with 36bit physical address space. The PTE
entry references 47000ee000, which is outside of it.

Add a check for the physical address space and warn/printk about the
stupid caller.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/ioremap.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/ioremap.c
+++ linux-2.6/arch/x86/mm/ioremap.c
@@ -35,6 +35,18 @@ unsigned long __phys_addr(unsigned long 
 }
 EXPORT_SYMBOL(__phys_addr);
 
+static inline int phys_addr_valid(unsigned long addr)
+{
+	return addr < (1 << boot_cpu_data.x86_phys_bits);
+}
+
+#else
+
+static inline int phys_addr_valid(unsigned long addr)
+{
+	return 1;
+}
+
 #endif
 
 int page_is_ram(unsigned long pagenr)
@@ -118,6 +130,13 @@ static void __iomem *__ioremap(unsigned 
 	if (!size || last_addr < phys_addr)
 		return NULL;
 
+	if (!phys_addr_valid(phys_addr)) {
+		printk(KERN_WARNING "ioremap: invalid physical address %lx\n",
+		       phys_addr);
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
 	/*
 	 * Don't remap the low PCI/ISA area, it's always mapped..
 	 */
