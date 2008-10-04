Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYJDVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYJDVMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYJDVMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:12:08 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:22002 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbYJDVMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:12:06 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] dumpstack: x86: move die_nmi to dumpstack_32.c
Date: Sat,  4 Oct 2008 23:12:40 +0200
Message-Id: <1223154766-19350-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sat, 04 Oct 2008 23:11:49 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.243; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason die_nmi is still defined in traps.c for
i386, but is found in dumpstack_64.c for x86_64. Move it
to dumpstack_32.c

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_32.c |   36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c        |   37 -------------------------------------
 2 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 7378c0c..fd9b439 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -406,6 +406,42 @@ void die(const char *str, struct pt_regs *regs, long err)
 	oops_end(flags, regs, SIGSEGV);
 }
 
+static DEFINE_SPINLOCK(nmi_print_lock);
+
+void notrace __kprobes
+die_nmi(char *str, struct pt_regs *regs, int do_panic)
+{
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
+
+	spin_lock(&nmi_print_lock);
+	/*
+	* We are in trouble anyway, lets at least try
+	* to get a message out:
+	*/
+	bust_spinlocks(1);
+	printk(KERN_EMERG "%s", str);
+	printk(" on CPU%d, ip %08lx, registers:\n",
+		smp_processor_id(), regs->ip);
+	show_registers(regs);
+	if (do_panic)
+		panic("Non maskable interrupt");
+	console_silent();
+	spin_unlock(&nmi_print_lock);
+	bust_spinlocks(0);
+
+	/*
+	 * If we are in kernel we are probably nested up pretty bad
+	 * and might aswell get out now while we still can:
+	 */
+	if (!user_mode_vm(regs)) {
+		current->thread.trap_no = 2;
+		crash_kexec(regs);
+	}
+
+	do_exit(SIGSEGV);
+}
+
 static int __init kstack_setup(char *s)
 {
 	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 54e08d2..3e825da 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -429,43 +429,6 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 }
 
-#ifdef CONFIG_X86_32
-static DEFINE_SPINLOCK(nmi_print_lock);
-
-void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
-{
-	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	spin_lock(&nmi_print_lock);
-	/*
-	* We are in trouble anyway, lets at least try
-	* to get a message out:
-	*/
-	bust_spinlocks(1);
-	printk(KERN_EMERG "%s", str);
-	printk(" on CPU%d, ip %08lx, registers:\n",
-		smp_processor_id(), regs->ip);
-	show_registers(regs);
-	if (do_panic)
-		panic("Non maskable interrupt");
-	console_silent();
-	spin_unlock(&nmi_print_lock);
-	bust_spinlocks(0);
-
-	/*
-	 * If we are in kernel we are probably nested up pretty bad
-	 * and might aswell get out now while we still can:
-	 */
-	if (!user_mode_vm(regs)) {
-		current->thread.trap_no = 2;
-		crash_kexec(regs);
-	}
-
-	do_exit(SIGSEGV);
-}
-#endif
-
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
-- 
1.5.4.3

