Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbYKRO6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbYKRO6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYKRO6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:58:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYKRO6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:58:42 -0500
Date: Tue, 18 Nov 2008 09:58:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
 field
In-Reply-To: <20081118144838.GB30358@elte.hu>
Message-ID: <alpine.DEB.1.10.0811180951410.15003@gandalf.stny.rr.com>
References: <4920D571.4050007@gmail.com> <20081117084923.GD28786@elte.hu> <alpine.DEB.1.10.0811180918480.15003@gandalf.stny.rr.com> <20081118144838.GB30358@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > I was just looking at the stack tracer, and it pretty much gives us 
> > the answer ;-) I'm hitting on max traces around 55, but some of 
> > those are asm calls. We could do 50 or 60?  We probably want to make 
> > sure that the two do not come close to hitting. That is, the bottom 
> > of the stack to overwrite the saved return addresses.
> 
> does the stack tracer properly nest across IRQ entry boundaries 
> already on x86? We used to have problems in that area.

Actually, because the stack tracer is in generic code, we punt on IRQ 
stacks:

	/* we do not handle interrupt stacks yet */
	if (!object_is_on_stack(&this_size))
		return;

I check if the local variable "this_size" is on the current->stack and if 
it is not then this means that we are using some other stack, and we do 
not record it.

What would be needed is to make a per-arch stack call. Perhaps have a:

   arch_check_stack(&this_size, &max_stack_trace, &max_stack_size);

Where a weak function can be defined to return nothing. But the arch can 
check which stack the "this_size" variable is on and run the stack tracer 
against that stack.

Maybe we should have two stack traces, a stack_trace file and a 
stack_trace_irq ?

Because, some archs, like x86_64 have different size stacks. The thread 
stack is 8K where as the IRQ stack is 4K.  We may want to see which IRQ 
stack call is the worst, and not compare it to the thread stack call.

-- Steve

