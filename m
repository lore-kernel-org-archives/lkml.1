Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbZDQGlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbZDQGlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759980AbZDQGjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:39:45 -0400
Received: from gw.goop.org ([64.81.55.164]:56726 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754901AbZDQGjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:39:41 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: mathieu.desnoyers@polymtl.ca
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/5] x86/pvops: add tracing for all significant pvops entrypoints
Date: Thu, 16 Apr 2009 23:39:31 -0700
Message-Id: <1239950374-1252-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239950374-1252-1-git-send-email-jeremy@goop.org>
References: <1239950374-1252-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Define TRACE_EVENTS for all significant pvops entrypoints.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt-trace.h | 1171 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/paravirt.h       |  163 ++++-
 arch/x86/kernel/Makefile              |    5 +-
 arch/x86/kernel/paravirt-trace.c      |   16 +
 4 files changed, 1331 insertions(+), 24 deletions(-)
 create mode 100644 arch/x86/include/asm/paravirt-trace.h
 create mode 100644 arch/x86/kernel/paravirt-trace.c

diff --git a/arch/x86/include/asm/paravirt-trace.h b/arch/x86/include/asm/paravirt-trace.h
new file mode 100644
index 0000000..2c72964
--- /dev/null
+++ b/arch/x86/include/asm/paravirt-trace.h
@@ -0,0 +1,1171 @@
+#if !defined(_ASM_X86_PARAVIRT_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _ASM_X86_PARAVIRT_TRACE_H
+
+#include <linux/tracepoint.h>
+#include <asm/paravirt_types.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM pvops
+
+#define TRACE_INCLUDE_FILE	paravirt-trace
+#define TRACE_INCLUDE_PATH	asm
+
+struct tss_struct;
+struct thread_struct;
+
+/* width for %0*x */
+#define HEX_FIELD(type)	((int)sizeof(type) * 2)
+
+/* 
+ * Define tracepoints for all significant pvops.
+ *
+ * Some general rules I used to determine what to record:
+ *  - no global state (lazy modes, etc), since that can be
+ *    derived from tracing
+ *  - record old values where practical, so that updates can be
+ *    self-contained (somewhat contradictory to point 1, but
+ *    could be useful)
+ *  - display pte/pmd/pud/pgds in "cooked" rather than raw form
+ *    (ie, the result of "X_val" rather than the naked bitpattern
+ *    in the X_t type).
+ */
+
+TRACE_EVENT(load_sp0,
+	    TP_PROTO(struct tss_struct *tss, struct thread_struct *thread),
+	    TP_ARGS(tss, thread),
+	    TP_STRUCT__entry(
+		    __field(struct tss_struct *, tss)
+		    __field(struct thread_struct *, thread)
+		    ),
+	    TP_fast_assign(
+		    __entry->tss = tss;
+		    __entry->thread = thread;
+		    ),
+	    TP_printk("task %p tss = %p",
+		      __entry->thread, __entry->tss)
+	);
+
+TRACE_EVENT(get_debugreg,
+	    TP_PROTO(int reg, unsigned long val),
+	    TP_ARGS(reg, val),
+	    TP_STRUCT__entry(
+		    __field(int, reg)
+		    __field(unsigned long, val)
+		    ),
+	    TP_fast_assign(
+		    __entry->reg = reg;
+		    __entry->val = val;
+		    ),
+	    TP_printk("reg %d = %lx", __entry->reg, __entry->val)
+	);
+
+TRACE_EVENT(set_debugreg,
+	    TP_PROTO(int reg, unsigned long val),
+	    TP_ARGS(reg, val),
+	    TP_STRUCT__entry(
+		    __field(int, reg)
+		    __field(unsigned long, val)
+		    ),
+	    TP_fast_assign(
+		    __entry->reg = reg;
+		    __entry->val = val;
+		    ),
+	    TP_printk("reg %d = %lx", __entry->reg, __entry->val)
+	);
+
+TRACE_EVENT(clts,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(read_cr0,
+	    TP_PROTO(unsigned long cr0),
+	    TP_ARGS(cr0),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr0)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr0 = cr0;
+		    ),
+	    TP_printk("%lx", __entry->cr0)
+	);
+
+TRACE_EVENT(write_cr0,
+	    TP_PROTO(unsigned long cr0),
+	    TP_ARGS(cr0),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr0)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr0 = cr0;
+		    ),
+	    TP_printk("%lx", __entry->cr0)
+	);
+
+TRACE_EVENT(read_cr2,
+	    TP_PROTO(unsigned long cr2),
+	    TP_ARGS(cr2),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr2)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr2 = cr2;
+		    ),
+	    TP_printk("%lx", __entry->cr2)
+	);
+
+TRACE_EVENT(write_cr2,
+	    TP_PROTO(unsigned long cr2),
+	    TP_ARGS(cr2),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr2)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr2 = cr2;
+		    ),
+	    TP_printk("%lx", __entry->cr2)
+	);
+
+TRACE_EVENT(read_cr3,
+	    TP_PROTO(unsigned long cr3),
+	    TP_ARGS(cr3),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr3)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr3 = cr3;
+		    ),
+	    TP_printk("%lx", __entry->cr3)
+	);
+
+TRACE_EVENT(write_cr3,
+	    TP_PROTO(unsigned long cr3),
+	    TP_ARGS(cr3),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr3)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr3 = cr3;
+		    ),
+	    TP_printk("%lx", __entry->cr3)
+	);
+
+TRACE_EVENT(write_cr4,
+	    TP_PROTO(unsigned long cr4),
+	    TP_ARGS(cr4),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr4)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr4 = cr4;
+		    ),
+	    TP_printk("%lx", __entry->cr4)
+	);
+
+TRACE_EVENT(read_cr4,
+	    TP_PROTO(unsigned long cr4),
+	    TP_ARGS(cr4),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr4)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr4 = cr4;
+		    ),
+	    TP_printk("%lx", __entry->cr4)
+	);
+
+TRACE_EVENT(write_cr8,
+	    TP_PROTO(unsigned long cr8),
+	    TP_ARGS(cr8),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr8)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr8 = cr8;
+		    ),
+	    TP_printk("%lx", __entry->cr8)
+	);
+
+TRACE_EVENT(read_cr8,
+	    TP_PROTO(unsigned long cr8),
+	    TP_ARGS(cr8),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr8)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr8 = cr8;
+		    ),
+	    TP_printk("%lx", __entry->cr8)
+	);
+
+TRACE_EVENT(safe_halt,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(wbinvd,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(read_msr,
+	    TP_PROTO(unsigned msr, u64 val),
+	    TP_ARGS(msr, val),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, val)
+		    __field(unsigned, msr)
+		    ),
+	    TP_fast_assign(
+		    __entry->msr = msr;
+		    __entry->val = val;
+		    ),
+	    TP_printk("%x -> %llx", __entry->msr, __entry->val)
+	);
+
+TRACE_EVENT(read_msr_amd,
+	    TP_PROTO(unsigned msr, u64 val),
+	    TP_ARGS(msr, val),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, val)
+		    __field(unsigned, msr)
+		    ),
+	    TP_fast_assign(
+		    __entry->msr = msr;
+		    __entry->val = val;
+		    ),
+	    TP_printk("%x -> %llx", __entry->msr, __entry->val)
+	);
+
+TRACE_EVENT(write_msr,
+	    TP_PROTO(unsigned msr, unsigned low, unsigned high),
+	    TP_ARGS(msr, low, high),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, val)
+		    __field(unsigned, msr)
+		    ),
+	    TP_fast_assign(
+		    __entry->msr = msr;
+		    __entry->val = ((u64)high << 32) | low;
+		    ),
+	    TP_printk("%x -> %llx", __entry->msr, __entry->val)
+	);
+
+TRACE_EVENT(read_tsc,
+	    TP_PROTO(unsigned long long tsc),
+	    TP_ARGS(tsc),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, tsc)
+		    ),
+	    TP_fast_assign(
+		    __entry->tsc = tsc;
+		    ),
+	    TP_printk("%llx", __entry->tsc)
+	);
+
+TRACE_EVENT(sched_clock,
+	    TP_PROTO(unsigned long long clock),
+	    TP_ARGS(clock),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, clock)
+		    ),
+	    TP_fast_assign(
+		    __entry->clock = clock;
+		    ),
+	    TP_printk("%llx", __entry->clock)
+	);
+
+TRACE_EVENT(read_pmc,
+	    TP_PROTO(unsigned pmc, u64 val),
+	    TP_ARGS(pmc, val),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, val)
+		    __field(unsigned, pmc)
+		    ),
+	    TP_fast_assign(
+		    __entry->pmc = pmc;
+		    __entry->val = val;
+		    ),
+	    TP_printk("%x -> %llx", __entry->pmc, __entry->val)
+	);
+
+TRACE_EVENT(read_tscp,
+	    TP_PROTO(unsigned long long tsc, unsigned aux),
+	    TP_ARGS(tsc, aux),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, tsc)
+		    __field(unsigned, aux)
+		    ),
+	    TP_fast_assign(
+		    __entry->tsc = tsc;
+		    __entry->aux = aux;
+		    ),
+	    TP_printk("tsc:%llx aux:%x", __entry->tsc, __entry->aux)
+	);
+
+TRACE_EVENT(alloc_ldt,
+	    TP_PROTO(struct desc_struct *ldt, unsigned entries),
+	    TP_ARGS(ldt, entries),
+	    TP_STRUCT__entry(
+		    __field(struct desc_struct *, ldt)
+		    __field(unsigned, entries)
+		    ),
+	    TP_fast_assign(
+		    __entry->ldt = ldt;
+		    __entry->entries = entries;
+		    ),
+	    TP_printk("ldt:%p entries:%d",
+		      __entry->ldt, __entry->entries)
+	);
+
+TRACE_EVENT(free_ldt,
+	    TP_PROTO(struct desc_struct *ldt, unsigned entries),
+	    TP_ARGS(ldt, entries),
+	    TP_STRUCT__entry(
+		    __field(struct desc_struct *, ldt)
+		    __field(unsigned, entries)
+		    ),
+	    TP_fast_assign(
+		    __entry->ldt = ldt;
+		    __entry->entries = entries;
+		    ),
+	    TP_printk("ldt:%p entries:%d",
+		      __entry->ldt, __entry->entries)
+	);
+
+TRACE_EVENT(load_TR_desc,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(load_gdt,
+	    TP_PROTO(const struct desc_ptr *gdt),
+	    TP_ARGS(gdt),
+	    TP_STRUCT__entry(
+		    __field(struct desc_ptr, gdtptr)
+		    ),
+	    TP_fast_assign(
+		    __entry->gdtptr = *gdt;
+		    ),
+	    TP_printk("gdt:%lx size:%d",
+		      __entry->gdtptr.address, __entry->gdtptr.size)
+	);
+
+TRACE_EVENT(load_idt,
+	    TP_PROTO(const struct desc_ptr *idt),
+	    TP_ARGS(idt),
+	    TP_STRUCT__entry(
+		    __field(struct desc_ptr, idtptr)
+		    ),
+	    TP_fast_assign(
+		    __entry->idtptr = *idt;
+		    ),
+	    TP_printk("idt:%lx size:%d",
+		      __entry->idtptr.address, __entry->idtptr.size)
+	);
+
+TRACE_EVENT(set_ldt,
+	    TP_PROTO(const struct desc_struct *ldt, unsigned entries),
+	    TP_ARGS(ldt, entries),
+	    TP_STRUCT__entry(
+		    __field(const struct desc_struct *, ldt)
+		    __field(unsigned, entries)
+		    ),
+	    TP_fast_assign(
+		    __entry->ldt = ldt;
+		    __entry->entries = entries;
+		    ),
+	    TP_printk("ldt:%p entries:%d",
+		      __entry->ldt, __entry->entries)
+	);
+
+TRACE_EVENT(store_gdt,
+	    TP_PROTO(const struct desc_ptr *gdt),
+	    TP_ARGS(gdt),
+	    TP_STRUCT__entry(
+		    __field(struct desc_ptr, gdtptr)
+		    ),
+	    TP_fast_assign(
+		    __entry->gdtptr = *gdt;
+		    ),
+	    TP_printk("gdt:%lx size:%d",
+		      __entry->gdtptr.address, __entry->gdtptr.size)
+	);
+
+TRACE_EVENT(store_idt,
+	    TP_PROTO(const struct desc_ptr *idt),
+	    TP_ARGS(idt),
+	    TP_STRUCT__entry(
+		    __field(struct desc_ptr, idtptr)
+		    ),
+	    TP_fast_assign(
+		    __entry->idtptr = *idt;
+		    ),
+	    TP_printk("idt:%lx size:%d",
+		      __entry->idtptr.address, __entry->idtptr.size)
+	);
+
+TRACE_EVENT(store_tr,
+	    TP_PROTO(unsigned long tr),
+	    TP_ARGS(tr),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, tr)
+		    ),
+	    TP_fast_assign(
+		    __entry->tr = tr;
+		    ),
+	    TP_printk("%lx", __entry->tr)
+	);
+
+TRACE_EVENT(load_TLS,
+	    TP_PROTO(const struct thread_struct *t, unsigned cpu),
+	    TP_ARGS(t, cpu),
+	    TP_STRUCT__entry(
+		    __array(struct desc_struct, tls, GDT_ENTRY_TLS_ENTRIES)
+		    __field(unsigned, cpu)
+		    ),
+	    TP_fast_assign(
+		    memcpy(__entry->tls, t->tls_array, sizeof(__entry->tls));
+		    __entry->cpu = cpu;
+		    ),
+	    TP_printk("cpu:%d", __entry->cpu)
+	);
+
+TRACE_EVENT(load_gs_index,
+	    TP_PROTO(unsigned gs),
+	    TP_ARGS(gs),
+	    TP_STRUCT__entry(
+		    __field(unsigned, gs)
+		    ),
+	    TP_fast_assign(
+		    __entry->gs = gs;
+		    ),
+	    TP_printk("gs:%x", __entry->gs)
+	);
+
+TRACE_EVENT(write_ldt_entry,
+	    TP_PROTO(struct desc_struct *dt, int idx, const void *desc),
+	    TP_ARGS(dt, idx, desc),
+	    TP_STRUCT__entry(
+		    __field(struct desc_struct *, dt)
+		    __field(int, idx)
+		    __field(const void *, desc)
+		    ),
+	    TP_fast_assign(
+		    __entry->dt = dt;
+		    __entry->idx = idx;
+		    __entry->desc = desc;
+		    ),
+	    TP_printk("dt:%p entry:%d desc:%p",
+		      __entry->dt, __entry->idx, __entry->desc)
+	);
+
+TRACE_EVENT(write_gdt_entry,
+	    TP_PROTO(struct desc_struct *dt, int idx, void *desc, int type),
+	    TP_ARGS(dt, idx, desc, type),
+	    TP_STRUCT__entry(
+		    __field(struct desc_struct *, dt)
+		    __field(int, idx)
+		    __field(void *, desc)
+		    __field(int, type)
+		    ),
+	    TP_fast_assign(
+		    __entry->dt = dt;
+		    __entry->idx = idx;
+		    __entry->desc = desc;
+		    __entry->type = type;
+		    ),
+	    TP_printk("dt:%p entry:%d desc:%p type:%d",
+		      __entry->dt, __entry->idx, __entry->desc, __entry->type)
+	);
+
+TRACE_EVENT(write_idt_entry,
+	    TP_PROTO(gate_desc *dt, int idx, const gate_desc *g),
+	    TP_ARGS(dt, idx, g),
+	    TP_STRUCT__entry(
+		    __field(gate_desc *, dt)
+		    __field(int, idx)
+		    __field(const gate_desc *, gate)
+		    ),
+	    TP_fast_assign(
+		    __entry->dt = dt;
+		    __entry->idx = idx;
+		    __entry->gate = g;
+		    ),
+	    TP_printk("dt:%p entry:%d gate:%p",
+		      __entry->dt, __entry->idx, __entry->gate)
+	);
+
+TRACE_EVENT(set_iopl_mask,
+	    TP_PROTO(unsigned mask),
+	    TP_ARGS(mask),
+	    TP_STRUCT__entry(
+		    __field(unsigned, mask)
+		    ),
+	    TP_fast_assign(
+		    __entry->mask = mask;
+		    ),
+	    TP_printk("mask:%x", __entry->mask)
+	);
+
+TRACE_EVENT(activate_mm,
+	    TP_PROTO(struct mm_struct *prev, struct mm_struct *next),
+	    TP_ARGS(prev, next),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, prev)
+		    __field(struct mm_struct *, next)
+		    ),
+	    TP_fast_assign(
+		    __entry->prev = prev;
+		    __entry->next = next;
+		    ),
+	    TP_printk("prev=%p next=%p",
+		      __entry->prev, __entry->next)
+	);
+
+TRACE_EVENT(dup_mmap,
+	    TP_PROTO(struct mm_struct *prev, struct mm_struct *next),
+	    TP_ARGS(prev, next),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, prev)
+		    __field(struct mm_struct *, next)
+		    ),
+	    TP_fast_assign(
+		    __entry->prev = prev;
+		    __entry->next = next;
+		    ),
+	    TP_printk("oldmm=%p mm=%p",
+		      __entry->prev, __entry->next)
+	);
+
+TRACE_EVENT(exit_mmap,
+	    TP_PROTO(struct mm_struct *mm),
+	    TP_ARGS(mm),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    ),
+	    TP_printk("mm=%p", __entry->mm)
+	);
+
+TRACE_EVENT(flush_tlb_user,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(flush_tlb_kernel,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(flush_tlb_single,
+	    TP_PROTO(unsigned long addr),
+	    TP_ARGS(addr),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, addr)
+		    ),
+	    TP_fast_assign(
+		    __entry->addr = addr;
+		    ),
+	    TP_printk("addr:%lx", __entry->addr)
+	);
+
+TRACE_EVENT(flush_tlb_others,
+	    TP_PROTO(const struct cpumask *cpumask, struct mm_struct *mm, unsigned long va),
+	    TP_ARGS(cpumask, mm, va),
+	    TP_STRUCT__entry(
+		    __field(struct cpumask, cpumask)
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, va)
+		    ),
+	    TP_fast_assign(
+		    __entry->cpumask = *cpumask;
+		    __entry->mm = mm;
+		    __entry->va = va;
+		    ),
+	    TP_printk("cpumask:<> mm:%p addr:%lx",
+		      __entry->mm, __entry->va)
+	);
+
+TRACE_EVENT(pgd_alloc,
+	    TP_PROTO(struct mm_struct *mm),
+	    TP_ARGS(mm),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(pgd_t *, pgd)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->pgd = mm->pgd;
+		    ),
+	    TP_printk("mm:%p pgd:%p", __entry->mm, __entry->pgd)
+	);
+
+
+TRACE_EVENT(pgd_free,
+	    TP_PROTO(struct mm_struct *mm, pgd_t *pgd),
+	    TP_ARGS(mm, pgd),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(pgd_t *, pgd)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->pgd = pgd;
+		    ),
+	    TP_printk("mm:%p pgd:%p", __entry->mm, __entry->pgd)
+	);
+
+TRACE_EVENT(alloc_pte,
+	    TP_PROTO(struct mm_struct *mm, unsigned long pfn),
+	    TP_ARGS(mm, pfn),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("mm:%p pfn:%lx", __entry->mm, __entry->pfn)
+	);
+
+TRACE_EVENT(release_pte,
+	    TP_PROTO(unsigned long pfn),
+	    TP_ARGS(pfn),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("pfn:%lx", __entry->pfn)
+	);
+
+TRACE_EVENT(alloc_pmd,
+	    TP_PROTO(struct mm_struct *mm, unsigned long pfn),
+	    TP_ARGS(mm, pfn),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("mm:%p pfn:%lx", __entry->mm, __entry->pfn)
+	);
+
+TRACE_EVENT(alloc_pmd_clone,
+	    TP_PROTO(unsigned long pfn, unsigned long clonepfn,
+		     unsigned long start, unsigned long count),
+	    TP_ARGS(pfn, clonepfn, start, count),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, pfn)
+		    __field(unsigned long, clonepfn)
+		    __field(unsigned long, start)
+		    __field(unsigned long, count)
+		    ),
+	    TP_fast_assign(
+		    __entry->pfn = pfn;
+		    __entry->clonepfn = clonepfn;
+		    __entry->start = start;
+		    __entry->count = count;
+		    ),
+	    TP_printk("pfn:%lx clonepfn:%lx start:%lx count:%lx",
+		      __entry->pfn, __entry->clonepfn, __entry->start, __entry->count)
+	);
+
+TRACE_EVENT(release_pmd,
+	    TP_PROTO(unsigned long pfn),
+	    TP_ARGS(pfn),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("pfn:%lx", __entry->pfn)
+	);
+
+TRACE_EVENT(alloc_pud,
+	    TP_PROTO(struct mm_struct *mm, unsigned long pfn),
+	    TP_ARGS(mm, pfn),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("mm:%p pfn:%lx", __entry->mm, __entry->pfn)
+	);
+
+TRACE_EVENT(release_pud,
+	    TP_PROTO(unsigned long pfn),
+	    TP_ARGS(pfn),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("pfn:%lx", __entry->pfn)
+	);
+
+TRACE_EVENT(kmap_atomic_pte,
+	    TP_PROTO(struct page *page, enum km_type type, unsigned long addr),
+	    TP_ARGS(page, type, addr),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, pfn)
+		    __field(unsigned long, addr)
+		    __field(enum km_type, type)
+		    ),
+	    TP_fast_assign(
+		    __entry->pfn = page_to_pfn(page);
+		    __entry->type = type;
+		    __entry->addr = addr;
+		    ),
+	    TP_printk("pfn:%lx type:%d addr:%lx",
+		      __entry->pfn, __entry->type, __entry->addr)
+	);
+
+TRACE_EVENT(pte_update,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
+	    TP_ARGS(mm, addr, ptep),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->pteval = pte_val_notrace(*ptep);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(pte_update_defer,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
+	    TP_ARGS(mm, addr, ptep),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->pteval = pte_val_notrace(*ptep);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(make_pte,
+	    TP_PROTO(pteval_t pteval, pteval_t pte),
+	    TP_ARGS(pteval, pte),
+	    TP_STRUCT__entry(
+		    __field(pteval_t, pteval)
+		    __field(pteval_t, pte)
+		    ),
+	    TP_fast_assign(
+		    __entry->pteval = pteval;
+		    __entry->pte = pte;
+		    ),
+	    TP_printk("pteval:%0*llx pte:%0*llx",
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pte)
+	);
+
+TRACE_EVENT(pte_val,
+	    TP_PROTO(pte_t pte, pteval_t pteval),
+	    TP_ARGS(pte, pteval),
+	    TP_STRUCT__entry(
+		    __field(pte_t, pte)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(
+		    __entry->pte = pte;
+		    __entry->pteval = pteval;
+		    ),
+	    TP_printk("pte:%0*llx pteval:%0*llx",
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pte.pte,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(make_pgd,
+	    TP_PROTO(pgdval_t pgdval, pgdval_t pgd),
+	    TP_ARGS(pgdval, pgd),
+	    TP_STRUCT__entry(
+		    __field(pgdval_t, pgdval)
+		    __field(pgdval_t, pgd)
+		    ),
+	    TP_fast_assign(
+		    __entry->pgdval = pgdval;
+		    __entry->pgd = pgd;
+		    ),
+	    TP_printk("pgdval:%0*llx pgd:%0*llx",
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgdval,
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgd)
+	);
+
+TRACE_EVENT(pgd_val,
+	    TP_PROTO(pgd_t pgd, pgdval_t pgdval),
+	    TP_ARGS(pgd, pgdval),
+	    TP_STRUCT__entry(
+		    __field(pgd_t, pgd)
+		    __field(pgdval_t, pgdval)
+		    ),
+	    TP_fast_assign(
+		    __entry->pgd = pgd;
+		    __entry->pgdval = pgdval;
+		    ),
+	    TP_printk("pgd:%0*llx pgdval:%0*llx",
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgd.pgd,
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgdval)
+	);
+
+TRACE_EVENT(ptep_modify_prot_start,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
+	    TP_ARGS(mm, addr, ptep),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->pteval = pte_val_notrace(*ptep);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(ptep_modify_prot_commit,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte),
+	    TP_ARGS(mm, addr, ptep, pte),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    __field(pteval_t, newpte)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->pteval = pte_val_notrace(*ptep);
+		    __entry->newpte = pte_val_notrace(pte);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx newpte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
+	);
+
+TRACE_EVENT(set_pte,
+	    TP_PROTO(pte_t *ptep, pte_t pte),
+	    TP_ARGS(ptep, pte),
+	    TP_STRUCT__entry(
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, oldpte)
+		    __field(pteval_t, newpte)
+		    ),
+	    TP_fast_assign(
+		    __entry->ptep = ptep;
+		    __entry->oldpte = pte_val_notrace(*ptep);
+		    __entry->newpte = pte_val_notrace(pte);
+		    ),
+	    TP_printk("ptep:%p oldpte:%0*llx newpte:%0*llx",
+		      __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
+	);
+
+TRACE_EVENT(set_pte_at,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte),
+	    TP_ARGS(mm, addr, ptep, pte),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, oldpte)
+		    __field(pteval_t, newpte)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->oldpte = pte_val_notrace(*ptep);
+		    __entry->newpte = pte_val_notrace(pte);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p oldpte:%0*llx newpte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
+	);
+
+TRACE_EVENT(set_pmd,
+	    TP_PROTO(pmd_t *pmdp, pmd_t pmd),
+	    TP_ARGS(pmdp, pmd),
+	    TP_STRUCT__entry(
+		    __field(pmd_t *, pmdp)
+		    __field(pmdval_t, oldpmd)
+		    __field(pmdval_t, newpmd)
+		    ),
+	    TP_fast_assign(
+		    __entry->pmdp = pmdp;
+		    __entry->oldpmd = pmd_val_notrace(*pmdp);
+		    __entry->newpmd = pmd_val_notrace(pmd);
+		    ),
+	    TP_printk("pmdp:%p oldpmd:%0*llx newpmd:%0*llx",
+		      __entry->pmdp,
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->oldpmd,
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->newpmd)
+	);
+
+#if PAGETABLE_LEVELS >= 3
+TRACE_EVENT(make_pmd,
+	    TP_PROTO(pmdval_t pmdval, pmdval_t pmd),
+	    TP_ARGS(pmdval, pmd),
+	    TP_STRUCT__entry(
+		    __field(pmdval_t, pmdval)
+		    __field(pmdval_t, pmd)
+		    ),
+	    TP_fast_assign(
+		    __entry->pmdval = pmdval;
+		    __entry->pmd = pmd;
+		    ),
+	    TP_printk("pmdval:%0*llx pmd:%0*llx",
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmdval,
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmd)
+	);
+
+TRACE_EVENT(pmd_val,
+	    TP_PROTO(pmd_t pmd, pmdval_t pmdval),
+	    TP_ARGS(pmd, pmdval),
+	    TP_STRUCT__entry(
+		    __field(pmd_t, pmd)
+		    __field(pmdval_t, pmdval)
+		    ),
+	    TP_fast_assign(
+		    __entry->pmd = pmd;
+		    __entry->pmdval = pmdval;
+		    ),
+	    TP_printk("pmd:%0*llx pmdval:%0*llx",
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmd.pmd,
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmdval)
+	);
+
+TRACE_EVENT(set_pud,
+	    TP_PROTO(pud_t *pudp, pud_t pud),
+	    TP_ARGS(pudp, pud),
+	    TP_STRUCT__entry(
+		    __field(pud_t *, pudp)
+		    __field(pudval_t, oldpud)
+		    __field(pudval_t, newpud)
+		    ),
+	    TP_fast_assign(
+		    __entry->pudp = pudp;
+		    __entry->oldpud = pud_val_notrace(*pudp);
+		    __entry->newpud = pud_val_notrace(pud);
+		    ),
+	    TP_printk("pudp:%p oldpud:%0*llx newpud:%0*llx",
+		      __entry->pudp,
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->oldpud,
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->newpud)
+	);
+
+#if PAGETABLE_LEVELS == 4
+
+TRACE_EVENT(make_pud,
+	    TP_PROTO(pudval_t pudval, pudval_t pud),
+	    TP_ARGS(pudval, pud),
+	    TP_STRUCT__entry(
+		    __field(pudval_t, pudval)
+		    __field(pudval_t, pud)
+		    ),
+	    TP_fast_assign(
+		    __entry->pudval = pudval;
+		    __entry->pud = pud;
+		    ),
+	    TP_printk("pudval:%0*llx pud:%0*llx",
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pudval,
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pud)
+	);
+
+TRACE_EVENT(pud_val,
+	    TP_PROTO(pud_t pud, pudval_t pudval),
+	    TP_ARGS(pud, pudval),
+	    TP_STRUCT__entry(
+		    __field(pud_t, pud)
+		    __field(pudval_t, pudval)
+		    ),
+	    TP_fast_assign(
+		    __entry->pud = pud;
+		    __entry->pudval = pudval;
+		    ),
+	    TP_printk("pud:%0*llx pudval:%0*llx",
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pud.pud,
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pudval)
+	);
+
+TRACE_EVENT(set_pgd,
+	    TP_PROTO(pgd_t *pgdp, pgd_t pgd),
+	    TP_ARGS(pgdp, pgd),
+	    TP_STRUCT__entry(
+		    __field(pgd_t *, pgdp)
+		    __field(pgdval_t, oldpgd)
+		    __field(pgdval_t, newpgd)
+		    ),
+	    TP_fast_assign(
+		    __entry->pgdp = pgdp;
+		    __entry->oldpgd = pgd_val_notrace(*pgdp);
+		    __entry->newpgd = pgd_val_notrace(pgd);
+		    ),
+	    TP_printk("pgdp:%p oldpgd:%0*llx newpgd:%0*llx",
+		      __entry->pgdp,
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->oldpgd,
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->newpgd)
+	);
+
+#endif	/* PAGETABLE_LEVELS == 4 */
+
+#endif	/* PAGETABLE_LEVELS >= 3 */
+
+#ifdef CONFIG_X86_PAE
+TRACE_EVENT(set_pte_atomic,
+	    TP_PROTO(pte_t *ptep, pte_t pte),
+	    TP_ARGS(ptep, pte),
+	    TP_STRUCT__entry(
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, oldpte)
+		    __field(pteval_t, newpte)
+		    ),
+	    TP_fast_assign(
+		    __entry->ptep = ptep;
+		    __entry->oldpte = pte_val_notrace(*ptep);
+		    __entry->newpte = pte_val_notrace(pte);
+		    ),
+	    TP_printk("ptep:%p oldpte:%0*llx newpte:%0*llx",
+		      __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
+	);
+
+TRACE_EVENT(pte_clear,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
+	    TP_ARGS(mm, addr, ptep),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, oldpte)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->oldpte = pte_val_notrace(*ptep);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p oldpte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte)
+	);
+
+TRACE_EVENT(pmd_clear,
+	    TP_PROTO(pmd_t *pmdp),
+	    TP_ARGS(pmdp),
+	    TP_STRUCT__entry(
+		    __field(pmd_t *, pmdp)
+		    __field(pmdval_t, oldpmd)
+		    ),
+	    TP_fast_assign(
+		    __entry->pmdp = pmdp;
+		    __entry->oldpmd = pmd_val_notrace(*pmdp);
+		    ),
+	    TP_printk("pmdp:%p oldpmd:%0*llx",
+		      __entry->pmdp,
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->oldpmd)
+	);
+
+#endif	/* CONFIG_X86_PAE */
+
+TRACE_EVENT(enter_lazy_cpu,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(leave_lazy_cpu,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(enter_lazy_mmu,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(leave_lazy_mmu,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(set_fixmap,
+	    TP_PROTO(unsigned idx, phys_addr_t phys, pgprot_t flags),
+	    TP_ARGS(idx, phys, flags),
+	    TP_STRUCT__entry(
+		    __field(unsigned, idx)
+		    __field(phys_addr_t, phys)
+		    __field(pgprot_t, flags)
+		    ),
+	    TP_fast_assign(
+		    __entry->idx = idx;
+		    __entry->phys = phys;
+		    __entry->flags = flags;
+		    ),
+	    TP_printk("idx:%d phys:%llx flags:%*llx",
+		      __entry->idx, (unsigned long long)__entry->phys,
+		      HEX_FIELD(pgprotval_t), (unsigned long long)pgprot_val(__entry->flags))
+	);
+
+#endif	/* _ASM_X86_PARAVIRT_TRACE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 9fdc5f7..fafb965 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -12,8 +12,10 @@
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/cpumask.h>
+
 #include <asm/kmap_types.h>
 #include <asm/desc_defs.h>
+#include <asm/paravirt-trace.h>
 
 static inline int paravirt_enabled(void)
 {
@@ -54,87 +56,115 @@ static inline void __cpuid(unsigned int *eax, unsigned int *ebx,
  */
 static inline unsigned long paravirt_get_debugreg(int reg)
 {
-	return PVOP_CALL1(unsigned long, pv_cpu_ops.get_debugreg, reg);
+	unsigned long ret;
+
+	ret = PVOP_CALL1(unsigned long, pv_cpu_ops.get_debugreg, reg);
+
+	trace_get_debugreg(reg, ret);
+
+	return ret;
 }
 #define get_debugreg(var, reg) var = paravirt_get_debugreg(reg)
 static inline void set_debugreg(unsigned long val, int reg)
 {
+	trace_set_debugreg(reg, val);
 	PVOP_VCALL2(pv_cpu_ops.set_debugreg, reg, val);
 }
 
 static inline void clts(void)
 {
+	trace_clts(0);
 	PVOP_VCALL0(pv_cpu_ops.clts);
 }
 
 static inline unsigned long read_cr0(void)
 {
-	return PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr0);
+	unsigned long ret = PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr0);
+	trace_read_cr0(ret);
+	return ret;
 }
 
 static inline void write_cr0(unsigned long x)
 {
+	trace_write_cr0(x);
 	PVOP_VCALL1(pv_cpu_ops.write_cr0, x);
 }
 
 static inline unsigned long read_cr2(void)
 {
-	return PVOP_CALL0(unsigned long, pv_mmu_ops.read_cr2);
+	unsigned long ret = PVOP_CALL0(unsigned long, pv_mmu_ops.read_cr2);
+	trace_read_cr2(ret);
+	return ret;
 }
 
 static inline void write_cr2(unsigned long x)
 {
+	trace_write_cr2(x);
 	PVOP_VCALL1(pv_mmu_ops.write_cr2, x);
 }
 
 static inline unsigned long read_cr3(void)
 {
-	return PVOP_CALL0(unsigned long, pv_mmu_ops.read_cr3);
+	unsigned long ret = PVOP_CALL0(unsigned long, pv_mmu_ops.read_cr3);
+	trace_read_cr3(ret);
+	return ret;
 }
 
 static inline void write_cr3(unsigned long x)
 {
+	trace_write_cr3(x);
 	PVOP_VCALL1(pv_mmu_ops.write_cr3, x);
 }
 
 static inline unsigned long read_cr4(void)
 {
-	return PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr4);
+	unsigned long ret = PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr4);
+	trace_read_cr4(ret);
+	return ret;
 }
 static inline unsigned long read_cr4_safe(void)
 {
-	return PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr4_safe);
+	unsigned long ret = PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr4_safe);
+	trace_read_cr4(ret);
+	return ret;
 }
 
 static inline void write_cr4(unsigned long x)
 {
+	trace_write_cr4(x);
 	PVOP_VCALL1(pv_cpu_ops.write_cr4, x);
 }
 
 #ifdef CONFIG_X86_64
 static inline unsigned long read_cr8(void)
 {
-	return PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr8);
+	unsigned long ret = PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr8);
+	trace_read_cr8(ret);
+	return ret;
 }
 
 static inline void write_cr8(unsigned long x)
 {
+	trace_write_cr8(x);
 	PVOP_VCALL1(pv_cpu_ops.write_cr8, x);
 }
 #endif
 
 static inline void raw_safe_halt(void)
 {
+	trace_safe_halt(0);
 	PVOP_VCALL0(pv_irq_ops.safe_halt);
 }
 
 static inline void halt(void)
 {
+	trace_safe_halt(0);
 	PVOP_VCALL0(pv_irq_ops.safe_halt);
 }
 
 static inline void wbinvd(void)
 {
+	trace_wbinvd(0);
 	PVOP_VCALL0(pv_cpu_ops.wbinvd);
 }
 
@@ -142,14 +172,19 @@ static inline void wbinvd(void)
 
 static inline u64 paravirt_read_msr(unsigned msr, int *err)
 {
-	return PVOP_CALL2(u64, pv_cpu_ops.read_msr, msr, err);
+	u64 ret = PVOP_CALL2(u64, pv_cpu_ops.read_msr, msr, err);
+	trace_read_msr(msr, ret);
+	return ret;
 }
 static inline u64 paravirt_read_msr_amd(unsigned msr, int *err)
 {
-	return PVOP_CALL2(u64, pv_cpu_ops.read_msr_amd, msr, err);
+	u64 ret = PVOP_CALL2(u64, pv_cpu_ops.read_msr_amd, msr, err);
+	trace_read_msr_amd(msr, ret);
+	return ret;
 }
 static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 {
+	trace_write_msr(msr, low, high);
 	return PVOP_CALL3(int, pv_cpu_ops.write_msr, msr, low, high);
 }
 
@@ -203,7 +238,9 @@ static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 
 static inline u64 paravirt_read_tsc(void)
 {
-	return PVOP_CALL0(u64, pv_cpu_ops.read_tsc);
+	u64 ret = PVOP_CALL0(u64, pv_cpu_ops.read_tsc);
+	trace_read_tsc(ret);
+	return ret;
 }
 
 #define rdtscl(low)				\
@@ -216,13 +253,17 @@ do {						\
 
 static inline unsigned long long paravirt_sched_clock(void)
 {
-	return PVOP_CALL0(unsigned long long, pv_time_ops.sched_clock);
+	unsigned long long ret = PVOP_CALL0(unsigned long long, pv_time_ops.sched_clock);
+	trace_sched_clock(ret);
+	return ret;
 }
 #define calibrate_tsc() (pv_time_ops.get_tsc_khz())
 
 static inline unsigned long long paravirt_read_pmc(int counter)
 {
-	return PVOP_CALL1(u64, pv_cpu_ops.read_pmc, counter);
+	unsigned long long ret = PVOP_CALL1(u64, pv_cpu_ops.read_pmc, counter);
+	trace_read_tscp(counter, ret);
+	return ret;
 }
 
 #define rdpmc(counter, low, high)		\
@@ -234,7 +275,9 @@ do {						\
 
 static inline unsigned long long paravirt_rdtscp(unsigned int *aux)
 {
-	return PVOP_CALL1(u64, pv_cpu_ops.read_tscp, aux);
+	unsigned long long ret = PVOP_CALL1(u64, pv_cpu_ops.read_tscp, aux);
+	trace_read_tscp(ret, *aux);
+	return ret;
 }
 
 #define rdtscp(low, high, aux)				\
@@ -255,51 +298,63 @@ do {							\
 
 static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
+	trace_alloc_ldt(ldt, entries);
 	PVOP_VCALL2(pv_cpu_ops.alloc_ldt, ldt, entries);
 }
 
 static inline void paravirt_free_ldt(struct desc_struct *ldt, unsigned entries)
 {
+	trace_free_ldt(ldt, entries);
 	PVOP_VCALL2(pv_cpu_ops.free_ldt, ldt, entries);
 }
 
 static inline void load_TR_desc(void)
 {
+	trace_load_TR_desc(0);
 	PVOP_VCALL0(pv_cpu_ops.load_tr_desc);
 }
 static inline void load_gdt(const struct desc_ptr *dtr)
 {
+	trace_load_gdt(dtr);
 	PVOP_VCALL1(pv_cpu_ops.load_gdt, dtr);
 }
 static inline void load_idt(const struct desc_ptr *dtr)
 {
+	trace_load_idt(dtr);
 	PVOP_VCALL1(pv_cpu_ops.load_idt, dtr);
 }
 static inline void set_ldt(const void *addr, unsigned entries)
 {
+	trace_set_ldt(addr, entries);
 	PVOP_VCALL2(pv_cpu_ops.set_ldt, addr, entries);
 }
 static inline void store_gdt(struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.store_gdt, dtr);
+	trace_store_gdt(dtr);
 }
 static inline void store_idt(struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.store_idt, dtr);
+	trace_store_idt(dtr);
 }
 static inline unsigned long paravirt_store_tr(void)
 {
-	return PVOP_CALL0(unsigned long, pv_cpu_ops.store_tr);
+	unsigned long ret = PVOP_CALL0(unsigned long, pv_cpu_ops.store_tr);
+	trace_store_tr(ret);
+	return ret;
 }
 #define store_tr(tr)	((tr) = paravirt_store_tr())
 static inline void load_TLS(struct thread_struct *t, unsigned cpu)
 {
+	trace_load_TLS(t, cpu);
 	PVOP_VCALL2(pv_cpu_ops.load_tls, t, cpu);
 }
 
 #ifdef CONFIG_X86_64
 static inline void load_gs_index(unsigned int gs)
 {
+	trace_load_gs_index(gs);
 	PVOP_VCALL1(pv_cpu_ops.load_gs_index, gs);
 }
 #endif
@@ -307,21 +362,25 @@ static inline void load_gs_index(unsigned int gs)
 static inline void write_ldt_entry(struct desc_struct *dt, int entry,
 				   const void *desc)
 {
+	trace_write_ldt_entry(dt, entry, desc);
 	PVOP_VCALL3(pv_cpu_ops.write_ldt_entry, dt, entry, desc);
 }
 
 static inline void write_gdt_entry(struct desc_struct *dt, int entry,
 				   void *desc, int type)
 {
+	trace_write_gdt_entry(dt, entry, desc, type);
 	PVOP_VCALL4(pv_cpu_ops.write_gdt_entry, dt, entry, desc, type);
 }
 
 static inline void write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
 {
+	trace_write_idt_entry(dt, entry, g);
 	PVOP_VCALL3(pv_cpu_ops.write_idt_entry, dt, entry, g);
 }
 static inline void set_iopl_mask(unsigned mask)
 {
+	trace_set_iopl_mask(mask);
 	PVOP_VCALL1(pv_cpu_ops.set_iopl_mask, mask);
 }
 
@@ -376,30 +435,36 @@ static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 static inline void paravirt_activate_mm(struct mm_struct *prev,
 					struct mm_struct *next)
 {
+	trace_activate_mm(prev, next);
 	PVOP_VCALL2(pv_mmu_ops.activate_mm, prev, next);
 }
 
 static inline void arch_dup_mmap(struct mm_struct *oldmm,
 				 struct mm_struct *mm)
 {
+	trace_dup_mmap(oldmm, mm);
 	PVOP_VCALL2(pv_mmu_ops.dup_mmap, oldmm, mm);
 }
 
 static inline void arch_exit_mmap(struct mm_struct *mm)
 {
+	trace_exit_mmap(mm);
 	PVOP_VCALL1(pv_mmu_ops.exit_mmap, mm);
 }
 
 static inline void __flush_tlb(void)
 {
+	trace_flush_tlb_user(0);
 	PVOP_VCALL0(pv_mmu_ops.flush_tlb_user);
 }
 static inline void __flush_tlb_global(void)
 {
+	trace_flush_tlb_kernel(0);
 	PVOP_VCALL0(pv_mmu_ops.flush_tlb_kernel);
 }
 static inline void __flush_tlb_single(unsigned long addr)
 {
+	trace_flush_tlb_single(addr);
 	PVOP_VCALL1(pv_mmu_ops.flush_tlb_single, addr);
 }
 
@@ -407,49 +472,60 @@ static inline void flush_tlb_others(const struct cpumask *cpumask,
 				    struct mm_struct *mm,
 				    unsigned long va)
 {
+	trace_flush_tlb_others(cpumask, mm, va);	
 	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, cpumask, mm, va);
 }
 
 static inline int paravirt_pgd_alloc(struct mm_struct *mm)
 {
-	return PVOP_CALL1(int, pv_mmu_ops.pgd_alloc, mm);
+	int ret = PVOP_CALL1(int, pv_mmu_ops.pgd_alloc, mm);
+	trace_pgd_alloc(mm);
+	return ret;
 }
 
 static inline void paravirt_pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
+	trace_pgd_free(mm, pgd);
 	PVOP_VCALL2(pv_mmu_ops.pgd_free, mm, pgd);
 }
 
 static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned long pfn)
 {
+	trace_alloc_pte(mm, pfn);
 	PVOP_VCALL2(pv_mmu_ops.alloc_pte, mm, pfn);
 }
 static inline void paravirt_release_pte(unsigned long pfn)
 {
+	trace_release_pte(pfn);
 	PVOP_VCALL1(pv_mmu_ops.release_pte, pfn);
 }
 
 static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
 {
+	trace_alloc_pmd(mm, pfn);
 	PVOP_VCALL2(pv_mmu_ops.alloc_pmd, mm, pfn);
 }
 
 static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,
 					    unsigned long start, unsigned long count)
 {
+	trace_alloc_pmd_clone(pfn, clonepfn, start, count);
 	PVOP_VCALL4(pv_mmu_ops.alloc_pmd_clone, pfn, clonepfn, start, count);
 }
 static inline void paravirt_release_pmd(unsigned long pfn)
 {
+	trace_release_pmd(pfn);
 	PVOP_VCALL1(pv_mmu_ops.release_pmd, pfn);
 }
 
 static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned long pfn)
 {
+	trace_alloc_pud(mm, pfn);
 	PVOP_VCALL2(pv_mmu_ops.alloc_pud, mm, pfn);
 }
 static inline void paravirt_release_pud(unsigned long pfn)
 {
+	trace_release_pud(pfn);
 	PVOP_VCALL1(pv_mmu_ops.release_pud, pfn);
 }
 
@@ -458,6 +534,7 @@ static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
 {
 	unsigned long ret;
 	ret = PVOP_CALL2(unsigned long, pv_mmu_ops.kmap_atomic_pte, page, type);
+	trace_kmap_atomic_pte(page, type, ret);
 	return (void *)ret;
 }
 #endif
@@ -465,12 +542,14 @@ static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
 static inline void pte_update(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)
 {
+	trace_pte_update(mm, addr, ptep);
 	PVOP_VCALL3(pv_mmu_ops.pte_update, mm, addr, ptep);
 }
 
 static inline void pte_update_defer(struct mm_struct *mm, unsigned long addr,
 				    pte_t *ptep)
 {
+	trace_pte_update_defer(mm, addr, ptep);
 	PVOP_VCALL3(pv_mmu_ops.pte_update_defer, mm, addr, ptep);
 }
 
@@ -486,11 +565,11 @@ static inline pte_t __pte(pteval_t val)
 		ret = PVOP_CALLEE1(pteval_t,
 				   pv_mmu_ops.make_pte,
 				   val);
-
+	trace_make_pte(val, ret);
 	return (pte_t) { .pte = ret };
 }
 
-static inline pteval_t pte_val(pte_t pte)
+static inline pteval_t pte_val_notrace(pte_t pte)
 {
 	pteval_t ret;
 
@@ -500,7 +579,13 @@ static inline pteval_t pte_val(pte_t pte)
 	else
 		ret = PVOP_CALLEE1(pteval_t, pv_mmu_ops.pte_val,
 				   pte.pte);
+	return ret;
+}
 
+static inline pteval_t pte_val(pte_t pte)
+{
+	pteval_t ret = pte_val_notrace(pte);
+	trace_pte_val(pte, ret);
 	return ret;
 }
 
@@ -514,11 +599,11 @@ static inline pgd_t __pgd(pgdval_t val)
 	else
 		ret = PVOP_CALLEE1(pgdval_t, pv_mmu_ops.make_pgd,
 				   val);
-
+	trace_make_pgd(val, ret);
 	return (pgd_t) { ret };
 }
 
-static inline pgdval_t pgd_val(pgd_t pgd)
+static inline pgdval_t pgd_val_notrace(pgd_t pgd)
 {
 	pgdval_t ret;
 
@@ -528,7 +613,13 @@ static inline pgdval_t pgd_val(pgd_t pgd)
 	else
 		ret =  PVOP_CALLEE1(pgdval_t, pv_mmu_ops.pgd_val,
 				    pgd.pgd);
+	return ret;
+}
 
+static inline pgdval_t pgd_val(pgd_t pgd)
+{
+	pgdval_t ret = pgd_val_notrace(pgd);
+	trace_pgd_val(pgd, ret);
 	return ret;
 }
 
@@ -541,12 +632,14 @@ static inline pte_t ptep_modify_prot_start(struct mm_struct *mm, unsigned long a
 	ret = PVOP_CALL3(pteval_t, pv_mmu_ops.ptep_modify_prot_start,
 			 mm, addr, ptep);
 
+	trace_ptep_modify_prot_start(mm, addr, ptep);
 	return (pte_t) { .pte = ret };
 }
 
 static inline void ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 					   pte_t *ptep, pte_t pte)
 {
+	trace_ptep_modify_prot_commit(mm, addr, ptep, pte);
 	if (sizeof(pteval_t) > sizeof(long))
 		/* 5 arg words */
 		pv_mmu_ops.ptep_modify_prot_commit(mm, addr, ptep, pte);
@@ -557,6 +650,7 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm, unsigned long a
 
 static inline void set_pte(pte_t *ptep, pte_t pte)
 {
+	trace_set_pte(ptep, pte);
 	if (sizeof(pteval_t) > sizeof(long))
 		PVOP_VCALL3(pv_mmu_ops.set_pte, ptep,
 			    pte.pte, (u64)pte.pte >> 32);
@@ -568,6 +662,7 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
+	trace_set_pte_at(mm, addr, ptep, pte);
 	if (sizeof(pteval_t) > sizeof(long))
 		/* 5 arg words */
 		pv_mmu_ops.set_pte_at(mm, addr, ptep, pte);
@@ -579,6 +674,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
 	pmdval_t val = native_pmd_val(pmd);
 
+	trace_set_pmd(pmdp, pmd);
 	if (sizeof(pmdval_t) > sizeof(long))
 		PVOP_VCALL3(pv_mmu_ops.set_pmd, pmdp, val, (u64)val >> 32);
 	else
@@ -596,11 +692,11 @@ static inline pmd_t __pmd(pmdval_t val)
 	else
 		ret = PVOP_CALLEE1(pmdval_t, pv_mmu_ops.make_pmd,
 				   val);
-
+	trace_make_pmd(val, ret);
 	return (pmd_t) { ret };
 }
 
-static inline pmdval_t pmd_val(pmd_t pmd)
+static inline pmdval_t pmd_val_notrace(pmd_t pmd)
 {
 	pmdval_t ret;
 
@@ -610,7 +706,13 @@ static inline pmdval_t pmd_val(pmd_t pmd)
 	else
 		ret =  PVOP_CALLEE1(pmdval_t, pv_mmu_ops.pmd_val,
 				    pmd.pmd);
+	return ret;
+}
 
+static inline pmdval_t pmd_val(pmd_t pmd)
+{
+	pmdval_t ret = pmd_val_notrace(pmd);
+	trace_pmd_val(pmd, ret);
 	return ret;
 }
 
@@ -618,6 +720,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 {
 	pudval_t val = native_pud_val(pud);
 
+	trace_set_pud(pudp, pud);
 	if (sizeof(pudval_t) > sizeof(long))
 		PVOP_VCALL3(pv_mmu_ops.set_pud, pudp,
 			    val, (u64)val >> 32);
@@ -636,11 +739,11 @@ static inline pud_t __pud(pudval_t val)
 	else
 		ret = PVOP_CALLEE1(pudval_t, pv_mmu_ops.make_pud,
 				   val);
-
+	trace_make_pud(val, ret);
 	return (pud_t) { ret };
 }
 
-static inline pudval_t pud_val(pud_t pud)
+static inline pudval_t pud_val_notrace(pud_t pud)
 {
 	pudval_t ret;
 
@@ -654,10 +757,18 @@ static inline pudval_t pud_val(pud_t pud)
 	return ret;
 }
 
+static inline pudval_t pud_val(pud_t pud)
+{
+	pudval_t ret = pud_val_notrace(pud);
+	trace_pud_val(pud, ret);
+	return ret;
+}
+
 static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
 	pgdval_t val = native_pgd_val(pgd);
 
+	trace_set_pgd(pgdp, pgd);
 	if (sizeof(pgdval_t) > sizeof(long))
 		PVOP_VCALL3(pv_mmu_ops.set_pgd, pgdp,
 			    val, (u64)val >> 32);
@@ -685,6 +796,7 @@ static inline void pud_clear(pud_t *pudp)
    64-bit pte atomically */
 static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
 {
+	trace_set_pte_atomic(ptep, pte);
 	PVOP_VCALL3(pv_mmu_ops.set_pte_atomic, ptep,
 		    pte.pte, pte.pte >> 32);
 }
@@ -692,11 +804,13 @@ static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
 			     pte_t *ptep)
 {
+	trace_pte_clear(mm, addr, ptep);
 	PVOP_VCALL3(pv_mmu_ops.pte_clear, mm, addr, ptep);
 }
 
 static inline void pmd_clear(pmd_t *pmdp)
 {
+	trace_pmd_clear(pmdp);
 	PVOP_VCALL1(pv_mmu_ops.pmd_clear, pmdp);
 }
 #else  /* !CONFIG_X86_PAE */
@@ -731,11 +845,13 @@ static inline void arch_end_context_switch(struct task_struct *next)
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
 {
+	trace_enter_lazy_mmu(0);
 	PVOP_VCALL0(pv_mmu_ops.lazy_mode.enter);
 }
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
+	trace_leave_lazy_mmu(0);
 	PVOP_VCALL0(pv_mmu_ops.lazy_mode.leave);
 }
 
@@ -744,6 +860,7 @@ void arch_flush_lazy_mmu_mode(void);
 static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 				phys_addr_t phys, pgprot_t flags)
 {
+	trace_set_fixmap(idx, phys, flags);
 	pv_mmu_ops.set_fixmap(idx, phys, flags);
 }
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 145cce7..6e69f04 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -11,6 +11,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_paravirt-trace.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
@@ -24,6 +25,7 @@ CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
+CFLAGS_paravirt-trace.o	:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
@@ -89,7 +91,8 @@ obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
-obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o paravirt-spinlocks.o
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o \
+					paravirt-spinlocks.o paravirt-trace.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
diff --git a/arch/x86/kernel/paravirt-trace.c b/arch/x86/kernel/paravirt-trace.c
new file mode 100644
index 0000000..ca0ef16
--- /dev/null
+++ b/arch/x86/kernel/paravirt-trace.c
@@ -0,0 +1,16 @@
+#include <linux/rcupdate.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#define CREATE_TRACE_POINTS
+#include <asm/paravirt-trace.h>
+
+char paravirt_trace_lazy_mode(void)
+{
+	switch (paravirt_get_lazy_mode()) {
+	case PARAVIRT_LAZY_NONE:	return '-';
+	case PARAVIRT_LAZY_MMU:		return 'm';
+	case PARAVIRT_LAZY_CPU:		return 'c';
+	default:			return '?';
+	}
+}
-- 
1.6.0.6

