Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYIEX11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYIEX11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYIEX1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:27:15 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51039 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYIEX1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:27:12 -0400
Message-ID: <48C1C04F.10105@ct.jp.nec.com>
Date: Fri, 05 Sep 2008 16:27:11 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86_32: signal: introduce signal_fault()
References: <48C1BF41.8040404@ct.jp.nec.com>
In-Reply-To: <48C1BF41.8040404@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

implement signal_fault() for 32bit.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   18 +++++++++++++++++-
 include/asm-x86/ptrace.h    |    4 ++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 3e4a688..76d05d7 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -243,7 +243,7 @@ asmlinkage int sys_rt_sigreturn(unsigned long __unused)
 	return ax;
 
 badframe:
-	force_sig(SIGSEGV, current);
+	signal_fault(regs, frame, "rt sigreturn");
 	return 0;
 }
 
@@ -669,3 +669,19 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 
 	clear_thread_flag(TIF_IRET);
 }
+
+void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
+{
+	struct task_struct *me = current;
+
+	if (show_unhandled_signals && printk_ratelimit()) {
+		printk(KERN_INFO
+		       "%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
+		       me->comm, me->pid, where, frame,
+		       regs->ip, regs->sp, regs->orig_ax);
+		print_vma_addr(" in ", regs->ip);
+		printk(KERN_CONT "\n");
+	}
+
+	force_sig(SIGSEGV, me);
+}
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index d64a610..4dfce55 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -178,10 +178,10 @@ convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 #ifdef CONFIG_X86_32
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code);
-#else
-void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 #endif
 
+void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
+
 extern long syscall_trace_enter(struct pt_regs *);
 extern void syscall_trace_leave(struct pt_regs *);
 
-- 
1.5.6

