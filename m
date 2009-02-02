Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZBBVzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZBBVzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZBBVzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:55:42 -0500
Received: from gw.goop.org ([64.81.55.164]:42412 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbZBBVzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:55:41 -0500
Message-ID: <49876BD3.5070804@goop.org>
Date: Mon, 02 Feb 2009 13:55:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>, Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   16 ++++++++++++++++
 arch/x86/xen/smp.c       |    7 ++++++-
 arch/x86/xen/xen-ops.h   |    2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff -r 42a1fb2574f0 arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c	Mon Feb 02 12:44:32 2009 -0800
+++ b/arch/x86/xen/enlighten.c	Mon Feb 02 13:24:32 2009 -0800
@@ -66,6 +66,8 @@
 
 struct shared_info xen_dummy_shared_info;
 
+void *xen_initial_gdt;
+
 /*
  * Point at some empty memory to start with. We map the real shared_info
  * page as soon as fixmap is up and running.
@@ -917,8 +919,19 @@
 	have_vcpu_info_placement = 0;
 #endif
 
-	/* setup percpu state */
+#ifdef CONFIG_X86_64
+	/*
+	 * Setup percpu state.  We only need to do this for 64-bit
+	 * because 32-bit already has %fs set properly.
+	 */
 	load_percpu_segment(0);
+#endif
+	/*
+	 * The only reliable way to retain the initial address of the
+	 * percpu gdt_page is to remember it here, so we can go and
+	 * mark it RW later, when the initial percpu area is freed.
+	 */
+	xen_initial_gdt = &per_cpu(gdt_page, 0);
 
 	xen_smp_init();
 
diff -r 42a1fb2574f0 arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c	Mon Feb 02 12:44:32 2009 -0800
+++ b/arch/x86/xen/smp.c	Mon Feb 02 13:24:32 2009 -0800
@@ -170,8 +170,7 @@
 
 	/* We've switched to the "real" per-cpu gdt, so make sure the
 	   old memory can be recycled */
-	make_lowmem_page_readwrite(__per_cpu_load +
-				   (unsigned long)&per_cpu_var(gdt_page));
+	make_lowmem_page_readwrite(xen_initial_gdt);
 
 	xen_setup_vcpu_info_placement();
 }
@@ -287,6 +286,9 @@
 	irq_ctx_init(cpu);
 #else
 	clear_tsk_thread_flag(idle, TIF_FORK);
+	per_cpu(kernel_stack, cpu) =
+		(unsigned long)task_stack_page(idle) -
+		KERNEL_STACK_OFFSET + THREAD_SIZE;
 #endif
 	xen_setup_timer(cpu);
 	xen_init_lock_cpu(cpu);
diff -r 42a1fb2574f0 arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h	Mon Feb 02 12:44:32 2009 -0800
+++ b/arch/x86/xen/xen-ops.h	Mon Feb 02 13:24:32 2009 -0800
@@ -10,6 +10,8 @@
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
 
+extern void *xen_initial_gdt;
+
 struct trap_info;
 void xen_copy_trap_info(struct trap_info *traps);
 


