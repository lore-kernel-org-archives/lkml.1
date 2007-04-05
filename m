Return-Path: <linux-kernel-owner+w=401wt.eu-S1767425AbXDEXgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767425AbXDEXgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 19:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXDEXgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 19:36:39 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34291 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209AbXDEXgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 19:36:38 -0400
Message-ID: <46158793.9010608@vmware.com>
Date: Thu, 05 Apr 2007 16:34:43 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com>
In-Reply-To: <46158674.5090709@vmware.com>
Content-Type: multipart/mixed;
 boundary="------------090003060907090101030201"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090003060907090101030201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Zachary Amsden wrote:
> I noticed this never got applied.  There was some feedback which I did 
> not include in this patch because I think it is inappropriate to touch 
> code outside vmi.c at this point for 2.6.21.  Please apply; this patch 
> is needed as a bugfix in 2.6.21.  An updated version for 2.6.22 will 
> come later which has a nicer interface.
>

Erm, stale patch, sorry.  This one instead.



--------------090003060907090101030201
Content-Type: text/plain;
 name="vmi-lazy-mmu-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmi-lazy-mmu-fix.patch"

Critical bugfix; when using software RAID, potentially USB or AIO in
highmem configurations, drivers are allowed to use kmap_atomic from
interrupt context.  This is incompatible with the current implementation
of lazy MMU mode, and means the kmap will silently fail, causing either
memory corruption or kernel panics.

The fix is to disable interrupts on the CPU when entering a lazy MMU
state; this is totally safe, as preemption is already disabled, and
lazy update state can neither be nested nor overlapping.  Thus per-cpu
variables to track the state and flags can be used to disable interrupts
during this critical region.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r eee69881b2f9 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Thu Apr 05 16:20:18 2007 -0700
+++ b/arch/i386/kernel/vmi.c	Thu Apr 05 16:31:12 2007 -0700
@@ -69,6 +69,7 @@ static struct {
 	void (*flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
+  	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
 /*
@@ -545,6 +546,31 @@ vmi_startup_ipi_hook(int phys_apicid, un
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
@@ -769,7 +795,7 @@ static inline int __init activate_vmi(vo
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
-	para_fill(set_lazy_mode, SetLazyMode);
+	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);

--------------090003060907090101030201--
