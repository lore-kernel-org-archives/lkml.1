Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbXCaHqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbXCaHqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 03:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXCaHqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 03:46:52 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:50836 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbXCaHqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 03:46:51 -0400
Message-ID: <460E1FC7.5030107@vmware.com>
Date: Sat, 31 Mar 2007 00:45:59 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] VMI paravirt-ops bugfix for 2.6.21
Content-Type: multipart/mixed;
 boundary="------------070701020207090800010905"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070701020207090800010905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

So lazy MMU mode is vulnerable to interrupts coming in and issuing 
kmap_atomic, which does not work when under lazy MMU mode.  The window 
for this is small, but it means highmem kernels, especially with heavy 
network, USB, or AIO workloads are vulnerable to getting invariably 
fatal pagefaults in interrupt handlers.  For now, the best fix is to 
simply disable and re-enable interrupts when entering and exiting lazy 
mode (which, btw, is already guaranteed to have preempt disabled).  For 
the future, a better fix is to simply exit lazy mode when issuing 
kmap_atomic, but I do not want to touch any generic code now for 2.6.21.

Hopefully there is still time to apply it.  Thanks to Jeremy 
Fitzhardinge for pointing this out.

Zach

--------------070701020207090800010905
Content-Type: text/plain;
 name="vmi-lazy-mmu-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmi-lazy-mmu-fix.patch"

Critical bugfix; when using software RAID, potentially USB or AIO in
highmem configurations, drivers are allowed to use kmap_atomic from
interrupt context.  This is incompatible with the current implementation
of lazy MMU mode, and means the kmap will silently fail, causing either
memory corruption or kernel panics.  This bug is only visible with >970
megs of RAM and extreme memory pressure, but nontheless extremely serious.

The fix is to disable interrupts on the CPU when entering a lazy MMU
state; this is totally safe, as preemption is already disabled, and
lazy update state can neither be nested nor overlapping.  Thus per-cpu
variables to track the state and flags can be used to disable interrupts
during this critical region.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r be8c61492e28 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Fri Mar 30 14:13:45 2007 -0700
+++ b/arch/i386/kernel/vmi.c	Fri Mar 30 14:18:16 2007 -0700
@@ -69,6 +69,7 @@ struct {
 	void (*flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
+ 	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
 /* XXX move this to alternative.h */
@@ -574,6 +575,31 @@ vmi_startup_ipi_hook(int phys_apicid, un
 }
 #endif
 
+static void vmi_set_lazy_mode(int new_mode)
+{
+	static DEFINE_PER_CPU(int, mode);
+	static DEFINE_PER_CPU(unsigned long, flags);
+	int cpu = smp_processor_id();
+
+	if (!vmi_ops.set_lazy_mode)
+		return;
+
+	/*
+	 * Modes do not nest or overlap, so we can simply disable
+	 * irqs when entering a mode and re-enable when leaving.
+	 */
+	BUG_ON(per_cpu(mode, cpu) && new_mode);
+	BUG_ON(!new_mode && !per_cpu(mode, cpu));
+	
+	if (new_mode)
+		local_irq_save(per_cpu(flags, cpu));
+	else
+		local_irq_restore(per_cpu(flags, cpu));
+
+	vmi_ops.set_lazy_mode(new_mode);
+	per_cpu(mode, cpu) = new_mode;
+}
+
 static inline int __init check_vmi_rom(struct vrom_header *rom)
 {
 	struct pci_header *pci;
@@ -804,7 +830,7 @@ static inline int __init activate_vmi(vo
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
-	para_fill(set_lazy_mode, SetLazyMode);
+	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);

--------------070701020207090800010905--
