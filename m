Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYIKF7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYIKF7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 01:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYIKF7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 01:59:46 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:54827 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbYIKF7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 01:59:45 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48C8B3CF.4000303@avtrex.com>
Date: Wed, 10 Sep 2008 22:59:43 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 4/6] MIPS: Watch exception handling for HARDWARE_WATCHPOINTS.
References: <48C8ADEF.9020305@avtrex.com>
In-Reply-To: <48C8ADEF.9020305@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2008 05:59:44.0108 (UTC) FILETIME=[9684C2C0:01C913D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Watch exception handling for HARDWARE_WATCHPOINTS.

Here we hook up the watch exception handler so that it sends SIGTRAP when
the hardware watch registers are triggered.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/genex.S |    4 ++++
 arch/mips/kernel/traps.c |   14 +++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index c6ada98..15a9bde 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -416,7 +416,11 @@ NESTED(nmi_handler, PT_SIZE, sp)
 	BUILD_HANDLER tr tr sti silent			/* #13 */
 	BUILD_HANDLER fpe fpe fpe silent		/* #15 */
 	BUILD_HANDLER mdmx mdmx sti silent		/* #22 */
+#ifdef 	CONFIG_HARDWARE_WATCHPOINTS
+	BUILD_HANDLER watch watch sti silent		/* #23 */
+#else
 	BUILD_HANDLER watch watch sti verbose		/* #23 */
+#endif
 	BUILD_HANDLER mcheck mcheck cli verbose		/* #24 */
 	BUILD_HANDLER mt mt sti silent			/* #25 */
 	BUILD_HANDLER dsp dsp sti silent		/* #26 */
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 6bee290..5fbf591 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -42,6 +42,7 @@
 #include <asm/tlbdebug.h>
 #include <asm/traps.h>
 #include <asm/uaccess.h>
+#include <asm/watch.h>
 #include <asm/mmu_context.h>
 #include <asm/types.h>
 #include <asm/stacktrace.h>
@@ -908,12 +909,15 @@ asmlinkage void do_mdmx(struct pt_regs *regs)
 asmlinkage void do_watch(struct pt_regs *regs)
 {
 	/*
-	 * We use the watch exception where available to detect stack
-	 * overflows.
+	 * If the current thread has the watch registers loaded, save
+	 * their values and send SIGTRAP.  Otherwise another thread
+	 * left the registers set, clear them and continue.
 	 */
-	dump_tlb_all();
-	show_regs(regs);
-	panic("Caught WATCH exception - probably caused by stack overflow.");
+	if (test_tsk_thread_flag(current, TIF_LOAD_WATCH)) {
+		mips_read_watch_registers();
+		force_sig(SIGTRAP, current);
+	} else
+		mips_clear_watch_registers();
 }
 
 asmlinkage void do_mcheck(struct pt_regs *regs)
-- 
1.5.5.1

