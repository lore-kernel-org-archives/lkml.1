Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZF0Fb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZF0Fb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 01:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbZF0Fbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 01:31:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39465 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbZF0Fbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 01:31:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19013.44722.893263.275594@cargo.ozlabs.ibm.com>
Date: Sat, 27 Jun 2009 15:31:30 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 2/2] perf_counter: powerpc: Add callchain support
In-Reply-To: <19013.44646.549261.100582@cargo.ozlabs.ibm.com>
References: <19013.44646.549261.100582@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for tracing callchains for powerpc, both 32-bit
and 64-bit, and both in the kernel and userspace, from PMU interrupt
context.

The first three entries stored for each callchain are the NIP (next
instruction pointer), LR (link register), and the contents of the LR
save area in the second stack frame (the first is ignored because the
ABI convention on powerpc is that functions save their return address
in their caller's stack frame).  Because functions don't have to save
their return address (LR value) and don't have to establish a stack
frame, it's possible for either or both of LR and the second stack
frame's LR save area to have valid return addresses in them.  This
is basically impossible to disambiguate without either reading the
code or looking at auxiliary information such as CFI tables.  Since
we don't want to do that at interrupt time, we store both LR and the
second stack frame's LR save area.

Once we get past the second stack frame, there is no ambiguity; all
return addresses we get are reliable.

For kernel traces, we check whether they are valid kernel instruction
addresses and store zero instead if they are not (rather than
omitting them, which would make it impossible for userspace to know
which was which).  We also store zero instead of the second stack
frame's LR save area value if it is the same as LR.

For kernel traces, we check for interrupt frames, and for user traces,
we check for signal frames.  In each case, since we're starting a new
trace, we store a PERF_CONTEXT_KERNEL/USER marker so that userspace
knows that the next three entries are NIP, LR and the second stack frame
for the interrupted context.

We read user memory with __get_user_inatomic.  On 64-bit, we set a flag
to indicate that the data storage exception handler shouldn't call
hash_page on a MMU hashtable miss.  Instead we get a -EFAULT from
__get_user_inatomic and then read the Linux PTE and access the page
via the kernel linear mapping.  Since 64-bit doesn't use (or need)
highmem there is no need to do kmap_atomic.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/Makefile         |    2 +-
 arch/powerpc/kernel/perf_callchain.c |  544 ++++++++++++++++++++++++++++++++++
 2 files changed, 545 insertions(+), 1 deletions(-)
 create mode 100644 arch/powerpc/kernel/perf_callchain.c

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index b73396b..9619285 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -97,7 +97,7 @@ obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
-obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_counter.o
+obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_counter.o perf_callchain.o
 obj64-$(CONFIG_PPC_PERF_CTRS)	+= power4-pmu.o ppc970-pmu.o power5-pmu.o \
 				   power5+-pmu.o power6-pmu.o power7-pmu.o
 obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
diff --git a/arch/powerpc/kernel/perf_callchain.c b/arch/powerpc/kernel/perf_callchain.c
new file mode 100644
index 0000000..3cc1487
--- /dev/null
+++ b/arch/powerpc/kernel/perf_callchain.c
@@ -0,0 +1,544 @@
+/*
+ * Performance counter callchain support - powerpc architecture code
+ *
+ * Copyright © 2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/perf_counter.h>
+#include <linux/percpu.h>
+#include <linux/uaccess.h>
+#include <linux/mm.h>
+#include <asm/ptrace.h>
+#include <asm/pgtable.h>
+#include <asm/sigcontext.h>
+#include <asm/ucontext.h>
+#include <asm/vdso.h>
+#ifdef CONFIG_PPC64
+#include "ppc32.h"
+#endif
+
+/*
+ * Store another value in a callchain_entry.
+ */
+static inline void callchain_store(struct perf_callchain_entry *entry, u64 ip)
+{
+	unsigned int nr = entry->nr;
+
+	if (nr < PERF_MAX_STACK_DEPTH) {
+		entry->ip[nr] = ip;
+		entry->nr = nr + 1;
+	}
+}
+
+/*
+ * Is sp valid as the address of the next kernel stack frame after prev_sp?
+ * The next frame may be in a different stack area but should not go
+ * back down in the same stack area.
+ */
+static int valid_next_sp(unsigned long sp, unsigned long prev_sp)
+{
+	if (sp & 0xf)
+		return 0;		/* must be 16-byte aligned */
+	if (!validate_sp(sp, current, STACK_FRAME_OVERHEAD))
+		return 0;
+	if (sp >= prev_sp + STACK_FRAME_OVERHEAD)
+		return 1;
+	/*
+	 * sp could decrease when we jump off an interrupt stack
+	 * back to the regular process stack.
+	 */
+	if ((sp & ~(THREAD_SIZE - 1)) != (prev_sp & ~(THREAD_SIZE - 1)))
+		return 1;
+	return 0;
+}
+
+static void perf_callchain_kernel(struct pt_regs *regs,
+				  struct perf_callchain_entry *entry)
+{
+	unsigned long sp, next_sp;
+	unsigned long next_ip;
+	unsigned long lr;
+	long level = 0;
+	unsigned long *fp;
+
+	lr = regs->link;
+	sp = regs->gpr[1];
+	callchain_store(entry, PERF_CONTEXT_KERNEL);
+	callchain_store(entry, regs->nip);
+
+	if (!validate_sp(sp, current, STACK_FRAME_OVERHEAD))
+		return;
+
+	for (;;) {
+		fp = (unsigned long *) sp;
+		next_sp = fp[0];
+
+		if (next_sp == sp + STACK_INT_FRAME_SIZE &&
+		    fp[STACK_FRAME_MARKER] == STACK_FRAME_REGS_MARKER) {
+			/*
+			 * This looks like an interrupt frame for an
+			 * interrupt that occurred in the kernel
+			 */
+			regs = (struct pt_regs *)(sp + STACK_FRAME_OVERHEAD);
+			next_ip = regs->nip;
+			lr = regs->link;
+			level = 0;
+			callchain_store(entry, PERF_CONTEXT_KERNEL);
+
+		} else {
+			if (level == 0)
+				next_ip = lr;
+			else
+				next_ip = fp[STACK_FRAME_LR_SAVE];
+
+			/*
+			 * We can't tell which of the first two addresses
+			 * we get are valid, but we can filter out the
+			 * obviously bogus ones here.  We replace them
+			 * with 0 rather than removing them entirely so
+			 * that userspace can tell which is which.
+			 */
+			if ((level == 1 && next_ip == lr) ||
+			    (level <= 1 && !kernel_text_address(next_ip)))
+				next_ip = 0;
+
+			++level;
+		}
+
+		callchain_store(entry, next_ip);
+		if (!valid_next_sp(next_sp, sp))
+			return;
+		sp = next_sp;
+	}
+}
+
+#ifdef CONFIG_PPC64
+/*
+ * On 64-bit we don't want to invoke hash_page on user addresses from
+ * interrupt context, so if the access faults, we read the page tables
+ * to find which page (if any) is mapped and access it directly.
+ */
+static int read_user_stack_slow(void __user *ptr, void *ret, int nb)
+{
+	pgd_t *pgdir;
+	pte_t *ptep, pte;
+	int pagesize;
+	unsigned long addr = (unsigned long) ptr;
+	unsigned long offset;
+	unsigned long pfn;
+	void *kaddr;
+
+	pgdir = current->mm->pgd;
+	if (!pgdir)
+		return -EFAULT;
+
+	pagesize = get_slice_psize(current->mm, addr);
+
+	/* align address to page boundary */
+	offset = addr & ((1ul << mmu_psize_defs[pagesize].shift) - 1);
+	addr -= offset;
+
+	if (HPAGE_SHIFT && mmu_huge_psizes[pagesize])
+		ptep = huge_pte_offset(current->mm, addr);
+	else
+		ptep = find_linux_pte(pgdir, addr);
+
+	if (ptep == NULL)
+		return -EFAULT;
+	pte = *ptep;
+	if (!pte_present(pte) || !(pte_val(pte) & _PAGE_USER))
+		return -EFAULT;
+	pfn = pte_pfn(pte);
+	if (!page_is_ram(pfn))
+		return -EFAULT;
+
+	/* no highmem to worry about here */
+	kaddr = pfn_to_kaddr(pfn);
+	memcpy(ret, kaddr + offset, nb);
+	return 0;
+}
+
+static int read_user_stack_64(unsigned long __user *ptr, unsigned long *ret)
+{
+	int err;
+
+	if ((unsigned long)ptr > TASK_SIZE - sizeof(unsigned long) ||
+	    ((unsigned long)ptr & 7))
+		return -EFAULT;
+
+	/*
+	 * On 64-bit, tell the DSI handler not to call hash_page
+	 * if this access causes a hashtable miss fault.
+	 */
+	get_paca()->in_pmu_nmi = 1;
+	barrier();
+	err = __get_user_inatomic(*ret, ptr);
+	barrier();
+	get_paca()->in_pmu_nmi = 0;
+
+	if (!err)
+		return 0;
+
+	return read_user_stack_slow(ptr, ret, 8);
+}
+
+static int read_user_stack_32(unsigned int __user *ptr, unsigned int *ret)
+{
+	int err;
+
+	if ((unsigned long)ptr > TASK_SIZE - sizeof(unsigned int) ||
+	    ((unsigned long)ptr & 3))
+		return -EFAULT;
+
+	/*
+	 * On 64-bit, tell the DSI handler not to call hash_page
+	 * if this access causes a hashtable miss fault.
+	 */
+	get_paca()->in_pmu_nmi = 1;
+	barrier();
+	err = __get_user_inatomic(*ret, ptr);
+	barrier();
+	get_paca()->in_pmu_nmi = 0;
+
+	if (!err)
+		return 0;
+
+	return read_user_stack_slow(ptr, ret, 4);
+}
+
+static inline int valid_user_sp(unsigned long sp, int is_64)
+{
+	if (!sp || (sp & 7) || sp > (is_64 ? TASK_SIZE : 0x100000000UL) - 32)
+		return 0;
+	return 1;
+}
+
+/*
+ * 64-bit user processes use the same stack frame for RT and non-RT signals.
+ */
+struct signal_frame_64 {
+	char		dummy[__SIGNAL_FRAMESIZE];
+	struct ucontext	uc;
+	unsigned long	unused[2];
+	unsigned int	tramp[6];
+	struct siginfo	*pinfo;
+	void		*puc;
+	struct siginfo	info;
+	char		abigap[288];
+};
+
+static int is_sigreturn_64_address(unsigned long nip, unsigned long fp)
+{
+	if (nip == fp + offsetof(struct signal_frame_64, tramp))
+		return 1;
+	if (vdso64_rt_sigtramp && current->mm->context.vdso_base &&
+	    nip == current->mm->context.vdso_base + vdso64_rt_sigtramp)
+		return 1;
+	return 0;
+}
+
+/*
+ * Do some sanity checking on the signal frame pointed to by sp.
+ * We check the pinfo and puc pointers in the frame.
+ */
+static int sane_signal_64_frame(unsigned long sp)
+{
+	struct signal_frame_64 __user *sf;
+	unsigned long pinfo, puc;
+
+	sf = (struct signal_frame_64 __user *) sp;
+	if (read_user_stack_64((unsigned long __user *) &sf->pinfo, &pinfo) ||
+	    read_user_stack_64((unsigned long __user *) &sf->puc, &puc))
+		return 0;
+	return pinfo == (unsigned long) &sf->info &&
+		puc == (unsigned long) &sf->uc;
+}
+
+static void perf_callchain_user_64(struct pt_regs *regs,
+				   struct perf_callchain_entry *entry)
+{
+	unsigned long sp, next_sp;
+	unsigned long next_ip;
+	unsigned long lr;
+	long level = 0;
+	struct signal_frame_64 __user *sigframe;
+	unsigned long __user *fp, *uregs;
+
+	next_ip = regs->nip;
+	lr = regs->link;
+	sp = regs->gpr[1];
+	callchain_store(entry, PERF_CONTEXT_USER);
+	callchain_store(entry, next_ip);
+
+	for (;;) {
+		fp = (unsigned long __user *) sp;
+		if (!valid_user_sp(sp, 1) || read_user_stack_64(fp, &next_sp))
+			return;
+		if (level > 0 && read_user_stack_64(&fp[2], &next_ip))
+			return;
+
+		/*
+		 * Note: the next_sp - sp >= signal frame size check
+		 * is true when next_sp < sp, which can happen when
+		 * transitioning from an alternate signal stack to the
+		 * normal stack.
+		 */
+		if (next_sp - sp >= sizeof(struct signal_frame_64) &&
+		    (is_sigreturn_64_address(next_ip, sp) ||
+		     (level <= 1 && is_sigreturn_64_address(lr, sp))) &&
+		    sane_signal_64_frame(sp)) {
+			/*
+			 * This looks like an signal frame
+			 */
+			sigframe = (struct signal_frame_64 __user *) sp;
+			uregs = sigframe->uc.uc_mcontext.gp_regs;
+			if (read_user_stack_64(&uregs[PT_NIP], &next_ip) ||
+			    read_user_stack_64(&uregs[PT_LNK], &lr) ||
+			    read_user_stack_64(&uregs[PT_R1], &sp))
+				return;
+			level = 0;
+			callchain_store(entry, PERF_CONTEXT_USER);
+			callchain_store(entry, next_ip);
+			continue;
+		}
+
+		if (level == 0)
+			next_ip = lr;
+		callchain_store(entry, next_ip);
+		++level;
+		sp = next_sp;
+	}
+}
+
+static inline int current_is_64bit(void)
+{
+	/*
+	 * We can't use test_thread_flag() here because we may be on an
+	 * interrupt stack, and the thread flags don't get copied over
+	 * from the thread_info on the main stack to the interrupt stack.
+	 */
+	return !test_ti_thread_flag(task_thread_info(current), TIF_32BIT);
+}
+
+#else  /* CONFIG_PPC64 */
+/*
+ * On 32-bit we just access the address and let hash_page create a
+ * HPTE if necessary, so there is no need to fall back to reading
+ * the page tables.  Since this is called at interrupt level,
+ * do_page_fault() won't treat a DSI as a page fault.
+ */
+static int read_user_stack_32(unsigned int __user *ptr, unsigned int *ret)
+{
+	if ((unsigned long)ptr > TASK_SIZE - sizeof(unsigned int) ||
+	    ((unsigned long)ptr & 3))
+		return -EFAULT;
+
+	return __get_user_inatomic(*ret, ptr);
+}
+
+static inline void perf_callchain_user_64(struct pt_regs *regs,
+					  struct perf_callchain_entry *entry)
+{
+}
+
+static inline int current_is_64bit(void)
+{
+	return 0;
+}
+
+static inline int valid_user_sp(unsigned long sp, int is_64)
+{
+	if (!sp || (sp & 7) || sp > TASK_SIZE - 32)
+		return 0;
+	return 1;
+}
+
+#define __SIGNAL_FRAMESIZE32	__SIGNAL_FRAMESIZE
+#define sigcontext32		sigcontext
+#define mcontext32		mcontext
+#define ucontext32		ucontext
+#define compat_siginfo_t	struct siginfo
+
+#endif /* CONFIG_PPC64 */
+
+/*
+ * Layout for non-RT signal frames
+ */
+struct signal_frame_32 {
+	char			dummy[__SIGNAL_FRAMESIZE32];
+	struct sigcontext32	sctx;
+	struct mcontext32	mctx;
+	int			abigap[56];
+};
+
+/*
+ * Layout for RT signal frames
+ */
+struct rt_signal_frame_32 {
+	char			dummy[__SIGNAL_FRAMESIZE32 + 16];
+	compat_siginfo_t	info;
+	struct ucontext32	uc;
+	int			abigap[56];
+};
+
+static int is_sigreturn_32_address(unsigned int nip, unsigned int fp)
+{
+	if (nip == fp + offsetof(struct signal_frame_32, mctx.mc_pad))
+		return 1;
+	if (vdso32_sigtramp && current->mm->context.vdso_base &&
+	    nip == current->mm->context.vdso_base + vdso32_sigtramp)
+		return 1;
+	return 0;
+}
+
+static int is_rt_sigreturn_32_address(unsigned int nip, unsigned int fp)
+{
+	if (nip == fp + offsetof(struct rt_signal_frame_32,
+				 uc.uc_mcontext.mc_pad))
+		return 1;
+	if (vdso32_rt_sigtramp && current->mm->context.vdso_base &&
+	    nip == current->mm->context.vdso_base + vdso32_rt_sigtramp)
+		return 1;
+	return 0;
+}
+
+static int sane_signal_32_frame(unsigned int sp)
+{
+	struct signal_frame_32 __user *sf;
+	unsigned int regs;
+
+	sf = (struct signal_frame_32 __user *) (unsigned long) sp;
+	if (read_user_stack_32((unsigned int __user *) &sf->sctx.regs, &regs))
+		return 0;
+	return regs == (unsigned long) &sf->mctx;
+}
+
+static int sane_rt_signal_32_frame(unsigned int sp)
+{
+	struct rt_signal_frame_32 __user *sf;
+	unsigned int regs;
+
+	sf = (struct rt_signal_frame_32 __user *) (unsigned long) sp;
+	if (read_user_stack_32((unsigned int __user *) &sf->uc.uc_regs, &regs))
+		return 0;
+	return regs == (unsigned long) &sf->uc.uc_mcontext;
+}
+
+static unsigned int __user *signal_frame_32_regs(unsigned int sp,
+				unsigned int next_sp, unsigned int next_ip)
+{
+	struct mcontext32 __user *mctx = NULL;
+	struct signal_frame_32 __user *sf;
+	struct rt_signal_frame_32 __user *rt_sf;
+
+	/*
+	 * Note: the next_sp - sp >= signal frame size check
+	 * is true when next_sp < sp, for example, when
+	 * transitioning from an alternate signal stack to the
+	 * normal stack.
+	 */
+	if (next_sp - sp >= sizeof(struct signal_frame_32) &&
+	    is_sigreturn_32_address(next_ip, sp) &&
+	    sane_signal_32_frame(sp)) {
+		sf = (struct signal_frame_32 __user *) (unsigned long) sp;
+		mctx = &sf->mctx;
+	}
+
+	if (!mctx && next_sp - sp >= sizeof(struct rt_signal_frame_32) &&
+	    is_rt_sigreturn_32_address(next_ip, sp) &&
+	    sane_rt_signal_32_frame(sp)) {
+		rt_sf = (struct rt_signal_frame_32 __user *) (unsigned long) sp;
+		mctx = &rt_sf->uc.uc_mcontext;
+	}
+
+	if (!mctx)
+		return NULL;
+	return mctx->mc_gregs;
+}
+
+static void perf_callchain_user_32(struct pt_regs *regs,
+				   struct perf_callchain_entry *entry)
+{
+	unsigned int sp, next_sp;
+	unsigned int next_ip;
+	unsigned int lr;
+	long level = 0;
+	unsigned int __user *fp, *uregs;
+
+	next_ip = regs->nip;
+	lr = regs->link;
+	sp = regs->gpr[1];
+	callchain_store(entry, PERF_CONTEXT_USER);
+	callchain_store(entry, next_ip);
+
+	while (entry->nr < PERF_MAX_STACK_DEPTH) {
+		fp = (unsigned int __user *) (unsigned long) sp;
+		if (!valid_user_sp(sp, 0) || read_user_stack_32(fp, &next_sp))
+			return;
+		if (level > 0 && read_user_stack_32(&fp[1], &next_ip))
+			return;
+
+		uregs = signal_frame_32_regs(sp, next_sp, next_ip);
+		if (!uregs && level <= 1)
+			uregs = signal_frame_32_regs(sp, next_sp, lr);
+		if (uregs) {
+			/*
+			 * This looks like an signal frame, so restart
+			 * the stack trace with the values in it.
+			 */
+			if (read_user_stack_32(&uregs[PT_NIP], &next_ip) ||
+			    read_user_stack_32(&uregs[PT_LNK], &lr) ||
+			    read_user_stack_32(&uregs[PT_R1], &sp))
+				return;
+			level = 0;
+			callchain_store(entry, PERF_CONTEXT_USER);
+			callchain_store(entry, next_ip);
+			continue;
+		}
+
+		if (level == 0)
+			next_ip = lr;
+		callchain_store(entry, next_ip);
+		++level;
+		sp = next_sp;
+	}
+}
+
+/*
+ * Since we can't get PMU interrupts inside a PMU interrupt handler,
+ * we don't need separate irq and nmi entries here.
+ */
+static DEFINE_PER_CPU(struct perf_callchain_entry, callchain);
+
+struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+{
+	struct perf_callchain_entry *entry = &__get_cpu_var(callchain);
+
+	entry->nr = 0;
+
+	if (current->pid == 0)		/* idle task? */
+		return entry;
+
+	if (!user_mode(regs)) {
+		perf_callchain_kernel(regs, entry);
+		if (current->mm)
+			regs = task_pt_regs(current);
+		else
+			regs = NULL;
+	}
+
+	if (regs) {
+		if (current_is_64bit())
+			perf_callchain_user_64(regs, entry);
+		else
+			perf_callchain_user_32(regs, entry);
+	}
+
+	return entry;
+}
-- 
1.6.0.4

