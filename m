Return-Path: <linux-kernel-owner+w=401wt.eu-S2992927AbXCIDbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992927AbXCIDbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992928AbXCIDbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:31:18 -0500
Received: from ozlabs.org ([203.10.76.45]:45609 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992927AbXCIDbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:31:17 -0500
Subject: [PATCH 8/9] lguest: Optimize away copy in and out of per-cpu guest
	pages
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1173410611.32234.84.camel@localhost.localdomain>
References: <1173409524.32234.67.camel@localhost.localdomain>
	 <1173409696.32234.69.camel@localhost.localdomain>
	 <1173409939.32234.73.camel@localhost.localdomain>
	 <1173410210.32234.76.camel@localhost.localdomain>
	 <1173410264.32234.78.camel@localhost.localdomain>
	 <1173410348.32234.81.camel@localhost.localdomain>
	 <1173410611.32234.84.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 14:30:00 +1100
Message-Id: <1173411000.32234.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than copy in IDT, GDT and TSS every time, we only need do it
when something has changed (ie. guest IDT/GDT/TSS has changed, or
guest has changed CPU, or CPU has just run another guest).

For the registers, we simply allocate them an entire page and map that
over the stack page in the guest.

This restores context switch speed to be comparable to the old
segment-using lguest.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 8286b7923a5b arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c	Fri Mar 09 13:09:39 2007 +1100
+++ b/arch/i386/lguest/core.c	Fri Mar 09 13:09:48 2007 +1100
@@ -37,6 +37,7 @@ static struct {
 	unsigned short segment;
 } lguest_entry __attribute_used__;
 DEFINE_MUTEX(lguest_lock);
+static DEFINE_PER_CPU(struct lguest *, last_guest);
 
 /* FIXME: Make dynamic. */
 #define MAX_LGUEST_GUESTS 16
@@ -144,10 +145,10 @@ static int emulate_insn(struct lguest *l
 {
 	u8 insn;
 	unsigned int insnlen = 0, in = 0, shift = 0;
-	unsigned long physaddr = guest_pa(lg, lg->regs.eip);
+	unsigned long physaddr = guest_pa(lg, lg->regs->eip);
 
 	/* This only works for addresses in linear mapping... */
-	if (lg->regs.eip < lg->page_offset)
+	if (lg->regs->eip < lg->page_offset)
 		return 0;
 	lhread(lg, &insn, physaddr, 1);
 
@@ -180,11 +181,11 @@ static int emulate_insn(struct lguest *l
 	if (in) {
 		/* Lower bit tells is whether it's a 16 or 32 bit access */
 		if (insn & 0x1)
-			lg->regs.eax = 0xFFFFFFFF;
+			lg->regs->eax = 0xFFFFFFFF;
 		else
-			lg->regs.eax |= (0xFFFF << shift);
-	}
-	lg->regs.eip += insnlen;
+			lg->regs->eax |= (0xFFFF << shift);
+	}
+	lg->regs->eip += insnlen;
 	return 1;
 }
 
@@ -260,36 +261,35 @@ static void run_guest_once(struct lguest
 		     : "memory", "%edx", "%ecx", "%edi", "%esi");
 }
 
-static void copy_in_guest_info(struct lguest_pages *pages,
-			       struct lguest *lg)
-{
-	/* Copy in regs. */
-	pages->regs = lg->regs;
-
-	/* TSS entries for direct traps. */
+static void copy_in_guest_info(struct lguest_pages *pages, struct lguest *lg)
+{
+	if (__get_cpu_var(last_guest) != lg || lg->last_pages != pages) {
+		__get_cpu_var(last_guest) = lg;
+		lg->last_pages = pages;
+		lg->changed = CHANGED_ALL;
+	}
+
+	/* These are pretty cheap, so we do them unconditionally. */
+	pages->state.host_cr3 = __pa(current->mm->pgd);
+	map_hypervisor_in_guest(lg, pages);
 	pages->state.guest_tss.esp1 = lg->esp1;
 	pages->state.guest_tss.ss1 = lg->ss1;
 
-	/* CR3 */
-	pages->state.host_cr3 = __pa(current->mm->pgd);
-
 	/* Copy direct trap entries. */
-	copy_traps(lg, pages->state.guest_idt, lguest_default_idt_entries());
+	if (lg->changed & CHANGED_IDT)
+		copy_traps(lg, pages->state.guest_idt,
+			   lguest_default_idt_entries());
 
 	/* Copy all GDT entries but the TSS. */
-	copy_gdt(lg, pages->state.guest_gdt);
-}
-
-static void copy_out_guest_info(struct lguest *lg,
-				const struct lguest_pages *pages)
-{
-	/* We just want the regs back. */
-	lg->regs = pages->regs;
+	if (lg->changed & CHANGED_GDT)
+		copy_gdt(lg, pages->state.guest_gdt);
+
+	lg->changed = 0;
 }
 
 int run_guest(struct lguest *lg, char *__user user)
 {
-	struct lguest_regs *regs = &lg->regs;
+	struct lguest_regs *regs = lg->regs;
 
 	while (!lg->dead) {
 		unsigned int cr2 = 0; /* Damn gcc */
@@ -327,10 +327,8 @@ int run_guest(struct lguest *lg, char *_
 		set_ts(lg->ts);
 
 		pages = lguest_pages(raw_smp_processor_id());
-		map_hypervisor_in_guest(lg);
 		copy_in_guest_info(pages, lg);
 		run_guest_once(lg, pages);
-		copy_out_guest_info(lg, pages);
 
 		/* Save cr2 now if we page-faulted. */
 		if (regs->trapnum == 14)
diff -r 8286b7923a5b arch/i386/lguest/hypervisor.S
--- a/arch/i386/lguest/hypervisor.S	Fri Mar 09 13:09:39 2007 +1100
+++ b/arch/i386/lguest/hypervisor.S	Fri Mar 09 13:15:43 2007 +1100
@@ -76,6 +76,8 @@ switch_to_guest:
 	/* Figure out where we are, based on stack (at top of regs). */	\
 	movl	%esp, %eax;						\
 	subl	$LGUEST_PAGES_regs, %eax;				\
+	/* Put trap number in %ebx before we switch cr3 and lose it. */ \
+	movl	LGUEST_PAGES_regs_trapnum(%eax), %ebx;			\
 	/* Switch to host page tables (host GDT, IDT and stack are in host   \
 	   mem, so need this first) */					\
 	movl	LGUEST_PAGES_host_cr3(%eax), %edx;			\
@@ -104,23 +106,15 @@ return_to_host:
 
 deliver_to_host:
 	SWITCH_TO_HOST
-decode_idt_and_jmp:
 	/* Decode IDT and jump to hosts' irq handler.  When that does iret, it
 	 * will return to run_guest_once.  This is a feature. */
 	movl	(LGUEST_PAGES_host_idt_desc+2)(%eax), %edx
-	movl	LGUEST_PAGES_regs_trapnum(%eax), %eax
-	leal	(%edx,%eax,8), %eax
+	leal	(%edx,%ebx,8), %eax
 	movzwl	(%eax),%edx
 	movl	4(%eax), %eax
 	xorw	%ax, %ax
 	orl	%eax, %edx
 	jmp	*%edx
-
-/* FIXME: NMI needs something completely different.  Don't SWITCH_TO_HOST. */
-deliver_to_host_with_errcode:
-	SWITCH_TO_HOST
-	pushl	LGUEST_PAGES_regs_errcode(%eax)
-	jmp decode_idt_and_jmp
 
 /* Real hardware interrupts are delivered straight to the host.  Others
    cause us to return to run_guest_once so it can decide what to do.  Note
@@ -154,7 +148,8 @@ default_idt_entries:
 default_idt_entries:
 .text
 	IRQ_STUBS 0 1 return_to_host		/* First two traps */
-	IRQ_STUB 2 deliver_to_host_with_errcode	/* NMI */
+/* FIXME: NMI needs something completely different.  Don't SWITCH_TO_HOST. */
+	IRQ_STUB 2 deliver_to_host		/* NMI */
 	IRQ_STUBS 3 31 return_to_host		/* Rest of traps */
 	IRQ_STUBS 32 127 deliver_to_host	/* Real interrupts */
 	IRQ_STUB 128 return_to_host		/* System call (overridden) */
diff -r 8286b7923a5b arch/i386/lguest/interrupts_and_traps.c
--- a/arch/i386/lguest/interrupts_and_traps.c	Fri Mar 09 13:09:39 2007 +1100
+++ b/arch/i386/lguest/interrupts_and_traps.c	Fri Mar 09 13:09:48 2007 +1100
@@ -25,7 +25,7 @@ static void reflect_trap(struct lguest *
 {
 	u32 __user *gstack;
 	u32 eflags, ss, irq_enable;
-	struct lguest_regs *regs = &lg->regs;
+	struct lguest_regs *regs = lg->regs;
 
 	/* If they want a ring change, we use new stack and push old ss/esp */
 	if ((regs->ss&0x3) != GUEST_DPL) {
@@ -121,11 +121,11 @@ void check_bug_kill(struct lguest *lg)
 void check_bug_kill(struct lguest *lg)
 {
 #ifdef CONFIG_BUG
-	u32 eip = lg->regs.eip - PAGE_OFFSET;
+	u32 eip = lg->regs->eip - PAGE_OFFSET;
 	u16 insn;
 
 	/* This only works for addresses in linear mapping... */
-	if (lg->regs.eip < PAGE_OFFSET)
+	if (lg->regs->eip < PAGE_OFFSET)
 		return;
 	lhread(lg, &insn, eip, sizeof(insn));
 	if (insn == 0x0b0f) {
@@ -219,6 +219,7 @@ void load_guest_idt_entry(struct lguest 
 	if (num == 2 || num == 8 || num == 15 || num == LGUEST_TRAP_ENTRY)
 		return;
 
+	lg->changed |= CHANGED_IDT;
 	if (num < ARRAY_SIZE(lg->idt))
 		set_trap(lg, &lg->idt[num], num, lo, hi);
 	else if (num == SYSCALL_VECTOR)
diff -r 8286b7923a5b arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h	Fri Mar 09 13:09:39 2007 +1100
+++ b/arch/i386/lguest/lg.h	Fri Mar 09 13:09:48 2007 +1100
@@ -118,10 +118,16 @@ struct lguest_pages
 	struct lguest_ro_state state;
 } __attribute__((aligned(PAGE_SIZE)));
 
+#define CHANGED_IDT		1
+#define CHANGED_GDT		2
+#define CHANGED_ALL	        3
+
 /* The private info the thread maintains about the guest. */
 struct lguest
 {
-	struct lguest_regs regs;
+	/* At end of a page shared mapped over lguest_pages in guest.  */
+	unsigned long regs_page;
+	struct lguest_regs *regs;
 	struct lguest_data __user *lguest_data;
 	struct task_struct *tsk;
 	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
@@ -138,6 +144,10 @@ struct lguest
 	u32 esp1;
 	u8 ss1;
 
+	/* Bitmap of what has changed: see CHANGED_* above. */
+	int changed;
+	struct lguest_pages *last_pages;
+
 	/* We keep a small number of these. */
 	u32 pgdidx;
 	struct pgdir pgdirs[4];
@@ -210,7 +220,7 @@ void guest_pagetable_flush_user(struct l
 void guest_pagetable_flush_user(struct lguest *lg);
 void guest_set_pte(struct lguest *lg, unsigned long cr3,
 		   unsigned long vaddr, u32 val);
-void map_hypervisor_in_guest(struct lguest *lg);
+void map_hypervisor_in_guest(struct lguest *lg, struct lguest_pages *pages);
 int demand_page(struct lguest *info, u32 cr2, int write);
 void pin_page(struct lguest *lg, u32 addr);
 
diff -r 8286b7923a5b arch/i386/lguest/lguest_user.c
--- a/arch/i386/lguest/lguest_user.c	Fri Mar 09 13:09:39 2007 +1100
+++ b/arch/i386/lguest/lguest_user.c	Fri Mar 09 13:09:48 2007 +1100
@@ -100,19 +100,28 @@ static int initialize(struct file *file,
 	lg->guestid = i;
 	lg->pfn_limit = args[0];
 	lg->page_offset = args[3];
+	lg->regs_page = get_zeroed_page(GFP_KERNEL);
+	if (!lg->regs_page) {
+		err = -ENOMEM;
+		goto release_guest;
+	}
+	lg->regs = (void *)lg->regs_page + PAGE_SIZE - sizeof(*lg->regs);
 
 	err = init_guest_pagetable(lg, args[1]);
 	if (err)
-		goto release_guest;
+		goto free_regs;
 
-	setup_regs(&lg->regs, args[2]);
+	setup_regs(lg->regs, args[2]);
 	lg->tsk = current;
 	lg->mm = get_task_mm(current);
+	lg->last_pages = NULL;
 	mutex_unlock(&lguest_lock);
 
 	file->private_data = lg;
 	return sizeof(args);
 
+free_regs:
+	free_page(lg->regs_page);
 release_guest:
 	memset(lg, 0, sizeof(*lg));
 unlock:
@@ -160,6 +169,7 @@ static int close(struct inode *inode, st
 	mmput(lg->mm);
 	if (lg->dead != (void *)1)
 		kfree(lg->dead);
+	free_page(lg->regs_page);
 	memset(lg, 0, sizeof(*lg));
 	mutex_unlock(&lguest_lock);
 	return 0;
diff -r 8286b7923a5b arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c	Fri Mar 09 13:09:39 2007 +1100
+++ b/arch/i386/lguest/page_tables.c	Fri Mar 09 13:09:48 2007 +1100
@@ -99,7 +99,7 @@ static u32 get_pte(struct lguest *lg, u3
    swapped.  It'd be nice to have a callback when Linux wants to swap out. */
 
 /* We fault pages in, which allows us to update accessed/dirty bits.
- * Return NULL or the pte page. */
+ * Return true if we got page. */
 static int page_in(struct lguest *lg, u32 vaddr, unsigned flags)
 {
 	u32 gtop, gpte;
@@ -323,13 +323,17 @@ void free_guest_pagetable(struct lguest 
 }
 
 /* Caller must be preempt-safe */
-void map_hypervisor_in_guest(struct lguest *lg)
-{
-	int cpu = smp_processor_id();
+void map_hypervisor_in_guest(struct lguest *lg, struct lguest_pages *pages)
+{
+	u32 *hype_pte_page = __get_cpu_var(hypervisor_pte_pages);
 
 	/* Since hypervisor less that 4MB, we simply mug top pte page. */
 	lg->pgdirs[lg->pgdidx].pgdir[HYPERVISOR_PGD_ENTRY] =
-		(__pa(hypervisor_pte_page(cpu))| _PAGE_KERNEL);
+		(__pa(hype_pte_page) | _PAGE_KERNEL);
+
+	/* Map our regs page over stack page. */
+	hype_pte_page[(unsigned long)pages / PAGE_SIZE % PTES_PER_PAGE]
+		= (__pa(lg->regs_page) | _PAGE_KERNEL);
 }
 
 static void free_hypervisor_pte_pages(void)
diff -r 8286b7923a5b arch/i386/lguest/segments.c
--- a/arch/i386/lguest/segments.c	Fri Mar 09 13:09:39 2007 +1100
+++ b/arch/i386/lguest/segments.c	Fri Mar 09 13:09:48 2007 +1100
@@ -24,15 +24,15 @@ static int ignored_gdt(unsigned int num)
 /* We don't allow removal of CS, DS or SS; it doesn't make sense. */
 static void check_segment_use(struct lguest *lg, unsigned int desc)
 {
-	if (lg->regs.gs / 8 == desc)
-		lg->regs.gs = 0;
-	if (lg->regs.fs / 8 == desc)
-		lg->regs.fs = 0;
-	if (lg->regs.es / 8 == desc)
-		lg->regs.es = 0;
-	if (lg->regs.ds / 8 == desc
-	    || lg->regs.cs / 8 == desc
-	    || lg->regs.ss / 8 == desc)
+	if (lg->regs->gs / 8 == desc)
+		lg->regs->gs = 0;
+	if (lg->regs->fs / 8 == desc)
+		lg->regs->fs = 0;
+	if (lg->regs->es / 8 == desc)
+		lg->regs->es = 0;
+	if (lg->regs->ds / 8 == desc
+	    || lg->regs->cs / 8 == desc
+	    || lg->regs->ss / 8 == desc)
 		kill_guest(lg, "Removed live GDT entry %u", desc);
 }
 
@@ -103,6 +103,7 @@ void load_guest_gdt(struct lguest *lg, u
 
 	lhread(lg, lg->gdt, table, num * sizeof(lg->gdt[0]));
 	fixup_gdt_table(lg);
+	lg->changed |= CHANGED_GDT;
 }
 
 void guest_load_tls(struct lguest *lg, const struct desc_struct __user *gtls)
@@ -111,4 +112,5 @@ void guest_load_tls(struct lguest *lg, c
 
 	lhread(lg, tls, (u32)gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
 	fixup_gdt_table(lg);
+	lg->changed |= CHANGED_GDT;
 }


