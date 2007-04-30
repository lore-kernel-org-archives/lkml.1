Return-Path: <linux-kernel-owner+w=401wt.eu-S1423605AbXD3S1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423605AbXD3S1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423614AbXD3S1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:27:03 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:34080 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423530AbXD3S1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:27:00 -0400
Subject: Re: [PATCH] i386: init early_gdt_descr and idle task properly on
	voyager
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4633E507.7070002@goop.org>
References: <4633E507.7070002@goop.org>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 13:26:55 -0500
Message-Id: <1177957615.3674.53.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 17:21 -0700, Jeremy Fitzhardinge wrote:
> Initialize early_gdt_descr and idle task properly.
> 
> [ Incremental fix for "i386: introduce voyager smp_ops, fix voyager build" ]

Still not quite enough.  this is what I need to complete the build:

James

Index: voyager-2.6/arch/i386/kernel/cpu/common.c
===================================================================
--- voyager-2.6.orig/arch/i386/kernel/cpu/common.c	2007-04-30 12:49:45.000000000 -0500
+++ voyager-2.6/arch/i386/kernel/cpu/common.c	2007-04-30 13:03:42.000000000 -0500
@@ -21,6 +21,9 @@
 
 #include "cpu.h"
 
+DEFINE_PER_CPU(unsigned long, this_cpu_off);
+EXPORT_PER_CPU_SYMBOL(this_cpu_off);
+
 DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { 0x0000ffff, 0x00cf9a00 },
 	[GDT_ENTRY_KERNEL_DS] = { 0x0000ffff, 0x00cf9200 },
@@ -650,6 +653,22 @@ void switch_to_new_gdt(void)
 	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
 }
 
+/* Initialize the CPU's GDT.  This is either the boot CPU doing itself
+   (still using the master per-cpu area), or a CPU doing it for a
+   secondary which will soon come up. */
+__cpuinit void init_gdt(int cpu)
+{
+	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+
+	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
+			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
+			__per_cpu_offset[cpu], 0xFFFFF,
+			0x80 | DESCTYPE_S | 0x2, 0x8);
+
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
+	per_cpu(cpu_number, cpu) = cpu;
+}
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
Index: voyager-2.6/arch/i386/kernel/smpboot.c
===================================================================
--- voyager-2.6.orig/arch/i386/kernel/smpboot.c	2007-04-30 12:49:45.000000000 -0500
+++ voyager-2.6/arch/i386/kernel/smpboot.c	2007-04-30 13:03:45.000000000 -0500
@@ -99,9 +99,6 @@ EXPORT_SYMBOL(x86_cpu_to_apicid);
 
 u8 apicid_2_node[MAX_APICID];
 
-DEFINE_PER_CPU(unsigned long, this_cpu_off);
-EXPORT_PER_CPU_SYMBOL(this_cpu_off);
-
 /*
  * Trampoline 80x86 program as an array.
  */
@@ -764,25 +761,6 @@ static inline struct task_struct * alloc
 #define alloc_idle_task(cpu) fork_idle(cpu)
 #endif
 
-/* Initialize the CPU's GDT.  This is either the boot CPU doing itself
-   (still using the master per-cpu area), or a CPU doing it for a
-   secondary which will soon come up. */
-static __cpuinit void init_gdt(int cpu)
-{
-	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
-
-	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
-			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
-			__per_cpu_offset[cpu], 0xFFFFF,
-			0x80 | DESCTYPE_S | 0x2, 0x8);
-
-	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
-	per_cpu(cpu_number, cpu) = cpu;
-}
-
-/* Defined in head.S */
-extern struct Xgt_desc_struct early_gdt_descr;
-
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
Index: voyager-2.6/include/asm-i386/processor.h
===================================================================
--- voyager-2.6.orig/include/asm-i386/processor.h	2007-04-30 12:49:45.000000000 -0500
+++ voyager-2.6/include/asm-i386/processor.h	2007-04-30 12:54:47.000000000 -0500
@@ -749,6 +749,10 @@ extern unsigned long boot_option_idle_ov
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
+/* Defined in head.S */
+extern struct Xgt_desc_struct early_gdt_descr;
+
+extern void init_gdt(int cpu);
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(void);
 extern void cpu_init(void);


