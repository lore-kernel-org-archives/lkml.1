Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZA2B4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZA2B4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZA2B4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:56:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35613 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbZA2B4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:56:04 -0500
Date: Wed, 28 Jan 2009 20:56:01 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, npiggin@suse.de,
       torvalds@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, arjan@infradead.org
Subject: Re: [PATCH] use per cpu data for single cpu ipi calls
In-Reply-To: <20090128173039.cbc29e81.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901282041550.14733@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <200901290955.38940.rusty@rustcorp.com.au> <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com> <20090128173039.cbc29e81.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 Jan 2009, Andrew Morton wrote:

> On Wed, 28 Jan 2009 19:52:16 -0500 (EST)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > The smp_call_function can be passed a wait parameter telling it to
> > wait for all the functions running on other CPUs to complete before
> > returning, or to return without waiting. Unfortunately, this is
> > currently just a suggestion and not manditory. That is, the
> 
> "mandatory"

Some day I'll learn to use spell check.

> > 
> > Unfortunatly, some callers do no abide by this hint and act as if
> 
> "Unfortunately".

Unfortunately, not today.

> 
> Well that looks nice.

Thank you.

> 
> Can we make the spinlock a per-cpu thing as well?  Or is that
> over-optimising?  We'd need to initialise all those spinlocks at
> runtime.

I thought about it and thought it was over optimizing (US spelling).
But I could be wrong.

> 
> In generic_smp_call_function_single_interrupt(), did you consider
> releasing the "lock" _before_ calling the callback function?  That
> would reduces latencies a bit, allow more concurrency.  Maybe that's
> over-optimising too.

I thought about it too, but I wanted to avoid the coping of the data 
fields. Currently the callee does:

                   data = list_entry(list.next, struct call_single_data,
                                           list);
                   list_del(&data->list);

                   /*
                    * 'data' can be invalid after this call if
                    * flags == 0 (when called through
                    * generic_exec_single(), so save them away before
                    * making the call.
                    */
                    data_flags = data->flags;

                    data->func(data->info);

I would need to have a stack item like I did in my first release, and copy 
it.

	d = *data;
	smp_wmb();
	data->flags &= ~CDS_FLAG_LOCK;

	d->func(d->info).

I figured that the contention would only happen with a second caller. The
first caller does not have to wait. And I doubt that there would be many
instances of two callers contending. Matters how often smp_call_function 
is called.

Probably not enough contention to worry about.

> 
> Can generic_smp_call_function_single_interrupt() ever see
> CSD_FLAG_ALLOC set now?  If not, that kfree can go away.

Probably not, but I kept it just in case. I see there's a way a caller
can pass in their own data through

       generic_exec_single()

A user could potentially set the ALLOC flag. But since the enum is defined 
in this file, I find that highly unlikely. But looking at some of the code 
in the kernel, I would not be surprised if it is.

> 
> And where do we now stand with the architectures which _don't_ use the
> kernel/smp.c code?  If someone writes code in generic kernel which
> relies upon the new capabilities, it will go bad on those
> architectures.  Makes davem sad.

I guess someone should flag the arch list.

-- Steve

