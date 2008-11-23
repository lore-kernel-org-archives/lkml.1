Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYKWTgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYKWTgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYKWTgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:36:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbYKWTgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:36:00 -0500
Date: Sun, 23 Nov 2008 20:35:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: don't trace kfree
	while it frees the return stack
Message-ID: <20081123193554.GC2794@elte.hu>
References: <492985C8.7070205@gmail.com> <20081123164013.GC6206@elte.hu> <alpine.DEB.1.10.0811231237470.13888@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811231237470.13888@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Sun, 23 Nov 2008, Ingo Molnar wrote:
> > > 
> > > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > > index 90d99fb..ffff7ec 100644
> > > --- a/kernel/trace/ftrace.c
> > > +++ b/kernel/trace/ftrace.c
> > > @@ -1628,8 +1628,9 @@ void ftrace_retfunc_init_task(struct task_struct *t)
> > >  
> > >  void ftrace_retfunc_exit_task(struct task_struct *t)
> > >  {
> > > -	kfree(t->ret_stack);
> > > +	struct ftrace_ret_stack	*ret_stack = t->ret_stack;
> > >  	t->ret_stack = NULL;
> > > +	kfree(ret_stack);
> > 
> > heh, nice one :)
> > 
> > note that we also need to keep gcc from reordering things here (no 
> > matter how unlikely in this particular case).
> 
> I first thought that too, but thinking about it, if gcc does do that, then
> it will break the logic for a correct C program.
> 
> t is passed in as a pointer, then it modifies the contents of t 
> (which could be a global pointer), then it calls a external 
> function, that might also reference the global pointer.
> 
> This means that if it were to reorder the two, it would break C, 
> because the compiler can not assume that the called function will 
> read the global pointer either.
> 
> In other words, the compiler should not need to worry about SMP or 
> modifications done by interrupts or other threads. But the compiler 
> should always preserve the order that is assumed by a single 
> context.

Correct, but this assumes that kfree is a C function. Which it might 
not necessarily be: it could be optimized via an inline in certain 
cases, etc. It's best to document such cases explicitly.

In any case, the real solution is what i suggested in the previous 
mail, to do the freeing from the task-struct freeing path in 
kernel/fork.c:free_task() - that has other advantages as well.

	Ingo
