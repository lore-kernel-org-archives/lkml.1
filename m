Return-Path: <linux-kernel-owner+w=401wt.eu-S1765100AbXHHHQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765100AbXHHHQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760726AbXHHHIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758870AbXHHHIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:46 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 14/25] [PATCH] add native functions for descriptors handling
Date: Wed,  8 Aug 2007 01:19:01 -0300
Message-Id: <118654680831-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865468043920-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com>
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
---
 arch/x86_64/kernel/head64.c      |    2 +-
 arch/x86_64/kernel/ldt.c         |    6 +-
 arch/x86_64/kernel/reboot.c      |    3 +-
 arch/x86_64/kernel/setup64.c     |    4 +-
 arch/x86_64/kernel/suspend.c     |   11 ++-
 include/asm-x86_64/desc.h        |  183 +++++++++++++++++++++++++++----------
 include/asm-x86_64/mmu_context.h |    4 +-
 7 files changed, 148 insertions(+), 65 deletions(-)

diff --git a/arch/x86_64/kernel/head64.c b/arch/x86_64/kernel/head64.c
index 6c34bdd..a0d05d7 100644
--- a/arch/x86_64/kernel/head64.c
+++ b/arch/x86_64/kernel/head64.c
@@ -70,7 +70,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 	for (i = 0; i < IDT_ENTRIES; i++)
 		set_intr_gate(i, early_idt_handler);
-	asm volatile("lidt %0" :: "m" (idt_descr));
+	load_idt(&idt_descr);
 
 	early_printk("Kernel alive\n");
 
diff --git a/arch/x86_64/kernel/ldt.c b/arch/x86_64/kernel/ldt.c
index bc9ffd5..8e6fcc1 100644
--- a/arch/x86_64/kernel/ldt.c
+++ b/arch/x86_64/kernel/ldt.c
@@ -173,7 +173,7 @@ static int write_ldt(void __user * ptr, unsigned long bytecount, int oldmode)
 {
 	struct task_struct *me = current;
 	struct mm_struct * mm = me->mm;
-	__u32 entry_1, entry_2, *lp;
+	__u32 entry_1, entry_2;
 	int error;
 	struct user_desc ldt_info;
 
@@ -202,7 +202,6 @@ static int write_ldt(void __user * ptr, unsigned long bytecount, int oldmode)
 			goto out_unlock;
 	}
 
-	lp = (__u32 *) ((ldt_info.entry_number << 3) + (char *) mm->context.ldt);
 
    	/* Allow LDTs to be cleared by the user. */
    	if (ldt_info.base_addr == 0 && ldt_info.limit == 0) {
@@ -220,8 +219,7 @@ static int write_ldt(void __user * ptr, unsigned long bytecount, int oldmode)
 
 	/* Install the new entry ...  */
 install:
-	*lp	= entry_1;
-	*(lp+1)	= entry_2;
+	write_ldt_entry(mm->context.ldt, ldt_info.entry_number, entry_1, entry_2);
 	error = 0;
 
 out_unlock:
diff --git a/arch/x86_64/kernel/reboot.c b/arch/x86_64/kernel/reboot.c
index 368db2b..ebc242c 100644
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
@@ -136,7 +137,7 @@ void machine_emergency_restart(void)
 		}
 
 		case BOOT_TRIPLE: 
-			__asm__ __volatile__("lidt (%0)": :"r" (&no_idt));
+			load_idt((struct desc_ptr *)&no_idt);
 			__asm__ __volatile__("int3");
 
 			reboot_type = BOOT_KBD;
diff --git a/arch/x86_64/kernel/setup64.c b/arch/x86_64/kernel/setup64.c
index 395cf02..49f7342 100644
--- a/arch/x86_64/kernel/setup64.c
+++ b/arch/x86_64/kernel/setup64.c
@@ -224,8 +224,8 @@ void __cpuinit cpu_init (void)
  		memcpy(cpu_gdt(cpu), cpu_gdt_table, GDT_SIZE);
 
 	cpu_gdt_descr[cpu].size = GDT_SIZE;
-	asm volatile("lgdt %0" :: "m" (cpu_gdt_descr[cpu]));
-	asm volatile("lidt %0" :: "m" (idt_descr));
+	load_gdt(&cpu_gdt_descr[cpu]);
+	load_idt(&idt_descr);
 
 	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
 	syscall_init();
diff --git a/arch/x86_64/kernel/suspend.c b/arch/x86_64/kernel/suspend.c
index 573c0a6..24055b6 100644
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
+	load_gdt((struct desc_ptr *)&ctxt->gdt_limit);
+	load_idt((struct desc_ptr *)&ctxt->idt_limit);
+
 
 	/*
 	 * segment registers
diff --git a/include/asm-x86_64/desc.h b/include/asm-x86_64/desc.h
index ac991b5..5710e52 100644
--- a/include/asm-x86_64/desc.h
+++ b/include/asm-x86_64/desc.h
@@ -16,9 +16,17 @@
 
 extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
 
-#define load_TR_desc() asm volatile("ltr %w0"::"r" (GDT_ENTRY_TSS*8))
-#define load_LDT_desc() asm volatile("lldt %w0"::"r" (GDT_ENTRY_LDT*8))
-#define clear_LDT()  asm volatile("lldt %w0"::"r" (0))
+static inline void native_load_tr_desc(void)
+{
+	asm volatile("ltr %w0"::"r" (GDT_ENTRY_TSS*8));
+}
+
+static inline unsigned long native_store_tr(void)
+{
+       unsigned long tr;
+       asm volatile ("str %w0":"=r" (tr));
+       return tr;
+}
 
 /*
  * This is the ldt that every process will get unless we need
@@ -31,44 +39,55 @@ extern struct desc_ptr cpu_gdt_descr[];
 /* the cpu gdt accessor */
 #define cpu_gdt(_cpu) ((struct desc_struct *)cpu_gdt_descr[_cpu].address)
 
-static inline void _set_gate(void *adr, unsigned type, unsigned long func, unsigned dpl, unsigned ist)  
+static inline void native_load_gdt(const struct desc_ptr *ptr)
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
+	asm volatile("lgdt %w0"::"m" (*ptr));
+}
 
-static inline void set_intr_gate(int nr, void *func) 
-{ 
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, 0); 
-} 
+static inline void native_store_gdt(struct desc_ptr *ptr)
+{
+       asm ("sgdt %w0":"=m" (*ptr));
+}
 
-static inline void set_intr_gate_ist(int nr, void *func, unsigned ist) 
-{ 
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, ist); 
-} 
+static inline void native_write_idt_entry(void *adr, struct gate_struct *s)
+{
+	/* does not need to be atomic because
+	 * it is only done once at setup time */
+	memcpy(adr, s, 16);
+}
 
-static inline void set_system_gate(int nr, void *func) 
-{ 
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, 0); 
-} 
+static inline void native_write_gdt_entry(void *ptr, void *entry,
+						unsigned type, unsigned size)
+{
+	memcpy(ptr, entry, size);
+}
 
-static inline void set_system_gate_ist(int nr, void *func, unsigned ist)
+/*
+ * This one unfortunately can't go with the others, in below, because it has
+ * an user anxious for its definition: set_tssldt_descriptor
+ */
+#ifndef CONFIG_PARAVIRT
+#define write_gdt_entry(_ptr, _e, _type, _size) \
+		native_write_gdt_entry((_ptr),(_e), (_type), (_size))
+#endif
+
+static inline void native_write_ldt_entry(struct desc_struct *ldt,
+					int entrynum, u32 entry_1, u32 entry_2)
 {
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, ist);
+	__u32 *lp;
+	lp = (__u32 *) ((entrynum << 3) + (char *) ldt);
+	*lp	= entry_1;
+	*(lp+1)	= entry_2;
+}
+
+static inline void native_load_idt(const struct desc_ptr *ptr)
+{
+	asm volatile("lidt %w0"::"m" (*ptr));
+}
+
+static inline void native_store_idt(struct desc_ptr *dtr)
+{
+       asm ("sidt %w0":"=m" (*dtr));
 }
 
 static inline void set_tssldt_descriptor(void *ptr, unsigned long tss, unsigned type, 
@@ -84,7 +103,7 @@ static inline void set_tssldt_descriptor(void *ptr, unsigned long tss, unsigned
 	d.limit1 = (size >> 16) & 0xF;
 	d.base2 = (PTR_MIDDLE(tss) >> 8) & 0xFF; 
 	d.base3 = PTR_HIGH(tss); 
-	memcpy(ptr, &d, 16); 
+	write_gdt_entry(ptr, &d, type, 16);
 }
 
 static inline void set_tss_desc(unsigned cpu, void *addr)
@@ -135,7 +154,7 @@ static inline void set_ldt_desc(unsigned cpu, void *addr, int size)
 	(info)->useable		== 0	&& \
 	(info)->lm		== 0)
 
-static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
+static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 {
 	unsigned int i;
 	u64 *gdt = (u64 *)(cpu_gdt(cpu) + GDT_ENTRY_TLS_MIN);
@@ -143,28 +162,92 @@ static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
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
+#define write_idt_entry(_adr, _s) native_write_idt_entry((_adr),(_s))
+#define write_ldt_entry(_ldt, _number, _entry1, _entry2) \
+		native_write_ldt_entry((_ldt), (_number), (_entry1), (_entry2))
+#endif
+
+static inline void _set_gate(void *adr, unsigned type, unsigned long func, unsigned dpl, unsigned ist)
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
+#define clear_LDT()  set_ldt(NULL,0)
 
 /*
  * load one particular LDT into the current CPU
  */
-static inline void load_LDT_nolock (mm_context_t *pc, int cpu)
+static inline void load_LDT_nolock (mm_context_t *pc)
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
diff --git a/include/asm-x86_64/mmu_context.h b/include/asm-x86_64/mmu_context.h
index 0cce83a..c8cdc1e 100644
--- a/include/asm-x86_64/mmu_context.h
+++ b/include/asm-x86_64/mmu_context.h
@@ -43,7 +43,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		load_cr3(next->pgd);
 
 		if (unlikely(next->context.ldt != prev->context.ldt)) 
-			load_LDT_nolock(&next->context, cpu);
+			load_LDT_nolock(&next->context);
 	}
 #ifdef CONFIG_SMP
 	else {
@@ -56,7 +56,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			 * to make sure to use no freed page tables.
 			 */
 			load_cr3(next->pgd);
-			load_LDT_nolock(&next->context, cpu);
+			load_LDT_nolock(&next->context);
 		}
 	}
 #endif
-- 
1.4.4.2

