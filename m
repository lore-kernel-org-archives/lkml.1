Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbXJaXB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbXJaXB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 19:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761506AbXJaXAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 19:00:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761011AbXJaXAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 19:00:50 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 8/16] add native functions for descriptors handling
Date: Wed, 31 Oct 2007 16:14:53 -0300
Message-Id: <11938581451804-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938581403478-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com> <11938581351064-git-send-email-gcosta@redhat.com> <11938581403478-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch turns the basic descriptor handling into native_
functions. It is basically write_idt, load_idt, write_gdt,
load_gdt, set_ldt, store_tr, load_tls, and the ones
for updating a single entry.

In the process of doing that, we change the definition of
load_LDT_nolock, and caller sites have to be patched. We
also patch call sites that now needs a typecast.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/ldt_64.c         |    7 +-
 include/asm-x86/desc_64.h        |  172 +++++++++++++++++++++++++-------------
 include/asm-x86/mmu_context_64.h |   23 ++++--
 3 files changed, 132 insertions(+), 70 deletions(-)

diff --git a/arch/x86/kernel/ldt_64.c b/arch/x86/kernel/ldt_64.c
index 60e57ab..ab1ff6e 100644
--- a/arch/x86/kernel/ldt_64.c
+++ b/arch/x86/kernel/ldt_64.c
@@ -171,7 +171,7 @@ static int write_ldt(void __user * ptr, unsigned long bytecount, int oldmode)
 {
 	struct task_struct *me = current;
 	struct mm_struct * mm = me->mm;
-	__u32 entry_1, entry_2, *lp;
+	__u32 entry_1, entry_2;
 	int error;
 	struct user_desc ldt_info;
 
@@ -200,7 +200,6 @@ static int write_ldt(void __user * ptr, unsigned long bytecount, int oldmode)
 			goto out_unlock;
 	}
 
-	lp = (__u32 *) ((ldt_info.entry_number << 3) + (char *) mm->context.ldt);
 
    	/* Allow LDTs to be cleared by the user. */
    	if (ldt_info.base_addr == 0 && ldt_info.limit == 0) {
@@ -218,8 +217,8 @@ static int write_ldt(void __user * ptr, unsigned long bytecount, int oldmode)
 
 	/* Install the new entry ...  */
 install:
-	*lp	= entry_1;
-	*(lp+1)	= entry_2;
+	write_ldt_entry(mm->context.ldt, ldt_info.entry_number,
+			entry_1, entry_2);
 	error = 0;
 
 out_unlock:
diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index 7d9c938..f7008bb 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
@@ -16,20 +16,18 @@
 
 extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
 
-#define load_TR_desc() asm volatile("ltr %w0"::"r" (GDT_ENTRY_TSS*8))
-#define load_LDT_desc() asm volatile("lldt %w0"::"r" (GDT_ENTRY_LDT*8))
-#define clear_LDT()  asm volatile("lldt %w0"::"r" (0))
+static inline void native_load_tr_desc(void)
+{
+	asm volatile("ltr %w0"::"r" (GDT_ENTRY_TSS*8));
+}
 
-static inline unsigned long __store_tr(void)
+static inline unsigned long native_store_tr(void)
 {
        unsigned long tr;
-
        asm volatile ("str %w0":"=r" (tr));
        return tr;
 }
 
-#define store_tr(tr) (tr) = __store_tr()
-
 /*
  * This is the ldt that every process will get unless we need
  * something other than this.
@@ -41,62 +39,51 @@ extern struct desc_ptr cpu_gdt_descr[];
 /* the cpu gdt accessor */
 #define cpu_gdt(_cpu) ((struct desc_struct *)cpu_gdt_descr[_cpu].address)
 
-static inline void load_gdt(const struct desc_ptr *ptr)
+static inline void native_load_gdt(const struct desc_ptr *ptr)
 {
 	asm volatile("lgdt %w0"::"m" (*ptr));
 }
 
-static inline void store_gdt(struct desc_ptr *ptr)
+static inline void native_store_gdt(struct desc_ptr *ptr)
 {
-       asm("sgdt %w0":"=m" (*ptr));
+       asm volatile ("sgdt %w0":"=m" (*ptr));
 }
 
-static inline void _set_gate(void *adr, unsigned type, unsigned long func, unsigned dpl, unsigned ist)  
+static inline void native_write_idt_entry(void *adr, struct gate_struct *s)
 {
-	struct gate_struct s; 	
-	s.offset_low = PTR_LOW(func); 
-	s.segment = __KERNEL_CS;
-	s.ist = ist; 
-	s.p = 1;
-	s.dpl = dpl; 
-	s.zero0 = 0;
-	s.zero1 = 0; 
-	s.type = type; 
-	s.offset_middle = PTR_MIDDLE(func); 
-	s.offset_high = PTR_HIGH(func); 
-	/* does not need to be atomic because it is only done once at setup time */ 
-	memcpy(adr, &s, 16); 
-} 
-
-static inline void set_intr_gate(int nr, void *func) 
-{ 
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, 0); 
-} 
+	/* does not need to be atomic because
+	 * it is only done once at setup time */
+	memcpy(adr, s, 16);
+}
 
-static inline void set_intr_gate_ist(int nr, void *func, unsigned ist) 
-{ 
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, ist); 
-} 
+static inline void native_write_gdt_entry(void *ptr, void *entry,
+						unsigned type, unsigned size)
+{
+	memcpy(ptr, entry, size);
+}
 
-static inline void set_system_gate(int nr, void *func) 
-{ 
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, 0); 
-} 
+/*
+ * This one unfortunately can't go with the others, in below, because it has
+ * an user anxious for its definition: set_tssldt_descriptor
+ */
+#ifndef CONFIG_PARAVIRT
+#define write_gdt_entry(_ptr, _e, _type, _size) \
+		native_write_gdt_entry((_ptr), (_e), (_type), (_size))
+#endif
 
-static inline void set_system_gate_ist(int nr, void *func, unsigned ist)
+static inline void write_dt_entry(struct desc_struct *dt,
+				  int entry, u32 entry_low, u32 entry_high)
 {
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, ist);
+	((struct n_desc_struct *)dt)[entry].a = entry_low;
+	((struct n_desc_struct *)dt)[entry].b = entry_high;
 }
 
-static inline void load_idt(const struct desc_ptr *ptr)
+static inline void native_load_idt(const struct desc_ptr *ptr)
 {
 	asm volatile("lidt %w0"::"m" (*ptr));
 }
 
-static inline void store_idt(struct desc_ptr *dtr)
+static inline void native_store_idt(struct desc_ptr *dtr)
 {
        asm("sidt %w0":"=m" (*dtr));
 }
@@ -114,7 +101,7 @@ static inline void set_tssldt_descriptor(void *ptr, unsigned long tss, unsigned
 	d.limit1 = (size >> 16) & 0xF;
 	d.base2 = (PTR_MIDDLE(tss) >> 8) & 0xFF; 
 	d.base3 = PTR_HIGH(tss); 
-	memcpy(ptr, &d, 16); 
+	write_gdt_entry(ptr, &d, type, 16);
 }
 
 static inline void set_tss_desc(unsigned cpu, void *addr)
@@ -165,7 +152,7 @@ static inline void set_ldt_desc(unsigned cpu, void *addr, int size)
 	(info)->useable		== 0	&& \
 	(info)->lm		== 0)
 
-static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
+static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 {
 	unsigned int i;
 	u64 *gdt = (u64 *)(cpu_gdt(cpu) + GDT_ENTRY_TLS_MIN);
@@ -173,28 +160,93 @@ static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
 	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
 		gdt[i] = t->tls_array[i];
 } 
+static inline void native_set_ldt(const void *addr,
+				  unsigned int entries)
+{
+	if (likely(entries == 0))
+		__asm__ __volatile__ ("lldt %w0" :: "r" (0));
+	else {
+		unsigned cpu = smp_processor_id();
+
+		set_tssldt_descriptor(&cpu_gdt(cpu)[GDT_ENTRY_LDT],
+					(unsigned long)addr, DESC_LDT,
+					entries * 8 - 1);
+		__asm__ __volatile__ ("lldt %w0"::"r" (GDT_ENTRY_LDT*8));
+	}
+}
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define load_TR_desc()	native_load_tr_desc()
+#define load_gdt(ptr)	native_load_gdt(ptr)
+#define load_idt(ptr)	native_load_idt(ptr)
+#define load_TLS(t, cpu) native_load_tls(t, cpu)
+#define set_ldt(addr, entries)	native_set_ldt(addr, entries)
+#define store_tr(tr) (tr) = native_store_tr()
+#define store_gdt(ptr)	native_store_gdt(ptr)
+#define store_idt(ptr)	native_store_idt(ptr)
+
+#define write_idt_entry(_adr, _s) native_write_idt_entry((_adr), (_s))
+#define write_ldt_entry(_ldt, _number, _entry1, _entry2) \
+		write_dt_entry((_ldt), (_number), (_entry1), (_entry2))
+#endif
+
+static inline void _set_gate(void *adr, unsigned type, unsigned long func,
+			     unsigned dpl, unsigned ist)
+{
+	struct gate_struct s;
+	s.offset_low = PTR_LOW(func);
+	s.segment = __KERNEL_CS;
+	s.ist = ist;
+	s.p = 1;
+	s.dpl = dpl;
+	s.zero0 = 0;
+	s.zero1 = 0;
+	s.type = type;
+	s.offset_middle = PTR_MIDDLE(func);
+	s.offset_high = PTR_HIGH(func);
+	write_idt_entry(adr, &s);
+}
+
+static inline void set_intr_gate(int nr, void *func)
+{
+	BUG_ON((unsigned)nr > 0xFF);
+	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, 0);
+}
+
+static inline void set_intr_gate_ist(int nr, void *func, unsigned ist)
+{
+	BUG_ON((unsigned)nr > 0xFF);
+	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, ist);
+}
+
+static inline void set_system_gate(int nr, void *func)
+{
+	BUG_ON((unsigned)nr > 0xFF);
+	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, 0);
+}
+
+static inline void set_system_gate_ist(int nr, void *func, unsigned ist)
+{
+	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, ist);
+}
+
+#define clear_LDT()  set_ldt(NULL, 0)
 
 /*
  * load one particular LDT into the current CPU
  */
-static inline void load_LDT_nolock (mm_context_t *pc, int cpu)
+static inline void load_LDT_nolock(mm_context_t *pc)
 {
-	int count = pc->size;
-
-	if (likely(!count)) {
-		clear_LDT();
-		return;
-	}
-		
-	set_ldt_desc(cpu, pc->ldt, count);
-	load_LDT_desc();
+	set_ldt(pc->ldt, pc->size);
 }
 
 static inline void load_LDT(mm_context_t *pc)
 {
-	int cpu = get_cpu();
-	load_LDT_nolock(pc, cpu);
-	put_cpu();
+	preempt_disable();
+	load_LDT_nolock(pc);
+	preempt_enable();
 }
 
 extern struct desc_ptr idt_descr;
diff --git a/include/asm-x86/mmu_context_64.h b/include/asm-x86/mmu_context_64.h
index 0cce83a..841ee33 100644
--- a/include/asm-x86/mmu_context_64.h
+++ b/include/asm-x86/mmu_context_64.h
@@ -7,7 +7,16 @@
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
 #include <asm-generic/mm_hooks.h>
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+}
+#endif /* CONFIG_PARAVIRT */
 
 /*
  * possibly do the LDT unload here?
@@ -25,7 +34,7 @@ static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 
 static inline void load_cr3(pgd_t *pgd)
 {
-	asm volatile("movq %0,%%cr3" :: "r" (__pa(pgd)) : "memory");
+	write_cr3(__pa(pgd));
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
@@ -43,7 +52,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		load_cr3(next->pgd);
 
 		if (unlikely(next->context.ldt != prev->context.ldt)) 
-			load_LDT_nolock(&next->context, cpu);
+			load_LDT_nolock(&next->context);
 	}
 #ifdef CONFIG_SMP
 	else {
@@ -56,7 +65,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			 * to make sure to use no freed page tables.
 			 */
 			load_cr3(next->pgd);
-			load_LDT_nolock(&next->context, cpu);
+			load_LDT_nolock(&next->context);
 		}
 	}
 #endif
@@ -67,8 +76,10 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	asm volatile("movl %0,%%fs"::"r"(0));  \
 } while(0)
 
-#define activate_mm(prev, next) \
-	switch_mm((prev),(next),NULL)
-
+#define activate_mm(prev, next) 		\
+do {						\
+	paravirt_activate_mm(prev, next);	\
+	switch_mm((prev), (next), NULL);	\
+} while (0)
 
 #endif
-- 
1.4.4.2

