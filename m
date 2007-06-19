Return-Path: <linux-kernel-owner+w=401wt.eu-S1763660AbXFSSxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763660AbXFSSxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763005AbXFSSxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:53:14 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:63775 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763170AbXFSSxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:53:12 -0400
Subject: [PATCH RT] Only allow atomic safe consoles to print in atomic
	areas.
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 14:52:32 -0400
Message-Id: <1182279152.15228.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since PREEMPT_RT makes spin_locks schedule, and some consoles (namely
serial) use spin locks in the write method.  This patch creates a new
console flag called CON_ATOMIC which is set by safe consoles that do not
grab spinlocks.

On PREEMPT_RT only safe consoles will write within non atomic operations
(and not in a oops).

Signed-off-by: Steven Rostedt

Index: linux-2.6-rt-test/arch/x86_64/kernel/early_printk.c
===================================================================
--- linux-2.6-rt-test.orig/arch/x86_64/kernel/early_printk.c
+++ linux-2.6-rt-test/arch/x86_64/kernel/early_printk.c
@@ -56,7 +56,7 @@ static void early_vga_write(struct conso
 static struct console early_vga_console = {
 	.name =		"earlyvga",
 	.write =	early_vga_write,
-	.flags =	CON_PRINTBUFFER,
+	.flags =	CON_PRINTBUFFER | CON_ATOMIC,
 	.index =	-1,
 };
 
@@ -152,7 +152,7 @@ static __init void early_serial_init(cha
 static struct console early_serial_console = {
 	.name =		"earlyser",
 	.write =	early_serial_write,
-	.flags =	CON_PRINTBUFFER,
+	.flags =	CON_PRINTBUFFER | CON_ATOMIC,
 	.index =	-1,
 };
 
@@ -193,7 +193,7 @@ static void simnow_write(struct console 
 static struct console simnow_console = {
 	.name =		"simnow",
 	.write =	simnow_write,
-	.flags =	CON_PRINTBUFFER,
+	.flags =	CON_PRINTBUFFER | CON_ATOMIC,
 	.index =	-1,
 };
 
Index: linux-2.6-rt-test/drivers/char/vt.c
===================================================================
--- linux-2.6-rt-test.orig/drivers/char/vt.c
+++ linux-2.6-rt-test/drivers/char/vt.c
@@ -2317,7 +2317,7 @@ static struct console vt_console_driver 
 	.write		= vt_console_print,
 	.device		= vt_console_device,
 	.unblank	= unblank_screen,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER | CON_ATOMIC,
 	.index		= -1,
 };
 #endif
Index: linux-2.6-rt-test/include/linux/console.h
===================================================================
--- linux-2.6-rt-test.orig/include/linux/console.h
+++ linux-2.6-rt-test/include/linux/console.h
@@ -92,6 +92,17 @@ void give_up_console(const struct consw 
 #define CON_ENABLED	(4)
 #define CON_BOOT	(8)
 #define CON_ANYTIME	(16) /* Safe to call when cpu is offline */
+#define CON_ATOMIC	(32) /* Safe to call in PREEMPT_RT atomic */
+
+#ifdef CONFIG_PREEMPT_RT
+# define console_atomic_safe(con)		\
+	(((con)->flags & CON_ATOMIC) ||		\
+	 (!in_atomic() && !irqs_disabled()) ||	\
+	 (system_state != SYSTEM_RUNNING) ||	\
+	 oops_in_progress)
+#else
+# define console_atomic_safe(con) (1)
+#endif
 
 struct console
 {
Index: linux-2.6-rt-test/kernel/printk.c
===================================================================
--- linux-2.6-rt-test.orig/kernel/printk.c
+++ linux-2.6-rt-test/kernel/printk.c
@@ -328,6 +328,7 @@ static void __call_console_drivers(unsig
 	touch_critical_timing();
 	for (con = console_drivers; con; con = con->next) {
 		if ((con->flags & CON_ENABLED) && con->write &&
+				console_atomic_safe(con) &&
 				(cpu_online(raw_smp_processor_id()) ||
 				(con->flags & CON_ANYTIME))) {
 			/*


