Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZEMAdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZEMAdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbZEMAdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:33:21 -0400
Received: from gw.goop.org ([64.81.55.164]:42276 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbZEMAdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:33:20 -0400
Message-ID: <4A0A154C.9080000@goop.org>
Date: Tue, 12 May 2009 17:33:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH FIXED] x86: use flush_tlb_others to implement flush_tlb_all
References: <4A09E5FE.2080507@goop.org> <4A0A0D7C.8050206@zytor.com>
In-Reply-To: <4A0A0D7C.8050206@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huh.  How's this?

	J


Subject: [PATCH] x86: use flush_tlb_others to implement flush_tlb_all

Use the flush_tlb_others() call to implement flush_tlb_all().  This is
useful because flush_tlb_others() already goes via paravirt_ops, and so
will be properly paravirtualized.  This needs a small extension of the
extension to the existing native_flush_tlb_others: the global flush is
indicated by setting the "mm" parameter to NULL, so that kernel mappings
are also flushed.

As a side effect of this change, we need to initialize
native_flush_tlb_others()'s spinlocks earlier, as flush_tlb_all() can
be called earlier in the boot sequence.

(Nothing similar is required for xen_flush_tlb_others, as we don't use
global mappings in a guest-visible way under Xen.)

[ Impact: Optimise flush_tlb_all under Xen ]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 16a5c84..4b663c5 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -89,6 +89,10 @@ static inline void __flush_tlb_one(unsigned long addr)
 
 #ifndef CONFIG_SMP
 
+static inline void __init init_smp_flush(void)
+{
+}
+
 #define flush_tlb() __flush_tlb()
 #define flush_tlb_all() __flush_tlb_all()
 #define local_flush_tlb() __flush_tlb()
@@ -129,6 +133,8 @@ static inline void reset_lazy_tlbstate(void)
 
 #define local_flush_tlb() __flush_tlb()
 
+extern void init_smp_flush(void);
+
 extern void flush_tlb_all(void);
 extern void flush_tlb_current_task(void);
 extern void flush_tlb_mm(struct mm_struct *);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b415843..747566c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -87,6 +87,7 @@
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
 #include <asm/bugs.h>
+#include <asm/tlbflush.h>
 
 #include <asm/system.h>
 #include <asm/vsyscall.h>
@@ -906,6 +907,9 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn);
 
+	/* Initialize cross-cpu tlb flushes */
+	init_smp_flush();
+
 #ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 821e970..efd9109 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -147,13 +147,25 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 		 * BUG();
 		 */
 
-	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
-		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
+	if (f->flush_mm == NULL ||
+	    f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
+		int tlbstate = percpu_read(cpu_tlbstate.state);
+
+		/* 
+		 * flush_mm == NULL means flush everything, including
+		 * global tlbs, which will only happen when flushing
+		 * kernel mappings. 
+		 */
+		if (f->flush_mm == NULL)
+			__flush_tlb_all();
+		else if (tlbstate == TLBSTATE_OK) {
 			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
 				__flush_tlb_one(f->flush_va);
-		} else
+		}
+
+		if (tlbstate == TLBSTATE_LAZY)
 			leave_mm(cpu);
 	}
 out:
@@ -217,16 +229,13 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	flush_tlb_others_ipi(cpumask, mm, va);
 }
 
-static int __cpuinit init_smp_flush(void)
+void __init init_smp_flush(void)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
 		spin_lock_init(&flush_state[i].tlbstate_lock);
-
-	return 0;
 }
-core_initcall(init_smp_flush);
 
 void flush_tlb_current_task(void)
 {
@@ -275,16 +284,16 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 	preempt_enable();
 }
 
-static void do_flush_tlb_all(void *info)
+void flush_tlb_all(void)
 {
-	unsigned long cpu = smp_processor_id();
+	/* flush_tlb_others expects preempt to be disabled */
+	get_cpu();
+
+	flush_tlb_others(cpu_online_mask, NULL, TLB_FLUSH_ALL);
 
 	__flush_tlb_all();
 	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
-		leave_mm(cpu);
-}
+		leave_mm(smp_processor_id());
 
-void flush_tlb_all(void)
-{
-	on_each_cpu(do_flush_tlb_all, NULL, 1);
+	put_cpu();
 }
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 760e3a5..42aa664 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1284,6 +1284,13 @@ static void xen_flush_tlb_single(unsigned long addr)
 	preempt_enable();
 }
 
+/* 
+ * Flush tlb on other cpus.  Xen can do this via a single hypercall
+ * rather than explicit IPIs, which has the nice property of avoiding
+ * any cpus which don't actually have dirty tlbs.  Unfortunately it
+ * doesn't give us an opportunity to kick out cpus which are in lazy
+ * tlb state, so we may end up reflushing some cpus unnecessarily.
+ */
 static void xen_flush_tlb_others(const struct cpumask *cpus,
 				 struct mm_struct *mm, unsigned long va)
 {


