Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZBFTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZBFTtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZBFTtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:49:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57890 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZBFTtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:49:05 -0500
Date: Fri, 6 Feb 2009 14:49:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 1/7] ring-buffer: add NMI protection for spinlocks
In-Reply-To: <20090206194030.GB32652@Krystal>
Message-ID: <alpine.DEB.1.10.0902061446390.22636@gandalf.stny.rr.com>
References: <20090206152151.962749733@goodmis.org> <20090206152720.441757059@goodmis.org> <20090206194030.GB32652@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 6 Feb 2009, Mathieu Desnoyers wrote:
> >  
> >  	commit_page = cpu_buffer->commit_page;
> >  	/* we just need to protect against interrupts */
> > @@ -995,7 +1026,19 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
> >  		struct buffer_page *next_page = tail_page;
> >  
> >  		local_irq_save(flags);
> > -		__raw_spin_lock(&cpu_buffer->lock);
> > +		/*
> > +		 * NMIs can happen after we take the lock.
> > +		 * If we are in an NMI, only take the lock
> > +		 * if it is not already taken. Otherwise
> > +		 * simply fail.
> > +		 */
> > +		if (unlikely(__get_cpu_var(rb_in_nmi))) {
> > +			if (!__raw_spin_trylock(&cpu_buffer->lock))
> > +				goto out_unlock;
> 
> Hi Steven,
> 
> You're not silently discarding an event, aren't you ? ;)
> 
> Please keep at least a count of "events_lost" so it can be reported
> later by a printk().

I could add a counter here, but it is not a silent discard. The tracer 
would receive a "NULL" pointer in this case. Then the tracer can do what 
it wants with this information. The ring buffer will never discard data 
(otherwise it is a bug) without letting the tracer know that it did so.

-- Steve

