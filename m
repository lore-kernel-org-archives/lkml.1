Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbYEQDU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbYEQDU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 23:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYEQDUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 23:20:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbYEQDUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 23:20:16 -0400
Date: Fri, 16 May 2008 20:19:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <20080517015705.GA20375@mit.edu>
Message-ID: <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org> <20080517015705.GA20375@mit.edu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 May 2008, Theodore Tso wrote:
> 
> Why do you consider rebasing topic branches a bad thing?

Rebasing branches is absolutely not a bad thing for individual developers.

But it *is* a bad thing for a subsystem maintainer.

So I would heartily recommend that if you're a "random developer" and 
you're never going to have anybody really pull from you and you 
*definitely* don't want to pull from other peoples (except the ones that 
you consider to be "strictly upstream" from you!), then you should often 
plan on keeping your own set of patches as a nice linear regression.

And the best way to do that is very much by rebasing them.

That is, for example, what I do myself with all my git patches, since in 
git I'm not the maintainer, but instead send out my changes as emails to 
the git mailing list and to Junio.

So for that end-point-developer situation "git rebase" is absolutely the 
right thing to do. You can keep your patches nicely up-to-date and always 
at the top of your history, and basically use git as an efficient 
patch-queue manager that remembers *your* patches, while at the same time 
making it possible to efficiently synchronize with a distributed up-stream 
maintainer.

So doing "git fetch + git rebase" is *wonderful* if all you keep track of 
is your own patches, and nobody else ever cares until they get merged into 
somebody elses tree (and quite often, sending the patches by email is a 
common situation for this kind of workflow, rather than actually doing git 
merges at all!)

So I think 'git rebase' has been a great tool, and is absolutely worth 
knowing and using.

*BUT*. And this is a pretty big 'but'.

BUT if you're a subsystem maintainer, and other people are supposed to be 
able to pull from you, and you're supposed to merge other peoples work, 
then rebasing is a *horrible* workflow.

Why?

It's horrible for multiple reasons. The primary one being because nobody 
else can depend on your work any more. It can change at any point in time, 
so nobody but a temporary tree (like your "linux-next release of the day" 
or "-mm of the week" thing) can really pull from you sanely. Because each 
time you do a rebase, you'll pull the rug from under them, and they have 
to re-do everything they did last time they tried to track your work.

But there's a secondary reason, which is more indirect, but despite that 
perhaps even more important, at least in the long run. 

If you are a top-level maintainer or an active subsystem, like Ingo or 
Thomas are, you are a pretty central person. That means that you'd better 
be working on the *assumption* that you personally aren't actually going 
to do most of the actual coding (at least not in the long run), but that 
your work is to try to vet and merge other peoples patches rather than 
primarily to write them yourself.

And that in turn means that you're basically where I am, and where I was 
before BK, and that should tell you something. I think a lot of people 
are a lot happier with how I can take their work these days than they 
were six+ years ago.

So you can either try to drink from the firehose and inevitably be bitched 
about because you're holding something up or not giving something the 
attention it deserves, or you can try to make sure that you can let others 
help you. And you'd better select the "let other people help you", because 
otherwise you _will_ burn out. It's not a matter of "if", but of "when".

Now, this isn't a big issue for some subsystems. If you're working in a 
pretty isolated area, and you get perhaps one or two patches on average 
per day, you can happily basically work like a patch-queue, and then other 
peoples patches aren't actually all that different from your own patches, 
and you can basically just rebase and work everything by emailing patches 
around. Big deal.

But for something like the whole x86 architecture, that's not what te 
situation is. The x86 merge isn't "one or two patches per day". It easily 
gets a thousand commits or more per release. That's a LOT. It's not quite 
as much as the networking layer (counting drivers and general networking 
combined), but it's in that kind of ballpark.

And when you're in that kind of ballpark, you should at least think of 
yourself as being where I was six+ years ago before BK. You should really 
seriously try to make sure that you are *not* the single point of failure, 
and you should plan on doing git merges.

And that absolutely *requires* that you not rebase. If you rebase, the 
people down-stream from you cannot effectively work with your git tree 
directly, and you cannot merge their work and then rebase without SCREWING 
UP their work.

And I realize that the x86 tree doesn't do git merges from other 
sub-maintaines of x86 stuff, and I think that's a problem waiting to 
happen. It's not a problem as long as Ingo and Thomas are on the net every 
single day, 12 hours a day, and respond to everything. But speaking from 
experience, you can try to do that for a decade, but it won't really work.

I've talked to Ingo about this a bit, and I'm personally fairly convinced 
that part of the friction with Ingo has been that micro-management on a 
per-patch level. I should know. I used to do it myself. And I still do it, 
but now I do it only for really "core" stuff. So now I get involved in 
stuff like really core VM locking, or the whole BKL thing, but on the 
whole I try to be the anti-thesis of a micro-manager, and just pull from 
the submaintainers.

It's easier for me, but more importantly, it's actually easier for 
everybody *else*, as long as we can get the right flow working.

Which is why I still spend time on git, but even more so, why I also try 
to spend a fair amount of time on explaining flow issues like this. 
Because I want to try to get people on the same page when it comes to how 
patches flow - because that makes it easier for *everybody* in the end.

[ IOW, from my personal perspective, in the short run the easiest thing to 
  do is always "just pull".

  But in the long run, I want to know I can pull in the future too, and 
  part of that means that I try to explain what I expect from downstream, 
  but part of that also means that I try to push down-stream developers 
  into directions where I think they'll be more productive and less 
  stressed out so that they'll hopefully *be* there in the long run.

  And I think both Ingo and Thomas would be more produtive and less 
  stressed out if they could actually pull from some submaintainers of 
  their own, and try to "spread the load" a bit. It involves them finding 
  the right people they can trust, but it also involves them having a 
  workflow in place that _allows_ those kinds of people to then work with 
  them! ]

> Is there a write up of what you consider the "proper" git workflow?

See above. It really depends on where in the work-flow you are.

And it very much does depend on just how big the flow of patches is. For 
example, during 2.6.24..26, net/ and drivers/net had ~2500 commits. 
arch/x86 and include/asm-x86 had ~1300 commits. Those are both big 
numbers. We're talking a constant stream of work.

But Ted, when you look at fs/ext4, you had what, 67 commits in the 
2.6.24..25 window? That's a whole different ballgame. If you have 67 
commits in a release window of two months, we're talking roughly one a 
day, and you probably didn't have a single real conflict with anybody else 
during that whole release window, did you?

In *that* situation, you don't need to try to stream-line the merging. You 
are better off thinking of them as individual patches, and passing them 
around as emails on the ext4 mailing lists. People won't burn out from 
handling an average of one patch a day, even for long long times. Agreed?

Realistically, not many subsystems really need to try to find 
sub-sub-maintainers. Of the architectures, x86 is the most active one 
*by*far*. That said, I think PowerPC actually has a chain of maintenance 
that is better structured, in that there is more of a network of people 
who have their own areas and they pull from each other. And POWERPC only 
has about half the number commits that x86 has. I bet that lower number of 
commits, coupled with the more spread out maintenance situation makes it 
*much* more relaxed for everybody.

Networking, as mentioned, is about twice the number of patches (in 
aggregate) from x86, but the network layer too has a multi-layer 
maintenance setup, so I suspect that it's actually more relaxed about that 
*bigger* flow of commits than arch/x86 is. Of course, that's fairly 
recent: David had to change how he works, exactly so that the people who 
work with him don't have to jump through hoops in order to synchronize 
with his tree.

In other words, I very heavily would suggest that subsystem maintainers - 
at least of the bigger subsystems, really see themselves as being in the 
same situation I am: rather than doing the work, trying to make it easy 
for *others* to do the work, and then just pulling the result.

		Linus
