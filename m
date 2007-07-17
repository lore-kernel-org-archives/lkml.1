Return-Path: <linux-kernel-owner+w=401wt.eu-S933508AbXGQROZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbXGQROZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXGQROK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:14:10 -0400
Received: from mail.screens.ru ([213.234.233.54]:55779 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbXGQROI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:14:08 -0400
Date: Tue, 17 Jul 2007 21:15:35 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <76306.1226@compuserve.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: Q: a bogus set_fs(USER_DS) in setup_frame/setup_rt_frame ?
Message-ID: <20070717171535.GA431@tv-sign.ru>
References: <20070717154638.GA342@tv-sign.ru> <alpine.LFD.0.999.0707170902570.19166@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707170902570.19166@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17, Linus Torvalds wrote:
> 
> On Tue, 17 Jul 2007, Oleg Nesterov wrote:
> >
> > I am really puzzled by set_fs(USER_DS) in setup_frame/setup_rt_frame.
> > 
> > How is it possible that current->addr_limit != USER_DS ? If this _is_
> > possible, how can can we trust the result of access_ok() above?
> 
> Heh. I think it's entirely historical.
> 
> Please realize that the whole reason that function is called "set_fs()" is 
> that it literally used to set the %fs segment register, not 
> "->addr_limit".
> 
> So I think the "set_fs(USER_DS)" is there _only_ to match the other
> 
>         regs->xds = __USER_DS;
>         regs->xes = __USER_DS;
>         regs->xss = __USER_DS;
>         regs->xcs = __USER_CS;
> 
> things, and never mattered.

Thanks!

> And now it matters even less, and has been 
> copied to all other architectures where it is just totally insane.

Yes.

Also, sparc does something strange with do_sigaltstack(). It first copies
stack_t to the local variable, then sets KERNEL_DS to access it from
do_sigaltstack().

IOW, what's wrong with the patch below? Why should we ignore errors other
than -EFAULT?

Oleg.

--- arch/sparc64/kernel/signal.c~	2007-05-21 13:57:49.000000000 +0400
+++ arch/sparc64/kernel/signal.c	2007-07-17 21:04:32.000000000 +0400
@@ -291,7 +291,6 @@ void do_rt_sigreturn(struct pt_regs *reg
 	__siginfo_fpu_t __user *fpu_save;
 	mm_segment_t old_fs;
 	sigset_t set;
-	stack_t st;
 	int err;
 
 	/* Always make any pending restarted system calls return -EINTR */
@@ -327,20 +326,13 @@ void do_rt_sigreturn(struct pt_regs *reg
 		err |= restore_fpu_state(regs, &sf->fpu_state);
 
 	err |= __copy_from_user(&set, &sf->mask, sizeof(sigset_t));
-	err |= __copy_from_user(&st, &sf->stack, sizeof(stack_t));
-	
+	err |= do_sigaltstack(&st->stack, NULL, (unsigned long)sf);
+
 	if (err)
 		goto segv;
-		
+
 	regs->tpc = tpc;
 	regs->tnpc = tnpc;
-	
-	/* It is more difficult to avoid calling this function than to
-	   call it and ignore errors.  */
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-	do_sigaltstack((const stack_t __user *) &st, NULL, (unsigned long)sf);
-	set_fs(old_fs);
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
 	spin_lock_irq(&current->sighand->siglock);

