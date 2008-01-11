Return-Path: <linux-kernel-owner+w=401wt.eu-S1762482AbYAKW3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762482AbYAKW3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbYAKW3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:29:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:4876 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbYAKW3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:29:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EG9FuyiWGj+wXd54cowZUiKLrRKg+DfAZ2krJyFPknAvofKC9Cf6PM2O2c8RCEBTMeJwECn3aWxoKA4V09p31ksgny0YPQuFoZdGphvsoCfRzdGiOesmv1Rxjz31XMs40oDhgs7zpQvNcmXXv4GYF0egVHELfIikZHICnxWOIHc=
Subject: [PATCH-RFC] x86: Remove last user of get_segment_eip
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 14:29:07 -0800
Message-Id: <1200090547.19760.61.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, this probably shouldn't be applied without someone
with a much deeper understanding having a look.  I think
I've properly understood how the segment limits were being
set/returned, but I am _not_ sure that probe_kernel_address()
will catch all the same cases, so I could be on crack here.

is_prefetch was the last user of get_segment_eip and only on
X86_32.  This function returned the faulting instruction's
address and set the upper segment limit.

Instead, use the convert_ip_to_linear helper and rely on
probe_kernel_address to do the segment checks which was
already done everywhere the segment limit was being checked
on X86_32.

Remove get_segment_eip as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/step.c   |   84 ----------------------------------------------
 arch/x86/mm/fault_32.c   |   15 +-------
 arch/x86/mm/fault_64.c   |   15 +-------
 include/asm-x86/ptrace.h |    6 ++-
 4 files changed, 8 insertions(+), 112 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 923aee6..6685c7a 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -5,90 +5,6 @@
 #include <linux/mm.h>
 #include <linux/ptrace.h>
 
-#ifdef CONFIG_X86_32
-#include <linux/uaccess.h>
-
-#include <asm/desc.h>
-
-/*
- * Return EIP plus the CS segment base.  The segment limit is also
- * adjusted, clamped to the kernel/user address space (whichever is
- * appropriate), and returned in *eip_limit.
- *
- * The segment is checked, because it might have been changed by another
- * task between the original faulting instruction and here.
- *
- * If CS is no longer a valid code segment, or if EIP is beyond the
- * limit, or if it is a kernel address when CS is not a kernel segment,
- * then the returned value will be greater than *eip_limit.
- *
- * This is slow, but is very rarely executed.
- */
-unsigned long get_segment_eip(struct pt_regs *regs,
-					    unsigned long *eip_limit)
-{
-	unsigned long ip = regs->ip;
-	unsigned seg = regs->cs & 0xffff;
-	u32 seg_ar, seg_limit, base, *desc;
-
-	/* Unlikely, but must come before segment checks. */
-	if (unlikely(regs->flags & VM_MASK)) {
-		base = seg << 4;
-		*eip_limit = base + 0xffff;
-		return base + (ip & 0xffff);
-	}
-
-	/* The standard kernel/user address space limit. */
-	*eip_limit = user_mode(regs) ? USER_DS.seg : KERNEL_DS.seg;
-
-	/* By far the most common cases. */
-	if (likely(SEGMENT_IS_FLAT_CODE(seg)))
-		return ip;
-
-	/* Check the segment exists, is within the current LDT/GDT size,
-	   that kernel/user (ring 0..3) has the appropriate privilege,
-	   that it's a code segment, and get the limit. */
-	__asm__("larl %3,%0; lsll %3,%1"
-		 : "=&r" (seg_ar), "=r" (seg_limit) : "0" (0), "rm" (seg));
-	if ((~seg_ar & 0x9800) || ip > seg_limit) {
-		*eip_limit = 0;
-		return 1;	 /* So that returned ip > *eip_limit. */
-	}
-
-	/* Get the GDT/LDT descriptor base.
-	   When you look for races in this code remember that
-	   LDT and other horrors are only used in user space. */
-	if (seg & (1<<2)) {
-		/* Must lock the LDT while reading it. */
-		mutex_lock(&current->mm->context.lock);
-		desc = current->mm->context.ldt;
-		desc = (void *)desc + (seg & ~7);
-	} else {
-		/* Must disable preemption while reading the GDT. */
-		desc = (u32 *)get_cpu_gdt_table(get_cpu());
-		desc = (void *)desc + (seg & ~7);
-	}
-
-	/* Decode the code segment base from the descriptor */
-	base = get_desc_base((struct desc_struct *)desc);
-
-	if (seg & (1<<2))
-		mutex_unlock(&current->mm->context.lock);
-	else
-		put_cpu();
-
-	/* Adjust EIP and segment limit, and clamp at the kernel limit.
-	   It's legitimate for segments to wrap at 0xffffffff. */
-	seg_limit += base;
-	if (seg_limit < *eip_limit && seg_limit >= base)
-		*eip_limit = seg_limit;
-	return ip + base;
-}
-#endif
-
-#ifdef CONFIG_X86_32
-static
-#endif
 unsigned long convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs)
 {
 	unsigned long addr, seg;
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index f0bbcab..7bde8a8 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -81,7 +81,6 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	unsigned char *max_instr;
 
 #ifdef CONFIG_X86_32
-	unsigned long limit;
 	if (unlikely(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
 		     boot_cpu_data.x86 >= 6)) {
 		/* Catch an obscure case of prefetch inside an NX page. */
@@ -90,30 +89,23 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	} else {
 		return 0;
 	}
-	instr = (unsigned char *)get_segment_eip(regs, &limit);
 #else
 	/* If it was a exec fault ignore */
 	if (error_code & PF_INSTR)
 		return 0;
-	instr = (unsigned char __user *)convert_ip_to_linear(current, regs);
 #endif
 
+	instr = (unsigned char *)convert_ip_to_linear(current, regs);
 	max_instr = instr + 15;
 
-#ifdef CONFIG_X86_64
 	if (user_mode(regs) && instr >= (unsigned char *)TASK_SIZE)
 		return 0;
-#endif
 
 	while (scan_more && instr < max_instr) {
 		unsigned char opcode;
 		unsigned char instr_hi;
 		unsigned char instr_lo;
 
-#ifdef CONFIG_X86_32
-		if (instr > (unsigned char *)limit)
-			break;
-#endif
 		if (probe_kernel_address(instr, opcode))
 			break;
 
@@ -155,10 +147,7 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 		case 0x00:
 			/* Prefetch instruction is 0x0F0D or 0x0F18 */
 			scan_more = 0;
-#ifdef CONFIG_X86_32
-			if (instr > (unsigned char *)limit)
-				break;
-#endif
+
 			if (probe_kernel_address(instr, opcode))
 				break;
 			prefetch = (instr_lo == 0xF) &&
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 7dedb6b..880ae66 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -84,7 +84,6 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	unsigned char *max_instr;
 
 #ifdef CONFIG_X86_32
-	unsigned long limit;
 	if (unlikely(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
 		     boot_cpu_data.x86 >= 6)) {
 		/* Catch an obscure case of prefetch inside an NX page. */
@@ -93,30 +92,23 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	} else {
 		return 0;
 	}
-	instr = (unsigned char *)get_segment_eip(regs, &limit);
 #else
 	/* If it was a exec fault ignore */
 	if (error_code & PF_INSTR)
 		return 0;
-	instr = (unsigned char __user *)convert_ip_to_linear(current, regs);
 #endif
 
+	instr = (unsigned char *)convert_ip_to_linear(current, regs);
 	max_instr = instr + 15;
 
-#ifdef CONFIG_X86_64
 	if (user_mode(regs) && instr >= (unsigned char *)TASK_SIZE)
 		return 0;
-#endif
 
 	while (scan_more && instr < max_instr) {
 		unsigned char opcode;
 		unsigned char instr_hi;
 		unsigned char instr_lo;
 
-#ifdef CONFIG_X86_32
-		if (instr > (unsigned char *)limit)
-			break;
-#endif
 		if (probe_kernel_address(instr, opcode))
 			break;
 
@@ -158,10 +150,7 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 		case 0x00:
 			/* Prefetch instruction is 0x0F0D or 0x0F18 */
 			scan_more = 0;
-#ifdef CONFIG_X86_32
-			if (instr > (unsigned char *)limit)
-				break;
-#endif
+
 			if (probe_kernel_address(instr, opcode))
 				break;
 			prefetch = (instr_lo == 0xF) &&
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 35c1037..ee4b595 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -70,6 +70,10 @@ struct pt_regs {
 #include <asm/segment.h>
 
 struct task_struct;
+
+extern unsigned long
+convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
+
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code);
 
 /*
@@ -184,8 +188,6 @@ convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
 #ifdef __KERNEL__
 
-unsigned long get_segment_eip(struct pt_regs *regs, unsigned long *eip_limit);
-
 /*
  * These are defined as per linux/ptrace.h, which see.
  */
-- 
1.5.4.rc2.1164.g6451

