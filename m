Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbXLFTED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbXLFTED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbXLFTBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:01:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbXLFTBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:01:46 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 10/19] change write_gdt_entry signature.
Date: Thu,  6 Dec 2007 14:16:31 -0200
Message-Id: <11969578534185-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11969578483552-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com> <11969578242463-git-send-email-gcosta@redhat.com> <11969578292944-git-send-email-gcosta@redhat.com> <11969578343061-git-send-email-gcosta@redhat.com> <11969578383955-git-send-email-gcosta@redhat.com> <11969578431489-git-send-email-gcosta@redhat.com> <11969578483552-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the write_gdt_entry function signature.
Instead of the old "a" and "b" parameters, it now receives
a pointer to a desc_struct, and the size of the entry being
handled. This is because x86_64 can have some 16-byte entries
as well as 8-byte ones.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/paravirt_32.c  |    4 ++--
 arch/x86/kernel/smpcommon_32.c |    7 ++++---
 arch/x86/xen/enlighten.c       |    5 ++---
 include/asm-x86/desc_32.h      |   29 +++++++++++++++--------------
 include/asm-x86/paravirt.h     |    9 ++++++---
 5 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/paravirt_32.c b/arch/x86/kernel/paravirt_32.c
index 9ed46da..edff853 100644
--- a/arch/x86/kernel/paravirt_32.c
+++ b/arch/x86/kernel/paravirt_32.c
@@ -379,8 +379,8 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.store_idt = native_store_idt,
 	.store_tr = native_store_tr,
 	.load_tls = native_load_tls,
-	.write_ldt_entry = write_dt_entry,
-	.write_gdt_entry = write_dt_entry,
+	.write_ldt_entry = write_ldt_entry,
+	.write_gdt_entry = write_gdt_entry,
 	.write_idt_entry = write_idt_entry,
 	.load_sp0 = native_load_sp0,
 
diff --git a/arch/x86/kernel/smpcommon_32.c b/arch/x86/kernel/smpcommon_32.c
index bbfe85a..a6f9b41 100644
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
+			0x80 | 0x2, 0x8);
+
+	gdt[GDT_ENTRY_PERCPU].s = 1;
 
 	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	per_cpu(cpu_number, cpu) = cpu;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 829a450..a552103 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -474,7 +474,7 @@ static void xen_load_idt(const struct desc_ptr *desc)
 /* Write a GDT descriptor entry.  Ignore LDT descriptors, since
    they're handled differently. */
 static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
-				u32 low, u32 high)
+				void *desc, int size)
 {
 	preempt_disable();
 
@@ -486,10 +486,9 @@ static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
 
 	default: {
 		xmaddr_t maddr = virt_to_machine(&dt[entry]);
-		u64 desc = (u64)high << 32 | low;
 
 		xen_mc_flush();
-		if (HYPERVISOR_update_descriptor(maddr.maddr, desc))
+		if (HYPERVISOR_update_descriptor(maddr.maddr, *(u64 *)desc))
 			BUG();
 	}
 
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index 3653c9f..622b0e7 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -28,11 +28,11 @@ extern struct desc_ptr idt_descr;
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
 }
 
@@ -69,7 +69,8 @@ static inline void pack_gate(gate_desc *gate,
 #define set_ldt native_set_ldt
 
 #define write_ldt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
-#define write_gdt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
+#define write_gdt_entry(dt, entry, desc, size) \
+				native_write_gdt_entry(dt, entry, desc, size)
 #define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
 #endif
 
@@ -78,11 +79,10 @@ static inline void native_write_idt_entry(gate_desc *idt, int entry, gate_desc *
 	memcpy(&idt[entry], gate, sizeof(*gate));
 }
 
-static inline void write_dt_entry(struct desc_struct *dt,
-				  int entry, u32 entry_low, u32 entry_high)
+static inline void native_write_gdt_entry(struct desc_struct *gdt, int entry,
+					   void *desc, int size)
 {
-	dt[entry].a = entry_low;
-	dt[entry].b = entry_high;
+	memcpy(&gdt[entry], desc, size);
 }
 
 static inline void native_set_ldt(const void *addr, unsigned int entries)
@@ -91,12 +91,13 @@ static inline void native_set_ldt(const void *addr, unsigned int entries)
 		__asm__ __volatile__("lldt %w0"::"q" (0));
 	else {
 		unsigned cpu = smp_processor_id();
-		__u32 a, b;
+		ldt_desc ldt;
 
-		pack_descriptor(&a, &b, (unsigned long)addr,
+		pack_descriptor(&ldt, (unsigned long)addr,
 				entries * sizeof(struct desc_struct) - 1,
 				DESCTYPE_LDT, 0);
-		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT, a, b);
+		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
+				&ldt, sizeof(ldt));
 		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
 	}
 }
@@ -152,11 +153,11 @@ static inline void _set_gate(int gate, unsigned int type, void *addr, unsigned s
 
 static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const void *addr)
 {
-	__u32 a, b;
-	pack_descriptor(&a, &b, (unsigned long)addr,
+	tss_desc tss;
+	pack_descriptor(&tss, (unsigned long)addr,
 			offsetof(struct tss_struct, __cacheline_filler) - 1,
 			DESCTYPE_TSS, 0);
-	write_gdt_entry(get_cpu_gdt_table(cpu), entry, a, b);
+	write_gdt_entry(get_cpu_gdt_table(cpu), entry, &tss, sizeof(tss));
 }
 
 
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index d369b85..a3e22b7 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -99,7 +99,7 @@ struct pv_cpu_ops {
 	void (*write_ldt_entry)(struct desc_struct *,
 				int entrynum, u32 low, u32 high);
 	void (*write_gdt_entry)(struct desc_struct *,
-				int entrynum, u32 low, u32 high);
+				int entrynum, void *desc, int size);
 	void (*write_idt_entry)(gate_desc *,
 				int entrynum, gate_desc *gate);
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
@@ -664,10 +664,13 @@ static inline void write_ldt_entry(void *dt, int entry, u32 low, u32 high)
 {
 	PVOP_VCALL4(pv_cpu_ops.write_ldt_entry, dt, entry, low, high);
 }
-static inline void write_gdt_entry(void *dt, int entry, u32 low, u32 high)
+
+static inline void write_gdt_entry(struct desc_struct *dt, int entry,
+				   void *desc, int size)
 {
-	PVOP_VCALL4(pv_cpu_ops.write_gdt_entry, dt, entry, low, high);
+	PVOP_VCALL4(pv_cpu_ops.write_gdt_entry, dt, entry, desc, size);
 }
+
 static inline void write_idt_entry(gate_desc *dt, int entry, gate_desc *g)
 {
 	PVOP_VCALL4(pv_cpu_ops.write_idt_entry, dt, entry, g);
-- 
1.4.4.2

