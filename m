Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYIEH6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYIEH6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 03:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYIEH6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 03:58:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:19312 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbYIEH6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 03:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wSxif/dRFPFIqEWg5ccLD5vbUHX4xPv2E9c/MbmDzdr3gnzVaNwudgOVXUAkkVEnnJ
         wJunclRc+LRJWs2oo7fHvGrVzSAM8iXhmSnfRgVHaI3XfdxM5Z9z6RvyZjWvRU+h4Jtf
         2b+K2dHYB10fIuKklewN31bFcvc7jyROI0tTQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: move nonx_setup etc from common.c to init_64.c
Date: Fri,  5 Sep 2008 00:58:28 -0700
Message-Id: <1220601508-16360-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

like 32 bit put it in init_32.c

Signed-off-by: Yinghai <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/common.c |   54 -------------------------------------------
 arch/x86/mm/init_64.c        |   54 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 54 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -847,51 +847,6 @@ struct desc_ptr idt_descr = { 256 * 16 -
 
 char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
 
-unsigned long __supported_pte_mask __read_mostly = ~0UL;
-EXPORT_SYMBOL_GPL(__supported_pte_mask);
-
-static int do_not_nx __cpuinitdata;
-
-/* noexec=on|off
-Control non executable mappings for 64bit processes.
-
-on	Enable(default)
-off	Disable
-*/
-static int __init nonx_setup(char *str)
-{
-	if (!str)
-		return -EINVAL;
-	if (!strncmp(str, "on", 2)) {
-		__supported_pte_mask |= _PAGE_NX;
-		do_not_nx = 0;
-	} else if (!strncmp(str, "off", 3)) {
-		do_not_nx = 1;
-		__supported_pte_mask &= ~_PAGE_NX;
-	}
-	return 0;
-}
-early_param("noexec", nonx_setup);
-
-int force_personality32;
-
-/* noexec32=on|off
-Control non executable heap for 32bit processes.
-To control the stack too use noexec=off
-
-on	PROT_READ does not imply PROT_EXEC for 32bit processes (default)
-off	PROT_READ implies PROT_EXEC
-*/
-static int __init nonx32_setup(char *str)
-{
-	if (!strcmp(str, "on"))
-		force_personality32 &= ~READ_IMPLIES_EXEC;
-	else if (!strcmp(str, "off"))
-		force_personality32 |= READ_IMPLIES_EXEC;
-	return 1;
-}
-__setup("noexec32=", nonx32_setup);
-
 void pda_init(int cpu)
 {
 	struct x8664_pda *pda = cpu_pda(cpu);
@@ -957,15 +912,6 @@ void syscall_init(void)
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
-void __cpuinit check_efer(void)
-{
-	unsigned long efer;
-
-	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || do_not_nx)
-		__supported_pte_mask &= ~_PAGE_NX;
-}
-
 unsigned long kernel_eflags;
 
 /*
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -88,6 +88,60 @@ early_param("gbpages", parse_direct_gbpa
 
 int after_bootmem;
 
+unsigned long __supported_pte_mask __read_mostly = ~0UL;
+EXPORT_SYMBOL_GPL(__supported_pte_mask);
+
+static int do_not_nx __cpuinitdata;
+
+/* noexec=on|off
+Control non executable mappings for 64bit processes.
+
+on	Enable(default)
+off	Disable
+*/
+static int __init nonx_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	if (!strncmp(str, "on", 2)) {
+		__supported_pte_mask |= _PAGE_NX;
+		do_not_nx = 0;
+	} else if (!strncmp(str, "off", 3)) {
+		do_not_nx = 1;
+		__supported_pte_mask &= ~_PAGE_NX;
+	}
+	return 0;
+}
+early_param("noexec", nonx_setup);
+
+void __cpuinit check_efer(void)
+{
+	unsigned long efer;
+
+	rdmsrl(MSR_EFER, efer);
+	if (!(efer & EFER_NX) || do_not_nx)
+		__supported_pte_mask &= ~_PAGE_NX;
+}
+
+int force_personality32;
+
+/* noexec32=on|off
+Control non executable heap for 32bit processes.
+To control the stack too use noexec=off
+
+on	PROT_READ does not imply PROT_EXEC for 32bit processes (default)
+off	PROT_READ implies PROT_EXEC
+*/
+static int __init nonx32_setup(char *str)
+{
+	if (!strcmp(str, "on"))
+		force_personality32 &= ~READ_IMPLIES_EXEC;
+	else if (!strcmp(str, "off"))
+		force_personality32 |= READ_IMPLIES_EXEC;
+	return 1;
+}
+__setup("noexec32=", nonx32_setup);
+
 /*
  * NOTE: This function is marked __ref because it calls __init function
  * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
