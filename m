Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZBDQdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZBDQdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZBDQcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:32:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbZBDQcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:32:53 -0500
Date: Wed, 4 Feb 2009 17:32:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Norbert Preining <preining@logic.at>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
Message-ID: <20090204163213.GA25996@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12505
> > Subject		: 2.6.29-rc1 Firefox crashing on page load
> > Submitter	: Justin Madru <jdm64@gawab.com>
> > Date		: 2009-01-16 20:56 (20 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4217458dafaa57d8e26a46f5d05ab8c53cf64191
> > References	: http://marc.info/?l=linux-kernel&m=123213941914274&w=4
> > Handled-By	: Justin P. Mattock <justinmattock@gmail.com>
> 
> Heh. That commit you point to is very innocuous.
> 
> Commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191 is a pure cleanup, and it 
> _does_ make the code look nicer, but while it looks lik a total no-op, it 
> actually has a very subtle behavioural change: it makes gcc think that it 
> owns the whole argument stack. Which is _not_ true of 'asmlinkage' 
> functions, but we've never been able to tell gcc to keep its grubby hands 
> off our stack.
> 
> So I suspect that gcc inlines the function and then creates a function 
> call that re-uses the "struct pt_regs" on the stack as the argument area 
> too. Which corrupts the "pt_regs", and then we return to user space with 
> some random register contents.

yes - i tracked it down back then, just the regression entry didnt get 
updated.

> So I think we need to just revert it. Ingo, Hiroshi?

should be fixed upstream by:

 552b8aa: Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"

the revert commit is below with explaination - also with a Tested-by tag. 
The revert is not a pure revert - it also adds a comment to preserve this 
circumstance cleanly.

We first had a few fruitless attempts to annotate it in some clear fashion 
(the existing tailcall-avoidance macros we have didnt suit this case) - then 
went for the revert because none of the variants that told gcc not to screw 
up actually made the code better than it was originally.

	Ingo

-------------->
>From 552b8aa4d1edcc1c764ff6f61a7686347a2d1827 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 20 Jan 2009 09:31:49 +0100
Subject: [PATCH] Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"

This reverts commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191.

Justin Madru bisected this commit, it was causing weird Firefox
crashes.

The reason is that GCC mis-optimizes (re-uses) the on-stack parameters of
the calling frame, which corrupts the syscall return pt_regs state and
thus corrupts user-space register state.

So we go back to the slightly less clean but more optimization-safe
method of getting to pt_regs. Also add a comment to explain this.

Resolves: http://bugzilla.kernel.org/show_bug.cgi?id=12505

Reported-and-bisected-by: Justin Madru <jdm64@gawab.com>
Tested-by: Justin Madru <jdm64@gawab.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/syscalls.h |    2 +-
 arch/x86/kernel/signal.c        |   11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 9c6797c..c0b0bda 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -40,7 +40,7 @@ asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
 asmlinkage int sys_sigaltstack(unsigned long);
 asmlinkage unsigned long sys_sigreturn(unsigned long);
-asmlinkage int sys_rt_sigreturn(struct pt_regs);
+asmlinkage int sys_rt_sigreturn(unsigned long);
 
 /* kernel/ioport.c */
 asmlinkage long sys_iopl(unsigned long);
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 89bb766..df0587f 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -632,9 +632,16 @@ badframe:
 }
 
 #ifdef CONFIG_X86_32
-asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
+/*
+ * Note: do not pass in pt_regs directly as with tail-call optimization
+ * GCC will incorrectly stomp on the caller's frame and corrupt user-space
+ * register state:
+ */
+asmlinkage int sys_rt_sigreturn(unsigned long __unused)
 {
-	return do_rt_sigreturn(&regs);
+	struct pt_regs *regs = (struct pt_regs *)&__unused;
+
+	return do_rt_sigreturn(regs);
 }
 #else /* !CONFIG_X86_32 */
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
