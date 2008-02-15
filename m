Return-Path: <linux-kernel-owner+w=401wt.eu-S1764798AbYBOU5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764798AbYBOU5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762699AbYBOUzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:55:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:55883 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762189AbYBOUzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:55:47 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/7] kgdb-light-v10: x86 HW breakpoints
Date: Fri, 15 Feb 2008 14:55:56 -0600
Message-Id: <1203108958-1818-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1203108958-1818-5-git-send-email-jason.wessel@windriver.com>
References: <1203108958-1818-1-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-2-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-3-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-4-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 15 Feb 2008 20:55:36.0390 (UTC) FILETIME=[1D0A5660:01C87015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add HW breakpoints into the arch specific portion of x86 kgdb.  In the
current x86 kernel.org kernels HW breakpoints are changed out in lazy
fashion because there is no infrastructure around changing them when
changing to a kernel task or entering the kernel mode via a system
call.  This lazy approach means that if a user process uses HW
breakpoints the kgdb will loose out.  This is an acceptable trade off
because the developer debugging the kernel is assumed to know what is
going on system wide and would be aware of this trade off.

There is a minor bug fix to the kgdb core so as to correctly call the
hw breakpoint functions with a valid value from the enum.

There is also a minor change to the x86_64 startup code when using
early HW breakpoints.  When the debugger is connected, the cpu startup
code must not zero out the HW breakpoint registers or you cannot hit
the breakpoints you are interested in, in the first place.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c    |  138 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup64.c |   14 +++++
 kernel/kgdb.c             |    4 +-
 3 files changed, 154 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 83d97bb..88bfa45 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -182,6 +182,122 @@ void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 #endif
 }
 
+static struct hw_breakpoint {
+	unsigned		enabled;
+	unsigned		type;
+	unsigned		len;
+	unsigned long		addr;
+} breakinfo[4];
+
+static void kgdb_correct_hw_break(void)
+{
+	unsigned long dr7;
+	int correctit = 0;
+	int breakbit;
+	int breakno;
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
+			if (breakno >= 0 && breakno <= 3)
+				set_debugreg(breakinfo[breakno].addr, breakno);
+
+		} else {
+			if ((dr7 & breakbit) && !breakinfo[breakno].enabled) {
+				correctit = 1;
+				dr7 &= ~breakbit;
+				dr7 &= ~(0xf0000 << (breakno << 2));
+			}
+		}
+	}
+	if (correctit)
+		set_debugreg(dr7, 7);
+}
+
+static int
+kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
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
+
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
+static int
+kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
+{
+	unsigned type;
+	int i;
+
+	for (i = 0; i < 4; i++)
+		if (!breakinfo[i].enabled)
+			break;
+	if (i == 4)
+		return -1;
+
+	switch (bptype) {
+	case BP_HARDWARE_BREAKPOINT:
+		type = 0;
+		len  = 1;
+		break;
+	case BP_WRITE_WATCHPOINT:
+		type = 1;
+		break;
+	case BP_ACCESS_WATCHPOINT:
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
+
+	return 0;
+}
+
+/**
+ *	kgdb_disable_hw_debug - Disable hardware debugging while we in kgdb.
+ *	@regs: Current &struct pt_regs.
+ *
+ *	This function will be called if the particular architecture must
+ *	disable hardware debugging while it is processing gdb packets or
+ *	handling exception.
+ */
+void kgdb_disable_hw_debug(struct pt_regs *regs)
+{
+	/* Disable hardware debugging while we are in kgdb: */
+	set_debugreg(0UL, 7);
+}
+
 /**
  *	kgdb_post_primary_code - Save error vector/code numbers.
  *	@regs: Original pt_regs.
@@ -243,6 +359,7 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 			       struct pt_regs *linux_regs)
 {
 	unsigned long addr;
+	unsigned long dr6;
 	char *ptr;
 	int newPC;
 
@@ -269,6 +386,22 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 			}
 		}
 
+		get_debugreg(dr6, 6);
+		if (!(dr6 & 0x4000)) {
+			int breakno;
+
+			for (breakno = 0; breakno < 4; breakno++) {
+				if (dr6 & (1 << breakno) &&
+				    breakinfo[breakno].type == 0) {
+					/* Set restore flag: */
+					linux_regs->flags |= X86_EFLAGS_RF;
+					break;
+				}
+			}
+		}
+		set_debugreg(0UL, 6);
+		kgdb_correct_hw_break();
+
 		return 0;
 	}
 
@@ -426,4 +559,9 @@ unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: */
 	.gdb_bpt_instr		= { 0xcc },
+	.flags			= KGDB_HW_BREAKPOINT,
+	.set_hw_breakpoint	= kgdb_set_hw_break,
+	.remove_hw_breakpoint	= kgdb_remove_hw_break,
+	.remove_all_hw_break	= kgdb_remove_all_hw_break,
+	.correct_hw_break	= kgdb_correct_hw_break,
 };
diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index 309366f..d5a146a 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -11,6 +11,7 @@
 #include <linux/bootmem.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
+#include <linux/kgdb.h>
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -325,6 +326,15 @@ void __cpuinit cpu_init (void)
 	load_TR_desc();
 	load_LDT(&init_mm.context);
 
+#ifdef CONFIG_KGDB
+	/*
+	 * If the kgdb is connected no debug regs should be altered.  This
+	 * is only applicable when KGDB and a KGDB I/O module are built
+	 * into the kernel and you are using early debugging with
+	 * kgdbwait. KGDB will control the kernel HW breakpoint registers.
+	 */
+	if (kgdb_connected) {
+#endif
 	/*
 	 * Clear all 6 debug registers:
 	 */
@@ -335,6 +345,10 @@ void __cpuinit cpu_init (void)
 	set_debugreg(0UL, 3);
 	set_debugreg(0UL, 6);
 	set_debugreg(0UL, 7);
+#ifdef CONFIG_KGDB
+	/* If the kgdb is connected no debug regs should be altered. */
+	}
+#endif
 
 	fpu_init(); 
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index b516de0..a453764 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1121,10 +1121,10 @@ static void gdb_cmd_break(struct kgdb_state *ks)
 		error = kgdb_remove_sw_break(addr);
 	else if (remcom_in_buffer[0] == 'Z')
 		error = arch_kgdb_ops.set_hw_breakpoint(addr,
-			(int)length, *bpt_type);
+			(int)length, *bpt_type - '0');
 	else if (remcom_in_buffer[0] == 'z')
 		error = arch_kgdb_ops.remove_hw_breakpoint(addr,
-			(int) length, *bpt_type);
+			(int) length, *bpt_type - '0');
 
 	if (error == 0)
 		strcpy(remcom_out_buffer, "OK");
-- 
1.5.4

