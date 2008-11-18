Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYKRPDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYKRPDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYKRPC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:02:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33828 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYKRPC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:02:57 -0500
Date: Tue, 18 Nov 2008 16:02:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
	field
Message-ID: <20081118150249.GE30358@elte.hu>
References: <4920D571.4050007@gmail.com> <20081117084923.GD28786@elte.hu> <alpine.DEB.1.10.0811180918480.15003@gandalf.stny.rr.com> <20081118144838.GB30358@elte.hu> <alpine.DEB.1.10.0811180951410.15003@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811180951410.15003@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Tue, 18 Nov 2008, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > I was just looking at the stack tracer, and it pretty much gives us 
> > > the answer ;-) I'm hitting on max traces around 55, but some of 
> > > those are asm calls. We could do 50 or 60?  We probably want to make 
> > > sure that the two do not come close to hitting. That is, the bottom 
> > > of the stack to overwrite the saved return addresses.
> > 
> > does the stack tracer properly nest across IRQ entry boundaries 
> > already on x86? We used to have problems in that area.
> 
> Actually, because the stack tracer is in generic code, we punt on IRQ 
> stacks:
> 
> 	/* we do not handle interrupt stacks yet */
> 	if (!object_is_on_stack(&this_size))
> 		return;
> 
> I check if the local variable "this_size" is on the current->stack 
> and if it is not then this means that we are using some other stack, 
> and we do not record it.
> 
> What would be needed is to make a per-arch stack call. Perhaps have 
> a:
> 
>    arch_check_stack(&this_size, &max_stack_trace, &max_stack_size);
> 
> Where a weak function can be defined to return nothing. But the arch 
> can check which stack the "this_size" variable is on and run the 
> stack tracer against that stack.
> 
> Maybe we should have two stack traces, a stack_trace file and a 
> stack_trace_irq ?
> 
> Because, some archs, like x86_64 have different size stacks. The 
> thread stack is 8K where as the IRQ stack is 4K.  We may want to see 
> which IRQ stack call is the worst, and not compare it to the thread 
> stack call.

... and on 64-bit x86 the IRQ stacks are 16K, and some of the IST 
exception stacks have different sizes as well.

	Ingo
