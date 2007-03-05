Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbXCEWFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbXCEWFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXCEWFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:05:24 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:39893 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXCEWFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:05:20 -0500
X-IronPort-AV: i="4.14,251,1170651600"; 
   d="scan'208"; a="23619317:sNHT27803286"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Paul Mundt" <lethal@linux-sh.org>
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Date: Mon, 5 Mar 2007 17:06:10 -0500
User-Agent: KMail/1.9.5
Cc: "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Wu, Bryan" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <200703051129.19234.rgetz@blackfin.uclinux.org> <20070305173214.GA15800@linux-sh.org>
In-Reply-To: <20070305173214.GA15800@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051706.11115.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 05 Mar 2007 22:05:14.0712 (UTC) FILETIME=[5A2C6D80:01C75F72]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 5 Mar 2007 12:32, Paul Mundt pondered:
> On Mon, Mar 05, 2007 at 11:29:19AM -0500, Robin Getz wrote:
> > On Mon 5 Mar 2007 09:00, Paul Mundt pondered:
> > > Throwing this all at the user simply shows that the functions being
> > > relocated haven't been profiled adequately with real workloads.
> >
> > Actually - that is not true at all - we have profiled these
> > extensively
> > across many workloads on various real world applications from fax
> > machine to bar code scanner, to software radio, to internet radio -
> > and that is the point - it all depends on what the user
> > application/drivers
> > that are loaded are doing. I can't decided what is best for the user,
> > because I don't know what they are doing.
>
> And there are just as many cases that are common regardless of the
> workload that are simply good decisions. Exception vectors are a good
> example, either you get a boost from having them in L1 memory or you
> don't, the workload really doesn't matter.

Then you have not profiled the same applications I have. I see different 
results in on this platform.

> Workloads will of course have variations, but it's optimizing the hot
> paths that end up being quite common that end up being the most useful.
> These are not things that should be required from the end user.

The end user is the only one who knows what is work load is.

> > > If a user wants to use on-chip memory, presumably they have a target
> > > application in mind, and they know how much space they need. Beyond
> > > that, they expect the kernel to do the best it can with the space
> > > that's left over for it to play with.
> >
> > And that is the problem - the kernel doesn't know how much on chip
> > memory an application which will be loaded in the future might need.
> > The user needs to be able to control the amount of on-chip memory 
> > that the kernel uses - hence the knobs.
>
> That's crap, for the exact reason that these are not run-time
> configurable knobs, they are static build-time components. If a user has
> to scale back the kernel users until their application fits, then they
> already know how much space they're going to need. Once you know that,
> reserving a chunk for userspace and limiting the kernel's usage is quite
> simple.

OK - you want me to remove 14 selections (yeah - I agree that is alot), and 
replace them with one selection, and a header file, that the user has to 
maintain separately from the .config, which everyone does already? IMHO - 
that is harder for an end user to maintain than our existing proposal.

> > > If a user has to sit around profiling their workload to
> > > figure out what config options to set to chew through the rest of
> > > the L1 memory, you've completely lost at intuitive design.
> >
> > Embedded has never been intuitive.
>
> Embedded has also never been about throwing everything at the user
> that's possible. Flexibility is good. Intelligent design is good.
> Blindly tossing everything the user's way and hoping for the best 
> is not. 

default settings? 

Hope is not a strategy that we use. Careful design is (most of the time).

> > Normally, the majority of end users leave things set by the default,
> > meaning their application doesn't use the on-chip memory, and the
> > kernel is allowed to. If they want to start using on-chip memory,
> > they are forced to do a re-compile, with the kernel functions
> > using off-chip memory, and see how much of on-chip memory 
> > their application uses. They calculate the difference, and
> > do a little system level profiling, and put the most used kernel
> > functions back.
>
> Yes, precisely. This is all something that should be done by the kernel
> _for_ the user. They can of course add their own instrumentation to the
> hot paths that their workload hits that aren't generally handled, but
> this should not be a required step.
>
> If I'm working on an embedded application, I expect my kernel to do some
> sensible things with the hardware available. I don't want to have to
> manually configure ever possible thing in order to get a system that
> behaves in a reasonable manner, and I certainly don't want to have to do
> this multiple times with a profiler for paths that are inevitably going
> to be quite common anyways.

People do all kinds of things to make their application work better on a 
processor that cost less than lunch for one person.

The applications always work without system level tuning - but they can work 
up to 2x faster with a little performance tweaking. To most people, spending 
the day or two - doing the tweaking to get max performance that the chip is 
capable of is worth the effort.

> > You are asking me to try to decide what is best for all the potential
> > end users, with out knowing what the end user is doing. What ends up
> > happening is that people make modifications (normally poor ones) and
> > then still ask for help when their modifications break.
>
> No, I'm asking you to set some sensible defaults, provide an interface
> that works for the common cases, and allow the special cases to remain
> simply that.

In my opinion - that is what we have.

> > I would rather give them a supported (but arguablely confusing) method
> > of customisation. (This is why it was added - end users were asking for
> > it, and when we didn't have it, they would try to make the 
> > modifications themselves, break it, and report a bug. After telling
> > 8 different people the same thing,
>>
> There's also a substantial differences between what customers are
> telling
> you they want, what they're trying to accomplish, and what they actually
> need. If you want to add something simple, setup an attribute tag for
> the
> section and tell the customers to flag the cases they're most concerned
> with. Obviously you expect them to be sitting there with a profiler open
> anyways, so this should not be a problem.

This is what people do today (without our proposal). This is what was causing 
all the problems. This is what we are trying to avoid.

> Also note that we are not required to accept bad code in the kernel
> because you happen to have customer requirements for it.

I am not asking you to accept bad code. I'm trying to explain why we came to a 
specific design decision, and went down a specific path, after thinking about 
and a similar idea as your suggestion.

> The point is, doing this as a config option design is just broken. It
> doesn't scale for new code, and it doesn't scale as soon as you start
> throwing in more blocks of SRAM with varying locality, latencies, etc.
> Littering around ifdefs for this stuff all over the code is equally
> ugly.

It is equally bad to force end users to maintain a patch set, to change around 
our best guess of what their fast paths might be in a .h file.

> I'll reiterate my original suggestion, allow the user to cap the amount
> of memory that's used by the kernel, then add something akin to initcall
> levels that you can use for prioritizing items to be relocated in
> on-chip memory, while spilling the rest to RAM. With this sort of scheme
> you can also trivially spill in to additional SRAM pools and whatever 
> else you have handy as you go along.

I don't understand how this is radically different than what we have today. 
You are suggesting that we take the knobs that are easy to modify, and hide 
them, to create pain for a user who wants to/needs to use them. I don't think 
this is good design either.

> You can of course argue that as an embedded platform the user must make
> all of these decisions on their own, but there can be a compromise if
> the kernel's at least half-way intelligent about matters.

I guess it is an disagreement in overall design philosophy - I thought the 
kernel was suppost to be flexible enough to handle the corner cases, and 
robust enough to ensure proper operation in all cases. What we are attempting 
to do (maybe poorly - jury is still out), is continue to add flexibility, 
putting the burden on us - the maintainers of all the files where the #ifdefs 
exist (all in arch/blackfin or include/asm-blackfin), to make it easier (both 
from use and maintenance) on end users.

If your disagreement is - this doesn't make it easier, it makes it harder - 
then OK - but I don't think moving the controls somewhere else makes it 
easier. Plus I am not sure how I would explain things - "there are n levels 
of prioritizing if a function will be in slow or fast SRAM. Setting things to 
the highest priority may not mean it will go in the fastest SRAM, and you 
won't know until runtime, when your application doesn't run as fast as it 
should or by digging through the map file and looking at the address of the 
function".

This is a worst case explanation, and I am sure that you could think of 
something better. I tend to be negative.

What we have today - is a switch (not a knob). If you select too much, link 
fails. There is no "spill over" - by design. It is in on-chip SRAM, or not.

> While it may not count for much, until something is done about this and
> the other issues that were raised earlier in the thread, I'd have to NAK
> this patch. If not wanting to manually select everything that goes in to
> L1 memory makes me too unsophisticated by blackfin standards, so be it
> ;-)

It's not that we don't appreciate the thoughts and time that you have looking 
into this - we do and Thanks - I guess I would rather have something that:
 - hard failure, rather than soft failure. (it works, or it doesn't boot)
 - is maintained in .config file

We are all about worrying about good design, proper code, and future 
maintenance/extendability. I think that this specific part of the patch meet 
those goals.

As for the other pieces of the patch, that you pointed out - most need to be 
fixed per your comments. Thanks again for the time.

-Robin
