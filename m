Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZA1WIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZA1WIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZA1WI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:08:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbZA1WI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:08:27 -0500
Date: Wed, 28 Jan 2009 14:07:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, peterz@infradead.org, arjan@infradead.org,
       rusty@rustcorp.com.au, jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
Message-Id: <20090128140725.782f5cc1.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901281621450.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	<20090128131202.21757da6.akpm@linux-foundation.org>
	<20090128131327.417b01e1.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0901281621450.25359@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 16:23:32 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 28 Jan 2009, Andrew Morton wrote:
> 
> > On Wed, 28 Jan 2009 13:12:02 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > Thought: do we need to do the kmalloc at all?  Perhaps we can instead
> > > use a statically allocated per-cpu call_single_data local to
> > > kernel/smp.c?  It would need a spinlock or something to protect it...
> > 
> > (not a spinlock - get_cpu_var/put_cpu_var will suffice)
> 
> Is that enough?
> 
> The calling IPIs may process the data after smp_call_function is made. 
> What happens if two smp_call_functions are executed one after the other? 
> The second one may corrupt the data if the IPI function has not executed 
> yet.
> 
> We may still need that "RELEASE" flag for that case.
> 

Good point.

Forget I said that - smp_call_function_single() is calling a function
on a *different* CPU, so data which is local to the calling CPU is of
course in the wrong place.

So if we're going to use per-cpu data then we'd need to protect it with
a lock.  We could (should?) have a separate lock for each destination
CPU.

We could make smp_call_function_single() block until the IPI handler
has consumed the call_single_data, in which case we might as well put
the call_single_data, onto the caller's stack, as you've done.

Or we could take the per-cpu spinlock in smp_call_function_single(),
and release it in the IPI handler, after the call_single_data has been
consumed, which is a bit more efficient.  But I have a suspicion that
this is AB/BA deadlockable.

<tries to think of any scenarios>

<fails>

So we have

smp_call_function_single(int cpu)
{
	spin_lock(per_cpu(cpu, locks));
	per_cpu(cpu, call_single_data) = <stuff>
	send_ipi(cpu);
	return;
}

ipi_handler(...)
{
	int cpu = smp_processor_id();
	call_single_data csd = per_cpu(cpu, call_single_data);

	spin_unlock(per_cpu(cpu, locks));
	use(csd);
}

does that work?

Dunno if it's any better than what you have now.  It does however
remove the unpleasant "try kmalloc and if that failed, try something
else" mess.

