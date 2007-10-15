Return-Path: <linux-kernel-owner+w=401wt.eu-S1765730AbXJOSmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765730AbXJOSmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933950AbXJOSes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:34:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:47931 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933935AbXJOSee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:34:34 -0400
Message-ID: <4713B28C.3030905@windriver.com>
Date: Mon, 15 Oct 2007 13:33:48 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ak@suse.de
Subject: [PATCH 17/21] KGDB: This adds hardware breakpoint support for i386.
Content-Type: multipart/mixed;
 boundary="------------070200000602030509060106"
X-OriginalArrivalTime: 15 Oct 2007 18:34:31.0985 (UTC) FILETIME=[070D6210:01C80F5A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070200000602030509060106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------070200000602030509060106
Content-Type: text/x-patch;
 name="i386-hw_breakpoints.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i386-hw_breakpoints.patch"

i386-hw_breakpoints.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: ak@suse.de
Subject: [PATCH] This adds hardware breakpoint support for i386.

This is the minimal set of routines support hw breakpoints on the x86
arch.  It has the known limitation that the system boot will wipe out
the hw breakpoints at cpu_init time and any user space hw breakpoints
will wipe out the kernel breakpoints.

In the future this implementation could change such that the the
kernel space may have its own context to swap in for hw breakpoints.
For now this minimal implementation works well given the limitations.

Signed-off-by: Milind Dumbare <milind@linsyssoft.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

 arch/x86/kernel/kgdb_32.c |  128 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 121 insertions(+), 7 deletions(-)
---

--- a/arch/x86/kernel/kgdb_32.c
+++ b/arch/x86/kernel/kgdb_32.c
@@ -14,12 +14,15 @@
 
 /*
  * Copyright (C) 2000-2001 VERITAS Software Corporation.
+ * Copyright (C) 2007 Wind River Systems, Inc.
+ * Copyright (C) 2007 MontaVista Software, Inc.
  */
 /*
  *  Contributor:     Lake Stevens Instrument Division$
  *  Written by:      Glenn Engel $
  *  Updated by:	     Amit Kale<akale@veritas.com>
  *  Updated by:	     Tom Rini <trini@kernel.crashing.org>
+ *  Updated by:	     Jason Wessel <jason.wessel@windriver.com>
  *  Modified for 386 by Jim Kingdon, Cygnus Support.
  *  Origianl kgdb, compatibility with 2.1.xx kernel by
  *  David Grothe <dave@gcom.com>
@@ -124,10 +127,115 @@ static struct hw_breakpoint {
 	{ .enabled = 0 },
 };
 
+static void kgdb_correct_hw_break(void)
+{
+	int breakno;
+	int breakbit;
+	int correctit = 0;
+	unsigned long dr7;
+
+	get_debugreg(dr7, 7);
+	for (breakno = 0; breakno < 4; breakno++) {
+		breakbit = 2 << (breakno << 1);
+		if (!(dr7 & breakbit) && breakinfo[breakno].enabled) {
+			correctit = 1;
+			dr7 |= breakbit;
+			dr7 &= ~(0xf0000 << (breakno << 2));
+			dr7 |= ((breakinfo[breakno].len << 2) |
+				 breakinfo[breakno].type) <<
+			       ((breakno << 2) + 16);
+			switch (breakno) {
+			case 0:
+				set_debugreg(breakinfo[0].addr, 0);
+				break;
+
+			case 1:
+				set_debugreg(breakinfo[1].addr, 1);
+				break;
+
+			case 2:
+				set_debugreg(breakinfo[2].addr, 2);
+				break;
+
+			case 3:
+				set_debugreg(breakinfo[3].addr, 3);
+				break;
+			}
+		} else if ((dr7 & breakbit) && !breakinfo[breakno].enabled) {
+			correctit = 1;
+			dr7 &= ~breakbit;
+			dr7 &= ~(0xf0000 << (breakno << 2));
+		}
+	}
+	if (correctit)
+		set_debugreg(dr7, 7);
+}
+
+static int kgdb_remove_hw_break(unsigned long addr, int len,
+				enum kgdb_bptype bptype)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		if (breakinfo[i].addr == addr && breakinfo[i].enabled)
+			break;
+	if (i == 4)
+		return -1;
+
+	breakinfo[i].enabled = 0;
+	return 0;
+}
+
+static void kgdb_remove_all_hw_break(void)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		memset(&breakinfo[i], 0, sizeof(struct hw_breakpoint));
+}
+
+static int kgdb_set_hw_break(unsigned long addr, int len,
+			     enum kgdb_bptype bptype)
+{
+	int i;
+	unsigned type;
+
+	for (i = 0; i < 4; i++)
+		if (!breakinfo[i].enabled)
+			break;
+	if (i == 4)
+		return -1;
+
+	switch (bptype) {
+	case bp_hardware_breakpoint:
+		type = 0;
+		len  = 1;
+		break;
+	case bp_write_watchpoint:
+		type = 1;
+		break;
+	case bp_access_watchpoint:
+		type = 3;
+		break;
+	default:
+		return -1;
+	}
+
+	if (len == 1 || len == 2 || len == 4)
+		breakinfo[i].len  = len - 1;
+	else
+		return -1;
+
+	breakinfo[i].enabled = 1;
+	breakinfo[i].addr = addr;
+	breakinfo[i].type = type;
+	return 0;
+}
+
 void kgdb_disable_hw_debug(struct pt_regs *regs)
 {
 	/* Disable hardware debugging while we are in kgdb */
-	asm volatile ("movl %0,%%db7": /* no output */ :"r" (0));
+	set_debugreg(0, 7);
 }
 
 void kgdb_post_master_code(struct pt_regs *regs, int e_vector, int err_code)
@@ -172,12 +280,12 @@ int kgdb_arch_handle_exception(int e_vec
 			linux_regs->eflags |= TF_MASK;
 			debugger_step = 1;
 			atomic_set(&cpu_doing_single_step,
-			raw_smp_processor_id());
+				   raw_smp_processor_id());
 		}
 
-		asm volatile ("movl %%db6, %0\n":"=r" (dr6));
+		get_debugreg(dr6, 6);
 		if (!(dr6 & 0x4000)) {
-			long breakno;
+			int breakno;
 			for (breakno = 0; breakno < 4; ++breakno) {
 				if (dr6 & (1 << breakno) &&
 				    breakinfo[breakno].type == 0) {
@@ -187,10 +295,11 @@ int kgdb_arch_handle_exception(int e_vec
 				}
 			}
 		}
-		asm volatile ("movl %0, %%db6\n"::"r" (0));
+		set_debugreg(0, 6);
+		kgdb_correct_hw_break();
 
-		return (0);
-	}			/* switch */
+		return 0;
+	}
 	/* this means that we do not want to exit from the handler */
 	return -1;
 }
@@ -297,4 +406,9 @@ unsigned long kgdb_arch_pc(int exception
 
 struct kgdb_arch arch_kgdb_ops = {
 	.gdb_bpt_instr = {0xcc},
+	.flags = KGDB_HW_BREAKPOINT,
+	.set_hw_breakpoint = kgdb_set_hw_break,
+	.remove_hw_breakpoint = kgdb_remove_hw_break,
+	.remove_all_hw_break = kgdb_remove_all_hw_break,
+	.correct_hw_break = kgdb_correct_hw_break,
 };

--------------070200000602030509060106--
