Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab0BLWq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:46:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:45606 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab0BLWqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:46:54 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/8] x86,early dr regs,kgdb: Allow kernel debugger early dr register access
Date: Fri, 12 Feb 2010 16:39:25 -0600
Message-Id: <1266014369-29547-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014369-29547-1-git-send-email-jason.wessel@windriver.com>
References: <1266014369-29547-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:43:09.0781 (UTC) FILETIME=[C049A850:01CAAC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel debugger was configured, attached and started with
kgdbwait, the hardware breakpoint registers should get restored by the
kgdb code which is managing the dr registers.

CC: x86@kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/cpu/common.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4868e4a..712c1eb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1084,6 +1084,20 @@ static void clear_all_debug_regs(void)
 	}
 }
 
+#ifdef CONFIG_KGDB
+/*
+ * Restore debug regs if using kgdbwait and you have a kernel debugger
+ * connection established.
+ */
+static void dbg_restore_debug_regs(void)
+{
+	if (unlikely(kgdb_connected && arch_kgdb_ops.correct_hw_break))
+		arch_kgdb_ops.correct_hw_break();
+}
+#else /* ! CONFIG_KGDB */
+#define dbg_restore_debug_regs()
+#endif /* ! CONFIG_KGDB */
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
@@ -1174,18 +1188,8 @@ void __cpuinit cpu_init(void)
 	load_TR_desc();
 	load_LDT(&init_mm.context);
 
-#ifdef CONFIG_KGDB
-	/*
-	 * If the kgdb is connected no debug regs should be altered.  This
-	 * is only applicable when KGDB and a KGDB I/O module are built
-	 * into the kernel and you are using early debugging with
-	 * kgdbwait. KGDB will control the kernel HW breakpoint registers.
-	 */
-	if (kgdb_connected && arch_kgdb_ops.correct_hw_break)
-		arch_kgdb_ops.correct_hw_break();
-	else
-#endif
-		clear_all_debug_regs();
+	clear_all_debug_regs();
+	dbg_restore_debug_regs();
 
 	fpu_init();
 
@@ -1239,6 +1243,7 @@ void __cpuinit cpu_init(void)
 #endif
 
 	clear_all_debug_regs();
+	dbg_restore_debug_regs();
 
 	/*
 	 * Force FPU initialization:
-- 
1.6.4.rc1

