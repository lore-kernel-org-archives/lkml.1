Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYKDOoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYKDOoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYKDOoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:44:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbYKDOoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:44:09 -0500
Date: Tue, 4 Nov 2008 09:44:06 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: function tracer with irqs disabled
In-Reply-To: <20081104090405.GA507@elte.hu>
Message-ID: <alpine.DEB.1.10.0811040919060.4140@gandalf.stny.rr.com>
References: <20081104041554.605521183@goodmis.org> <20081104042203.499871423@goodmis.org> <20081104080747.GA27075@elte.hu> <20081104090405.GA507@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 4 Nov 2008, Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Running hackbench 3 times with the irqs disabled and 3 times with 
> > > the preempt disabled function tracer yielded:
> > > 
> > > tracing type       times            entries recorded
> > > ------------      --------          ----------------
> > > irq disabled      43.393            166433066
> > >                   43.282            166172618
> > >                   43.298            166256704
> > > 
> > > preempt disabled  38.969            159871710
> > >                   38.943            159972935
> > >                   39.325            161056510
> > 
> > your numbers might be correct, but i found that hackbench is not 
> > reliable boot-to-boot - it can easily produce 10% systematic noise 
> > or more. (perhaps depending on how the various socket data 
> > structures happen to be allocated)
> > 
> > the really conclusive way to test this would be to add a hack that 
> > either does preempt disable or irqs disable, depending on a runtime 
> > flag - and then observe how hackbench performance reacts to the 
> > value of that flag.
> 
> ... which is exactly what your patch implements :-)

Yep ;-)

Those numbers were done without any reboots in between. I even tried it
several times, randomly picking to use irqs_disabled and preempt_disabled,
and everytime preempt_disabled was around 39 secs, and irqs disabled was
around 43.

> 
> > note that preempt-disable will also produce less trace entries, 
> > especially in very irq-rich workloads. Hence it will be "faster".
> 
> this point still holds. Do we have any good guess about the 'captured 
> trace events per second' rate in the two cases, are they the same?

If you look at the end of my change log, I printed stats from a patch I 
added that counted the times that ftrace recursed, but did not record.
Those numbers were quite big with preempt_disabled.

>> With irq disabled: 1,150 times the function tracer did not trace due to
>>   recursion.
>> with preempt disabled: 5,117,718 times.

When we used the preempt disabled version, we lost 5 million traces, as 
suppose to the irq disabled which was only 1,150 traces lost.

Considering that we had 166,256,704 traces total, that 5 million is only 
4% lost of traces. Still quite a lot. But again, this is an extreme,
because we are tracing hackbench.

-- Steve

