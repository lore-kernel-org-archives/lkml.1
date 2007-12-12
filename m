Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbXLLPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbXLLPmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758824AbXLLPjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:39:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758801AbXLLPjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:39:43 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 11/19] change write_gdt_entry signature.
Date: Wed, 12 Dec 2007 10:53:56 -0200
Message-Id: <11974641102691-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11974641042757-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com> <11974640522688-git-send-email-gcosta@redhat.com> <1197464057242-git-send-email-gcosta@redhat.com> <11974640653022-git-send-email-gcosta@redhat.com> <1197464070228-git-send-email-gcosta@redhat.com> <11974640752137-git-send-email-gcosta@redhat.com> <11974640813511-git-send-email-gcosta@redhat.com> <11974640872474-git-send-email-gcosta@redhat.com> <11974640932406-git-send-email-gcosta@redhat.com> <11974640983333-git-send-email-gcosta@redhat.com> <11974641042757-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the write_gdt_entry function signature.
Instead of the old "a" and "b" parameters, it now receives
a pointer to a desc_struct, and the size of the entry being
handled. This is because x86_64 can have some 16-byte entries
as well as 8-byte ones.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge.citrix.com>
---
 arch/x86/kernel/paravirt_32.c  |    2 +-
 arch/x86/kernel/smpcommon_32.c |    7 ++++---
 arch/x86/kernel/vmi_32.c       |   21 +++++++++++++++------
 arch/x86/lguest/boot.c         |    6 +++---
 arch/x86/xen/enlighten.c       |   11 +++++------
 include/asm-x86/desc_32.h      |   34 ++++++++++++++++++++++------------
 include/asm-x86/paravirt.h     |    9 ++++++---
 7 files changed, 56 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/paravirt_32.c b/arch/x86/kernel/paravirt_32.c
index 13bbc99..77602c1 100644
--- a/arch/x86/kernel/paravirt_32.c
+++ b/arch/x86/kernel/paravirt_32.c
@@ -380,7 +380,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.store_tr = native_store_tr,
 	.load_tls = native_load_tls,
 	.write_ldt_entry = write_dt_entry,
-	.write_gdt_entry = write_dt_entry,
+	.write_gdt_entry = native_write_gdt_entry,
 	.write_idt_entry = native_write_idt_entry,
 	.load_sp0 = native_load_sp0,
 
diff --git a/arch/x86/kernel/smpcommon_32.c b/arch/x86/kernel/smpcommon_32.c
index bbfe85a..8bc38af 100644
--- a/arch/x86/kernel/smpcommon_32.c
+++ b/arch/x86/kernel/smpcommon_32.c
@@ -14,10 +14,11 @@ __cpuinit void init_gdt(int cpu)
 {
 	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
 
-	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
-			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
+	pack_descriptor(&gdt[GDT_ENTRY_PERCPU],
 			__per_cpu_offset[cpu], 0xFFFFF,
-			0x80 | DESCTYPE_S | 0x2, 0x8);
+			0x2 | DESCTYPE_S, 0x8);
+
+	gdt[GDT_ENTRY_PERCPU].s = 1;
 
 	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	per_cpu(cpu_number, cpu) = cpu;
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index a635b22..21edd0d 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -63,6 +63,7 @@ static struct {
 	void (*_set_ldt)(u32 selector);
 	void (*set_tr)(u32 selector);
 	void (*write_idt_entry)(struct desc_struct *, int, u32, u32);
+	void (*write_gdt_entry)(struct desc_struct *, int, u32, u32);
 	void (*set_kernel_stack)(u32 selector, u32 sp0);
 	void (*allocate_page)(u32, u32, u32, u32, u32);
 	void (*release_page)(u32, u32);
@@ -187,7 +188,7 @@ static void vmi_cpuid(unsigned int *ax, unsigned int *bx,
 static inline void vmi_maybe_load_tls(struct desc_struct *gdt, int nr, struct desc_struct *new)
 {
 	if (gdt[nr].a != new->a || gdt[nr].b != new->b)
-		write_gdt_entry(gdt, nr, new->a, new->b);
+		write_gdt_entry(gdt, nr, new, 0);
 }
 
 static void vmi_load_tls(struct thread_struct *t, unsigned int cpu)
@@ -201,12 +202,12 @@ static void vmi_load_tls(struct thread_struct *t, unsigned int cpu)
 static void vmi_set_ldt(const void *addr, unsigned entries)
 {
 	unsigned cpu = smp_processor_id();
-	u32 low, high;
+	struct desc_struct desc;
 
-	pack_descriptor(&low, &high, (unsigned long)addr,
+	pack_descriptor(&desc, (unsigned long)addr,
 			entries * sizeof(struct desc_struct) - 1,
-			DESCTYPE_LDT, 0);
-	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT, low, high);
+			DESC_LDT, 0);
+	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT, &desc, DESC_LDT);
 	vmi_ops._set_ldt(entries ? GDT_ENTRY_LDT*sizeof(struct desc_struct) : 0);
 }
 
@@ -221,6 +222,13 @@ static void vmi_write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
 	vmi_ops.write_idt_entry(dt, entry, idt_entry[0], idt_entry[2]);
 }
 
+static void vmi_write_gdt_entry(struct desc_struct *dt, int entry,
+				const void *desc, int type)
+{
+	u32 *gdt_entry = (u32 *)desc;
+	vmi_ops.write_gdt_entry(dt, entry, gdt_entry[0], gdt_entry[2]);
+}
+
 static void vmi_load_sp0(struct tss_struct *tss,
 				   struct thread_struct *thread)
 {
@@ -798,7 +806,8 @@ static inline int __init activate_vmi(void)
 	para_fill(pv_cpu_ops.store_tr, GetTR);
 	pv_cpu_ops.load_tls = vmi_load_tls;
 	para_fill(pv_cpu_ops.write_ldt_entry, WriteLDTEntry);
-	para_fill(pv_cpu_ops.write_gdt_entry, WriteGDTEntry);
+	para_wrap(pv_cpu_ops.write_gdt_entry, vmi_write_gdt_entry,
+		  write_gdt_entry, WriteGDTEntry);
 	para_wrap(pv_cpu_ops.write_idt_entry, vmi_write_idt_entry,
 		  write_idt_entry, WriteIDTEntry);
 	para_wrap(pv_cpu_ops.load_sp0, vmi_load_sp0, set_kernel_stack, UpdateKernelStack);
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index b50c8ad..a633737 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -262,10 +262,10 @@ static void lguest_load_gdt(const struct desc_ptr *desc)
 /* For a single GDT entry which changes, we do the lazy thing: alter our GDT,
  * then tell the Host to reload the entire thing.  This operation is so rare
  * that this naive implementation is reasonable. */
-static void lguest_write_gdt_entry(struct desc_struct *dt,
-				   int entrynum, u32 low, u32 high)
+static void lguest_write_gdt_entry(struct desc_struct *dt, int entrynum,
+				   const void *desc, int type)
 {
-	write_dt_entry(dt, entrynum, low, high);
+	native_write_gdt_entry(dt, entrynum, desc, type);
 	hcall(LHCALL_LOAD_GDT, __pa(dt), GDT_ENTRIES, 0);
 }
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 6dd349e..c38240c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -475,22 +475,21 @@ static void xen_load_idt(const struct desc_ptr *desc)
 /* Write a GDT descriptor entry.  Ignore LDT descriptors, since
    they're handled differently. */
 static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
-				u32 low, u32 high)
+				const void *desc, int type)
 {
 	preempt_disable();
 
-	switch ((high >> 8) & 0xff) {
-	case DESCTYPE_LDT:
-	case DESCTYPE_TSS:
+	switch (type) {
+	case DESC_LDT:
+	case DESC_TSS:
 		/* ignore */
 		break;
 
 	default: {
 		xmaddr_t maddr = virt_to_machine(&dt[entry]);
-		u64 desc = (u64)high << 32 | low;
 
 		xen_mc_flush();
-		if (HYPERVISOR_update_descriptor(maddr.maddr, desc))
+		if (HYPERVISOR_update_descriptor(maddr.maddr, *(u64 *)desc))
 			BUG();
 	}
 
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index 0370099..41d8214 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -28,12 +28,13 @@ extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
 extern void set_intr_gate(unsigned int irq, void * addr);
 
-static inline void pack_descriptor(__u32 *a, __u32 *b,
+static inline void pack_descriptor(struct desc_struct *desc,
 	unsigned long base, unsigned long limit, unsigned char type, unsigned char flags)
 {
-	*a = ((base & 0xffff) << 16) | (limit & 0xffff);
-	*b = (base & 0xff000000) | ((base & 0xff0000) >> 16) |
+	desc->a = ((base & 0xffff) << 16) | (limit & 0xffff);
+	desc->b = (base & 0xff000000) | ((base & 0xff0000) >> 16) |
 		(limit & 0x000f0000) | ((type & 0xff) << 8) | ((flags & 0xf) << 20);
+	desc->p = 1;
 }
 
 static inline void pack_gate(gate_desc *gate,
@@ -69,7 +70,8 @@ static inline void pack_gate(gate_desc *gate,
 #define set_ldt native_set_ldt
 
 #define write_ldt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
-#define write_gdt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
+#define write_gdt_entry(dt, entry, desc, type) \
+				native_write_gdt_entry(dt, entry, desc, type)
 #define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
 #endif
 
@@ -79,6 +81,12 @@ static inline void native_write_idt_entry(gate_desc *idt, int entry,
 	memcpy(&idt[entry], gate, sizeof(*gate));
 }
 
+static inline void native_write_gdt_entry(struct desc_struct *gdt, int entry,
+					  const void *desc, int type)
+{
+	memcpy(&gdt[entry], desc, sizeof(struct desc_struct));
+}
+
 static inline void write_dt_entry(struct desc_struct *dt,
 				  int entry, u32 entry_low, u32 entry_high)
 {
@@ -86,18 +94,20 @@ static inline void write_dt_entry(struct desc_struct *dt,
 	dt[entry].b = entry_high;
 }
 
+
 static inline void native_set_ldt(const void *addr, unsigned int entries)
 {
 	if (likely(entries == 0))
 		__asm__ __volatile__("lldt %w0"::"q" (0));
 	else {
 		unsigned cpu = smp_processor_id();
-		__u32 a, b;
+		ldt_desc ldt;
 
-		pack_descriptor(&a, &b, (unsigned long)addr,
+		pack_descriptor(&ldt, (unsigned long)addr,
 				entries * sizeof(struct desc_struct) - 1,
-				DESCTYPE_LDT, 0);
-		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT, a, b);
+				DESC_LDT, 0);
+		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
+				&ldt, DESC_LDT);
 		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
 	}
 }
@@ -153,11 +163,11 @@ static inline void _set_gate(int gate, unsigned int type, void *addr, unsigned s
 
 static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const void *addr)
 {
-	__u32 a, b;
-	pack_descriptor(&a, &b, (unsigned long)addr,
+	tss_desc tss;
+	pack_descriptor(&tss, (unsigned long)addr,
 			offsetof(struct tss_struct, __cacheline_filler) - 1,
-			DESCTYPE_TSS, 0);
-	write_gdt_entry(get_cpu_gdt_table(cpu), entry, a, b);
+			DESC_TSS, 0);
+	write_gdt_entry(get_cpu_gdt_table(cpu), entry, &tss, DESC_TSS);
 }
 
 
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 86a9d7b..3f2abf2 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -99,7 +99,7 @@ struct pv_cpu_ops {
 	void (*write_ldt_entry)(struct desc_struct *,
 				int entrynum, u32 low, u32 high);
 	void (*write_gdt_entry)(struct desc_struct *,
-				int entrynum, u32 low, u32 high);
+				int entrynum, const void *desc, int size);
 	void (*write_idt_entry)(gate_desc *,
 				int entrynum, const gate_desc *gate);
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
@@ -664,10 +664,13 @@ static inline void write_ldt_entry(void *dt, int entry, u32 low, u32 high)
 {
 	PVOP_VCALL4(pv_cpu_ops.write_ldt_entry, dt, entry, low, high);
 }
-static inline void write_gdt_entry(void *dt, int entry, u32 low, u32 high)
+
+static inline void write_gdt_entry(struct desc_struct *dt, int entry,
+				   void *desc, int type)
 {
-	PVOP_VCALL4(pv_cpu_ops.write_gdt_entry, dt, entry, low, high);
+	PVOP_VCALL4(pv_cpu_ops.write_gdt_entry, dt, entry, desc, type);
 }
+
 static inline void write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
 {
 	PVOP_VCALL3(pv_cpu_ops.write_idt_entry, dt, entry, g);
-- 
1.5.0.6

