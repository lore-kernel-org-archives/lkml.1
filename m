Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYGAXcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYGAXcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbYGAXcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:32:15 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:4248 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYGAXcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:32:14 -0400
Date: Wed, 2 Jul 2008 01:31:34 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] x86: traps_xx: modify do_trap
Message-ID: <20080701233134.GD29903@mailshack.com>
References: <20080701193643.GA29695@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701193643.GA29695@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Wed, 02 Jul 2008 01:32:01 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.59; VDF: 7.0.5.30; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if (cond) block -> if (!cond) goto end_of_block

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_64.c |   56 ++++++++++++++++++++++----------------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 1ae0d4d..b49c886 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -635,38 +635,38 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 {
 	struct task_struct *tsk = current;
 
-	if (user_mode(regs)) {
-		/*
-		 * We want error_code and trap_no set for userspace
-		 * faults and kernelspace faults which result in
-		 * die(), but not kernelspace faults which are fixed
-		 * up.  die() gives the process no chance to handle
-		 * the signal and notice the kernel fault information,
-		 * so that won't result in polluting the information
-		 * about previously queued, but not yet delivered,
-		 * faults.  See also do_general_protection below.
-		 */
-		tsk->thread.error_code = error_code;
-		tsk->thread.trap_no = trapnr;
-
-		if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
-		    printk_ratelimit()) {
-			printk(KERN_INFO
-			       "%s[%d] trap %s ip:%lx sp:%lx error:%lx",
-			       tsk->comm, tsk->pid, str,
-			       regs->ip, regs->sp, error_code);
-			print_vma_addr(" in ", regs->ip);
-			printk("\n");
-		}
+	if (!user_mode(regs))
+		goto kernel_trap;
 
-		if (info)
-			force_sig_info(signr, info, tsk);
-		else
-			force_sig(signr, tsk);
-		return;
+	/*
+	 * We want error_code and trap_no set for userspace faults and
+	 * kernelspace faults which result in die(), but not
+	 * kernelspace faults which are fixed up.  die() gives the
+	 * process no chance to handle the signal and notice the
+	 * kernel fault information, so that won't result in polluting
+	 * the information about previously queued, but not yet
+	 * delivered, faults.  See also do_general_protection below.
+	 */
+	tsk->thread.error_code = error_code;
+	tsk->thread.trap_no = trapnr;
+
+	if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
+	    printk_ratelimit()) {
+		printk(KERN_INFO
+		       "%s[%d] trap %s ip:%lx sp:%lx error:%lx",
+		       tsk->comm, tsk->pid, str,
+		       regs->ip, regs->sp, error_code);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
 	}
 
+	if (info)
+		force_sig_info(signr, info, tsk);
+	else
+		force_sig(signr, tsk);
+	return;
 
+kernel_trap:
 	if (!fixup_exception(regs)) {
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = trapnr;
-- 
1.5.4.3

