Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758869AbYLPWC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYLPWC2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYLPWCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:02:18 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:54701 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbYLPWCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:02:17 -0500
Message-ID: <49482568.3020108@ct.jp.nec.com>
Date: Tue, 16 Dec 2008 14:02:16 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: signal: use signal_fault() in sys_sigreturn()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Call signal_fault() in error route of sys_sigreturn().
Change log level to KERN_EMERG if current is init.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index dee553c..605592a 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -594,17 +594,7 @@ asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
 	return ax;
 
 badframe:
-	if (show_unhandled_signals && printk_ratelimit()) {
-		printk("%s%s[%d] bad frame in sigreturn frame:"
-			"%p ip:%lx sp:%lx oeax:%lx",
-		    task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG,
-		    current->comm, task_pid_nr(current), frame, regs->ip,
-		    regs->sp, regs->orig_ax);
-		print_vma_addr(" in ", regs->ip);
-		printk(KERN_CONT "\n");
-	}
-
-	force_sig(SIGSEGV, current);
+	signal_fault(regs, frame, "sigreturn");
 
 	return 0;
 }
@@ -906,8 +896,9 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 	struct task_struct *me = current;
 
 	if (show_unhandled_signals && printk_ratelimit()) {
-		printk(KERN_INFO
+		printk("%s"
 		       "%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
+		       task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG,
 		       me->comm, me->pid, where, frame,
 		       regs->ip, regs->sp, regs->orig_ax);
 		print_vma_addr(" in ", regs->ip);
-- 
1.6.0.4

