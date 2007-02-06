Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbXBFDxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbXBFDxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXBFDxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:53:24 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40354 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752647AbXBFDwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:52:49 -0500
Date: Mon, 5 Feb 2007 19:52:48 -0800
Message-Id: <200702060352.l163qm2Z000733@zach-dev.vmware.com>
Subject: [PATCH 3/11] Profile pc badness
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:52:47.0969 (UTC) FILETIME=[441DED10:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Profile_pc was broken when using paravirtualization because the
assumption the kernel was running at CPL 0 was violated, causing
bad logic to read a random value off the stack.

The only way to be in kernel lock functions is to be in kernel
code, so validate that assumption explicitly by checking the CS
value.  We don't want to be fooled by BIOS / APM segments and
try to read those stacks, so only match KERNEL_CS.

I moved some stuff in segment.h to make it prettier.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 69d0339b9997 arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c	Fri Feb 02 15:55:46 2007 -0800
+++ b/arch/i386/kernel/time.c	Fri Feb 02 16:15:45 2007 -0800
@@ -131,15 +131,13 @@ unsigned long profile_pc(struct pt_regs 
 	unsigned long pc = instruction_pointer(regs);
 
 #ifdef CONFIG_SMP
-	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
+	if (!v8086_mode(regs) && SEGMENT_IS_KERNEL_CODE(regs->xcs) &&
+	    in_lock_functions(pc)) {
 #ifdef CONFIG_FRAME_POINTER
 		return *(unsigned long *)(regs->ebp + 4);
 #else
-		unsigned long *sp;
-		if ((regs->xcs & 3) == 0)
-			sp = (unsigned long *)&regs->esp;
-		else
-			sp = (unsigned long *)regs->esp;
+		unsigned long *sp = (unsigned long *)&regs->esp;
+
 		/* Return address is either directly at stack pointer
 		   or above a saved eflags. Eflags has bits 22-31 zero,
 		   kernel addresses don't. */
diff -r 69d0339b9997 include/asm-i386/ptrace.h
--- a/include/asm-i386/ptrace.h	Fri Feb 02 15:55:46 2007 -0800
+++ b/include/asm-i386/ptrace.h	Fri Feb 02 16:12:37 2007 -0800
@@ -49,6 +49,10 @@ static inline int user_mode_vm(struct pt
 {
 	return ((regs->xcs & SEGMENT_RPL_MASK) | (regs->eflags & VM_MASK)) >= USER_RPL;
 }
+static inline int v8086_mode(struct pt_regs *regs)
+{
+	return (regs->eflags & VM_MASK);
+}
 
 #define instruction_pointer(regs) ((regs)->eip)
 #define regs_return_value(regs) ((regs)->eax)
diff -r 69d0339b9997 include/asm-i386/segment.h
--- a/include/asm-i386/segment.h	Fri Feb 02 15:55:46 2007 -0800
+++ b/include/asm-i386/segment.h	Fri Feb 02 16:08:50 2007 -0800
@@ -83,13 +83,7 @@
  * The GDT has 32 entries
  */
 #define GDT_ENTRIES 32
-
 #define GDT_SIZE (GDT_ENTRIES * 8)
-
-/* Matches __KERNEL_CS and __USER_CS (they must be 2 entries apart) */
-#define SEGMENT_IS_FLAT_CODE(x)  (((x) & 0xec) == GDT_ENTRY_KERNEL_CS * 8)
-/* Matches PNP_CS32 and PNP_CS16 (they must be consecutive) */
-#define SEGMENT_IS_PNP_CODE(x)   (((x) & 0xf4) == GDT_ENTRY_PNPBIOS_BASE * 8)
 
 /* Simple and small GDT entries for booting only */
 
@@ -134,4 +128,17 @@
 #ifndef CONFIG_PARAVIRT
 #define get_kernel_rpl()  0
 #endif
+/*
+ * Matching rules for certain types of segments.
+ */
+
+/* Matches only __KERNEL_CS, ignoring PnP / USER / APM segments */
+#define SEGMENT_IS_KERNEL_CODE(x) (((x) & 0xfc) == GDT_ENTRY_KERNEL_CS * 8)
+
+/* Matches __KERNEL_CS and __USER_CS (they must be 2 entries apart) */
+#define SEGMENT_IS_FLAT_CODE(x)  (((x) & 0xec) == GDT_ENTRY_KERNEL_CS * 8)
+
+/* Matches PNP_CS32 and PNP_CS16 (they must be consecutive) */
+#define SEGMENT_IS_PNP_CODE(x)   (((x) & 0xf4) == GDT_ENTRY_PNPBIOS_BASE * 8)
+
 #endif
