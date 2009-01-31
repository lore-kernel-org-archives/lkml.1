Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZAaBmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZAaBmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 20:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbZAaBm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 20:42:28 -0500
Received: from gw.goop.org ([64.81.55.164]:36854 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbZAaBm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 20:42:27 -0500
Message-ID: <4983AC7F.5020207@goop.org>
Date: Fri, 30 Jan 2009 17:42:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Brian Gerst <brgerst@gmail.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 1/3] xen: setup percpu data pointers
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to access percpu data fairly early, so set up the percpu
registers as soon as possible.  We only need to load the appropriate
segment register.  We already have a GDT, but its hard to change it
early because we need to manipulate the pagetable to do so, and that
hasn't been set up yet.

Also, set the kernel stack when bringing up secondary CPUs.  If we
don't they all end up sharing the same stack...

[This depends on the two other percpu patches that Tejun has in his tree. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   16 ++++++++++++++++
 arch/x86/xen/smp.c       |    4 +++-
 arch/x86/xen/xen-ops.h   |    2 ++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff -r 9f052779cc5d arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c	Fri Jan 30 17:20:43 2009 -0800
+++ b/arch/x86/xen/enlighten.c	Fri Jan 30 17:37:05 2009 -0800
@@ -61,6 +61,8 @@
 enum xen_domain_type xen_domain_type = XEN_NATIVE;
 EXPORT_SYMBOL_GPL(xen_domain_type);
 
+void *xen_initial_gdt;
+
 /*
  * Identity map, in addition to plain kernel map.  This needs to be
  * large enough to allocate page table pages to allocate the rest.
@@ -1646,6 +1648,20 @@
 	have_vcpu_info_placement = 0;
 #endif
 
+#ifdef CONFIG_X86_64
+	/*
+	 * Setup percpu state.  We only need to do this for 64-bit
+         * because 32-bit already has %fs set properly.
+	 */
+	load_percpu_segment(0);
+#endif
+	/*
+	 * The only reliable way to retain the initial address of the
+	 * percpu gdt_page is to remember it here, so we can go and
+	 * mark it RW later, when the initial percpu area is freed.
+	 */
+	xen_initial_gdt = &per_cpu(gdt_page, 0);
+
 	xen_smp_init();
 
 	/* Get mfn list */
diff -r 9f052779cc5d arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c	Fri Jan 30 17:20:43 2009 -0800
+++ b/arch/x86/xen/smp.c	Fri Jan 30 17:37:05 2009 -0800
@@ -170,7 +170,7 @@
 
 	/* We've switched to the "real" per-cpu gdt, so make sure the
 	   old memory can be recycled */
-	make_lowmem_page_readwrite(&per_cpu_var(gdt_page));
+	make_lowmem_page_readwrite(xen_initial_gdt);
 
 	xen_setup_vcpu_info_placement();
 }
@@ -235,6 +235,8 @@
 	ctxt->user_regs.ss = __KERNEL_DS;
 #ifdef CONFIG_X86_32
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
+#else
+	ctxt->gs_base_kernel = per_cpu_offset(cpu);
 #endif
 	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
 	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
@@ -284,6 +286,9 @@
 	irq_ctx_init(cpu);
 #else
 	clear_tsk_thread_flag(idle, TIF_FORK);
+	per_cpu(kernel_stack, cpu) =
+		(unsigned long)task_stack_page(idle) -
+		KERNEL_STACK_OFFSET + THREAD_SIZE;
 #endif
 	xen_setup_timer(cpu);
 	xen_init_lock_cpu(cpu);
diff -r 9f052779cc5d arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h	Fri Jan 30 17:20:43 2009 -0800
+++ b/arch/x86/xen/xen-ops.h	Fri Jan 30 17:37:05 2009 -0800
@@ -10,6 +10,8 @@
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
 
+extern void *xen_initial_gdt;
+
 struct trap_info;
 void xen_copy_trap_info(struct trap_info *traps);
 


