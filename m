Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYABMqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYABMqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 07:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYABMq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 07:46:28 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:22356 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbYABMq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 07:46:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vAFsrVbxMeTqEB8ZZVlgtXYy2L/sb1DdqIHrYQCFJzFjH8gDdxgcFtVGLs6qhnGqGNpc19v6FZ9rRemh7ydetzQD1xjtJsqLgatJdlwe5+zAANi2DkcfBsL2n4p6LVWM6p/CFuzgzDDQC2BUVcmtmi9h8mar+5mE5U6Heo3+Uw4=
Subject: [PATCH] x86: begin fault_{32|64}.c unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 04:46:24 -0800
Message-Id: <1199277984.6323.66.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move X86_32 only get_segment_eip to X86_64
Move X86_64 only is_errata93 to X86_32

Change X86_32 loop in is_prefetch to highlight the differences
between them.  Fold the logic from __is_prefetch in as well on
X86_32.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |   97 ++++++++++++++++++++++++++++++-------
 arch/x86/mm/fault_64.c |  124 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 196 insertions(+), 25 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 870b561..300c9d8 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -61,6 +61,7 @@ static inline int notify_page_fault(struct pt_regs *regs)
 #endif
 }
 
+#ifdef CONFIG_X86_32
 /*
  * Return EIP plus the CS segment base.  The segment limit is also
  * adjusted, clamped to the kernel/user address space (whichever is
@@ -135,26 +136,61 @@ static inline unsigned long get_segment_eip(struct pt_regs *regs,
 		*eip_limit = seg_limit;
 	return ip + base;
 }
+#endif
 
 /*
+ * X86_32
  * Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
  * Check that here and ignore it.
+ *
+ * X86_64
+ * Sometimes the CPU reports invalid exceptions on prefetch.
+ * Check that here and ignore it.
+ *
+ * Opcode checker based on code by Richard Brunner
  */
-static int __is_prefetch(struct pt_regs *regs, unsigned long addr)
+static int is_prefetch(struct pt_regs *regs, unsigned long addr,
+		       unsigned long error_code)
 {
-	unsigned long limit;
-	unsigned char *instr = (unsigned char *)get_segment_eip(regs, &limit);
+	unsigned char *instr;
 	int scan_more = 1;
 	int prefetch = 0;
-	int i;
+	unsigned char *max_instr;
+
+#ifdef CONFIG_X86_32
+	unsigned long limit;
+	if (unlikely(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+		     boot_cpu_data.x86 >= 6)) {
+		/* Catch an obscure case of prefetch inside an NX page. */
+		if (nx_enabled && (error_code & PF_INSTR))
+			return 0;
+	} else {
+		return 0;
+	}
+	instr = (unsigned char *)get_segment_eip(regs, &limit);
+#else
+	/* If it was a exec fault ignore */
+	if (error_code & PF_INSTR)
+		return 0;
+	instr = (unsigned char __user *)convert_rip_to_linear(current, regs);
+#endif
+
+	max_instr = instr + 15;
+
+#ifdef CONFIG_X86_64
+	if (user_mode(regs) && instr >= (unsigned char *)TASK_SIZE)
+		return 0;
+#endif
 
-	for (i = 0; scan_more && i < 15; i++) {
+	while (scan_more && instr < max_instr) {
 		unsigned char opcode;
 		unsigned char instr_hi;
 		unsigned char instr_lo;
 
+#ifdef CONFIG_X86_32
 		if (instr > (unsigned char *)limit)
 			break;
+#endif
 		if (probe_kernel_address(instr, opcode))
 			break;
 
@@ -196,8 +232,10 @@ static int __is_prefetch(struct pt_regs *regs, unsigned long addr)
 		case 0x00:
 			/* Prefetch instruction is 0x0F0D or 0x0F18 */
 			scan_more = 0;
+#ifdef CONFIG_X86_32
 			if (instr > (unsigned char *)limit)
 				break;
+#endif
 			if (probe_kernel_address(instr, opcode))
 				break;
 			prefetch = (instr_lo == 0xF) &&
@@ -211,19 +249,6 @@ static int __is_prefetch(struct pt_regs *regs, unsigned long addr)
 	return prefetch;
 }
 
-static inline int is_prefetch(struct pt_regs *regs, unsigned long addr,
-			      unsigned long error_code)
-{
-	if (unlikely(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-		     boot_cpu_data.x86 >= 6)) {
-		/* Catch an obscure case of prefetch inside an NX page. */
-		if (nx_enabled && (error_code & 16))
-			return 0;
-		return __is_prefetch(regs, addr);
-	}
-	return 0;
-}
-
 static noinline void force_sig_info_fault(int si_signo, int si_code,
 	unsigned long address, struct task_struct *tsk)
 {
@@ -274,6 +299,42 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 	return pmd_k;
 }
 
+#ifdef CONFIG_X86_64
+static const char errata93_warning[] =
+KERN_ERR "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
+KERN_ERR "******* Working around it, but it may cause SEGVs or burn power.\n"
+KERN_ERR "******* Please consider a BIOS update.\n"
+KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
+
+/* Workaround for K8 erratum #93 & buggy BIOS.
+   BIOS SMM functions are required to use a specific workaround
+   to avoid corruption of the 64bit RIP register on C stepping K8.
+   A lot of BIOS that didn't get tested properly miss this.
+   The OS sees this as a page fault with the upper 32bits of RIP cleared.
+   Try to work around it here.
+   Note we only handle faults in kernel here. */
+
+static int is_errata93(struct pt_regs *regs, unsigned long address)
+{
+	static int warned;
+	if (address != regs->ip)
+		return 0;
+	if ((address >> 32) != 0)
+		return 0;
+	address |= 0xffffffffUL << 32;
+	if ((address >= (u64)_stext && address <= (u64)_etext) ||
+	    (address >= MODULES_VADDR && address <= MODULES_END)) {
+		if (!warned) {
+			printk(errata93_warning);
+			warned = 1;
+		}
+		regs->ip = address;
+		return 1;
+	}
+	return 0;
+}
+#endif
+
 /*
  * Handle a fault on the vmalloc or module mapping area
  *
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 7e98a76..dd41793 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -64,32 +64,136 @@ static inline int notify_page_fault(struct pt_regs *regs)
 #endif
 }
 
-/* Sometimes the CPU reports invalid exceptions on prefetch.
-   Check that here and ignore.
-   Opcode checker based on code by Richard Brunner */
-static noinline int is_prefetch(struct pt_regs *regs, unsigned long addr,
-				unsigned long error_code)
+#ifdef CONFIG_X86_32
+/*
+ * Return EIP plus the CS segment base.  The segment limit is also
+ * adjusted, clamped to the kernel/user address space (whichever is
+ * appropriate), and returned in *eip_limit.
+ *
+ * The segment is checked, because it might have been changed by another
+ * task between the original faulting instruction and here.
+ *
+ * If CS is no longer a valid code segment, or if EIP is beyond the
+ * limit, or if it is a kernel address when CS is not a kernel segment,
+ * then the returned value will be greater than *eip_limit.
+ *
+ * This is slow, but is very rarely executed.
+ */
+static inline unsigned long get_segment_eip(struct pt_regs *regs,
+					    unsigned long *eip_limit)
+{
+	unsigned long ip = regs->ip;
+	unsigned seg = regs->cs & 0xffff;
+	u32 seg_ar, seg_limit, base, *desc;
+
+	/* Unlikely, but must come before segment checks. */
+	if (unlikely(regs->flags & VM_MASK)) {
+		base = seg << 4;
+		*eip_limit = base + 0xffff;
+		return base + (ip & 0xffff);
+	}
+
+	/* The standard kernel/user address space limit. */
+	*eip_limit = user_mode(regs) ? USER_DS.seg : KERNEL_DS.seg;
+
+	/* By far the most common cases. */
+	if (likely(SEGMENT_IS_FLAT_CODE(seg)))
+		return ip;
+
+	/* Check the segment exists, is within the current LDT/GDT size,
+	   that kernel/user (ring 0..3) has the appropriate privilege,
+	   that it's a code segment, and get the limit. */
+	__asm__ ("larl %3,%0; lsll %3,%1"
+		 : "=&r" (seg_ar), "=r" (seg_limit) : "0" (0), "rm" (seg));
+	if ((~seg_ar & 0x9800) || ip > seg_limit) {
+		*eip_limit = 0;
+		return 1;	 /* So that returned ip > *eip_limit. */
+	}
+
+	/* Get the GDT/LDT descriptor base.
+	   When you look for races in this code remember that
+	   LDT and other horrors are only used in user space. */
+	if (seg & (1<<2)) {
+		/* Must lock the LDT while reading it. */
+		mutex_lock(&current->mm->context.lock);
+		desc = current->mm->context.ldt;
+		desc = (void *)desc + (seg & ~7);
+	} else {
+		/* Must disable preemption while reading the GDT. */
+		desc = (u32 *)get_cpu_gdt_table(get_cpu());
+		desc = (void *)desc + (seg & ~7);
+	}
+
+	/* Decode the code segment base from the descriptor */
+	base = get_desc_base((struct desc_struct *)desc);
+
+	if (seg & (1<<2))
+		mutex_unlock(&current->mm->context.lock);
+	else
+		put_cpu();
+
+	/* Adjust EIP and segment limit, and clamp at the kernel limit.
+	   It's legitimate for segments to wrap at 0xffffffff. */
+	seg_limit += base;
+	if (seg_limit < *eip_limit && seg_limit >= base)
+		*eip_limit = seg_limit;
+	return ip + base;
+}
+#endif
+
+/*
+ * X86_32
+ * Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
+ * Check that here and ignore it.
+ *
+ * X86_64
+ * Sometimes the CPU reports invalid exceptions on prefetch.
+ * Check that here and ignore it.
+ *
+ * Opcode checker based on code by Richard Brunner
+ */
+static int is_prefetch(struct pt_regs *regs, unsigned long addr,
+		       unsigned long error_code)
 {
 	unsigned char *instr;
 	int scan_more = 1;
 	int prefetch = 0;
 	unsigned char *max_instr;
 
+#ifdef CONFIG_X86_32
+	unsigned long limit;
+	if (unlikely(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+		     boot_cpu_data.x86 >= 6)) {
+		/* Catch an obscure case of prefetch inside an NX page. */
+		if (nx_enabled && (error_code & PF_INSTR))
+			return 0;
+	} else {
+		return 0;
+	}
+	instr = (unsigned char *)get_segment_eip(regs, &limit);
+#else
 	/* If it was a exec fault ignore */
 	if (error_code & PF_INSTR)
 		return 0;
-
 	instr = (unsigned char __user *)convert_rip_to_linear(current, regs);
+#endif
+
 	max_instr = instr + 15;
 
+#ifdef CONFIG_X86_64
 	if (user_mode(regs) && instr >= (unsigned char *)TASK_SIZE)
 		return 0;
+#endif
 
 	while (scan_more && instr < max_instr) {
 		unsigned char opcode;
 		unsigned char instr_hi;
 		unsigned char instr_lo;
 
+#ifdef CONFIG_X86_32
+		if (instr > (unsigned char *)limit)
+			break;
+#endif
 		if (probe_kernel_address(instr, opcode))
 			break;
 
@@ -125,12 +229,16 @@ static noinline int is_prefetch(struct pt_regs *regs, unsigned long addr,
 			scan_more = (instr_lo & 0xC) == 0x4;
 			break;
 		case 0xF0:
-			/* 0xF0, 0xF2, and 0xF3 are valid prefixes in all modes. */
+			/* 0xF0, 0xF2, 0xF3 are valid prefixes in all modes. */
 			scan_more = !instr_lo || (instr_lo>>1) == 1;
 			break;
 		case 0x00:
 			/* Prefetch instruction is 0x0F0D or 0x0F18 */
 			scan_more = 0;
+#ifdef CONFIG_X86_32
+			if (instr > (unsigned char *)limit)
+				break;
+#endif
 			if (probe_kernel_address(instr, opcode))
 				break;
 			prefetch = (instr_lo == 0xF) &&
@@ -185,6 +293,7 @@ bad:
 	printk("BAD\n");
 }
 
+#ifdef CONFIG_X86_64
 static const char errata93_warning[] =
 KERN_ERR "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
 KERN_ERR "******* Working around it, but it may cause SEGVs or burn power.\n"
@@ -218,6 +327,7 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 	}
 	return 0;
 }
+#endif
 
 static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 				 unsigned long error_code)
-- 
1.5.4.rc2.1097.gb6e0d



