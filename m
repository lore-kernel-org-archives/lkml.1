Return-Path: <linux-kernel-owner+w=401wt.eu-S934042AbZKYBea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042AbZKYBea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbZKYBe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:34:29 -0500
Received: from www.tglx.de ([62.245.132.106]:53115 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758112AbZKYBe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:34:28 -0500
Date: Wed, 25 Nov 2009 02:23:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Dimitri Sivanich <sivanich@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
In-Reply-To: <m1ljhvwmiu.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.0911250110030.24119@localhost.localdomain>
References: <20091120211139.GB19106@sgi.com> <m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com> <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain> <1259069986.4531.1453.camel@laptop> <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
 <20091124065022.6933be1a@infradead.org> <m1ws1f6csh.fsf@fess.ebiederm.org> <20091124214121.GA15182@sgi.com> <alpine.LFD.2.00.0911242243160.24119@localhost.localdomain> <m1ljhvwmiu.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Tue, 24 Nov 2009, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > Please do not put anything complex into x86 code at all. Such designs
> > are likely to happen on other architectures and as I said before we
> > want to have
> >
> > 1) the decision function what's valid and not in the generic code
> 
> For the UV problem I don't have an issue.    assign_irq_vector
> enforces some rules that I don't see being able to expose
> to user space.

How is that related to user space ? All I'm asking for is to move the
decision to the generic code and not add more stuff to x86/*.

This UV problem is currently unique, but it's going to pop up all over
the place.
 
> > 2) a way to expose that information as part of the irq interface to
> >    user space.
> 
> -EINVAL?

Err ? What's your problem with telling user space that an irq is
restricted to a certain set of CPUs ?

> > So what's wrong with a per irq_chip function which returns the cpumask
> > which is valid for irq N ?
> 
> I have no problems with a generic function to do that.
> 
> > That function would be called to check the affinity mask in
> > set_irq_affinity and to dump the mask to /proc/irq/N/possible_cpus or
> > whatever name we agree on.
> >
> > That way we don't have to worry about where in the x86 code the
> > decision should reside as you simply would always get valid masks from
> > the core code.
> 
> Impossible.  assign_irq_vector is the only function that can tell you
> if a mask is valid or not.  Currently we support roughly 240 irqs
> per cpu.  Currently we support more than 240 irqs.

Interesting.

> I don't see how you can enforce that limit.

-ENOPARSE. Please excuse my limited ability to decode crypt_eric

> Furthermore irq migration on x86 is a very non-trivial exercise.

Thanks for the education, that's really new information to me.

> We must wait until we get a new irq at the new location before
> we cleanup the irq state at the old location, to ensure that the
> state change has gone through.  At which point again we can not
> know.

Know what? 
 
> So Thomas the logical conclusion that you are requesting.  An
> architecture specific interface for migrating irqs that does not
> need to return error codes because the generic code has enough
> information to avoid all problem cases is not going to happen.
> It is totally unreasonable.

I did never request that at all. All I'm asking for is that we think
more about having decision functions which are valuable for more than
one esoteric use case like UV moved into generic code instead of
hacking them into some architecture space.

> > That just works and is neither restricted to UV nor to x86.
> 
> Doing it all in the core totally fails as it gets the initial irq
> assignment wrong.

That's fixable. And I did not say that these decision functions can
only be used by the generic code, they can be used to do final or
initial decisions in the low level code as well. I'm just fighting
that you folks think that your problems are so unique that they need
to be solved in special ways.
 
> Last I looked set_irq_affinity was a horribly broken interface.  We
> can not return error codes to user space when they ask us to do the
> impossible.  Right now irq->affinity is a hint that occasionally we
> ignore when what it requests is impossible.

And that is a perfect excuse to refuse to think about improvements or
a reasonable replacement for that interface ?
 
> Thomas my apologies for ranting but I am extremely sensitive about
> people placing demands on the irq code that would be very convenient
> and simple for the rest of the world, except that the hardware does not
> work the way people envision it should work.  The worst offender is
> the cpu hotunplug logic that requests we perform the impossible when
> it comes to irq migration.  In the case of UV I expect cpu hotplug is
> going to request we migrate irqs to another node.

Sure, and the proper way to fix that is the arch/x86 code, right ?

> Right now a lot of the generic irq code is living in a deluded fantasy and
> I really don't want to see more impossible requests from the irq code
> added to the pile.

Sorry dude. _You_ are living in the delusion that your problems are
unique and can only be solved by adding special crafted hackery to
everything. You simply refuse to go the hard way of proving that it is
impossible to solve for the benefit of everyone just on the base of
handwaving and claiming that you are the only expert who understands
all the details of interrupt handling.

> The architecture specific function setup_irq_vector has all of the
> information available to it to make the decision.  We use it
> consistently everywhere.  For the case of UV it needs to know about
> another possible hardware limitation, to do it's job.  I am happy
> if that information comes from an architecture agnostic source but
> making the decision somewhere else is just a guarantee that we will
> have more subtle breakage that occasionally fail for people but at
> too low a rate that people will care enough to fix.

You are completely ignoring the fact, that the deluded people who
started to work on a generic irq subsystem actually had and still have
very good reasons to do so and do have a not so deluded insight into
the general and also the x86 specific problem space.

I'm well aware that every generic interface has short comings, but we
are in the kernel space where we can fix things if we _want_ and work
together on doing so.

It's just impossible to do that with people who insist on their
particular world view and I'm not talking about you alone. The same
applies to the embedded crowd and driver folks who permanentely insist
on implementing "workarounds" instead of talking to the people who are
responsible and willing to fix things.

Thanks,

	tglx
