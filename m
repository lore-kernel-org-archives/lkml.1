Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbXLXPqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbXLXPqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbXLXPqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:46:43 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:20202 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXLXPql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:46:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nEg/zpy8lHbCE79+CPyd3wro4MDbG1aU348m/PPPVP2eFf3tRORgyJye3b2POyrfWGZ+kzmYzViQDkPahm1vneTOUqk3NeXCFzDUoEHK4ptipVbcS0/NtJTOTYf4Pfqj7WR2+f4GhAVVnU7sMXZvM65S4GavtA4bhrX2uq8Pyvs=
Subject: [PATCH] x86: Cosmetic fixes fault_{32|64}.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Mon, 24 Dec 2007 07:46:47 -0800
Message-Id: <1198511207.6323.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First step towards unifying these files.
- Checkpatch trailing whitespace fixes
- Checkpatch indentation of switch statement fixes
- Checkpatch single statement ifs need no braces fixes
- Checkpatch consistent spacing after comma fixes
- Introduce defines for pagefault error bits from X86_64 and add useful
  comment from X86_32.  Use these defines in X86_32 where obvious.
- Unify comments between 32|64 bit
- Small ifdef movement for CONFIG_KPROBES in notify_page_fault()
- Introduce X86_64 only case statement

No Functional Changes.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |  148 ++++++++++++++++++++++++++---------------------
 arch/x86/mm/fault_64.c |  151 ++++++++++++++++++++++++-----------------------
 2 files changed, 160 insertions(+), 139 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index db8d748..bfb0917 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/i386/mm/fault.c
- *
  *  Copyright (C) 1995  Linus Torvalds
  */
 
@@ -30,11 +28,25 @@
 #include <asm/desc.h>
 #include <asm/segment.h>
 
-extern void die(const char *,struct pt_regs *,long);
+/*
+ * Page fault error code bits
+ *	bit 0 == 0 means no page found, 1 means protection fault
+ *	bit 1 == 0 means read, 1 means write
+ *	bit 2 == 0 means kernel, 1 means user-mode
+ *	bit 3 == 1 means use of reserved bit detected
+ *	bit 4 == 1 means fault was an instruction fetch
+ */
+#define PF_PROT	(1<<0)
+#define PF_WRITE	(1<<1)
+#define PF_USER	(1<<2)
+#define PF_RSVD	(1<<3)
+#define PF_INSTR	(1<<4)
+
+extern void die(const char *, struct pt_regs *, long);
 
-#ifdef CONFIG_KPROBES
 static inline int notify_page_fault(struct pt_regs *regs)
 {
+#ifdef CONFIG_KPROBES
 	int ret = 0;
 
 	/* kprobe_running() needs smp_processor_id() */
@@ -46,13 +58,10 @@ static inline int notify_page_fault(struct pt_regs *regs)
 	}
 
 	return ret;
-}
 #else
-static inline int notify_page_fault(struct pt_regs *regs)
-{
 	return 0;
-}
 #endif
+}
 
 /*
  * Return EIP plus the CS segment base.  The segment limit is also
@@ -65,7 +74,7 @@ static inline int notify_page_fault(struct pt_regs *regs)
  * If CS is no longer a valid code segment, or if EIP is beyond the
  * limit, or if it is a kernel address when CS is not a kernel segment,
  * then the returned value will be greater than *eip_limit.
- * 
+ *
  * This is slow, but is very rarely executed.
  */
 static inline unsigned long get_segment_eip(struct pt_regs *regs,
@@ -84,7 +93,7 @@ static inline unsigned long get_segment_eip(struct pt_regs *regs,
 
 	/* The standard kernel/user address space limit. */
 	*eip_limit = user_mode(regs) ? USER_DS.seg : KERNEL_DS.seg;
-	
+
 	/* By far the most common cases. */
 	if (likely(SEGMENT_IS_FLAT_CODE(seg)))
 		return ip;
@@ -99,7 +108,7 @@ static inline unsigned long get_segment_eip(struct pt_regs *regs,
 		return 1;	 /* So that returned ip > *eip_limit. */
 	}
 
-	/* Get the GDT/LDT descriptor base. 
+	/* Get the GDT/LDT descriptor base.
 	   When you look for races in this code remember that
 	   LDT and other horrors are only used in user space. */
 	if (seg & (1<<2)) {
@@ -109,16 +118,16 @@ static inline unsigned long get_segment_eip(struct pt_regs *regs,
 		desc = (void *)desc + (seg & ~7);
 	} else {
 		/* Must disable preemption while reading the GDT. */
- 		desc = (u32 *)get_cpu_gdt_table(get_cpu());
+		desc = (u32 *)get_cpu_gdt_table(get_cpu());
 		desc = (void *)desc + (seg & ~7);
 	}
 
 	/* Decode the code segment base from the descriptor */
 	base = get_desc_base((struct desc_struct *)desc);
 
-	if (seg & (1<<2)) { 
+	if (seg & (1<<2))
 		mutex_unlock(&current->mm->context.lock);
-	} else
+	else
 		put_cpu();
 
 	/* Adjust EIP and segment limit, and clamp at the kernel limit.
@@ -129,19 +138,19 @@ static inline unsigned long get_segment_eip(struct pt_regs *regs,
 	return ip + base;
 }
 
-/* 
+/*
  * Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
  * Check that here and ignore it.
  */
 static int __is_prefetch(struct pt_regs *regs, unsigned long addr)
-{ 
+{
 	unsigned long limit;
-	unsigned char *instr = (unsigned char *)get_segment_eip (regs, &limit);
+	unsigned char *instr = (unsigned char *)get_segment_eip(regs, &limit);
 	int scan_more = 1;
-	int prefetch = 0; 
+	int prefetch = 0;
 	int i;
 
-	for (i = 0; scan_more && i < 15; i++) { 
+	for (i = 0; scan_more && i < 15; i++) {
 		unsigned char opcode;
 		unsigned char instr_hi;
 		unsigned char instr_lo;
@@ -149,27 +158,43 @@ static int __is_prefetch(struct pt_regs *regs, unsigned long addr)
 		if (instr > (unsigned char *)limit)
 			break;
 		if (probe_kernel_address(instr, opcode))
-			break; 
+			break;
 
-		instr_hi = opcode & 0xf0; 
-		instr_lo = opcode & 0x0f; 
+		instr_hi = opcode & 0xf0;
+		instr_lo = opcode & 0x0f;
 		instr++;
 
-		switch (instr_hi) { 
+		switch (instr_hi) {
 		case 0x20:
 		case 0x30:
-			/* Values 0x26,0x2E,0x36,0x3E are valid x86 prefixes. */
+			/*
+			 * Values 0x26,0x2E,0x36,0x3E are valid x86 prefixes.
+			 * In X86_64 long mode, the CPU will signal invalid
+			 * opcode if some of these prefixes are present so
+			 * X86_64 will never get here anyway
+			 */
 			scan_more = ((instr_lo & 7) == 0x6);
 			break;
-			
+#ifdef CONFIG_X86_64
+		case 0x40:
+			/*
+			 * In AMD64 long mode 0x40..0x4F are valid REX prefixes
+			 * Need to figure out under what instruction mode the
+			 * instruction was issued. Could check the LDT for lm,
+			 * but for now it's good enough to assume that long
+			 * mode only uses well known segments or kernel.
+			 */
+			scan_more = (!user_mode(regs)) || (regs->cs == __USER_CS);
+			break;
+#endif
 		case 0x60:
 			/* 0x64 thru 0x67 are valid prefixes in all modes. */
 			scan_more = (instr_lo & 0xC) == 0x4;
-			break;		
+			break;
 		case 0xF0:
-			/* 0xF0, 0xF2, and 0xF3 are valid prefixes */
+			/* 0xF0, 0xF2, 0xF3 are valid prefixes in all modes. */
 			scan_more = !instr_lo || (instr_lo>>1) == 1;
-			break;			
+			break;
 		case 0x00:
 			/* Prefetch instruction is 0x0F0D or 0x0F18 */
 			scan_more = 0;
@@ -179,11 +204,11 @@ static int __is_prefetch(struct pt_regs *regs, unsigned long addr)
 				break;
 			prefetch = (instr_lo == 0xF) &&
 				(opcode == 0x0D || opcode == 0x18);
-			break;			
+			break;
 		default:
 			scan_more = 0;
 			break;
-		} 
+		}
 	}
 	return prefetch;
 }
@@ -199,7 +224,7 @@ static inline int is_prefetch(struct pt_regs *regs, unsigned long addr,
 		return __is_prefetch(regs, addr);
 	}
 	return 0;
-} 
+}
 
 static noinline void force_sig_info_fault(int si_signo, int si_code,
 	unsigned long address, struct task_struct *tsk)
@@ -284,19 +309,12 @@ int show_unhandled_signals = 1;
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
  * routines.
- *
- * error_code:
- *	bit 0 == 0 means no page found, 1 means protection fault
- *	bit 1 == 0 means read, 1 means write
- *	bit 2 == 0 means kernel, 1 means user-mode
- *	bit 3 == 1 means use of reserved bit detected
- *	bit 4 == 1 means fault was an instruction fetch
  */
 void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	struct task_struct *tsk;
 	struct mm_struct *mm;
-	struct vm_area_struct * vma;
+	struct vm_area_struct *vma;
 	unsigned long address;
 	int write, si_code;
 	int fault;
@@ -307,7 +325,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	trace_hardirqs_fixup();
 
 	/* get the address */
-        address = read_cr2();
+	address = read_cr2();
 
 	tsk = current;
 
@@ -350,7 +368,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	/*
 	 * If we're in an interrupt, have no user context or are running in an
-	 * atomic region then we must not take the fault..
+	 * atomic region then we must not take the fault.
 	 */
 	if (in_atomic() || !mm)
 		goto bad_area_nosemaphore;
@@ -371,7 +389,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 * thus avoiding the deadlock.
 	 */
 	if (!down_read_trylock(&mm->mmap_sem)) {
-		if ((error_code & 4) == 0 &&
+		if ((error_code & PF_USER) == 0 &&
 		    !search_exception_tables(regs->ip))
 			goto bad_area_nosemaphore;
 		down_read(&mm->mmap_sem);
@@ -384,7 +402,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 		goto good_area;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		goto bad_area;
-	if (error_code & 4) {
+	if (error_code & PF_USER) {
 		/*
 		 * Accessing the stack below %sp is always a bug.
 		 * The large cushion allows instructions like enter
@@ -403,19 +421,19 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 good_area:
 	si_code = SEGV_ACCERR;
 	write = 0;
-	switch (error_code & 3) {
-		default:	/* 3: write, present */
-				/* fall through */
-		case 2:		/* write, not present */
-			if (!(vma->vm_flags & VM_WRITE))
-				goto bad_area;
-			write++;
-			break;
-		case 1:		/* read, present */
+	switch (error_code & (PF_PROT|PF_WRITE)) {
+	default:	/* 3: write, present */
+		/* fall through */
+	case PF_WRITE:		/* write, not present */
+		if (!(vma->vm_flags & VM_WRITE))
+			goto bad_area;
+		write++;
+		break;
+	case PF_PROT:		/* read, present */
+		goto bad_area;
+	case 0:			/* read, not present */
+		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
 			goto bad_area;
-		case 0:		/* read, not present */
-			if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
-				goto bad_area;
 	}
 
  survive:
@@ -457,14 +475,14 @@ bad_area:
 
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
-	if (error_code & 4) {
+	if (error_code & PF_USER) {
 		/*
 		 * It's possible to have interrupts off here.
 		 */
 		local_irq_enable();
 
-		/* 
-		 * Valid to do another page fault here because this one came 
+		/*
+		 * Valid to do another page fault here because this one came
 		 * from user space.
 		 */
 		if (is_prefetch(regs, address, error_code))
@@ -492,7 +510,7 @@ bad_area_nosemaphore:
 	 */
 	if (boot_cpu_data.f00f_bug) {
 		unsigned long nr;
-		
+
 		nr = (address - idt_descr.address) >> 3;
 
 		if (nr == 6) {
@@ -507,13 +525,13 @@ no_context:
 	if (fixup_exception(regs))
 		return;
 
-	/* 
+	/*
 	 * Valid to do another page fault here, because if this fault
-	 * had been triggered by is_prefetch fixup_exception would have 
+	 * had been triggered by is_prefetch fixup_exception would have
 	 * handled it.
 	 */
- 	if (is_prefetch(regs, address, error_code))
- 		return;
+	if (is_prefetch(regs, address, error_code))
+		return;
 
 /*
  * Oops. The kernel tried to access some bad page. We'll have to
@@ -541,7 +559,7 @@ no_context:
 		else
 			printk(KERN_ALERT "BUG: unable to handle kernel paging"
 					" request");
-		printk(" at virtual address %08lx\n",address);
+		printk(" at virtual address %08lx\n", address);
 		printk(KERN_ALERT "printing ip: %08lx ", regs->ip);
 
 		page = read_cr3();
@@ -605,7 +623,7 @@ do_sigbus:
 	up_read(&mm->mmap_sem);
 
 	/* Kernel mode? Handle exceptions or die */
-	if (!(error_code & 4))
+	if (!(error_code & PF_USER))
 		goto no_context;
 
 	/* User space => ok to do another page fault */
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 3a94941..7e98a76 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/x86-64/mm/fault.c
- *
  *  Copyright (C) 1995  Linus Torvalds
  *  Copyright (C) 2001,2002 Andi Kleen, SuSE Labs.
  */
@@ -33,16 +31,23 @@
 #include <asm/proto.h>
 #include <asm-generic/sections.h>
 
-/* Page fault error code bits */
-#define PF_PROT	(1<<0)		/* or no page found */
+/*
+ * Page fault error code bits
+ *	bit 0 == 0 means no page found, 1 means protection fault
+ *	bit 1 == 0 means read, 1 means write
+ *	bit 2 == 0 means kernel, 1 means user-mode
+ *	bit 3 == 1 means use of reserved bit detected
+ *	bit 4 == 1 means fault was an instruction fetch
+ */
+#define PF_PROT	(1<<0)
 #define PF_WRITE	(1<<1)
 #define PF_USER	(1<<2)
 #define PF_RSVD	(1<<3)
 #define PF_INSTR	(1<<4)
 
-#ifdef CONFIG_KPROBES
 static inline int notify_page_fault(struct pt_regs *regs)
 {
+#ifdef CONFIG_KPROBES
 	int ret = 0;
 
 	/* kprobe_running() needs smp_processor_id() */
@@ -54,75 +59,75 @@ static inline int notify_page_fault(struct pt_regs *regs)
 	}
 
 	return ret;
-}
 #else
-static inline int notify_page_fault(struct pt_regs *regs)
-{
 	return 0;
-}
 #endif
+}
 
 /* Sometimes the CPU reports invalid exceptions on prefetch.
    Check that here and ignore.
    Opcode checker based on code by Richard Brunner */
 static noinline int is_prefetch(struct pt_regs *regs, unsigned long addr,
 				unsigned long error_code)
-{ 
+{
 	unsigned char *instr;
 	int scan_more = 1;
-	int prefetch = 0; 
+	int prefetch = 0;
 	unsigned char *max_instr;
 
 	/* If it was a exec fault ignore */
 	if (error_code & PF_INSTR)
 		return 0;
-	
+
 	instr = (unsigned char __user *)convert_rip_to_linear(current, regs);
 	max_instr = instr + 15;
 
 	if (user_mode(regs) && instr >= (unsigned char *)TASK_SIZE)
 		return 0;
 
-	while (scan_more && instr < max_instr) { 
+	while (scan_more && instr < max_instr) {
 		unsigned char opcode;
 		unsigned char instr_hi;
 		unsigned char instr_lo;
 
 		if (probe_kernel_address(instr, opcode))
-			break; 
+			break;
 
-		instr_hi = opcode & 0xf0; 
-		instr_lo = opcode & 0x0f; 
+		instr_hi = opcode & 0xf0;
+		instr_lo = opcode & 0x0f;
 		instr++;
 
-		switch (instr_hi) { 
+		switch (instr_hi) {
 		case 0x20:
 		case 0x30:
-			/* Values 0x26,0x2E,0x36,0x3E are valid x86
-			   prefixes.  In long mode, the CPU will signal
-			   invalid opcode if some of these prefixes are
-			   present so we will never get here anyway */
+			/*
+			 * Values 0x26,0x2E,0x36,0x3E are valid x86 prefixes.
+			 * In X86_64 long mode, the CPU will signal invalid
+			 * opcode if some of these prefixes are present so
+			 * X86_64 will never get here anyway
+			 */
 			scan_more = ((instr_lo & 7) == 0x6);
 			break;
-			
+#ifdef CONFIG_X86_64
 		case 0x40:
-			/* In AMD64 long mode, 0x40 to 0x4F are valid REX prefixes
-			   Need to figure out under what instruction mode the
-			   instruction was issued ... */
-			/* Could check the LDT for lm, but for now it's good
-			   enough to assume that long mode only uses well known
-			   segments or kernel. */
+			/*
+			 * In AMD64 long mode 0x40..0x4F are valid REX prefixes
+			 * Need to figure out under what instruction mode the
+			 * instruction was issued. Could check the LDT for lm,
+			 * but for now it's good enough to assume that long
+			 * mode only uses well known segments or kernel.
+			 */
 			scan_more = (!user_mode(regs)) || (regs->cs == __USER_CS);
 			break;
-			
+#endif
 		case 0x60:
 			/* 0x64 thru 0x67 are valid prefixes in all modes. */
 			scan_more = (instr_lo & 0xC) == 0x4;
-			break;		
+			break;
 		case 0xF0:
 			/* 0xF0, 0xF2, and 0xF3 are valid prefixes in all modes. */
 			scan_more = !instr_lo || (instr_lo>>1) == 1;
-			break;			
+			break;
 		case 0x00:
 			/* Prefetch instruction is 0x0F0D or 0x0F18 */
 			scan_more = 0;
@@ -130,20 +135,20 @@ static noinline int is_prefetch(struct pt_regs *regs, unsigned long addr,
 				break;
 			prefetch = (instr_lo == 0xF) &&
 				(opcode == 0x0D || opcode == 0x18);
-			break;			
+			break;
 		default:
 			scan_more = 0;
 			break;
-		} 
+		}
 	}
 	return prefetch;
 }
 
-static int bad_address(void *p) 
-{ 
+static int bad_address(void *p)
+{
 	unsigned long dummy;
 	return probe_kernel_address((unsigned long *)p, dummy);
-} 
+}
 
 void dump_pagetable(unsigned long address)
 {
@@ -154,11 +159,11 @@ void dump_pagetable(unsigned long address)
 
 	pgd = (pgd_t *)read_cr3();
 
-	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK); 
+	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK);
 	pgd += pgd_index(address);
 	if (bad_address(pgd)) goto bad;
 	printk("PGD %lx ", pgd_val(*pgd));
-	if (!pgd_present(*pgd)) goto ret; 
+	if (!pgd_present(*pgd)) goto ret;
 
 	pud = pud_offset(pgd, address);
 	if (bad_address(pud)) goto bad;
@@ -172,7 +177,7 @@ void dump_pagetable(unsigned long address)
 
 	pte = pte_offset_kernel(pmd, address);
 	if (bad_address(pte)) goto bad;
-	printk("PTE %lx", pte_val(*pte)); 
+	printk("PTE %lx", pte_val(*pte));
 ret:
 	printk("\n");
 	return;
@@ -180,7 +185,7 @@ bad:
 	printk("BAD\n");
 }
 
-static const char errata93_warning[] = 
+static const char errata93_warning[] =
 KERN_ERR "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
 KERN_ERR "******* Working around it, but it may cause SEGVs or burn power.\n"
 KERN_ERR "******* Please consider a BIOS update.\n"
@@ -188,31 +193,31 @@ KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
 
 /* Workaround for K8 erratum #93 & buggy BIOS.
    BIOS SMM functions are required to use a specific workaround
-   to avoid corruption of the 64bit RIP register on C stepping K8. 
-   A lot of BIOS that didn't get tested properly miss this. 
+   to avoid corruption of the 64bit RIP register on C stepping K8.
+   A lot of BIOS that didn't get tested properly miss this.
    The OS sees this as a page fault with the upper 32bits of RIP cleared.
    Try to work around it here.
    Note we only handle faults in kernel here. */
 
-static int is_errata93(struct pt_regs *regs, unsigned long address) 
+static int is_errata93(struct pt_regs *regs, unsigned long address)
 {
 	static int warned;
 	if (address != regs->ip)
 		return 0;
-	if ((address >> 32) != 0) 
+	if ((address >> 32) != 0)
 		return 0;
 	address |= 0xffffffffUL << 32;
-	if ((address >= (u64)_stext && address <= (u64)_etext) || 
-	    (address >= MODULES_VADDR && address <= MODULES_END)) { 
+	if ((address >= (u64)_stext && address <= (u64)_etext) ||
+	    (address >= MODULES_VADDR && address <= MODULES_END)) {
 		if (!warned) {
-			printk(errata93_warning); 		
+			printk(errata93_warning);
 			warned = 1;
 		}
 		regs->ip = address;
 		return 1;
 	}
 	return 0;
-} 
+}
 
 static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 				 unsigned long error_code)
@@ -296,7 +301,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 {
 	struct task_struct *tsk;
 	struct mm_struct *mm;
-	struct vm_area_struct * vma;
+	struct vm_area_struct *vma;
 	unsigned long address;
 	int write, fault;
 	unsigned long flags;
@@ -360,8 +365,8 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		pgtable_bad(address, regs, error_code);
 
 	/*
-	 * If we're in an interrupt or have no user
-	 * context, we must not take the fault..
+	 * If we're in an interrupt, have no user context or are running in an
+	 * atomic region then we must not take the fault.
 	 */
 	if (unlikely(in_atomic() || !mm))
 		goto bad_area_nosemaphore;
@@ -403,7 +408,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		goto good_area;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		goto bad_area;
-	if (error_code & 4) {
+	if (error_code & PF_USER) {
 		/* Allow userspace just enough access below the stack pointer
 		 * to let the 'enter' instruction work.
 		 */
@@ -420,18 +425,18 @@ good_area:
 	info.si_code = SEGV_ACCERR;
 	write = 0;
 	switch (error_code & (PF_PROT|PF_WRITE)) {
-		default:	/* 3: write, present */
-			/* fall through */
-		case PF_WRITE:		/* write, not present */
-			if (!(vma->vm_flags & VM_WRITE))
-				goto bad_area;
-			write++;
-			break;
-		case PF_PROT:		/* read, present */
+	default:	/* 3: write, present */
+		/* fall through */
+	case PF_WRITE:		/* write, not present */
+		if (!(vma->vm_flags & VM_WRITE))
+			goto bad_area;
+		write++;
+		break;
+	case PF_PROT:		/* read, present */
+		goto bad_area;
+	case 0:			/* read, not present */
+		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
 			goto bad_area;
-		case 0:			/* read, not present */
-			if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
-				goto bad_area;
 	}
 
 	/*
@@ -491,7 +496,7 @@ bad_area_nosemaphore:
 					tsk->comm, tsk->pid, address, regs->ip,
 					regs->sp, error_code);
 		}
-       
+
 		tsk->thread.cr2 = address;
 		/* Kernel addresses are always protection faults */
 		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
@@ -505,21 +510,19 @@ bad_area_nosemaphore:
 	}
 
 no_context:
-	
 	/* Are we prepared to handle this kernel fault?  */
-	if (fixup_exception(regs)) {
+	if (fixup_exception(regs))
 		return;
-	}
 
-	/* 
+	/*
 	 * Hall of shame of CPU/BIOS bugs.
 	 */
 
- 	if (is_prefetch(regs, address, error_code))
- 		return;
+	if (is_prefetch(regs, address, error_code))
+		return;
 
 	if (is_errata93(regs, address))
-		return; 
+		return;
 
 /*
  * Oops. The kernel tried to access some bad page. We'll have to
@@ -532,7 +535,7 @@ no_context:
 		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
 	else
 		printk(KERN_ALERT "Unable to handle kernel paging request");
-	printk(" at %016lx RIP: \n" KERN_ALERT,address);
+	printk(" at %016lx RIP: \n" KERN_ALERT, address);
 	printk_address(regs->ip);
 	dump_pagetable(address);
 	tsk->thread.cr2 = address;
@@ -582,7 +585,7 @@ LIST_HEAD(pgd_list);
 
 void vmalloc_sync_all(void)
 {
-	/* Note that races in the updates of insync and start aren't 
+	/* Note that races in the updates of insync and start aren't
 	   problematic:
 	   insync can only get set bits added, and updates to start are only
 	   improving performance (without affecting correctness if undone). */
@@ -614,6 +617,6 @@ void vmalloc_sync_all(void)
 	}
 	/* Check that there is no need to do the same for the modules area. */
 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
-	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) == 
+	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
 				(__START_KERNEL & PGDIR_MASK)));
 }
-- 
1.5.4.rc0.1143.g1a8a



