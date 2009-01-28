Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZA1XlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZA1XlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZA1XlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:41:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZA1XlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:41:09 -0500
Date: Wed, 28 Jan 2009 18:41:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Buggy IPI and MTRR code on low memory
In-Reply-To: <200901290955.38940.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0901281835090.7408@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <200901290955.38940.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 29 Jan 2009, Rusty Russell wrote:

> On Thursday 29 January 2009 03:08:14 Steven Rostedt wrote:
> > 
> > While developing the RT git tree I came across this deadlock.
> > 
> > To avoid touching the memory allocator in smp_call_function_many I forced 
> > the stack use case, the path that would be taken if data fails to 
> > allocate.
> > 
> > Here's the current code in kernel/smp.c:
> 
> Interesting.  I simplified smp_call_function_ma{sk,ny}, and introduced 
> this bug (see 54b11e6d57a10aa9d0009efd93873e17bffd5d30).

No, I think the bug existed before you simplified it. In fact, I'm 
currently working on 2.6.28 where I hit the bug. I actually backported 
part of that commit to implement this.

> 
> We used to wait on OOM, yes, but we didn't do them one at a time.
> 
> We could restore that quiesce code, or call a function on all online 
> cpus using on-stack data, and have them atomic_dec a counter when 
> they're done (I'm not sure why we didn't do this in the first place: 
> Nick?)
> 
> > The problem is that if we use the stack, then we must wait for the 
> > function to finish. But in the mtrr code, the called functions are waiting 
> > for the caller to do something after the smp_call_function. Thus we 
> > deadlock! This mtrr code seems to have been there for a while. At least 
> > longer than the git history.
> 
> I don't see how the *ever* worked then, even with the quiesce stuff.

It didn't ;-)

> 
> > The patch creates another flag called CSD_FLAG_RELEASE. If we fail
> > to alloc the data and the wait bit is not set, we still use the stack
> > but we also set this flag instead of the wait flag. The receiving IPI 
> > will copy the data locally, and if this flag is set, it will clear it. The 
> > caller, after sending the IPI, will wait on this flag to be cleared.
> 
> Doesn't this break with more than one cpus?  I think a refcnt is needed 
> for the general case...

I only use it on a single cpu call. This was what I backported from your 
patch. I still have the first alloc (ifdef out for RT), but the fall back 
goes to single CPU mode, one at a time.

void smp_call_function_many(const struct cpumask *mask,
                            void (*func)(void *), void *info,
                            bool wait)
{
        struct call_function_data *data;
[...]
        data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
        if (unlikely(!data)) {
                /* Slow path. */
                for_each_online_cpu(cpu) {
                        if (cpu == smp_processor_id())
                                continue;
                        if (cpumask_test_cpu(cpu, mask))
                                smp_call_function_single(cpu, func, info, wait);
                }
                return;
        }


I only needed to handle the single cpu case. Yes, this is slow because it 
would need to wait for each individual CPU before going to the next. But 
it at least is a work around.

-- Steve

