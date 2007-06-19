Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbXFSPEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbXFSPEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbXFSPEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:04:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41379 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780AbXFSPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:04:35 -0400
Date: Tue, 19 Jun 2007 08:01:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Oleg Verych <olecom@flower.upol.cz>,
       Debbugs developers <debian-debbugs@lists.debian.org>,
       Martin Bligh <mbligh@mbligh.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
In-Reply-To: <20070619124855.GB12950@stusta.de>
Message-ID: <alpine.LFD.0.98.0706190732150.3593@woody.linux-foundation.org>
References: <200706172349.08813.bzolnier@gmail.com> <4675C083.6080409@s5r6.in-berlin.de>
 <20070617220927.99ebc1ee.akpm@linux-foundation.org>
 <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca>
 <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com>
 <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>
 <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org>
 <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Jun 2007, Adrian Bunk wrote:
> 
> The goal is to get all patches for a maintained subsystem submitted to 
> Linus by the maintainer.

Well, to be honest, I've actually over the years tried to have a policy of 
*never* really having black-and-white policies.

The fact is, some maintainers are excellent. All the relevant patches 
*already* effectively go through them.

But at the same time, other maintainers are less than active, and some 
areas aren't clearly maintained at all. 

Also, being a maintainer often means that you are busy and spend a lot of 
time talking to *people* - it doesn't necessarily mean that you actually 
have the hardware and can test things, nor does it necessarily mean that 
you know every detail. 

So I point out in Documentation/ManagementStyle (which is written very 
much tongue-in-cheek, but at the same time it's really *true*) that 
maintainership is often about recognizing people who just know *better* 
than you!

> The -mm kernel already implements what your proposed PTS would do.
> 
> Plus it gives testers more or less all patches currently pending 
> inclusion into Linus' tree in one kernel they can test.
> 
> The problem are more social problems like patches Andrew has never heard 
> of before getting into Linus' tree during the merge window.

Not really. The "problem" boils down to this:

	[torvalds@woody linux]$ git-rev-list --all --since=100.days.ago | wc -l
	7147
	[torvalds@woody linux]$ git-rev-list --no-merges --all --since=100.days.ago | wc -l
	6768

ie over the last hundred days, we have averaged over 70 changes per day, 
and even ignoring merges and only looking at "pure patches" we have more 
than an average of 65 patches per day. Every day. Day in and day out.

That translates to five hundred commits a week, two _thousand_ commits per 
month, and 25 thousand commits per year. As a fairly constant stream.

Will mistakes happen? Hell *yes*. 

And I'd argue that any flow that tries to "guarantee" that mistakes don't 
happen is broken. It's a sure-fire way to just frustrate people, simply 
because it assumes a level of perfection in maintainers and developers 
that isn't possible.

The accepted industry standard for bug counts is basically one bug per a 
thousand lines of code. And that's for released, *debugged* code. 

Yes, we should aim higher. Obviously. Let's say that we aim for 0.1 bugs 
per KLOC, and that we actually aim for that not just in _released_ code, 
but in patches.

What does that mean?

Do the math:

	git log -M -p --all --since=100.days.ago | grep '^+' | wc -l

That basically takes the last one hundred days of development, shows it 
all as patches, and just counts the "new" lines. It takes about ten 
seconds to run, and returns 517252 for me right now.

That's *over*half*a*million* lines added or changed!

And even with the expectation that we do ten times better than what is 
often quoted as an industry average, and even with the expectation that 
this is already fully debugged code, that's at least 50 bugs in the last 
one hundred days.

Yeah, we can be even more stringent, and actually subtract the number of 
lines _removed_ (274930), and assume that only *new* code contains bugs, 
and that's still just under a quarter million purely *added* lines, and 
maybe we'd expect just new 24 bugs in the last 100 days.

[ Argument: some of the old code also contained bugs, so the lines added 
  to replace it balance out. Counter-argument: new code is less well 
  tested by *definition* than old code, so.. Counter-counter-argument: the 
  new code was often added to _fix_ a bug, so the code removed had an even 
  _higher_ bug rate than normal code.. 

  End result? We don't know. This is all just food for thought. ]

So here's the deal: even by the most *stringent* reasonable rules, we add 
a new bug every four days. That's just something that people need to 
accept. The people who say "we must never introduce a regression" aren't 
living on planet earth, they are living in some wonderful world of 
Blarney, where mistakes don't happen, developers are perfect, hardware is 
perfect, and maintainers always catch things.

> The problem is that most problems don't occur on one well-defined 
> kind of hardware - patches often break in exactly the areas the patch
> author expected no problems in.

Note that the industry-standard 1-bug-per-kloc thing has nothing to do 
with hardware. Somebody earlier in this thread (or one of the related 
ones) said that "git bisect is only valid for bugs that happen due to 
hardware issues", which is just totally *ludicrous*.

Yes, hardware makes it harder to test, but even *without* any hardware- 
specific issues, bugs happen. The developer just didn't happen to trigger 
the condition, or didn't happen to notice it when he *did* trigger it.

So don't go overboard about "hardware". Yes, hardware-specific issues have 
their own set of problems, and yes, drivers have a much higher incidence 
of bugs per KLOC, but in the end, even *without* that, you'd still have to 
face the music. Even for stuff that isn't drivers.

So this whole *notion* that you can get it right the first time is 
*insane*.

We should aim for doing well, yes.

But quite frankly, anybody who aims for "perfect" without taking reality 
into account is just not realistic. And if that's part of the goal of some 
"new process", then I'm not even interested in listening to people discuss 
it.

If this plan cannot take reality into account, please stop Cc'ing me. I'm 
simply not interested.

Any process that tries to "guarantee" that regressions don't happen is 
crap. Any process that tries to "guarantee" that we release only kernels 
without bugs can go screw itself. There's one thing I _can_ guarantee, and 
that's as long as we add a quarter million new lines per 100 days (and 
change another quarter million lines), we will have new bugs.

No ifs, buts or maybe's about it.

The process should aim for making them *fewer*. But any process that aims 
for total eradication of new bugs will result in one thing, and one thign 
only: we won't be getting any actual work done.

The only way to guarantee no regressions is to make no progress.

		Linus
