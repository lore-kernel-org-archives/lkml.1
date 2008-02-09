Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYBIRxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYBIRxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYBIRxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:53:13 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:39916 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbYBIRxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:53:10 -0500
Date: Sat, 9 Feb 2008 19:53:05 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       pq@iki.fi
Subject: [PATCH] x86 mmiotrace: Use percpu instead of arrays.
Message-ID: <20080209195305.0d094a50@daedalus.pq.iki.fi>
In-Reply-To: <47A8D69C.8010505@cosmosbay.com>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
	<20080205222807.7b35ef2b@daedalus.pq.iki.fi>
	<20080205223046.668309be@daedalus.pq.iki.fi>
	<47A8CA97.30008@cosmosbay.com>
	<20080205231452.16cc2f88@daedalus.pq.iki.fi>
	<47A8D69C.8010505@cosmosbay.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/kmmio.c    |   27 +++++++++-------
 arch/x86/mm/mmio-mod.c |   80 +++++++++++++++++++++++++----------------------
 2 files changed, 58 insertions(+), 49 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index e759f7c..5e239d0 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -16,6 +16,7 @@
 #include <linux/uaccess.h>
 #include <linux/ptrace.h>
 #include <linux/preempt.h>
+#include <linux/percpu.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
@@ -49,7 +50,8 @@ static unsigned int handler_registered;
 static struct list_head kmmio_page_table[KMMIO_PAGE_TABLE_SIZE];
 static LIST_HEAD(kmmio_probes);
 
-static struct kmmio_context kmmio_ctx[NR_CPUS];
+/* Accessed per-cpu */
+static DEFINE_PER_CPU(struct kmmio_context, kmmio_ctx);
 
 static struct notifier_block nb_die = {
 	.notifier_call = kmmio_die_notifier
@@ -173,8 +175,7 @@ static void disarm_kmmio_fault_page(unsigned long page, int *page_level)
  */
 static int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 {
-	struct kmmio_context *ctx;
-	int cpu;
+	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
 
 	/*
 	 * Preemption is now disabled to prevent process switch during
@@ -187,8 +188,6 @@ static int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 	 * And that interrupt triggers a kmmio trap?
 	 */
 	preempt_disable();
-	cpu = smp_processor_id();
-	ctx = &kmmio_ctx[cpu];
 
 	/* interrupts disabled and CPU-local data => atomicity guaranteed. */
 	if (ctx->active) {
@@ -199,7 +198,7 @@ static int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 		 */
 		printk(KERN_EMERG "mmiotrace: recursive probe hit on CPU %d, "
 					"for address %lu. Ignoring.\n",
-					cpu, addr);
+					smp_processor_id(), addr);
 		goto no_kmmio;
 	}
 	ctx->active++;
@@ -231,6 +230,7 @@ static int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 	/* We hold lock, now we set present bit in PTE and single step. */
 	disarm_kmmio_fault_page(ctx->fpage->page, NULL);
 
+	put_cpu_var(kmmio_ctx);
 	return 1;
 
 no_kmmio_locked:
@@ -238,6 +238,7 @@ no_kmmio_locked:
 	ctx->active--;
 no_kmmio:
 	preempt_enable_no_resched();
+	put_cpu_var(kmmio_ctx);
 	/* page fault not handled by kmmio */
 	return 0;
 }
@@ -249,11 +250,11 @@ no_kmmio:
  */
 static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 {
-	int cpu = smp_processor_id();
-	struct kmmio_context *ctx = &kmmio_ctx[cpu];
+	int ret = 0;
+	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
 
 	if (!ctx->active)
-		return 0;
+		goto out;
 
 	if (ctx->probe && ctx->probe->post_handler)
 		ctx->probe->post_handler(ctx->probe, condition, regs);
@@ -273,10 +274,12 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	 * will have TF set, in which case, continue the remaining processing
 	 * of do_debug, as if this is not a probe hit.
 	 */
-	if (regs->flags & TF_MASK)
-		return 0;
+	if (!(regs->flags & TF_MASK))
+		ret = 1;
 
-	return 1;
+out:
+	put_cpu_var(kmmio_ctx);
+	return ret;
 }
 
 static int add_kmmio_fault_page(unsigned long page)
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index f492b65..ed62a95 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -30,6 +30,7 @@
 #include <linux/mmiotrace.h>
 #include <asm/e820.h> /* for ISA_START_ADDRESS */
 #include <asm/atomic.h>
+#include <linux/percpu.h>
 
 #include "kmmio.h"
 #include "pf_in.h"
@@ -49,11 +50,11 @@ struct trap_reason {
 };
 
 /* Accessed per-cpu. */
-static struct trap_reason pf_reason[NR_CPUS];
-static struct mm_io_header_rw cpu_trace[NR_CPUS];
+static DEFINE_PER_CPU(struct trap_reason, pf_reason);
+static DEFINE_PER_CPU(struct mm_io_header_rw, cpu_trace);
 
 /* Access to this is not per-cpu. */
-static atomic_t dropped[NR_CPUS];
+static DEFINE_PER_CPU(atomic_t, dropped);
 
 static struct file_operations mmio_fops = {
 	.owner = THIS_MODULE,
@@ -150,15 +151,15 @@ static void print_pte(unsigned long address)
  */
 static void die_kmmio_nesting_error(struct pt_regs *regs, unsigned long addr)
 {
-	const unsigned long cpu = smp_processor_id();
+	const struct trap_reason *my_reason = &get_cpu_var(pf_reason);
 	printk(KERN_EMERG MODULE_NAME ": unexpected fault for address: %lx, "
 					"last fault for address: %lx\n",
-					addr, pf_reason[cpu].addr);
+					addr, my_reason->addr);
 	print_pte(addr);
 #ifdef __i386__
 	print_symbol(KERN_EMERG "faulting EIP is at %s\n", regs->ip);
 	print_symbol(KERN_EMERG "last faulting EIP was at %s\n",
-							pf_reason[cpu].ip);
+							my_reason->ip);
 	printk(KERN_EMERG
 			"eax: %08lx   ebx: %08lx   ecx: %08lx   edx: %08lx\n",
 			regs->ax, regs->bx, regs->cx, regs->dx);
@@ -168,100 +169,105 @@ static void die_kmmio_nesting_error(struct pt_regs *regs, unsigned long addr)
 #else
 	print_symbol(KERN_EMERG "faulting RIP is at %s\n", regs->ip);
 	print_symbol(KERN_EMERG "last faulting RIP was at %s\n",
-							pf_reason[cpu].ip);
+							my_reason->ip);
 	printk(KERN_EMERG "rax: %016lx   rcx: %016lx   rdx: %016lx\n",
 					regs->ax, regs->cx, regs->dx);
 	printk(KERN_EMERG "rsi: %016lx   rdi: %016lx   "
 				"rbp: %016lx   rsp: %016lx\n",
 				regs->si, regs->di, regs->bp, regs->sp);
 #endif
+	put_cpu_var(pf_reason);
 	BUG();
 }
 
 static void pre(struct kmmio_probe *p, struct pt_regs *regs,
 						unsigned long addr)
 {
-	const unsigned long cpu = smp_processor_id();
+	struct trap_reason *my_reason = &get_cpu_var(pf_reason);
+	struct mm_io_header_rw *my_trace = &get_cpu_var(cpu_trace);
 	const unsigned long instptr = instruction_pointer(regs);
 	const enum reason_type type = get_ins_type(instptr);
 
 	/* it doesn't make sense to have more than one active trace per cpu */
-	if (pf_reason[cpu].active_traces)
+	if (my_reason->active_traces)
 		die_kmmio_nesting_error(regs, addr);
 	else
-		pf_reason[cpu].active_traces++;
+		my_reason->active_traces++;
 
-	pf_reason[cpu].type = type;
-	pf_reason[cpu].addr = addr;
-	pf_reason[cpu].ip = instptr;
+	my_reason->type = type;
+	my_reason->addr = addr;
+	my_reason->ip = instptr;
 
-	cpu_trace[cpu].header.type = MMIO_MAGIC;
-	cpu_trace[cpu].header.pid = 0;
-	cpu_trace[cpu].header.data_len = sizeof(struct mm_io_rw);
-	cpu_trace[cpu].rw.address = addr;
+	my_trace->header.type = MMIO_MAGIC;
+	my_trace->header.pid = 0;
+	my_trace->header.data_len = sizeof(struct mm_io_rw);
+	my_trace->rw.address = addr;
 
 	/*
 	 * Only record the program counter when requested.
 	 * It may taint clean-room reverse engineering.
 	 */
 	if (trace_pc)
-		cpu_trace[cpu].rw.pc = instptr;
+		my_trace->rw.pc = instptr;
 	else
-		cpu_trace[cpu].rw.pc = 0;
+		my_trace->rw.pc = 0;
 
-	record_timestamp(&cpu_trace[cpu].header);
+	record_timestamp(&my_trace->header);
 
 	switch (type) {
 	case REG_READ:
-		cpu_trace[cpu].header.type |=
+		my_trace->header.type |=
 			(MMIO_READ << MMIO_OPCODE_SHIFT) |
 			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
 		break;
 	case REG_WRITE:
-		cpu_trace[cpu].header.type |=
+		my_trace->header.type |=
 			(MMIO_WRITE << MMIO_OPCODE_SHIFT) |
 			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
-		cpu_trace[cpu].rw.value = get_ins_reg_val(instptr, regs);
+		my_trace->rw.value = get_ins_reg_val(instptr, regs);
 		break;
 	case IMM_WRITE:
-		cpu_trace[cpu].header.type |=
+		my_trace->header.type |=
 			(MMIO_WRITE << MMIO_OPCODE_SHIFT) |
 			(get_ins_mem_width(instptr) << MMIO_WIDTH_SHIFT);
-		cpu_trace[cpu].rw.value = get_ins_imm_val(instptr);
+		my_trace->rw.value = get_ins_imm_val(instptr);
 		break;
 	default:
 		{
 			unsigned char *ip = (unsigned char *)instptr;
-			cpu_trace[cpu].header.type |=
+			my_trace->header.type |=
 					(MMIO_UNKNOWN_OP << MMIO_OPCODE_SHIFT);
-			cpu_trace[cpu].rw.value = (*ip) << 16 |
-							*(ip + 1) << 8 |
-							*(ip + 2);
+			my_trace->rw.value = (*ip) << 16 | *(ip + 1) << 8 |
+								*(ip + 2);
 		}
 	}
+	put_cpu_var(cpu_trace);
+	put_cpu_var(pf_reason);
 }
 
 static void post(struct kmmio_probe *p, unsigned long condition,
 							struct pt_regs *regs)
 {
-	const unsigned long cpu = smp_processor_id();
+	struct trap_reason *my_reason = &get_cpu_var(pf_reason);
+	struct mm_io_header_rw *my_trace = &get_cpu_var(cpu_trace);
 
 	/* this should always return the active_trace count to 0 */
-	pf_reason[cpu].active_traces--;
-	if (pf_reason[cpu].active_traces) {
+	my_reason->active_traces--;
+	if (my_reason->active_traces) {
 		printk(KERN_EMERG MODULE_NAME ": unexpected post handler");
 		BUG();
 	}
 
-	switch (pf_reason[cpu].type) {
+	switch (my_reason->type) {
 	case REG_READ:
-		cpu_trace[cpu].rw.value = get_ins_reg_val(pf_reason[cpu].ip,
-									regs);
+		my_trace->rw.value = get_ins_reg_val(my_reason->ip, regs);
 		break;
 	default:
 		break;
 	}
-	relay_write(chan, &cpu_trace[cpu], sizeof(struct mm_io_header_rw));
+	relay_write(chan, my_trace, sizeof(*my_trace));
+	put_cpu_var(cpu_trace);
+	put_cpu_var(pf_reason);
 }
 
 /*
@@ -274,7 +280,7 @@ static int subbuf_start_handler(struct rchan_buf *buf, void *subbuf,
 					void *prev_subbuf, size_t prev_padding)
 {
 	unsigned int cpu = buf->cpu;
-	atomic_t *drop = &dropped[cpu];
+	atomic_t *drop = &per_cpu(dropped, cpu);
 	int count;
 	if (relay_buf_full(buf)) {
 		if (atomic_inc_return(drop) == 1) {
-- 
1.5.3.7

