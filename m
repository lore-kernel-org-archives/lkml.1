Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYGVQHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYGVQHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYGVQHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:07:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbYGVQG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:06:59 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
References: <1216676595.3433.80.camel@localhost.localdomain>
	<y0mprp68zg9.fsf@ton.toronto.redhat.com>
	<1216698788.3433.116.camel@localhost.localdomain>
	<20080722115101.GB9508@redhat.com>
	<1216739683.3364.43.camel@localhost.localdomain>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 22 Jul 2008 12:05:23 -0400
In-Reply-To: <1216739683.3364.43.camel@localhost.localdomain> (James Bottomley's message of "Tue, 22 Jul 2008 10:14:43 -0500")
Message-ID: <y0mk5fd9a64.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> [...]
>> > [...]
>> > > - You disprefer systemtap's use of an established, non-deprecated API
>> > >   for placing kernel probes.  [...]
>> >
>> > You mean embedding half a megabyte of symbols simply so you can avoid
>> > the inconvenience of using a kernel API? yes, I think it's ...
>> > suboptimal.
>> 
>> It has been explained already that the symbol table you saw in
>> stap-symbols.h has nothing to do with the kprobe addressing issue.
>> [...]
>
> You're confusing issues.  I said embedding half a megabyte of symbol
> table that the kernel already has is a bad idea full stop.  

Be that as it may, but it is not appropriate to knowingly bring up a
topic that is irrelevant to the patch series you're actually proposing.


> The ultimate think I'm looking to do is to evolve kernel APIs that
> makes this practice unnecessary.

If by "this practice" you mean "stap-symbols.h tables", then you're
worrying on the wrong area of code (anything in/near kprobes).  I am
happy to suggest more appropriate areas to help with that.


>> > There is no current userspace infrastructure, since utrace still isn't
>> > in the kernel, so you're predicating this argument on an event which
>> > hasn't happened.
>> 
>> We exercise professional foresight.  And the backward compatibility
>> issue remains even without that.
>
> No ... you're trying to constrain the open source process 
> to a pre-conceived design which is unrealised by in-kernel code.

The "open source process" does not entail welcoming unnecessary changes.

> This is directly producing an impasse.

I don't recognize an impasse.  This aspect of systemtap has been
working just fine with the kernel as has been.  We are not blocked on
a resolution to the current issue.


>> [...]
>> > For instance, the obvious way to me of doing this would be to map
>> > the user space stack into the systemtap runtime and unwind it from
>> > there instead of vectoring it into the kernel.
>> 
>> Please elaborate.  What does mapping a stack into the runtime mean?
>
> It means that the systemtap runtime and the process would share a
> mapping for the process stacks Obviously the process would have to be
> quiesced to poke about in it, but it obviates the need to vector
> megabytes of stack information through the kernel.

I still don't understand.  No one has seriously proposed "vectoring
megabytes of stack information through the kernel", if by that you
mean copying it all to userspace.  Even frame-pointer-based dtrace
doesn't do that.

Accessing the process stack from systemtap modules is not the problem
in the first place: rather, it's instant access to the unwind & symbol
data needed to decode it.


>> Do you mean to suggest having the userspace program unwind itself?
>
> It's possible ... but more likely that the stap runtime would do the
> unwinding.  Which is more efficient won't really be known until someone
> actually tries coding it.

It's not just a matter of efficiency but a matter of non-disruptiveness.


>>   Or relying on the userspace programs' possibly-paged-out unwind data?
>> That would be intrusive.
>
> I think you'll find doing it in user space is an advantage for paged out
> data.  It's much more complex to get to it in the kernel because you
> have to be careful of context while you're asking for it to be paged
> back in.

We would not ask for anything to be paged back in.  That is one kind
of disruption to system state that we strain to avoid.


>> > > - I offer _stext+offset (for the kernel) and (.text*)+offset (for
>> > >   modules) kprobes [...]
>> > I thought this and subsequent emails addressed the points pretty well:
>> > http://marc.info/?l=linux-kernel&m=121632572409118
>> 
>> No, they didn't.  Every time I explained about how it does work, you
>> just claimed "not", without even a single worked-out substantiating
>> example.
>
> Really?  The mutability of _stext vs _text; the problem probing init
> sections I think they're real issues.

Then please do me the courtesy of replying to the points already made
on those items.

(Recap: we don't care whether the vmlinux reference symbol is _text or
_stext or something else.  Whatever works, and so far _stext does
everywhere we've needed it.)

For init sections in general, they are irrelevant for systemtap at
this time as kprobes blocks them, and we'd need extra kernel/module.c
infrastructure to let us hook module-loaded init-not-yet-run events
(and the corresponding exit transitions).  Once those are solved,
systemtap can trivially calculate .init addresses relative to _stext
or whatever -- and it does today!)

So, they do not appear to be real issues.


>[...]
>> We have had reported problems with differences between kernels
>> hand-built with long absolute source path names versus the smallest
>> "kernel/foo.c" names.  If such canonicalization takes place but
>> inconsistently by the different tools, we will have a problem.
>
> What it currently does is add tree relative names, so, for example this
> is a cut and paste from System.map: [...]
> There's no ambiguity about how the path is constructed.

Perhaps, as long as the dwarf-parsing side canonicalizes them the same way.


>> Even with ksymtab compression, there is still new data to be stored in
>> the kernel, and it is extra for each systemtap probe datum.
>
> I think the requirement that your huge data problem be solved at
> absolutely no cost is possibly a bit ambitious.  

What "huge data problem"?  Forget the stap-symbols.h already.


>> > > Does that still seem an acceptable cost, just to get systemtap to
>> > > change its preferred kprobes api?
>> > [no answer]
>> Indeed.
>
> Perhaps because that's the wrong question.  It's not about trying to
> change a "preferred" API (and the concept of preferred means according
> to your preset design).  

Preferred, as in working, stable, not in any way deprecated, backward
compatible -- and more.  It ain't broke and it don't need fixin'.


> It's about trying to get systemtap actually to engage with the
> kernel and iterate to an actual solution.

It is unfortunate that this technical trivium wants to turn into jabs
about "engaging with the kernel" or "constraining the open source
process" or something.  Let the idea stand on its own merits.


- FChE
