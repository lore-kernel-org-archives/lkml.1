Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYGAXci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYGAXci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbYGAXcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:32:19 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:18264 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133AbYGAXcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:32:17 -0400
Date: Wed, 2 Jul 2008 01:30:30 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] x86: traps_xx: shuffle headers and globals
Message-ID: <20080701233030.GB29903@mailshack.com>
References: <20080701193643.GA29695@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701193643.GA29695@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Wed, 02 Jul 2008 01:32:00 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.59; VDF: 7.0.5.30; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder headers and collect globals in traps_32.c and traps_64.c

Code size and data size are unaffected by the changes. Code
itself is changed due to different ordering of data and bss.
The bss segment changed size due to a change in the packing
of the variables.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |    9 ++----
 arch/x86/kernel/traps_64.c |   63 +++++++++++++++++++++----------------------
 2 files changed, 34 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 9dd2521..7e88fa3 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -62,8 +62,6 @@
 
 #include "mach_traps.h"
 
-int panic_on_unrecovered_nmi;
-
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
 EXPORT_SYMBOL_GPL(used_vectors);
 
@@ -100,8 +98,11 @@ asmlinkage void alignment_check(void);
 asmlinkage void spurious_interrupt_bug(void);
 asmlinkage void machine_check(void);
 
+int panic_on_unrecovered_nmi;
 int kstack_depth_to_print = 24;
 static unsigned int code_bytes = 64;
+static int ignore_nmis;
+static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
@@ -383,8 +384,6 @@ int is_valid_bugaddr(unsigned long ip)
 	return ud2 == 0x0b0f;
 }
 
-static int die_counter;
-
 int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 {
 	unsigned short ss;
@@ -833,8 +832,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	reassert_nmi();
 }
 
-static int ignore_nmis;
-
 notrace __kprobes void do_nmi(struct pt_regs *regs, long error_code)
 {
 	int cpu;
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 46af2d8..934bd0f 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -10,50 +10,50 @@
  * 'Traps.c' handles hardware traps and faults after we have saved some
  * state in 'entry.S'.
  */
-#include <linux/sched.h>
+#include <linux/moduleparam.h>
+#include <linux/interrupt.h>
+#include <linux/kallsyms.h>
+#include <linux/spinlock.h>
+#include <linux/kprobes.h>
+#include <linux/uaccess.h>
+#include <linux/utsname.h>
+#include <linux/kdebug.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ptrace.h>
 #include <linux/string.h>
+#include <linux/unwind.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/ptrace.h>
+#include <linux/kexec.h>
+#include <linux/sched.h>
 #include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/spinlock.h>
-#include <linux/interrupt.h>
-#include <linux/kallsyms.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/nmi.h>
-#include <linux/kprobes.h>
-#include <linux/kexec.h>
-#include <linux/unwind.h>
-#include <linux/uaccess.h>
 #include <linux/bug.h>
-#include <linux/kdebug.h>
-#include <linux/utsname.h>
-
-#include <mach_traps.h>
+#include <linux/nmi.h>
+#include <linux/mm.h>
 
 #if defined(CONFIG_EDAC)
 #include <linux/edac.h>
 #endif
 
-#include <asm/system.h>
-#include <asm/io.h>
-#include <asm/atomic.h>
+#include <asm/stacktrace.h>
+#include <asm/processor.h>
 #include <asm/debugreg.h>
+#include <asm/atomic.h>
+#include <asm/system.h>
+#include <asm/unwind.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
-#include <asm/processor.h>
-#include <asm/unwind.h>
+#include <asm/nmi.h>
 #include <asm/smp.h>
+#include <asm/io.h>
+#include <asm/kmemcheck.h>
 #include <asm/pgalloc.h>
-#include <asm/pda.h>
 #include <asm/proto.h>
-#include <asm/nmi.h>
-#include <asm/stacktrace.h>
-#include <asm/kmemcheck.h>
+#include <asm/pda.h>
+
+#include <mach_traps.h>
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
@@ -73,12 +73,14 @@ asmlinkage void page_fault(void);
 asmlinkage void coprocessor_error(void);
 asmlinkage void simd_coprocessor_error(void);
 asmlinkage void alignment_check(void);
-asmlinkage void machine_check(void);
 asmlinkage void spurious_interrupt_bug(void);
+asmlinkage void machine_check(void);
 
 int panic_on_unrecovered_nmi;
+int kstack_depth_to_print = 12;
 static unsigned int code_bytes = 64;
-static unsigned ignore_nmis;
+static int ignore_nmis;
+static int die_counter;
 
 static inline void conditional_sti(struct pt_regs *regs)
 {
@@ -102,8 +104,6 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	dec_preempt_count();
 }
 
-int kstack_depth_to_print = 12;
-
 void printk_address(unsigned long address, int reliable)
 {
 #ifdef CONFIG_KALLSYMS
@@ -564,7 +564,6 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 
 int __kprobes __die(const char * str, struct pt_regs * regs, long err)
 {
-	static int die_counter;
 	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff,++die_counter);
 #ifdef CONFIG_PREEMPT
 	printk("PREEMPT ");
-- 
1.5.4.3

