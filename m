Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbZLRBCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbZLRBCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZLRBCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:02:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZLRBCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:02:50 -0500
Date: Fri, 18 Dec 2009 01:56:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
Message-ID: <20091218005650.GA20667@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

do_debug() is obviously wrong wrt PTRACE_SINGLESTEP/TIF_SINGLESTEP, no?

Afaics this was broken by

	hw-breakpoints: modifying generic debug exception to use thread-specific debug registers
	commit 08d68323d1f0c34452e614263b212ca556dae47f

To verify, the "patch" below fixes the stepping for me, not sure what
is the proper fix...

Oleg.

--- arch/x86/kernel/traps.c~	2009-12-18 00:20:49.000000000 +0100
+++ arch/x86/kernel/traps.c	2009-12-18 01:44:05.000000000 +0100
@@ -575,7 +575,7 @@ dotraplinkage void __kprobes do_debug(st
 		regs->flags &= ~X86_EFLAGS_TF;
 	}
 	si_code = get_si_code(tsk->thread.debugreg6);
-	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
+//	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
 

