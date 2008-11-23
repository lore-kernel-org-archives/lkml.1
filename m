Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYKWTZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYKWTZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbYKWTYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:24:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100AbYKWTYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:24:45 -0500
Date: Sun, 23 Nov 2008 14:24:42 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: don't trace kfree while
 it frees the return stack
In-Reply-To: <20081123164013.GC6206@elte.hu>
Message-ID: <alpine.DEB.1.10.0811231237470.13888@gandalf.stny.rr.com>
References: <492985C8.7070205@gmail.com> <20081123164013.GC6206@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 23 Nov 2008, Ingo Molnar wrote:
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 90d99fb..ffff7ec 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -1628,8 +1628,9 @@ void ftrace_retfunc_init_task(struct task_struct *t)
> >  
> >  void ftrace_retfunc_exit_task(struct task_struct *t)
> >  {
> > -	kfree(t->ret_stack);
> > +	struct ftrace_ret_stack	*ret_stack = t->ret_stack;
> >  	t->ret_stack = NULL;
> > +	kfree(ret_stack);
> 
> heh, nice one :)
> 
> note that we also need to keep gcc from reordering things here (no 
> matter how unlikely in this particular case).

I first thought that too, but thinking about it, if gcc does do that, then
it will break the logic for a correct C program.

t is passed in as a pointer, then it modifies the contents of t (which 
could be a global pointer), then it calls a external function, that might 
also reference the global pointer.

This means that if it were to reorder the two, it would break C, because 
the compiler can not assume that the called function will read the global 
pointer either.

In other words, the compiler should not need to worry about SMP or 
modifications done by interrupts or other threads. But the compiler should 
always preserve the order that is assumed by a single context.

-- Steve
