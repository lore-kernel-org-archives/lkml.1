Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbYHDGsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbYHDGsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbYHDGsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:48:32 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48519 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbYHDGsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:48:32 -0400
Message-ID: <51617.166.70.238.45.1217831286.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:28:06 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 2/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/arch/x86/kernel/traps_32.c	2008-08-03 16:09:54.000000000 -0600
+++ b/arch/x86/kernel/traps_32.c	2008-08-03 17:33:06.000000000 -0600
@@ -46,6 +46,16 @@
 #include <linux/edac.h>
 #endif

+#ifdef CONFIG_MDB
+#define DEBUGGER_EXCEPTION        1
+#define NMI_EXCEPTION             2
+#define BREAKPOINT_EXCEPTION      3
+#define SOFTWARE_EXCEPTION       22
+
+extern unsigned char *mdb_oops;
+extern int mdb(int reason, int error, void *frame);
+#endif
+
 #include <asm/arch_hooks.h>
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
@@ -452,8 +462,15 @@
  */
 void die(const char *str, struct pt_regs *regs, long err)
 {
-	unsigned long flags = oops_begin();
+#ifdef	CONFIG_MDB
+	unsigned long flags;

+        mdb_oops = (unsigned char *)str;
+        mdb(SOFTWARE_EXCEPTION, err, regs);
+	flags = oops_begin();
+#else
+	unsigned long flags = oops_begin();
+#endif
 	if (die_nest_count < 3) {
 		report_bug(regs->ip, regs);

@@ -573,7 +590,7 @@
 }

 DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV,
regs->ip)
-#ifndef CONFIG_KPROBES
+#if !defined(CONFIG_KPROBES) && !defined(CONFIG_MDB)
 DO_VM86_ERROR(3, SIGTRAP, "int3", int3)
 #endif
 DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
@@ -718,6 +735,9 @@
 {
 	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
NOTIFY_STOP)
 		return;
+#ifdef	CONFIG_MDB
+        mdb(NMI_EXCEPTION, reason, regs); // nmi is code 2
+#endif
 #ifdef CONFIG_MCA
 	/*
 	 * Might actually be able to figure out what the guilty party
@@ -756,6 +776,9 @@
 	printk(" on CPU%d, ip %08lx, registers:\n",
 		smp_processor_id(), regs->ip);
 	show_registers(regs);
+#ifdef	CONFIG_MDB
+        mdb(NMI_EXCEPTION, 0, regs); // nmi is code 2
+#endif
 	if (do_panic)
 		panic("Non maskable interrupt");
 	console_silent();
@@ -785,6 +808,10 @@
 	if (!cpu)
 		reason = get_nmi_reason();

+#if defined(CONFIG_SMP) && defined(CONFIG_MDB)
+        if (mdb(NMI_EXCEPTION, 0, regs))
+           return;
+#endif
 	if (!(reason & 0xc0)) {
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
@@ -850,6 +877,10 @@
 #ifdef CONFIG_KPROBES
 void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
+#ifdef	CONFIG_MDB
+        if (mdb(BREAKPOINT_EXCEPTION, error_code, regs))
+           return;
+#endif
 	trace_hardirqs_fixup();

 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
@@ -865,6 +896,16 @@
 }
 #endif

+#if defined(CONFIG_MDB) && !defined(CONFIG_KPROBES)
+fastcall void do_int3(struct pt_regs * regs, long error_code)
+{
+#ifdef	CONFIG_MDB
+        if (mdb(BREAKPOINT_EXCEPTION, error_code, regs))
+           return;
+#endif
+	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
+}
+#endif	/* CONFIG_KDB && !CONFIG_KPROBES */
 /*
  * Our handling of the processor debug registers is non-trivial.
  * We do not clear them on entry and exit from the kernel. Therefore
@@ -895,6 +936,10 @@
 	trace_hardirqs_fixup();

 	get_debugreg(condition, 6);
+#ifdef	CONFIG_MDB
+        if (mdb(DEBUGGER_EXCEPTION, error_code, regs))
+           return;
+#endif

 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



