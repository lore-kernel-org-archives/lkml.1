Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbXGRHap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbXGRHap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXGRHae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:30:34 -0400
Received: from ozlabs.org ([203.10.76.45]:58363 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbXGRHac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:30:32 -0400
Subject: [PATCH 1/3] Standardize x86_64's desc_defs.h in preparation for
	exposure to i386.
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 17:22:34 +1000
Message-Id: <1184743355.10380.112.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KVM has independent definitions of these structures, which is bad.
However, the currently (i386-derived) x86-64 ones are suboptimal.  The
first step is to clean them up, especially by making desc_struct a
union.

Additional changes:
1) s/ldttss_desc/ldttss_desc_64/ to clearly indicate it's x86-64 only.
2) Changed the type of the tls_array in struct thread_struct:
   there seems little point to all these casts.
3) s/gate_struct/gate_struct_64/ to differentiate from new gate_struct_32.
4) New base/limit extraction convenience functions in desc_defs.h.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r ef94811a10d5 arch/x86_64/ia32/tls32.c
--- a/arch/x86_64/ia32/tls32.c	Wed Jul 18 14:46:15 2007 +1000
+++ b/arch/x86_64/ia32/tls32.c	Wed Jul 18 15:59:01 2007 +1000
@@ -19,7 +19,7 @@ static int get_free_idx(void)
 	int idx;
 
 	for (idx = 0; idx < GDT_ENTRY_TLS_ENTRIES; idx++)
-		if (desc_empty((struct n_desc_struct *)(t->tls_array) + idx))
+		if (desc_empty(t->tls_array + idx))
 			return idx + GDT_ENTRY_TLS_MIN;
 	return -ESRCH;
 }
@@ -31,7 +31,7 @@ int do_set_thread_area(struct thread_str
 int do_set_thread_area(struct thread_struct *t, struct user_desc __user *u_info)
 {
 	struct user_desc info;
-	struct n_desc_struct *desc;
+	struct desc_struct *desc;
 	int cpu, idx;
 
 	if (copy_from_user(&info, u_info, sizeof(info)))
@@ -54,7 +54,7 @@ int do_set_thread_area(struct thread_str
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 
-	desc = ((struct n_desc_struct *)t->tls_array) + idx - GDT_ENTRY_TLS_MIN;
+	desc = t->tls_array + idx - GDT_ENTRY_TLS_MIN;
 
 	/*
 	 * We must not get preempted while modifying the TLS.
@@ -62,11 +62,10 @@ int do_set_thread_area(struct thread_str
 	cpu = get_cpu();
 
 	if (LDT_empty(&info)) {
-		desc->a = 0;
-		desc->b = 0;
+		desc->raw = 0;
 	} else {
-		desc->a = LDT_entry_a(&info);
-		desc->b = LDT_entry_b(&info);
+		desc->raw32.a = LDT_entry_a(&info);
+		desc->raw32.b = LDT_entry_b(&info);
 	}
 	if (t == &current->thread)
 		load_TLS(t, cpu);
@@ -85,27 +85,13 @@ asmlinkage long sys32_set_thread_area(st
  * Get the current Thread-Local Storage area:
  */
 
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
-#define GET_LONGMODE(desc)	(((desc)->b >> 21) & 1)
+#define GET_CONTENTS(desc)	(((desc)->raw32.b >> 10) & 3)
+#define GET_WRITABLE(desc)	(((desc)->raw32.b >>  9) & 1)
 
 int do_get_thread_area(struct thread_struct *t, struct user_desc __user *u_info)
 {
 	struct user_desc info;
-	struct n_desc_struct *desc;
+	struct desc_struct *desc;
 	int idx;
 
 	if (get_user(idx, &u_info->entry_number))
@@ -113,19 +99,19 @@ int do_get_thread_area(struct thread_str
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 
-	desc = ((struct n_desc_struct *)t->tls_array) + idx - GDT_ENTRY_TLS_MIN;
+	desc = t->tls_array + idx - GDT_ENTRY_TLS_MIN;
 
 	memset(&info, 0, sizeof(struct user_desc));
 	info.entry_number = idx;
-	info.base_addr = GET_BASE(desc);
-	info.limit = GET_LIMIT(desc);
-	info.seg_32bit = GET_32BIT(desc);
+	info.base_addr = get_seg_desc_base(&desc->seg);
+	info.limit = get_seg_desc_limit(&desc->seg);
+	info.seg_32bit = desc->seg.d;
 	info.contents = GET_CONTENTS(desc);
 	info.read_exec_only = !GET_WRITABLE(desc);
-	info.limit_in_pages = GET_LIMIT_PAGES(desc);
-	info.seg_not_present = !GET_PRESENT(desc);
-	info.useable = GET_USEABLE(desc);
-	info.lm = GET_LONGMODE(desc);
+	info.limit_in_pages = desc->seg.g;
+	info.seg_not_present = !desc->seg.p;
+	info.useable = desc->seg.avl;
+	info.lm = desc->seg.l;
 
 	if (copy_to_user(u_info, &info, sizeof(info)))
 		return -EFAULT;
@@ -140,7 +126,7 @@ asmlinkage long sys32_get_thread_area(st
 
 int ia32_child_tls(struct task_struct *p, struct pt_regs *childregs)
 {
-	struct n_desc_struct *desc;
+	struct desc_struct *desc;
 	struct user_desc info;
 	struct user_desc __user *cp;
 	int idx;
@@ -155,9 +141,9 @@ int ia32_child_tls(struct task_struct *p
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 	
-	desc = (struct n_desc_struct *)(p->thread.tls_array) + idx - GDT_ENTRY_TLS_MIN;
-	desc->a = LDT_entry_a(&info);
-	desc->b = LDT_entry_b(&info);
+	desc = p->thread.tls_array + idx - GDT_ENTRY_TLS_MIN;
+	desc->raw32.a = LDT_entry_a(&info);
+	desc->raw32.b = LDT_entry_b(&info);
 
 	return 0;
 }
diff -r ef94811a10d5 arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c	Wed Jul 18 14:46:15 2007 +1000
+++ b/arch/x86_64/kernel/process.c	Wed Jul 18 15:59:01 2007 +1000
@@ -432,19 +432,13 @@ static inline void set_32bit_tls(struct 
 		.limit_in_pages = 1,
 		.useable = 1,
 	};
-	struct n_desc_struct *desc = (void *)t->thread.tls_array;
-	desc += tls;
-	desc->a = LDT_entry_a(&ud); 
-	desc->b = LDT_entry_b(&ud); 
+	t->thread.tls_array[tls].raw32.a = LDT_entry_a(&ud);
+	t->thread.tls_array[tls].raw32.b = LDT_entry_b(&ud);
 }
 
 static inline u32 read_32bit_tls(struct task_struct *t, int tls)
 {
-	struct desc_struct *desc = (void *)t->thread.tls_array;
-	desc += tls;
-	return desc->base0 | 
-		(((u32)desc->base1) << 16) | 
-		(((u32)desc->base2) << 24);
+	return get_seg_desc_base(&t->thread.tls_array[tls].seg);
 }
 
 /*
diff -r ef94811a10d5 arch/x86_64/kernel/suspend.c
--- a/arch/x86_64/kernel/suspend.c	Wed Jul 18 14:46:15 2007 +1000
+++ b/arch/x86_64/kernel/suspend.c	Wed Jul 18 15:59:01 2007 +1000
@@ -125,7 +125,7 @@ void fix_processor_context(void)
 
 	set_tss_desc(cpu,t);	/* This just modifies memory; should not be neccessary. But... This is neccessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
 
-	cpu_gdt(cpu)[GDT_ENTRY_TSS].type = 9;
+	cpu_gdt(cpu)[GDT_ENTRY_TSS].seg.type = DESC_TSS;
 
 	syscall_init();                         /* This sets MSR_*STAR and related */
 	load_TR_desc();				/* This does ltr */
diff -r ef94811a10d5 include/asm-x86_64/desc.h
--- a/include/asm-x86_64/desc.h	Wed Jul 18 14:46:15 2007 +1000
+++ b/include/asm-x86_64/desc.h	Wed Jul 18 15:59:01 2007 +1000
@@ -25,7 +25,7 @@ extern struct desc_struct cpu_gdt_table[
  * something other than this.
  */
 extern struct desc_struct default_ldt[];
-extern struct gate_struct idt_table[]; 
+extern struct gate_struct_64 idt_table[]; 
 extern struct desc_ptr cpu_gdt_descr[];
 
 /* the cpu gdt accessor */
@@ -33,7 +33,7 @@ extern struct desc_ptr cpu_gdt_descr[];
 
 static inline void _set_gate(void *adr, unsigned type, unsigned long func, unsigned dpl, unsigned ist)  
 {
-	struct gate_struct s; 	
+	struct gate_struct_64 s; 	
 	s.offset_low = PTR_LOW(func); 
 	s.segment = __KERNEL_CS;
 	s.ist = ist; 
@@ -74,7 +74,7 @@ static inline void set_tssldt_descriptor
 static inline void set_tssldt_descriptor(void *ptr, unsigned long tss, unsigned type, 
 					 unsigned size) 
 { 
-	struct ldttss_desc d;
+	struct ldttss_desc_64 d;
 	memset(&d,0,sizeof(d)); 
 	d.limit0 = size & 0xFFFF;
 	d.base0 = PTR_LOW(tss); 
@@ -138,7 +138,7 @@ static inline void load_TLS(struct threa
 static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
 {
 	unsigned int i;
-	u64 *gdt = (u64 *)(cpu_gdt(cpu) + GDT_ENTRY_TLS_MIN);
+	struct desc_struct *gdt = cpu_gdt(cpu) + GDT_ENTRY_TLS_MIN;
 
 	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
 		gdt[i] = t->tls_array[i];
diff -r ef94811a10d5 include/asm-x86_64/desc_defs.h
--- a/include/asm-x86_64/desc_defs.h	Wed Jul 18 14:46:15 2007 +1000
+++ b/include/asm-x86_64/desc_defs.h	Wed Jul 18 16:20:57 2007 +1000
@@ -11,16 +11,43 @@
 
 #include <linux/types.h>
 
-// 8 byte segment descriptor
-struct desc_struct {
+// 8 byte segment descriptor (GDT/LDT)
+struct segment_desc {
 	u16 limit0;
 	u16 base0;
 	unsigned base1 : 8, type : 4, s : 1, dpl : 2, p : 1;
 	unsigned limit : 4, avl : 1, l : 1, d : 1, g : 1, base2 : 8;
 } __attribute__((packed));
 
-struct n_desc_struct {
+static inline u32 get_seg_desc_base(const struct segment_desc *seg)
+{
+	return seg->base0 | ((u32)seg->base1 << 16) | ((u32)seg->base2 << 24);
+}
+
+static inline u32 get_seg_desc_limit(const struct segment_desc *seg)
+{
+	return seg->limit0 | ((u32)seg->limit << 16);
+}
+
+// 8 byte interrupt/trap descriptor (i386 IDT)
+struct gate_struct_32 {
+	u16 offset_low;
+	u16 segment;
+	unsigned zero0 : 8, type : 5, dpl : 2, p : 1;
+	u16 offset_middle;
+};
+
+struct raw_desc {
 	unsigned int a,b;
+};
+
+struct desc_struct {
+	union {
+		u64 raw;
+		struct segment_desc seg;
+		struct gate_struct_32 gate;
+		struct raw_desc raw32;
+	};
 };
 
 enum {
@@ -29,8 +56,8 @@ enum {
 	GATE_CALL = 0xC,
 };
 
-// 16byte gate
-struct gate_struct {
+// 16byte gate (x86_64 only)
+struct gate_struct_64 {
 	u16 offset_low;
 	u16 segment;
 	unsigned ist : 3, zero0 : 5, type : 5, dpl : 2, p : 1;
@@ -48,8 +75,8 @@ enum {
 	DESC_LDT = 0x2,
 };
 
-// LDT or TSS descriptor in the GDT. 16 bytes.
-struct ldttss_desc {
+// LDT or TSS descriptor in the GDT (x86_64 only). 16 bytes.
+struct ldttss_desc_64 {
 	u16 limit0;
 	u16 base0;
 	unsigned base1 : 8, type : 5, dpl : 2, p : 1;
diff -r ef94811a10d5 include/asm-x86_64/processor.h
--- a/include/asm-x86_64/processor.h	Wed Jul 18 14:46:15 2007 +1000
+++ b/include/asm-x86_64/processor.h	Wed Jul 18 15:59:01 2007 +1000
@@ -21,6 +21,7 @@
 #include <linux/personality.h>
 #include <linux/cpumask.h>
 #include <asm/processor-flags.h>
+#include <asm/desc_defs.h>
 
 #define TF_MASK		0x00000100
 #define IF_MASK		0x00000200
@@ -32,11 +33,16 @@
 #define VIP_MASK	0x00100000	/* virtual interrupt pending */
 #define ID_MASK		0x00200000
 
-#define desc_empty(desc) \
-               (!((desc)->a | (desc)->b))
-
-#define desc_equal(desc1, desc2) \
-               (((desc1)->a == (desc2)->a) && ((desc1)->b == (desc2)->b))
+static inline bool desc_empty(const struct desc_struct *desc)
+{
+	return !desc->raw;
+}
+
+static inline bool desc_equal(const struct desc_struct *d1,
+			      const struct desc_struct *d2)
+{
+	return d1->raw == d2->raw;
+}
 
 /*
  * Default implementation of macro that returns current
@@ -238,7 +244,7 @@ struct thread_struct {
 	unsigned long	*io_bitmap_ptr;
 	unsigned io_bitmap_max;
 /* cached TLS descriptors. */
-	u64 tls_array[GDT_ENTRY_TLS_ENTRIES];
+	struct desc_struct tls_array[GDT_ENTRY_TLS_ENTRIES];
 } __attribute__((aligned(16)));
 
 #define INIT_THREAD  { \


