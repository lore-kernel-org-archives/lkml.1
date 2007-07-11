Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXGKAHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXGKAHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763383AbXGKAHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:07:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:48963 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763315AbXGKAHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tS3jLYY4rU/0aTUQGyODXxVqRL2iG6HJZzqd8GrqQOCCpsaU3rJeU0V5etZ8wga8obtzWDvU8rP4Q5IC/D+4B35rkGrlomdW4yRcZC/SG0LMtqKWZc3aAZ4n0gTP81YK/jCw4whneXYnWSZJs3m4fHiZk403E/fKhz+1jCQy3J0=
Message-ID: <a781481a0707101707w121da1b7hc82dc0e3638e4570@mail.gmail.com>
Date: Wed, 11 Jul 2007 05:37:02 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [PATCH 17/20] SMP: Implement on_cpu()
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       KVM <kvm-devel@lists.sourceforge.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <46936766.20900@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11838956891287-git-send-email-avi@qumranet.com>
	 <p73lkdqzpdm.fsf@bingen.suse.de> <4691D9C1.4050309@qumranet.com>
	 <20070709071640.GB10864@one.firstfloor.org>
	 <46920270.3080309@qumranet.com> <46921BE9.4040801@qumranet.com>
	 <a781481a0707091224s3fb1a2acr6d3ccce091480f61@mail.gmail.com>
	 <4693211D.4040406@qumranet.com>
	 <a781481a0707100222k4f204ed8gfd4823bc21b7bf25@mail.gmail.com>
	 <46936766.20900@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Avi Kivity <avi@qumranet.com> wrote:
> Satyam Sharma wrote:
> > On 7/10/07, Avi Kivity <avi@qumranet.com> wrote:
> >> Satyam Sharma wrote:
> >> >
> >> >
> >> > On 7/9/07, Andi Kleen <andi@firstfloor.org> wrote:
> >> >> [...]
> >> >> on_each_cpu() was imho always a mistake. It would have been better
> >> >> to just fix smp_call_function() directly
> >> >
> >> > I'm not sure what you mean by "fix" here, but if you're proposing
> >> > that we change smp_call_function() semantics to _include_ the
> >> > current CPU (and just run the given function locally also along
> >> > with the others -- and hence get rid of on_each_cpu) then I'm sorry
> >> > but I'll have to *violently* disagree with that. Please remember that
> >> > the current CPU _must_ be treated specially in a whole *lot* of
> >> > usage scenarios ...
> >>
> >> I imagine that by "fix" Andi means also updating all callers.  Otherwise
> >> he would just have said "break".
> >
> > But that's the point. How do you plan / intend to update
> > smp_send_stop()?
>
> Well, I don't plan to do anything to smp_call_function().

Thanks, I wish smp_call_function_single() could be left alone as well,
different semantics of the two would be ugly and only breed confusion.

> I imagine you
> can add a flag, or compare smp_processor_id() to the cpu that's not
> stopping, or use smp_call_function_mask().

Ok, so what we (presently) have is:

1. smp_call_function() -> run given function on all *other* CPUs
2. on_each_cpu() -> run given function on _all_ CPUs

This is perfectly fine, and serves all possible use cases.

And I think what's proposed is:

1. Change smp_call_function() semantics, to run given function
on _all_ CPUs (thus getting rid of the on_each_cpu() "mistake")

2. Resort to (most probably implement another function?) using
smp_call_function_mask() or flags appropriately to also serve
the use cases where we need to run a given function on all
_other_ CPUs

Does this pointless/gratuitous code-churn really make sense?
Definitely not to me ...

[ For the _single() case we now have on_cpu() as you originally
proposed, which I definitely like and fills the other gap in the API. ]

So I still don't quite understand what is the need to change existing
semantics of smp_call_function{_single} in the first place.

> > More importantly, what's wrong with it in the first place (to "fix")?
>
> If most use cases want to run a function on all cpus, they shouldn't
> need to open code it.

We already have on_each_cpu() for precisely such usage. I don't see
what / why would someone be open-coding ...

> >> > On 7/9/07, Andi Kleen <andi@firstfloor.org> wrote:
> >> >> > I think it would be better to fix smp_call_function_single to just
> >> >> > handle this case transparently. There aren't that many callers yet
> >> >> > because it is
> >> >> > fairly new.
> >> >
> >> > Take the same example here -- let's say we want to send a
> >> > "for (;;) ;" kind of function to a specified CPU. Now let's say
> >> > by the time we've called smp_call_function_single() on that
> >> > target CPU, we're preempted out and then get rescheduled
> >> > on the target CPU itself. There, we begin executing the
> >> > smp_call_function_single() (as modified by Avi here with your
> >> > proposed changed semantics) and notice that we've landed
> >> > on the target CPU itself, execute the suicidal function
> >> > _locally_ *in current thread* itself, and ... well, I hope you
> >> > get the picture.
> >>
> >> So you disable preemption before calling smp_call_function_single().
> >
> > Which is what on_cpu() and which is why I like that.
> >
> > And which is *not* what Andi's proposal (or your later patch
> > implementing that proposal) does, and which is why I *don't*
> > like that.
>
> It does disable preemption.  Look more carefully.

But for a different reason. You've confused existing and the
proposed/new semantics of smp_call_function_single() here.

* Existing semantics:

Why is disabling preemption *compulsory* for correctness with
existing smp_call_function_single semantics?

Because we want to _detect_ (and WARN() + return error) for cases
when the _caller_ failed to disable preemption => by the time we
execute smp_call_function_single, we (current thread) could
actually have gone over to the target CPU (which is illegal with
existing semantics), so we need to check for that and warn.

Now, note that disabling preemption in smp_call_function{_single}
themselves is *insufficient*. We could be running on the target
CPU _already_ by the time we disable preemption inside those
functions. We'd end up finding this, WARN'ing about it, returning
an error -- all that could've been avoided if only the _caller_ had
the good sense to disable preemption _before_ calling smp_...()

So the *only* sane way (with existing semantics) to call the
smp_...() functions is to do that with preemption disabled in
the _caller_.

* Proposed semantics:

Here, we just don't care about what CPU we are on when we're
executing smp_call_function_single() -- if we're on the target
CPU, we'll just execute the function locally (in current thread
itself) else we'll fire off the IPI to get it executed on the target
CPU.

Of course, to make the decision above, we would need to have
a "if (current_cpu == target_cpu)" kind of check, and there's no
safe way to obtain "current_cpu" without disabling preemption --
so *that* is why the proposed code did the get_cpu() /
preemption-disabling inside smp_call_function_single().

> >> > So my opinion is to go with the get_cpu() / put_cpu() wrapper
> >> > Avi is proposing here and keep smp_call_function{_single}
> >> > semantics unchanged. [ Also please remember that for
> >> > *correctness*, preemption needs to be disabled by the
> >> > _caller_ of smp_call_function{_single} functions, doing so
> >> > inside them is insufficient. ]
> >>
> >> That's not correct.  kvm has two places where you can call the new
> >> smp_call_function_single() (or on_cpu()) without disabling preemption.
> >
> > on_cpu() _is_ the wrapper that does the necessary get_cpu()
> > (i.e. preemption-disabling wrap over smp_call_function_single).
> >
> > Obviously a caller of on_cpu() does not need to disable preemption.
>
> Neither does the caller of the new smp_call_function_single().  Look at
> the code.

As I said, that's because the caller wouldn't _care_ with the new
semantics.

Anyway, I don't really care enough about this (I'm not writing any code
that could get directly affected by all this) to continue objecting to the
proposed change. All I'm pointing out is just that it's unnecessary, and
I suspect nobody likes code churn just for the sake of it.

Satyam
