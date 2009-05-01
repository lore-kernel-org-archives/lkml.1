Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbZEAOXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbZEAOXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZEAOXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:23:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55346 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbZEAOXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:23:43 -0400
Date: Fri, 1 May 2009 10:23:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter
 atomic
In-Reply-To: <20090501115047.GA24706@elte.hu>
Message-ID: <alpine.DEB.2.00.0905011016560.20374@gandalf.stny.rr.com>
References: <20090501022210.851418183@goodmis.org> <20090501022403.826182932@goodmis.org> <20090501115047.GA24706@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 May 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The entries counter in cpu buffer is not atomic. Although it only 
> > gets updated by a single CPU, interrupts may come in and update 
> > the counter too. This would cause missing entries to be added.
> 
> > -	unsigned long			entries;
> > +	atomic_t			entries;
> 
> Hm, that's not really good as atomics can be rather expensive and 
> this is the fastpath.

Actually, it could be local_t. I used that in a lot of the other places.
The race is with on CPU not other CPUs, and on archs like x86 there
is not cost of the "LOCK".

> 
> This is the upteenth time or so that the fact that we do not disable 
> irqs while generating trace entries bites us in one way or another. 
> IRQs can come in and confuse function trace output, etc. etc.

Note, this race is on a simple counter used for stats. It never was
exposed to user land except in the latency output, and that tracer 
disables interrupts anyway.

> 
> Please lets do what i suggested a long time ago: disable irqs _once_ 
> in any trace point and run atomically from that point on, and enable 
> them once, at the end.
> 
> The cost is very small and it turns into a win immediately by 
> elimination of a _single_ atomic instruction. (even on Nehalem they 
> cost 20 cycles. More on older CPUs.) We can drop the preempt-count 
> disable/enable as well and a lot of racy code as well. Please.

If we punt and simply disable interrupts in the ring buffer, I would then 
have to disable all tracing of NMIs. Yes it will make the code simpler, 
but the new code would also have:

ring_buffer_lock_reserve() {

	if (in_nmi())
		return NULL;

If that is acceptible, then fine. I'll make the change.

I will also throw away the lockless ring buffer since it would no long er 
be needed.

-- Steve

