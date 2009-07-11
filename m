Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbZGKHpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbZGKHpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZGKHoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:44:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56728 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZGKHoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:44:14 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090711944.448667020@firstfloor.org>
In-Reply-To: <20090711944.448667020@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/3] x86: mce: Improve comments in mce.c
Message-Id: <20090711074411.B41C81D0261@basil.firstfloor.org>
Date: Sat, 11 Jul 2009 09:44:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Add references to documentation
- Add a top level comment giving a quick overview.
- Improve a few other comments.

No code changes

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce.c |   49 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1,11 +1,31 @@
 /*
- * Machine check handler.
+ * Machine check handler. This handles hardware errors detected by
+ * the CPU.
  *
  * K8 parts Copyright 2002,2003 Andi Kleen, SuSE Labs.
  * Rest from unknown author(s).
  * 2004 Andi Kleen. Rewrote most of it.
  * Copyright 2008 Intel Corporation
  * Author: Andi Kleen
+ *
+ * This code handles both corrected (by hardware) errors and
+ * uncorrected errors. The corrected errors are only logged and
+ * handled by machine_check_poll() et.al. The entry point for
+ * uncorrected errors is do_machine_check() which handles the machine
+ * check exception (int 18) raised by the CPU. Uncorrected errors can
+ * either panic or in some special cases be recovered. The logging of
+ * machine check events is done through a special /dev/mcelog
+ * device. Then there is a lot of support code for setting up machine
+ * checks and configuring them.
+ *
+ * References:
+ * Intel 64 Software developer's manual (SDM)
+ * System Programming Guide Volume 3a
+ * Chapter 15 "Machine-check architecture"
+ * You should read that before changing anything.
+ *
+ * Old, outdated paper, but gives a reasonable overview
+ * http://halobates.de/mce.pdf
  */
 #include <linux/thread_info.h>
 #include <linux/capability.h>
@@ -164,6 +184,11 @@ void mce_log(struct mce *mce)
 	set_bit(0, &mce_need_notify);
 }
 
+/*
+ * Panic handling. Print machine checks to the console in case of a
+ * unrecoverable error.
+ */
+
 static void print_mce(struct mce *m)
 {
 	printk(KERN_EMERG
@@ -260,7 +285,9 @@ static void mce_panic(char *msg, struct
 	panic(msg);
 }
 
-/* Support code for software error injection */
+/*
+ * Support code for software error injection
+ */
 
 static int msr_to_offset(u32 msr)
 {
@@ -409,6 +436,11 @@ asmlinkage void smp_mce_self_interrupt(s
 }
 #endif
 
+/*
+ * Schedule further processing of a machine check event after
+ * the exception handler ran. Has to be careful about context because
+ * MCEs run lockless independent from any normal kernel locks.
+ */
 static void mce_report_event(struct pt_regs *regs)
 {
 	if (regs->flags & (X86_VM_MASK|X86_EFLAGS_IF)) {
@@ -454,6 +486,9 @@ DEFINE_PER_CPU(unsigned, mce_poll_count)
  * Poll for corrected events or events that happened before reset.
  * Those are just logged through /dev/mcelog.
  *
+ * Either called regularly from a timer, or by special corrected
+ * error interrupts.
+ *
  * This is executed in standard interrupt context.
  *
  * Note: spec recommends to panic for fatal unsignalled
@@ -547,6 +582,10 @@ static int mce_no_way_out(struct mce *m,
 }
 
 /*
+ * Support for synchronizing machine checks over all CPUs.
+ */
+
+/*
  * Variable to establish order between CPUs while scanning.
  * Each CPU spins initially until executing is equal its number.
  */
@@ -1221,7 +1260,11 @@ static void mce_init(void)
 	}
 }
 
-/* Add per CPU specific workarounds here */
+/*
+ * This function contains workarounds for various machine check
+ * related CPU quirks. Primarly it disables broken machine check
+ * events.
+ */
 static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 {
 	/* This should be disabled by the BIOS, but isn't always */
