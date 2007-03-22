Return-Path: <linux-kernel-owner+w=401wt.eu-S965512AbXCVAJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512AbXCVAJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965519AbXCVAJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:09:30 -0400
Received: from ozlabs.org ([203.10.76.45]:59599 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965512AbXCVAJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:09:29 -0400
Subject: Re: [PATCH] Allow per-cpu variables to be page-aligned
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <m11wjiczje.fsf@ebiederm.dsl.xmission.com>
References: <1174457426.11680.132.camel@localhost.localdomain>
	 <m1ejnjc5qa.fsf@ebiederm.dsl.xmission.com>
	 <1174477457.11680.170.camel@localhost.localdomain>
	 <m11wjiczje.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 11:09:12 +1100
Message-Id: <1174522152.2713.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 10:49 -0600, Eric W. Biederman wrote:
> Rusty Russell <rusty@rustcorp.com.au> writes:
> 
> > On Wed, 2007-03-21 at 03:21 -0600, Eric W. Biederman wrote:
> >> Do we really want to allow modules to be able to allocate page sized
> >> per cpu memory.
> >
> > Hi Eric!
> >
> > 	They always could, of course, they just wouldn't get correct alignment.
> > I think the principle of least surprise says that if we support this, it
> > will also work in modules...
> 
> The module load would fail.

Hi again Eric,

	Unfortunately not.  It probably should, though: people ignore printks.
I was probably thinking that large alignment constraints were only for
performance when I wrote this code, but a page-aligned requirement for
hypervisors changes that.

> > Looking at the module per-cpu code again, the rounding up of the memory
> > used by the kernel seems unnecessary though.  I'll try ripping that
> > out...
>
> I want to say that when dealing with cpu stuff aligning to a cache
> line makes sense as it prevents multiple variables from sharing
> the same cache line.  However we rarely access per cpu variables from
> other cpus (the point) so the extra alignment doesn't seem to have
> a justification in this context.

Um, yes, always good to remember.  I wrote the per-cpu infrastructure,
and I haven't forgotten 8)

> Although I'm not quite certain what this will do to the per cpu
> memory allocator...

It should Just Work.  My only hesitation is that I obviously thought
different when I wrote this code, so am I smarter now, or then?

> After increasing NR_IRQS on x86_64 to (NR_CPUS*32) the per cpu irq
> stats got much bigger especially as NR_CPUS went up.  The only
> reasonable way I could see to fix this at the time was to just make
> PER_CPU_ENOUGH_ROOM do the right thing and change size dynamically
> with the size of the per cpu section.  I added PERCPU_MODULE_RESERVE
> to allocate the amount that we did not have compile information on.
> 8K was roughly what we had left over for modules before I made the
> change so I just preserved that.

This makes a lot of sense.  A fixed constant seemed sensible at the
time, but now we know that the majority of per-cpu vars are in code
which can never be a module.  Reasons are obvious, and seem unlikely to
change.

> > It means the x86 cpu_pda initialization would have to be done in
> > smp_prepare_boot_cpu tho...
> 
> Well that is earlier than trap_init so it shouldn't be a problem...

But it doesn't get called on UP.  Don't know if that matters, but it
wasn't immediately obvious.

Thanks,
Rusty.

