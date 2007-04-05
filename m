Return-Path: <linux-kernel-owner+w=401wt.eu-S1767421AbXDEXb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767421AbXDEXb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 19:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767422AbXDEXb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 19:31:57 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:59807 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767421AbXDEXb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 19:31:56 -0400
Message-ID: <46158674.5090709@vmware.com>
Date: Thu, 05 Apr 2007 16:29:56 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] Bugfix for VMI paravirt ops
Content-Type: multipart/mixed;
 boundary="------------020302040607040003080605"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020302040607040003080605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I noticed this never got applied.  There was some feedback which I did 
not include in this patch because I think it is inappropriate to touch 
code outside vmi.c at this point for 2.6.21.  Please apply; this patch 
is needed as a bugfix in 2.6.21.  An updated version for 2.6.22 will 
come later which has a nicer interface.

Zach

--------------020302040607040003080605
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

Index: ubuntu-2.6.20/arch/i386/kernel/vmi.c
===================================================================
--- ubuntu-2.6.20.orig/arch/i386/kernel/vmi.c	2007-03-29 21:17:47.000000000 -0700
+++ ubuntu-2.6.20/arch/i386/kernel/vmi.c	2007-03-30 00:01:20.000000000 -0700
@@ -69,6 +69,7 @@
 	void (fastcall *flush_tlb)(int);
 	void (fastcall *set_initial_ap_state)(int, int);
 	void (fastcall *halt)(void);
+ 	void (fastcall *set_lazy_mode)(int mode);
 } vmi_ops;
  
 /* XXX move this to alternative.h */
@@ -577,6 +578,31 @@
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
@@ -806,7 +832,7 @@
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
-	para_fill(set_lazy_mode, SetLazyMode);
+	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);

--------------020302040607040003080605--
