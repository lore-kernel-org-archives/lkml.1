Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbXA2BeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbXA2BeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 20:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933086AbXA2BeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 20:34:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:45082 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933053AbXA2BeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 20:34:23 -0500
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeff Garzik <jeff@garzik.org>, Greg Kroah-Hartman <greg@kroah.com>,
       Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
References: <1169714047.65693.647693675533.qpush@cradle>
	 <m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	 <1170015805.26655.15.camel@localhost.localdomain>
	 <45BD0BDC.40205@garzik.org> <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
	 <1170022154.26655.63.camel@localhost.localdomain>
	 <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 12:33:12 +1100
Message-Id: <1170034392.26655.172.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> To be clear I see this as 2 distinct layers of code. enable/disable
> that talks directly to the hardware, and the helpers of enable/disable
> that allocate the irq.  I base this on the fact that I only need the
> alloc/free when I am exclusively working with real hardware.

We need the alloc/free in all cases, wether we are talking to real HW or
hypervisor. Alloc free is what allocates linux virtual irq numbers (or
irq_desc's if your prefer) and what sets up the irq_desc->irq_chip to
the appropriate thing for MSIs on that machines. Thus it's really the
required step for everybody.

The thing you seem to be mixing up is allocating of linux virtual irqs
(picking an irq desc) and allocating of a HW vectors on your platformn
(which happens to be the same pretty much on x86 nowdays no ? That is,
they have the same numbering domain don't they ?).

That is, while in the HV case, we don't allocate HW vectors (the HV does
it for us), we still need to allocate linux irqs, setup the irq desc,
and hook them up.

> > You seem to absolutely want to get the HV case to go throuh the same
> > code path as the "raw" case, and that will not happen.
> 
> Yes I do.  Because that is the only sane approach for a HV to use.

BUT WE DON'T HAVE A CHOICE ON WHAT APPROACH THE HV USES !!!! pfff...
Isn't that clear enough ?

IBM will not change their HV interfaces becasue you don't like them, and
I doubt sun will neither and despite you disagreeing on that, we -do-
have to support them (hell, that's what I'm paid for among other
things :-)

It would be nice if we could dictate all HV and hardware vendors around
how we think they should work and what interfaces they should provide, I
suppose M$ can do that with Windows, but unfortunately, we aren't in a
position to do that.
 
> And yes we need an irq allocator to call the HV to setup the upstream
> reception of the msi message.

Not sure I completely parse the above.

> However I don't think it will be to hard to support your HV once we get
> the real hardware supported.  I just refuse to consider it before we have
> figured out what makes sense in the context where we have to do everything.

Hrmph....

> >   .../... (irq operations)
> >
> >> These because they are per irq make sense as per bus operations unless
> >> you have a good architecture definition like x86 has.  Roughly those
> >> operations are what we currently have except the current operations
> >> are a little simpler and easier to deal with for the architecture
> >> code.
> >
> > Oh ? How so ? (easier/simpler ?)
> 
> I don't take a type parameter, and I don't take a vector.  All of
> that work is done in the generic code.

Well, so basically, the main difference is that we make MSI looks like
MSI-X by providing an alloc/free abstraction that takes an array in all
cases and you make MSI-X look like MSI by working one interrupt at a
time.

Your case avoids a for () loop in the backend, at the cost of being
fundamentally incompatible with our HV approach (and possibly others
like sparc64).

We do pass the MSI vs. MSI-X because it's handy for the HV case to pass
it along to the firmware, though it doesn't have to be used, and indeed,
in the "raw" case, we don't use it.
 
> > This is indeed a lower level hook to be used by "raw" enable/disable. An
> > other approach would be to remove it, have each backend have it's own
> > enable/disable that obtains the address/data and calls into a helper to
> > program them. This would indeed be a little bit nicer in a layering
> > perspective. But it adds a bit more code to each backend, so we kept
> > things closer to the way they used to be. I don't have a firm reason not
> > to change it however, I need talk to Michael in case he has more good
> > reasons to keep it that way around. 
> 
> The current code in the kernel already is structured that way because
> we have to reprogram the msi message on each irq migration.  Not using
> a helper to write the message would be a noticeable change and require
> a fair amount of code rewriting on the currently supported
> architectures.

We never proposed not to use a helper to write back the message. We are
missing such a helper in the current implementation, true, but that
doesn't mean we are opposed to havign it, on the contrary.

However, I don't think your implementation is much cleaner :-) The thing
is that Michael's implementation completely avoids having any knowledge
of the specifics of enabling/disabling MSI's or MSI-X's in the top level
core code.

The main difference after the alloc/free case is the enable/disable
case:

You do something like that: Toplevel calls the backend "setup" for each
MSI or MSI-X, which itself then calls back into a helper to actually
write the message, that helper doing then a switch/case on MSI vs. MSI-X
based on infos in the msi desc. Then, you go back to the toplevel which
goes whack the config space to atually do the global enabling of MSIs or
MSI-X.

Well, I don't think that from a layering perspective, that is much
nicer. Your toplevel is a mix of high level interface to the backend and
low level code specific to the "raw" implementation.

In fact, I preferred the way it was done previously in that area in the
sense that if you decide to have the "raw" implementation indeed be the
"default" one, then move it at the top level and call some hook to
obtain the address/value pair for each MSI. That doesn't preclude having
the low level write_msi_message() function still be exported for use by
the set_affinity callback.

Michael's approach is similar than the above except that instead of
having the raw implementation at the toplevel, it hooks is via
enable/disable/setup_msi_msg.
 
> Yes.  In general the mainline linux kernel does not support certain
> classes of stupidity.
> TCP offload engines, firmware drivers for
> hardware we care about, a fixed ABI to binary only modules, etc.
> It is the responsibility of the OS to setup MSI so we do it, not
> the firmware so we do it.
> 
> Not supporting stupid things that are hard to support encourages other
> people not to be so silly, especially when linux still works on the
> hardware when that silly feature isn't supported.

Not supporting IBM HV because of those idealistic reasons means not
supporting a whole range of IBM machines in linux since LSIs are
optional on PCI-E.

It's not just a performance difference. A whole set of hardware will
-not- work on those machines because somebody has an ideal view of the
world (heh, that's funny, that same person actively works on x86
support, damn, that's something less than ideal :-)

I think that's a bit of a lame attitude (without wanting to be
insulting). The same way we can't dictate HW vendors how to do their
stuff (we try to encourage them ,we try to teach them, but once the HW
is out and people use it, we do also try to actually support it). So
yes, we try to "fix" some of our HV stuff when we think it's too much
off the hook (for example, initial interfaces didn't allow to
differenciate MSI from MSI-X at all, we got that changed) but there's a
limit on our influence on these things (heh, they also have to support
other operating systems) and we can't just say "won't support you" when
the interfaces don't please us.

> For similar reasons we don't support more than 1 irq with a plain MSI
> capability.  

I never understood why we had this stupid limitation in our API. It
would have been easy enough to do an API that can support it, as long as
we properly define that the platform is allowed to give you less than
what you asked.

> It is hard

Not really... Heh, in fact, with those "stupid" hypervisor interfaces,
it's actually very easy :-) But even in the raw case. Really not that
hard. Easier than MSI-X in many ways.

> we can't do it on most hardware

I've seen quite a few cards who say they do more than 1 MSI and the host
hardware shouldn't matter in that area.

> and anyone who wants more than 1 irq should just implement MSI-X and everyone
> will be able to use it, on any hardware.

Sure, anyone should just implement their hardware the way the linux
folks tell them to do, too bad HW vendors don't worship us as gods and
don't take our rules as god send laws ...

> Part of the reason to not support a messed up HV interface if it hard
> is that a HV is just software.  Which means the incremental cost to
> fix it is roughly the same as fixing the linux kernel, and it puts
> the burden on the people doing stupid things not on the rest of us
> forever more.

The comparison between > 1 MSI and HV is bad here. Supporting only 1 MSI
actually still allows the HW to work. Not supporting the HV (and thus
not supporting MSIs on those machines) does not when you start hitting
hardware that doesn't do LSI (which is allowed by spec and is starting
to appear, some IB cards for example don't do LSI).

> No.  I have spent time fixing what is there, and made it work.  I see
> implementations proposed that don't handle cases I have fixed, and I
> don't see anything that resembles a simple migration path for i386,
> x86_64 and ia64.  Which is part of what annoys me when I am told
> the ops work for everything.

They potentially do, and the easy migration path is mostly to use the
existing code as a HV-type backend for x86, and then incrementally fix
our generic "raw" helpers and move bits of the x86 / old-generic-code to
it... 

That's also a nice incremental approach...
 
> As for the code not working important parts of the code (like MSI-X)
> don't even work on ppc. 
> The strength of my opposition is largely
> shaped by the number of people wearing rose colored glasses and
> ignoring the problems, and missing huge details.

Well, which is why I'd like to have a more constructive discussion on
how to address those rather than outright dismissing the approach. You
are using the fact that Michael's implementation isn't feature complete
as an argument to dismiss the entire approach. In a way, you are
commiting a layering violation in your argument :-)

However, we can't get that resolved if we still don't agree on the veric
basic premises of the direction we are taking. We need to agree on some
of the fundamentals (like having alloc/free take an array or be
per-interrupt) or agree to disagree in which case we have no choice on
our side to "finish" Michael's implementation to do all those bits it's
missing and propose it as an alternate since the main one will not
handle our needs.
 
> Given that we have been talking about things since before OLS I would
> have expected the ppc code to be a little farther along.

We have been delayed / side tracked with other things. Shit happens.

> Not the x86 backend but the raw backend.  You might not need all of
> the features because you are always going through another interrupt
> controller but that doesn't mean they shouldn't be there.

I never disagreed with that. I always said we should have most of the
missing bits added to the raw backend for x86.

> Michael has at least agreed to look in that direction so I'm hoping
> my changes remove some of the difficulty for him.

Some do, some makes it more difficult. The way you removed the
alloc/free vs. setup/teardown distinction and made the whole thing
per-interrupt makes things more difficult for us.

> Nor do I see the level of care being put into the problem that would
> cause me to trust a rewrite.  I have a huge number of little technical
> problems with the proposed code, and see absolutely no overriding
> virtue in it.  Especially when the worst of the problems with msi.c
> can be easily fixed, as demonstrated by my patchset.

Can be fixed in a way that is by design incompatible with what we need. 

How should I phrase this so you understand that's not an option for
us ? 

Ben.


