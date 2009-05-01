Return-Path: <linux-kernel-owner+w=401wt.eu-S1762248AbZEAO2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762248AbZEAO2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbZEAO2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:28:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52595 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZEAO2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:28:14 -0400
Date: Fri, 1 May 2009 10:28:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter
 atomic
In-Reply-To: <20090501134234.GG6011@nowhere>
Message-ID: <alpine.DEB.2.00.0905011023580.20374@gandalf.stny.rr.com>
References: <20090501022210.851418183@goodmis.org> <20090501022403.826182932@goodmis.org> <20090501115047.GA24706@elte.hu> <20090501134234.GG6011@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Fri, 1 May 2009, Frederic Weisbecker wrote:

> On Fri, May 01, 2009 at 01:50:47PM +0200, Ingo Molnar wrote:
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > The entries counter in cpu buffer is not atomic. Although it only 
> > > gets updated by a single CPU, interrupts may come in and update 
> > > the counter too. This would cause missing entries to be added.
> > 
> > > -	unsigned long			entries;
> > > +	atomic_t			entries;
> > 
> > Hm, that's not really good as atomics can be rather expensive and 
> > this is the fastpath.
> > 
> > This is the upteenth time or so that the fact that we do not disable 
> > irqs while generating trace entries bites us in one way or another. 
> > IRQs can come in and confuse function trace output, etc. etc.
> > 
> > Please lets do what i suggested a long time ago: disable irqs _once_ 
> > in any trace point and run atomically from that point on, and enable 
> > them once, at the end.
> > 
> > The cost is very small and it turns into a win immediately by 
> > elimination of a _single_ atomic instruction. (even on Nehalem they 
> > cost 20 cycles. More on older CPUs.) We can drop the preempt-count 
> > disable/enable as well and a lot of racy code as well. Please.
> > 
> > 	Ingo
> 
> 
> I also suspect one other good effect on doing this.
> 
> As you know, between a lock_reserve and a discard, several interrupts
> can trigger some traces. It means that if some rooms have already been
> reserved, the discard will really create a discarded entry and we
> can't reuse it.
> 
> For example in the case of filters with lock tracing, we rapidly run
> into entries overriden, making the lock events tracing about useless
> because we rapidly lose everything.

If you want, we can disable interrupts from the event tracer, not the ring 
buffer.

We would have to go back to the original ring buffer code that passed in 
flags.

> 
> At least that's an effect I observed. I'm not sure the discard is the
> real cause but it seems to make sense.
> 
> That's a pity because believe me it is very useful to hunt a softlockup.
> 
> Of course it doesn't prevent from NMI tempest, but we already have
> protections for that.

If we do not allow interrupts to be traced, we can not allow NMIs either. 
If we do not let the ring buffer be re-entrant, then we will not be able 
to trace any NMI (to be safe).

Going this route, there would be no need to make a lockless ring buffer 
either.

-- Steve

