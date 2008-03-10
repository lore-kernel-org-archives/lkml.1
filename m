Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYCJNKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYCJNKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYCJNKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:10:41 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31039
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931AbYCJNKl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:10:41 -0400
Message-Id: <47D54185.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Mon, 10 Mar 2008 13:11:17 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <markus.t.metzger@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: prevent unconditional writes to DebugCtl MSR
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, enabling (or better, subsequent disabling) of single
stepping would cause a kernel oops on CPUs not having this MSR.

The patch could have been added a conditional to the MSR write in
user_disable_single_step(), but centralizing the updates seems safer
and (looking forward) better manageable.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Markus Metzger <markus.t.metzger@intel.com>

---
 arch/x86/kernel/kprobes.c    |    4 ++--
 arch/x86/kernel/process_32.c |    4 ++--
 arch/x86/kernel/process_64.c |    4 ++--
 arch/x86/kernel/step.c       |    2 +-
 include/asm-x86/processor.h  |    9 +++++++++
 5 files changed, 16 insertions(+), 7 deletions(-)

--- linux-2.6.25-rc5/arch/x86/kernel/kprobes.c	2008-03-10 13:24:10.000000000 +0100
+++ 2.6.25-rc5-x86-debugctlmsr/arch/x86/kernel/kprobes.c	2008-03-06 11:02:51.000000000 +0100
@@ -410,13 +410,13 @@ static void __kprobes set_current_kprobe
 static void __kprobes clear_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
-		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+		update_debugctlmsr(0);
 }
 
 static void __kprobes restore_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
-		wrmsrl(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr);
+		update_debugctlmsr(current->thread.debugctlmsr);
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
--- linux-2.6.25-rc5/arch/x86/kernel/process_32.c	2008-03-10 13:24:10.000000000 +0100
+++ 2.6.25-rc5-x86-debugctlmsr/arch/x86/kernel/process_32.c	2008-03-06 11:02:51.000000000 +0100
@@ -575,12 +575,12 @@ __switch_to_xtra(struct task_struct *pre
 		/* we clear debugctl to make sure DS
 		 * is not in use when we change it */
 		debugctl = 0;
-		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+		update_debugctlmsr(0);
 		wrmsr(MSR_IA32_DS_AREA, next->ds_area_msr, 0);
 	}
 
 	if (next->debugctlmsr != debugctl)
-		wrmsr(MSR_IA32_DEBUGCTLMSR, next->debugctlmsr, 0);
+		update_debugctlmsr(next->debugctlmsr);
 
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		set_debugreg(next->debugreg0, 0);
--- linux-2.6.25-rc5/arch/x86/kernel/process_64.c	2008-03-10 13:24:10.000000000 +0100
+++ 2.6.25-rc5-x86-debugctlmsr/arch/x86/kernel/process_64.c	2008-03-06 11:02:51.000000000 +0100
@@ -573,12 +573,12 @@ static inline void __switch_to_xtra(stru
 		/* we clear debugctl to make sure DS
 		 * is not in use when we change it */
 		debugctl = 0;
-		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+		update_debugctlmsr(0);
 		wrmsrl(MSR_IA32_DS_AREA, next->ds_area_msr);
 	}
 
 	if (next->debugctlmsr != debugctl)
-		wrmsrl(MSR_IA32_DEBUGCTLMSR, next->debugctlmsr);
+		update_debugctlmsr(next->debugctlmsr);
 
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		loaddebug(next, 0);
--- linux-2.6.25-rc5/arch/x86/kernel/step.c	2008-03-10 13:24:10.000000000 +0100
+++ 2.6.25-rc5-x86-debugctlmsr/arch/x86/kernel/step.c	2008-03-06 11:02:51.000000000 +0100
@@ -145,7 +145,7 @@ static void write_debugctlmsr(struct tas
 	if (child != current)
 		return;
 
-	wrmsrl(MSR_IA32_DEBUGCTLMSR, val);
+	update_debugctlmsr(val);
 }
 
 /*
--- linux-2.6.25-rc5/include/asm-x86/processor.h	2008-03-10 13:24:33.000000000 +0100
+++ 2.6.25-rc5-x86-debugctlmsr/include/asm-x86/processor.h	2008-03-06 11:02:51.000000000 +0100
@@ -662,6 +662,15 @@ extern void switch_to_new_gdt(void);
 extern void cpu_init(void);
 extern void init_gdt(int cpu);
 
+static inline void update_debugctlmsr(unsigned long debugctlmsr)
+{
+#ifndef CONFIG_X86_DEBUGCTLMSR
+	if (boot_cpu_data.x86 < 6)
+		return;
+#endif
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
+}
+
 /* from system description table in BIOS.  Mostly for MCA use, but
  * others may find it useful. */
 extern unsigned int machine_id;



