Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYFXHBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYFXHBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbYFXHB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:01:29 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:18514 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766AbYFXHB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=AWIRlcaJNchEXnzkJ+m/BqwPpmrkAxL0DkqcbYiVRQQnTTErHkgzMD5HZtaru0Zpg5
         4IPdIhuGAwCuTGz+6pUCeaGU0Y/wd6TCIaPfYEHgZ85r5mTD3WjYiJElQvqMBIJCevZP
         X6W8G5tycFDpgx3Os4xJHsWNDOP1yIPjEtnoU=
Message-ID: <505766fa0806240001o19f981b9i8f1577e5d2a01eb8@mail.gmail.com>
Date: Tue, 24 Jun 2008 15:01:26 +0800
From: hyl <heyongli@gmail.com>
To: john.blackwood@ccur.com, mingo@elte.hu
Subject: [patch][RFC] an early patch for x86_64 preempt-rt kernel cause more __might_sleep warnings
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, John

[Sorry resend this mail, with pure text format and CC to Linux-kernel. ]

I saw you submitted a patch for X86_64 to prevent a oops, here is the
hyper-link i google:
http://marc.info/?l=git-commits-head&m=113979973412652&w=2

There is an obvious problem for your patch , see my comment at  "=====>"

/* runs on IST stack. */
asmlinkage void __kprobes do_debug(struct pt_regs * regs,
                   unsigned long error_code)
{

- conditional_sti(regs);
+ preempt_conditional_sti(regs);


       force_sig_info(SIGTRAP, &info, tsk);=====> /*this function try
spin_lock_irqsave(&t->sighand->siglock, flags); generate more
warnings*/


clear_dr7:
set_debugreg(0UL, 7);
+ preempt_conditional_cli(regs);
return;

clear_TF_reenable:
set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
regs->eflags &= ~TF_MASK;
+ preempt_conditional_cli(regs);

}


here is the trace result, founded on linux2.6.25.4 with realtime
patch(not only do_debug, do_int3,do_stack_segment also has same
problem ):

BUG: sleeping function called from invalid context
usermode-agent(2302) at kernel/rtmutex.c:626

in_atomic():1 [00000001], irqs_disabled():0

Call Trace:
<#DB>  [<ffffffff80227177>] __might_sleep+0x107/0x110
[<ffffffff804ec510>] __rt_spin_lock+0x30/0x60
[<ffffffff804ec549>] rt_spin_lock+0x9/0x10

[<ffffffff8023cf2f>] force_sig_info+0x2f/0xd0
[<ffffffff8020cdab>] do_debug+0x17b/0x220
[<ffffffff804ed1b3>] debug+0x93/0x9f
<<EOE>>

Posssible way to resolve such problem:

1. relpace task->sighand->siglock  as raw_spin_lock_t
    but this will  reduce the preemptive kernel code size

2. if possible, call  preempt_conditional_cli before call force_sig_info
    but we must sure the John's bug not be re-introduce by such action

please don't hesitate to tell me the best solution if you got the good idea.


Best Wishes
hyl
