Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbZLRBke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbZLRBke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZLRBkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:40:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953AbZLRBkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:40:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
In-Reply-To: Oleg Nesterov's message of  Friday, 18 December 2009 01:56:50 +0100 <20091218005650.GA20667@redhat.com>
References: <20091218005650.GA20667@redhat.com>
X-Windows: garbage at your fingertips.
Message-Id: <20091218014021.CB474135F@magilla.sf.frob.com>
Date: Thu, 17 Dec 2009 17:40:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing to the old (2.6.32) logic, I think it might be this (untested).
I also note this is the sole use of get_si_code, seems like it should
just be rolled in here.


Thanks,
Roland


diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 3339917..16a88f5 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -530,7 +530,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
 	unsigned long dr6;
-	int si_code;
 
 	get_debugreg(dr6, 6);
 
@@ -569,14 +568,15 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	 * We already checked v86 mode above, so we can check for kernel mode
 	 * by just checking the CPL of CS.
 	 */
+	dr6 = tsk->thread.debugreg6;
 	if ((dr6 & DR_STEP) && !user_mode(regs)) {
 		tsk->thread.debugreg6 &= ~DR_STEP;
 		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
 		regs->flags &= ~X86_EFLAGS_TF;
+	} else if (dr6 & (DR_STEP | DR_TRAP_BITS)) {
+		send_sigtrap(tsk, regs, error_code, get_si_code(dr6));
 	}
-	si_code = get_si_code(tsk->thread.debugreg6);
-	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
-		send_sigtrap(tsk, regs, error_code, si_code);
+
 	preempt_conditional_cli(regs);
 
 	return;
