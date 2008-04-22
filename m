Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbYDVAWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbYDVAWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbYDVAVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:21:54 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:55969 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300AbYDVAVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:21:53 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <480D2F9E.4060408@avtrex.com>
Date: Mon, 21 Apr 2008 17:21:50 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 4/6] Watch trap handling for HARDWARE_WATCHPOINTS.
References: <480D2151.2020701@avtrex.com>
In-Reply-To: <480D2151.2020701@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 00:21:51.0846 (UTC) FILETIME=[DCA69060:01C8A40E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this portion of the patch we hook up the watch trap handler.  When the
trap occurs, we copy the register contents into the thread_struct and 
send SIGTRAP.  If the current thread was not expecting the trap, the
watch register values must have been left over from a different context and
we just clear the registers and return.

Also I turn off the message the prints on each trap, as these traps are now
expected.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/genex.S |    4 ++++
 arch/mips/kernel/traps.c |   13 +++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

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
index 984c0d0..6a5f3f0 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -887,6 +887,18 @@ asmlinkage void do_mdmx(struct pt_regs *regs)
 
 asmlinkage void do_watch(struct pt_regs *regs)
 {
+#ifdef CONFIG_HARDWARE_WATCHPOINTS
+	/*
+	 * If the current thread has the watch registers loaded, save
+	 * their values and send SIGTRAP.  Otherwise another thread
+	 * left the registers set, clear them and continue.
+	 */
+	if (test_tsk_thread_flag(current, TIF_LOAD_WATCH)) {
+		mips_read_watch_registers();
+		force_sig(SIGTRAP, current);
+	} else
+		mips_clear_watch_registers();
+#else
 	if (board_watchpoint_handler) {
 		(*board_watchpoint_handler)(regs);
 		return;
@@ -899,6 +911,7 @@ asmlinkage void do_watch(struct pt_regs *regs)
 	dump_tlb_all();
 	show_regs(regs);
 	panic("Caught WATCH exception - probably caused by stack overflow.");
+#endif
 }
 
 asmlinkage void do_mcheck(struct pt_regs *regs)
-- 
1.5.5

