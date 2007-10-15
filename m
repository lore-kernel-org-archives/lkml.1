Return-Path: <linux-kernel-owner+w=401wt.eu-S934704AbXJOSn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934704AbXJOSn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933954AbXJOSet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:34:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:47940 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933482AbXJOSek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:34:40 -0400
Message-ID: <4713B290.9060309@windriver.com>
Date: Mon, 15 Oct 2007 13:33:52 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ak@suse.de
Subject: [PATCH 18/21] KGDB: This adds hardware breakpoint support for x86_64.
Content-Type: multipart/mixed;
 boundary="------------030800050607060402000007"
X-OriginalArrivalTime: 15 Oct 2007 18:34:36.0032 (UTC) FILETIME=[0976E800:01C80F5A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030800050607060402000007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------030800050607060402000007
Content-Type: text/x-patch;
 name="x86_64-hw_breakpoints.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86_64-hw_breakpoints.patch"

x86_64-hw_breakpoints.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: ak@suse.de
Subject: [PATCH] This adds hardware breakpoint support for x86_64.

This is the minimal set of routines support hw breakpoints on the
x86_64 arch.  It has the known limitation that the system boot will
wipe out the hw breakpoints at cpu_init time and any user space hw
breakpoints will wipe out the kernel breakpoints.

In the future this implementation could change such that the the
kernel space may have its own context to swap in for hw breakpoints.
For now this minimal implementation works well given the limitations.

Signed-off-by: Milind Dumbare <milind@linsyssoft.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

 arch/x86/kernel/kgdb_64.c |  145 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 128 insertions(+), 17 deletions(-)
---

--- a/arch/x86/kernel/kgdb_64.c
+++ b/arch/x86/kernel/kgdb_64.c
@@ -17,6 +17,8 @@
  * Copyright (C) 2000-2001 VERITAS Software Corporation.
  * Copyright (C) 2002 Andi Kleen, SuSE Labs
  * Copyright (C) 2004 LinSysSoft Technologies Pvt. Ltd.
+ * Copyright (C) 2007 Jason Wessel, Wind River Systems, Inc.
+ * Copyright (C) 2007 MontaVista Software, Inc.
  */
 /****************************************************************************
  *  Contributor:     Lake Stevens Instrument Division$
@@ -116,22 +118,127 @@ void gdb_regs_to_regs(unsigned long *gdb
 	regs->r15 = gdb_regs[_R15];
 }				/* gdb_regs_to_regs */
 
-struct hw_breakpoint {
+static struct hw_breakpoint {
 	unsigned enabled;
 	unsigned type;
 	unsigned len;
 	unsigned long addr;
 } breakinfo[4] = {
-	{enabled:0},
-	{enabled:0},
-	{enabled:0},
-	{enabled:0}
+	{ .enabled = 0 },
+	{ .enabled = 0 },
+	{ .enabled = 0 },
+	{ .enabled = 0 },
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
-	asm volatile ("movq %0,%%db7": /* no output */ :"r" (0UL));
+	set_debugreg(0UL, 7);
 }
 
 void kgdb_post_master_code(struct pt_regs *regs, int e_vector, int err_code)
@@ -151,7 +258,6 @@ int kgdb_arch_handle_exception(int e_vec
 			       struct pt_regs *linux_regs)
 {
 	unsigned long addr;
-	unsigned long breakno;
 	char *ptr;
 	int newPC;
 	unsigned long dr6;
@@ -167,8 +273,8 @@ int kgdb_arch_handle_exception(int e_vec
 
 		/* clear the trace bit */
 		linux_regs->eflags &= ~TF_MASK;
-
 		atomic_set(&cpu_doing_single_step, -1);
+
 		/* set the trace bit if we're stepping */
 		if (remcomInBuffer[0] == 's') {
 			linux_regs->eflags |= TF_MASK;
@@ -179,20 +285,21 @@ int kgdb_arch_handle_exception(int e_vec
 
 		}
 
-		asm volatile ("movq %%db6, %0\n":"=r" (dr6));
+		get_debugreg(dr6, 6);
 		if (!(dr6 & 0x4000)) {
+			int breakno;
+
 			for (breakno = 0; breakno < 4; ++breakno) {
-				if (dr6 & (1 << breakno)) {
-					if (breakinfo[breakno].type == 0) {
-						/* Set restore flag */
-						linux_regs->eflags |=
-						    X86_EFLAGS_RF;
-						break;
-					}
+				if (dr6 & (1 << breakno) &&
+				    breakinfo[breakno].type == 0) {
+					/* Set restore flag */
+					linux_regs->eflags |= X86_EFLAGS_RF;
+					break;
 				}
 			}
 		}
-		asm volatile ("movq %0, %%db6\n"::"r" (0UL));
+		set_debugreg(0UL, 6);
+		kgdb_correct_hw_break();
 
 		return 0;
 	}
@@ -381,4 +488,8 @@ struct kgdb_arch arch_kgdb_ops = {
 	.gdb_bpt_instr = {0xcc},
 	.flags = KGDB_HW_BREAKPOINT,
 	.shadowth = 1,
+	.set_hw_breakpoint = kgdb_set_hw_break,
+	.remove_hw_breakpoint = kgdb_remove_hw_break,
+	.remove_all_hw_break = kgdb_remove_all_hw_break,
+	.correct_hw_break = kgdb_correct_hw_break,
 };

--------------030800050607060402000007--
