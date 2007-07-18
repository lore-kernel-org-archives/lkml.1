Return-Path: <linux-kernel-owner+w=401wt.eu-S937302AbXGRXh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937302AbXGRXh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936630AbXGRXaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:30:10 -0400
Received: from ozlabs.org ([203.10.76.45]:34129 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936625AbXGRXaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:30:07 -0400
Subject: Re: [PATCH 2/3] i386: use x86_64's desc_def.h
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1184801261.10380.174.camel@localhost.localdomain>
References: <1184743355.10380.112.camel@localhost.localdomain>
	 <1184743422.10380.114.camel@localhost.localdomain>
	 <469E3DA1.3010600@vmware.com>
	 <1184801261.10380.174.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 09:29:43 +1000
Message-Id: <1184801383.10380.176.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 09:27 +1000, Rusty Russell wrote:
> On Wed, 2007-07-18 at 09:19 -0700, Zachary Amsden wrote:
> > > +#define GET_CONTENTS(desc)	(((desc)->raw32.b >> 10) & 3)
> > > +#define GET_WRITABLE(desc)	(((desc)->raw32.b >>  9) & 1)
> > 
> > You got rid of the duplicate definitions here, but then added new 
> > duplicates (GET_CONTENTS / WRITABLE).  Can you stick them in desc.h?
> 
> To be honest, I got sick of counting bits at this point, and didn't want
> to introduce bugs.
> 
> Here's the updated version of PATCH 1/3:

And 2/3:
===
i386: use x86_64's desc_def.h

The main effect is to change the definition of "struct desc_struct" to
a union of more complex types.

I kept the old 32-bit comparisons, but many could be changed to use
the 64-bit "desc->raw".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r e80364496ab1 arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c	Thu Jul 19 09:09:28 2007 +1000
+++ b/arch/i386/kernel/cpu/common.c	Thu Jul 19 09:12:33 2007 +1000
@@ -22,31 +22,31 @@
 #include "cpu.h"
 
 DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
-	[GDT_ENTRY_KERNEL_CS] = { 0x0000ffff, 0x00cf9a00 },
-	[GDT_ENTRY_KERNEL_DS] = { 0x0000ffff, 0x00cf9200 },
-	[GDT_ENTRY_DEFAULT_USER_CS] = { 0x0000ffff, 0x00cffa00 },
-	[GDT_ENTRY_DEFAULT_USER_DS] = { 0x0000ffff, 0x00cff200 },
+	[GDT_ENTRY_KERNEL_CS] = { { 0x00cf9a000000ffffULL } },
+	[GDT_ENTRY_KERNEL_DS] = { { 0x00cf92000000ffffULL } },
+	[GDT_ENTRY_DEFAULT_USER_CS] = { { 0x00cffa000000ffffULL } },
+	[GDT_ENTRY_DEFAULT_USER_DS] = { { 0x00cff2000000ffffULL } },
 	/*
 	 * Segments used for calling PnP BIOS have byte granularity.
 	 * They code segments and data segments have fixed 64k limits,
 	 * the transfer segment sizes are set at run time.
 	 */
-	[GDT_ENTRY_PNPBIOS_CS32] = { 0x0000ffff, 0x00409a00 },/* 32-bit code */
-	[GDT_ENTRY_PNPBIOS_CS16] = { 0x0000ffff, 0x00009a00 },/* 16-bit code */
-	[GDT_ENTRY_PNPBIOS_DS] = { 0x0000ffff, 0x00009200 }, /* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_TS1] = { 0x00000000, 0x00009200 },/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_TS2] = { 0x00000000, 0x00009200 },/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_CS32] = { { 0x00409a000000ffffULL } },/* 32-bit code */
+	[GDT_ENTRY_PNPBIOS_CS16] = { { 0x00009a000000ffffULL } },/* 16-bit code */
+	[GDT_ENTRY_PNPBIOS_DS] = { { 0x000092000000ffffULL } }, /* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_TS1] = { { 0x0000920000000000ULL } },/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_TS2] = { { 0x0000920000000000ULL } },/* 16-bit data */
 	/*
 	 * The APM segments have byte granularity and their bases
 	 * are set at run time.  All have 64k limits.
 	 */
-	[GDT_ENTRY_APMBIOS_BASE] = { 0x0000ffff, 0x00409a00 },/* 32-bit code */
+	[GDT_ENTRY_APMBIOS_BASE] = { { 0x00409a000000ffffULL } },/* 32-bit code */
 	/* 16-bit code */
-	[GDT_ENTRY_APMBIOS_BASE+1] = { 0x0000ffff, 0x00009a00 },
-	[GDT_ENTRY_APMBIOS_BASE+2] = { 0x0000ffff, 0x00409200 }, /* data */
-
-	[GDT_ENTRY_ESPFIX_SS] = { 0x00000000, 0x00c09200 },
-	[GDT_ENTRY_PERCPU] = { 0x00000000, 0x00000000 },
+	[GDT_ENTRY_APMBIOS_BASE+1] = { { 0x00009a000000ffffULL } },
+	[GDT_ENTRY_APMBIOS_BASE+2] = { { 0x004092000000ffffULL } }, /* data */
+
+	[GDT_ENTRY_ESPFIX_SS] = { { 0x00c0920000000000ULL } },
+	[GDT_ENTRY_PERCPU] = { { 0x0000000000000000ULL } },
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
diff -r e80364496ab1 arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c	Thu Jul 19 09:09:28 2007 +1000
+++ b/arch/i386/kernel/process.c	Thu Jul 19 09:13:33 2007 +1000
@@ -466,8 +466,8 @@ int copy_thread(int nr, unsigned long cl
 			goto out;
 
 		desc = p->thread.tls_array + idx - GDT_ENTRY_TLS_MIN;
-		desc->a = LDT_entry_a(&info);
-		desc->b = LDT_entry_b(&info);
+		desc->raw32.a = LDT_entry_a(&info);
+		desc->raw32.b = LDT_entry_b(&info);
 	}
 
 	err = 0;
@@ -863,11 +863,11 @@ asmlinkage int sys_set_thread_area(struc
 	cpu = get_cpu();
 
 	if (LDT_empty(&info)) {
-		desc->a = 0;
-		desc->b = 0;
+		desc->raw32.a = 0;
+		desc->raw32.b = 0;
 	} else {
-		desc->a = LDT_entry_a(&info);
-		desc->b = LDT_entry_b(&info);
+		desc->raw32.a = LDT_entry_a(&info);
+		desc->raw32.b = LDT_entry_b(&info);
 	}
 	load_TLS(t, cpu);
 
@@ -879,23 +879,6 @@ asmlinkage int sys_set_thread_area(struc
 /*
  * Get the current Thread-Local Storage area:
  */
-
-#define GET_BASE(desc) ( \
-	(((desc)->a >> 16) & 0x0000ffff) | \
-	(((desc)->b << 16) & 0x00ff0000) | \
-	( (desc)->b        & 0xff000000)   )
-
-#define GET_LIMIT(desc) ( \
-	((desc)->a & 0x0ffff) | \
-	 ((desc)->b & 0xf0000) )
-	
-#define GET_32BIT(desc)		(((desc)->b >> 22) & 1)
-#define GET_CONTENTS(desc)	(((desc)->b >> 10) & 3)
-#define GET_WRITABLE(desc)	(((desc)->b >>  9) & 1)
-#define GET_LIMIT_PAGES(desc)	(((desc)->b >> 23) & 1)
-#define GET_PRESENT(desc)	(((desc)->b >> 15) & 1)
-#define GET_USEABLE(desc)	(((desc)->b >> 20) & 1)
-
 asmlinkage int sys_get_thread_area(struct user_desc __user *u_info)
 {
 	struct user_desc info;
@@ -912,14 +895,14 @@ asmlinkage int sys_get_thread_area(struc
 	desc = current->thread.tls_array + idx - GDT_ENTRY_TLS_MIN;
 
 	info.entry_number = idx;
-	info.base_addr = GET_BASE(desc);
-	info.limit = GET_LIMIT(desc);
-	info.seg_32bit = GET_32BIT(desc);
-	info.contents = GET_CONTENTS(desc);
-	info.read_exec_only = !GET_WRITABLE(desc);
-	info.limit_in_pages = GET_LIMIT_PAGES(desc);
-	info.seg_not_present = !GET_PRESENT(desc);
-	info.useable = GET_USEABLE(desc);
+	info.base_addr = get_seg_desc_base(&desc->seg);
+	info.limit = get_seg_desc_limit(&desc->seg);
+	info.seg_32bit = desc->seg.d;
+	info.contents = get_seg_desc_contents(&desc->seg);
+	info.read_exec_only = !get_seg_desc_writable(&desc->seg);
+	info.limit_in_pages = desc->seg.g;
+	info.seg_not_present = !desc->seg.p;
+	info.useable = desc->seg.avl;
 
 	if (copy_to_user(u_info, &info, sizeof(info)))
 		return -EFAULT;
diff -r e80364496ab1 arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c	Thu Jul 19 09:09:28 2007 +1000
+++ b/arch/i386/kernel/ptrace.c	Thu Jul 19 09:14:22 2007 +1000
@@ -283,37 +283,20 @@ ptrace_get_thread_area(struct task_struc
 /*
  * Get the current Thread-Local Storage area:
  */
-
-#define GET_BASE(desc) ( \
-	(((desc)->a >> 16) & 0x0000ffff) | \
-	(((desc)->b << 16) & 0x00ff0000) | \
-	( (desc)->b        & 0xff000000)   )
-
-#define GET_LIMIT(desc) ( \
-	((desc)->a & 0x0ffff) | \
-	 ((desc)->b & 0xf0000) )
-
-#define GET_32BIT(desc)		(((desc)->b >> 22) & 1)
-#define GET_CONTENTS(desc)	(((desc)->b >> 10) & 3)
-#define GET_WRITABLE(desc)	(((desc)->b >>  9) & 1)
-#define GET_LIMIT_PAGES(desc)	(((desc)->b >> 23) & 1)
-#define GET_PRESENT(desc)	(((desc)->b >> 15) & 1)
-#define GET_USEABLE(desc)	(((desc)->b >> 20) & 1)
-
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 
 	desc = child->thread.tls_array + idx - GDT_ENTRY_TLS_MIN;
 
 	info.entry_number = idx;
-	info.base_addr = GET_BASE(desc);
-	info.limit = GET_LIMIT(desc);
-	info.seg_32bit = GET_32BIT(desc);
-	info.contents = GET_CONTENTS(desc);
-	info.read_exec_only = !GET_WRITABLE(desc);
-	info.limit_in_pages = GET_LIMIT_PAGES(desc);
-	info.seg_not_present = !GET_PRESENT(desc);
-	info.useable = GET_USEABLE(desc);
+	info.base_addr = get_seg_desc_base(&desc->seg);
+	info.limit = get_seg_desc_limit(&desc->seg);
+	info.seg_32bit =  desc->seg.d;
+	info.contents = get_seg_desc_contents(&desc->seg);
+	info.read_exec_only = !get_seg_desc_writable(&desc->seg);
+	info.limit_in_pages = desc->seg.g;
+	info.seg_not_present = !desc->seg.p;
+	info.useable = desc->seg.avl;
 
 	if (copy_to_user(user_desc, &info, sizeof(info)))
 		return -EFAULT;
@@ -339,11 +322,11 @@ ptrace_set_thread_area(struct task_struc
 
 	desc = child->thread.tls_array + idx - GDT_ENTRY_TLS_MIN;
 	if (LDT_empty(&info)) {
-		desc->a = 0;
-		desc->b = 0;
+		desc->raw32.a = 0;
+		desc->raw32.b = 0;
 	} else {
-		desc->a = LDT_entry_a(&info);
-		desc->b = LDT_entry_b(&info);
+		desc->raw32.a = LDT_entry_a(&info);
+		desc->raw32.b = LDT_entry_b(&info);
 	}
 
 	return 0;
diff -r e80364496ab1 arch/i386/kernel/smpcommon.c
--- a/arch/i386/kernel/smpcommon.c	Thu Jul 19 09:09:28 2007 +1000
+++ b/arch/i386/kernel/smpcommon.c	Thu Jul 19 09:12:33 2007 +1000
@@ -14,8 +14,8 @@ __cpuinit void init_gdt(int cpu)
 {
 	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
 
-	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
-			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
+	pack_descriptor(&gdt[GDT_ENTRY_PERCPU].raw32.a,
+			&gdt[GDT_ENTRY_PERCPU].raw32.b,
 			__per_cpu_offset[cpu], 0xFFFFF,
 			0x80 | DESCTYPE_S | 0x2, 0x8);
 
diff -r e80364496ab1 arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c	Thu Jul 19 09:09:28 2007 +1000
+++ b/arch/i386/kernel/traps.c	Thu Jul 19 09:12:33 2007 +1000
@@ -71,7 +71,7 @@ char ignore_fpu_irq = 0;
  * F0 0F bug workaround.. We have a special link segment
  * for this.
  */
-struct desc_struct idt_table[256] __attribute__((__section__(".data.idt"))) = { {0, 0}, };
+struct desc_struct idt_table[256] __attribute__((__section__(".data.idt")));
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
diff -r e80364496ab1 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Thu Jul 19 09:09:28 2007 +1000
+++ b/arch/i386/kernel/vmi.c	Thu Jul 19 09:12:33 2007 +1000
@@ -178,8 +178,8 @@ static void vmi_cpuid(unsigned int *eax,
 
 static inline void vmi_maybe_load_tls(struct desc_struct *gdt, int nr, struct desc_struct *new)
 {
-	if (gdt[nr].a != new->a || gdt[nr].b != new->b)
-		write_gdt_entry(gdt, nr, new->a, new->b);
+	if (gdt[nr].raw32.a != new->raw32.a || gdt[nr].raw32.b != new->raw32.b)
+		write_gdt_entry(gdt, nr, new->raw32.a, new->raw32.b);
 }
 
 static void vmi_load_tls(struct thread_struct *t, unsigned int cpu)
diff -r e80364496ab1 include/asm-i386/desc.h
--- a/include/asm-i386/desc.h	Thu Jul 19 09:09:28 2007 +1000
+++ b/include/asm-i386/desc.h	Thu Jul 19 09:12:33 2007 +1000
@@ -81,8 +81,8 @@ static inline void write_dt_entry(struct
 static inline void write_dt_entry(struct desc_struct *dt,
 				  int entry, u32 entry_low, u32 entry_high)
 {
-	dt[entry].a = entry_low;
-	dt[entry].b = entry_high;
+	dt[entry].raw32.a = entry_low;
+	dt[entry].raw32.b = entry_high;
 }
 
 static inline void native_set_ldt(const void *addr, unsigned int entries)
diff -r e80364496ab1 include/asm-i386/processor.h
--- a/include/asm-i386/processor.h	Thu Jul 19 09:09:28 2007 +1000
+++ b/include/asm-i386/processor.h	Thu Jul 19 09:12:33 2007 +1000
@@ -22,19 +22,17 @@
 #include <linux/cpumask.h>
 #include <linux/init.h>
 #include <asm/processor-flags.h>
+#include <asm-x86_64/desc_defs.h>
 
 /* flag for disabling the tsc */
 extern int tsc_disable;
 
-struct desc_struct {
-	unsigned long a,b;
-};
-
 #define desc_empty(desc) \
-		(!((desc)->a | (desc)->b))
-
-#define desc_equal(desc1, desc2) \
-		(((desc1)->a == (desc2)->a) && ((desc1)->b == (desc2)->b))
+		(!((desc)->raw32.a | (desc)->raw32.b))
+
+#define desc_equal(desc1, desc2)				\
+		(((desc1)->raw32.a == (desc2)->raw32.a) &&	\
+		 ((desc1)->raw32.b == (desc2)->raw32.b))
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").


