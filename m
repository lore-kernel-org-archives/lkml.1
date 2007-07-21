Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbXGUDi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbXGUDi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758984AbXGUDit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:38:49 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:44432 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758934AbXGUDis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:38:48 -0400
Date: Fri, 20 Jul 2007 20:38:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org,
       rostedt@goodmis.org, chrisw@sous-sol.org
Subject: Re: [PATCH] Use descriptor's functions instead of inline assembly
Message-ID: <20070721033813.GP3672@sequoia.sous-sol.org>
References: <1184955278.16311.30.camel@t60>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184955278.16311.30.camel@t60>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Glauber de Oliveira Costa (gcosta@redhat.com) wrote:
> This patch provides a new set of functions for managing the descriptor
> tables that can be used instead of putting the raw assembly in .c files.

Looks alright, some cleanups below

> Remodeling of store_tr() suggested by Frederik Deweerdt.
>     
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> 
> diff --git a/arch/x86_64/kernel/head64.c b/arch/x86_64/kernel/head64.c
> index 6c34bdd..dde41d7 100644
> --- a/arch/x86_64/kernel/head64.c
> +++ b/arch/x86_64/kernel/head64.c
> @@ -70,7 +70,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
>  
>  	for (i = 0; i < IDT_ENTRIES; i++)
>  		set_intr_gate(i, early_idt_handler);
> -	asm volatile("lidt %0" :: "m" (idt_descr));
> +	load_idt((const struct desc_ptr *)&idt_descr);

No need for extra casting

>  	early_printk("Kernel alive\n");
>  
> diff --git a/arch/x86_64/kernel/reboot.c b/arch/x86_64/kernel/reboot.c
> index 7503068..7c50a12 100644
> --- a/arch/x86_64/kernel/reboot.c
> +++ b/arch/x86_64/kernel/reboot.c
> @@ -11,6 +11,7 @@
>  #include <linux/sched.h>
>  #include <asm/io.h>
>  #include <asm/delay.h>
> +#include <asm/desc.h>
>  #include <asm/hw_irq.h>
>  #include <asm/system.h>
>  #include <asm/pgtable.h>
> @@ -132,7 +133,7 @@ void machine_emergency_restart(void)
>  		}
>  
>  		case BOOT_TRIPLE: 
> -			__asm__ __volatile__("lidt (%0)": :"r" (&no_idt));
> +			load_idt((const struct desc_ptr *)&no_idt);

same here, plus opportunity for cleanup

>  			__asm__ __volatile__("int3");
>  
>  			reboot_type = BOOT_KBD;
> diff --git a/arch/x86_64/kernel/setup64.c b/arch/x86_64/kernel/setup64.c
> index 1200aaa..fef7290 100644
> --- a/arch/x86_64/kernel/setup64.c
> +++ b/arch/x86_64/kernel/setup64.c
> @@ -224,8 +224,8 @@ void __cpuinit cpu_init (void)
>   		memcpy(cpu_gdt(cpu), cpu_gdt_table, GDT_SIZE);
>  
>  	cpu_gdt_descr[cpu].size = GDT_SIZE;
> -	asm volatile("lgdt %0" :: "m" (cpu_gdt_descr[cpu]));
> -	asm volatile("lidt %0" :: "m" (idt_descr));
> +	load_gdt((const struct desc_ptr *)&cpu_gdt_descr[cpu]);
> +	load_idt((const struct desc_ptr *)&idt_descr);

same here

>  	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
>  	syscall_init();
> diff --git a/arch/x86_64/kernel/suspend.c b/arch/x86_64/kernel/suspend.c
> index b39d478..ddedadf 100644
> --- a/arch/x86_64/kernel/suspend.c
> +++ b/arch/x86_64/kernel/suspend.c
> @@ -32,9 +32,9 @@ void __save_processor_state(struct saved_context *ctxt)
>  	/*
>  	 * descriptor tables
>  	 */
> -	asm volatile ("sgdt %0" : "=m" (ctxt->gdt_limit));
> -	asm volatile ("sidt %0" : "=m" (ctxt->idt_limit));
> -	asm volatile ("str %0"  : "=m" (ctxt->tr));
> +	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
> +	store_idt((struct desc_ptr *)&ctxt->idt_limit);

same here, opportunity for cleanup

> +	store_tr(ctxt->tr);
>  
>  	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
>  	/*
> @@ -91,8 +91,9 @@ void __restore_processor_state(struct saved_context *ctxt)
>  	 * now restore the descriptor tables to their proper values
>  	 * ltr is done i fix_processor_context().
>  	 */
> -	asm volatile ("lgdt %0" :: "m" (ctxt->gdt_limit));
> -	asm volatile ("lidt %0" :: "m" (ctxt->idt_limit));
> +	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
> +	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
> +	
>  
>  	/*
>  	 * segment registers
> diff --git a/include/asm-x86_64/desc.h b/include/asm-x86_64/desc.h
> index ac991b5..f2b0a6f 100644
> --- a/include/asm-x86_64/desc.h
> +++ b/include/asm-x86_64/desc.h
> @@ -20,6 +20,15 @@ extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
>  #define load_LDT_desc() asm volatile("lldt %w0"::"r" (GDT_ENTRY_LDT*8))
>  #define clear_LDT()  asm volatile("lldt %w0"::"r" (0))
>  
> +static inline unsigned long __store_tr(void)
> +{
> +       unsigned long tr;
> +       asm volatile ("str %w0":"=r" (tr));
> +       return tr;
> +}

native_store_tr (although I've no objection to just fixing the interface)


Index: linus-2.6/arch/x86_64/kernel/head64.c
===================================================================
--- linus-2.6.orig/arch/x86_64/kernel/head64.c
+++ linus-2.6/arch/x86_64/kernel/head64.c
@@ -70,7 +70,7 @@ void __init x86_64_start_kernel(char * r
 
 	for (i = 0; i < IDT_ENTRIES; i++)
 		set_intr_gate(i, early_idt_handler);
-	load_idt((const struct desc_ptr *)&idt_descr);
+	load_idt(&idt_descr);
 
 	early_printk("Kernel alive\n");
 
Index: linus-2.6/arch/x86_64/kernel/reboot.c
===================================================================
--- linus-2.6.orig/arch/x86_64/kernel/reboot.c
+++ linus-2.6/arch/x86_64/kernel/reboot.c
@@ -24,7 +24,7 @@
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-static long no_idt[3];
+static struct desc_ptr no_idt;
 static enum { 
 	BOOT_TRIPLE = 't',
 	BOOT_KBD = 'k'
@@ -133,7 +133,7 @@ void machine_emergency_restart(void)
 		}
 
 		case BOOT_TRIPLE: 
-			load_idt((const struct desc_ptr *)&no_idt);
+			load_idt(&no_idt);
 			__asm__ __volatile__("int3");
 
 			reboot_type = BOOT_KBD;
Index: linus-2.6/arch/x86_64/kernel/setup64.c
===================================================================
--- linus-2.6.orig/arch/x86_64/kernel/setup64.c
+++ linus-2.6/arch/x86_64/kernel/setup64.c
@@ -224,8 +224,8 @@ void __cpuinit cpu_init (void)
  		memcpy(cpu_gdt(cpu), cpu_gdt_table, GDT_SIZE);
 
 	cpu_gdt_descr[cpu].size = GDT_SIZE;
-	load_gdt((const struct desc_ptr *)&cpu_gdt_descr[cpu]);
-	load_idt((const struct desc_ptr *)&idt_descr);
+	load_gdt(&cpu_gdt_descr[cpu]);
+	load_idt(&idt_descr);
 
 	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
 	syscall_init();
Index: linus-2.6/arch/x86_64/kernel/suspend.c
===================================================================
--- linus-2.6.orig/arch/x86_64/kernel/suspend.c
+++ linus-2.6/arch/x86_64/kernel/suspend.c
@@ -32,8 +32,8 @@ void __save_processor_state(struct saved
 	/*
 	 * descriptor tables
 	 */
-	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
-	store_idt((struct desc_ptr *)&ctxt->idt_limit);
+	store_gdt(&ctxt->gdt);
+	store_idt(&ctxt->idt);
 	store_tr(ctxt->tr);
 
 	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
@@ -91,8 +91,8 @@ void __restore_processor_state(struct sa
 	 * now restore the descriptor tables to their proper values
 	 * ltr is done i fix_processor_context().
 	 */
-	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
-	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
+	load_gdt(&ctxt->gdt);
+	load_idt(&ctxt->idt);
 	
 
 	/*
Index: linus-2.6/include/asm-x86_64/desc.h
===================================================================
--- linus-2.6.orig/include/asm-x86_64/desc.h
+++ linus-2.6/include/asm-x86_64/desc.h
@@ -20,14 +20,14 @@ extern struct desc_struct cpu_gdt_table[
 #define load_LDT_desc() asm volatile("lldt %w0"::"r" (GDT_ENTRY_LDT*8))
 #define clear_LDT()  asm volatile("lldt %w0"::"r" (0))
 
-static inline unsigned long __store_tr(void)
+static inline unsigned long native_store_tr(void)
 {
        unsigned long tr;
        asm volatile ("str %w0":"=r" (tr));
        return tr;
 }
 
-#define store_tr(tr) (tr) = __store_tr()
+#define store_tr(tr) (tr) = native_store_tr()
 
 /*
  * This is the ldt that every process will get unless we need
Index: linus-2.6/arch/x86_64/kernel/machine_kexec.c
===================================================================
--- linus-2.6.orig/arch/x86_64/kernel/machine_kexec.c
+++ linus-2.6/arch/x86_64/kernel/machine_kexec.c
@@ -119,11 +119,8 @@ static void set_idt(void *newidt, u16 li
 	/* x86-64 supports unaliged loads & stores */
 	curidt.size    = limit;
 	curidt.address = (unsigned long)newidt;
-
-	__asm__ __volatile__ (
-		"lidtq %0\n"
-		: : "m" (curidt)
-		);
+	
+	load_idt(&curidt);
 };
 
 
@@ -135,10 +132,7 @@ static void set_gdt(void *newgdt, u16 li
 	curgdt.size    = limit;
 	curgdt.address = (unsigned long)newgdt;
 
-	__asm__ __volatile__ (
-		"lgdtq %0\n"
-		: : "m" (curgdt)
-		);
+	load_gdt(&curgdt);
 };
 
 static void load_segments(void)
Index: linus-2.6/include/asm-x86_64/suspend.h
===================================================================
--- linus-2.6.orig/include/asm-x86_64/suspend.h
+++ linus-2.6/include/asm-x86_64/suspend.h
@@ -18,12 +18,8 @@ struct saved_context {
 	unsigned long gs_base, gs_kernel_base, fs_base;
 	unsigned long cr0, cr2, cr3, cr4, cr8;
 	unsigned long efer;
-	u16 gdt_pad;
-	u16 gdt_limit;
-	unsigned long gdt_base;
-	u16 idt_pad;
-	u16 idt_limit;
-	unsigned long idt_base;
+	struct desc_ptr gdt;
+	struct desc_ptr idt;
 	u16 ldt;
 	u16 tss;
 	unsigned long tr;
