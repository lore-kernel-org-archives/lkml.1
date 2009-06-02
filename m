Return-Path: <linux-kernel-owner+w=401wt.eu-S1759664AbZFBHRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664AbZFBHRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZFBHRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:17:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:32849 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbZFBHRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:17:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kgdbts: unify/generalize gdb breakpoint adjustment
Date: Tue,  2 Jun 2009 03:17:30 -0400
Message-Id: <1243927050-30685-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin arch, like the x86 arch, needs to adjust the PC manually
after a breakpoint is hit as normally this is handled by the remote gdb.
However, rather than starting another arch ifdef mess, create a common
GDB_ADJUSTS_BREAK_OFFSET define for any arch to opt-in via their kgdb.h.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/kgdb.h |    1 +
 arch/x86/include/asm/kgdb.h      |    1 +
 drivers/misc/kgdbts.c            |   14 ++++++--------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/include/asm/kgdb.h b/arch/blackfin/include/asm/kgdb.h
index c8b256d..8d5fe42 100644
--- a/arch/blackfin/include/asm/kgdb.h
+++ b/arch/blackfin/include/asm/kgdb.h
@@ -107,6 +107,7 @@ static inline void arch_kgdb_breakpoint(void)
 }
 #define BREAK_INSTR_SIZE	2
 #define CACHE_FLUSH_IS_SAFE	1
+#define GDB_ADJUSTS_BREAK_OFFSET
 #define HW_INST_WATCHPOINT_NUM	6
 #define HW_WATCHPOINT_NUM	8
 #define TYPE_INST_WATCHPOINT	0
diff --git a/arch/x86/include/asm/kgdb.h b/arch/x86/include/asm/kgdb.h
index e6c6c80..30671a8 100644
--- a/arch/x86/include/asm/kgdb.h
+++ b/arch/x86/include/asm/kgdb.h
@@ -75,5 +75,6 @@ static inline void arch_kgdb_breakpoint(void)
 }
 #define BREAK_INSTR_SIZE	1
 #define CACHE_FLUSH_IS_SAFE	1
+#define GDB_ADJUSTS_BREAK_OFFSET
 
 #endif /* _ASM_X86_KGDB_H */
diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index e4ff50b..faff9cb 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -291,10 +291,10 @@ static int check_and_rewind_pc(char *put_str, char *arg)
 		 NUMREGBYTES);
 	gdb_regs_to_pt_regs(kgdbts_gdb_regs, &kgdbts_regs);
 	v2printk("Stopped at IP: %lx\n", instruction_pointer(&kgdbts_regs));
-#ifdef CONFIG_X86
-	/* On x86 a breakpoint stop requires it to be decremented */
-	if (addr + 1 == kgdbts_regs.ip)
-		offset = -1;
+#ifdef GDB_ADJUSTS_BREAK_OFFSET
+	/* On some arches, a breakpoint stop requires it to be decremented */
+	if (addr + BREAK_INSTR_SIZE == instruction_pointer(&kgdbts_regs))
+		offset = -BREAK_INSTR_SIZE;
 #endif
 	if (strcmp(arg, "silent") &&
 		instruction_pointer(&kgdbts_regs) + offset != addr) {
@@ -302,10 +302,8 @@ static int check_and_rewind_pc(char *put_str, char *arg)
 			   instruction_pointer(&kgdbts_regs) + offset, addr);
 		return 1;
 	}
-#ifdef CONFIG_X86
-	/* On x86 adjust the instruction pointer if needed */
-	kgdbts_regs.ip += offset;
-#endif
+	/* Readjust the instruction pointer if needed */
+	instruction_pointer(&kgdbts_regs) += offset;
 	return 0;
 }
 
-- 
1.6.3.1

