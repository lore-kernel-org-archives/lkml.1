Return-Path: <linux-kernel-owner+w=401wt.eu-S935017AbXGTSOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017AbXGTSOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763650AbXGTSOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:14:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbXGTSOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:14:01 -0400
Subject: [PATCH] Use descriptor's functions instead of inline assembly
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org,
       rostedt@goodmis.org, chrisw@sous-sol.org
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 20 Jul 2007 15:14:38 -0300
Message-Id: <1184955278.16311.30.camel@t60>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a new set of functions for managing the descriptor
tables that can be used instead of putting the raw assembly in .c files.
    
Remodeling of store_tr() suggested by Frederik Deweerdt.
    
Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

diff --git a/arch/x86_64/kernel/head64.c b/arch/x86_64/kernel/head64.c
index 6c34bdd..dde41d7 100644
--- a/arch/x86_64/kernel/head64.c
+++ b/arch/x86_64/kernel/head64.c
@@ -70,7 +70,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 	for (i = 0; i < IDT_ENTRIES; i++)
 		set_intr_gate(i, early_idt_handler);
-	asm volatile("lidt %0" :: "m" (idt_descr));
+	load_idt((const struct desc_ptr *)&idt_descr);
 
 	early_printk("Kernel alive\n");
 
diff --git a/arch/x86_64/kernel/reboot.c b/arch/x86_64/kernel/reboot.c
index 7503068..7c50a12 100644
--- a/arch/x86_64/kernel/reboot.c
+++ b/arch/x86_64/kernel/reboot.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <asm/io.h>
 #include <asm/delay.h>
+#include <asm/desc.h>
 #include <asm/hw_irq.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -132,7 +133,7 @@ void machine_emergency_restart(void)
 		}
 
 		case BOOT_TRIPLE: 
-			__asm__ __volatile__("lidt (%0)": :"r" (&no_idt));
+			load_idt((const struct desc_ptr *)&no_idt);
 			__asm__ __volatile__("int3");
 
 			reboot_type = BOOT_KBD;
diff --git a/arch/x86_64/kernel/setup64.c b/arch/x86_64/kernel/setup64.c
index 1200aaa..fef7290 100644
--- a/arch/x86_64/kernel/setup64.c
+++ b/arch/x86_64/kernel/setup64.c
@@ -224,8 +224,8 @@ void __cpuinit cpu_init (void)
  		memcpy(cpu_gdt(cpu), cpu_gdt_table, GDT_SIZE);
 
 	cpu_gdt_descr[cpu].size = GDT_SIZE;
-	asm volatile("lgdt %0" :: "m" (cpu_gdt_descr[cpu]));
-	asm volatile("lidt %0" :: "m" (idt_descr));
+	load_gdt((const struct desc_ptr *)&cpu_gdt_descr[cpu]);
+	load_idt((const struct desc_ptr *)&idt_descr);
 
 	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
 	syscall_init();
diff --git a/arch/x86_64/kernel/suspend.c b/arch/x86_64/kernel/suspend.c
index b39d478..ddedadf 100644
--- a/arch/x86_64/kernel/suspend.c
+++ b/arch/x86_64/kernel/suspend.c
@@ -32,9 +32,9 @@ void __save_processor_state(struct saved_context *ctxt)
 	/*
 	 * descriptor tables
 	 */
-	asm volatile ("sgdt %0" : "=m" (ctxt->gdt_limit));
-	asm volatile ("sidt %0" : "=m" (ctxt->idt_limit));
-	asm volatile ("str %0"  : "=m" (ctxt->tr));
+	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
+	store_idt((struct desc_ptr *)&ctxt->idt_limit);
+	store_tr(ctxt->tr);
 
 	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
 	/*
@@ -91,8 +91,9 @@ void __restore_processor_state(struct saved_context *ctxt)
 	 * now restore the descriptor tables to their proper values
 	 * ltr is done i fix_processor_context().
 	 */
-	asm volatile ("lgdt %0" :: "m" (ctxt->gdt_limit));
-	asm volatile ("lidt %0" :: "m" (ctxt->idt_limit));
+	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
+	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
+	
 
 	/*
 	 * segment registers
diff --git a/include/asm-x86_64/desc.h b/include/asm-x86_64/desc.h
index ac991b5..f2b0a6f 100644
--- a/include/asm-x86_64/desc.h
+++ b/include/asm-x86_64/desc.h
@@ -20,6 +20,15 @@ extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
 #define load_LDT_desc() asm volatile("lldt %w0"::"r" (GDT_ENTRY_LDT*8))
 #define clear_LDT()  asm volatile("lldt %w0"::"r" (0))
 
+static inline unsigned long __store_tr(void)
+{
+       unsigned long tr;
+       asm volatile ("str %w0":"=r" (tr));
+       return tr;
+}
+
+#define store_tr(tr) (tr) = __store_tr()
+
 /*
  * This is the ldt that every process will get unless we need
  * something other than this.
@@ -31,6 +40,16 @@ extern struct desc_ptr cpu_gdt_descr[];
 /* the cpu gdt accessor */
 #define cpu_gdt(_cpu) ((struct desc_struct *)cpu_gdt_descr[_cpu].address)
 
+static inline void load_gdt(const struct desc_ptr *ptr)
+{
+	asm volatile("lgdt %w0"::"m" (*ptr));
+}
+
+static inline void store_gdt(struct desc_ptr *ptr)
+{
+       asm ("sgdt %w0":"=m" (*ptr));
+}
+
 static inline void _set_gate(void *adr, unsigned type, unsigned long func, unsigned dpl, unsigned ist)  
 {
 	struct gate_struct s; 	
@@ -71,6 +90,16 @@ static inline void set_system_gate_ist(int nr, void *func, unsigned ist)
 	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, ist);
 }
 
+static inline void load_idt(const struct desc_ptr *ptr)
+{
+	asm volatile("lidt %w0"::"m" (*ptr));
+}
+
+static inline void store_idt(struct desc_ptr *dtr)
+{
+       asm ("sidt %w0":"=m" (*dtr));
+}
+
 static inline void set_tssldt_descriptor(void *ptr, unsigned long tss, unsigned type, 
 					 unsigned size) 
 { 


