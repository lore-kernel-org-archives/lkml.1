Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXFWA3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXFWA3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 20:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbXFWA3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 20:29:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:53618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbXFWA3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 20:29:34 -0400
From: Andi Kleen <ak@suse.de>
References: <20070623229.766711000@suse.de>
In-Reply-To: <20070623229.766711000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.22] [3/3] x86_64: Ignore compat mode SYSCALL when IA32_EMULATION is not defined
Message-Id: <20070623002925.EED7414B35@wotan.suse.de>
Date: Sat, 23 Jun 2007 02:29:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Previously a program could switch to a compat mode segment and then
execute SYSCALL and it would jump to an uninitialized MSR and crash
the kernel.

Instead supply a dummy target for this case.

Pointed out by Jan Beulich

Cc: jbeulich@novell.com
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/entry.S   |    7 +++++++
 arch/x86_64/kernel/setup64.c |    3 +++
 2 files changed, 10 insertions(+)

Index: linux/arch/x86_64/kernel/entry.S
===================================================================
--- linux.orig/arch/x86_64/kernel/entry.S
+++ linux/arch/x86_64/kernel/entry.S
@@ -1163,3 +1163,10 @@ ENTRY(call_softirq)
 	ret
 	CFI_ENDPROC
 ENDPROC(call_softirq)
+
+KPROBE_ENTRY(ignore_sysret)
+	CFI_STARTPROC
+	mov $-ENOSYS,%eax
+	sysret
+	CFI_ENDPROC
+ENDPROC(ignore_sysret)
Index: linux/arch/x86_64/kernel/setup64.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup64.c
+++ linux/arch/x86_64/kernel/setup64.c
@@ -150,6 +150,8 @@ void pda_init(int cpu)
 char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ]
 __attribute__((section(".bss.page_aligned")));
 
+extern asmlinkage void ignore_sysret(void);
+
 /* May not be marked __init: used by software suspend */
 void syscall_init(void)
 {
@@ -160,6 +162,7 @@ void syscall_init(void)
 	 */ 
 	wrmsrl(MSR_STAR,  ((u64)__USER32_CS)<<48  | ((u64)__KERNEL_CS)<<32); 
 	wrmsrl(MSR_LSTAR, system_call); 
+	wrmsrl(MSR_CSTAR, ignore_sysret);
 
 #ifdef CONFIG_IA32_EMULATION   		
 	syscall32_cpu_init ();
