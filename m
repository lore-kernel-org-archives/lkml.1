Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbYEXPmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbYEXPmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYEXPlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:41:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:10446 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYEXPlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=RPWQy3mTvttVo/APLIR/j3ynCpXzb4VeNhzPbKT35FY9RPvcYkcpirKjNRH0UtQMpD9XpCYp7f3eSrU65FU3l43/CJtdPezhx94HqHaXAP5Sj6D07FgLbIvvZYFG0nv+gdZWJKO9AFH5Ibc4JkhN+Cp7RyzPG5BfJ5olvgSLeXE=
References: <20080524153630.669797039@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 01/11] x86: nmi - unify die_nmi() interface
Content-Disposition: inline; filename=die-nmi-32-unify
Message-ID: <4838373c.0305560a.43c0.35c8@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By slightly changing 32bit mode die_nmi() we may unify the
interface and make it common for both (32/64bit) modes

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_32.c	2008-05-24 19:22:41.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_32.c	2008-05-24 19:22:47.000000000 +0400
@@ -320,8 +320,6 @@ void touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
-extern void die_nmi(struct pt_regs *, const char *msg);
-
 notrace __kprobes int
 nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
@@ -375,7 +373,8 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 			/*
 			 * die_nmi will return ONLY if NOTIFY_STOP happens..
 			 */
-			die_nmi(regs, "BUG: NMI Watchdog detected LOCKUP");
+			die_nmi("BUG: NMI Watchdog detected LOCKUP",
+				regs, 0);
 	} else {
 		__get_cpu_var(last_irq_sum) = sum;
 		local_set(&__get_cpu_var(alert_counter), 0);
@@ -406,7 +405,7 @@ static int unknown_nmi_panic_callback(st
 	char buf[64];
 
 	sprintf(buf, "NMI received for unknown reason %02x\n", reason);
-	die_nmi(regs, buf);
+	die_nmi(buf, regs, 0);
 	return 0;
 }
 
Index: linux-2.6.git/arch/x86/kernel/traps_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps_32.c	2008-05-24 19:22:41.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/traps_32.c	2008-05-24 19:24:31.000000000 +0400
@@ -755,9 +755,9 @@ unknown_nmi_error(unsigned char reason, 
 
 static DEFINE_SPINLOCK(nmi_print_lock);
 
-void notrace __kprobes die_nmi(struct pt_regs *regs, const char *msg)
+void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
 {
-	if (notify_die(DIE_NMIWATCHDOG, msg, regs, 0, 2, SIGINT) == NOTIFY_STOP)
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
 		return;
 
 	spin_lock(&nmi_print_lock);
@@ -766,10 +766,12 @@ void notrace __kprobes die_nmi(struct pt
 	* to get a message out:
 	*/
 	bust_spinlocks(1);
-	printk(KERN_EMERG "%s", msg);
+	printk(KERN_EMERG "%s", str);
 	printk(" on CPU%d, ip %08lx, registers:\n",
 		smp_processor_id(), regs->ip);
 	show_registers(regs);
+	if (do_panic)
+		panic("Non maskable interrupt");
 	console_silent();
 	spin_unlock(&nmi_print_lock);
 	bust_spinlocks(0);
Index: linux-2.6.git/include/asm-x86/nmi.h
====================================================================
--- linux-2.6.git.orig/include/asm-x86/nmi.h	2008-05-24 19:22:41.000000000 +0400
+++ linux-2.6.git/include/asm-x86/nmi.h	2008-05-24 19:22:47.000000000 +0400
@@ -38,12 +38,12 @@ static inline void unset_nmi_pm_callback
 
 #ifdef CONFIG_X86_64
 extern void default_do_nmi(struct pt_regs *);
-extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern void nmi_watchdog_default(void);
 #else
 #define nmi_watchdog_default() do {} while (0)
 #endif
 
+extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
 extern int unknown_nmi_panic;

-- 
